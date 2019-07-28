//
//  NotesListViewController.swift
//  Note
//
//  Created by Сергей Гриневич on 25/07/2019.
//  Copyright © 2019 Grinevich Sergey. All rights reserved.
//

import UIKit

class NotesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var listView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return FileNotebook.shared.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteTableViewCell
        cell.selectionStyle = .none
        let note = FileNotebook.shared.notes[indexPath.row]
        cell.noteColour.backgroundColor = note.color
        cell.titleLabel.text = note.title
        cell.contentLabel.text = note.contex
        return cell
    }
    
    @IBAction func editList(_ sender: Any) {
        addButton.isEnabled = listView.isEditing
        listView.isEditing = !listView.isEditing
    }
    override func viewWillAppear(_ animated: Bool) {
        listView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        listView.delegate = self
        listView.dataSource = self
 
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "EditNoteSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            let note = FileNotebook.shared.notes[indexPath.row]
            FileNotebook.shared.remove(with: note.uid)
            tableView.reloadData()
        }
        
        return [delete]
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditNoteSegue" {
            if let VC = segue.destination as? AddNoteViewController, let selectedNote = listView.indexPathForSelectedRow?.row {
                VC.noteToEdit = FileNotebook.shared.notes[selectedNote]
            }
        }
        if segue.identifier == "AddNewNoteSegue" {
            if let VC = segue.destination as? AddNoteViewController {

                VC.noteToEdit = Note(title: "New Note \(FileNotebook.shared.notes.count + 1)", contex: "Note Content", color: nil, importance: nil, selfDestructionDate: nil)
            }
        }
    }
    
}
