//
//  ViewController.swift
//  Example3
//
//  Created by Lukasz Mroz on 27.12.2015.
//  Copyright © 2015 Droids On Roids. All rights reserved.
//

import UIKit
import SwiftCarousel

class ViewController: UIViewController {

    @IBOutlet weak var animalsCarousel: SwiftCarousel!
    @IBOutlet weak var animalsMoreCarousel: SwiftCarousel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        navigationController?.navigationBar.removeBorder()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
        animalsCarousel.backgroundColor = UIColor.orangeColor()
        animalsMoreCarousel.backgroundColor = UIColor.orangeColor()
        
        let animals = ["Elephants", "Tigers", "Chickens", "Owls", "Rats", "Parrots", "Snakes"]
        var animalsMore = [[String]]()
        animalsMore.append(["African elephant", "Asian elephant", "Borneo elephant", "Sumatran elephant"])
        animalsMore.append(["Bengal tiger", "Indochinese tiger", "Malayan tiger", "Siberian tiger", "South China tiger", "Sumatran tiger"])
        
        animalsCarousel.items = animals.map { labelForString($0) }
        animalsMoreCarousel.items = animalsMore.first!.map { labelForString($0) }
        
        animalsCarousel.resizeType = .FloatWithSpacing(10, .Center)
        animalsCarousel.delegate = self
        animalsMoreCarousel.resizeType = .FloatWithSpacing(10, .Center)
        animalsMoreCarousel.delegate = self
    }

    func labelForString(string: String) -> UILabel {
        let text = UILabel()
        text.text = string.uppercaseString
        text.textColor = UIColor.whiteColor()
        text.textAlignment = .Center
        text.font = UIFont.systemFontOfSize(12.0)
        text.numberOfLines = 0
        
        return text
    }
}

extension ViewController:SwiftCarouselDelegate {
    func didSelectItem(item item: UIView, index: Int) -> UIView? {
        return item
    }
}

extension UINavigationBar {
    func removeBorder() {
        self.subviews.first!.subviews.forEach { subview in
            if subview is UIImageView {
                subview.hidden = true
            }
        }
    }
}

