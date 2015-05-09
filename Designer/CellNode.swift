//
//  CellNode.swift
//  Designer
//
//  Created by Morgan Wilde on 09/05/2015.
//  Copyright (c) 2015 Morgan Wilde. All rights reserved.
//

import Foundation
import SceneKit

class CellNode: SCNNode {
    
    struct Constants {
        static let WIDTH: CGFloat  = 2
        static let HEIGHT: CGFloat = 2
        static let DEPTH: CGFloat = 0.5
        static let DECORATION_INSET_SIZE: CGFloat = 0.1
        static let DECORATION_DEPTH: CGFloat = 0.1
        static let LIGHT_DISTANCE: Float = 1
    }
    
    override init() {
        super.init()
        
        // The main slab
        let baseGeometry = SCNBox(width: Constants.WIDTH, height: Constants.HEIGHT, length: Constants.DEPTH, chamferRadius: 0)
        let baseNode = SCNNode(geometry: baseGeometry)
        
        // The decorative peace on top
        let decorationGeometry = SCNBox(
            width: baseGeometry.width - Constants.DECORATION_INSET_SIZE*2,
            height: baseGeometry.height - Constants.DECORATION_INSET_SIZE*2,
            length: Constants.DECORATION_DEPTH,
            chamferRadius: 0)
        let decorationNode = SCNNode(geometry: decorationGeometry)
        decorationNode.position = SCNVector3(
            x: 0,
            y: 0,
            z: Float(baseGeometry.length/2 + Constants.DECORATION_DEPTH/2))
        
        // Hierarchy
        baseNode.addChildNode(decorationNode)
        addChildNode(baseNode)
    }
    
    func turnOnLight() {
        // Create the light
        let light = SCNLight()
        light.type = SCNLightTypeOmni
        light.color = UIColor.whiteColor()
        light.spotInnerAngle = 10
        light.spotOuterAngle = 30
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(
            x: 0,
            y: 0,
            z: Float(Constants.DEPTH/2) + Constants.LIGHT_DISTANCE)
        
        // Add it
        addChildNode(lightNode)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}