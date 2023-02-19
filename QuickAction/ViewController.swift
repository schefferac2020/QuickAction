//
//  ViewController.swift
//  QuickAction
//
//  Created by Drew Scheffer on 2/18/23.
//

import UIKit
import SceneKit
import ARKit
import Foundation
import Vision
import AVFoundation

enum DrawingState {
    case NOT_SET, PLACING_NODES
}

class ViewController: UIViewController, ARSCNViewDelegate {
    
    
    let orange_clickable = UIColor(red: 251/255, green: 147/255, blue: 0/255, alpha: 1.0)
    let orange_disabled = UIColor(red: 251/255, green: 147/255, blue: 0/255, alpha: 0.5)
    
    let red_enabled = UIColor(red: 245/255, green: 71/255, blue: 72/255, alpha: 1.0)
    let red_disabled = UIColor(red: 245/255, green: 71/255, blue: 72/255, alpha: 0.5)
    
    //@IBOutlet var sceneView: ARSCNView!
    var drawing_state = DrawingState.NOT_SET
    
    var linesGroup: LineGroup?
    var allLineGroups: [LineGroup] = []
    var connectors: [SCNNode] = []
    
    let path = UIBezierPath()
    
    let toastLbl = UILabel()
    
    private let sceneView: ARSCNView =  ARSCNView(frame: UIScreen.main.bounds)
    private let indicator = UIImageView()
    
    var auditoryGuide: AuditoryGuide?
        
    let path_information: Dictionary<String, [SCNVector3]> = [
        "bike": [SCNVector3(x: 0.0, y: 0.3, z: 0.0), SCNVector3(x: 4.26, y: 0.3, z: 0), SCNVector3(x: 4.26, y: -1.2, z: 0), SCNVector3(x: 7.2, y: -1.2, z: 0), SCNVector3(x: 7.2, y: 2.4, z: 0), SCNVector3(x: 7.7, y: 2.4, z: 0)]
    ]
    
    let following_the_leader = true;
    
    @IBOutlet weak var moreButton: RoundedButton!
    @IBOutlet weak var horizStack: UIStackView!
    @IBOutlet weak var shareButton: RoundedButton!
    @IBOutlet weak var redoButton: RoundedButton!
    @IBOutlet weak var vertStack: UIStackView!
    
    var screenCenter: CGPoint?
    var focusSquare: FocusSquare?
    
