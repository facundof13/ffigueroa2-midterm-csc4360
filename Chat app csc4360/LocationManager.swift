//
//  LocationManager.swift
//  Chat app csc4360
//
//  Created by Facundo Figueroa on 3/7/22.
//

import CoreLocation
import CoreLocationUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    @Published var location: CLLocationCoordinate2D?
    private var chatUserLocationViewModel = ChatUserLocationViewModel()
    
    override init() {
        super.init()
        manager.delegate = self
    }

    func requestLocation(chatUser: ChatUser?) {
        manager.requestLocation()
        if let location = self.location, let chatUser = chatUser {
            chatUserLocationViewModel.saveUserLocation(chatUser: chatUser, location: location)
        }
//        if let chatUser = chatUser {
//
//        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status == .authorizedWhenInUse {
                self.requestLocation(chatUser: nil)
            }
        }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
    }
}

extension CLLocationCoordinate2D: Equatable {
    static public func ==(lhs: Self, rhs: Self) -> Bool {
        true
    }
}
