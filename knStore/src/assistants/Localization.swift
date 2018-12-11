//
//  Localization.swift
//  Coinhako
//
//  Created by Ky Nguyen on 10/3/17.
//  Copyright © 2017 Coinhako. All rights reserved.
//

import Foundation

enum Language: String {
    case en, vi
}

var i18nBoss = knTranslatorBoss()

class knTranslatorBoss {
    private lazy var onlineTranslator = knOnlineTranslator(lang: currentLang)
    private lazy var offlineTranslator = knOfflineTranslator(lang: currentLang)
    
    func register() {
        onlineTranslator.register()
    }
    private var _needUpdate = false
    var needUpdate: Bool {
        get { return _needUpdate }
    }
    
    private var currentLang: Language {
        get {
            
            guard let saveKey = UserDefaults.standard.value(forKeyPath: "currentLang") as? String else { return .en}
            return Language(rawValue: saveKey) ?? .en
        }
        set {
            _needUpdate = currentLang != newValue
            return UserDefaults.standard.setValue(newValue.rawValue, forKeyPath: "currentLang") }
    }
    
    func getCurrentLang() -> Language {
        return currentLang
    }
    
    func change(to lang: String) {
        guard let newLang = Language(rawValue: lang) else { return }
        currentLang = newLang
        onlineTranslator.change(to: currentLang)
        offlineTranslator.change(to: currentLang)
    }
    
    func getUpdate() {
        onlineTranslator.getUpdate()
    }
    
    func getOfflineText(_ key: String) -> String {
        return offlineTranslator.offlineTranslate(string: key)
    }
}

private class knOnlineTranslator {
    init(lang: Language) {
        register()
        change(to: lang)
    }
    
    func register() {
//        Lokalise.shared.setAPIToken(coinSetting.lokaliseToken,
//                                    projectID: coinSetting.lokaliseId)
//        Lokalise.shared.swizzleMainBundle()
//        #if DEBUG
//        Lokalise.shared.localizationType = .prerelease
//        #else
//        Lokalise.shared.localizationType = .release
//        #endif
        
    }
    
    func change(to lang: Language) {
//        Lokalise.shared.setLocalizationLocale(Locale(identifier: lang.rawValue),
//                                              makeDefault: false) { (err) in print(err ?? "set_lokalise_lang_success") }
    }
    
    func getUpdate() {
//        Lokalise.shared.checkForUpdates { (success, err) in print(err ?? "get_lokalise_update_success") }
    }
}

private class knOfflineTranslator {
    init(lang: Language) {
        dictionary = getLanguageFile(lang: lang)
    }
    
    func change(to lang: Language) {
        dictionary = getLanguageFile(lang: lang)
    }
    
    private var dictionary: NSDictionary = [:]
    private func getLanguageFile(lang: Language) -> NSDictionary {
        let fileName = "\(lang.rawValue).lproj/Localizable"
        if let path = Bundle.main.path(forResource: fileName, ofType: "plist") {
            return NSDictionary(contentsOfFile: path)! }
        return [:]
    }
    
    func offlineTranslate(string: String) -> String {
        guard let localizedString = dictionary.value(forKeyPath: string) as? String else { return string }
        return localizedString
    }
}

extension String {
    var i18n: String {
        let text = NSLocalizedString(self, comment: "")
        if text == "" { return self }
        if text == self { return i18nBoss.getOfflineText(self) }
        return text
    }
}
