//
//  CameraNode.swift
//  Designer
//
//  Created by Morgan Wilde on 09/05/2015.
//  Copyright (c) 2015 Morgan Wilde. All rights reserved.
//

import Foundation
import SceneKit

class CameraNode: SCNNode {
    
    struct Constants {
        static let perspectiveAngleX: Float = 135 * PI/180
        static let perspectiveAngleY: Float = 0 * PI/180
        static let perspectiveAngleZ: Float = 60 * PI/180
    }
    
    override init() {
        super.init()
        
        // Calculate perspective
        let perspectiveRotationX = SCNMatrix4MakeRotation(Constants.perspectiveAngleX, 1, 0, 0)
        let perspectiveRotationY = SCNMatrix4MakeRotation(Constants.perspectiveAngleY, 0, 1, 0)
        let perspectiveRotationZ = SCNMatrix4MakeRotation(Constants.perspectiveAngleZ, 0, 0, 1)
        transform = SCNMatrix4Mult(SCNMatrix4Mult(perspectiveRotationX, perspectiveRotationY) , perspectiveRotationZ)
        
        // Set camera properties
        camera = SCNCamera()
        camera!.zNear = -100
        camera!.zFar = 100
        camera!.orthographicScale = 10
        camera!.usesOrthographicProjection = true
        
        name = "cameraNode"
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}