//
//  PlayerSelectViewController.swift
//  AirHockeyProject
//
//  Created by uics13 on 4/13/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import UIKit

class PlayerSelectViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rect = CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: self.view.bounds.width, height: self.view.bounds.height/2))
        let test = TwoPBaseView(frame: rect)
        
        test.BackButton.hidden = true
        test.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        self.view.addSubview(test)

        // Do any additional setup after loading the view, typically from a nib.
        let rect2 = CGRect(origin: CGPoint(x: 0,y: (self.view.bounds.height/2)), size: CGSize(width: self.view.bounds.width, height: self.view.bounds.height/2))
        
        let test2 = TwoPBaseView(frame: rect2)
        self.view.addSubview(test2)
        self.navigationController!.interactivePopGestureRecognizer.enabled = false
        self.navigationController!.interactivePopGestureRecognizer.delegate = SwipeDelegate


    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

