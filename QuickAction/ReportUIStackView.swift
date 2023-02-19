//
//  ReportUIStackView.swift
//  QuickAction
//
//  Created by Aman Dhruva Thamminana on 2/18/23.
//

import UIKit

class ReportUIStackView: UIStackView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
    self.myView.addGestureRecognizer(gesture)

    @objc func checkAction(sender : UITapGestureRecognizer) {
        // Do what you want
        
    }

}
