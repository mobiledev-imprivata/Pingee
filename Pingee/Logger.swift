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

var dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "HH:mm:ss.SSS"
    return df
}()

func log(_ message: String) {
    let timestamp = dateFormatter.string(from: Date())
    let text = "[\(timestamp)] \(message)"
    print(text)
}

func log(_ component: Component, _ message: String) {
    let timestamp = dateFormatter.string(from: Date())
    print("[\(timestamp)] \(component.rawValue.uppercased().padding(toLength: 4, withPad: " ", startingAt: 0)) \(message)")
    NotificationCenter.default.post(name: Notification.Name(rawValue: newMessageNotification), object: nil, userInfo: ["message": message])
}
