//
//  SubscribeTestViewController.swift
//  R5ProTestbed
//
//  Created by Andy Zupko on 12/16/15.
//  Copyright © 2015 Infrared5. All rights reserved.
//

import UIKit
import R5Streaming

@objc(SubscribeAutoReconnectTest)
class SubscribeAutoReconnectTest: BaseTest {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        setupDefaultR5VideoViewController()
        
        self.Subscribe()
        
    }
    
    func Subscribe(){
        
        let config = getConfig()
        // Set up the connection and stream
        let connection = R5Connection(config: config)
        self.subscribeStream = R5Stream(connection: connection)
        self.subscribeStream!.delegate = self
        self.subscribeStream?.client = self;
        
        currentView?.attach(subscribeStream)
        
        
        self.subscribeStream!.play(Testbed.getParameter(param: "stream1") as! String)
        

        
    }
    
    override func onR5StreamStatus(_ stream: R5Stream!, withStatus statusCode: Int32, withMessage msg: String!) {
        
        super.onR5StreamStatus(stream, withStatus: statusCode, withMessage: msg)
        
 
        
        if(statusCode == Int32(r5_status_connection_error.rawValue)){
            
            //we can assume it failed here!
        
            NSLog("Connection error")
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { () -> Void in
                self.Subscribe()
            }
        }
        
    }
    
    
    func onMetaData(_ data : String){
        
    }
    
    
    
}
