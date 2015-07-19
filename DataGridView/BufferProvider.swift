//
//  BufferProvider.swift
//  HelloMetal
//
//  Created by Andrew  K. on 4/10/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit

class BufferProvider: NSObject {

    let inflightBuffersCount: Int
    private var uniformsBuffers: [MTLBuffer]
    private var avaliableBufferIndex: Int = 0
    var avaliableResourcesSemaphore:dispatch_semaphore_t
    
    init(device:MTLDevice, inflightBuffersCount: Int, sizeOfUniformsBuffer: Int) {
        
        avaliableResourcesSemaphore = dispatch_semaphore_create(inflightBuffersCount)
        
        self.inflightBuffersCount = inflightBuffersCount
        uniformsBuffers = [MTLBuffer]()
        
        for i in 0...inflightBuffersCount-1{
            var uniformsBuffer = device.newBufferWithLength(sizeOfUniformsBuffer, options: nil)
            uniformsBuffers.append(uniformsBuffer)
        }
    }
    
    deinit{
        for i in 0...self.inflightBuffersCount {
            dispatch_semaphore_signal(self.avaliableResourcesSemaphore)
        }
    }
    
    func nextUniformsBuffer(projectionMatrix: Matrix4, modelViewMatrix: Matrix4) -> MTLBuffer {
        
        var buffer = uniformsBuffers[avaliableBufferIndex]
        var bufferPointer = buffer.contents()
        
        memcpy(bufferPointer, modelViewMatrix.raw(), sizeof(Float)*Matrix4.numberOfElements())
        memcpy(bufferPointer + sizeof(Float)*Matrix4.numberOfElements(), projectionMatrix.raw(), sizeof(Float)*Matrix4.numberOfElements())
        
        avaliableBufferIndex++
        if avaliableBufferIndex == inflightBuffersCount{
            avaliableBufferIndex = 0
        } 
        
        return buffer
    }
}
