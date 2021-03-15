//
//  VideoPlayerVC.swift
//  MapList
//
//  Created by Behroz Khan on 14/03/2021.
//

import UIKit


class VideoPlayerVC: UIViewController {

    
    @IBOutlet weak var wbViewplayer: UIWebView!
    
    
    var places : Places?
    override func viewDidLoad() {
        super.viewDidLoad()
        CreateWebViewPlayer()
        // Do any additional setup after loading the view.
    }
    
        func CreateWebViewPlayer()
        {
            self.wbViewplayer.allowsInlineMediaPlayback = true
            
          
            let css = ".video-container {position:relative;padding-bottom:56.25%;height:0;overflow:hidden;} .video-container iframe, .video-container object, .video-container embed { position:absolute; top:0; left:0; width:100%; height:100%; }"
            
            let htmlString = "<html><head><style type=\"text/css\">\(css)</style></head><body><div class=\"video-container\"><iframe src=\"\(places!.video)\"?playsinline=1\"  frameborder=\"0\"></iframe></div></body></html>"
            
            wbViewplayer.scalesPageToFit = false
            wbViewplayer.allowsInlineMediaPlayback = true;
            wbViewplayer.loadHTMLString(htmlString, baseURL: nil)
            
            
        }
    
    @IBAction func shareBtnTapped(_ sender: UIButton) {
        
        let coordinate = places?.Location
        let image = places?.image
        let ss = "http://maps.apple.com/?ll=\(coordinate?.latitude ?? 0.0),\(coordinate?.longitude ?? 0.0)"
        let vCardURL = ViewController.vCardURL(from: coordinate!, with: "Test")
        let activityViewController = UIActivityViewController(activityItems: [image!,ss], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    
}
