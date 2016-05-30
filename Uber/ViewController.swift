/**
 * Copyright (c) 2015-present, Parse, LLC.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

import UIKit
import Parse

class ViewController: UIViewController, UITextFieldDelegate {
  
  @IBOutlet weak var username: UITextField!
  @IBOutlet weak var password: UITextField!
  
  @IBOutlet weak var riderLabel: UILabel!
  @IBOutlet weak var driverLabel: UILabel!
  @IBOutlet weak var `switch`: UISwitch!
  @IBOutlet weak var signUpButton: UIButton!
  @IBOutlet weak var toggleSignUpButton: UIButton!
  
  var signUpState  = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
    view.addGestureRecognizer(tap)
    
    self.username.delegate = self
    self.password.delegate = self
    
  }
  
  @IBAction func signUp(sender: AnyObject) {
    
    if username.text == "" || password.text == "" {
      
      displayAlert("Missing Field(s)", message: "Username and Password are required.")
      
    } else {
      
      
      if signUpState == true {
        
        let user = PFUser()
        user.username = username.text
        user.password = password.text

        user["isDriver"] = `switch`.on

        user.signUpInBackgroundWithBlock {
          (succeeded: Bool, error: NSError?) -> Void in
          if let error = error {
            if let errorString = error.userInfo["error"] as? String {
              
              self.displayAlert("Sign Up Failed", message: errorString)
              
            }
            
          } else {
            
            print("successful")
            
          }
      
        }
      } else {
        
        PFUser.logInWithUsernameInBackground(username.text!, password: password.text!) {
          (user: PFUser?, error: NSError?) -> Void in
          if user != nil {
            
            print("Login Successful")
            
          } else {
          
            if let errorString = error?.userInfo["error"] as? String {
              
              self.displayAlert("Login Failed", message: "Username or Password are incorrect.")
              print(errorString)
              
            }
            
          }
        }
        
      }
    }
    
  }
  
  @IBAction func toggleSignUp(sender: AnyObject) {
    
    if signUpState == true {
      
      signUpButton.setTitle("Log In", forState: UIControlState.Normal)
      
      toggleSignUpButton.setTitle("Switch To Sign Up", forState: UIControlState.Normal)
      
      signUpState = false
      
      riderLabel.alpha = 0
      driverLabel.alpha = 0
      `switch`.alpha = 0
      
    } else {
      
      signUpButton.setTitle("Sign Up", forState: UIControlState.Normal)
      
      toggleSignUpButton.setTitle("Switch To Log In", forState: UIControlState.Normal)
      
      signUpState = true
      
      riderLabel.alpha = 1
      driverLabel.alpha = 1
      `switch`.alpha = 1
      
      
    }
    
    
  }
  
  func displayAlert(title:String, message: String) {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
    
    self.presentViewController(alert, animated: true, completion: nil)
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    
    textField.resignFirstResponder()
    return true
    
  }
  
  func dismissKeyboard() {
    
    view.endEditing(true)
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
