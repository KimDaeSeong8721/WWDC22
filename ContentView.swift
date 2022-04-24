import SwiftUI
import SpriteKit
import SceneKit
import AVFoundation


struct ContentView: View {
    // MARK: - properties
    @State var progress : CGFloat = 0.8
    @State var startAnimation : CGFloat = 0
    @State var angleMultiplyer : AbsoluteDirec = .WEST
    @State var earthRotating : AbsoluteDirec = .WEST
    @State var isMoonStopped : IsMoonStopped = .MOVE
    @State var windCount : CGFloat = 1
    @State var isGraduationTapped : Bool = false
    @State var isMusicOn : Bool = false
    @State var player : AVAudioPlayer!
    @State var time : String = "12:00"
    @State var moonEmoji : String = "🌑"
    
    
    var SkyColors : [Color] {
        switch earthRotating {
        case .WEST :
            return [.white, .blue]
        case .SOUTH :
            return [.orange,.red, .blue]
        case .EAST :
            return [.black, .blue]
        case .NORTH :
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
            
            // MARK: - FirstView
            VStack(spacing:10){
                
                Spacer()
                
                HStack(spacing : 30) {
                    
                    // Earth Move
                    Button {
                        earthRotating = AbsoluteDirec(rawValue: (earthRotating.rawValue) % 4 + 1)!
                        print(earthRotating)
                        isMoonStopped = .STOP
                        
                        switch earthRotating {
                        case .SOUTH :
                            time = "18:00"
                        case .EAST :
                            time = "24:00"
                        case .NORTH :
                            time = "6:00"
                        default:
                            time = "12:00"
                            
                        }
                        
                        if angleMultiplyer.rawValue % 2 != 0 {
                            if abs(angleMultiplyer.rawValue-earthRotating.rawValue) % 2 == 0 {
                                progress = 0.8
                            }
                            else{
                                progress = 0.1
                            }
                        } else{
                            if abs(angleMultiplyer.rawValue - earthRotating.rawValue) % 2 == 0 {
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
                        
                        angleMultiplyer = AbsoluteDirec(rawValue:(angleMultiplyer.rawValue) % 4 + 1)!
                        
                        progress = angleMultiplyer.rawValue % 2 == 0 ? 0.4 : 0.8
                        
                        isMoonStopped = .MOVE
                        
                        switch angleMultiplyer {
                        case .SOUTH :
                            moonEmoji = "🌓"
                        case .EAST :
                            moonEmoji = "🌕"
                        case .NORTH :
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
                // Graduation
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
                
                // SCNSceneView
                SceneKitView(angleMultiplyer: $angleMultiplyer,earthRotating : $earthRotating ,isMoonStopped: $isMoonStopped)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2)
                    .padding()
                
                // Moonshape and Time
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
            
            
            // MARK: - SecondView
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



