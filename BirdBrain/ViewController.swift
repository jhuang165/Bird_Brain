//
//  ViewController.swift
//  BirdBrain
//
//  Created by Jeffrey Huang on 9/19/20.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var signIn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        signIn.isEnabled = false
        email.addTarget(self, action: #selector(ViewController.textFieldDidChange(_:)), for: .editingChanged)
        password.addTarget(self, action: #selector(ViewController.textFieldDidChange(_:)), for: .editingChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        email.resignFirstResponder()
        password.resignFirstResponder()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if email.text == "" || password.text == "" {
            signIn.isEnabled = false
        } else {
            signIn.isEnabled = true
        }
    }
    
    @IBAction func signin(_ sender: Any) {
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (authResult, error) in
            if (error == nil) {
                // sign in -> perform segue to home page
                self.performSegue(withIdentifier: "signin", sender: self)
            } else {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

