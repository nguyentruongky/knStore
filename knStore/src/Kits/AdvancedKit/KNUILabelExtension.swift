//  Created by Ky Nguyen

import UIKit

extension UILabel{
    func setLineSpacing(_ lineSpacing: CGFloat = 7.0, alignment: NSTextAlignment = NSTextAlignment.left) {
        guard let labelText = text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.maximumLineHeight = 40
        paragraphStyle.alignment = alignment
        
        let attributedString:NSMutableAttributedString
        if let labelattributedText = attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        // Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        attributedText = attributedString
    }

    @discardableResult
    func formatParagraph(alignment: NSTextAlignment = NSTextAlignment.left, spacing: CGFloat = 7) -> [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        paragraphStyle.maximumLineHeight = 40
        paragraphStyle.alignment = alignment
        
        let ats = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        attributedText = NSAttributedString(string: text!, attributes: ats)
        return ats
    }
    
    func setCharacterSpacing(_ space: CGFloat) {
        guard let text = text else { return }
        let att: NSMutableAttributedString
        if let currentAtt = attributedText {
            att = NSMutableAttributedString(attributedString: currentAtt)
        } else {
            att = NSMutableAttributedString(string: text)
        }
        att.addAttribute(.kern, value: space,
                         range: NSRange(location: 0, length: text.count - 1))
        attributedText = att
    }
    
    func formatText(boldStrings: [String] = [],
                    boldFont: UIFont = UIFont.boldSystemFont(ofSize: 14),
                    boldColor: UIColor = .black,
                    lineSpacing: CGFloat = 7,
                    alignment: NSTextAlignment = .left) {
        attributedText = String.format(strings: boldStrings,
                                       boldFont: boldFont,
                                       boldColor: boldColor,
                                       inString: text!,
                                       font: font,
                                       color: textColor,
                                       lineSpacing: lineSpacing,
                                       alignment: alignment)
    }
    
    func strikeout() {
        guard let text = text else { return }
        let att = NSMutableAttributedString(string: text)
        att.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1,
                         range: NSMakeRange(0, att.length))
        attributedText = att
    }
    
    func underline(string: String) {
        let attributedString: NSMutableAttributedString
        if let labelattributedText = attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: text ?? "")
        }
        guard let text = text, let index = text.indexOf(string) else { return }
        
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSMakeRange(index, string.count))
        attributedText = attributedString
    }
    
    func addCharacterSpacing(_ space: CGFloat) {
        guard let text = text else { return }
        let att = NSMutableAttributedString(string: text)
        att.addAttribute(NSAttributedString.Key.kern, value: 1.5,
                         range: NSMakeRange(0, att.length))
        attributedText = att
    }
}

