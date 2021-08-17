//  Created by Ky Nguyen

import UIKit

var screenWidth: CGFloat { return UIScreen.main.bounds.width }
var screenHeight: CGFloat { return UIScreen.main.bounds.height }
let appDelegate = UIApplication.shared.delegate as! AppDelegate

func run(_ action: @escaping () -> Void, after second: Double) {
    let triggerTime = DispatchTime.now() + .milliseconds(Int(second * 1000))
    DispatchQueue.main.asyncAfter(deadline: triggerTime) { action() }
}

extension AppDelegate {
    @objc func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil)
    }
}

func makeCall(to number: String) {
    guard let phoneUrl = URL(string: "tel://\(number)") else { return }
    guard UIApplication.shared.canOpenURL(phoneUrl) else { return }
    if #available(iOS 10.0, *) {
        UIApplication.shared.open(phoneUrl)
    } else {
        UIApplication.shared.openURL(phoneUrl)
    }
}

func openAppstore(url: String) {
    guard let link = URL(string: url) else { return }
    if #available(iOS 10.0, *) {
        UIApplication.shared.open(link)
    } else {
        UIApplication.shared.openURL(link)
    }
}

func hasNotch() -> Bool {
    return DeviceType.IS_IPHONE_X ||
        DeviceType.isIphoneXR ||
        DeviceType.isIphoneXS ||
        DeviceType.isIphoneXSMax
}

func openUrlInSafari(_ url: String) {
    guard let link = URL(string: url) else { return }
    UIApplication.shared.open(link, options: [:], completionHandler: nil)
}

let isSimulator: Bool = {
    #if arch(i386) || arch(x86_64)
    return true
    #else
    return false
    #endif
}()

extension UIFont {
    enum KNWeight: String {
        case black = "Muli-Black"
        case bold = "Muli-Bold"
        case medium = "Muli-SemiBold"
        case regular = "Muli-Regular"
    }
    
    static func main(_ weight: KNWeight = .regular, size: CGFloat = 15) -> UIFont {
        return font(weight.rawValue, size: size)
    }
    
    static func font(_ name: String, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: name, size: size) else { return UIFont.boldSystemFont(ofSize: size) }
        return font
    }
}

