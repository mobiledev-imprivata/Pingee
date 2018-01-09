//
//  Logger.swift
//  Pingee
//
//  Created by Jay Tucker on 1/8/18.
//  Copyright © 2018 Imprivata. All rights reserved.
//

import Foundation

let newMessageNotification = "com.imprivata.newMessage"

enum Component: String {
    case app, vc, beac, btle
}

func timestamp() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss.SSS"
    return dateFormatter.string(from: Date())
}

func log(_ component: Component, _ message: String) {
    print("[\(timestamp())] \(component.rawValue.uppercased().padding(toLength: 4, withPad: " ", startingAt: 0)) \(message)")
    NotificationCenter.default.post(name: Notification.Name(rawValue: newMessageNotification), object: nil, userInfo: ["message": message])
}
