//
//  LoginViewController.swift
//  EENAssignment
//
//  Created by Ruchira Macbook on 2021-10-10.
//

import UIKit

class LoginViewController: BaseViewController, UITextFieldDelegate {

    var usernameTextField: UITextField?
    var passwordTextField: UITextField?
    var loadingView: UIView?
    let backgroundButton = UIButton()
    
    override init(withAPIClient: APIClientProtocol){
        super.init(withAPIClient: withAPIClient)        
    }
    
    required init?(coder: NSCoder) {
        fatalError("Oops... You should not call this init...")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blueBackground
        loadUIComponents()
    }
    
    func hideKeyboards() {
        usernameTextField?.resignFirstResponder()
        passwordTextField?.resignFirstResponder()
    }
    
    @objc func backgroundButtonClick() {
        hideKeyboards()
    }
    
    @objc func loginButtonClick(){
        
        if Utils.isInternetAvailable() == false {
            displayNoInternetMessage()
            return
        }
        
        hideKeyboards()
        
        if let username = usernameTextField?.text, let password = passwordTextField?.text {
            if username.isEmpty || password.isEmpty {
                let alert = UIAlertController(title: NSLocalizedString("msg_title_oops", comment: ""), message: NSLocalizedString("msg_body_enter_both_username_password", comment: ""), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("msg_ok", comment: ""), style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            }
            else {
                
                displayLoadingView()
                guard let apiClient = self.apiClient else { return }
                
                apiClient.login(userName: username, password: password) { result, responseError in
                    self.hideLoadingView()
                    if responseError == .none {
                        let homeViewController = Factory.createHomeViewController()
                        self.navigationController?.pushViewController(homeViewController, animated: true)
                    }
                    else if responseError == .authentication {
                        
                        self.displayAlertMessage(withTitle: NSLocalizedString("msg_title_oops", comment: ""), andMessage: NSLocalizedString("msg_body_incorrect_cred", comment: ""), andCancelButton: NSLocalizedString("msg_ok", comment: ""), andOKButton: nil)
                        
                    }
                    else {
                        
                        self.displayAlertMessage(withTitle: NSLocalizedString("msg_title_oops", comment: ""), andMessage: NSLocalizedString("msg_body_difficulty", comment: ""), andCancelButton: NSLocalizedString("msg_ok", comment: ""), andOKButton: nil)
                    }
                }
            }
        }
    }

    override func loadUIComponents() {
        
        backgroundButton.addTarget(self, action: #selector(backgroundButtonClick), for: .touchUpInside)
        backgroundButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundButton)
        
        self.navigationItem.rightBarButtonItem = nil
        
        let userNameTextField = UITextField()
        userNameTextField.translatesAutoresizingMaskIntoConstraints = false
        userNameTextField.keyboardType = .emailAddress
        userNameTextField.borderStyle = .roundedRect
        userNameTextField.font = UIFont(name: "vonnes-lightcondensed", size: 24.0)
        userNameTextField.placeholder = NSLocalizedString("txt_enter_username", comment: "")
        userNameTextField.delegate = self
        self.usernameTextField = userNameTextField
        view.addSubview(userNameTextField)
        
        let passwordTextField = UITextField()
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.keyboardType = .emailAddress
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.font = UIFont(name: "vonnes-lightcondensed", size: 24.0)
        passwordTextField.placeholder = NSLocalizedString("txt_enter_password", comment: "")
        passwordTextField.delegate = self
        self.passwordTextField = passwordTextField
        view.addSubview(passwordTextField)
        
        let shakeMeLabel = UILabel()
        shakeMeLabel.text = NSLocalizedString("txt_shake_for_demo", comment: "")
        shakeMeLabel.textColor = .white
        shakeMeLabel.font = UIFont(name: "vonnes-lightcondensed", size: 18.0)
        shakeMeLabel.translatesAutoresizingMaskIntoConstraints = false
        shakeMeLabel.textAlignment = .center
        view.addSubview(shakeMeLabel)
        
        let loginButton: UIButton = UIButton()
        loginButton.setTitle(NSLocalizedString("btn_login", comment: ""), for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.setTitleColor(.black, for: .highlighted)
        loginButton.titleLabel?.font = UIFont(name: "vonnes-lightcondensed", size: 36.0)
        loginButton.addTarget(self, action: #selector(loginButtonClick), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        
        self.loadingView = UIView()
        self.loadingView?.backgroundColor = .loadingViewBackground
        loadingView?.translatesAutoresizingMaskIntoConstraints = false
        loadingView?.isHidden = true
        
        let activity = UIActivityIndicatorView(style: .large)
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.color = .white
        self.loadingView?.addSubview(activity)
        activity.startAnimating()
        activity.hidesWhenStopped = true
        
        if let loadingView = loadingView {
            view.addSubview(loadingView)
            
            NSLayoutConstraint.activate([
                
                backgroundButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                backgroundButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                backgroundButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
                backgroundButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
                
                userNameTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 100),
                userNameTextField.heightAnchor.constraint(equalToConstant: 44.0),
                userNameTextField.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 20),
                userNameTextField.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -20),
                
                passwordTextField.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 20),
                passwordTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
                passwordTextField.heightAnchor.constraint(equalToConstant: 44.0),
                passwordTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
                
                shakeMeLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
                shakeMeLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
                shakeMeLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
                
                loginButton.topAnchor.constraint(equalTo: shakeMeLabel.bottomAnchor, constant: 30.0),
                loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                loginButton.heightAnchor.constraint(equalToConstant: 44.0),
                
                loadingView.topAnchor.constraint(equalTo: view.topAnchor),
                loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                loadingView.rightAnchor.constraint(equalTo: view.rightAnchor),
                loadingView.leftAnchor.constraint(equalTo: view.leftAnchor),
                
                activity.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
                activity.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor)
            ])
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if textField == usernameTextField{
            passwordTextField?.becomeFirstResponder()
        }
        else if textField == passwordTextField {
            passwordTextField?.resignFirstResponder()
        }
        return true
    }
    
    func displayLoadingView(){
        loadingView?.isHidden = false
    }
    
    func hideLoadingView(){
        loadingView?.isHidden = true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            usernameTextField?.text = Constants.DEMO_USERNAME
            passwordTextField?.text = Constants.DEMO_PASSWORD
            loginButtonClick()
        }
    }
    
}
