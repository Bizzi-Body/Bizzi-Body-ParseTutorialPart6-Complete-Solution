//
//  TableTableViewController.swift
//  ParseTutorial
//
//  Created by Ian Bradbury on 05/02/2015.
//  Copyright (c) 2015 bizzi-body. All rights reserved.
//

import UIKit

class TableViewController: PFQueryTableViewController, UISearchBarDelegate {

	// Sign the user out
	@IBAction func signOut(sender: AnyObject) {
		
		PFUser.logOut()
		
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewControllerWithIdentifier("SignUpInViewController") as! UIViewController
		self.presentViewController(vc, animated: true, completion: nil)
	}
	
	@IBAction func add(sender: AnyObject) {
		
		dispatch_async(dispatch_get_main_queue()) {
			self.performSegueWithIdentifier("TableViewToDetailView", sender: self)
		}
	}

	// Table search bar
	@IBOutlet weak var searchBar: UISearchBar!
	
	// Initialise the PFQueryTable tableview
	override init!(style: UITableViewStyle, className: String!) {
		super.init(style: style, className: className)
	}
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
  
		// Configure the PFQueryTableView
		self.parseClassName = "Countries"
		self.textKey = "nameEnglish"
		self.pullToRefreshEnabled = true
		self.paginationEnabled = false
	}
	
	
	//override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject) -> PFTableViewCell {
		
		var cell = tableView.dequeueReusableCellWithIdentifier("CustomCell") as! CustomTableViewCell!
		if cell == nil {
			cell = CustomTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CustomCell")
		}
		
		// Extract values from the PFObject to display in the table cell
		if let nameEnglish = object["nameEnglish"] as? String {
			cell.customNameEnglish.text = nameEnglish
		}
		if let capital = object["capital"] as? String {
			cell.customCapital.text = capital
		}
		
		// Display flag image
		var initialThumbnail = UIImage(named: "question")
		cell.customFlag.image = initialThumbnail
		if let thumbnail = object["flag"] as? PFFile {
			cell.customFlag.file = thumbnail
			cell.customFlag.loadInBackground()
		}
		
		return cell
	}
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		// Get the new view controller using [segue destinationViewController].
		var detailScene = segue.destinationViewController as! DetailViewController
		
		// Pass the selected object to the destination view controller.
		if let indexPath = self.tableView.indexPathForSelectedRow() {
			let row = Int(indexPath.row)
			detailScene.currentObject = objects[row] as? PFObject
		}
	}
	
	// Define the query that will provide the data for the table view
	override func queryForTable() -> PFQuery! {
		
		// Start the query object
		var query = PFQuery(className: "Countries")
		
		// Add a where clause if there is a search criteria
		if searchBar.text != "" {
			query.whereKey("searchText", containsString: searchBar.text.lowercaseString)
		}
		
		// Order the results
		query.orderByAscending("nameEnglish")
		
		// Return the qwuery object
		return query
	}
	
	func searchBarTextDidEndEditing(searchBar: UISearchBar) {
		
		// Dismiss the keyboard
		searchBar.resignFirstResponder()
		
		// Force reload of table data
		self.loadObjects()
	}
	
	
	
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		
		// Dismiss the keyboard
		searchBar.resignFirstResponder()
		
		// Force reload of table data
		self.loadObjects()
	}
	
	
	func searchBarCancelButtonClicked(searchBar: UISearchBar) {
		
		// Clear any search criteria
		searchBar.text = ""
		
		// Dismiss the keyboard
		searchBar.resignFirstResponder()
		
		// Force reload of table data
		self.loadObjects()
	}
	
	
	override func viewDidAppear(animated: Bool) {
		
		// Refresh the table to ensure any data changes are displayed
		tableView.reloadData()
		
		// Delegate the search bar to this table view class
		searchBar.delegate = self
		
	}
	
	override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
		searchBar.resignFirstResponder()
		self.view.endEditing(true)
	}
	
}
