//
//  AddNoteViewController.swift
//  Note
//
//  Created by Сергей Гриневич on 27/07/2019.
//  Copyright © 2019 Grinevich Sergey. All rights reserved.
//

import UIKit


enum ChosenColour: Int {
    case white = 0
    case red = 1
    case green = 2
    case custom = 3
}


class AddNoteViewController: UIViewController,  UIScrollViewDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    var chosenColour: ChosenColour = .white
    var noteToEdit: Note?
    
    private let fileNotebook = FileNotebook()
    private let reuseId = "reuseId"
    private let segueName = "editNote"
    private(set) var currentIndex = -1
    
    let backendQueue = OperationQueue()
    let dbQueue = OperationQueue()
    let commonQueue = OperationQueue()
    private(set) var updateUI = BlockOperation()
    
    var chooseWhiteColour: UITapGestureRecognizer!
    var chooseRedColour: UITapGestureRecognizer!
    var chooseGreenColour: UITapGestureRecognizer!
    var chooseOtherColour: UITapGestureRecognizer!
    
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var destroySwitch: UISwitch!
    @IBOutlet weak var destroyDatePicker: UIDatePicker!
    @IBOutlet weak var datePickerHeight: NSLayoutConstraint!
    @IBOutlet weak var whiteColorView: UIView!
    @IBOutlet weak var greenColorView: UIView!
    @IBOutlet weak var redColorView: UIView!
    @IBOutlet weak var customColorView: UIView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var gradientPicture: UIImageView!
    @IBOutlet weak var scrollButton: NSLayoutConstraint!
    
    
    @IBOutlet var flagViews: [FlagView]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loadNoteOperation = LoadNotesOperation(
            notebook: fileNotebook,
            backendQueue: backendQueue,
            dbQueue: dbQueue,
            updateUI: updateUI
        )
        commonQueue.addOperation(loadNoteOperation)
        updateUI = BlockOperation {
            self.setUI()
        }
        
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let note = noteToEdit {
            titleTextField.text = note.title
            contentTextView.text = note.contex
            
            if let destroy = note.selfDestructionDate {
                destroySwitch.isOn = true
                destroyDatePicker.date = destroy
                datePickerHeight.constant = 162
            } else {
                destroySwitch.isOn = false
                datePickerHeight.constant = 0
            }
            
            switch note.color {
            case .white:
                chosenColour = .white
            case .red:
                chosenColour = .red
            case .green:
                chosenColour = .green
            default:
                chosenColour = .custom
            }
            setFlag(chosenColour.rawValue)
            if chosenColour == .custom {
                gradientPicture.isHidden = true
                customColorView.backgroundColor = note.color
            }
        }
        
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    @IBAction func useDestroyDate(_ sender: UISwitch) {
        
        if destroySwitch.isOn {
            datePickerHeight.constant = 0
        } else {
            datePickerHeight.constant = 162.0
        }
        destroySwitch.isOn = !destroySwitch.isOn
        
    }
    @IBAction func saveButton(_ sender: Any) {
        if let note = constructNote() {
           // FileNotebook.shared.add(note)
            let saveNoteOperation = SaveNoteOperation(
             
                note: note,
                notebook: fileNotebook,
                backendQueue: backendQueue,
                dbQueue: dbQueue
               
                
            )
            saveNoteOperation.completionBlock = {
                DispatchQueue.main.async {
                   // self.tableView.reloadData()
                }
            }
            commonQueue.addOperation(saveNoteOperation)
        }
        
        performSegue(withIdentifier: "SaveChangedNoteSegue", sender: self)
    }
    
    @objc func chooseCustomColour(sender: UILongPressGestureRecognizer) {
        if sender.state == .ended {
            chosenColour = .custom
            setFlag(chosenColour.rawValue)
            performSegue(withIdentifier: "ChooseCustomColour", sender: self)
        }
    }
    @objc func chooseColour(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if sender == chooseWhiteColour {
                chosenColour = .white
                setFlag(chosenColour.rawValue)
            }
            if sender == chooseRedColour {
                chosenColour = .red
                setFlag(chosenColour.rawValue)
            }
            if sender == chooseGreenColour {
                chosenColour = .green
                setFlag(chosenColour.rawValue)
            }
            if sender == chooseOtherColour {
                if gradientPicture.isHidden {
                    chosenColour = .custom
                    setFlag(chosenColour.rawValue)
                }
            }
        }
    }
    
    
    private func setUI() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        // delegates
        self.titleTextField.delegate = self
        self.contentTextView.delegate = self
        self.scroll.delegate = self
        // custom gestures
        let chooseCustomColour = UILongPressGestureRecognizer(target: self, action: #selector(self.chooseCustomColour))
        chooseCustomColour.minimumPressDuration = 0.5
        customColorView.addGestureRecognizer(chooseCustomColour)
        
        chooseWhiteColour = UITapGestureRecognizer(target: self, action: #selector(self.chooseColour))
        chooseWhiteColour.numberOfTapsRequired = 1
        whiteColorView.addGestureRecognizer(chooseWhiteColour)
        
        chooseRedColour = UITapGestureRecognizer(target: self, action: #selector(self.chooseColour))
        chooseRedColour.numberOfTapsRequired = 1
        redColorView.addGestureRecognizer(chooseRedColour)
        
        chooseGreenColour = UITapGestureRecognizer(target: self, action: #selector(self.chooseColour))
        chooseGreenColour.numberOfTapsRequired = 1
        greenColorView.addGestureRecognizer(chooseGreenColour)
        
        chooseOtherColour = UITapGestureRecognizer(target: self, action: #selector(self.chooseColour))
        chooseGreenColour.numberOfTapsRequired = 1
        customColorView.addGestureRecognizer(chooseOtherColour)
        // UI
        whiteColorView.layer.borderColor = UIColor.black.cgColor
        whiteColorView.layer.borderWidth = 1.0
        redColorView.layer.borderColor = UIColor.black.cgColor
        redColorView.layer.borderWidth = 1.0
        greenColorView.layer.borderColor = UIColor.black.cgColor
        greenColorView.layer.borderWidth = 1.0
        customColorView.layer.borderColor = UIColor.black.cgColor
        customColorView.layer.borderWidth = 1.0
    }
    
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            contentTextView.contentInset = .zero
            scrollButton.constant = 0.0
        } else {
            contentTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
            scrollButton.constant = keyboardViewEndFrame.height + 24.0
        }
    }
    
    private func setFlag(_ no: Int) {
        for flag in flagViews {
            flag.isHidden = true
        }
        flagViews[no].isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChooseCustomColour" {
            if let VC = segue.destination as? ColourPickerViewController {
                if let note = constructNote() {
                    VC.note = note
                    print("to: \(note.color)")
                }
            }
        }
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollView.resignFirstResponder()
    }
    
    
    
    private func constructNote() -> Note? {
        guard let uid = noteToEdit?.uid else {return nil}
        guard let title = titleTextField.text else {return nil}
        guard let content = contentTextView.text else {return nil}
        var destroyDate: Date?
        if destroySwitch.isOn {
            destroyDate = destroyDatePicker.date
        }
        var colour: UIColor?
        switch chosenColour {
        case .white:
            colour = .white
        case .red:
            colour = .red
        case .green:
            colour = .green
        default:
            colour = noteToEdit?.color
        }
        
        if (title != "") && (content != "") {
            let note = Note(uid: uid, title: title, contex: content, color: colour, importance: .important, selfDestructionDate: destroyDate)
            return note
        } else {
            return nil
        }
    }
    
    
}
