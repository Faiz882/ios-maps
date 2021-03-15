//
//  ImageViewController.swift
//  MapList
//
//  Created by Usama Ali on 01/02/2021.
//

import UIKit
import MapKit
class ImageViewController: UIViewController {

    var data : Places?
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var lablName: UILabel!
    @IBOutlet weak var crossBtn: UIButton!
    @IBOutlet weak var sharebUTTON: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image.layer.cornerRadius = 6
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.gray.cgColor
        image.image = data?.image
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
//        let tappedImage = tapGestureRecognizer.view as! UIImageView
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewImageVC") as! ViewImageViewController
        vc.image = data!.image 
//        vc.imageView.image = data?.image
        
          self.present(vc, animated: true, completion: nil)
        
    }
    

    
    @IBAction func crossButton(_ sender: Any) {
        view.removeFromSuperview()
    }
    
    @IBAction func sharePressed(_ sender: Any) {
        let coordinate = data?.Location
        let image = data?.image
        let ss = "http://maps.apple.com/?ll=\(coordinate?.latitude ?? 0.0),\(coordinate?.longitude ?? 0.0)"
        let vCardURL = ViewController.vCardURL(from: coordinate!, with: "Test")
        let activityViewController = UIActivityViewController(activityItems: [image!,ss], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}
