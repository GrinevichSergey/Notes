//
//  TableViewController.swift
//  Note
//
//  Created by Сергей Гриневич on 21/07/2019.
//  Copyright © 2019 Grinevich Sergey. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var index = -1
 
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    
    
    var notes = [Note(title: "title 1", contex: "test test test", color: UIColor.red, importance: .important),
                 Note(title: "title 2", contex: "test  gr gnt kedkernrfnerkfnekrngrgknetgnerkgnekrgnekrg jnjnjnnjndcnfdcnfnjfdnvjfndnvfjvfjnvnnvjdnfvjnvndcn nfvjnj jfdnvjfnjndfjnj nfdjnfj ndfnj ndfnnjnfnjn jdf jnfjnvdjnvjdfnvn djfvnjnvjdfnvjnvdfjvnjvndjfnvj njdfsdkqwjdpqweodjowejfdivin in nven bgtntjg tjyg tjyt yj yjh tjyh thytest test", color: UIColor.red, importance: .ordinary),
                 Note(title: "title 3", contex: "test fg,kmgk fkgmfkgfjkfjnjfgn fgj jg ng j gr gnt bgtntjg tjyg tjyt yj yjh tjyh thytest test", color: UIColor.red, importance: .important)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.reloadData()
        
     
    }
    @IBAction func AddNotes(_ sender: Any) {
        index = -1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        index = -1
    }
    @IBAction func isEdit(_ sender: Any) {
            self.isEditing = !self.isEditing
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

       return UITableView.automaticDimension;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CellTableTableViewCell
        cell.labelText?.text = self.notes[indexPath.row].title
        //cell.labelText?.numberOfLines = 5
        cell.contexView?.text = notes[indexPath.row].contex
        cell.contexView.textContainer.maximumNumberOfLines = 5
      
        cell.imageColor?.backgroundColor = notes[indexPath.row].color
        
        cell.selectionStyle = .none
        cell.contexView.isEditable = false
        cell.contexView.isUserInteractionEnabled = false
       
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.item
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController
        print(vc as Any)
    
        let note = notes[indexPath.row]
   
      //  vc!.titleTextField.text = note.title
    
     // vc?.noteTextView.text = note.contex
        vc?.contex = note.contex
        vc?.titleText = note.title
    

        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Удалить")
            
            self.notes.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
  
    
}


public extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 5, height: 5)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
