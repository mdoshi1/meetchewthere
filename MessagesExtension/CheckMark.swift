//
//  CheckMark.swift
//  meetchewthere
//
//  Created by Michael-Anthony Doshi on 1/29/17.
//  Copyright © 2017 Alejandrina Gonzalez Reyes. All rights reserved.
//

import UIKit

class CheckMark: UIView {
    
    private var checked = false
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if checked {
            drawRectChecked(rect)
        } else {
            drawRectOpenCircle(rect)
        }
    }
    
    func setChecked(_ checked: Bool) {
        self.checked = checked
        setNeedsDisplay()
    }
    
    func drawRectChecked(_ rect: CGRect) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()
        //// Color Declarations
        let checkmarkBlue2 = UIColor.chewBlue
        //// Shadow Declarations
        let shadow2 = UIColor.black
        let shadow2Offset = CGSize(width: CGFloat(0.1), height: CGFloat(-0.1))
        let shadow2BlurRadius: CGFloat = 2.5
        //// Frames
        let frame: CGRect = self.bounds
        //// Subframes
        let group = CGRect(x: CGFloat(frame.minX + 3.0), y: CGFloat(frame.minY + 3.0), width: CGFloat(frame.width - 6), height: CGFloat(frame.height - 6.0))
        //// CheckedOval Drawing
        let x = CGFloat(group.minX + floor(group.width * 0.00000 + 0.5))
        let y = CGFloat(group.minY + floor(group.height * 0.00000 + 0.5))
        let width = CGFloat(floor(group.width * 1.00000 + 0.5) - floor(group.width * 0.00000 + 0.5))
        let height = CGFloat(floor(group.height * 1.00000 + 0.5) - floor(group.height * 0.00000 + 0.5))
        let checkedOvalPath = UIBezierPath(ovalIn: CGRect(x: x, y: y, width: width, height: height))
        context?.saveGState()
        context?.setShadow(offset: shadow2Offset, blur: shadow2BlurRadius, color: shadow2.cgColor)
        checkmarkBlue2.setFill()
        checkedOvalPath.fill()
        context?.restoreGState()
        UIColor.white.setStroke()
        checkedOvalPath.lineWidth = 1
        checkedOvalPath.stroke()
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: CGFloat(group.minX + 0.27083 * group.width), y: CGFloat(group.minY + 0.54167 * group.height)))
        bezierPath.addLine(to: CGPoint(x: CGFloat(group.minX + 0.41667 * group.width), y: CGFloat(group.minY + 0.68750 * group.height)))
        bezierPath.addLine(to: CGPoint(x: CGFloat(group.minX + 0.75000 * group.width), y: CGFloat(group.minY + 0.35417 * group.height)))
        bezierPath.lineCapStyle = .square
        UIColor.white.setStroke()
        bezierPath.lineWidth = 1.3
        bezierPath.stroke()
    }
    
    func drawRectOpenCircle(_ rect: CGRect) {
        //// General Declarations
        let context: CGContext? = UIGraphicsGetCurrentContext()
        //// Shadow Declarations
        let shadow = UIColor.black
        let shadowOffset = CGSize(width: CGFloat(0.1), height: CGFloat(-0.1))
        let shadowBlurRadius: CGFloat = 0.5
        let shadow2 = UIColor.black
        let shadow2Offset = CGSize(width: CGFloat(0.1), height: CGFloat(-0.1))
        let shadow2BlurRadius: CGFloat = 2.5
        //// Frames
        let frame: CGRect = self.bounds
        //// Subframes
        let group = CGRect(x: CGFloat(frame.minX + 3), y: CGFloat(frame.minY + 3), width: CGFloat(frame.width - 6), height: CGFloat(frame.height - 6))
        //// Group
        //// EmptyOval Drawing
        let x = CGFloat(group.minX + floor(group.width * 0.00000 + 0.5))
        let y = CGFloat(group.minY + floor(group.height * 0.00000 + 0.5))
        let width = CGFloat(floor(group.width * 1.00000 + 0.5) - floor(group.width * 0.00000 + 0.5))
        let height = CGFloat(floor(group.height * 1.00000 + 0.5) - floor(group.height * 0.00000 + 0.5))
        let emptyOvalPath = UIBezierPath(ovalIn: CGRect(x: x, y: y, width: width, height: height))
        context?.saveGState()
        context?.setShadow(offset: shadow2Offset, blur: shadow2BlurRadius, color: shadow2.cgColor)
        context?.restoreGState()
        context?.saveGState()
        context?.setShadow(offset: shadowOffset, blur: shadowBlurRadius, color: shadow.cgColor)
        UIColor.white.setStroke()
        emptyOvalPath.lineWidth = 1
        emptyOvalPath.stroke()
        context?.restoreGState()
    }
}
