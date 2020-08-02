//
//  AuthorizationViewController.swift
//  Save Your Money
//
//  Created by Ярослав Петюль on 6/7/20.
//  Copyright © 2020 Ярослав Петюль. All rights reserved.
//

import UIKit
import RealmSwift

class AuthorizationViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var loginTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
    }
    
    //MARK: - Methods
    func setUpElements() {
        loginButton.layer.borderWidth = 0.3
    }
    
    func warningAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ок", style: .cancel)
        alertController.addAction(okButton)
        self.present(alertController, animated: true)
    }
    
    func login() -> Bool {
        let login = loginTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let realm = try! Realm()
        let results = realm.objects(Users.self).filter("email = '\(login ?? "")'")
        
        if login == "" || password == "" {
            
            warningAlert(title: "Ошибка", message: "Заполните все поля")
            return false
            
        } else if results.count == 0 {
            
            warningAlert(title: "Ошибка", message: "Введен неверный электронный адрес")
            return false
            
        } else if results[0].password != password {
            
            warningAlert(title: "Ошибка", message: "Введен неверный пароль")
            return false
            
        } else {
            
            return true
        }
    }
    
    //MARK: - Actions
    @IBAction func loginButtonTapped(_ sender: Any) {
        if login() == true {
            
            let timerViewController = storyboard?.instantiateViewController(identifier: "timerVC") as? ViewController
            navigationController?.pushViewController(timerViewController!, animated: true)
            timerViewController?.loginToPass = loginTextField.text
            loginTextField.text = ""
            passwordTextField.text = ""
        }
    }
    
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
    }
    
}
