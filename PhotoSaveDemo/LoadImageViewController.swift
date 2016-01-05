//
//  LoadImageViewController.swift
//  PhotoSaveDemo
//
//  Created by Ferdy Fauzi on 29/12/2015.
//  Copyright © 2015 Ferdy Fauzi. All rights reserved.
//

import UIKit

class LoadImageViewController: UIViewController {

    @IBOutlet weak var myLoadImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let loadedImage = loadImageFromPath(myImagePath as! String) {
            print(" Loaded Image: \(loadedImage)")
            myLoadImage.image = loadedImage
            
        } else { print("cannot load image") }


        // Do any additional setup after loading the view.
    }
    
    func loadImageFromPath(path: String) -> UIImage? {
        
        let image = UIImage(contentsOfFile: path)
        
        if image == nil {
            
            print("missing image at: \(path)")
        }
        print("Loading image from path: \(path)") // this is just for you to see the path in case you want to go to the directory, using Finder.
        return image
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
