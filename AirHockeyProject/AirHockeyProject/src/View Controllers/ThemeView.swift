//
//  ThemeView.swift
//  AirHockeyProject
//
//  Created by divms on 4/5/15.
//  Copyright (c) 2015 divms. All rights reserved.
//

import Foundation
import UIKit

class ThemeView : UIView {
    private var theme : Theme!
   
    @IBOutlet weak var boardImage: UIImageView!
    @IBOutlet weak var boardNameField: UILabel!
   
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet var contentView: UIView!
    
  
    func configure(t : Theme) {
        theme = t
        boardNameField.text = t.boardName
        boardNameField.font = UIFont(name: theme.fontName!, size: boardNameField.font.pointSize)
        
        boardImage.image = UIImage(contentsOfFile: theme.getTableImageFile())
        backgroundImage.image = UIImage(contentsOfFile: theme.getBackgroundImageFile())
    }
    
    override init() {
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        NSBundle.mainBundle().loadNibNamed("ThemeView", owner: self, options: nil)
        self.addSubview(self.contentView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        NSBundle.mainBundle().loadNibNamed("ThemeView", owner: self, options: nil)
        
        self.bounds = self.contentView.bounds

        self.addSubview(self.contentView)
    }
    
   
}