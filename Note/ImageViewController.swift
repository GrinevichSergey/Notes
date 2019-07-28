//
//  ImageViewController.swift
//  Note
//
//  Created by Сергей Гриневич on 24/07/2019.
//  Copyright © 2019 Grinevich Sergey. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate{
    
    var images: [UIImage] = []
    
    @IBOutlet weak var imageCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageCollection.delegate = self
        self.imageCollection.dataSource = self
        
        let names = ["img1", "img2", "img3", "img4", "img"]
        for name in names {
            if let image = UIImage(named: name) {
                images.append(image)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        imageCollection.reloadData()
    }
    
    @IBAction func newImage(_ sender: Any) {
        
        let newImageController = UIImagePickerController()
        newImageController.delegate = self
        newImageController.sourceType = .photoLibrary
        
        present(newImageController, animated: true, completion: nil)
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageViewCell
        cell.imageView.image = images[indexPath.row]
        cell.imageView.contentMode = .scaleAspectFill
        return cell
        
    }
    

  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         performSegue(withIdentifier: "DetailImageSegue", sender: self)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailImageSegue" {
            if let scrollVC = segue.destination as? ScrollViewController, let selectedImage = imageCollection.indexPathsForSelectedItems?.first {
                scrollVC.images = images
                scrollVC.lastPage = selectedImage.row
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width/2 - 8, height: collectionView.bounds.size.width/2 - 8)
    }
    
}


extension ImageViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            images.append(image)
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
}
