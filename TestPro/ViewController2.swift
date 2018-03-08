//
//  ViewController2.swift
//  TestPro
//
//  Created by 张乐 on 7/3/18.
//  Copyright © 2018 张乐. All rights reserved.
//

import UIKit
import Firebase
import Foundation

class ViewController2: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
    var ref: DatabaseReference? = nil
    
    var sections = ["Campaign"]
    var fruit = [""]
    let vegetables = ["Carrot", "Broccoli"]
    var refresher: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        refresher = UIRefreshControl()
        self.getStoreID()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewWillAppear(_ animated: Bool) {
        print(">>>> sesstions",self.sections[0])
    }
    
    func getStoreID(){
        ref = Database.database().reference()
        let user = Auth.auth().currentUser
        ref?.child("Users").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let storeID = value?["storeID"] as? String ?? ""
            print(">>>>> storeID ",storeID)
            self.getStoreName(storeid: storeID)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getStoreName(storeid:String){
        ref = Database.database().reference()
        ref?.child("Store").child(storeid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let campaignID = value?["campaign"] as? String ?? ""
            let storen = value?["name"] as? String ?? ""
            self.storeName.text = storen
            print(">>>>> storeID ",campaignID)
            var CampineArr = campaignID.split(separator: "|").map(String.init)
            var fcol:String = CampineArr[0]
            self.fruit.append(fcol)
            fcol = CampineArr[1]
            self.fruit.append(fcol)
            print(">>>>> campaign",fcol)
            print("refreshed")
            self.tableView.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlainCell", for: indexPath)
        // Depending on the section, fill the textLabel with the relevant text
        switch indexPath.section {
        case 0:
            // Fruit Section
            cell.textLabel?.text = fruit[indexPath.row]
            break
        case 1:
            // Vegetable Section
            cell.textLabel?.text = vegetables[indexPath.row]
            break
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            // Fruit Section
            return fruit.count
        case 1:
            // Vegetable Section
            return vegetables.count
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
}
