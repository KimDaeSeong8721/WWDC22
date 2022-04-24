import SwiftUI
import SpriteKit
import SceneKit
import AVFoundation


struct ContentView: View {
    
    @State var progress : CGFloat = 0.8
    @State var startAnimation : CGFloat = 0
    @State var angleMultiplyer : Int = 1
    @State var earthRotating : Int = 1
    @State var isMoonStopped : IsMoonStopped = .MOVE
    @State var windCount : CGFloat = 1
    @State var isGraduationTapped : Bool = false
    @State var isMusicOn : Bool = false
    @State var player : AVAudioPlayer!
    @State var time : String = "12:00"
    @State var moonEmoji : String = "🌑"

    
    var SkyColors : [Color] {
        switch earthRotating {
        case 1 :
            return [.white, .blue]
        case 2 :
            return [.orange,.red, .blue]
        case 3 :
            return [.black, .blue]
        case 4 :
            return [.blue,.orange, .white]

        default:
            return [.white, .blue]
        
        }
    }

    
    init(){
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    var body: some View {
        
        NavigationView {
                
            VStack(spacing:10){

               Spacer()
                
                HStack(spacing : 30) {
                
                // Earth Move
                Button {
                    earthRotating = (earthRotating) % 4 + 1
                    isMoonStopped = .STOP
                    
                    switch earthRotating {
                    case 2 :
                        time = "18:00"
                    case 3 :
                        time = "24:00"
                    case 4 :
                        time = "6:00"
                    default:
                        time = "12:00"

                    }
                    
                    if angleMultiplyer % 2 != 0 {
                        if abs(angleMultiplyer-earthRotating) % 2 == 0 {
                            progress = 0.8
                        }
                        else{
                            progress = 0.1
                        }
                    } else{
                        if abs(angleMultiplyer-earthRotating) % 2 == 0 {
                            progress = 0.4
                        }
                        else{
                            progress = 0.1
                        }
                    }
                   
                } label: {
                    Label {
                        Text("Move")
                    } icon: {
                        Image(systemName: "globe.europe.africa.fill")
                    }
                    .foregroundColor(.white)

                }
                
                    // Moon Move
                Button {
                   
                    angleMultiplyer = (angleMultiplyer) % 4 + 1
                   
                    progress = angleMultiplyer % 2 == 0 ? 0.4 : 0.8

                    isMoonStopped = .MOVE
 
                    switch angleMultiplyer {
                    case 2 :
                        moonEmoji = "🌓"
                    case 3 :
                        moonEmoji = "🌕"
                    case 4 :
                        moonEmoji = "🌗"
                    default:
                        moonEmoji = "🌑"

                    }
                } label: {
                    
                    Label {
                        Text("Move")
                    } icon: {
                        Image(systemName: "moon.circle.fill")
                    }
                    .foregroundColor(.white)
                 
                }
                
            }
                
                Label {
                    Text("Graduation")
                } icon: {
                    Image(systemName: "chart.xyaxis.line")
                }
                .onTapGesture {
                    isGraduationTapped.toggle()
                    if isMoonStopped == .MOVE {
                    isMoonStopped = .EXTRA
                    }
                }
                .foregroundColor(.white)
                .padding(.vertical)
                SceneKitView(angleMultiplyer: $angleMultiplyer,earthRotating : $earthRotating ,isMoonStopped: $isMoonStopped)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2)
                    .padding()
                
                
                Text("\(moonEmoji) \(isMoonStopped != .STOP ? "" : time)")
                    .font(.title)
                    .foregroundColor(.white)
                    .bold()
                
                Spacer()

            }
            .navigationTitle("Position with S,E,M")
            .navigationBarTitleDisplayMode(.inline)
            .background(.black)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isMusicOn.toggle()
                        
                        if isMusicOn {
                            playSound()
                            if isMoonStopped == .MOVE {
                            isMoonStopped = .EXTRA
                            }                        } else{
                            player?.stop()
                        }
                    } label: {
                        Image(systemName: isMusicOn ? "speaker.wave.2.fill": "speaker.slash.fill")
                            .foregroundColor(.white)
                    }
                }
            })
            // 지구 태양 달
            
            VStack {
      
                GeometryReader{ proxy in
                    
                    let size = proxy.size
                    
                    ZStack{
                
                        WaterWave(progress: $progress, waveHeight: 0.1, offset: startAnimation)
                            .fill(Color.blue)
                        
                        if isGraduationTapped{
                        GraduationView()
                            .frame(width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height)
                        }
                    }.frame(width: size.width, height: size.height, alignment: .center)
                        .onAppear {
                            withAnimation(.easeIn(duration: 6).repeatForever(autoreverses : false)){
                                startAnimation = size.width*1.5
                            }
                        }
                }
           

            }
            .background(LinearGradient(gradient: Gradient(colors: isMoonStopped == .STOP ? SkyColors : [.white, .blue]), startPoint: .top, endPoint: .bottom))
           
          
            
        }.navigationViewStyle(.columns)
            
        
    }
    
    func playSound(){
        let url = Bundle.main.url(forResource: "waveMusic", withExtension: "mp3")
        
        guard  url != nil else{
            return
        }
        do{
            player = try AVAudioPlayer(contentsOf: url!)
            player?.play()
            
        }
        catch{
            print("error")
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
