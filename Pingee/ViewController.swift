//
//  ViewController.swift
//  Pingee
//
//  Created by Jay Tucker on 1/8/18.
//  Copyright © 2018 Imprivata. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    private var bluetoothManager: BluetoothManager!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.appendMessage(_:)), name: NSNotification.Name(rawValue: newMessageNotification), object: nil)

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.isCoreLocationEventLaunch {
            log(.app, "app launched in response to a CoreLocation event")
            appDelegate.showNotification("app launched in response to a CoreLocation event")
        }
        
        log(.vc, "viewDidLoad")
        bluetoothManager = BluetoothManager()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func appendMessage(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let message = userInfo["message"] as? String else { return }
        DispatchQueue.main.async {
            let newText = self.textView.text + "\n" + message
            self.textView.text = newText
            self.textView.scrollRangeToVisible(NSRange(location: newText.count, length: 0))
        }
    }
    
}

