//
//  TeachingNewsViewController.swift
//  NJUNews
//
//  Created by CuiZihan on 2020/12/23.
//

import UIKit
import SwiftSoup
class TeachingNewsViewController: UIViewController {
    var news = [NewsItem]()
    var domain = "https://jw.nju.edu.cn"
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchData()
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        super.prepare(for: segue, sender: sender)
        //print("identifier:" + segue.identifier!)
        switch segue.identifier ?? "" {
        case "ShowTeachingNewsDetail":
            guard let webDisplayViewController = segue.destination as? WebDisplayViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }

            guard let selectedNewsCell = sender as? TeachingNewsTableViewCell else {
                    fatalError("Unexpected sender: \(String(describing: sender))")
                }

            guard let indexPath = tableView.indexPath(for: selectedNewsCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }

            let selectedNews = news[indexPath.row]
            webDisplayViewController.news = selectedNews
            
        default:
            fatalError("Unexpected Segue Identifier: \(String(describing: segue.identifier))")
        }
    }
    
    private func fetchData() {
        let url = URL(string: "https://jw.nju.edu.cn/24774/list.htm")!
        let task = URLSession.shared.dataTask(with: url, completionHandler: {
            data, response, error in
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
                
            guard let httpResponse = response as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode) else {
                    print("server error")
                    return
            }
                
            if let mimeType = httpResponse.mimeType, mimeType == "text/html",
                let data = data,
                let string = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        do{
                            let doc : Document = try SwiftSoup.parse(string)
                            let news : Elements = try doc.getElementsByClass("news")
                            //print(try news.first()?.html())
                            for new in news {
                                let title = try new.select("a").attr("title")
                                let href = try new.select("a").attr("href")
                                let date = try new.select("span.news_meta").text()
                                guard let newsItem = NewsItem(title: title, href: self.domain + href, date: date) else {
                                    fatalError("Unable to instantiate TeachingNews")
                                }
                                self.news.append(newsItem)
                            }
                            self.tableView.reloadData()
                        }catch Exception.Error(_, let message) {
                            print(message)
                        } catch {
                            print("error")
                        }
                    }
                
                
            }
        })
        task.resume()
       
    }
}

extension TeachingNewsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeachingNewsCell") as! TeachingNewsTableViewCell
        let newsItem = self.news[indexPath.row]
        cell.textLabel?.text = "[\(newsItem.date)]"+newsItem.title
        return cell
    }
    
    
}
