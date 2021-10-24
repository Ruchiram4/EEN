//
//  CameraCell.swift
//  EENAssignment
//
//  Created by Ruchira Macbook on 2021-10-11.
//

import UIKit

class CameraCell: UITableViewCell {

    let cameraIdLabel = UILabel()
    let cameraNameLabel = UILabel()
    let macAddressLabel = UILabel()
    let zoneIdLabel = UILabel()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCellValues(camera: Camera?) -> Void {
        
        guard let camera = camera else { return }
        
        if let name = camera.name, let id = camera.cameraId, let macAddress = camera.ethernetMacAddress, let zone = camera.zoneId {
            
            cameraIdLabel.attributedText = Utils.getAttributedStringWithFirstStringBold(boldText: NSLocalizedString("txt_camera_view_camera_id", comment: ""), normalText: String(id))
            cameraNameLabel.attributedText = Utils.getAttributedStringWithFirstStringBold(boldText: NSLocalizedString("txt_camera_view_camera_name", comment: ""), normalText: name)
            macAddressLabel.attributedText = Utils.getAttributedStringWithFirstStringBold(boldText: NSLocalizedString("txt_camera_view_mac_address", comment: ""), normalText: macAddress)
            zoneIdLabel.attributedText = Utils.getAttributedStringWithFirstStringBold(boldText: NSLocalizedString("txt_camera_view_zone_id", comment: ""), normalText: String(zone))
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        cameraIdLabel.textColor = .black
        cameraIdLabel.font = UIFont(name: "vonnes-lightcondensed", size: 16.0)
        cameraIdLabel.numberOfLines = 0
        cameraIdLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cameraIdLabel)
        
        cameraNameLabel.textColor = .black
        cameraNameLabel.font = UIFont(name: "vonnes-lightcondensed", size: 16.0)
        cameraNameLabel.numberOfLines = 0
        cameraNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cameraNameLabel)
        
        macAddressLabel.textColor = .black
        macAddressLabel.font = UIFont(name: "vonnes-lightcondensed", size: 16.0)
        macAddressLabel.numberOfLines = 0
        macAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(macAddressLabel)
        
        zoneIdLabel.textColor = .black
        zoneIdLabel.font = UIFont(name: "vonnes-lightcondensed", size: 16.0)
        zoneIdLabel.numberOfLines = 0
        zoneIdLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(zoneIdLabel)
        
        NSLayoutConstraint.activate([
            
            cameraIdLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20.0),
            cameraIdLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20.0),
            cameraIdLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20.0),
            
            cameraNameLabel.topAnchor.constraint(equalTo: cameraIdLabel.bottomAnchor, constant: 8.0),
            cameraNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20.0),
            cameraNameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20.0),
            
            macAddressLabel.topAnchor.constraint(equalTo: cameraNameLabel.bottomAnchor, constant: 8.0),
            macAddressLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20.0),
            macAddressLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20.0),
            
            zoneIdLabel.topAnchor.constraint(equalTo: macAddressLabel.bottomAnchor, constant: 8.0),
            zoneIdLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20.0),
            zoneIdLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20.0),
            zoneIdLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20.0)
        ])
    }
}
