//
//  Extension.swift
//  Domino
//
//  Created by Đỗ Ngọc on 9/1/16.
//  Copyright © 2016 Đỗ Ngọc. All rights reserved.
//

import UIKit

let APP_VERSION = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion")!
let APP_NAME = Bundle.main.object(forInfoDictionaryKey: "CFBundleName")!
let APP_DELEGATE = UIApplication.shared.delegate as! AppDelegate
var ROOTVC = APP_DELEGATE.window?.rootViewController
var KEY_WINDOW = UIApplication.shared.keyWindow
let USER_DEFAULTS = UserDefaults.standard
let APPLICATION = UIApplication.shared
let BUNDLE = Bundle.main
let NOTIFICATION_CENTER = NotificationCenter.default
let MAIN_SCREEN = UIScreen.main
let FILE_MANAGER = FileManager.default
let DOCUMENTS_DIR = FILE_MANAGER.urls(for: .documentDirectory, in: .userDomainMask).last!

func navigationBar(viewController:UIViewController)->UINavigationBar{
    return  viewController.navigationController!.navigationBar
}

extension CAGradientLayer {
    enum CADirection:Int{
        case horization
        case vertical
    }
    convenience init(frame: CGRect, colors: [UIColor],direction:CADirection) {
        self.init()
        self.frame = frame
        self.colors = []
        for color in colors {
            self.colors?.append(color.cgColor)
        }
        if direction == .vertical{
            startPoint = CGPoint(x: 0, y: 0)
            endPoint = CGPoint(x: 0, y: 1)
        }else{
            startPoint = CGPoint(x: 0, y: 0)
            endPoint = CGPoint(x: 1, y: 0)
        }
    }
    
    func creatGradientImage() -> UIImage? {
        
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
    
}

func tabBar(viewController:UIViewController)->UITabBar{
    return  viewController.tabBarController!.tabBar
}

let DATE_COMPONENTS = [NSCalendar.Unit.year ,NSCalendar.Unit.month,NSCalendar.Unit.day]
let screenWidth = MAIN_SCREEN.bounds.size.width
let screenHeight = MAIN_SCREEN.bounds.size.height


extension UIImage{
    func maskWithColor(color: UIColor) -> UIImage? {
        
        let maskImage = self.cgImage
        let width = self.size.width
        let height = self.size.height
        let bounds = CGRect(x:0, y:0, width:width,height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let bitmapContext = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) //needs rawValue of bitmapInfo
        
        bitmapContext!.clip(to: bounds, mask: maskImage!)
        bitmapContext!.setFillColor(color.cgColor)
        bitmapContext!.fill(bounds)
        
        //is it nil?
        if let cImage = bitmapContext!.makeImage() {
            let coloredImage = UIImage(cgImage: cImage)
            
            return coloredImage
            
        } else {
            return nil
        }
    }
    
}

extension UIColor{
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
extension String {
    static func stringCurrency(_ moneyString: NSString?) -> String {
        if  moneyString != nil {
            var resultString : String = ""
            var string = moneyString
            while string!.length > 3 {
                let subString = string!.substring(with: NSRange.init(location: string!.length - 3, length: 3)) as String
                if resultString.count > 0 {
                    resultString = subString + "." + resultString
                } else {
                    resultString = subString + resultString
                }
                
                string = string!.substring(with: NSRange.init(location: 0, length: string!.length - 3)) as NSString
            }
            if string!.length > 0 {
                if resultString.count > 0 {
                    resultString = (string! as String) + "." + resultString
                } else {
                    resultString = (string! as String) + resultString
                }
            }
            if resultString == "" {
                resultString = "0"
            }
            return resultString
        } else {
            return "0"
        }
    }
    //Validate Email
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
    
    //validate PhoneNumber
    func isPhoneNumber(string:String!)-> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: string)
        return result
    }
    
    func toDictionary() -> [String:Any]? {
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
   
}
enum Validate {
    case email(_: String)
    case phoneNum(_: String)
    case carNum(_: String)
    case username(_: String)
    case password(_: String)
    case nickname(_: String)
    
    case URL(_: String)
    case IP(_: String)
    
    
    var isRight: Bool {
        var predicateStr:String!
        var currObject:String!
        switch self {
        case let .email(str):
            predicateStr = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
            currObject = str
        case let .phoneNum(str):
            predicateStr = "^((13[0-9])|(15[^4,\\D]) |(17[0,0-9])|(18[0,0-9]))\\d{8}$"
            currObject = str
        case let .carNum(str):
            predicateStr = "^[A-Za-z]{1}[A-Za-z_0-9]{5}$"
            currObject = str
        case let .username(str):
            predicateStr = "^[A-Za-z0-9]{6,20}+$"
            currObject = str
        case let .password(str):
            predicateStr = "^[a-zA-Z0-9]{6,20}+$"
            currObject = str
        case let .nickname(str):
            predicateStr = "^[\\u4e00-\\u9fa5]{4,8}$"
            currObject = str
        case let .URL(str):
            predicateStr = "^(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$"
            currObject = str
        case let .IP(str):
            predicateStr = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
            currObject = str
        }
        
        let predicate =  NSPredicate(format: "SELF MATCHES %@" ,predicateStr)
        return predicate.evaluate(with: currObject)
    }
}
extension UILabel{
    func blink() {
        let animation = CABasicAnimation.init(keyPath:"opacity")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.repeatCount = .greatestFiniteMagnitude
        self.layer.add(animation, forKey: "opacity")
    }
}

extension Array where Element: Hashable {
    
    func next(item: Element) -> Element? {
        if let index = self.index(of: item), index + 1 <= self.count {
            return index + 1 == self.count ? self[0] : self[index + 1]
        }
        return nil
    }
    
    func prev(item: Element) -> Element? {
        if let index = self.index(of: item), index >= 0 {
            return index == 0 ? self.last : self[index - 1]
        }
        return nil
    }
}
