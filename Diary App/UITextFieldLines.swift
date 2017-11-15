//
//  UITextFieldLines.swift
//  Diary App
//
//  Created by Angus Muller on 15/11/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//


import UIKit

class UnderlinedTextView: UITextView {
    var lineHeight: CGFloat = 13.8
    
    override var font: UIFont? {
        didSet {
            if let newFont = font {
                lineHeight = newFont.lineHeight
            }
        }
    }
    /* Trying out line spacing
    override func didMoveToWindow() {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 20
        let attributes = [NSAttributedStringKey.paragraphStyle : style]
        self.attributedText = NSAttributedString(string: "dd", attributes: attributes)
    }
    */
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        
        let numberOfLines = Int(rect.height / lineHeight)
        let topInset = textContainerInset.top
        
        for i in 1...numberOfLines {
            let y = topInset + CGFloat(i) * lineHeight
            
            let line = CGMutablePath()
            line.move(to: CGPoint(x: 0.0, y: y))
            line.addLine(to: CGPoint(x: rect.width, y: y))
            
            ctx?.addPath(line)
        }
        
        ctx?.strokePath()
        
        super.draw(rect)
    }
}
