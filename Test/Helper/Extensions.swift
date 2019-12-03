//
//  File.swift
//  JTAppleCalendar
//
//  Created by Jeron Thomas on 2016-12-09.
//
//

import UIKit
import CoreGraphics



extension UIColor {
    
    convenience init(hexString: String, alpha: CGFloat?=1.0) {
        let scanner = Scanner(string: hexString)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: alpha!
        )
    }

    convenience init(_ RGB:String, _ alpha: CGFloat?=1.0) {
            let array = RGB.components(separatedBy: " ")
            let r = array[0].floatValue
            let g = array[1].floatValue
            let b = array[2].floatValue

        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: alpha!
        )
    }

    func as1ptImage(_ width:Int = 1, _ height:Int = 1) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        setFill()
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: width, height: height))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }

}





extension CALayer {
    
    @IBInspectable var borderColorFromUIColor: UIColor? {
        get {
            return UIColor(cgColor: self.borderColor!)
        }
        set {
            self.borderColor = newValue?.cgColor
        }
    }

}



extension UIButton {
    
    @IBInspectable var buttonImageTintColor: UIColor? {
        get {
            return self.tintColor
        }
        set {
            let tintedImage = self.image(for: .normal)?.withRenderingMode(.alwaysTemplate)
            self.setImage(tintedImage, for: .normal)
            self.tintColor = newValue
        }
    }
    
}



extension UIImageView {

    @IBInspectable var imageTintColor: UIColor? {
        get {
            return self.tintColor
        }
        set {
            let tintedImage = self.image?.withRenderingMode(.alwaysTemplate)
            self.image = tintedImage
            self.tintColor = newValue
        }
    }
}



extension UIImage
{
    func tint(color: UIColor, blendMode: CGBlendMode) -> UIImage
    {
        let drawRect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context = UIGraphicsGetCurrentContext()
        context?.clip(to: drawRect, mask: self.cgImage!)
        color.setFill()
        UIRectFill(drawRect)
        draw(in: drawRect, blendMode: blendMode, alpha: 1.0)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage!
    }
   

}






extension UITextView {
    
    func scrollToBotom() {
        if self.text.count > 0 {
            let range = NSRange(location: self.text.count - 1, length: 1)
            scrollRangeToVisible(range)
        }
    }
}


extension String {
    
    // formatting text for currency text
    func currencyFormatting() -> String {
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
//        formatter.currencySymbol = currency
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2

        var numberString = (self as NSString)
        numberString = numberString.replacingOccurrences(of: ",", with: "") as NSString
        let double = (numberString as NSString).doubleValue
        number = NSNumber(value: double)
        return formatter.string(from: number)!
    }
        
    // formatting text for currency textfield
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
//        formatter.currencySymbol = currency
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
//        guard number != 0 as NSNumber else {
//            return formatter.string(from: 0)!
//        }
        
        return formatter.string(from: number)!
    }
    
    
    // formatting numbers only
    func numberInputFormatting(_ FractionDigits: Int? = 0) -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = FractionDigits!
        formatter.minimumFractionDigits = FractionDigits!
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        
        if FractionDigits! > 0 {
            number = NSNumber(value: (double / pow(10.0, Double(FractionDigits!))))
        }else {
            number = NSNumber(value: double)
        }
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        let numberString = formatter.string(from: number)!
        return numberString.replacingOccurrences(of: ",", with: "")
    }

}



extension String {

//    var isEmail:Bool {
//        get{
//            let emailTest = NSPredicate(format: "SELF MATCHES %@", Constant.REGEX_EMAIL)
//            return emailTest.evaluate(with: self)
//        }
//    }
//    
//    var isMobile:Bool {
//        get{
//            let emailTest = NSPredicate(format: "SELF MATCHES %@", Constant.REGEX_MOBILE)
//            return emailTest.evaluate(with: self)
//        }
//    }

    var intValue:Int {
        get{
            return Int(self) ?? 0
        }
    }
    
    var floatValue:Float{
        get{
            return (self as NSString).floatValue 
        }
    }
    
