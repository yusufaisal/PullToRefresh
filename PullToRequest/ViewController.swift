//
//  ViewController.swift
//  PullToRequest
//
//  Created by iSal on 24/02/20.
//  Copyright © 2020 iSal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var refreshControl: UIRefreshControl = UIRefreshControl()
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPullToRefresh(from: &refreshControl, for: &scrollView, title: "" )
    }
    
    func performPullToRequest(with completion: @escaping () -> Void) {
        let concurrentQueue = DispatchQueue(label: "main.view.loader", attributes: .concurrent)
        let group = DispatchGroup()
        for i in 1...5 {
            group.enter()
            concurrentQueue.async {
                let imageURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/0/07/Huge_ball_at_Vilnius_center.jpg")!
                let _ = try! Data(contentsOf: imageURL)
                print("###### Image \(i) Downloaded ######")
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            completion()
        }
    }
    
    override func didReleasePullToRefresh(sender: UIRefreshControl) {
        performPullToRequest(with: {
            print("##### Download Completed #####")
            sender.endRefreshing()
        })
    }
}

extension UIViewController {
    /// This function used to setup Refresh Control on tableView. You can call this function on viewDidLoad(:)
    /// - Parameters:
    ///   - refreshControl: The Refresh Control
    ///   - scrollView: The scrollView that you want to embed by refreshControl
    ///   - title: The string that you want to show while refreshing
    func setupPullToRefresh(from refreshControl: inout UIRefreshControl ,for scrollView: inout UIScrollView, title:String){
        scrollView.alwaysBounceVertical = true
        scrollView.bounces  = true
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: title)
        refreshControl.addTarget(self, action: #selector(didReleasePullToRefresh), for: UIControl.Event.valueChanged)
        
        scrollView.addSubview(refreshControl)
    }
    
    /// Call this method at the end of any refresh operation (whether it was initiated programmatically or by the user) to return the refresh control to its default state. If the refresh control is at least partially visible, calling this method also hides it. If animations are also enabled, the control is hidden using an animation. But,  you can still override this method for your custom procedure.
    /// When you call this method without overriding it, the loading will ends immediately
    /// - Parameter sender:
    @objc func didReleasePullToRefresh(sender:UIRefreshControl){
        sender.endRefreshing()
    }
}
