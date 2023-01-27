//
//  StoryProgress.swift
//  Connect
//
//  Created by Gustavo Kumasawa on 18/04/22.
//

import Foundation

protocol StoryProgressDelegate: AnyObject {
    func showText(onCompletion: @escaping () -> Void)
}

class StoryProgress {
    weak var delegate: StoryProgressDelegate?
    let tips: Tips
    
    var canCreateConnection: Bool = true
    var canTapOnConnection: Bool = false
    var canCutConnectionLine: Bool = false
    var canZoomInOrZoomOut: Bool = false
    var canCreateDistantConnection: Bool = false
    var completedAllStory: Bool = false
    
    var connectionsCreated: Int = 0
    var connectionsTapped: Int = 0
    var connectionsCut: Int = 0
    var distantConnectionsMade: Int = 0
    
    init(delegate: StoryProgressDelegate, tips: Tips) {
        self.delegate = delegate
        self.tips = tips
    }
    
    private var _step: Int = 0
    var step: Int {
        get {
            return _step
        }
        set {
            switch newValue {
            case 1:
                canTapOnConnection = true
                tips.dismiss()
                delegate?.showText(onCompletion: {
                    self.tips.showTap()
                })
            case 2:
                canCutConnectionLine = true
                tips.dismiss()
                delegate?.showText(onCompletion: {
                    self.tips.showCut()
                })
            case 3:
                canZoomInOrZoomOut = true
                tips.dismiss()
                delegate?.showText(onCompletion: {
                    self.tips.showZoom()
                })
            case 4:
                canCreateDistantConnection = true
                completedAllStory = true
                tips.dismiss()
                delegate?.showText(onCompletion: {
                    self.tips.showConnectDistant()
                })
            case 5:
                tips.dismiss()
                delegate?.showText(onCompletion: {
                    self.tips.showExplore()
                })
                _step = newValue
                return
            default:
                return
            }
            
            _step = newValue
        }
    }
    
    func createdConnection() {
        if step != 0 {
            return
        }
        
        if connectionsCreated < 2 {
            connectionsCreated += 1
            return
        }
        
        step += 1
    }
    
    func tappedOnConnection() {
        if step != 1 {
            return
        }
        
        if connectionsTapped < 2 {
            connectionsTapped += 1
            return
        }
        
        step += 1
    }
    
    func cutConnectionLine() {
        if step != 2 {
            return
        }
        
        if connectionsCut < 2 {
            connectionsCut += 1
            return
        }
        
        step += 1
    }
    
    func zoomedOut() {
        if step != 3 {
            return
        }
        
        step += 1
    }
    
    func createdDistantConection() {
        if step != 4 {
            return
        }
        
        if distantConnectionsMade < 2 {
            distantConnectionsMade += 1
            return
        }
        
        step += 1
    }
}
