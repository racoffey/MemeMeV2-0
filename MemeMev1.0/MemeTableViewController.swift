//
//  MemeTableViewController.swift
//  MemeMev2.0
//
//  Created by Robert Coffey on 19/01/2016.
//  Copyright © 2016 Robert Coffey. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //Loads meme struct from AppDelegate
    var memes: [Meme]! {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    @IBOutlet weak var memeTableView: UITableView!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set row height
        self.memeTableView.rowHeight = 100   
    }
    
    //Reload data each time view appears to secure most recent data is always shown
    override func viewWillAppear(animated: Bool) {
        self.memeTableView.reloadData()
    }
    
    // Provide number of rows based on items in the memes struct
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.memes.count
    }
    
    // Populate table with content of memes struct, including top text, bottom text and image
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = memeTableView.dequeueReusableCellWithIdentifier("MemeTableCell")!
        let meme = self.memes[indexPath.row]
        cell.imageView?.image = meme.memedImage
        let text = meme.topText + " ... " + meme.bottomText
        cell.textLabel?.frame.origin.x = 100
        cell.textLabel!.text = text
        
        return cell
    }
    
    // Instantiate Meme Detail View Controller with selected meme content
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    // Allow selected row to be edited
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // If delete selected meme is removed from Memes struct in AppDelegate and from the table view
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            self.memeTableView.reloadData()
        }
    }
}