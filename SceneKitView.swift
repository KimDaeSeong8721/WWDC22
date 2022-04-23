//
//  File.swift
//  TidalWaveTea
//
//  Created by DaeSeong on 2022/04/22.
//

import SwiftUI
import UIKit
import SceneKit


struct SceneKitView: UIViewRepresentable {

  @Binding var angleMultiplyer: Int
    @Binding var earthRotating : Int
  let baseNode: SCNNode
  let sceneView : SCNView
   // let moonRing : SCNNode?
    
    init(angleMultiplyer: Binding<Int>,earthRotating: Binding<Int>) {
      print("초기화")
      
      
      self.baseNode = SCNNode()
      self.sceneView = SCNView()
      //baseSetting()
    self._angleMultiplyer = angleMultiplyer
    self._earthRotating = earthRotating

  }

    func baseSetting(angleMultiplyer : Int){
    

        // Sun initial
        let sun = createPlanet(radius: 0.25, image: "sun")
        sun.name = "sun"
        sun.position = SCNVector3(x:0, y:0, z:0)
        
        // Moon intial
        let moon = createPlanet(radius: 0.05, image: "moon")
        let moonRing = createRing(ringSize: 0.2)
        moon.name = "moon"
        moon.position = SCNVector3(x:angleMultiplyer % 2 == 0 ? 0.2 : -0.2 , y: 0, z: 0)

        
        rotateMoon(rotation: .pi*0.5,planet: moonRing, duration: 1)
        moonRing.position = SCNVector3(x:0.0 , y: 0.02, z: 0)
        moonRing.rotation = SCNVector4(0, 1, 0, .pi*(-0.5)*Float(angleMultiplyer))
        moonRing.addChildNode(moon)

        // Earth intial
        let earthRing = createRing(ringSize: 0.7)
        let earth = createPlanet(radius: 0.1, image: "earth")
        earth.name = "Earth"
        earth.position = SCNVector3(x:0.7, y: 0, z: 0)
        
       // rotateMoon(rotation: .pi*0.5,planet: earth, duration: 1)
        //rotateMoon(rotation: .pi*(-0.5),planet: moonRing, duration: 1)

        earth.addChildNode(moonRing)

        earthRing.addChildNode(earth)

     
        baseNode.addChildNode(sun)
        baseNode.addChildNode(earthRing)
        baseNode.position = SCNVector3(x: 0 ,y: -0.5 ,z: -1)
        baseNode.rotation = .init(1, 0, 0, .pi*0.5)
    }
    
  func makeUIView(context: UIViewRepresentableContext<SceneKitView>) -> SCNView {
      
      baseSetting(angleMultiplyer: angleMultiplyer)
    
    sceneView.scene = SCNScene()
      sceneView.allowsCameraControl = true
    sceneView.autoenablesDefaultLighting = true
    sceneView.scene?.rootNode.addChildNode(baseNode)
    return sceneView
  }

  func updateUIView(_ sceneView: SCNView, context: UIViewRepresentableContext<SceneKitView>) {
    print("Updating view \(angleMultiplyer)")
      
      print("baseNode \(baseNode.childNodes.count)")
   

    // To go to a fixed angleMultiplyer state
    //let rotation = SCNAction.rotate(toAxisAngle: SCNVector4(1, 0, 0, angle.radians), duration: 3)
      baseSetting(angleMultiplyer: angleMultiplyer)
      print("da")
      sceneView.scene?.rootNode.removeAllAnimations()
      sceneView.scene?.rootNode.childNodes[0].removeFromParentNode()

      sceneView.scene?.rootNode.addChildNode(baseNode)
 

  }
    
    
    
    // MARK: - for planet
    func createPlanet(radius: Float, image: String) -> SCNNode{
        let planet = SCNSphere(radius: CGFloat(radius))
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "\(image).jpg")
        planet.materials = [material]
    
        let planetNode = SCNNode(geometry: planet)
        
        
        return planetNode
    }
    

  
    
    func rotateMoon( rotation: CGFloat,planet: SCNNode, duration: Float){
//        let rotation = SCNAction.rotateBy(x:0,y:CGFloat(rotation),z:0, duration: TimeInterval(duration))
      //  let angle = CGFloat(-90.0 * .pi / 180)
        
        let rotation = SCNAction.rotate(by: rotation, around: SCNVector3(0, 1, 0), duration: 1)

        //let rotation = SCNAction.rotateBy(x: 0, y: .pi*0.5, z: 0, duration: TimeInterval(duration))
       // planet.runAction(SCNAction.sequence([rotation])
        planet.runAction(SCNAction.sequence([rotation]))
        
    }
    
//    func rotateObject(rotation: Float, planet: SCNNode, duration: Float){
//        let rotation = SCNAction.rotateBy(x:0,y:CGFloat(rotation),z:0, duration: TimeInterval(duration))
//        planet.runAction(SCNAction.sequence([rotation]))
//
//    }
    
    func createRing(ringSize: Float) -> SCNNode {
        
        let ring = SCNTorus(ringRadius: CGFloat(ringSize), pipeRadius: 0.002)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.darkGray
        
        ring.materials = [material]
        
        let ringNode = SCNNode(geometry: ring)
        
        return ringNode
    }

}
