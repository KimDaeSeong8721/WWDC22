import SwiftUI
import SpriteKit
import SceneKit



struct ContentView: View {
    
    @State var progress : CGFloat = 0.5
    @State var startAnimation : CGFloat = 0

    let baseNode = SCNNode()
    let scene = SCNScene()
    init(){
        baseSetting()
    }
    
    func baseSetting(){
    
        let sun = createPlanet(radius: 0.25, image: "sun")
        sun.name = "sun"
        sun.position = SCNVector3(x:0, y:0, z:0)
       // rotateObject(rotation: -0.3, planet: sun, duration: 1)
        
        let moon = createPlanet(radius: 0.05, image: "moon")
        let moonRing = createRing(ringSize: 0.2)
        moon.name = "moon"
        moon.position = SCNVector3(x:0.2 , y: 0, z: 0)
        //rotateObject(rotation: 0.5, planet: moon, duration: 0.4)
        rotateMoon(rotation: 0.5, planet: moonRing, duration: 1)
        moonRing.position = SCNVector3(x:0.0 , y: 0.02, z: 0)
        moonRing.addChildNode(moon)

        
        let earthRing = createRing(ringSize: 0.7)
        let earth = createPlanet(radius: 0.1, image: "earth")
        earth.name = "Earth"
        earth.position = SCNVector3(x:0.7, y: 0, z: 0)
       // rotateObject(rotation: 0.25, planet: earth, duration: 0.4)
      //  rotateObject(rotation: 0.25, planet: earthRing, duration: 1)

        earth.addChildNode(moonRing)

        earthRing.addChildNode(earth)

     
     //   baseNode.addChildNode(moonRing)
        baseNode.addChildNode(sun)
        baseNode.addChildNode(earthRing)
        baseNode.position = SCNVector3(x: 0 ,y: -0.5 ,z: -1)
        scene.rootNode.addChildNode(baseNode)
    }
    
    func createPlanet(radius: Float, image: String) -> SCNNode{
        let planet = SCNSphere(radius: CGFloat(radius))
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "\(image).jpg")
        planet.materials = [material]
    
        let planetNode = SCNNode(geometry: planet)
        
        
        return planetNode
    }
    

  
    
    func rotateMoon(rotation: Float, planet: SCNNode, duration: Float){
//        let rotation = SCNAction.rotateBy(x:0,y:CGFloat(rotation),z:0, duration: TimeInterval(duration))
        let angle = CGFloat(-90.0 * .pi / 180)
        let rotation = SCNAction.rotateBy(x: 0, y: angle, z: 0, duration: TimeInterval(duration))
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
    var body: some View {
        
        NavigationView {
                
            VStack{
                
                Button {
                  //  rotateMoon(rotation: 0.5, planet: moonRing, duration: 1)
                } label: {
                    Text("달이동시키기")
                }

                
                SceneView(scene: scene,options: [.autoenablesDefaultLighting, .allowsCameraControl])
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2)
            }
            // 지구 태양 달 
            
            VStack {
                    
                Slider(value: $progress, in: -0.2...1, step: 0.1)

        
                GeometryReader{ proxy in
                    
                    let size = proxy.size
                    
                    ZStack{
                        
                 
                        
                        WaterWave(progress: $progress, waveHeight: 0.1, offset: startAnimation)
                            .fill(Color.blue)
                    }.frame(width: size.width, height: size.height, alignment: .center)
                        .onAppear {
                            withAnimation(.linear(duration: 6).repeatForever(autoreverses : false)){
                                startAnimation = size.width*1.5
                            }
                        }
                }
           

            }
        
          
            
        }
    }
}


struct WaterWave : Shape {
    
    @Binding var progress : CGFloat
    var waveHeight : CGFloat
    
    var offset : CGFloat
    
    var animatableData: CGFloat {
        get{offset}
        set{offset = newValue}
    }
    func path(in rect: CGRect) -> Path {
        return Path{ path in
            
            path.move(to: .zero)
            
            
            let progressHeight : CGFloat = (1 - progress) * rect.height
            let height = waveHeight * rect.height
            
            for value in stride(from: 0, to: rect.width, by: 2){
                let x : CGFloat = value
                let sine : CGFloat = sin(Angle(degrees :0.3*value + offset).radians)
                let y : CGFloat = progressHeight + (height * sine)
                
                path.addLine(to: CGPoint(x: x, y: y))
                
            }
            
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
        }
    }
}
