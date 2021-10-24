//
//  BaseViewController.swift
//  EENAssignment
//
//  Created by Ruchira Macbook on 2021-10-12.
//


import UIKit

class BaseViewController: UIViewController {

    var logOutButton: UIBarButtonItem?
    var apiClient: APIClientProtocol?
    
    func loadUIComponents(){
        preconditionFailure("Method must be overriden by child class.")
    }
    
    required init?(coder: NSCoder) {
        fatalError("Do not use this class directly. Subclass this instead.")
    }
    
    init(withAPIClient: APIClientProtocol) {
        
        super.init(nibName: nil, bundle: nil)
        self.apiClient = withAPIClient
        self.logOutButton = UIBarButtonItem(title: NSLocalizedString("btn_logout", comment: ""), style: .plain, target: self, action: #selector(logOutPress))
        self.logOutButton?.setTitleTextAttributes([
                                                    NSAttributedString.Key.font: UIFont(name: "vonnes-lightcondensed", size: 24)!,
                                                    NSAttributedString.Key.foregroundColor: UIColor.black],
                                                  for: .normal)
        self.logOutButton?.setTitleTextAttributes([
                                                    NSAttributedString.Key.font: UIFont(name: "vonnes-lightcondensed", size: 24)!,
                                                    NSAttributedString.Key.foregroundColor: UIColor.white],
                                                  for: .highlighted)
        
        self.navigationController?.navigationBar.isTranslucent = false
        
    }
    
    func hideLogoutButton() {
        self.navigationItem.rightBarButtonItem = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = logOutButton
    }
    
    @objc func logOutPress() {

        self.apiClient?.logOut(completion: { responseError in
            AppDataManager.shared.clearTokens()
            self.navigationController?.popToRootViewController(animated: true)
            
        })
    }
    
    func displayNoInternetMessage() {
        displayAlertMessage(withTitle: NSLocalizedString("msg_title_oops", comment: ""), andMessage: NSLocalizedString("msg_no_internet", comment: ""), andCancelButton: NSLocalizedString("msg_ok", comment: ""), andOKButton: nil)
    }

    func displayAlertMessage(withTitle: String, andMessage: String, andCancelButton: String?, andOKButton: String? ) {
        
        let alert = UIAlertController(title: withTitle, message: andMessage, preferredStyle: .alert)
        
        if let _ = andCancelButton {
            alert.addAction(UIAlertAction(title: andCancelButton, style: .cancel, handler: nil))
        }
        
        if let _ = andOKButton {
            alert.addAction(UIAlertAction(title: andOKButton, style: .default, handler: nil))
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
