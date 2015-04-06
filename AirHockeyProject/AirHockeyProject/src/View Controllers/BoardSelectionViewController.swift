//
//  BoardSelectionViewController.swift
//  AirHockeyProject
//
//  Created by divms on 4/5/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import UIKit
class BoardSelectionViewController : UIViewController {
    private var themes : [Theme] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        themes = Themes().getAllThemes()
        println("view")
        var x = 0
        var y = 500
        for theme in themes {
            var nextView = ThemeView()
            
            x = x + 300
            nextView.configure(theme)
            self.view!.addSubview(nextView)
            nextView.center = CGPoint(x: x,y: y)
        }
        
        
        
    }
    
    
}