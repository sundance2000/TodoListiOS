//
//  UserDefaults.swift
//  TodoList
//
//  Created by Christian Oberdörfer on 22.03.19.
//  Copyright © 2019 Christian Oberdörfer. All rights reserved.
//

import SwiftyUserDefaults

extension DefaultsKeys {

    static let serverAddress = DefaultsKey<String>(Preferences.serverAddress, defaultValue: Preferences.serverAddressDefaultValue)

}
