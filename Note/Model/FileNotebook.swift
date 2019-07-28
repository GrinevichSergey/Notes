////
////  FileNotebook.swift
////  Note
////
////  Created by Сергей Гриневич on 27/06/2019.
////  Copyright © 2019 Grinevich Sergey. All rights reserved.
////

import Foundation

class FileNotebook: FileNotebookProtocol {
    
    static var shared = FileNotebook()
    
    public private(set) var notes: [Note]
    
    private let urlJSON: URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("notes.json")
    
    init() {
        notes = []
        if FileManager.default.fileExists(atPath: urlJSON.path) {
            loadNotes()
        }
    }
    
    public func add(_ note: Note) {
        for i in (0..<notes.count).reversed() {
            if notes[i].uid == note.uid {
                notes.remove(at: i)
            }
        }
        
        notes.append(note)
        saveNotes()
    }
    
    public func remove(with uid: String) {
        for i in (0..<notes.count).reversed() {
            if notes[i].uid == uid {
                notes.remove(at: i)
            }
        }
        
        saveNotes()
    }
    
    private func saveNotes() {
        var dictionary = [String: Dictionary<String, Any>]()
        for i in 0..<notes.count {
            dictionary["\(i)"] = notes[i].json
        }
        
        guard let newJSON = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted) as Data else {
            print("Couldn't serialize Dictionary into Data")
            return
        }
        
        do {
            try newJSON.write(to: urlJSON, options: Data.WritingOptions.atomic)
        } catch {
            print("Cant write to a file")
        }
    }
    
    private func loadNotes() {
        notes = []
        
        if FileManager.default.fileExists(atPath: urlJSON.path) {
            guard let rawData = try? Data(contentsOf: URL(fileURLWithPath: urlJSON.path)) else {
                print("Couldn't serialize notes.json")
                return
            }
            guard let parsedJSON = try? (JSONSerialization.jsonObject(with: rawData, options: .allowFragments) as! [String: Any]) else {
                print("Couldn't convert Data into Dictionary")
                return
            }
            for i in 0..<parsedJSON.count {
                guard let json = parsedJSON["\(i)"] as? [String: Any] else {
                    print("Couldn't extract Note json")
                    return
                }
                if let note = Note.parse(json: json) {
                    notes.append(note)
                } else {
                    print("Empty note")
                }
            }
        }
    }
}
