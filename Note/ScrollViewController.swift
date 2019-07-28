//
//  ScrollViewController.swift
//  Note
//
//  Created by Сергей Гриневич on 21/07/2019.
//  Copyright © 2019 Grinevich Sergey. All rights reserved.
//

import UIKit

class ScrollViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    var imageViews = [UIImageView]()
    
    var images: [UIImage] = []
    var gallery: [UIImageView] = []
    
    var lastPage: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let imageNames = ["img", "img1", "img2", "img3", "img4"]
//        for name in imageNames {
//            let image = UIImage(named: name)
//            let imageView = UIImageView(image: image)
//            imageView.contentMode = .scaleAspectFill
//            scrollView.addSubview(imageView)
//            imageViews.append(imageView)
//        }
        
        let backToGallery = UITapGestureRecognizer(target: self, action: #selector(self.backToGallery(_:)))
        backToGallery.numberOfTapsRequired = 1
        scrollView.addGestureRecognizer(backToGallery)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        gallery = []
        for image in images {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            gallery.append(imageView)
            scrollView.addSubview(imageView)
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        for (index, imageView) in gallery.enumerated() {
            imageView.frame.size = scrollView.frame.size
            imageView.frame.origin.x = scrollView.frame.width * CGFloat(index)
            imageView.frame.origin.y = 0
        }
        
        let contentWidth = scrollView.frame.width * CGFloat(gallery.count)
        scrollView.contentSize = CGSize(width: contentWidth, height: scrollView.frame.height)
        
        if let lastPage = lastPage {
            scrollView.contentOffset.x = CGFloat(lastPage) * scrollView.frame.size.width
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        lastPage = Int(round(scrollView.contentOffset.x / scrollView.frame.size.width))
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        for (index, imageView) in imageViews.enumerated() {
//            imageView.frame.size = scrollView.frame.size
//            imageView.frame.origin.x = scrollView.frame.width * CGFloat(index)
//            imageView.frame.origin.y = 0
//        }
//        let contentWidth = scrollView.frame.width * CGFloat(imageViews.count)
//        scrollView.contentSize = CGSize(width: contentWidth, height: scrollView.frame.height)
//    }
//

    
    
    @objc func backToGallery(_ sender: UITapGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }

}
