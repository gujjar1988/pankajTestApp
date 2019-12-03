//
//  MyTextField.swift
//  Jaee
//
//  Created by Pankaj on 27/06/18.
//  Copyright © 2018 Pankaj. All rights reserved.
//

import Foundation
import UIKit


@IBDesignable
open class MyTextfield: UITextField, UITextFieldDelegate {
    
    let label : UILabel = UILabel()
    var labelTopLayout :NSLayoutConstraint?

    @IBInspectable var defaultBorderColor : UIColor = UIColor(hexString: "C8C8C8")
    @IBInspectable var highLightBorderColor : UIColor = UIColor(hexString: "C8C8C8")
    @IBInspectable var paddingLeft: CGFloat = 5.0
    @IBInspectable var paddingRight: CGFloat = 5.0
    @IBInspectable var labelPaddingLeft: CGFloat = 5.0
    @IBInspectable var labelHidden: Bool = true
    @IBInspectable var labelText: String = ""
    @IBInspectable var labelFont: CGFloat = 10.0

    var placeHolderString: String = ""




    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        delegate = self
    }
    required override public init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
    }
    
    override open func awakeFromNib() {
//        self.layer.borderWidth = 0.0
        self.layer.borderColor = defaultBorderColor.cgColor
        
        if labelHidden == false {
            self.superview?.addSubview(self.label)
            
            let horConstraint = NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal,
                                                   toItem: self, attribute: .left,
                                                   multiplier: 1.0, constant: (labelPaddingLeft + paddingLeft))
            let verConstraint = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal,
                                                   toItem: self, attribute: .centerY,
                                                   multiplier: 1.0, constant: 0.0)
            verConstraint.priority = UILayoutPriority(250)
            
            
            labelTopLayout = NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal,
                                                toItem: self, attribute: .top,
                                                multiplier: 1.0, constant: 0.0)
            labelTopLayout?.priority = UILayoutPriority(249)
            
            self.superview?.addConstraints([horConstraint, verConstraint, labelTopLayout!])
        }
        
        self.placeHolderString = self.placeholder ?? ""
    }
    
    
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        let padding = UIEdgeInsets(top: 0, left: paddingLeft, bottom: 0, right: paddingRight)
        return bounds.inset(by: padding)
//        return CGRect(x: bounds.origin.x + paddingLeft, y: bounds.origin.y, width: (bounds.size.width - (paddingLeft + paddingRight)), height: bounds.size.height)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
            return textRect(forBounds: bounds)
        }
    
    override open func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        self.textFieldDidBeginEditing()
        return result
    }
    
    //MARK:- UITextfield Resigns Responder
    override open func resignFirstResponder() -> Bool {
        let result =  super.resignFirstResponder()
        self.textFieldDidEndEditing()
        return result
    }
    
    
    func textFieldDidBeginEditing() {
        switch self.keyboardType {
        case .default: break
        default:
            self.inputAccessoryView = addDoneButtonOnKeyboard()
        }
        self.layer.borderColor = highLightBorderColor.cgColor
        self.bottomLine.borderColor = highLightBorderColor.cgColor
        
        if ((self.placeholder?.count ?? 0) > 0  && !labelHidden){
            self.label.textAlignment = .left
            self.label.translatesAutoresizingMaskIntoConstraints = false
            self.label.text = self.labelText.isEmpty ? self.placeHolderString : self.labelText
            self.label.font = self.font
//            self.label?.textColor = UIColor.white
            self.label.sizeToFit()
            self.placeholder = nil
            self.label.isHidden = false
            UIView.animate(withDuration: 2.0) {
                self.label.font = self.label.font.withSize(self.labelFont)
                self.labelTopLayout?.priority = UILayoutPriority(251)
            }
        }
    }
    
    func textFieldDidEndEditing() {
        self.label.isHidden = true
        self.labelTopLayout?.priority = UILayoutPriority(249)
        self.placeholder = self.placeHolderString
        self.layer.borderColor = defaultBorderColor.cgColor
        self.bottomLine.borderColor = self.borderColor.cgColor
    }
    
    
    // to add done button on keyboard
    func addDoneButtonOnKeyboard() -> UIToolbar {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(resignFirstResponder))
        
        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        return doneToolbar
    }

}








@IBDesignable
class MyTextView: UITextView, UITextViewDelegate {
    
