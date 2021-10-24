//
//  Utils.swift
//  EENAssignment
//
//  Created by Ruchira Macbook on 2021-10-09.
//

import Foundation
import UIKit

class Utils {
    
    static func getAttributedStringWithFirstStringBold(boldText: String, normalText: String) -> NSAttributedString{
        
        let attrs = [NSAttributedString.Key.font : UIFont(name: "Vonnes-BoldCondensed", size: 16.0)]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs as [NSAttributedString.Key : Any])

        let normalText = normalText
        let normalString = NSMutableAttributedString(string:normalText)

        attributedString.append(normalString)
        
        return attributedString
    }
    
    public static func isInternetAvailable() -> Bool {
        
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        if let appDelegate = appDelegate {
            return appDelegate.internetAvailable
        }
        return false
    }

}


extension String {
    
    func base64Encode() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    func isNonEmpty() -> Bool {
        return !self.isEmpty
    }
    
}
