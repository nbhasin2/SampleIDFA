//
//  TrackingViewModel.swift
//  SampleIDFA
//
//  Created by Nishant Bhasin on 2020-07-09.
//

import Foundation
import AppTrackingTransparency
import AdSupport

enum TrackingPersmissionStatus: String {
    case authorized
    case denied
    case notDetermined
    case unknown
}

class TrackingViewModel {
    var trackingModelStatus: TrackingPersmissionStatus = .notDetermined
    var trackingManagerStatus: ATTrackingManager.AuthorizationStatus {
        return ATTrackingManager.trackingAuthorizationStatus
    }
    init() {
        updateCurrentStatus()
    }
    
    func updateCurrentStatus()  {
        let status = ATTrackingManager.trackingAuthorizationStatus
        switch status {
        case .authorized:
            // racking authorization dialog was shown and we are authorized
            print("Authorized")
            trackingModelStatus = .authorized
        case .denied:
            // Tracking authorization dialog was shown and permission is denied
            print("Denied")
            trackingModelStatus = .denied
        case .notDetermined:
            // Tracking authorization dialog has not been shown
            print("Not Determined")
            trackingModelStatus = .notDetermined
        case .restricted:
            print("Restricted")
            trackingModelStatus = .denied
        @unknown default:
            print("Unknown")
            trackingModelStatus = .unknown
        }
    }

    func shouldShowAppTrackingDialog() -> Bool {
        let status = ATTrackingManager.trackingAuthorizationStatus
        guard status != .notDetermined else {
            return true
        }
        return false
    }
    
    func isAuthorized() -> Bool {
        return trackingManagerStatus == .authorized
    }
    
    func requestPermission() {
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .authorized:
                // racking authorization dialog was shown and we are authorized
                print("Authorized")
            case .denied:
                // Tracking authorization dialog was shown and permission is denied
                print("Denied")
            case .notDetermined:
                // Tracking authorization dialog has not been shown
                print("Not Determined")
            case .restricted:
                print("Restricted")
            @unknown default:
                print("Unknown")
            }
        }
    }
    
    func getIDFA() -> UUID {
        return ASIdentifierManager.shared().advertisingIdentifier
    }
    
    func requestAppTrackingPermission(_ completion: @escaping (ATTrackingManager.AuthorizationStatus) -> Void) {
        ATTrackingManager.requestTrackingAuthorization(completionHandler: completion)
    }
}
