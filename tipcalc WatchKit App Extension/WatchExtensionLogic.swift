//
//  WatchExtensionLogic.swift
//  tipcalc WatchKit App Extension
//
//  Created by Jonathan Wong on 3/25/18.
//  Copyright © 2018 Jonathan Wong. All rights reserved.
//

import WatchConnectivity

class WatchExtensionLogic: NSObject {
    
    func setupWatchConnectivity() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
}

extension WatchExtensionLogic: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activateion failed with error: \(error.localizedDescription)")
            return
        }
        print("WCSession activiated with state: \(activationState.rawValue)")
    }


}
