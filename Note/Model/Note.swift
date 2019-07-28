//
//  Note.swift
//  Note
//
//  Created by Сергей Гриневич on 22/06/2019.
//  Copyright © 2019 Grinevich Sergey. All rights reserved.
//

import Foundation
import UIKit


struct Note {
    let uid: String
    let title: String
    let contex: String
    let color: UIColor
    let importance: Importance
    let selfDestructionDate: Date?
    
    init(uid: String = UUID().uuidString, title: String, contex: String, color: UIColor?, importance: Importance?, selfDestructionDate: Date? = nil) {
//
//        if let notEmptyId = uid {
//            self.uid = notEmptyId
//        } else {
//            self.uid = UUID().uuidString
//        }
        self.uid = uid
        self.title = title
        self.contex = contex
        self.color = color ?? .white
        self.importance = importance ?? .ordinary
        self.selfDestructionDate = selfDestructionDate
    }
}

enum Importance: String {
    case unimportant
    case ordinary
    case important
}
