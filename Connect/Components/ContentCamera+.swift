//
//  ContentCamera+.swift
//  Connect
//
//  Created by Gustavo Kumasawa on 20/04/22.
//

import SpriteKit

extension ContentCamera {
    func addChild(_ textOverlay: TextOverlay) {
        node.addChild(textOverlay.node)
    }
}
