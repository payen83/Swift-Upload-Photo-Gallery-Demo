//
//  ViewController.swift
//  PhotoSaveDemo
//
//  Created by Ferdy Fauzi on 29/12/2015.
//  Copyright © 2015 Ferdy Fauzi. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreData

var myImagePath:AnyObject?

func getDocumentsURL() -> NSURL {
    let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
    return documentsURL
}

func fileInDocumentsDirectory(filename: String) -> String {
    
    let fileURL = getDocumentsURL().URLByAppendingPathComponent(filename)
    return fileURL.path!
    
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var newMedia : Bool?
    var imageToSave : AnyObject?
    
    // a queue to save the image without freezing the App UI
    let saveQueue = dispatch_queue_create("saveQueue", DISPATCH_QUEUE_CONCURRENT)
    
    // the Managed Object Context where we will save our image
    let managedContext = AppDelegate().managedObjectContext
    
    @IBOutlet weak var myImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnImportGallery(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
            imagePicker.mediaTypes = [kUTTypeImage as NSString as String]
            
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
            newMedia = false
            
        }//end if UIImagePicker
        
    }// end btn Import Gallery
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let mediaType = info[String(UIImagePickerControllerMediaType)] as! String
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if mediaType.containsString(kUTTypeImage as NSString as String){
            
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            myImage.image = image
            imageToSave = image
            
            if (newMedia == true){
                UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
            }
            
        }//end if mediaType.containString
        
        
    }//end of func imagePickerController
    
    @IBAction func saveImage(sender: AnyObject) {
        
        let myFileName = randomStringWithLength(5)
        let imagePath = fileInDocumentsDirectory(myFileName as String)
        
        myImagePath = imagePath
        
        
        if let image = myImage.image {
            saveImage(image, path: imagePath)
            print("image saved successfully at: \(imagePath)")
        } else { print("Error while saving the image") }
        
        
        //print(String(myImage.description))
        //print(imagePath)
        
    }
    
    func saveImage(image: UIImage, path: String ) -> Bool{
        
        let pngImageData = UIImagePNGRepresentation(image)
        //let jpgImageData = UIImageJPEGRepresentation(image, 1.0)   // if you want to save as JPEG
        let result = pngImageData!.writeToFile(path, atomically: true)
        
        saveInCoreData(path)
        
        return result
        
    }
    
    func saveInCoreData(imagePath: String){
        
        //1 create managedContext for CoreData
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2. create entity
        
        let entity = NSEntityDescription.entityForName("ImageSave", inManagedObjectContext: managedContext)
        
        //3. create item
        let myImageToSave = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        myImageToSave.setValue(imagePath, forKey: "imagePath")
        
        //4. Sync or save data in CoreData
        do{
            try managedContext.save()
            //groceries.append(myGroceries)
            print("\n image saved successfully in Core Data")
            
        } catch let error as NSError{
            print("Could not save. \(error)")
        }
        
    }// end of func saveInCoreData

    
    
    func scale(image image:UIImage, toSize newSize:CGSize) -> UIImage {
        
        // make sure the new size has the correct aspect ratio
        let aspectFill = resizeFill(image.size, toSize: newSize)
        
        UIGraphicsBeginImageContextWithOptions(aspectFill, false, 0.0);
        image.drawInRect(CGRectMake(0, 0, aspectFill.width, aspectFill.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func resizeFill(fromSize: CGSize, toSize: CGSize) -> CGSize {
        
        let aspectOne = fromSize.height / fromSize.width
        let aspectTwo = toSize.height / toSize.width
        
        let scale : CGFloat
        
        if aspectOne < aspectTwo {
            scale = fromSize.height / toSize.height
        } else {
            scale = fromSize.width / toSize.width
        }
        
        let newHeight = fromSize.height / scale
        let newWidth = fromSize.width / scale
        return CGSize(width: newWidth, height: newHeight)
        
    }
    
    func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
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
