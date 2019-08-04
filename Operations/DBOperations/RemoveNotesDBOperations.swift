//
//  RemoveNotesDBOperations.swift
//  Note
//
//  Created by Сергей Гриневич on 04/08/2019.
//  Copyright © 2019 Grinevich Sergey. All rights reserved.
//

import Foundation

class RemoveNoteDBOperation: BaseDBOperation {
    private let note: Note
    
    init(note: Note,
         notebook: FileNotebook) {
        self.note = note
        super.init(notebook: notebook)
    }
    
    override func main() {
        notebook.remove(with: note.uid)
        notebook.saveNotes()
        finish()
    }
}