    var doubleValue:Double{
        get{
            var numberString = (self as NSString)
            numberString = numberString.replacingOccurrences(of: ",", with: "") as NSString
            return (numberString as NSString).doubleValue
//            return (self as NSString).doubleValue
        }
    }

    var boolValue:Bool {
        get{
            return (self as NSString).boolValue
        }
    }

}


extension Bool {
    var intValue:Int {
        get{
            return Int(truncating: NSNumber(value:self))
        }
    }
}



extension Int {
    var boolValue:Bool {
        get{
            return Bool.init(truncating: self as NSNumber)
        }
    }
    
    var stringValue:String {
        get{
            return "\(self)"
        }
    }
}


extension Double {
    
    var stringValue: String {
        get{
            return "\(self)"
        }
        //        return String(format: "%.1f", self)
    }
}

extension Float {
    var stringValue: String {
        get{
//            return "\(self)"
            return String(format: "%.2f", self)
        }
    }
}





extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector("statusBar")) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}


extension BinaryInteger {
    var degreesToRadians: CGFloat { return CGFloat(Int(self)) * .pi / 180 }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}


extension Dictionary {
    mutating func append(_ dic:[String:Any]) {
        var initialResult = self as! [String:Any]
        initialResult = dic.reduce(initialResult) { (result, data) -> [String:Any] in
            var res = result
            res[data.key] = data.value
            return res
        }
        self = initialResult as! Dictionary<Key, Value>
    }
}






// open public var and func
var TimeStamp: String {
    //    return "\(NSDate().timeIntervalSince1970 * 1000)"
    return "\(NSDate().timeIntervalSince1970 * 1000000)".components(separatedBy: ".").first ?? ""
}

func makeDateStringWithFormat(_ date:Date, _ format:String, _ localeIdentifier:String? = nil) -> String {
    let formatter = DateFormatter()
    if localeIdentifier == nil {
        if (UserDefaults.standard.array(forKey: "AppleLanguages")?.first as! String).contains("ar") {
            formatter.locale = NSLocale(localeIdentifier: "ar") as Locale
        }else {
            formatter.locale = NSLocale(localeIdentifier: "en") as Locale
        }
    }else {
        formatter.locale = NSLocale(localeIdentifier: localeIdentifier!) as Locale
    }
    formatter.dateFormat = format
    return formatter.string(from: date)
}

func makeDateFromString(_ dateString:String?, _ format:String) -> Date {
    if (dateString == nil) {
        return Date()
    }
    
    if (dateString?.isEmpty)! {
        return Date()
    }
    
    let formatter = DateFormatter()
    formatter.locale = NSLocale(localeIdentifier: "en") as Locale
    formatter.dateFormat = format
    
    if let date = formatter.date(from: dateString!) {
        return date
    }
    
    // to make date from arabic string
    formatter.locale = NSLocale(localeIdentifier: "ar") as Locale
    formatter.dateFormat = format
    
    if let date = formatter.date(from: dateString!) {
        return date
    }
    
    
    return Date()
}

func changeDateStringWithFormat(_ dateString:String?, _ from:String, _ to:String) -> String {
    if (dateString == nil) {
        return " "
    }
    
    if (dateString?.isEmpty)! {
        return " "
    }
    
    let formatter = DateFormatter()
    formatter.locale = NSLocale(localeIdentifier: "en") as Locale
    formatter.dateFormat = from
    if let date = formatter.date(from: dateString!) {
        formatter.dateFormat = to
        if (UserDefaults.standard.array(forKey: "AppleLanguages")?.first as! String).contains("ar") {
            formatter.locale = NSLocale(localeIdentifier: "ar") as Locale
        }
        return formatter.string(from: date)
    }
    
    // to make date from arabic string
    formatter.locale = NSLocale(localeIdentifier: "ar") as Locale
    formatter.dateFormat = from
    if let date = formatter.date(from: dateString!) {
        formatter.dateFormat = to
        if (UserDefaults.standard.array(forKey: "AppleLanguages")?.first as! String).contains("en") {
            formatter.locale = NSLocale(localeIdentifier: "en") as Locale
        }
        return formatter.string(from: date)
    }
    
    return " "
}
