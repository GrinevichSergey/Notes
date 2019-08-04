//
//  LoadNotesDBOperations.swift
//  Note
//
//  Created by Сергей Гриневич on 04/08/2019.
//  Copyright © 2019 Grinevich Sergey. All rights reserved.
//

import Foundation

class LoadNotesDBOperation: BaseDBOperation {
    var result: [Note]?
    
    override func main() {
        notebook.loadNotes()
        result = notebook.notes
        finish()
    }
}
