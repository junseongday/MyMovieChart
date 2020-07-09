//
//  DetailViewController.swift
//  MyMovieChart
//
//  Created by JSMAC on 2019/12/19.
//  Copyright © 2019 JSPRO. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    @IBOutlet var wv: WKWebView!
    var mvo: MovieVO!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        self.wv.navigationDelegate = self
        
        let navibar = self.navigationItem
        navibar.title = self.mvo?.title
        
        if let url = self.mvo.detail {
            if let urlObj = URL(string: url) {
                let req = URLRequest(url: urlObj)
                self.wv.load(req)
            } else {
                let alert = UIAlertController(title: "오류", message: "잘못된 URL입니다", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "확인", style: .cancel) { _ in
                    _ = self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(cancelAction)
                self.present(alert, animated: false, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "오류", message: "필수 파라미터가 누락되었습니다.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "확인", style: .cancel) { _ in
                _ = self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(cancelAction)
            self.present(alert, animated: false, completion: nil)
        }
        
        
    }
}

// MARK:- WKNavigationDelegate 프로토콜 구현
extension DetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.spinner.startAnimating()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.spinner.stopAnimating()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.spinner.stopAnimating()
        self.alert("상세 페이지를 읽어오지 못했습니다.") {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
}

extension DetailViewController {
    func alert(_ message: String, onclick: (() -> Void)? = nil) {
        let controller = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
            onclick?()
        })
        DispatchQueue.main.async {
            self.present(controller, animated: true, completion: nil)
        }
    }
}
