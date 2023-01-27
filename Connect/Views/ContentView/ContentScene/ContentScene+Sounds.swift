//
//  ContentScene+Sounds.swift
//  Connect
//
//  Created by Gustavo Kumasawa on 23/04/22.
//

import SpriteKit

extension ContentScene {
    func playConnectionSound() {
        self.run(
            .playSoundFileNamed(Sounds.getFileName(for: .connection), waitForCompletion: false),
            withKey: ActionKeys.connectionSoundAction
        )
    }
    
    func playDistantConnectionSound() {
        self.run(
            .playSoundFileNamed(
                Sounds.getFileName(for: .distantConnection),
                waitForCompletion: false
            ),
            withKey: ActionKeys.connectionSoundAction
        )
    }
    
    func playCutSound() {
        self.run(
            .playSoundFileNamed(Sounds.getFileName(for: .cut), waitForCompletion: false),
            withKey: ActionKeys.cutSoundAction
        )
    }
    
    func playTapSound() {
        self.run(
            .playSoundFileNamed(Sounds.getFileName(for: .tap), waitForCompletion: false),
            withKey: ActionKeys.tapSoundAction
        )
    }
    
    func playZoomInSound() {
        zoomInSoundPlayer?.volume = 1
        zoomInSoundPlayer?.play()
    }
    
    func playZoomOutSound() {
        zoomOutSoundPlayer?.volume = 1
        zoomOutSoundPlayer?.play()
    }
    
    func stopZoomInSound() {
        zoomInSoundPlayer?.setVolume(0.2, fadeDuration: 1)
    }
    
    func stopZoomOutSound() {
        zoomOutSoundPlayer?.setVolume(0.2, fadeDuration: 1)
    }
}
