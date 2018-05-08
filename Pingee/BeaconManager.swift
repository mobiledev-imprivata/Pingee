//
//  BeaconManager.swift
//  Pingee
//
//  Created by Jay Tucker on 1/8/18.
//  Copyright © 2018 Imprivata. All rights reserved.
//

import Foundation
import CoreLocation

protocol BeaconManagerDelegate {
    func showNotification(_ message: String)
}

final class BeaconManager: NSObject {
    
    private let proximityUUID = UUID(uuidString: "0130C53E-97C1-421A-81C0-FC8F453295AD")!
    private let major: CLBeaconMajorValue = 123
    private let minor: CLBeaconMinorValue = 456
    private let identifier = "com.imprivata.pinger"
    
    private var beaconRegion: CLBeaconRegion!
    private var locationManager: CLLocationManager!
    
    var delegate: BeaconManagerDelegate?
    
    func startMonitoring() {
        log(.beac, "startMonitoring")
        
        guard beaconRegion == nil && locationManager == nil else {
            log(.beac, "already monitoring")
            return
        }
        
        guard CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) else {
            log(.beac, "monitoring is not available for CLBeaconRegion")
            return
        }
        
        guard CLLocationManager.isRangingAvailable() else {
            log(.beac, "ranging is not available for CLBeaconRegion")
            return
        }
        
        log(.beac, "authorizationStatus \(CLLocationManager.authorizationStatus())")
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.activityType = .other
        // locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestAlwaysAuthorization()
        
        log(.beac, "end of startMonitoring")
    }
    
    func stopMonitoring() {
        log(.beac, "stopMonitoring")
        
        guard beaconRegion != nil && locationManager != nil else {
            log(.beac, "already stopped")
            return
        }
        
        locationManager.stopMonitoring(for: beaconRegion)
        beaconRegion = nil
        locationManager = nil
    }
    
    private func startScanning() {
        log(.beac, "startScanning")
        beaconRegion = CLBeaconRegion(proximityUUID: proximityUUID, major: major, minor: minor, identifier: identifier)
        locationManager.startMonitoring(for: beaconRegion)
        // locationManager.requestStateForRegion(beaconRegion)
        // locationManager.startRangingBeaconsInRegion(beaconRegion)
    }
    
}

extension BeaconManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        log(.beac, "locationManager didChangeAuthorizationStatus \(status)")
        
        guard CLLocationManager.authorizationStatus()  == .authorizedAlways else {
            log(.beac, "status is not authorizedAlways")
            return
        }
        
        startScanning()
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        log(.beac, "locationManagerDidPauseLocationUpdates")
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        log(.beac, "locationManagerDidResumeLocationUpdates")
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        log(.beac, "locationManager didStartMonitoringForRegion")
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        log(.beac, "locationManager didEnterRegion")
        delegate?.showNotification("didEnterRegion")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        log(.beac, "locationManager didExitRegion")
        delegate?.showNotification("didExitRegion")
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        log(.beac, "locationManager didDetermineState \(state)")
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        log(.beac, "locationManager didRangeBeacons \(beacons.count)")
        guard beacons.count > 0 else {
            log(.beac, "no beacons found")
            return
        }
        log(.beac, "proximity \(beacons[0].proximity)")
    }
    
    // failures
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        log(.beac, "locationManager didFailWithError \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        log(.beac, "locationManager monitoringDidFailForRegion withError \(error)")
    }
    
}

extension CLAuthorizationStatus: CustomStringConvertible {

    public var description: String {
        switch self {
        case .notDetermined: return "notDetermined"
        case .restricted: return "restricted"
        case .denied: return "denied"
        case .authorizedAlways: return "authorizedAlways"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        }
    }
    
}

extension CLRegionState: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .unknown: return "unknown"
        case .inside: return "inside"
        case .outside: return "outside"
        }
    }
    
}

extension CLProximity: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .unknown: return "unknown"
        case .immediate: return "immediate"
        case .near: return "near"
        case .far: return "far"
        }
    }
    
}
