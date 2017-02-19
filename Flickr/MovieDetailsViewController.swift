//
//  MovieDetailsViewController.swift
//  Flickr
//
//  Created by Viet Dang Ba on 2/17/17.
//  Copyright © 2017 Viet Dang. All rights reserved.
//

import UIKit
import AFNetworking

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var imgPoster: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblOverview: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    
    let smallImageBaseURL:String = "https://image.tmdb.org/t/p/w45"
    let baseURL:String = "https://image.tmdb.org/t/p/original"
    var movieDetail:NSDictionary = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblTitle.text = movieDetail["title"] as? String
        self.lblOverview.text = movieDetail["overview"] as? String
        
        self.lblOverview.sizeToFit()
        
        infoView.frame.size = CGSize(width: infoView.frame.size.width, height: lblTitle.frame.size.height + lblOverview.frame.size.height + 5);
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.height )
        
//        if let posterPath = movieDetail["poster_path"] as? String{
//            let fullUrlString = baseURL + posterPath
//            let url = URL(string: fullUrlString)
//            self.imgPoster.setImageWith(url!);
//        }
        loadImage()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadImage(){
        if let posterPath = movieDetail["poster_path"] as? String{
            let smallImageRequest = NSURLRequest(url: NSURL(string: smallImageBaseURL + posterPath)! as URL)
            print(smallImageBaseURL + posterPath)
            let largeImageRequest = NSURLRequest(url: NSURL(string: baseURL + posterPath)! as URL)
            
            self.imgPoster.setImageWith(
                smallImageRequest as URLRequest,
                placeholderImage: nil,
                success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                    
                    // smallImageResponse will be nil if the smallImage is already available
                    // in cache (might want to do something smarter in that case).
                    self.imgPoster.alpha = 0.0
                    self.imgPoster.image = smallImage;
                    
                    UIView.animate(withDuration: 1, animations: { () -> Void in
                        
                        self.imgPoster.alpha = 1.0
                        
                    }, completion: { (sucess) -> Void in
                        
                        // The AFNetworking ImageView Category only allows one request to be sent at a time
                        // per ImageView. This code must be in the completion block.
                        self.imgPoster.setImageWith(
                            largeImageRequest as URLRequest,
                            placeholderImage: smallImage,
                            success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                
                                self.imgPoster.image = largeImage;
                                
                        },
                            failure: { (request, response, error) -> Void in
                                // do something for the failure condition of the large image request
                                // possibly setting the ImageView's image to a default image
                        })
                    })
            },
                failure: { (request, response, error) -> Void in
                    // do something for the failure condition
                    // possibly try to get the large image
            })
 
            
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
