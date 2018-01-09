//
//  BluetoothManager.swift
//  Pingee
//
//  Created by Jay Tucker on 1/9/18.
//  Copyright © 2018 Imprivata. All rights reserved.
//

import UIKit
import CoreBluetooth

final class BluetoothManager: NSObject {
    
    private let serviceUUID        = CBUUID(string: "3025E7A9-CC24-4B7C-B806-0F674D07E46C")
    private let characteristicUUID = CBUUID(string: "9476292B-5E5A-4CD4-BD3E-9B1E7B4DB12E")
    
    private var peripheralManager: CBPeripheralManager!
    
    private var uiBackgroundTaskIdentifier: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    
    override init() {
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    private func addService() {
        log(.btle, "addService")
        peripheralManager.stopAdvertising()
        peripheralManager.removeAllServices()
        let service = CBMutableService(type: serviceUUID, primary: true)
        let characteristic = CBMutableCharacteristic(type: characteristicUUID, properties: .read, value: nil, permissions: .readable)
        service.characteristics = [characteristic]
        peripheralManager.add(service)
    }
    
    private func startAdvertising() {
        log(.btle, "startAdvertising")
        peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [serviceUUID]])
    }
    
}

extension BluetoothManager: CBPeripheralManagerDelegate {
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        var caseString: String!
        switch peripheral.state {
        case .unknown:
            caseString = "unknown"
        case .resetting:
            caseString = "resetting"
        case .unsupported:
            caseString = "unsupported"
        case .unauthorized:
            caseString = "unauthorized"
        case .poweredOff:
            caseString = "poweredOff"
        case .poweredOn:
            caseString = "poweredOn"
        }
        log(.btle, "peripheralManagerDidUpdateState \(caseString!)")
        if peripheral.state == .poweredOn {
            addService()
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        let message = "peripheralManager didAddService " + (error == nil ? "ok" :  ("error " + error!.localizedDescription))
        log(.btle, message)
        if error == nil {
            startAdvertising()
        }
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        let message = "peripheralManagerDidStartAdvertising " + (error == nil ? "ok" :  ("error " + error!.localizedDescription))
        log(.btle, message)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        log(.btle, "peripheralManager didReceiveRead request")
        request.value = "Hello from Pingee!".data(using: .utf8, allowLossyConversion: false)
        peripheralManager.respond(to: request, withResult: .success)
    }
    
}
