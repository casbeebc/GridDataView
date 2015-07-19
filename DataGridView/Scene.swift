//
//  Scene.swift
//  DataGridView
//
//  Created by brett on 7/18/15.
//  Copyright (c) 2015 DataMingle. All rights reserved.
//
import UIKit

class Scene: Node {
    /*
    
    var avaliableUniformBuffers: dispatch_semaphore_t?
    
    var width: Float = 0.0
    var height: Float = 0.0
    
    let perspectiveAngleRad: Float = Matrix4.degreesToRad(85.0)
    var sceneOffsetZ: Float = 0.0
    
    //    var projectionMatrix: AnyObject
    
    init(name: String, baseEffect: BaseEffect, width: Float, height: Float)
    {
        self.width = width
        self.height = height
        
        sceneOffsetZ = (height * 0.5) / tanf(perspectiveAngleRad * 0.5)
        var ratio: Float = Float(width) / Float(height)
        
        
        baseEffect.projectionMatrix = Matrix4.makePerspectiveViewAngle(perspectiveAngleRad, aspectRatio: ratio, nearZ: 0.1, farZ: 10.5*sceneOffsetZ)
        
        super.init(name: name, baseEffect: baseEffect, vertices: nil, vertexCount: 0, textureName: nil)
        
        positionZ = -1*sceneOffsetZ
    }
    
    func prepareToDraw()
    {
        var numberOfUniformBuffersToUse = 3*self.numberOfSiblings
        println("bufs \(numberOfUniformBuffersToUse)")
        avaliableUniformBuffers = dispatch_semaphore_create(numberOfUniformBuffersToUse)
        self.uniformBufferProvider = UniformsBufferGenerator(numberOfInflightBuffers: CInt(numberOfUniformBuffersToUse), withDevice: baseEffect.device)
        
    }
    
    func render(commandQueue: MTLCommandQueue, metalView: MetalView, parentMVMatrix: AnyObject)
    {
        
        var parentModelViewMatrix: Matrix4 = parentMVMatrix as! Matrix4
        var myModelViewMatrix: Matrix4 = modelMatrix() as! Matrix4
        myModelViewMatrix.multiplyLeft(parentModelViewMatrix)
        var projectionMatrix: Matrix4 = baseEffect.projectionMatrix as! Matrix4
        
        
        //We are using 3 uniform buffers, we need to wait in case CPU wants to write in first uniform buffer, while GPU is still using it (case when GPU is 2 frames ahead CPU)
        dispatch_semaphore_wait(avaliableUniformBuffers!, DISPATCH_TIME_FOREVER)
        
        
        var renderPathDescriptor = metalView.frameBuffer.renderPassDescriptor
        var commandBuffer = commandQueue.commandBuffer()
        commandBuffer.addCompletedHandler(
            {
                (buffer:MTLCommandBuffer!) -> Void in
                var q = dispatch_semaphore_signal(self.avaliableUniformBuffers!)
        })
        
        
        var shouldEndEncodingOnLastChild = vertexCount <= 0
        var commandEncoder: MTLRenderCommandEncoder? = nil
        
        for var i = 0; i < children.count; i++
        {
            var child = children[i]
            var lastChild = i == children.count - 1
            commandEncoder = renderNode(child, parentMatrix: myModelViewMatrix, projectionMatrix: projectionMatrix, renderPassDescriptor: renderPathDescriptor, commandBuffer: commandBuffer, encoder: commandEncoder, uniformProvider: uniformBufferProvider)
        }
        
        if let drawableAnyObject = metalView.frameBuffer.currentDrawable
        {
            commandBuffer.presentDrawable(drawableAnyObject);
        }
        
        commandEncoder?.endEncoding()
        
        // Commit commandBuffer to his commandQueue in which he will be executed after commands before him in queue
        commandBuffer.commit();
    }
    */
}