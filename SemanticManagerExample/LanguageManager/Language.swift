//
//  Language.swift
//  SemanticManagerExample
//
//  Created by Ahmed Zaki on 19/04/2021.
//

import Foundation
// MARK: - Language
enum Language: String {
    case arabic = "ar"
    case urdu = "ur"
    case english = "en"
    case french = "fr"
    
    var isRTL: Bool {
        switch self {
        case .arabic, .urdu: return true
        case .english, .french: return false
        }
    }
}


