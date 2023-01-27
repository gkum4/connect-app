//
//  Sounds.swift
//  Connect
//
//  Created by Gustavo Kumasawa on 23/04/22.
//

import Foundation

class Sounds {
    static func getFileName(for sound: Sounds) -> String {
        switch sound {
        case .connection:
            return "connection.mp3"
        case .distantConnection:
            return "distantConnection.mp3"
        case .cut:
            return "cut.mp3"
        case .tap:
            return "tap.mp3"
        case .zoomIn:
            return "zoomIn.mp3"
        case .zoomOut:
            return "zoomOut.mp3"
        }
    }
    
    enum Sounds {
        case connection
        case distantConnection
        case cut
        case tap
        case zoomIn
        case zoomOut
    }
}

