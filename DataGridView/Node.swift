//
//  Node.swift
//  HelloMetal
//
//  Created by Andrew K. on 10/23/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import Foundation
import Metal
import QuartzCore

class Node {
    
    var time:CFTimeInterval = 0.0
    
    let name: String
    var vertexCount: Int
    var vertexBuffer: MTLBuffer
    var device: MTLDevice
    
    var positionX:Float = 0.0
    var positionY:Float = 0.0
    var positionZ:Float = 0.0
    
    var rotationX:Float = 0.0
    var rotationY:Float = 0.0
    var rotationZ:Float = 0.0
    var scale:Float     = 1.0
    
    var bufferProvider: BufferProvider
    var texture: MTLTexture?
    lazy var samplerState: MTLSamplerState? = Node.defaultSampler(self.device)
    
    init(name: String, vertices: Array<Vertex>, device: MTLDevice, texture: MTLTexture?) {
        
        var vertexData = Array<Float>()
        for vertex in vertices{
            vertexData += vertex.floatBuffer()
        }
        
        let dataSize = vertexData.count * sizeofValue(vertexData[0])
        vertexBuffer = device.newBufferWithBytes(vertexData, length: dataSize, options: nil)
        
        self.name = name
        self.device = device
        vertexCount = vertices.count
        self.texture = texture
        
        self.bufferProvider = BufferProvider(device: device, inflightBuffersCount: 3, sizeOfUniformsBuffer: sizeof(Float) * Matrix4.numberOfElements() * 2)
    }
    
    func render(commandQueue: MTLCommandQueue, pipelineState: MTLRenderPipelineState, drawable: CAMetalDrawable, parentModelViewMatrix: Matrix4, projectionMatrix: Matrix4, clearColor: MTLClearColor?){
        
        dispatch_semaphore_wait(bufferProvider.avaliableResourcesSemaphore, DISPATCH_TIME_FOREVER)
        
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .Clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 104.0/255.0, blue: 5.0/255.0, alpha: 1.0)
        renderPassDescriptor.colorAttachments[0].storeAction = .Store
        
        let commandBuffer = commandQueue.commandBuffer()
        commandBuffer.addCompletedHandler { (commandBuffer) -> Void in
            var temp = dispatch_semaphore_signal(self.bufferProvider.avaliableResourcesSemaphore)
        }
        
        let renderEncoderOpt = commandBuffer.renderCommandEncoderWithDescriptor(renderPassDescriptor)
        if let renderEncoder = renderEncoderOpt {
            //For now cull mode is used instead of depth buffer
            renderEncoder.setCullMode(MTLCullMode.Front)
            
            renderEncoder.setRenderPipelineState(pipelineState)
            renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, atIndex: 0)
            if let texture = self.texture {
                renderEncoder.setFragmentTexture(texture, atIndex: 0)
            }

            if let samplerState = samplerState{
                renderEncoder.setFragmentSamplerState(samplerState, atIndex: 0)
            }
            
            var nodeModelMatrix = self.modelMatrix()
            nodeModelMatrix.multiplyLeft(parentModelViewMatrix)
            
            let uniformBuffer = bufferProvider.nextUniformsBuffer(projectionMatrix, modelViewMatrix: nodeModelMatrix)
            
            renderEncoder.setVertexBuffer(uniformBuffer, offset: 0, atIndex: 1)
            renderEncoder.drawPrimitives(.Triangle, vertexStart: 0, vertexCount: vertexCount)
            renderEncoder.endEncoding()
        }
        
        commandBuffer.presentDrawable(drawable)
        commandBuffer.commit()
    }
    
    func modelMatrix() -> Matrix4 {
        var matrix = Matrix4()
        matrix.translate(positionX, y: positionY, z: positionZ)
        matrix.rotateAroundX(rotationX, y: rotationY, z: rotationZ)
        matrix.scale(scale, y: scale, z: scale)
        return matrix
    }
    
    func updateWithDelta(delta: CFTimeInterval){
        time += delta
    }
    
    class func defaultSampler(device: MTLDevice) -> MTLSamplerState
    {
        var pSamplerDescriptor:MTLSamplerDescriptor? = MTLSamplerDescriptor();
        
        if let sampler = pSamplerDescriptor
        {
            sampler.minFilter             = MTLSamplerMinMagFilter.Nearest
            sampler.magFilter             = MTLSamplerMinMagFilter.Nearest
            sampler.mipFilter             = MTLSamplerMipFilter.Nearest
            sampler.maxAnisotropy         = 1
            sampler.sAddressMode          = MTLSamplerAddressMode.ClampToEdge
            sampler.tAddressMode          = MTLSamplerAddressMode.ClampToEdge
            sampler.rAddressMode          = MTLSamplerAddressMode.ClampToEdge
            sampler.normalizedCoordinates = true
            sampler.lodMinClamp           = 0
            sampler.lodMaxClamp           = FLT_MAX
        }
        else
        {
            println(">> ERROR: Failed creating a sampler descriptor!")
        }
        return device.newSamplerStateWithDescriptor(pSamplerDescriptor!)
    }
}
