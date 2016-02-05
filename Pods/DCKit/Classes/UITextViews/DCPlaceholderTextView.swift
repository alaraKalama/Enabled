//
//  DCPlaceholderTextView.swift
//  DCKitSample
//
//  Created by Andrey Gordeev on 5/8/15.
//  Copyright (c) 2015 Andrey Gordeev. All rights reserved.
//

import UIKit

/// UITextView subclass that adds placeholder support like UITextField has. Swift version of https://github.com/soffes/SAMTextView/tree/master/SAMTextView
@IBDesignable
public class DCPlaceholderTextView: DCBorderedTextView {
    
    ///  The string that is displayed when there is no other text in the text view. This property reads and writes the attributed variant.
    @IBInspectable public var placeholder: String? {
        set {
            if newValue == self.attributedPlaceholder?.string {
                return
            }
            
            var attributes = [String : AnyObject]()
            // This was in the original SAMTextView, but I really don't understand, why this is needed.
            // This makes placeholder appear as entered text, which seems wrong, so I commented it out.
//            if isFirstResponder() && (typingAttributes != nil) {
//                attributes.addEntriesFromDictionary(typingAttributes)
//            }
//            else {
                attributes[NSFontAttributeName] = font
                attributes[NSForegroundColorAttributeName] = UIColor(white: 0.702, alpha: 1.0)
//            }
            
            if textAlignment != NSTextAlignment.Left {
                let paragraph = NSMutableParagraphStyle()
                paragraph.alignment = textAlignment
                attributes[NSParagraphStyleAttributeName] = paragraph
            }
            
            attributedPlaceholder = NSAttributedString(string: newValue ?? "", attributes: attributes)
        }
        get {
            return self.attributedPlaceholder?.string
        }
    }
    
    /// The attributed string that is displayed when there is no other text in the text view.
    @IBInspectable public var attributedPlaceholder: NSAttributedString? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override public var text: String! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override public var attributedText: NSAttributedString! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override public var contentInset: UIEdgeInsets {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override public var font: UIFont? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override public var textAlignment: NSTextAlignment {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: - Initializers
    
    // IBDesignables require both of these inits, otherwise we'll get an error: IBDesignable View Rendering times out.
    // http://stackoverflow.com/questions/26772729/ibdesignable-view-rendering-times-out
    
    override public init(frame: CGRect, textContainer: NSTextContainer!) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Placeholder
    
    func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        var rect = UIEdgeInsetsInsetRect(bounds, contentInset)
        
        if respondsToSelector(Selector("textContainer")) {
            rect = UIEdgeInsetsInsetRect(rect, textContainerInset)
            let padding = textContainer.lineFragmentPadding;
            rect.origin.x = rect.origin.x + padding
            rect.size.width = rect.size.width - padding * 2.0
        }
        else {
            if contentInset.left == 0.0 {
                rect.origin.x = rect.origin.x + 8.0
            }
            rect.origin.y = rect.origin.y + 8.0
        }
        
        return rect
    }
    
    // MARK: - Build control
    
    public override func customInit() {
        super.customInit()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("textChanged"), name: UITextViewTextDidChangeNotification, object: self)
    }
    
    // MARK: - Misc
    
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        // Draw placeholder if necessary
        if (text as NSString).length == 0 && attributedPlaceholder != nil {
            let placeholderRect = placeholderRectForBounds(bounds)
            attributedPlaceholder!.drawInRect(placeholderRect)
        }
    }
    
    public override func insertText(text: String) {
        super.insertText(text)
        
        setNeedsDisplay()
    }
    
    @objc private func textChanged() {
        setNeedsDisplay()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextViewTextDidChangeNotification, object: self)
    }

}
