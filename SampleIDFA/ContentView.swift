//
//  ContentView.swift
//  SampleIDFA
//
//  Created by Nishant Bhasin on 2020-07-05.
//

import SwiftUI
import Foundation
import AppTrackingTransparency
import AdSupport
import UIKit

struct ContentView: View {
    let viewModel = TrackingViewModel()
    static var idfa: UUID {
        return ASIdentifierManager.shared().advertisingIdentifier
    }
    @State var topText = "IDFA will be displayed here"
    @State var buttonText = "Request IDFA"
    var body: some View {
        VStack {
            Text(topText).padding()
            Button(action: {
                // Requesting IDFA from the user
                // This dialog is only shown once per install
                
                // 1st step:
                // We check if dialog has already been shown
                if viewModel.shouldShowAppTrackingDialog() {
                    print("We can show dialog and ask for permission")
                    viewModel.requestAppTrackingPermission { (status) in
                        viewModel.updateCurrentStatus()
                        if viewModel.isAuthorized() {
                            buttonText = "Tap to show IDFA"
                        }
                    }
                } else {
                    print("App Tracking dialog has already been shown")
                    print("Check if Authorized or Denied")
                    print("Authorized: \(viewModel.isAuthorized())")
                    if(viewModel.isAuthorized()) {
                        print("Since we are authorized: IDFA \(viewModel.getIDFA().uuidString)")
                        topText = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                    } else {
                        print("We take user to the settings as we can only show dialog ones and they have denied it.")
                        print("User should be told to enable - \("Allow Cross App Tracking Option")")
                        buttonText = "Open settings: Allow Cross App Tracking"
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    }
                }
            }) {
                Text(buttonText)
            }
        }.onAppear {
            // Update the button text based on the IDFA authorization state
            if viewModel.isAuthorized() {
                buttonText = "Tap to show IDFA"
            } else if viewModel.shouldShowAppTrackingDialog() {
                buttonText = "Request IDFA"
            } else {
                buttonText = "Open settings: Allow Cross App Tracking"
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
