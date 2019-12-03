//
//  Extensions.swift
//  BSC
//
//  Created by Anupam Katiyar on 02/10/17.
//  Copyright © 2017 Anupam Katiyar. All rights reserved.
//

import UIKit


extension UIView {
    private struct AssociatedKeysUIView {
        static var BottomLine: UInt8 = 0
    }

    var bottomLine: CALayer {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKeysUIView.BottomLine) as? CALayer else {
                let layer = CALayer()
                objc_setAssociatedObject(self, &AssociatedKeysUIView.BottomLine, layer, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                
                return layer
            }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeysUIView.BottomLine, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    @IBInspectable var bottomLineWidth: CGFloat {
        get {
            return bottomLine.frame.size.height
        }
        set {
            bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - newValue, width: self.frame.size.width, height: newValue)
            bottomLine.backgroundColor = bottomLineColor == nil ? UIColor.black.cgColor : bottomLineColor?.cgColor
            self.layer.addSublayer(bottomLine)
            self.layer.masksToBounds = true // newValue > 0
        }
    }

    
    @IBInspectable var bottomLineColor: UIColor? {
        get {
            guard let color = bottomLine.backgroundColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            bottomLine.backgroundColor = newValue?.cgColor
//            layer.masksToBounds = true
        }
    }

    @IBInspectable var corners: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            guard let color = layer.borderColor else {
                return UIColor.clear
            }
            return UIColor(cgColor: color)
        }
        set {
            layer.borderColor = newValue.cgColor
            layer.masksToBounds = true
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    
    @IBInspectable var Shadow_Color: UIColor {
        get {
            return UIColor(cgColor: self.layer.shadowColor ?? UIColor.white.cgColor)
        }
        set {
            self.layer.masksToBounds = false
            self.layer.shadowColor = newValue.cgColor
            self.layer.shadowOpacity = 1.0
            self.isOpaque = false
//            self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
//            self.layer.shouldRasterize = true
//            self.layer.rasterizationScale = UIScreen.main.scale
        }
    }

    @IBInspectable var Shadow_Radius: CGFloat {
        get {
            return self.layer.shadowRadius
        }
        set {
            self.layer.shadowRadius = newValue
        }
    }

    @IBInspectable var Shadow_Offset: CGSize {
        get {
            return self.layer.shadowOffset
        }
        set {
            self.layer.shadowOffset = newValue
        }
    }

}



extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor(hexString: "c8c8c8").cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 10
        self.isOpaque = false
        
//        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
//        self.layer.shouldRasterize = true
//        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        self.isOpaque = false
        
//        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
//        self.layer.shouldRasterize = true
//        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func removeShadow () {
        self.layer.shadowOpacity = 0.0;
    }
}




extension UIView {
    @IBInspectable var dash_Color: UIColor {
        get {
            return UIColor.clear
        }
        set {
            let yourViewBorder = CAShapeLayer()
            yourViewBorder.strokeColor = newValue.cgColor
            yourViewBorder.lineDashPattern = [5, 5]
            yourViewBorder.frame = self.bounds
            yourViewBorder.fillColor = nil
            yourViewBorder.path = UIBezierPath(rect: self.bounds).cgPath
            self.layer.addSublayer(yourViewBorder)
            layer.borderColor = UIColor.clear.cgColor
        }
    }

}




extension UIView {
    class func viewFromNib<T : UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    class func loadNib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle.main)
    }
}

extension UIView {
    
    var x: CGFloat {
        get {
            return self.frame.origin.x
        } set {
            self.frame.origin.x = newValue
        }
    }
    
    var y: CGFloat {
        get {
            return self.frame.origin.y
        } set {
            self.frame.origin.y = newValue
        }
    }
    
    var midX: CGFloat {
        return self.frame.midX
    }
    
    var maxX: CGFloat {
        return self.frame.maxX
    }
    
    var midY: CGFloat {
        return self.frame.midY
    }
    
    var maxY: CGFloat {
        return self.frame.maxY
    }
    
    var width: CGFloat {
        get {
            return self.frame.size.width
        } set {
            self.frame.size.width = newValue
        }
    }
    
    var height: CGFloat {
        get {
            return self.frame.size.height
        } set {
            self.frame.size.height = newValue
        }
    }
    
    var size: CGSize {
        get {
            return self.frame.size
        } set {
            self.frame.size = newValue
        }
    }
    
}


extension UIView {
    private struct AssociatedObjectKeys {
        static var refreshTapAction: UInt8 = 0
    }

    private typealias Action = ((UIView) -> Void)?

    // Set our computed property type to a closure
    private var refreshTapAction: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.refreshTapAction, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let refreshControlActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.refreshTapAction) as? Action
            return refreshControlActionInstance
        }
    }

    //  closure the user tap on view
    public func addTapGesture(_ action: ((UIView) -> Void)?) {
        self.isUserInteractionEnabled = true
        self.refreshTapAction = action
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)
    }
    
    // which triggers the closure we taped
    @objc private func tapped(_ sender: UIView) {
        if let action = self.refreshTapAction {
            action?(sender)
        } else {
            print("no action")
        }
    }

}



extension UIScreen {
    
    static var width: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    static var height: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    static var size: CGSize {
        return UIScreen.main.bounds.size
    }
}

extension UILabel {
    
    func manageBlendedLayers() {
        self.isOpaque = true
        self.backgroundColor = UIColor.white
    }
    
}




extension UIView {
    func addGradientToView(colors: [CGColor], locations: [NSNumber]? = nil)
    {
        //gradient layer
        let gradientLayer = CAGradientLayer()
        
        //define colors
        gradientLayer.colors = colors
//        gradientLayer.colors = [UIColor.red.cgColor,    UIColor.green.cgColor, UIColor.blue.cgColor]
        
        //define locations of colors as NSNumbers in range from 0.0 to 1.0
        //if locations not provided the colors will spread evenly
//        gradientLayer.locations = [0.0, 0.6, 0.8]
        gradientLayer.locations = locations
        //define frame
        gradientLayer.frame = self.bounds
        
        //insert the gradient layer to the view layer
        self.layer.insertSublayer(gradientLayer, at: 0)
    }

}






extension UIView {
    
    func asImage() -> UIImage? {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
            defer { UIGraphicsEndImageContext() }
            guard let currentContext = UIGraphicsGetCurrentContext() else {
                return nil
            }
            self.layer.render(in: currentContext)
            return UIGraphicsGetImageFromCurrentImageContext()
        }
    }
}
