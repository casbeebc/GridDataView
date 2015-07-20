//
//  MetalViewControllerDelegate.swift
//  DataGridView
//
//  Created by brett on 7/19/15.
//  Copyright (c) 2015 DataMingle. All rights reserved.
//

import UIKit
import Metal
import QuartzCore

protocol MetalViewControllerDelegate : class {
    
    func updateLogic(timeSinceLastUpdate:CFTimeInterval)
    func renderObjects(drawable:CAMetalDrawable)
    
}