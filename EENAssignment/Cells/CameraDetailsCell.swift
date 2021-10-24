//
//  CameraDetailsCell.swift
//  EENAssignment
//
//  Created by Ruchira Macbook on 2021-10-12.
//

import UIKit

class CameraDetailsCell: UITableViewCell {

    let contentLabel = UILabel()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    func updateCellValues(withObject: CameraStatusDetail?, row: Int) -> Void {
        
        guard let _ = withObject else { return }
        
        if let key = withObject?.key, let value = withObject?.value {
            
            contentLabel.attributedText = Utils.getAttributedStringWithFirstStringBold(boldText: "\(key): ", normalText: value)
        }
        
        self.accessoryType = row == 0 ? .disclosureIndicator : .none
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentLabel.textColor = .black
        contentLabel.font = UIFont(name: "vonnes-lightcondensed", size: 16.0)
        contentLabel.numberOfLines = 0
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentLabel)

        NSLayoutConstraint.activate([
            
            contentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20.0),
            contentLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20.0),
            contentLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20.0),
            contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20.0)
           
        ])
     
    }


}

