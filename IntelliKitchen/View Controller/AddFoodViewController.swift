//
//  AddFoodViewController.swift
//  IntelliKitchen_Myfood
//
//  Created by D.WANG on 4/29/20.
//  Copyright © 2020 D.WANG. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class AddFoodViewController: UIViewController {
    
    @IBOutlet weak var foodNameField: UITextField!
    @IBOutlet weak var boughtDateField: UITextField!
    @IBOutlet weak var expirationDateField: UITextField!
    
    @IBOutlet weak var foodListTableView: UITableView!
    
    private var datePicker: UIDatePicker?
    private var datePicker2: UIDatePicker?
    
    var foods = [String]()
    var foodNames = [String]()
    var bDate = [String]()
    var eDate = [String]()
    
    //var ref: DatabaseReference!
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ref = Database.database().reference()
        datePicker = UIDatePicker()
        datePicker2 = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker2?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(AddFoodViewController.dateChanged(datePicker:)), for: .valueChanged)
        datePicker2?.addTarget(self, action: #selector(AddFoodViewController.dateChanged2(datePicker2:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddFoodViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        boughtDateField.inputView = datePicker
        expirationDateField.inputView = datePicker2

    }
    

    @IBAction func addTapped(_ sender: Any) {
        if(foodNameField.text == "" || boughtDateField.text == "" || expirationDateField.text == ""){
            createAlert(title: "Oops", message: "It seems like you miss something!")
        } else {
            /*ref?.child("Food").child(foodNameField.text ?? "").child("FoodName").setValue(foodNameField.text);
            ref?.child("Food").child(foodNameField.text ?? "").child("BoughtDate").setValue(boughtDateField.text);
            ref?.child("Food").child(foodNameField.text ?? "").child("ExpireDate").setValue(expirationDateField.text);*/
            let currentUid = Auth.auth().currentUser!.uid
            db.collection("users").document(currentUid).collection("foods").document(foodNameField.text ?? "").setData(["foodName":foodNameField.text ?? "", "boughtDate":boughtDateField.text ?? "", "expireDate":expirationDateField.text ?? ""])
                /*.addDocument(data: ["foodName":foodNameField.text ?? "", "boughtDate": boughtDateField.text ?? "", "expireDate": expirationDateField.text ?? ""])*/
            createAlert(title: "Success!", message: "Successfully added food!")
            insertNewFood()
        }
        
    }
    
    func insertNewFood(){
        foods.append("\(foodNameField.text!)       \(boughtDateField.text!)       \(expirationDateField.text!)")
        foodNames.append(foodNameField.text ?? "")
        bDate.append(boughtDateField.text ?? "")
        eDate.append(expirationDateField.text ?? "")
        let indexPath = IndexPath(row: foods.count - 1, section: 0)
        foodListTableView.beginUpdates()
        foodListTableView.insertRows(at: [indexPath], with: .automatic)
        foodListTableView.endUpdates()
        foodNameField.text = ""
        boughtDateField.text = ""
        expirationDateField.text = ""
    }
    
    

    // prompt error message
    func createAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        if( NSDate.init().laterDate(datePicker.date) == datePicker.date){
            createAlert(title: "Oops", message: "Bought date can't be in the futue!")
            view.endEditing(true)
        } else {
            boughtDateField.text = dateFormatter.string(from: datePicker.date)
        }
    }
    
    @objc func dateChanged2(datePicker2: UIDatePicker) {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "MM/dd/yyyy"
          if( NSDate.init().earlierDate(datePicker2.date) == datePicker2.date){
            createAlert(title: "Oops", message: "Your food has already expired!")
            view.endEditing(true)
          } else {
            expirationDateField.text = dateFormatter.string(from: datePicker2.date)
      }
    }
}

extension AddFoodViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = foodListTableView.dequeueReusableCell(withIdentifier: "foodCell") as! AddFoodTableViewCell
        //let cell = AddFoodTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "foodCell")
        cell.bDateLabel.text = bDate[indexPath.row]
        cell.eDateLabel.text = eDate[indexPath.row]
        cell.foodNameLabel.text = foodNames[indexPath.row]
        cell.bDateLabel.adjustsFontSizeToFitWidth = true
        cell.eDateLabel.adjustsFontSizeToFitWidth = true
        cell.foodNameLabel.adjustsFontSizeToFitWidth = true
        //cell.textLabel?.text = foods[indexPath.row]
        //cell.textLabel?.adjustsFontSizeToFitWidth = true
        return cell
    }
    
    

    
    
}
