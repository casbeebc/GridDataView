//
//  Triangle.swift
//  DataGridView
//
//  Created by brett on 7/18/15.
//  Copyright (c) 2015 DataMingle. All rights reserved.
//

import Foundation
import Metal

class Triangle: Node {
    
    init(device: MTLDevice){
        
        let V0 = Vertex(x:  0.0, y:   1.0, z:   0.0, r:  1.0, g:  0.0, b:  0.0, a:  1.0, s:0.0, t:0.0)
        let V1 = Vertex(x: -1.0, y:  -1.0, z:   0.0, r:  0.0, g:  1.0, b:  0.0, a:  1.0, s:0.0, t:0.0)
        let V2 = Vertex(x:  1.0, y:  -1.0, z:   0.0, r:  0.0, g:  0.0, b:  1.0, a:  1.0, s:0.0, t:0.0)
        
        var verticesArray = [V0,V1,V2]
        super.init(name: "Triangle", vertices: verticesArray, device: device, texture:nil)
    }
    
}

