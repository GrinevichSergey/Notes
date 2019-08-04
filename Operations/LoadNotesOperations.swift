//
//  LoadNotesOperations.swift
//  Note
//
//  Created by Сергей Гриневич on 04/08/2019.
//  Copyright © 2019 Grinevich Sergey. All rights reserved.
//

import Foundation

class LoadNotesOperation: AsyncOperation {
    private let notebook: FileNotebook
    private var loadFromDb: LoadNotesDBOperation?
    private let loadFromBackend: LoadNotesBackendOperation
    private let updateUI: BlockOperation
    
    private(set) var result: Bool = false
    
    init(notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue,
         updateUI: BlockOperation) {
        self.notebook = notebook
        
        loadFromBackend = LoadNotesBackendOperation()
        self.updateUI = updateUI
        
        super.init()
        
        loadFromBackend.completionBlock = {
            if case .failure(let v) = self.loadFromBackend.result! {
                print(v)
                self.loadFromDb = LoadNotesDBOperation(notebook: notebook)
                self.addDependency(self.loadFromDb!)
                dbQueue.addOperation(self.loadFromDb!)
            }
        }
        
        addDependency(loadFromBackend)
        backendQueue.addOperation(loadFromBackend)
    }
    
    override func main() {
        result = true
        finish()
    }
}
