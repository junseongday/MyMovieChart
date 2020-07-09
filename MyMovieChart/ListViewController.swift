//
//  ListViewController.swift
//  MyMovieChart
//
//  Created by JSMAC on 2019/12/09.
//  Copyright © 2019 JSPRO. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    var page = 1
    @IBOutlet var moreBtn: UIButton!
    //    var dataset = [
//        ("다크나이트", "영웅물에 철학에 음악까지 더해져 예술이 되다.", "2008-09-04", 8.95, "darknight.jpg"),
//        ("호우시절", "때를 알고 내리는 좋은 비", "2009-10-08", 7.31, "rain.jpg"),
//        ("말할 수 없는 비밀", "여기서 너까지 다섯 걸음", "2015-05-07", 9.19, "secret.jpg")
//    ]
    
    lazy var list: [MovieVO] = {
        var datalist = [MovieVO]()
//        for (title, desc, opendate, rating, thumbnail) in self.dataset {
//            let mvo = MovieVO()
//            mvo.title = title
//            mvo.detail = desc
//            mvo.opendate = opendate
//            mvo.rating = rating
//            mvo.thumbnail = thumbnail
//
//            datalist.append(mvo)
//        }
        return datalist
    }()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.list[indexPath.row]
        
        NSLog("제목:\(row.title!), 호출된 행번호:\(indexPath.row)")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! MovieCell
  
        cell.title.text = row.title
        cell.desc.text = row.detail
        cell.opendate.text = row.opendate
        cell.rating.text = "\(row.rating!)"
//        let url: URL! = URL(string: row.thumbnail!)
//        let imageData = try! Data(contentsOf: url)
//        cell.thumbnail.image = UIImage(data: imageData)
//        cell.thumbnail.image = row.thumbnailImage
        DispatchQueue.main.async(execute: {
            cell.thumbnail.image = self.getThumbnailImage(indexPath.row)
        })
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("선택된 행은 \(indexPath.row) 번째 행입니다")
        
    }
    
    override func viewDidLoad() {
        self.callMovieAPI()
    }
    
    @IBAction func more(_ sender: Any) {
        self.page += 1
        self.callMovieAPI()
    }
    
    func callMovieAPI() {
        let url = "http://swiftapi.rubypaper.co.kr:2029/hoppin/movies?version=1&page=\(self.page)&count=30&genreId=&order=releasedateasc"
        let apiURI: URL! = URL(string: url)
        let apidata = try! Data(contentsOf: apiURI)
        let log = NSString(data: apidata, encoding: String.Encoding.utf8.rawValue) ?? ""
        NSLog("API Result=\(log)")
        
        do {
            let apiDictionary = try JSONSerialization.jsonObject(with: apidata, options: []) as! NSDictionary
            let hoppin = apiDictionary["hoppin"] as! NSDictionary
            let movies = hoppin["movies"] as! NSDictionary
            let movie = movies["movie"] as! NSArray
            
            for row in movie {
                let r = row as! NSDictionary
                let mvo = MovieVO()
                mvo.title = r["title"] as? String
                mvo.description = r["genreNames"] as? String
                mvo.thumbnail = r["thumbnailImage"] as? String
                mvo.detail = r["linkUrl"] as? String
                mvo.rating = (r["ratingAverage"] as! NSString).doubleValue
                
                let url:URL! = URL(string: mvo.thumbnail!)
                let imageData = try! Data(contentsOf: url)
                mvo.thumbnailImage = UIImage(data: imageData)
                
                self.list.append(mvo)
            }
            self.tableView.reloadData()
            if (self.list.count >= (hoppin["totalCount"] as! NSString).integerValue) {
                self.moreBtn.isHidden = true
            }
        } catch {
            
        }
    }
    
    func getThumbnailImage(_ index: Int) -> UIImage {
        let mvo = self.list[index]
        
        if let savedImage = mvo.thumbnailImage {
            return savedImage
        } else {
            let url:URL! = URL(string: mvo.thumbnail!)
            let imageData = try! Data(contentsOf: url)
            mvo.thumbnailImage = UIImage(data: imageData)
            
            return mvo.thumbnailImage!
            
        }
    }
    
}

extension ListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_detail" {
            let path = self.tableView.indexPath(for: sender as! MovieCell)
            NSLog("path: \(path!)")
            let detailVC = segue.destination as? DetailViewController
            detailVC?.mvo = self.list[path!.row]
        }
    }
}

