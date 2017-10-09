//
//  ThirdViewController.swift
//  Mobile-Photo-Sharing
//
//  Created by LyuQi on 9/18/17.
//  Copyright © 2017 LyuQi. All rights reserved.
//

import UIKit
import YangMingShan

class ThirdViewController: UIViewController, YMSPhotoPickerViewControllerDelegate {

    @IBOutlet weak var numberOfPhotos: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func presentPhotoPicker(_ sender: UIButton) {
        if self.numberOfPhotos.text!.characters.count > 0
            && UInt(self.numberOfPhotos.text!) != 1 {
            let pickerViewController = YMSPhotoPickerViewController.init()
            
            pickerViewController.numberOfPhotoToSelect = UInt(self.numberOfPhotos.text!)!
            
            self.yms_presentCustomAlbumPhotoView(pickerViewController, delegate: self)
        }
        else {
            self.yms_presentAlbumPhotoView(with: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let barButtonItem: UIBarButtonItem! = UIBarButtonItem.init(barButtonSystemItem: .organize, target: self, action:#selector(presentPhotoPicker(_:)))
        self.navigationItem.rightBarButtonItem = barButtonItem
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func photoPickerViewControllerDidReceivePhotoAlbumAccessDenied(_ picker: YMSPhotoPickerViewController!) {
        let alertController = UIAlertController(title: "Allow photo album access?", message: "Need your permission to access photo albums", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (action) in
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
        }
        alertController.addAction(dismissAction)
        alertController.addAction(settingsAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func photoPickerViewControllerDidReceiveCameraAccessDenied(_ picker: YMSPhotoPickerViewController!) {
        let alertController = UIAlertController(title: "Allow camera album access?", message: "Need your permission to take a photo", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (action) in
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
        }
        alertController.addAction(dismissAction)
        alertController.addAction(settingsAction)
        
        // The access denied of camera is always happened on picker, present alert on it to follow the view hierarchy
        picker.present(alertController, animated: true, completion: nil)
    }
    
    
}
