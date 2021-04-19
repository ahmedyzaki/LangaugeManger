//
//  LanguageManager.swift
//  SemanticManagerExample
//
//  Created by Ahmed Zaki on 19/04/2021.
//

import UIKit

class LanguageManager {
    // MARK: - Attributes
    var delegate: LanguageManagerDelegate?
    private let appleLanguagesKey = "AppleLanguages"
    var currentLanguage: Language {
        let currentLanguage = UserDefaults.standard.value(forKey: appleLanguagesKey) as? [String] ?? [Language.english.rawValue]
        return Language(rawValue: "\(currentLanguage.first ?? Language.english.rawValue)") ?? .english
    }
    var viewDirection: UISemanticContentAttribute {
        return currentLanguage.isRTL ? .forceRightToLeft : .forceLeftToRight
    }
    var preferredLocale: Locale { return Locale(identifier: currentLanguage.rawValue) }
    // MARK: - Init
    private init() {}
    static let shared: LanguageManager = LanguageManager()
    // MARK: - Methods
    func setLanguage(_ language: Language) {
        UserDefaults.standard.setValue([language.rawValue], forKey: appleLanguagesKey)
        setSemanticContentAttribute(semantic: viewDirection)
        SwizzlingService.shared.doSwizzling()
        reset()
    }
    func reset() {
        delegate?.setRoot()
        debugPrint("Lang: \(currentLanguage)")
        guard let window = UIApplication.shared.keyWindow else { return }
        let option: UIView.AnimationOptions = currentLanguage.isRTL ? .transitionFlipFromRight : .transitionFlipFromLeft
        UIView.transition(with: window, duration: 0.5, options: option, animations: nil, completion: nil)
    }
    func setDefaultLanguage(_ language: Language) {
        guard language != currentLanguage else { return }
        UserDefaults.standard.setValue([language.rawValue], forKey: appleLanguagesKey)
        setSemanticContentAttribute(semantic: viewDirection)
        SwizzlingService.shared.doSwizzling()
    }
    func setSemanticContentAttribute(semantic: UISemanticContentAttribute) {
        UINavigationBar.appearance().semanticContentAttribute = semantic
        UITabBar.appearance().semanticContentAttribute = semantic
        UISearchBar.appearance().semanticContentAttribute = semantic
    }
}
