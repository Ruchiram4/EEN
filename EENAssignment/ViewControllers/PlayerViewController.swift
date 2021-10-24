//
//  PlayerViewController.swift
//  EENAssignment
//
//  Created by Ruchira Macbook on 2021-10-16.
//

import Foundation
import UIKit
import AVFoundation
import AVKit

class PlayerViewController: UIViewController {
    
    let playerViewController = AVPlayerViewController()
    var playerItem: AVPlayerItem?
    var player = AVPlayer()
    var urlString:String?

    override func viewDidLoad() {
        startPlaying()
        self.view.addSubview(playerViewController.view)
    }

    init(withUrl: String){
        self.urlString = withUrl
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do not use this initializer.")
    }
    
    func addAuthenticationToUrl(aUrlString: String?) -> String {
        if let aUrlString = aUrlString, let accessToken = AppDataManager.shared.accessToken {
            let newUrlString = aUrlString + "&access_token=\(accessToken)"
            return newUrlString
        }
        return ""
    }
    
    func startPlaying() {

        if let urlOfCameraString = urlString, let url = URL(string: addAuthenticationToUrl(aUrlString: urlOfCameraString)) {
            let asset = AVAsset(url: url)
            let playerItem = AVPlayerItem(asset: asset)
            //playerItem.preferredMaximumResolution = CGSize(width: 100, height: 100)
            player.replaceCurrentItem(with: playerItem)
            playerViewController.player = player
            playerViewController.player?.play()
            
            
        }
    }
}
