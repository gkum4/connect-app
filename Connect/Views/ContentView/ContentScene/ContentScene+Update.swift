//
//  ContentScene+Update.swift
//  Connect
//
//  Created by Gustavo Kumasawa on 13/04/22.
//

import SpriteKit

extension ContentScene {
    override func didSimulatePhysics() {
        for line in lines {
            line.update()
        }
    }
}
