//
//  PaymentListViewController.swift
//  MyPodLibrary_Example
//
//  Created by Varun Bagga on 18/10/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

class PaymentListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension PaymentListViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    }
    
    
}
