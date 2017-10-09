//
//  SecondViewController.swift
//  Mobile-Photo-Sharing
//
//  Created by LyuQi on 9/6/17.
//  Copyright © 2017 LyuQi. All rights reserved.
//

import UIKit
import AWSS3
import AWSCore
import AWSCognito

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let S3BucketName = "mobile-photo-sharing-storage"
    let S3DownloadKeyName = "test.jpg"
    var objects = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func refresh(_ sender: UIButton) {
        self.getListOfimage()
    }
    @IBAction func image_download(_ sender: UIButton) {
        
        let fileURL = "/Users/lyuqi/Projects/Mobile-Photo-Sharing/Download/test.jpg"
        let transferUtility = AWSS3TransferUtility.default()
        transferUtility.download(
            to: NSURL(fileURLWithPath: fileURL) as URL,
            bucket: S3BucketName,
            key: S3DownloadKeyName,
            expression: nil,
            completionHandler: nil
            ).continueWith {
                (task) -> AnyObject! in if let error = task.error {
                    print("Error: \(error.localizedDescription)")
                }
                
                if let _ = task.result {
                    // Do something with downloadTask.
                    NSLog("Download Starting!")
                }
                return nil;
        }
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
        self.getListOfimage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getListOfimage() {
        let s3 = AWSS3.s3(forKey: "USWest2S3")
        let listRequest:AWSS3ListObjectsRequest = AWSS3ListObjectsRequest()
        listRequest.bucket = "mobile-photo-sharing-storage"
        self.objects = [String]()
        s3.listObjects(listRequest).continueWith { (task) -> AnyObject? in
            for object in (task.result?.contents)! {
                print("Object key = \(object.key!)")
                self.objects.append(object.key!)
            }
            return nil
        }
        self.tableView.reloadData()
    }
//    MARK: table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objects.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.imageName.text = self.objects[indexPath.row]
        cell.share.tag = indexPath.row
        cell.share.addTarget(self, action: Selector(("ShareAction")), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: <#T##String#>, sender: self)
    }
    
}
