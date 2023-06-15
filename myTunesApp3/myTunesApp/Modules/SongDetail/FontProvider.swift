//
//  FontProvider.swift
//  myTunesApp
//
//  Created by Baki Uçan on 15.06.2023.
//

import UIKit

protocol FontProvider {
    func boldSystemFont(ofSize fontSize: CGFloat) -> Any
    func systemFont(ofSize fontSize: CGFloat) -> Any
}

struct UIKitFontProvider: FontProvider {
    func boldSystemFont(ofSize fontSize: CGFloat) -> Any {
        return UIFont.boldSystemFont(ofSize: fontSize)
    }

    func systemFont(ofSize fontSize: CGFloat) -> Any {
        return UIFont.systemFont(ofSize: fontSize)
    }
}
