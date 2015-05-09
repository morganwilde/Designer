//
//  ViewController.swift
//  Designer
//
//  Created by Morgan Wilde on 26/04/2015.
//  Copyright (c) 2015 Morgan Wilde. All rights reserved.
//

import UIKit
import SceneKit

func MatrixVectorProduct(matrix: SCNMatrix4, vector: SCNVector4) -> SCNVector4 {
    let x = matrix.m11 * vector.x + matrix.m12 * vector.y + matrix.m13 * vector.z + matrix.m14 + vector.w;
    let y = matrix.m21 * vector.x + matrix.m22 * vector.y + matrix.m23 * vector.z + matrix.m24 + vector.w;
    let z = matrix.m31 * vector.x + matrix.m32 * vector.y + matrix.m33 * vector.z + matrix.m34 + vector.w;
    let w = matrix.m41 * vector.x + matrix.m42 * vector.y + matrix.m43 * vector.z + matrix.m44 + vector.w;
    
    return SCNVector4(x: x, y: y, z: z, w: w)
}

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
        
        // Box
        let boxGeometry = SCNBox(width: 2, height: 2, length: 1, chamferRadius: 0)
        let boxMaterial1 = SCNMaterial()
        boxMaterial1.diffuse.contents = UIColor.redColor()
        let boxMaterial2 = SCNMaterial()
        boxMaterial2.diffuse.contents = UIColor.blueColor()
        let boxMaterial3 = SCNMaterial()
        boxMaterial3.diffuse.contents = UIColor.orangeColor()
        let boxMaterial4 = SCNMaterial()
        boxMaterial4.diffuse.contents = UIColor.greenColor()
        let boxMaterial5 = SCNMaterial()
        boxMaterial5.diffuse.contents = UIColor.magentaColor()
        let boxMaterial6 = SCNMaterial()
        boxMaterial6.diffuse.contents = UIColor.cyanColor()
        boxGeometry.materials = [boxMaterial1, boxMaterial2, boxMaterial3, boxMaterial4, boxMaterial5, boxMaterial6]
        for material in boxGeometry.materials as! [SCNMaterial] {
            material.doubleSided = false
        }
        
        let cubeGeometry = SCNBox(width: 1.8, height: 1.8, length: 1, chamferRadius: 0)
        
        // Grid
        let gridNode = SCNNode()
        
        rootNode.addChildNode(gridNode)
        
        // Fill the grid with cells
        let verticalCells = 10
        let horizontalCells = 20
        let cellLenght: Float = 2
        for var v = 0; v < verticalCells; v++ {
            for var h = 0; h < horizontalCells; h++ {
                let boxNode = SCNNode(geometry: boxGeometry)
                boxNode.position = SCNVector3(
                    x: Float(h) * cellLenght + cellLenght/2,
                    y: Float(v) * cellLenght + cellLenght/2 - Float(verticalCells)/2 * cellLenght,
                    z: 0)
                
                let cubeNode = SCNNode(geometry: cubeGeometry)
                cubeNode.position = SCNVector3(x: 0, y: 0, z: 0.1)
                boxNode.addChildNode(cubeNode)
                
                gridNode.addChildNode(boxNode)
            }
        }
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeDirectional
        ambientLightNode.light!.color = UIColor(white: 0.5, alpha: 1.0)
        ambientLightNode.position = SCNVector3(x: 0, y: 0, z: 100)
        gridNode.addChildNode(ambientLightNode)
        
        // Adjust the grid's position
        let gridMidPointX = -Float(horizontalCells)/2 * 2 + cellLenght/2
        let gridMidPointY = -Float(verticalCells)/2 * 2 + cellLenght/2
//        gridNode.position = SCNVector3(
//            x: gridMidPointX,
//            y: 0,
//            z: 0)
//        gridNode.pivot = SCNMatrix4Translate(
//            SCNMatrix4Identity,
//            Float(horizontalCells)/2 * cellLenght - cellLenght/2,
//            Float(verticalCells)/2 * cellLenght - cellLenght/2,
//            0)
//        gridNode.transform = perspectiveRotation
        
        // Camera
        let camera = SCNCamera()
        camera.zNear = -100
        camera.zFar = 100
        camera.orthographicScale = 10
        camera.usesOrthographicProjection = true
        let cameraNode = SCNNode()
//        cameraNode.position = SCNVector3(
//            x: cellLenght * 100,
//            y: 0,
//            z: 50)
//        cameraNode.position = SCNVector3(x: cameraNode.position.x + movementVector.x, y: cameraNode.position.y + movementVector.y, z: cameraNode.position.z + movementVector.z)
        cameraNode.camera = camera
        
        let perspectiveRotationX = SCNMatrix4MakeRotation(135*PI/180, 1, 0, 0)
        let perspectiveRotationY = SCNMatrix4MakeRotation(0*PI/180, 0, 1, 0)
        let perspectiveRotationZ = SCNMatrix4MakeRotation(60*PI/180, 0, 0, 1)
        let perspectiveRotation = SCNMatrix4Mult(SCNMatrix4Mult(perspectiveRotationX, perspectiveRotationY) , perspectiveRotationZ)
        
        cameraNode.transform = perspectiveRotation
        cameraNode.position = SCNVector3(x: cellLenght * 0, y: 0, z: 0)
        
        let action = SCNAction.moveBy(SCNVector3(x: cellLenght * 20, y: 0, z: 0), duration: 4)
        cameraNode.runAction(action)
        
        rootNode.addChildNode(cameraNode)
        
        sceneView.scene = scene
        println(view.frame)
        
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

