//
//  StatusReportViewController.swift
//  QuickAction
//
//  Created by Aman Dhruva Thamminana on 2/18/23.
//

import UIKit
import FirebaseFirestore

import CoreLocation

class StatusReportViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {

    @IBOutlet weak var LocationTextField: UITextField!
    
    @IBOutlet weak var RoomNumberTextField: UITextField!
    
    @IBOutlet weak var FloorTextField: UITextField!
    
    @IBOutlet weak var NumberOfPeopleTextField: UITextField!
    
    @IBOutlet weak var Barricaded: UISegmentedControl!
    
    let locationManager = CLLocationManager()
    
    
    @IBAction func SubmitButton(_ sender: Any) {
        let LocationText: String = LocationTextField.text ?? "NotReported"
        let RoomNumberText: String = RoomNumberTextField.text ?? "NotReported"
        let FloorText: String = FloorTextField.text ?? "NotReported"
        let NumberOfPeopleText: Int = Int(NumberOfPeopleTextField.text ?? "-1") ?? -1
        
        var isBarricaded: Bool = false
        
        switch Barricaded.selectedSegmentIndex {
        case 0:
            isBarricaded = true
            
        case 1:
            isBarricaded = false

        default:
            isBarricaded = false
        }
        
        
        
        
        onSubmit(location: LocationText, roomNumber: RoomNumberText, floor: FloorText, numberOfPeople: NumberOfPeopleText, isBarricaded: isBarricaded)
        
        
        print("hello")
        
        
        performSegue(withIdentifier: "StatusViewSegue", sender: self)
        locationManager.requestLocation()
        
        
    }
    
    let collection = Firestore.firestore().collection("Report")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NumberOfPeopleTextField.keyboardType = .decimalPad
        
        self.locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            print("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Error requesting location: \(error.localizedDescription)")
    }
    
    func onSubmit(location: String, roomNumber: String, floor: String, numberOfPeople: Int, isBarricaded: Bool) {
        let docRef = collection.document(UUID().uuidString)
        
        docRef.setData(["numberOfPeople": numberOfPeople,
                        "floor" : floor,
                        "roomNumber": roomNumber,
                        "location" : location,
                        "isBarricaded": isBarricaded])

        

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
