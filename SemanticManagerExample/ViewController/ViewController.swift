//
//  ViewController.swift
//  SemanticManagerExample
//
//  Created by Ahmed Zaki on 19/04/2021.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func didChangeLangaugeButtonTapped(_ sender: UIButton) {
        let lang: Language =  LanguageManager.shared.currentLanguage.isRTL ? .english : .arabic
        LanguageManager.shared.setLanguage(lang)
    }
}
