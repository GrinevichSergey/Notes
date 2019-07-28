//
//  NoteTableViewCell.swift
//  Note
//
//  Created by Сергей Гриневич on 25/07/2019.
//  Copyright © 2019 Grinevich Sergey. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var noteColour: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        noteColour.layer.borderWidth = 1.0
        noteColour.layer.borderColor = UIColor.black.cgColor
        
        contentLabel.numberOfLines = 5
        contentLabel.font.withSize(14.0)
        titleLabel.font.withSize(18.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
