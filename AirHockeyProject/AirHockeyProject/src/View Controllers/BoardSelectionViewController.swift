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
    private var selectedView : ThemeView?
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        self.navigationController!.interactivePopGestureRecognizer.enabled = false

        
        let horizontalSpacing : CGFloat = 10
        let verticalSpacing : CGFloat = 10
        let tablesPerRow = 2
        scrollView.frame.size.width = self.view.frame.size.width
        
        let startHeight : CGFloat = 0
        
        let frameWidth = ( self.view.frame.width / CGFloat(tablesPerRow) ) - ( horizontalSpacing * (CGFloat(tablesPerRow) + 1)  )
        let frameHeight = (self.view.frame.height / 2 ) - ( verticalSpacing )
        
        
        
        super.viewDidLoad()
        themes = Themes().getAllThemes()
       
        var frame = CGRect(origin: CGPoint(x: 0,y: startHeight - (verticalSpacing + frameHeight)), size: CGSize(width: frameWidth, height: frameHeight))
        var counter = 0
        var rows = 0
        for theme in themes {
            
            if (counter % tablesPerRow)==0 {
                rows = rows  + 1
                frame.origin.x = horizontalSpacing
                frame.origin.y = frame.origin.y + verticalSpacing + frameHeight
            
            } else {
                frame.origin.x = horizontalSpacing + frameWidth + frame.origin.x
            }
            
            var nextView = ThemeView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: frame.size))
            nextView.center = CGPoint(x: frame.origin.x + (frame.width/2), y: frame.origin.y + (frame.height/2))
            nextView.configure(theme)
            nextView.layer.borderWidth = 3
            scrollView.addSubview(nextView)
            counter = counter + 1
            
        }
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: CGFloat(rows) * (frameHeight + verticalSpacing))
        
    }
  
    @IBAction func tapHandler(sender: UITapGestureRecognizer) {
        
        for view in scrollView.subviews {
            if let curView = view as? ThemeView {
                if curView.frame.contains(sender.locationInView(scrollView)) {
                    if (selectedView != nil) {
                        selectedView!.layer.borderColor = UIColor.blackColor().CGColor
                    }

                    selectedView = curView
                    selectedView!.layer.borderColor = UIColor.greenColor().CGColor
                    SoundManager().playButtonPressedSound()
                }
            }
            
        }
    }
    
}