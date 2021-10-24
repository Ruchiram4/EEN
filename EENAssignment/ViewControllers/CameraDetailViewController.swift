//
//  CameraDetailViewController.swift
//  EENAssignment
//
//  Created by Ruchira Macbook on 2021-10-12.
//

import UIKit

struct CameraStatusDetail {
    var key: String
    var value: String
}

class CameraDetailViewController: BaseViewController {

    var camera: Camera?
    let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
    var loadingView: UIView = UIView()
    var modelArray: [CameraStatusDetail]?
    let refreshControl = UIRefreshControl()
    final let CellIdentifier:String = "DetailCell"
    
    public init(withClient: APIClientProtocol, andCamera: Camera?){
        self.camera = andCamera
        super.init(withAPIClient: withClient)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do not use this method to initiate.")
    }
    
    override func loadUIComponents(){
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 30.0
        tableView.register(CameraDetailsCell.self, forCellReuseIdentifier: CellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        let attributedString = NSAttributedString(string: NSLocalizedString("txt_pull_refresh", comment: ""), attributes: [NSAttributedString.Key.font:UIFont(name: "vonnes-lightcondensed", size: 16.0) as Any])
        refreshControl.attributedTitle = attributedString
        refreshControl.addTarget(self, action: #selector(downloadData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        refreshControl.tintColor = .refreshViewTint
        
        loadingView.backgroundColor = .loadingViewBackground
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        let activity = UIActivityIndicatorView(style: .large)
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.color = .white
        loadingView.addSubview(activity)
        activity.startAnimating()
        activity.hidesWhenStopped = true
        
        view.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingView.leftAnchor.constraint(equalTo: view.leftAnchor),
            loadingView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            activity.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            activity.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor)
        ])
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        loadUIComponents()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.downloadData()
        }

    }
    
    @objc func downloadData() -> Void {
        
        if Utils.isInternetAvailable() == false {
            self.loadingView.isHidden = true
            displayNoInternetMessage()
            return
        }
        
        self.loadingView.isHidden = false
        
        guard let camera = camera, let apiClient = self.apiClient else {return}
        apiClient.getCameraDetailsIncludingStreams(camera: camera) { [weak self] cameraStream, cameraStatus, responseError in
            self?.loadingView.isHidden = true
            self?.refreshControl.endRefreshing()
            self?.camera?.streamUrl = cameraStream?.urls?.hlsHttps
            
            let array = self?.formatData(cameraStatus: cameraStatus, camera: camera)
            self?.modelArray = array
            self?.tableView.reloadData()
        }
    }
    
    override func logOutPress() {
        loadingView.isHidden = false
        super.logOutPress()
    }
    
}

extension CameraDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //For Player view controller
        if indexPath.row == 0 {
            let player: PlayerViewController = Factory.createPlayerViewController(withUrl: camera?.streamUrl)
            self.navigationController?.pushViewController(player, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let modelArray = self.modelArray else { return UITableViewCell() }
        
        let detailsCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as? CameraDetailsCell
        
        guard let detailsCellAlias = detailsCell else { return UITableViewCell() }
        
        if indexPath.row < modelArray.count {
            detailsCellAlias.updateCellValues(withObject: modelArray[indexPath.row], row: indexPath.row)
        }
        
        return detailsCellAlias
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let modelArray = modelArray else { return 0 }
        return modelArray.count
    }
    
    func formatData(cameraStatus: CameraStatus?, camera: Camera?) -> [CameraStatusDetail]? {
        
        guard let cameraStatus = cameraStatus, let camera = camera else { return nil}
        var array = [CameraStatusDetail]()
        
        if let cameraId = camera.cameraId,
           let name = camera.name,
           let deviceTypeId = camera.deviceTypeId,
           let ethernetMacAddress = camera.ethernetMacAddress,
           let zoneId = camera.zoneId,
           let accountId = camera.zoneId,
           let isOnline = cameraStatus.isOnline,
           let isRecordingOnCloud = cameraStatus.isRecordingOnCloud,
           let isAudioEnabled = cameraStatus.isAudioEnabled,
           let isPasswordKnown = cameraStatus.isPasswordKnown,
           let firmwareStatus = cameraStatus.firmwareStatus,
           let lastConnectionResult = cameraStatus.lastConnectionResult{
            
           
            array.append(CameraStatusDetail(key: NSLocalizedString("txt_camera_detail_view_camera_id", comment: ""), value: String(cameraId)))
            array.append(CameraStatusDetail(key: NSLocalizedString("txt_camera_detail_view_camera_name", comment: ""), value: String(name)))
            array.append(CameraStatusDetail(key: NSLocalizedString("txt_camera_detail_view_device_type_id", comment: ""), value: String(deviceTypeId)))
            array.append(CameraStatusDetail(key: NSLocalizedString("txt_camera_detail_view_ethernet_address", comment: ""), value: String(ethernetMacAddress)))
            array.append(CameraStatusDetail(key: NSLocalizedString("txt_camera_detail_view_zone_id", comment: ""), value: String(zoneId)))
            array.append(CameraStatusDetail(key: NSLocalizedString("txt_camera_detail_view_account_id", comment: ""), value: String(accountId)))
            array.append(CameraStatusDetail(key: NSLocalizedString("txt_camera_detail_view_online_status", comment: ""), value: isOnline ? NSLocalizedString("txt_online", comment: "") : NSLocalizedString("txt_offline", comment: "")))
            array.append(CameraStatusDetail(key: NSLocalizedString("txt_camera_detail_view_recording_status", comment: ""), value: isRecordingOnCloud ? NSLocalizedString("txt_recording", comment: "") : NSLocalizedString("txt_not_recording", comment: "")))
            array.append(CameraStatusDetail(key: NSLocalizedString("txt_camera_detail_view_audio_status", comment: ""), value: isAudioEnabled ? NSLocalizedString("txt_enabled", comment: "") : NSLocalizedString("txt_disabled", comment: "")))
            array.append(CameraStatusDetail(key: NSLocalizedString("txt_camera_detail_view_password_status", comment: ""), value: isPasswordKnown ? "txt_password_known" : "txt_password_not_known"))
            array.append(CameraStatusDetail(key: NSLocalizedString("txt_camera_detail_view_firmware_status", comment: ""), value: firmwareStatus))
            array.append(CameraStatusDetail(key: NSLocalizedString("txt_camera_detail_view_last_connection_result", comment: ""), value: lastConnectionResult))
        }
        
        return array
    }
}
