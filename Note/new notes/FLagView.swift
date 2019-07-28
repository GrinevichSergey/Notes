//
//  FLagView.swift
//  Note
//
//  Created by Сергей Гриневич on 27/07/2019.
//  Copyright © 2019 Grinevich Sergey. All rights reserved.
//

import UIKit

@IBDesignable
class FlagView: UIView {
    private let color: UIColor = .black
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        isUserInteractionEnabled = false
        isHidden = true
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        color.setStroke()
        color.setFill()
        
        let pathCircle = getCircle(rect)
        pathCircle.lineWidth = 2
        pathCircle.stroke()
        
        let pathTick = getTick(rect)
        pathTick.lineWidth = 2
        pathTick.stroke()
        
        let pathDot = getDot(rect)
        pathDot.fill()
    }
    
    private func getCircle(_ rect: CGRect) -> UIBezierPath {
        return UIBezierPath(
            arcCenter: CGPoint(x: rect.midX,y: rect.midY),
            radius: CGFloat(rect.width / 4),
            startAngle: CGFloat(0),
            endAngle: CGFloat(Double.pi * 2),
            clockwise: true
        )
    }
    
    private func getTick(_ rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: rect.midX - 3, y: rect.midY + 5))
        path.addLine(to: CGPoint(x: rect.midX - 8, y: rect.midY))
        
        path.move(to: CGPoint(x: rect.midX - 3, y: rect.midY + 5))
        path.addLine(to: CGPoint(x: rect.midX + 7, y: rect.midY - 5))
        
        return path
    }
    
    private func getDot(_ rect: CGRect) -> UIBezierPath {
        return UIBezierPath(
            arcCenter: CGPoint(x: rect.midX - 3,y: rect.midY + 5),
            radius: CGFloat(1),
            startAngle: CGFloat(0),
            endAngle: CGFloat(Double.pi * 2),
            clockwise: true
        )
    }
}
