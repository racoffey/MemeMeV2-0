//
//  MemeCollectionViewController.swift
//  MemeMev2.0
//
//  Created by Robert Coffey on 16/01/2016.
//  Copyright © 2016 Robert Coffey. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    //Loads meme struct from AppDelegate
    var memes: [Meme]! {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    //Outlet for flowLayout
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Establish layout parameters for collection view. View dimensioned to show 3 meme images across narrowest screen dimension
        let space: CGFloat = 3.0
        var dimension = view.frame.size.width
        if UIDevice.currentDevice().orientation.isPortrait {
            dimension = (view.frame.size.width - (2 * space)) / 3.0
        }
        else {
            dimension = (view.frame.size.height - (2 * space)) / 3.0
        }
        print(dimension)
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    override func viewWillAppear(animated: Bool) {
        //Data reloaded each time view appears to ensure latest data is always presented
        collectionView?.reloadData()
    }
    
    // Provide number of items to be show
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    // Populate rows based on meme content. Only image is used
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[indexPath.row]
        cell.memedImageView?.image = meme.memedImage

        return cell
    }
    
    // Instantiate Meme Detail View Controller when meme selected and pass selected meme to this controller
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    //When device is rotated invalidate collection view layout to trigger updated layout and reload data
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        collectionViewLayout.invalidateLayout()
        collectionView?.reloadData()
    }
    
}