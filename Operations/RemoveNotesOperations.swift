//
//  RemoveNotesOperations.swift
//  Note
//
//  Created by Сергей Гриневич on 04/08/2019.
//  Copyright © 2019 Grinevich Sergey. All rights reserved.
//

import Foundation

class RemoveNoteOperation: AsyncOperation {
    private let note: Note
    private let notebook: FileNotebook
    private let removeFromDb: RemoveNoteDBOperation
    private let removeFromBackend: SaveNotesBackendOperation
    private let updateUI: BlockOperation
    
    private(set) var result: Bool? = false
    
    init(note: Note,
         notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue,
         updateUI: BlockOperation) {
        self.note = note
        self.notebook = notebook
        
        removeFromDb = RemoveNoteDBOperation(note: note, notebook: notebook)
        removeFromBackend = SaveNotesBackendOperation(notes: notebook.notes)
        self.updateUI = updateUI
        
        super.init()
        
        self.addDependency(removeFromBackend)
        backendQueue.addOperation(removeFromBackend)
        
        addDependency(removeFromDb)
        dbQueue.addOperation(removeFromDb)
    }
    
    override func main() {
        switch removeFromBackend.result! {
        case .success:
            result = true
        case .failure:
            result = false
        }
        finish()
    }
}
