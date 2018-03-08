//
//  ViewController.swift
//  TestPro
//
//  Created by 张乐 on 7/3/18.
//  Copyright © 2018 张乐. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var usernametx: UITextField!
    
    @IBOutlet weak var passwordtx: UITextField!
    
    @IBAction func clicklogin(_ sender: Any) {
        var username = self.usernametx.text!
        var password = self.passwordtx.text!
        print(">>>> username is ",username)
        print(">>>> password is ",password)
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // ...
            let user = Auth.auth().currentUser
            self.usernametx.text = user?.email
            self.passwordtx.text = user?.uid
            self.changeUserFDB()
            self.submitFDB()
        }
        
    }
    
    var ref: DatabaseReference? = nil
    
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func connectFDB(){
        ref = Database.database().reference()
        ref?.child("theme").child("0").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let theme = value?["folderName"] as? String ?? ""
            print(">>>>> folder name should see CNY:",theme)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func submitFDB(){
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        ref = Database.database().reference()
        let user = Auth.auth().currentUser
        let childRef = ref?.child("Users").child((user?.uid)!)
        let addingItem = [
            "email": usernametx.text!,
            "name": user?.displayName,
            "phonenumber": user?.phoneNumber,
            "providerID": user?.providerID,
            "storeID": "0",
            "spinDate": dateFormat.string(from: Date())
            ] as [String : Any]
        childRef?.setValue(addingItem, withCompletionBlock: { (errorAdding, ref) in
        })
    }
    
    func changeUserFDB(){
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = "Le Zhang"
        changeRequest?.commitChanges { (error) in
            // ...
        }
    }

    
}

