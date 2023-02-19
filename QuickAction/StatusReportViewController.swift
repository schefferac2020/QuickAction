//
//  StatusReportViewController.swift
//  QuickAction
//
//  Created by Aman Dhruva Thamminana on 2/18/23.
//

import UIKit
import FirebaseFirestore

import CoreLocation

import Foundation
import FirebaseAuth


class StatusReportViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var LocationTextField: UITextField!
    
    @IBOutlet weak var RoomNumberTextField: UITextField!
    
    @IBOutlet weak var FloorTextField: UITextField!
    
    @IBOutlet weak var NumberOfPeopleTextField: UITextField!
    
    @IBOutlet weak var Barricaded: UISegmentedControl!
    
//    let locationManager = CLLocationManager()
    let userDefaults = UserDefaults.standard

    
    @IBAction func SubmitButton(_ sender: Any) {
        let LocationText: String = LocationTextField.text ?? "NotReported"
        let RoomNumberText: String = RoomNumberTextField.text ?? "NotReported"
        let FloorText: String = FloorTextField.text ?? "NotReported"
        let NumberOfPeopleText: Int = Int(NumberOfPeopleTextField.text ?? "-1") ?? -1
        
        let NameOfPerson: String = "TestPerson"
        let PhoneNumber: String = "9991119999"
        var isBarricaded: Bool = false
        
        switch Barricaded.selectedSegmentIndex {
        case 0:
            isBarricaded = true
            
        case 1:
            isBarricaded = false

        default:
            isBarricaded = false
        }
        
        
        
        
        onSubmit(location: LocationText, roomNumber: RoomNumberText, floor: FloorText, numberOfPeople: NumberOfPeopleText, isBarricaded: isBarricaded, PhoneNumber: PhoneNumber, Name: NameOfPerson)
        
        
        print("hello")
        
   

        
        if Auth.auth().currentUser?.uid != nil {
            //The user is logged in
            print("The user is logged in")
            performSegue(withIdentifier: "StatusViewSegue", sender: self)
            
        }else{
            print("The user is not logged in...")
            performSegue(withIdentifier: "NotLoggedInSegue", sender: self)
        }
        
        
        
        
    }
    
    let collection = Firestore.firestore().collection("Report")

    override func viewDidLoad() {
        super.viewDidLoad()
        //Navigation Title
        self.title = "Report"
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true;
        
        NumberOfPeopleTextField.keyboardType = .decimalPad
        

        
        
        
        LocationTextField.delegate = self
        RoomNumberTextField.delegate = self
        FloorTextField.delegate = self
        NumberOfPeopleTextField.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//            guard let location = locations.last else { return }
//            print("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
//    }
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//            print("Error requesting location: \(error.localizedDescription)")
//    }
    
    func onSubmit(location: String, roomNumber: String, floor: String, numberOfPeople: Int, isBarricaded: Bool, PhoneNumber: String, Name: String) {
        
        let uid = userDefaults.string(forKey: "UID") ?? UUID().uuidString
        let docRef = collection.document(uid)
            userDefaults.set(uid, forKey: "UID")

        
        docRef.setData(["numberOfPeople": numberOfPeople,
                        "floor" : floor,
                        "roomNumber": roomNumber,
                        "location" : location,
                        "isBarricaded": isBarricaded,
                        "safe": false,
                        "time": Date.now,
                        "UID": uid,
                        "phoneNumber": PhoneNumber,
                        "name": Name])
        
        if let user = Auth.auth().currentUser {
            let email = user.email ?? "sample"
            print("User email:")
            print(email)
            
            let collection2 = Firestore.firestore().collection("Users")
            let docRef2 = collection2.document(email)
//            if let name = data["name"] as? String {
//                // Use the name here
//            }
            docRef2.getDocument { (document, error) in
                if let document = document, document.exists {
                    // Get the field you want
                    let uName = document.get("name")
                    let pNumber = document.get("phoneNumber")
                    print("Field Value: \(uName)")
                    docRef.setData(["name":uName, "phoneNumber": pNumber], merge: true)
                } else {
                    print("Document does not exist")
                }
            }

            
        } else {
            print("User not logged in")
        }

        

        print("done")
        
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
