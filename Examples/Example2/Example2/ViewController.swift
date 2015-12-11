//
//  ViewController.swift
//  Example2
//
//  Created by Lukasz Mroz on 11.12.2015.
//  Copyright © 2015 Lukasz Mroz. All rights reserved.
//

import UIKit
import SwiftCarousel

class ViewController: UIViewController {

    var carouselView: SwiftCarousel!
    var choices: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let rect = CGRect(origin: CGPoint(x: view.center.x - 200, y: view.center.y - 100), size: CGSize(width: 400, height: 200))
        choices = (1...5).map{ choice in
            let imageView = UIImageView(image: UIImage(named: "puppy\(choice)"))
            imageView.frame = CGRect(origin: CGPointZero, size: CGSize(width: 200, height: 200))
            
            return imageView
        }
        carouselView = SwiftCarousel(frame: rect, choices: choices)
        carouselView.resizeType = .WithoutResizing(10)
        
        view.addSubview(carouselView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

