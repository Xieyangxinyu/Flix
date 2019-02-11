//
//  YoutubeViewController.swift
//  Flix
//
//  Created by 谢阳欣雨 on 2/10/19.
//  Copyright © 2019 Yangxinyu Xie. All rights reserved.
//

import UIKit
import WebKit

class YoutubeViewController: UIViewController {

    var movie: [String:Any]!
    @IBOutlet weak var YoutubeView: WKWebView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = movie["title"] as? String
        synopsisLabel.text = movie["overview"] as? String
        let id = movie["id"] as! NSNumber
        getVideo(videoCode: id)
    }
    

    func getVideo(videoCode: Any){
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(videoCode)/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                let movieTrailer = dataDictionary["results"]  as! [[String:Any]]
                let key = movieTrailer[0]["key"] as! String
                let id = URL(string: "https://www.youtube.com/embed/\(key)")
                
                self.YoutubeView.load(URLRequest(url: id!))
            }
        }
        task.resume()
    }

}