    var moreToggled: Bool = false
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        layout_view()
        setUpAndRunConfiguration()
        
        
        
    }
    
    private func SetupToast(){
        let width = view.bounds.width
        let height = view.bounds.height
        
        toastLbl.text = "Please scan around your room to localize"
        toastLbl.textAlignment = .center
        toastLbl.font = UIFont.systemFont(ofSize: 30)
        toastLbl.textColor = UIColor.white
        toastLbl.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLbl.numberOfLines = 0
        
        let textSize = toastLbl.intrinsicContentSize
        let labelWidth = min(textSize.width, width - 80)
        
        toastLbl.frame = CGRect(x: 20, y: 90, width: labelWidth+20, height: textSize.height+50)
        toastLbl.center.x = view.center.x
        toastLbl.layer.cornerRadius = 10
        toastLbl.layer.masksToBounds = true
        
        view.addSubview(toastLbl)
    }
    
    private func setUpAndRunConfiguration(){
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            if ARWorldTrackingConfiguration.isSupported{
                let configuration = ARWorldTrackingConfiguration()
                //The y-axis matches the direction of gravity as detected by the device's motion sensing hardware; that is, the vector (0,-1,0) points downward
                configuration.worldAlignment = .gravity
                
                //Do plane detection
                configuration.planeDetection = [.horizontal, .vertical]
                
                
//                enable this if you want to see the world Origin being set when a market
//                is scanned during navigation or creating a custom map
                sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin]
                
                //Reference marker images
                
                if let ARImages = ARReferenceImage.referenceImages(inGroupNamed: "ARResources", bundle: Bundle.main) {
                    
                    configuration.detectionImages = ARImages
                } else {
                    print("Images could not be loaded")
                }
                //Cleans the ARScene
                sceneView.scene.rootNode.enumerateChildNodes{ (node, stop) in
                    node.removeFromParentNode()
                }
                sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
            } else {
                print("ARWORLDTRACKING IS NOT SUPPORTED!!!!")
            }
        }
        
    }
    
    func layout_view(){
        self.screenCenter = self.sceneView.bounds.mid
        //screenCenter = self.indicator.center
        setupFocusSquare()
        
        let width = view.bounds.width
        let height = view.bounds.height
        view.backgroundColor = UIColor.black
        
        view.addSubview(sceneView)
        sceneView.frame = view.bounds
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints] //Shows the feature points
        sceneView.autoenablesDefaultLighting = true
        
        indicator.image = K.Image.Indicator.green
        // = orange_clickable
        
        indicator.image = indicator.image?.withRenderingMode(.alwaysTemplate)
        indicator.tintColor = orange_clickable
        
        indicator.frame = CGRect(x: (width - 60)/2, y: (height - 60)/2, width: 60, height: 60)
        view.addSubview(indicator)
        
        
        moreButton.defaultColor = orange_clickable
        moreButton.highlightedColor = orange_disabled
        
        shareButton.defaultColor = orange_clickable
        shareButton.highlightedColor = orange_disabled
        
        redoButton.defaultColor = red_enabled
        redoButton.highlightedColor = red_disabled
        
        view.bringSubviewToFront(horizStack)
        view.bringSubviewToFront(vertStack)
        
        redoButton.isHidden = true
        shareButton.isHidden = true
        
        SetupToast()
    }
    
    func setupFocusSquare() {
            self.focusSquare?.isHidden = true
            self.focusSquare?.removeFromParentNode()
            self.focusSquare = FocusSquare()
            self.sceneView.scene.rootNode.addChildNode(self.focusSquare!)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        // If Out Target Image Has Been Detected Then Get The Corresponding Anchor
        guard let currentImageAnchor = anchor as? ARImageAnchor else { return nil }

        // Get The Targets Name
        let name = currentImageAnchor.referenceImage.name!

        // Log The Reference Images Information
        print("FOUND ANCHOR WITH NAME = \(name)")
        
        DispatchQueue.main.sync {
            toastLbl.isHidden = true
        }
        
        // Set the origin
        sceneView.session.setWorldOrigin(relativeTransform: anchor.transform)
        
        CreatePathFromPositions(anchor_name: name)
        
        return nil
    }
    
    // Create a linegroup from a list of positions
    private func CreatePathFromPositions(anchor_name: String){
        resetEverything()
        
        guard let new_path = path_information[anchor_name] else { return  }
        
        linesGroup = LineGroup(positions: new_path, sceneView: sceneView)
        auditoryGuide = AuditoryGuide(line_group: linesGroup!, threshold: 0.4)
    }
    
    //Runs over and over again (60fps)
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        self.updateLine()
        self.updateFocusSquare()
        
        //Get the camera position
        let user_vec = getUserVector()
        let user_dir = user_vec.0
        let user_pos = user_vec.1
        
        auditoryGuide?.UpdateCameraLocation(camera_pos: user_pos)
    }
    
    public func lineIntersection(planePoint: SCNVector3, planeNormal: SCNVector3, linePoint: SCNVector3, lineDirection: SCNVector3) -> SCNVector3? {
        if (planeNormal.dot(with: lineDirection.normalize()) == 0){
            return nil
        }
        
        let t = (planeNormal.dot(with: planePoint) - planeNormal.dot(with: linePoint)) / planeNormal.dot(with: lineDirection.normalize())
        return linePoint + lineDirection.normalize().scale(factor: t)
    }
    
    
    func updateFocusSquare() {
        DispatchQueue.main.async {
            
            self.focusSquare?.unhide()
            
            let (world_transform, planeAnchor, _) = self.sceneView.worldPositionFromScreenPosition(self.indicator.center, objectPos: nil)
            let worldPos = world_transform?.translation
            if let worldPos = worldPos {
                    self.focusSquare?.update(for: worldPos, planeAnchor: planeAnchor, camera: self.sceneView.session.currentFrame?.camera)
            }
        }
    }
    
    func getUserVector() -> (SCNVector3, SCNVector3) { // returns direction, position vectors
        if let frame = self.sceneView.session.currentFrame {
            let mat = SCNMatrix4(frame.camera.transform)
            let pos = SCNVector3(mat.m41, mat.m42, mat.m43)
            let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33)
            
            return (dir, pos)
        }
        return (SCNVector3(0, 0, -1), SCNVector3(0, 0, -0.2))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        
        self.setUpAndRunConfiguration()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
    func updateLine() {
        if (following_the_leader){
            //we do not want to update the path if it is just a user...
            return;
        }
        
        
        let result = sceneView.worldPositionFromScreenPosition(self.indicator.center, objectPos: nil)
        guard let transform = result.world_transform else { return; }
        
        let position: SCNVector3? = SCNVector3.transformToPosition(result.world_transform!)
        if let p = position {
            let camera = self.sceneView.session.currentFrame?.camera
            let cameraPos = SCNVector3.transformToPosition(camera!.transform)
            //Do something with the current camera position
            
            guard let group = linesGroup else {
                return;
            }
            let area = group.updatePosition(pos: p, camera: camera)
            
        }
    }
    
    func lineBetweenNodes(node1: SCNNode, node2: SCNNode) -> SCNNode {
        let lineNode = SCNGeometry.cylinderLine(from: node1.position, to: node2.position, segments: 16)
        return lineNode
    }
    
    //MARK: - IBActions
    @IBAction func moreButtonPressed(_ sender: Any) {
        
        
        
        let dur = 0.4
        let op = UIView.AnimationOptions.transitionCrossDissolve
        
        if (moreToggled){
            if self.shareButton.isHidden == false {
                UIView.transition(with: shareButton, duration: 1*dur,
                                  options: op,
                                  animations: {
                                    self.shareButton.isHidden = true
                              })
            }
            UIView.transition(with: redoButton, duration: 2*dur,
                              options: op,
                              animations: {
                                self.redoButton.isHidden = true
                          })
        }else{
            UIView.transition(with: redoButton, duration: 1*dur,
                              options: op,
                              animations: {
                                self.redoButton.isHidden = false
                          })
            if allLineGroups.count != 0 {
                UIView.transition(with: shareButton, duration: 3*dur,
                                  options: op,
                                  animations: {
                                    self.shareButton.isHidden = false
                              })
            }
        }

        
        moreToggled = !moreToggled
        moreButton.defaultColor = moreToggled ? orange_disabled : orange_clickable
        
    }
    
    
    @IBAction func finishButtonPressed(_ sender: Any) {
        self.finishAction(sender as! UIButton)
    }
    
    @IBAction func redoButtonPressed(_ sender: Any) {
        resetEverything()
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        exportObject(sender as! UIButton)
    }
    
    
}

