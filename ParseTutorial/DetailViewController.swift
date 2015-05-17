//
//  DetailViewController.swift
//  ParseTutorial
//
//  Created by Ian Bradbury on 06/02/2015.
//  Copyright (c) 2015 bizzi-body. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
	
	// Container to store the view table selected object
	var currentObject : PFObject?
	
	// Some text fields
	@IBOutlet weak var nameEnglish: UITextField!
	@IBOutlet weak var nameLocal: UITextField!
	@IBOutlet weak var capital: UITextField!
	@IBOutlet weak var currencyCode: UITextField!
	@IBOutlet weak var flag: PFImageView!
	
	
	// The save button
	@IBAction func saveButton(sender: AnyObject) {
		
		if let updateObject = currentObject as PFObject? {
			
			// Update the existing parse object
			updateObject["nameEnglish"] = nameEnglish.text
			updateObject["nameLocal"] = nameLocal.text
			updateObject["capital"] = capital.text
			updateObject["currencyCode"] = currencyCode.text
			
			// Create a string of text that is used by search capabilites
			var searchText = (capital.text + " " + nameEnglish.text + " " + nameLocal.text + " " + currencyCode.text).lowercaseString
			updateObject["searchText"] = searchText
			
			// Save the data back to the server in a background task
			updateObject.saveEventually()
		} else {
			
			// Create a new parse object
			var updateObject = PFObject(className:"Countries")
			
			updateObject["nameEnglish"] = nameEnglish.text
			updateObject["nameLocal"] = nameLocal.text
			updateObject["capital"] = capital.text
			updateObject["currencyCode"] = currencyCode.text
			
			// Create a string of text that is used by search capabilites
			var searchText = (capital.text + " " + nameEnglish.text + " " + nameLocal.text + " " + currencyCode.text).lowercaseString
			updateObject["searchText"] = searchText
			
			updateObject.ACL = PFACL(user: PFUser.currentUser())
			
			// Save the data back to the server in a background task
			updateObject.saveEventually()
		}
		
		// Return to table view
		self.navigationController?.popViewControllerAnimated(true)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Unwrap the current object object
		if let object = currentObject {
			nameEnglish.text = object["nameEnglish"] as! String
			nameLocal.text = object["nameLocal"] as! String
			capital.text = object["capital"] as! String
			currencyCode.text = object["currencyCode"] as! String
			
			var initialThumbnail = UIImage(named: "question")
			flag.image = initialThumbnail
			if let thumbnail = object["flag"] as? PFFile {
				flag.file = thumbnail
				flag.loadInBackground()
			}
			
		}
	}
}
