//
//  AlertController.swift
//  ProFive
//
//  Created by Pankaj Kumar on 04/08/17.
//  Copyright © 2017 Anupam Katiyar. All rights reserved.
//

import UIKit

@objc open class AlertController : NSObject {
    
    //==========================================================================================================
    // MARK: - Singleton
    //==========================================================================================================
    
    class var instance : AlertController {
        struct Static {
            static let inst : AlertController = AlertController ()
        }
        return Static.inst
    }
    
    //==========================================================================================================
    // MARK: - Private Functions
    //==========================================================================================================
    
    private func topMostController() -> UIViewController? {
        
        var presentedVC = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
            .filter({$0.isKeyWindow}).first?.rootViewController
        while let pVC = presentedVC?.presentedViewController
        {
            presentedVC = pVC
        }
        
        if presentedVC == nil {
            print("AKAlertController Error: You don't have any views set. You may be calling in viewdidload. Try viewdidappear.")
        }
        return presentedVC
    }
    
    
    //==========================================================================================================
    // MARK: - Class Functions
    //==========================================================================================================
    
    @discardableResult
    open class func alert(_ title: String) -> UIAlertController {
        return alert(title, message: "")
    }
    
    @discardableResult
    open class func alert(_ title: String, message: String) -> UIAlertController {
        return alert(title, message: message, acceptMessage: "OK", acceptBlock: {
            // Do nothing
        })
    }
    
    @discardableResult
    open class func alert(_ title: String, message: String?, acceptMessage: String, acceptBlock: @escaping () -> ()) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let acceptButton = UIAlertAction(title: acceptMessage, style: .default, handler: { (action: UIAlertAction) in
            acceptBlock()
        })
        alert.addAction(acceptButton)
        
        instance.topMostController()?.present(alert, animated: true, completion: nil)
        return alert
    }
    
    @discardableResult
    open class func alert(_ title: String, message: String, buttons:[String], tapBlock:((UIAlertController, UIAlertAction, Int) -> Void)?) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert, buttons: buttons, tapBlock: tapBlock)
        instance.topMostController()?.present(alert, animated: true, completion: nil)
        return alert
    }
    
    
    
    @discardableResult
    open class func alert(_ title: String, message: String, textFieldPlaceholders: [String], buttons:[String], tapBlock:((UIAlertController, UIAlertAction, Int) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert, textFieldPlaceholders: textFieldPlaceholders, buttons: buttons, tapBlock: tapBlock)
        instance.topMostController()?.present(alert, animated: true, completion: nil)
        return alert
    }
    
    
    @discardableResult
    open class func actionSheet(_ title: String? = nil, message: String? = nil, sourceView: Any, actions: [UIAlertAction]) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.actionSheet)
        for action in actions {
            alert.addAction(action)
        }
        if let view = sourceView as? UIBarButtonItem {
            alert.popoverPresentationController?.barButtonItem = view
        }else {
            if let view = sourceView as? UIView {
                alert.popoverPresentationController?.sourceView = view
                alert.popoverPresentationController?.sourceRect = view.bounds
            }else{
                alert.popoverPresentationController?.sourceView = instance.topMostController()?.view
                alert.popoverPresentationController?.sourceRect = (instance.topMostController()?.view.bounds)!
            }
        }
        
        alert.popoverPresentationController?.permittedArrowDirections = [] //to hide the arrow of any particular direction
        instance.topMostController()?.present(alert, animated: true, completion: nil)
        return alert
    }
    
    @discardableResult
    open class func actionSheet(_ title: String? = nil, message: String? = nil, sourceView: Any, buttons:[String], tapBlock:((UIAlertController, UIAlertAction, Int) -> Void)?) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet, buttons: buttons, tapBlock: tapBlock)
        if let view = sourceView as? UIBarButtonItem {
            alert.popoverPresentationController?.barButtonItem = view
        }else {
            if let view = sourceView as? UIView {
                alert.popoverPresentationController?.sourceView = view
                alert.popoverPresentationController?.sourceRect = view.bounds
            }else{
                alert.popoverPresentationController?.sourceView = instance.topMostController()?.view
                alert.popoverPresentationController?.sourceRect = (instance.topMostController()?.view.bounds)!
            }
        }
        
        alert.popoverPresentationController?.permittedArrowDirections = [] //to hide the arrow of any particular direction
        
        instance.topMostController()?.present(alert, animated: true, completion: nil)
        return alert
    }
    
}


private extension UIAlertController {
    
    convenience init(title: String?, message: String?, preferredStyle: UIAlertController.Style, textFieldPlaceholders: [String]? = nil, buttons:[String], tapBlock:((UIAlertController, UIAlertAction,Int) -> Void)?) {
        self.init(title: title, message: message, preferredStyle:preferredStyle)
        var buttonIndex = 0
        for buttonTitle in buttons {
            var preferredStyle: UIAlertAction.Style!
            switch buttonTitle.lowercased() {
            case "cancel":
                preferredStyle = .cancel
            default:
                preferredStyle = .default
            }
            let action = UIAlertAction(title: buttonTitle, preferredStyle: preferredStyle, alert: self, buttonIndex: buttonIndex, tapBlock: tapBlock)
            buttonIndex += 1
            self.addAction(action)
        }
        
        guard let placeholders = textFieldPlaceholders else { return }
        for placeholder in placeholders {
            self.addTextField(configurationHandler: { (textField) in
                textField.placeholder = placeholder
                textField.isSecureTextEntry = placeholder.lowercased().contains("password")
            })
        }
    }
    
    
}



private extension UIAlertAction {
    convenience init(title: String?, preferredStyle: UIAlertAction.Style, alert: UIAlertController, buttonIndex:Int, tapBlock:((UIAlertController, UIAlertAction, Int) -> Void)?) {
        self.init(title: title, style: preferredStyle) {
            (action:UIAlertAction) in
            if let block = tapBlock {
                block(alert, action, buttonIndex)
            }
        }
    }
}
