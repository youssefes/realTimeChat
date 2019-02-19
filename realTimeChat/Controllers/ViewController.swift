//
//  ViewController.swift
//  realTimeChat
//
//  Created by youssef on 2/18/19.
//  Copyright © 2019 youssef. All rights reserved.
//

import UIKit
import Firebase


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
            cell.actionButton.addTarget(self, action: #selector(didPressSignIn), for: .touchUpInside)
            
            
            
            
        }else if(indexPath.row == 1){
            // sign up
            cell.userNameContener.isHidden = false
            cell.actionButton.setTitle("sign Up", for: .normal)
            cell.sliderButton.setTitle("👈 sign in", for: .normal)
             cell.sliderButton.addTarget(self, action: #selector(slideIntosigInCell), for: .touchUpInside)
            cell.actionButton.addTarget(self, action: #selector(didPressSignUp), for: .touchUpInside)
        }
        return cell
    }
    
    @objc func didPressSignIn(){
        let indexpath = IndexPath(row: 0, section: 0)
        let cell = self.collectionViewSign.cellForItem(at: indexpath) as! formcell
        guard let emailAdress = cell.email.text,let password = cell.password.text else{
            return
        }
        if emailAdress.isEmpty == true || password.isEmpty == true{
            displayError(errorText: "Empty Password And email")
        }else{
            Auth.auth().signIn(withEmail: emailAdress, password: password) { (result, error) in
                if error == nil{
                   self.dismiss(animated: true, completion: nil)
                }else{
                    self.displayError(errorText: "wrong password anf=d email")
                }
            }
        }
       
    }
    
    
    
    func displayError(errorText: String){
        let alert = UIAlertController(title: "error", message: errorText, preferredStyle: .alert)
        let dismissAlert = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(dismissAlert)
        self.present(alert, animated: true
            , completion: nil)
    }
    
    
    @objc func didPressSignUp(){
        let indexPath = IndexPath(row: 1, section: 0)
        let cell = self.collectionViewSign.cellForItem(at: indexPath) as! formcell
        guard let emailAdress = cell.email.text, !emailAdress.isEmpty, let password = cell.password.text, !password.isEmpty else{
            return
        }
        dismiss(animated: true, completion: nil)
        Auth.auth().createUser(withEmail: emailAdress, password: password) { (result, error) in
            if (error == nil){
                
                guard let  userId = result?.user.uid, let userName = cell.username.text,!userName.isEmpty else{
                    return
                }
               let refrence = Database.database().reference()
                let user = refrence.child("users").child(userId)
                let dataArray : [String : Any] = ["username" : userName]
                user.setValue(dataArray)
            }
        }
        
        
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

