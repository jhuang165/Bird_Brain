//
//  SignUpViewController.swift
//  BirdBrain
//
//  Created by Jeffrey Huang on 9/19/20.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {
    
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var username: UITextField!
    @IBOutlet var signUp: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUp.isEnabled = false
        email.addTarget(self, action: #selector(ViewController.textFieldDidChange(_:)), for: .editingChanged)
        password.addTarget(self, action: #selector(ViewController.textFieldDidChange(_:)), for: .editingChanged)
        username.addTarget(self, action: #selector(ViewController.textFieldDidChange(_:)), for: .editingChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        self.view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        email.resignFirstResponder()
        password.resignFirstResponder()
        username.resignFirstResponder()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if email.text == "" || password.text == "" || username.text == "" {
            signUp.isEnabled = false
        } else {
            signUp.isEnabled = true
        }
    }
    
    @IBAction func signup(_ sender: Any) {
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (authResult, error) in
            if (error == nil) {
                // sign in -> perform segue to home page
                let ref = Database.database().reference()
                let df = DateFormatter()
                df.dateFormat = "yyyy-MMM-dd HH:mm:ss"
                let date = Date()
                let dateString = df.string(from: date)
                ref.child("users").child((authResult?.user.uid)!).setValue(["email": authResult?.user.email!, "username": self.username.text!, "join": dateString])
                self.performSegue(withIdentifier: "signup", sender: self)
            } else {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
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
