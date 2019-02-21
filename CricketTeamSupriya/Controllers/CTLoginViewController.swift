//
//  CTLoginViewController.swift
//  CricketTeamSupriya
//
//  Created by Supriya Malgaonkar on 21/02/19.
//  Copyright © 2019 Supriya Malgaonkar. All rights reserved.
//

import UIKit

class CTLoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var passwordShowHideButton: UIButton!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    //MARK: - UI Helpers
    
    private func setupView() {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.containerView.layer.cornerRadius = DEFAULT_CORNER_RADIUS
        self.loginButton.layer.cornerRadius = DEFAULT_CORNER_RADIUS
        
        self.passwordShowHideButton.setImage(UIImage(named: "showPswd"), for: .selected)
        self.passwordShowHideButton.setImage(UIImage(named: "hidePswd"), for: .normal)
        self.passwordShowHideButton.isSelected = self.passwordTF.isSecureTextEntry
    }
    
    
    //MARK: - Actions
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        
        sender.isUserInteractionEnabled = false
        
        let emailVal = self.emailTF.text
        let passwordVal = self.passwordTF.text
        
        if emailVal != nil && emailVal! != "" {
            if passwordVal != nil && passwordVal! != "" {
                
                CustomLoadingView.customLoaderInstance.showLoader(onView: sender, style: .white)
                
                CTRequestManager.getSharedManager().loginUser(emailValue: "maheshwari@techcetra.com", passwordValue: passwordVal!) { (response) in
                    print("\n Response : \(response)")
                    print("\n")
                    
                    sender.isUserInteractionEnabled = true
                    
                    if response["success"].boolValue {
                        CustomLoadingView.customLoaderInstance.hideLoader()
                        
                        setUserToken(tokenVal: response["data"]["token"].stringValue)
                        
                        self.emailTF.resignFirstResponder()
                        self.passwordTF.resignFirstResponder()
                        
                        showAlert(titleVal: "", messageVal: response["msg"].stringValue, withNavController: self.navigationController, completion: { (_) in
                            
                            let playerListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "playerListView") as! CTPlayersListViewController
                            self.navigationController?.pushViewController(playerListVC, animated: true)
                        })
                    }
                    else {
                        
                        CustomLoadingView.customLoaderInstance.hideLoader()
                        
                        var msg = "Invalid email or password"
                        if let firstError = response["errors"].arrayValue.first {
                            msg = firstError["msg"].stringValue
                        }
                        
                        self.emailTF.resignFirstResponder()
                        self.passwordTF.resignFirstResponder()
                        
                        showAlert(titleVal: "Error", messageVal: msg, withNavController: self.navigationController, completion: { (_) in
                        })
                        
                        self.emailTF.text = ""
                        self.passwordTF.text = ""
                        
                    }
                }
            }
            else {
                showAlert(titleVal: "Error", messageVal: "Please enter password.", withNavController: self.navigationController) { (_) in
                }
            }
        }
        else {
            showAlert(titleVal: "Error", messageVal: "Please enter valid email.", withNavController: self.navigationController) { (_) in
            }
        }
    }
    
    @IBAction func passwordToggleButtonClicked(_ sender: UIButton) {
        self.passwordTF.isSecureTextEntry = !self.passwordShowHideButton.isSelected
        self.passwordShowHideButton.isSelected = self.passwordTF.isSecureTextEntry
    }
    
    
    //MARK: - TextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}
