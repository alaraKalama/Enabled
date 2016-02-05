//
//  HairlineView.swift
//  DCKit
//
//  Created by Andrey Gordeev on 28/12/14.
//  Copyright (c) 2014 Andrey Gordeev (andrew8712@gmail.com). All rights reserved.
//

import UIKit

/// This view can be used as a thin/thick separator line between views.
@IBDesignable
public class DCHairlineView: UIView {
    
    /// A color of the line. Don't use background color.
    @IBInspectable public var color: UIColor = UIColor.blackColor()
    
    /// A width/height of the line.
    @IBInspectable public var width: CGFloat = 1.0
    
    /// True if we want to draw the horizontal line. False for vertical line.
    @IBInspectable public var horizontal: Bool = true
    
    // MARK: - Life cycle
    
    public override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        if horizontal {
            CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect))
            CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect))
        }
        else {
            CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect))
            CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect))
        }
        CGContextSetStrokeColorWithColor(context, color.CGColor )
        CGContextSetLineWidth(context, width / UIScreen.mainScreen().scale)
        CGContextStrokePath(context)
    }

}
