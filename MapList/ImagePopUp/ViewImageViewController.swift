//
//  ViewImageViewController.swift
//  MapList
//
//  Created by Behroz Khan on 14/03/2021.
//

import UIKit

class ViewImageViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
        
    
    var places : Places?
    var image = UIImage()
        override func viewDidLoad() {
            super.viewDidLoad()
            imageView.image = places?.image
            scrollView.maximumZoomScale = 4
            scrollView.minimumZoomScale = 1
            
            scrollView.delegate = self
        }
    
    @IBAction func shareBtnTapped(_ sender: Any) {
        
        let coordinate = places?.Location
        let image = places?.image
        let ss = "http://maps.apple.com/?ll=\(coordinate?.latitude ?? 0.0),\(coordinate?.longitude ?? 0.0)"
        let vCardURL = ViewController.vCardURL(from: coordinate!, with: "Test")
        let activityViewController = UIActivityViewController(activityItems: [image!,ss], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    }

    extension ViewImageViewController: UIScrollViewDelegate {
        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return imageView
        }
        
        func scrollViewDidZoom(_ scrollView: UIScrollView) {
            if scrollView.zoomScale > 1 {
                if let image = imageView.image {
                    let ratioW = imageView.frame.width / image.size.width
                    let ratioH = imageView.frame.height / image.size.height
                    
                    let ratio = ratioW < ratioH ? ratioW : ratioH
                    let newWidth = image.size.width * ratio
                    let newHeight = image.size.height * ratio
                    let conditionLeft = newWidth*scrollView.zoomScale > imageView.frame.width
                    let left = 0.5 * (conditionLeft ? newWidth - imageView.frame.width : (scrollView.frame.width - scrollView.contentSize.width))
                    let conditioTop = newHeight*scrollView.zoomScale > imageView.frame.height
                    
                    let top = 0.5 * (conditioTop ? newHeight - imageView.frame.height : (scrollView.frame.height - scrollView.contentSize.height))
                    
                    scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
                    
                }
            } else {
                scrollView.contentInset = .zero
            }
        }
    }

