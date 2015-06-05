//
//  ViewController.swift
//  CollectionView Play
//
//  Created by Jeremy Frick on 6/4/15.
//  Copyright (c) 2015 Red Anchor Software. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, searchResultsProtocol {
    var movies = [Movie]()
    var API: OnlineDataBaseSearch!
    @IBOutlet weak var selection: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        API = OnlineDataBaseSearch(delegate: self)
        self.selection.selectedSegmentIndex = 0
        // Do any additional setup after loading the view, typically from a nib.
    }

    func didReceiveSearchResults(results:NSDictionary) {
        dispatch_async(dispatch_get_main_queue(),{
            self.movies = Movie.moviesWithJSON(results)
            self.collectionView!.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    
    //MARK: - TableView
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! MovieCell
        let movie = self.movies[indexPath.row]
        cell.movieTitle?.text =  movie.title
        cell.MovieYear?.text = movie.year
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        return cell
    }
}

extension ViewController : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        API.searchDataBase(textField.text)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        activityIndicator.removeFromSuperview()
        textField.text = nil
        textField.resignFirstResponder()
        return true
        
    }
}

