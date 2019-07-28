//
//  NoteExtensions.swift
//  Note
//
//  Created by Сергей Гриневич on 23/06/2019.
//  Copyright © 2019 Grinevich Sergey. All rights reserved.
//


import Foundation
import CoreImage
import UIKit

extension Note {
    
    var json: [String: Any] {
        get {
            var dictionary = [String: Any]()
            dictionary["uid"] = uid
            dictionary["title"] = title
            dictionary["contex"] = contex
            if color != .white {
                let rgba = color.rgba
                let colourDict: [String: Double] = ["red": Double(rgba.red), "blue": Double(rgba.blue), "green": Double(rgba.green), "alpha": Double(rgba.alpha)]
                dictionary["color"] = colourDict
            }
            if importance != .ordinary {
                let rawImportance = importance.rawValue
                dictionary["importance"] = String(rawImportance)
            }
            if let deadline = selfDestructionDate {
                let date = Double(deadline.timeIntervalSince1970)
                dictionary["destructionDate"] = date
            }
            return dictionary
        }
    }
    
    static func parse(json: [String: Any]) -> Note? {
        let note = { () -> Note? in
            let rawUID = json["uid"] as? String
            let rawTitle = json["title"] as? String
            let rawContent = json["contex"] as? String
            switch (rawUID, rawTitle, rawContent) {
            case (_?, _?, _?):
                var colour: UIColor? = nil
                var importance: Importance? = nil
                var deadline: Date? = nil
                
                let uid = rawUID!
                let title = rawTitle!
                let content = rawContent!
                
                if let rawColour = json["color"] as? [String: Double] {
                    if let red: Double = rawColour["red"] {
                        if let green: Double = rawColour["green"] {
                            if let blue: Double = rawColour["blue"] {
                                if let alpha: Double = rawColour["alpha"] {
                                    colour = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
                                }
                            }
                        }
                    }
                    
                }
                if let rawImportance = json["importance"] as? String{
                    importance = Importance(rawValue: rawImportance)
                }
                if let rawDeadline = json["destructionDate"] as? TimeInterval{
                    deadline = Date(timeIntervalSince1970: rawDeadline)
                }
                
                let noteDraft = Note(uid: uid, title: title, contex: content, color: colour, importance: importance, selfDestructionDate: deadline)
                return noteDraft
            default:
                return nil
            }
        }
        return note()
    }
}

extension Note: Equatable {
    static func == (lhs: Note, rhs: Note) -> Bool {
        return (lhs.uid == rhs.uid) && (lhs.title == rhs.title) && (lhs.contex == rhs.contex) && (lhs.color == rhs.color) && (lhs.importance == rhs.importance) && (lhs.selfDestructionDate == rhs.selfDestructionDate)
    }
}


extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue, alpha)
    }
}


