//
//  WatchLogic.swift
//  tipcalc
//
//  Created by Jonathan Wong on 3/25/18.
//  Copyright © 2018 Jonathan Wong. All rights reserved.
//

import Foundation
import WatchConnectivity

class WatchLogic: NSObject {
    
    func setupWatchConnectivity() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
}

extension WatchLogic: WCSessionDelegate {
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("WCSession did deactivate")
        WCSession.default.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed with error: \(error.localizedDescription)")
            return
        }
        print("WCSession activated with state: \(activationState.rawValue)")
    }
    
    func sendTipInfo(_ notification: Notification) {
        if WCSession.isSupported() {
            
        }
    }
}
