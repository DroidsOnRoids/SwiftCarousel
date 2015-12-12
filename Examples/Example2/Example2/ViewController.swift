//
//  ViewController.swift
//  Example2
//
//  Created by Lukasz Mroz on 11.12.2015.
//  Copyright © 2015 Droids on Roids. All rights reserved.
//

import UIKit
import SwiftCarousel

class ViewController: UIViewController {

    var carouselView: SwiftCarousel!
    var choices: [UIView]!
    var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let carouselFrame = CGRect(x: view.center.x - 200, y: view.center.y - 100, width: 400, height: 200)
        choices = (1...5).map{ choice in
            let imageView = UIImageView(image: UIImage(named: "puppy\(choice)"))
            imageView.frame = CGRect(origin: CGPointZero, size: CGSize(width: 200, height: 200))
            
            return imageView
        }
        carouselView = SwiftCarousel(frame: carouselFrame, choices: choices)
        carouselView.resizeType = .WithoutResizing(10)
        carouselView.delegate = self
        view.addSubview(carouselView)
        
        let labelFrame = CGRect(x: view.center.x - 150, y: CGRectGetMinY(carouselFrame) - 40, width: 300, height: 20)
        label = UILabel(frame: labelFrame)
        label.text = ""
        label.textColor = UIColor.blackColor()
        label.textAlignment = .Center
        view.addSubview(label)
        
        let titleFrame = CGRect(x: view.center.x - 150, y: 60, width: 300, height: 24)
        let title = UILabel(frame: titleFrame)
        title.text = "Puppy selector 🐶🐱"
        title.font = UIFont.systemFontOfSize(24)
        title.textColor = UIColor.blackColor()
        title.textAlignment = .Center
        
        view.addSubview(title)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: SwiftCarouselDelegate {
    func didSelectItem(item item: UIView, index: Int) -> UIView? {
        label.text = index < 2 ? "🐶 number \(index+1) won! Woof woof 🐶" : "🐱 number \(index - 1) won! Meeeeeeow 🐱"
        
        return nil
    }
    
    func willBeginDragging(withOffset offset: CGPoint) {
        label.text = "Searching for some love.."
    }
}