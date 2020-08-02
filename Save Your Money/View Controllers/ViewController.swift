//
//  ViewController.swift
//  Save Your Money
//
//  Created by Ярослав Петюль on 6/2/20.
//  Copyright © 2020 Ярослав Петюль. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: - Outlets
    @IBOutlet weak var farePickerView: UIPickerView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var moneyLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    
    //MARK: - Variables/Constants
    let pickerViewData = [["1", "5", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55", "60"],
                          ["0.1", "0.2", "0.5", "1", "1.5", "2", "3", "5", "10", "15", "20", "30", "50"]]
    
    var timer = Timer()
    var isTimerRunning = false
    var seconds: Float = 0.0
    var startMoney: Float = 0.0
    var loginToPass: String!
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
    }
    
    //MARK: - Methods
    //...................................Необходимые для реализации методы
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewData[0].count
    }
    //....................................................................
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewData[component][row]
    }
    
    func setUpElements() {
        farePickerView.delegate = self
        farePickerView.dataSource = self
        
        startButton.layer.borderWidth = 1.5
        startButton.layer.cornerRadius = 20

        let myProfileButton = UIBarButtonItem()
        let titleFont: UIFont = UIFont(name: "Futura", size: 17)!
        let titleColor: UIColor = UIColor.systemBlue
        let attributes = [NSAttributedString.Key.font: titleFont,
                          NSAttributedString.Key.foregroundColor: titleColor]
        myProfileButton.target = self
        myProfileButton.action = #selector(transactionToAccount(sender:))
        myProfileButton.title = "Мой профиль"
        
        myProfileButton.setTitleTextAttributes(attributes, for: .normal)
        navigationItem.rightBarButtonItem = myProfileButton
        
    }
    
    @objc func transactionToAccount(sender: UIBarButtonItem) {
        let accountViewController = storyboard?.instantiateViewController(identifier: "AccVC") as? AccountViewController
        navigationController?.pushViewController(accountViewController!, animated: true)
        accountViewController?.helpLogin = loginToPass
    }
    
    
    //Seconds and money timers
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
    }
    
    @objc func updateTimer() {
        seconds += 1
        timeLabel.text = timeString(TimeInterval(seconds))
        runMoney()
    }
    
    func timeString(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func runMoney() {
        let fareSeconds = Float(pickerViewData[0][farePickerView.selectedRow(inComponent: 0)])! * 60
        let fareMoney = Float(pickerViewData[1][farePickerView.selectedRow(inComponent: 1)])! * 100
        
        startMoney = Float((fareMoney * seconds) / fareSeconds) / 100
        moneyLabel.text = String(format: "%.2f", startMoney)
    }
    
    func writeTotalMoneyToDb(savedMoney: String?) {
        let realm = try! Realm()
        let userNow = realm.objects(Users.self).filter("email = '\(self.loginToPass ?? "")'").first
        
        try! realm.write {
            userNow!.totalSavedMoney += Float(savedMoney!)!
        }
    }
    
    //Alert for saving money in profile
    func alert(title: String?, message: String?, savedMoney: String?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let yesButton = UIAlertAction(title: "Да", style: .default) { (yesButton) in
            self.writeTotalMoneyToDb(savedMoney: savedMoney)
        }
        let noButton = UIAlertAction(title: "Нет", style: .default)
        alertController.addAction(noButton)
        alertController.addAction(yesButton)
        self.present(alertController, animated: true)
    }
    
    //MARK: - Actions
    @IBAction func startButtonTapped(_ sender: Any) {
        if startButton.title(for: .normal) == "Старт" {
            runTimer()
            startButton.setTitle("Стоп", for: .normal)
            farePickerView.isUserInteractionEnabled = false
        } else {
            let savedMoney = moneyLabel.text
            seconds = -1.0
            startMoney = 0.0
            updateTimer()
            
            timer.invalidate()
            startButton.setTitle("Старт", for: .normal)
            isTimerRunning = false
            
            alert(title: nil, message: "Желаете сохранить сумму \(savedMoney!) BYN в ваш профиль?", savedMoney: savedMoney)
            farePickerView.isUserInteractionEnabled = true
        }
    }
}

