//
//  HomeViewController.swift
//  Shift
//
//  Created by Chris Villegas on 5/7/19.
//  Copyright © 2019 Village Games. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var play: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let frame = self.view.frame
        UIView.animate(withDuration: 1, animations: {
            let width = frame.width * 5 / 6
            let height = frame.height / 6
            let x = frame.midX - width / 2
            let y = frame.height / 4
            self.logo.frame = CGRect(x: x, y: y, width: width, height: height)
            
        })
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
