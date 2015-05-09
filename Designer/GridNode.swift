//
//  GridNode.swift
//  Designer
//
//  Created by Morgan Wilde on 09/05/2015.
//  Copyright (c) 2015 Morgan Wilde. All rights reserved.
//

import Foundation
import SceneKit

class GridNode: SCNNode {
    
    let width: Int
    let height: Int
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        
        super.init()
        
        let cellWidth = Float(CellNode.Constants.WIDTH)
        let cellHeight = Float(CellNode.Constants.HEIGHT)
        
        for var v = 0; v < height; v++ {
            for var h = 0; h < width; h++ {
                let cellNode = CellNode()
                cellNode.position = SCNVector3(
                    x: Float(h) * cellWidth + cellWidth/2,
                    y: Float(v) * cellHeight + cellHeight/2 - Float(height)/2 * cellHeight,
                    z: 0)
                
                self.addChildNode(cellNode)
            }
        }
    }
    
    func putNodeOnCellAt(node: SCNNode, x: Int, y: Int) {
        let cell = cellNodeAt(x, y: y)
        let nodeGeometry = node.geometry as! SCNBox
        let nodeOffsetY = (nodeGeometry.length + CellNode.Constants.DEPTH + CellNode.Constants.DECORATION_DEPTH) / 2
        node.position = SCNVector3(x: 0, y: 0, z: Float(nodeOffsetY))
        cell.addChildNode(node)
        
    }
    
    func turnOnLightForCell(x: Int, y: Int) {
        cellNodeAt(x, y: y).turnOnLight()
    }
    
    func cellNodeAt(x: Int, y: Int) -> CellNode {
        let coordinate = y * width + x
        return childNodes[coordinate] as! CellNode
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}