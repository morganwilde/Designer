//
//  GeometryInterpreter.swift
//  Designer
//
//  Created by Morgan Wilde on 28/04/2015.
//  Copyright (c) 2015 Morgan Wilde. All rights reserved.
//

import Foundation
import SceneKit

struct Float3: Equatable {
    var x: Float
    var y: Float
    var z: Float
}

func ==(left: Float3, right: Float3) -> Bool {
    let deltaX = fabs(left.x - right.x)
    let deltaY = fabs(left.y - right.y)
    let deltaZ = fabs(left.z - right.z)
    
    //println("==> (\(deltaX), \(deltaY), \(deltaZ))")
    
    return (
        deltaX < 0.00001 &&
        deltaY < 0.00001 &&
        deltaZ < 0.00001
    )
}

class GeometryInterpreter {
    
    var geometry: SCNGeometry
    var elementCount: Int
    
    // Sources
    var vertexSources: [SCNGeometrySource]? {
        if let sources = geometry.geometrySourcesForSemantic(SCNGeometrySourceSemanticVertex) {
            return sources as? [SCNGeometrySource]
        }
        return nil
    }
    var normalSources: [SCNGeometrySource]? {
        if let sources = geometry.geometrySourcesForSemantic(SCNGeometrySourceSemanticNormal) {
            return sources as? [SCNGeometrySource]
        }
        return nil
    }
    var colorSources: [SCNGeometrySource]? {
        if let sources = geometry.geometrySourcesForSemantic(SCNGeometrySourceSemanticColor) {
            return sources as? [SCNGeometrySource]
        }
        return nil
    }
    var textureSources: [SCNGeometrySource]? {
        if let sources = geometry.geometrySourcesForSemantic(SCNGeometrySourceSemanticTexcoord) {
            return sources as? [SCNGeometrySource]
        }
        return nil
    }
    var vertexCreaseSources: [SCNGeometrySource]? {
        if let sources = geometry.geometrySourcesForSemantic(SCNGeometrySourceSemanticVertexCrease) {
            return sources as? [SCNGeometrySource]
        }
        return nil
    }
    var edgeCreaseSources: [SCNGeometrySource]? {
        if let sources = geometry.geometrySourcesForSemantic(SCNGeometrySourceSemanticEdgeCrease) {
            return sources as? [SCNGeometrySource]
        }
        return nil
    }
    var boneWeightsSources: [SCNGeometrySource]? {
        if let sources = geometry.geometrySourcesForSemantic(SCNGeometrySourceSemanticBoneWeights) {
            return sources as? [SCNGeometrySource]
        }
        return nil
    }
    var boneIndicesSources: [SCNGeometrySource]? {
        if let sources = geometry.geometrySourcesForSemantic(SCNGeometrySourceSemanticBoneIndices) {
            return sources as? [SCNGeometrySource]
        }
        return nil
    }
    
    // Elements
    var geometryElements: [SCNGeometryElement] {
        var elements: [SCNGeometryElement] = []
        let elementCount = geometry.geometryElementCount
        for var index = 0; index < elementCount; index++ {
            elements.append(geometry.geometryElementAtIndex(index)!)
        }
        
        return elements
    }
    
    init(geometry: SCNGeometry) {
        self.geometry = geometry
        
        // Analyse geometry elements and sources
        elementCount = geometry.geometryElementCount
        let geometryElement = geometry.geometryElementAtIndex(0)!
        println("geometryElement.primitiveType: \(geometryElement.primitiveType == .Triangles)")
    }
    
    func makeSpheres() -> [SCNNode] {
        var boxes: [SCNNode] = []
        var vectorsUsed: [Float3] = []
        let vectors = vertexSourceVectors()
        for vector in vectors {
            if contains(vectorsUsed, vector) == false {
                vectorsUsed.append(vector)
                let boxGeometry = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
                let boxNode = SCNNode(geometry: boxGeometry)
                boxNode.position = SCNVector3(x: vector.x, y: vector.y, z: vector.z)
                boxes.append(boxNode)
            } else {
                //println("vector already in there")
            }
        }
        
        return boxes
    }
    
    // Source vectors
    func vertexSourceVectors() -> [Float3] {
        var vectors: [Float3] = []
        
        if let vertexSourcesArray = vertexSources {
            if let vertexSource = vertexSourcesArray.first {
                let componentCount = vertexSource.vectorCount * vertexSource.componentsPerVector
                let componentOffset = vertexSource.dataOffset / vertexSource.bytesPerComponent
                let componentStride = vertexSource.dataStride / vertexSource.bytesPerComponent
//                println("vectorCount: \(vertexSource.vectorCount)")
//                println("componentCount: \(componentCount)")
//                println("componentOffset: \(componentOffset)")
//                println("componentStride: \(componentStride)")
                var components = [Float](count: componentCount, repeatedValue: 0)
                
                if let data = vertexSource.data {
//                    println("array size: \(components.count * sizeof(Float))")
//                    println("data sie: \(data.length)")
                    components = [Float](count: data.length / sizeof(Float), repeatedValue: 0)
                    data.getBytes(&components, length: data.length)
                }
                for var index = 0; index < components.count; index += componentStride {
                    let vector = Float3(
                        x: components[index + 0] * 10,
                        y: components[index + 1] * 10,
                        z: components[index + 2] * 10)
                    vectors.append(vector)
                    
//                    println("(\(vector.x), \(vector.y), \(vector.z))")
                }
//                println("count: \(vectors.count)")
                
                return vectors
            }
        }
        
        return vectors
    }
    
    func makeVertexSource() -> SCNGeometrySource {
        let vectors = vertexSourceVectors()
        let data = NSData(bytes: vectors, length: vectors.count * sizeof(Float3))
        let source = SCNGeometrySource(
            data: data,
            semantic: SCNGeometrySourceSemanticVertex,
            vectorCount: vectors.count,
            floatComponents: true,
            componentsPerVector: 3,
            bytesPerComponent: sizeof(Float),
            dataOffset: 0,
            dataStride: 0)
        
        return source
    }
    
    func makeElement() -> SCNGeometryElement {
        let geometryElement = geometryElements[0]
        var indexArray = [CShort](count: geometryElement.data!.length / sizeof(CShort), repeatedValue: 0)
        geometryElement.data!.getBytes(&indexArray, length: geometryElement.data!.length)
//        println("bytes count: \(geometryElement.bytesPerIndex)")
//        println("bytes count: \(sizeof(CShort))")
//        println("index count: \(indexArray.count)")
        
        let data = NSData(bytes: indexArray, length: indexArray.count * sizeof(CShort))
        let element = SCNGeometryElement(
            data: data,
            primitiveType: SCNGeometryPrimitiveType.Triangles,
            primitiveCount: indexArray.count / 3,
            bytesPerIndex: sizeof(CShort))
        
        return element
    }
    
    func makeGeometry() -> SCNGeometry {
        let vertices = vertexSources!
        let vertice = vertices[0]
        let normals = normalSources!
        let normal = normals[0]
        let textures = textureSources!
        let texture = textures[0]
        
        return SCNGeometry(
            sources: [vertice],
            elements: [makeElement()]
        )
    }
}