@objc private extension ViewController{
    func placePoint(_ sender: UIButton){
        linesGroup?.debug_lines()
        print("DEBUGGING")
        return;
        drawing_state = DrawingState.PLACING_NODES
        
        
        if let group = linesGroup {
            group.add_line()
        }else{
            let result = sceneView.worldPositionFromScreenPosition(self.indicator.center, objectPos: nil)
            let position: SCNVector3? = SCNVector3.transformToPosition(result.world_transform!)
            
            if let p = position {
                linesGroup = LineGroup(startPos: p, scnView: sceneView)
            }
        }
    }
    
    func finishAction(_ sender: UIButton) {
        linesGroup?.debug_lines()
        
        
        guard let lineGrp = linesGroup, lineGrp.lines.count >= 2 else{
            linesGroup = nil
            return
        }
        allLineGroups.append(lineGrp)
        linesGroup = nil
    }
    
    func exportObject(_ sender: UIButton) {
        //Write all of the feature points to a string
        resetEverything()
        performSegue(withIdentifier: K.Segues.toModify, sender: nil)
    }
    
    func resetEverything() {
        drawing_state = DrawingState.NOT_SET
        
        self.linesGroup = nil
        self.allLineGroups = []
        
        for connector in connectors{
            connector.removeFromParentNode()
        }
        self.connectors = []
        
        shareButton.isHidden = true
    }
}



