//
//  LineNode.swift
//  ARRuler
//
//  Created by Drew Scheffer on 6/8/21.
//

import Foundation
import UIKit
import SceneKit
import ARKit

class LineNode: NSObject, NSCopying {
    
    let good_orange = UIColor(red: 251/255, green: 147/255, blue: 0/255, alpha: 1.0)
    
    var node_scale = 1/150.0
    
    let startNode: SCNNode
    let endNode: SCNNode
    var lineNode: SCNNode?
    var arrowNode: SCNNode?
    var sceneView: ARSCNView?
    private var recentFocusSquarePositions = [SCNVector3]()
    
    init(startPos: SCNVector3, scnView: ARSCNView) {
        func buildSphere(color: UIColor) -> SCNSphere {
            let dot = SCNSphere(radius: 1)
            dot.firstMaterial?.diffuse.contents = color
            dot.firstMaterial?.lightingModel = .constant
            dot.firstMaterial?.isDoubleSided = true
            return dot
        }
        
        self.sceneView = scnView
        
        startNode = SCNNode(geometry: buildSphere(color: good_orange))
        startNode.scale = SCNVector3(node_scale, node_scale, node_scale)
        startNode.position = startPos
        sceneView?.scene.rootNode.addChildNode(startNode)
        
        endNode = SCNNode(geometry: buildSphere(color: good_orange))
        endNode.scale = SCNVector3(node_scale, node_scale, node_scale)
        
        lineNode = nil
        
        super.init()
    }
    
    //initializew with a start and end pos
    init(startPos: SCNVector3, endPos: SCNVector3, scnView: ARSCNView) {
        func buildSphere(color: UIColor) -> SCNSphere {
            let dot = SCNSphere(radius: 1)
            dot.firstMaterial?.diffuse.contents = color
            dot.firstMaterial?.lightingModel = .constant
            dot.firstMaterial?.isDoubleSided = true
            return dot
        }
        
        self.sceneView = scnView
        
        startNode = SCNNode(geometry: buildSphere(color: good_orange))
        startNode.scale = SCNVector3(node_scale, node_scale, node_scale)
        startNode.position = startPos
        sceneView?.scene.rootNode.addChildNode(startNode)
        
        endNode = SCNNode(geometry: buildSphere(color: good_orange))
        endNode.scale = SCNVector3(node_scale, node_scale, node_scale)
        endNode.position = endPos
        sceneView?.scene.rootNode.addChildNode(endNode)
        
        super.init()
        
        lineNode = self.lineBetweenNodes(node1: startNode, node2: endNode)
        sceneView?.scene.rootNode.addChildNode(lineNode!)
        
        
        arrowNode = CreateArrow(with: .orange)
        arrowNode?.position.x = (startPos.x + endPos.x) / 2
        arrowNode?.position.y = (startPos.y + endPos.y) / 2
        arrowNode?.position.z = (startPos.z + endPos.z) / 2
        arrowNode?.eulerAngles = lineNode!.eulerAngles
        sceneView?.scene.rootNode.addChildNode(arrowNode!)
        
        
        
    }
    
    init(startNode: SCNNode, endNode: SCNNode, lineNode: SCNNode?, sceneView: ARSCNView?) {
        self.startNode = startNode
        self.endNode = endNode
        self.lineNode = lineNode
        self.sceneView = sceneView

        super.init()
    }
    
    deinit {
        removeFromParent()
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let new_line_node: LineNode = LineNode(startNode: startNode.clone(), endNode: endNode.clone(), lineNode: lineNode?.clone(), sceneView: sceneView)
        return new_line_node
    }
    
    public func updateHeight(newHeight: Float){
        //lineNode?.position.y += 0.0001
        
        
        startNode.position.y = newHeight
        endNode.position.y = newHeight
        lineNode?.removeFromParentNode()
        lineNode = lineBetweenNodes(node1: startNode, node2: endNode)
        sceneView?.scene.rootNode.addChildNode(lineNode!)
        
        //lineNode?.scale = SCNVector3(1.5, 1.0, 1.0)
        
        //lineNode?.transform = SCNMatrix4MakeTranslation(1.0, Float(newHeight / 2.0), 1.0)
    }
    
    
    public func updatePosition (pos: SCNVector3, camera: ARCamera?, is_hidden: Bool = false) -> Float {
        let posEnd = updateTransform(for: pos, camera: camera)
        
        if endNode.parent == nil {
            sceneView?.scene.rootNode.addChildNode(endNode)
        }
        endNode.position = posEnd
        
        //let posStart = startNode.position
        
        lineNode?.removeFromParentNode()
        lineNode = lineBetweenNodes(node1: startNode, node2: endNode)
        lineNode?.isHidden = is_hidden
        sceneView?.scene.rootNode.addChildNode(lineNode!)
        
        return 0.0
    }
    
    func lineBetweenNodes(node1: SCNNode, node2: SCNNode) -> SCNNode {
        let lineNode = SCNGeometry.cylinderLine(from: node1.position, to: node2.position, segments: 16)
        return lineNode
    }
    
    func CreateArrow(with color: UIColor) -> SCNNode{
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.0, y: 0.0))
        path.addLine(to: CGPoint(x: -0.05, y: -0.05))
        path.addLine(to: CGPoint(x: 0.05, y: -0.05))
        //path.addLine(to: CGPoint(x: 0, y: 0.1))
        path.close()
        
        let shape = SCNShape(path: path, extrusionDepth: 0.01)
        shape.firstMaterial?.diffuse.contents = color
        shape.chamferRadius = 0.1
        
        let node = SCNNode(geometry: shape)
        
        return node
    }
    
    //MARK: - Private
    
    func removeFromParent() {
        startNode.removeFromParentNode()
        endNode.removeFromParentNode()
        lineNode?.removeFromParentNode()
        arrowNode?.removeFromParentNode()
    }
    
    private func updateTransform(for position: SCNVector3, camera: ARCamera?) -> SCNVector3 {
        //Currently does not do any updating lol
        return position
//        return SCNVector3Zero
    }
}
