import SwiftUI
import SpriteKit

struct ContentView: View {
    var contentScene: ContentScene {
        let scene = ContentScene()
        scene.scaleMode = .aspectFit
        scene.anchorPoint = .init(x: 0.5, y: 0.5)
        
        let sceneWidth = UIScreen.main.bounds.size.width
        let sceneHeight = UIScreen.main.bounds.size.height
        scene.size = CGSize(width: sceneWidth, height: sceneHeight)
        
        scene.backgroundColor = .black
        
        return scene
    }
    
    var body: some View {
        SpriteView(scene: contentScene)
            .ignoresSafeArea()
    }
}
