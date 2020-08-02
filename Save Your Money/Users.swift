//
//  UsersInfo.swift
//  Save Your Money
//
//  Created by Ярослав Петюль on 6/14/20.
//  Copyright © 2020 Ярослав Петюль. All rights reserved.
//

import Foundation
import RealmSwift

class Users: Object {
    @objc dynamic var name: String?
    @objc dynamic var email: String?
    @objc dynamic var password: String?
    @objc dynamic var totalSavedMoney: Float = 0.0
}
