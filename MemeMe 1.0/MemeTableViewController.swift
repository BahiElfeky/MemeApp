//
//  MemeTableViewController.swift
//  MemeMe 1.0
//
//  Created by Bahi El Feky on 3/30/19.
//  Copyright © 2019 Bahi El Feky. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {


    var meme: [MemedImage]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        tableView.layoutIfNeeded()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return meme.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let memes = self.meme[(indexPath as NSIndexPath).row]
        cell.tableViewImage?.image = memes.originalImage
        cell.tableViewTopText?.text = memes.topText
        cell.tableViewBottomText?.text = memes.bottomText
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailController.meme = self.meme[(indexPath as NSIndexPath).row]
        self.navigationController?.pushViewController(detailController, animated: true)
    }
}
