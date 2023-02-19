//
//  AuditoryGuide.swift
//  QuickAction
//
//  Created by Drew Scheffer on 2/18/23.
//

import Foundation
import AVFoundation
import SceneKit
import ARKit


class AuditoryGuide {
    let synthesizer = AVSpeechSynthesizer()
    
    let line_group: LineGroup
    var current_line = 0
    var threshold: Float
    
    
    init(line_group: LineGroup, threshold: Float) {
        self.line_group = line_group
        self.threshold = threshold
    }
    
    func UpdateCameraLocation(camera_pos: SCNVector3){
        //if we are done with the navigation, no need to update the camera location...
        if (current_line >= line_group.lines.count){
            return
        }
        
        //Calculate the distance to the current waypoint
        let dest_pos: SCNVector3 = line_group.lines[current_line].startNode.position
        let distance_to_next_waypoint = distanceBetweenPoints(A: camera_pos, B: dest_pos)
        
        //print("The distance is \(distance_to_next_waypoint)")
        if (distance_to_next_waypoint < self.threshold){
            
            
            
            //get the direction (left right straight) to the next waypoint
            
            if (current_line - 1 >= 0){
                line_group.lines[current_line-1].removeFromParent()
                let angle = GetAngleBetweenTwoLines(node1: line_group.lines[current_line-1], node2: line_group.lines[current_line])
                print("The angle you need to turn is... \(angle)")
                GuideToNextWaypointFromAngle(angle: angle)
            }

            current_line += 1
        }
        
        
    }
    
    func GetAngleBetweenTwoLines(node1: LineNode, node2: LineNode) -> CGFloat{
        let v1 = CGVector(dx: CGFloat(node1.endNode.position.x - node1.startNode.position.x), dy: CGFloat(node1.endNode.position.y - node1.startNode.position.y))
        let v2 = CGVector(dx: CGFloat(node2.endNode.position.x - node2.startNode.position.x), dy: CGFloat(node2.endNode.position.y - node2.startNode.position.y))
        
        print(v1, v2)
        
        let angle = atan2(v2.dy, v2.dx) - atan2(v1.dy, v1.dx)
        var deg = angle * CGFloat(180.0 / Double.pi)
        
        if deg < 0 { deg += 360.0 }
        
        return deg;
        
        
    }
    
    func SpeakText(message: String){
        let utterance = AVSpeechUtterance(string: message)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")

        synthesizer.speak(utterance)
    }
    
    func GuideToNextWaypointFromAngle(angle: CGFloat){
        if (angle < 20 || 360 - angle < 20){
            SpeakText(message: "Continue on forward")
            return
        }
        
        if (angle > 180){
            SpeakText(message: "Turn about \(Int(360-angle)) degrees to your left. Then continue on.")
        }else{
            SpeakText(message: "Turn about \(Int(angle)) degrees to your right. Then continue on.")
        }
    }
    
    func distanceBetweenPoints(A: SCNVector3, B: SCNVector3) -> Float {
         let l = sqrt((A.x - B.x) * (A.x - B.x) + (A.y - B.y) * (A.y - B.y) + (A.z - B.z) * (A.z - B.z))
         return l
     }
    
    
}
