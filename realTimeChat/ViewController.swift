//
//  ViewController.swift
//  realTimeChat
//
//  Created by youssef on 2/18/19.
//  Copyright © 2019 youssef. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionViewSign: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewSign.dataSource = self
        collectionViewSign.delegate = self
    }


}

extension ViewController : UICollectionViewDelegate{
    
}
extension ViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "formCell", for: indexPath) as! formcell
        if (indexPath.row == 0){ // signIn
            cell.userNameContener.isHidden = true
            cell.actionButton.setTitle("log In", for: .normal)
            cell.sliderButton.setTitle("sign UP 👉", for: .normal)
            cell.sliderButton.addTarget(self, action: #selector(slideIntosignUpCell), for: .touchUpInside)
        }else if(indexPath.row == 1){
            // sign up
            cell.userNameContener.isHidden = false
            cell.actionButton.setTitle("sign Up", for: .normal)
            cell.sliderButton.setTitle("👈 sign in", for: .normal)
             cell.sliderButton.addTarget(self, action: #selector(slideIntosigInCell), for: .touchUpInside)
        }
        return cell
    }
    
    @objc func slideIntosignUpCell(_ sender :UIButton){
        let indexPath = IndexPath(row: 1, section: 0)
        self.collectionViewSign.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
    }
    
    @objc func slideIntosigInCell(_ sender :UIButton){
        let indexPath = IndexPath(row: 0, section: 0)
        self.collectionViewSign.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
    }
}

extension  ViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionViewSign.frame.size
    }
}

