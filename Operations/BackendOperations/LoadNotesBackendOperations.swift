//
//  LoadNotesBackendOperations.swift
//  Note
//
//  Created by Сергей Гриневич on 04/08/2019.
//  Copyright © 2019 Grinevich Sergey. All rights reserved.
//

import Foundation

enum LoadNotesBackendResult {
    case success([Note])
    case failure(NetworkError)
}

class LoadNotesBackendOperation: BaseBackendOperation {
    var result: LoadNotesBackendResult?
    
    override func main() {
        result = .failure(.unreachable)
        finish()
    }
}
