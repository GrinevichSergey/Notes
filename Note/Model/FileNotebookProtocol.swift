//
//  FileNotebookProtocol.swift
//  Note
//
//  Created by Сергей Гриневич on 25/07/2019.
//  Copyright © 2019 Grinevich Sergey. All rights reserved.
//


import Foundation

protocol FileNotebookProtocol {
    var notes: [Note] {get}
    
    func add(_ note: Note)
    func remove(with uid: String)
}
