//
//  ViewController.swift
//  Designer
//
//  Created by Morgan Wilde on 26/04/2015.
//  Copyright (c) 2015 Morgan Wilde. All rights reserved.
//

import UIKit
import SceneKit

let PI = Float(M_PI_2)

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Scene view setup
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = true
        
        let scene = SCNScene()
        let rootNode = scene.rootNode
        
        // Grid
        let gridNode = GridNode(width: 10, height: 6)
        rootNode.addChildNode(gridNode)
        
        // Turn on lights
//        gridNode.turnOnLightForCell(0, y: 0)
        gridNode.turnOnLightForCell(0, y: 5)
        gridNode.turnOnLightForCell(9, y: 0)
        gridNode.turnOnLightForCell(9, y: 5)
        
        // Test adding boxes to the grid
        let node1 = SCNNode(geometry: SCNBox(width: 1, height: 1, length: 2, chamferRadius: 0))
        let node2 = SCNNode(geometry: SCNBox(width: 1, height: 1, length: 2, chamferRadius: 0))
        gridNode.putNodeOnCellAt(node1, x: 0, y: 0)
        gridNode.putNodeOnCellAt(node2, x: 4, y: 0)
        
        // Camera
        rootNode.addChildNode(CameraNode())
        
        sceneView.scene = scene
        
//        // Geometry
//        let boxGeometry = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
//        let interpreter = GeometryInterpreter(geometry: boxGeometry)
//        println(interpreter.vertexSources)
//        println(interpreter.normalSources)
//        println(interpreter.colorSources)
//        println(interpreter.textureSources)
//        println(interpreter.vertexCreaseSources)
//        println(interpreter.edgeCreaseSources)
//        println(interpreter.boneWeightsSources)
//        println(interpreter.boneIndicesSources)
//        
//        let pointGeometry = interpreter.makeGeometry()
//        let pointNode = SCNNode(geometry: pointGeometry)
//        pointNode.geometry?.firstMaterial = SCNMaterial()
//        pointNode.geometry?.firstMaterial?.doubleSided = false
//        //rootNode.addChildNode(pointNode)
//        
//        let spheres = interpreter.makeSpheres()
//        var index = 0
//        for sphere in spheres {
//            let material = SCNMaterial()
//            material.diffuse.contents = UIColor.orangeColor()
//            
//            // Assign it to the node
//            sphere.geometry?.firstMaterial = material
//            rootNode.addChildNode(sphere)
//            index++
////            if index == 5 {
////                break
////            }
//        }
//        println("boxes: \(index)")
//        
////        // Geometry element
////        let boxGeometryElement = boxGeometry.geometryElementAtIndex(0)
////        println(boxGeometryElement?.primitiveType == .Triangles)
////        println(boxGeometryElement?.primitiveType == .TriangleStrip)
////        println(boxGeometryElement?.primitiveType == .Line)
////        println(boxGeometryElement?.primitiveType == .Point)
////        println(boxGeometryElement!.primitiveCount)
////        let numberOfTriangles = boxGeometryElement!.primitiveCount
////        let numberOfVertices = numberOfTriangles * 3
////        println("numberOfVertices: \(numberOfVertices)")
////        
////        // Geometry source
////        let boxGeometrySources = boxGeometry.geometrySourcesForSemantic(SCNGeometrySourceSemanticVertex)
////        let boxGeometrySource = boxGeometrySources![0] as! SCNGeometrySource
////        
////        println(boxGeometrySource.vectorCount)
////        println(boxGeometrySource.floatComponents)
////        println(boxGeometrySource.componentsPerVector)
////        println(boxGeometrySource.bytesPerComponent)
////        println(boxGeometrySource.dataOffset)
////        println(boxGeometrySource.dataStride)
////        
////        //let componentCount = boxGeometrySource.vectorCount * boxGeometrySource.componentsPerVector
////        let componentCount = boxGeometrySource.data!.length / sizeof(Float)
////        var components = [Float](count: componentCount, repeatedValue: 0)
////        boxGeometrySource.data!.getBytes(&components, length: boxGeometrySource.data!.length)
////        
////        println("components.count: \(components.count)")
////        for var index = 0; index < components.count; {
////            let vector = SCNVector3(
////                x: components[index + 0],
////                y: components[index + 1],
////                z: components[index + 2])
////            
////            //println("(\(vector.x), \(vector.y), \(vector.z))")
////            index += 3
////        }
//        
//        let boxMaterial = SCNMaterial()
//        boxMaterial.diffuse.contents = UIColor.grayColor()
//        boxGeometry.firstMaterial = boxMaterial
//        let box = SCNNode(geometry: boxGeometry)
//        rootNode.addChildNode(box)
//        
//        // Camera
//        let cameraNode = SCNNode()
//        cameraNode.camera = SCNCamera()
//        cameraNode.position = SCNVector3(x: 0, y: 0, z: 0)
//        cameraNode.camera?.orthographicScale = 1
//        cameraNode.camera?.usesOrthographicProjection = true
//        rootNode.addChildNode(cameraNode)
//        
//        // 142 - deltaX from one screen side to the other
//        println(view.frame)
//        sceneView.showsStatistics = true
    }
    
//    var selectedNode: SCNNode?
//    var selectedNodePosition: SCNVector3?
//    var selectedPosition: CGPoint?
//    
//    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
//        
//        let touch = touches.first as! UITouch
//        let point = touch.locationInView(view)
//        
//        let options: [NSObject : AnyObject] = [
//            SCNHitTestFirstFoundOnlyKey: NSNumber(bool: true),
//            SCNHitTestSortResultsKey: NSNumber(bool: true)
//        ]
//        
//        if let results = sceneView.hitTest(point, options: options) as? [SCNHitTestResult] {
//            if let result = results.first {
//                selectedNode = result.node
//                selectedNodePosition = result.node.position
//                selectedPosition = point
//                activateSelectedNode()
//            }
//        }
//        
//        super.touchesBegan(touches, withEvent: event)
//    }
//    
//    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
//        if let selectedNode = selectedNode {
//            let touch = touches.first as! UITouch
//            let point = touch.locationInView(view)
//            
//            var deltaX = point.x - selectedPosition!.x
//            let deltaY = point.y - selectedPosition!.y
//            
//            if fabs(deltaX) > fabs(deltaY) {
//                let relative: Float = Float(deltaX / view.frame.width) * 142
//                println("relative: \(relative)")
//                let positionNew = SCNVector3(
//                    x: selectedNodePosition!.x + Float(relative),
//                    y: selectedNodePosition!.y,
//                    z: selectedNodePosition!.z)
//                selectedNode.position = positionNew
//            }
//        }
//        
//        super.touchesMoved(touches, withEvent: event)
//    }
//    
//    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
//        
//        deactivateSelectedNode()
//        
//        super.touchesEnded(touches, withEvent: event)
//    }
//    
//    func activateSelectedNode() {
//        let material = SCNMaterial()
//        material.diffuse.contents = UIColor.redColor()
//        
//        selectedNode?.geometry?.firstMaterial = material
//        
//        //sceneView.allowsCameraControl = false
//    }
//    func deactivateSelectedNode() {
//        let material = SCNMaterial()
//        material.diffuse.contents = UIColor.orangeColor()
//        
//        selectedNode?.geometry?.firstMaterial = material
//        selectedNode = nil
//        selectedPosition = nil
//        selectedNodePosition = nil
//        
//        //sceneView.allowsCameraControl = true
//    }

}

