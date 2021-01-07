//
//  ViewController.swift
//  Annotation
//
//  Created by 吴苗沁 on 29.12.20.
//

import UIKit
import RealityKit
import ARKit

class ViewController: UIViewController {
    
    var color = UIColor.red
    var anno_on = true
    
    @IBOutlet weak var statusText: UILabel!
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupARview()
        
        // Setup Tap Recognizer
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        let panToDrawGesture = UIPanGestureRecognizer(target: self, action: #selector(createNodesfromPan))
        self.sceneView.addGestureRecognizer(panToDrawGesture)
            
    }

    
    // MARK: Setup Methods
    func setupARview(){
      
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical] // both plane detection
        configuration.environmentTexturing = .automatic // make it more realistic
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        sceneView.session.run(configuration)
        
    }
    
    func addObject(x: Float = 0, y: Float = 0, z: Float = 0) {

        guard let ObjectScene = SCNScene(named: "art.scnassets/bullfinch.scn"),
            let ObjectNode = ObjectScene.rootNode.childNode(withName: "Plane", recursively: false)
        else {
            self.statusText.text = "Cannot load model"
            return
        }
        ObjectNode.position = SCNVector3(x,y,z)
        
        ObjectNode.name = "model"
        
        self.statusText.text = "Model loaded"
        sceneView.scene.rootNode.addChildNode(ObjectNode)
    }
    
    func addAnno(x: Float = 0, y: Float = 0, z: Float = 0) {
        
        let node = SCNNode(geometry: SCNSphere(radius: 0.0005))
        node.name = "annotation"
        node.geometry?.firstMaterial?.diffuse.contents = color
        node.position = SCNVector3(x,y,z)
        self.sceneView.scene.rootNode.addChildNode(node)
    }
    
    @IBAction func annoOrWipe(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            anno_on = true
        }else if sender.selectedSegmentIndex == 1{
            anno_on = false
        }
    }
    @IBAction func annoOrNot(_ sender: UISegmentedControl) {
        // wrong name: actually it is color switch
        
        if sender.selectedSegmentIndex == 0{
            color = UIColor.red
        }else if sender.selectedSegmentIndex == 1{
            color = UIColor.green
        }else if sender.selectedSegmentIndex == 2{
            color = UIColor.black
        }else if sender.selectedSegmentIndex == 3{
            color = UIColor.yellow
        }else if sender.selectedSegmentIndex == 4{
            color = UIColor.blue
        }
        
    }
    @IBAction func placeObject(_ sender: Any) {
        addObject()
    }
    
    @IBAction func clearContent(_ sender: Any) {
        self.sceneView.scene.rootNode.enumerateChildNodes({ (node, _) in
            if node.name == "annotation" {
                node.removeFromParentNode()
            }
        })
        self.statusText.text = "Annotation cleared"
    }

    
    @objc func createNodesfromPan(_gesture: UIPanGestureRecognizer){
        let currentPosition = _gesture.location(in: self.sceneView)
        let hitTestResults = self.sceneView.hitTest(currentPosition, options: nil)

        
        if hitTestResults .isEmpty{
            self.statusText.text = "No hit result"
            return
        }else{
            
            if anno_on == true {
                self.statusText.text = "Annotating"
                
                let tappednode = hitTestResults.first?.node
                
                if tappednode?.name == "model" {
                    
                    var anno_x = hitTestResults.first?.worldCoordinates.x ?? 0.0
                    var anno_y = hitTestResults.first?.worldCoordinates.y ?? 0.0
                    var anno_z = hitTestResults.first?.worldCoordinates.z ?? 0.0
                    
                    addAnno(x: anno_x, y: anno_y, z: anno_z)
                }else{
                    self.statusText.text = "Annotate not on model"
                }
                
            } else if anno_on == false{
                
                let tappednode = hitTestResults.first?.node
                
                self.sceneView.scene.rootNode.enumerateChildNodes({ (node, _) in
                    if node == tappednode && node.name == "annotation" {
                        node.removeFromParentNode()
                    }
                })
                self.statusText.text = "Annotation cleared"
            }
        }
        
    }
    
    
    @objc func didTap(withGestureRecognizer recognizer: UITapGestureRecognizer) {
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation)
        
        if hitTestResults .isEmpty{
            self.statusText.text = "No hit result"
            return
        }else{
            
            if anno_on == true {
                self.statusText.text = "Annotating"
                
                let tappednode = hitTestResults.first?.node
                
                if tappednode?.name == "model" {
                    
                    var anno_x = hitTestResults.first?.worldCoordinates.x ?? 0.0
                    var anno_y = hitTestResults.first?.worldCoordinates.y ?? 0.0
                    var anno_z = hitTestResults.first?.worldCoordinates.z ?? 0.0
                    
                    addAnno(x: anno_x, y: anno_y, z: anno_z)
                }else{
                    self.statusText.text = "Annotate not on model"
                }
                
            } else if anno_on == false{
                
                let tappednode = hitTestResults.first?.node
                
                self.sceneView.scene.rootNode.enumerateChildNodes({ (node, _) in
                    if node == tappednode && node.name == "annotation" {
                        node.removeFromParentNode()
                    }
                })
                self.statusText.text = "Annotation cleared"
            }
        }
        
    }

}

