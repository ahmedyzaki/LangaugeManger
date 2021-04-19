//
//  SwizzlingManager.swift
//  SemanticManagerExample
//
//  Created by Ahmed Zaki on 19/04/2021.
//

import UIKit

// MARK: - Swizzling
class SwizzlingService: NSObject {
    // MARK: - Init
    private override init() {}
    static let shared = SwizzlingService()
    // MARK: - Swizzling Method
    func doSwizzling() {
        swizzlingNSBundle()
        swizzlingUIApplication()
        swizzlingUILabel()
        swizzlingUITextField()
        swizzlingUITextView()
        swizzlingUIImageView()
        swizzlingUIStackView()
    }
    private static func methodSwizzleGivenClassName(cls: AnyClass, originalSelector: Selector, overrideSelector: Selector) {
        let originalMethod: Method = class_getInstanceMethod(cls, originalSelector)!
        let overrideMethod: Method = class_getInstanceMethod(cls, overrideSelector)!
        if class_addMethod(cls, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod)) {
            class_replaceMethod(cls, overrideSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, overrideMethod)
        }
    }
    private func swizzlingUITextField() {
        Self.methodSwizzleGivenClassName(cls: UITextField.self,
                                         originalSelector: #selector(UITextField.awakeFromNib),
                                         overrideSelector: #selector(UITextField.customAwakeFromNib))
    }
    private func swizzlingUITextView() {
        Self.methodSwizzleGivenClassName(cls: UITextView.self,
                                         originalSelector: #selector(UITextView.awakeFromNib),
                                         overrideSelector: #selector(UITextView.customAwakeFromNib))
    }
    private func swizzlingUILabel() {
        Self.methodSwizzleGivenClassName(cls: UILabel.self,
                                         originalSelector: #selector(UILabel.awakeFromNib),
                                         overrideSelector: #selector(UILabel.customAwakeFromNib))
    }
    private func swizzlingUIImageView() {
        Self.methodSwizzleGivenClassName(cls: UIImageView.self,
                                         originalSelector: #selector(UIImageView.awakeFromNib),
                                         overrideSelector: #selector(UIImageView.customAwakeFromNib))
    }
    private func swizzlingUIStackView() {
        Self.methodSwizzleGivenClassName(cls: UIStackView.self,
                                         originalSelector: #selector(UIImageView.awakeFromNib),
                                         overrideSelector: #selector(UIImageView.customAwakeFromNib))
    }
    private func swizzlingUIApplication() {
        Self.methodSwizzleGivenClassName(
            cls: UIApplication.self,
            originalSelector: #selector(getter: UIApplication.userInterfaceLayoutDirection),
            overrideSelector: #selector(getter: UIApplication.customUserInterfaceLayoutDirection)
        )
    }
    private func swizzlingNSBundle() {
        Self.methodSwizzleGivenClassName(cls: Bundle.self, originalSelector: #selector(Bundle.localizedString(forKey:value:table:)), overrideSelector: #selector(Bundle.customLocalizedString(forKey:value:table:)))
    }
}
// MARK: - UIApplication
extension UIApplication {
    @objc var customUserInterfaceLayoutDirection: UIUserInterfaceLayoutDirection {
        return LanguageManager.shared.currentLanguage.isRTL ?  .rightToLeft :  .leftToRight
    }
}
// MARK: - UIImageView
extension UIImageView {
    @objc func customAwakeFromNib() {
        super.awakeFromNib()
        if LanguageManager.shared.currentLanguage.isRTL && tag < 0 {
            image = image?.imageFlippedForRightToLeftLayoutDirection()
        }
    }
}
// MARK: - UIStackView
extension UIStackView {
    @objc func customAwakeFromNib() {
        super.awakeFromNib()
        guard semanticContentAttribute == .unspecified else { return }
        semanticContentAttribute = LanguageManager.shared.currentLanguage.isRTL ? .forceRightToLeft : .forceLeftToRight
    }
}
// MARK: - UITextField
extension UITextField {
    @objc func customAwakeFromNib() {
        super.awakeFromNib()
        if textAlignment == .center || textAlignment == .justified { return }
        textAlignment = LanguageManager.shared.currentLanguage.isRTL ? .right : .left
    }
}
// MARK: - UILabel
extension UILabel {
    @objc func customAwakeFromNib() {
        super.awakeFromNib()
        if textAlignment == .center { return }
        textAlignment = LanguageManager.shared.currentLanguage.isRTL ? .right : .left
    }
}

// MARK: - Bundle
extension Bundle {
    @objc func customLocalizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        let selectedLanguage = LanguageManager.shared.currentLanguage.rawValue
        guard let path = Bundle.main.path(forResource: selectedLanguage, ofType: "lproj"), let bundle = Bundle(path: path) else {
            return Bundle.main.customLocalizedString(forKey: key, value: value, table: tableName)
        }
        return bundle.customLocalizedString(forKey: key, value: value, table: tableName)
    }
}

// MARK: UITextView
extension UITextView {
    @objc func customAwakeFromNib() {
        super.awakeFromNib()
        if textAlignment == .center { return }
        textAlignment = LanguageManager.shared.currentLanguage.isRTL ? .right : .left
    }

}
