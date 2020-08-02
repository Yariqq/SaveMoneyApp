//
//  AccountViewController.swift
//  Save Your Money
//
//  Created by Ярослав Петюль on 6/9/20.
//  Copyright © 2020 Ярослав Петюль. All rights reserved.
//

import UIKit
import RealmSwift

class AccountViewController: UIViewController {
    
    @IBOutlet weak var totalMoneyLabel: UILabel!
    
    var helpLogin: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
    }
    
    //MARK: - Methods
    func setUpElements() {
        let realm = try! Realm()
        let results = realm.objects(Users.self).filter("email = '\(helpLogin ?? "")'")
        navigationItem.title = results[0].name
        totalMoneyLabel.text = String(format: "%.2f", results[0].totalSavedMoney)
    }
    
    func deleteMoneyFromDb() {
        let realm = try! Realm()
        let userNow = realm.objects(Users.self).filter("email = '\(helpLogin ?? "")'").first
        
        try! realm.write {
            userNow!.totalSavedMoney = 0.0
        }
        
        totalMoneyLabel.text = "0.00"
    }
    
    func quitAnAccount() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func alert(title: String?, message: String?, _ actionFunc: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let yesButton = UIAlertAction(title: "Да", style: .default) { (yesButton) in
            actionFunc()
        }
        let noButton = UIAlertAction(title: "Нет", style: .default)
        alertController.addAction(noButton)
        alertController.addAction(yesButton)
        self.present(alertController, animated: true)
    }
    
    //MARK: - Actions
    @IBAction func editButtonTapped(_ sender: Any) {
        let registrationVC = (self.storyboard?.instantiateViewController(withIdentifier: "RegVC")) as! RegistrationViewController as RegistrationViewController
        self.navigationController?.pushViewController(registrationVC, animated: true)
        
        let realm = try! Realm()
        let results = realm.objects(Users.self).filter("email = '\(helpLogin ?? "")'")
        
        registrationVC.nameToFill = results[0].name
        registrationVC.emailToFill = results[0].email
        registrationVC.editIdentifier = 1
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        alert(title: nil, message: "Вы уверены, что хотите обнулить счет?", deleteMoneyFromDb)
    }
    
    @IBAction func quitAccButtonTapped(_ sender: Any) {
        alert(title: nil, message: "Вы уверены, что хотите выйти из аккаунта?", quitAnAccount)
    }
}
