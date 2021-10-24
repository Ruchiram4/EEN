//
//  CustomTableView.swift
//  EENAssignment
//
//  Created by Ruchira Macbook on 2021-10-12.
//

import UIKit

class CustomTableView { }

extension UITableView {
    
    func displayPlaceholderView(withMessage: String) {

        let placeholderLabel = UILabel()
        placeholderLabel.text = withMessage
        placeholderLabel.textColor = .black
        placeholderLabel.textAlignment = .center
        placeholderLabel.backgroundColor = .white
        placeholderLabel.font = UIFont.systemFont(ofSize: 16.0)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.separatorStyle = .none
        self.isScrollEnabled = false
        self.backgroundView = placeholderLabel
    }
    
    func hidePlaceholderView() {
        
        self.backgroundView = nil
        self.isScrollEnabled = true
        self.separatorStyle = .singleLine
    }
}