    var label = EdgeInsetLabel()
    var indexpath : IndexPath?
    
    @IBInspectable var defaultBorderColor : UIColor = UIColor.clear
    @IBInspectable var highLightBorderColor : UIColor = UIColor.clear
    @IBInspectable var placeholderColor : UIColor = UIColor(hexString: "C7C7CD")
    @IBInspectable var textcolor : UIColor = UIColor.darkGray
    
    @IBInspectable var paddingLeft: CGFloat = 5.0
    @IBInspectable var paddingRight: CGFloat = 5.0
    @IBInspectable var paddingTop: CGFloat = 5.0
    @IBInspectable var paddingBottom: CGFloat = 5.0
    
    @IBInspectable var labelPaddingLeft: CGFloat = 5.0
    @IBInspectable var labelHidden: Bool = true
    @IBInspectable var labelText: String = ""
    @IBInspectable var labelFont: CGFloat = 10.0
    
    @IBInspectable var placeholder: String = ""
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        delegate = self
    }
    required override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        delegate = self
    }
    
    override func awakeFromNib() {
        self.layer.borderColor = defaultBorderColor.cgColor
        textContainerInset = UIEdgeInsets(top: paddingTop, left: paddingLeft, bottom: paddingBottom, right: paddingRight)
        self.textViewDidEndEditing()
        
        
        if labelHidden == false {
            self.superview?.addSubview(self.label)
            
            let horConstraint = NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal,
                                                   toItem: self, attribute: .left,
                                                   multiplier: 1.0, constant: (labelPaddingLeft + paddingLeft))
            let verConstraint = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal,
                                                   toItem: self, attribute: .top,
                                                   multiplier: 1.0, constant: 0.0)
            
            self.superview?.addConstraints([horConstraint, verConstraint])
        }
    }
    
    
    
    open var customText:String? {
        willSet{
            self.text = newValue ?? ""
        }
        didSet {
            self.textViewDidEndEditing()
        }
    }
    
    override open func becomeFirstResponder() -> Bool {
        self.textViewDidBeginEditing()
        let result = super.becomeFirstResponder()
        return result
    }
    
    //MARK:- UITextView Resigns Responder
    override open func resignFirstResponder() -> Bool {
        self.textViewDidEndEditing()
        let result =  super.resignFirstResponder()
        return result
    }
    
    
    func textViewDidBeginEditing() {
        self.inputAccessoryView = addDoneButtonOnKeyboard()

        self.layer.borderColor = highLightBorderColor.cgColor
        
        if (self.placeholder.count > 0  && !labelHidden){
            self.label.textInsets = UIEdgeInsets(top: 2.0, left: 8.0, bottom: 2.0, right: 8.0)
            //            self.label?.layer.borderWidth = 1.0
            //            self.label?.layer.borderColor = highLightBorderColor.cgColor
            self.label.layer.cornerRadius = 8.0
            self.label.layer.masksToBounds = true
            self.label.textAlignment = .center
            self.label.translatesAutoresizingMaskIntoConstraints = false
            self.label.text = self.labelText.isEmpty ? self.placeholder : self.labelText
            self.label.font = self.font
            self.label.font = self.label.font.withSize(self.labelFont)
            
            self.label.textColor = UIColor.white
            self.label.backgroundColor = highLightBorderColor
            self.label.sizeToFit()
        }
        
        if self.text == self.placeholder {
            self.text = ""
            self.textColor = self.textcolor
        }
        
    }
    
    func textViewDidEndEditing() {
        self.label.isHidden = true
        self.layer.borderColor = defaultBorderColor.cgColor
        
        while (self.text.hasPrefix(" ") || self.text.hasPrefix("\n")){
            self.text = String(self.text[self.text.index(after: self.text.startIndex)...])
        }
        
        while (self.text.hasSuffix(" ") || self.text.hasSuffix("\n")){
            self.text = String(self.text[..<self.text.index(before: self.text.endIndex)])
        }
        
        if self.text.isEmpty {
            self.text = self.placeholder
            self.textColor = self.placeholderColor
        } else {
            self.textColor = self.textcolor
        }
    }
    
    
    
    
    // to add done button on keyboard
    func addDoneButtonOnKeyboard() -> UIToolbar {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(resignFirstResponder))
        
        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        return doneToolbar
    }

}



