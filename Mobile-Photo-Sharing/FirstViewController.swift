//
//  FirstViewController.swift
//  Mobile-Photo-Sharing
//
//  Created by LyuQi on 9/6/17.
//  Copyright © 2017 LyuQi. All rights reserved.
//

import UIKit
import AWSS3
import AWSSNS
import AWSCore
import AWSCognito

class FirstViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var myFilePath = NSURL(fileURLWithPath: "/Users/lyuqi/Projects/Mobile-Photo-Sharing/IMG/test.jpg")
    var imageURL:String = ""
    var progressBlock: AWSS3TransferUtilityProgressBlock?
    var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?

    @IBOutlet weak var imageName: UITextField!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var progress: UIProgressView!
   
    
    @IBAction func import_image(_ sender: UIButton) {
        let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true)
    }
    
    @IBAction func upload_image(_ sender: UIButton) {

        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = progressBlock
        let S3BucketName = "mobile-photo-sharing-storage"
        let keyName = self.imageName.text ?? "test.jpg"
        let transferUtility = AWSS3TransferUtility.default()
        transferUtility.uploadFile(myFilePath as URL, bucket: S3BucketName, key: keyName, contentType: "image/jpg", expression: expression, completionHandler: completionHandler).continueWith {
            (task) -> AnyObject! in if let error = task.error {
                print("Error: \(error.localizedDescription)")
            }

            if let _ = task.result {
                // Do something with uploadTask.
                let url = AWSS3.default().configuration.endpoint.url.absoluteString
                self.imageURL = url + "/" + S3BucketName + "/" + keyName
            }
            return nil;
        }
    }
    
    @IBAction func view_image(_ sender: UIButton) {
        let image_url = URL(string: imageURL)
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(image_url!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(image_url!)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let imageURL = info[UIImagePickerControllerReferenceURL] as! NSURL
            let imagePath = imageURL.path!
            let localPath = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(imagePath)
            myFilePath = localPath! as NSURL
            myImage.image = image
            let data = UIImageJPEGRepresentation(image, 0.9)
            do {
                try data?.write(to: myFilePath as URL)
            } catch {
                print("ERROR: cannot write to disk")
            }
        } else {
            print("ERROR: no such image")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USWest2, identityPoolId:"us-west-2:3dd3412a-5d5e-47fa-a781-bea2d466bf66")
        
        let configuration = AWSServiceConfiguration(region:.USWest2, credentialsProvider:credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.status.text = ""
        self.progress.progress = 0.0
        self.progress.isHidden = true
        self.progressBlock = {(task, progress) in
            DispatchQueue.main.async(execute: {
                self.progress.progress = Float(progress.fractionCompleted)
                self.status.text = "Uploading..."
            })
        }
        self.completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                if let error = error {
                    print("Failed with error: \(error)")
                    self.status.text = "Failed"
                } else if(self.progress.progress != 1.0) {
                    self.status.text = "Failed"
                    NSLog("Error: Failed - Likely due to invalid region / filename")
                } else {
                    self.status.text = "Success"
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
