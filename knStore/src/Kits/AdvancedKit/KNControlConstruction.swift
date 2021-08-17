//  Created by Ky Nguye

import UIKit

extension UIButton {
    convenience init(image: UIImage?) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = false
        setImage(image, for: .normal)
    }
    
    convenience init(imageName: String) {
        let image = UIImage(named: imageName)
        self.init(image: image)
        translatesAutoresizingMaskIntoConstraints = false
        setImage(image, for: .normal)
    }
    
    convenience init(title: String?,
                     titleColor: UIColor? = .black,
                     font: UIFont? = nil,
                     background: UIColor? = .clear,
                     cornerRadius: CGFloat = 0,
                     borderWidth: CGFloat = 0,
                     borderColor: UIColor = .clear) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = false
        setTitle(title, for: .normal)
        
        setTitleColor(titleColor, for: .normal)
        setTitleColor(titleColor?.withAlphaComponent(0.4), for: .disabled)
        if let bg = background {
            setBackground(color: bg, forState: .normal)
            setBackground(color: bg.withAlphaComponent(0.5), forState: .disabled)
        }
        
        titleLabel?.font = font
        setCorner(radius: cornerRadius)
        setBorder(width: borderWidth, color: borderColor)
    }
    
    convenience init(mainButtonWithTitle title: String,
                     bgColor: UIColor = UIColor.gray,
                     titleColor: UIColor? = UIColor.white,
                     font: UIFont? = UIFont.main(.bold, size: 18), height h: CGFloat? = nil) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = false
        setTitle(title, for: .normal)
        titleLabel?.font = font
        setTitleColor(titleColor, for: .normal)
        setTitleColor(UIColor.white.alpha(0.5), for: .disabled)
        setBackground(color: bgColor, forState: .normal)
        setBackground(color: bgColor.alpha(0.5), forState: .disabled)
        setCorner(radius: 7)
        if let _h = h {
            height(_h)
        }
    }
}

extension UILabel {
    convenience init(text: String? = nil,
                     font: UIFont = .systemFont(ofSize: 15),
                     color: UIColor? = .black,
                     numberOfLines: Int = 1,
                     alignment: NSTextAlignment = .left) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = false
        self.font = font
        textColor = color
        self.text = text
        self.numberOfLines = numberOfLines
        textAlignment = alignment
    }
}

extension UIView {
    convenience init(background: UIColor?){
        self.init()
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = background
    }
}

extension UIImageView {
    convenience init(image: UIImage? = nil,
                     contentMode: UIView.ContentMode = .scaleAspectFit) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = contentMode
        clipsToBounds = true
    }
    convenience init(imageName: String,
                     contentMode: UIView.ContentMode = .scaleAspectFit){
        let image = UIImage(named: imageName)
        self.init(image: image)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
}
extension UITextField {
    convenience init(placeholder: String, icon: UIImage? = nil) {
        self.init(placeholder: placeholder, font: UIFont.main(.medium, size: 14),
                  color: .black)
        setPlaceholderColor(UIColor(r: 163, g: 169, b: 175))
        setCorner(radius: 7.5)
        setBorder(width: 1, color: UIColor(r: 230, g: 232, b: 234))
        
        if let icon = icon {
            let leftView = setView(.left, image: icon)
            leftView.imageView?.changeColor(to: UIColor.lightGray)
        } else {
            setView(.left, space: 20)
        }
    }
    
    convenience init(text: String? = nil,
                     placeholder: String? = nil,
                     font: UIFont = .systemFont(ofSize: 15),
                     color: UIColor = .black,
                     alignment: NSTextAlignment = .left) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = false
        self.font = font
        textColor = color
        self.text = text
        self.placeholder = placeholder
        textAlignment = alignment
        inputAccessoryView = UIMaker.makeKeyboardDoneView()
    }
}

extension UIStackView {
    convenience init(axis: NSLayoutConstraint.Axis = .vertical,
                     distributon: UIStackView.Distribution = .equalSpacing,
                     alignment: UIStackView.Alignment = .center,
                     space: CGFloat = 16) {
        self.init()
        self.axis = axis
        self.distribution = distributon
        self.alignment = alignment
        self.spacing = space
        translatesAutoresizingMaskIntoConstraints = false
    }
}

extension KNTableCell {
    convenience init(height h: CGFloat = 16, color: UIColor = .lightGray) {
        self.init()
        self.height(h)
        backgroundColor = color
    }
}
