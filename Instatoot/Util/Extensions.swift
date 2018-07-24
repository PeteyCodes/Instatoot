//
//  Extensions.swift
//  Instatoot
//
//  Created by Peter de Tagyos on 7/21/18.
//  Copyright © 2018 Peter de Tagyos. All rights reserved.
//

import UIKit


extension UIFont {
    static func appRegularFontWithSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.regularFont, size: size)!
    }

    static func appBoldFontWithSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.boldFont, size: size)!
    }

    static func appItalicFontWithSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.italicFont, size: size)!
    }

    static func appLightFontWithSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.lightFont, size: size)!
    }
}

