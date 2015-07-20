//
//  ViewController.swift
//  DataGridView
//
//  Created by brett on 7/18/15.
//  Copyright (c) 2015 DataMingle. All rights reserved.
//

import UIKit

class ViewController: MetalViewController, MetalViewControllerDelegate  {
    
    var worldModelMatrix:Matrix4!
    var objectToDraw: Cube!
    
    let panSensivity:Float = 5.0
    var lastPanLocation: CGPoint!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        worldModelMatrix = Matrix4()
        worldModelMatrix.translate(0.0, y: 0.0, z: -4)
        worldModelMatrix.rotateAroundX(Matrix4.degreesToRad(25), y: 0.0, z: 0.0)
        
        objectToDraw = Cube(device: device, commandQ:commandQueue)
        self.metalViewControllerDelegate = self
        
        setupGestures()
    }
    
    
    /*
     * MetalViewControllerDelegate functions
     */
    func renderObjects(drawable:CAMetalDrawable) {
        
        objectToDraw.render(commandQueue, pipelineState: pipelineState, drawable: drawable, parentModelViewMatrix: worldModelMatrix, projectionMatrix: projectionMatrix, clearColor: nil)
        
    }
    
    func updateLogic(timeSinceLastUpdate: CFTimeInterval) {
        
        objectToDraw.updateWithDelta(timeSinceLastUpdate)
        
    }
    
    /*
     * Gesture related functions
     */
    
    func setupGestures() {
        var pan = UIPanGestureRecognizer(target: self, action: Selector("pan:"))
        self.view.addGestureRecognizer(pan)
    }
    
    func pan(panGesture: UIPanGestureRecognizer) {
        
        if panGesture.state == UIGestureRecognizerState.Changed {
            
            var pointInView = panGesture.locationInView(self.view)
            var xDelta = Float((lastPanLocation.x - pointInView.x)/self.view.bounds.width) * panSensivity
            var yDelta = Float((lastPanLocation.y - pointInView.y)/self.view.bounds.height) * panSensivity
            
            objectToDraw.rotationY -= xDelta
            objectToDraw.rotationX -= yDelta
            lastPanLocation = pointInView
            
        } else if panGesture.state == UIGestureRecognizerState.Began{
            
            lastPanLocation = panGesture.locationInView(self.view)
            
        }
        
    }

}

