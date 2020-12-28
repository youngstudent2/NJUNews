//
//  WebDisplayViewController.swift
//  NJUNews
//
//  Created by nju on 2020/12/28.
//

import UIKit
import WebKit
class WebDisplayViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    var news : NewsItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let news = news{
            print(news.href)
        }
        let url = URL(string: news?.href ?? "")!
        let urlRequest = URLRequest(url: url)
        self.webView.load(urlRequest)
        
        
        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
