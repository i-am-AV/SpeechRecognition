//
//  UIView+.swift
//  SpeechRecognition
//
//  Created by  Alexander on 22.09.2020.
//

import UIKit

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UIButton {
    
    private enum Constants {
        static let shadowColor =  UIColor(red: 58/255,
                                          green: 131/255,
                                          blue: 241/255,
                                          alpha: 1)
    }
    
    func addShadow() {
        self.layer.shadowColor = Constants.shadowColor.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 4
    }
    
    func removeShadow() {
        self.layer.shadowRadius = 0
    }
}
