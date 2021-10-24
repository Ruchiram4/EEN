//
//  HomeViewController.swift
//  EENAssignment
//
//  Created by Ruchira Macbook on 2021-10-08.
//

import UIKit

class HomeViewController: BaseViewController {

    var cameras: [Camera]?
    let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
    let messageNoCamerasPlaceholder: String = NSLocalizedString("txt_no_cameras_placeholder", comment: "")
    let cellIdentifier = "CamerasCell"
    let loadingView = UIView()
    let refreshControl = UIRefreshControl()
    
    public override init(withAPIClient: APIClientProtocol) {
        super.init(withAPIClient: withAPIClient)
    }
    
    required init?(coder: NSCoder) {
        fatalError("This initializer is not meant to be used.")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = .white
        loadUIComponents()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.downloadData()
        }
    }
    
    override func loadUIComponents(){
        
        self.navigationController?.navigationBar.isHidden = false
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.register(CameraCell.self, forCellReuseIdentifier: cellIdentifier)
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
    
    func hideLoadingView() {
        loadingView.isHidden = true
    }
    
    func displayLoadingView() {
        loadingView.isHidden = false
    }
  
    @objc func downloadData() {
        
        if Utils.isInternetAvailable() == false {
            hideLoadingView()
            displayNoInternetMessage()
            return
        }
        
        guard let apiClient = self.apiClient else { return }
        
        displayLoadingView()
        tableView.refreshControl?.endRefreshing()
        
        apiClient.getCamerasWithAutoRefreshingToken { [weak self] cameras, responseError in
            
            self?.hideLoadingView()
            guard let cameras = cameras else {
                guard let messageNoCamerasPlaceholder = self?.messageNoCamerasPlaceholder else { return }
                self?.tableView.displayPlaceholderView(withMessage: messageNoCamerasPlaceholder)
                return
            }
            
            if cameras.isEmpty {
                guard let messageNoCamerasPlaceholder = self?.messageNoCamerasPlaceholder else { return }
                self?.tableView.displayPlaceholderView(withMessage: messageNoCamerasPlaceholder)
            }
            else {
                self?.tableView.hidePlaceholderView()
            }
            
            self?.cameras = cameras
            self?.tableView.reloadData()

        }
    }
    
    override func logOutPress() {
        displayLoadingView()
        super.logOutPress()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: CameraCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CameraCell
        
        guard let cellAlias = cell else { return UITableViewCell() }
        
        if let cameras = cameras {
            
            if indexPath.row < cameras.count{
                cellAlias.updateCellValues(camera: cameras[indexPath.row])
            }
        }
    
        return cellAlias
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cameras = cameras else {return 0}
        
        return cameras.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if Utils.isInternetAvailable() == false {
            displayNoInternetMessage()
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cameras = cameras else { return }
        let selectedCamera = cameras[indexPath.row]
        let nextViewController = Factory.createDetailsViewController(withCamera: selectedCamera)
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
}
