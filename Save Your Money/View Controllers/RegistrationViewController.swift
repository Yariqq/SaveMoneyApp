//
//  RegistrationViewController.swift
//  Save Your Money
//
//  Created by Ярослав Петюль on 6/7/20.
//  Copyright © 2020 Ярослав Петюль. All rights reserved.
//

import UIKit
import RealmSwift

class RegistrationViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    var editIdentifier = 0
    var nameToFill: String!, emailToFill: String!
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
    }

    //MARK: - Methods
    func setUpElements() {
        signUpButton.layer.borderWidth = 0.3
        
        nameTextField.text = nameToFill
        emailTextField.text = emailToFill
        
        if editIdentifier == 1 {
            signUpButton.setTitle("Изменить", for: .normal)
        } else {
            signUpButton.setTitle("Зарегистрироваться", for: .normal)
        }
    }
    
    func warningAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ок", style: .cancel)
        alertController.addAction(okButton)
        self.present(alertController, animated: true)
    }
    
    func isSignUpCorrect() -> Bool {
        if nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
           emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
           passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            warningAlert(title: "Ошибка", message: "Заполните все поля")
            return false
            
        } else if passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).count < 8 {
            
            warningAlert(title: "Ошибка", message: "Пароль должен иметь не менее восьми символов")
            return false
            
        } else if emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).contains("@") == false ||
                  emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).contains(".") == false {
            
            warningAlert(title: "Ошибка", message: "Некорректно введен электронный адрес")
            return false
            
        } else {
            return true
        }
    }
    
    func writeToDataBase() {
        let realm = try! Realm()
        let user = Users()
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        user.name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        user.email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        user.password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        try! realm.write {
            realm.add(user)
        }
    }
    
    func updateDataBase() {
        let realm = try! Realm()
        let userNow = realm.objects(Users.self).filter("email = '\(emailToFill ?? "")'").first
        
        try! realm.write {
            userNow!.name = nameTextField.text
            userNow!.email = emailTextField.text
            userNow!.password = passwordTextField.text
        }
    }
    
    //MARK: - Actions
    @IBAction func signUpButtonTapped(_ sender: Any) {
        if isSignUpCorrect() == true && editIdentifier == 0 {
            
            writeToDataBase()
            let timerViewController = storyboard?.instantiateViewController(identifier: "timerVC") as? ViewController
            navigationController?.pushViewController(timerViewController!, animated: true)
            timerViewController?.loginToPass = emailTextField.text
            
        } else if isSignUpCorrect() == true && editIdentifier == 1 {
            
            updateDataBase()
            let accVC = storyboard?.instantiateViewController(identifier: "AccVC") as? AccountViewController
            navigationController?.pushViewController(accVC!, animated: true)
            accVC?.helpLogin = emailTextField.text
            
        }
    }
}
