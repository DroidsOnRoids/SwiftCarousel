//
//  ViewController.swift
//  Example1
//
//  Created by Lukasz Mroz on 10.12.2015.
//  Copyright © 2015 Droids on Roids. All rights reserved.
//

import UIKit
import SwiftCarousel

class ViewController: UIViewController {

    @IBOutlet weak var carousel: SwiftCarousel!
    @IBOutlet weak var selectedTextLabel: UILabel!
    var items: [String]?
    var itemsViews: [UILabel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        items = ["Elephants", "Tigers", "Chickens", "Owls", "Rats", "Parrots", "Snakes"]
        itemsViews = items!.map { labelForString($0) }
        carousel.items = itemsViews!
        carousel.resizeType = .VisibleItemsPerPage(3)
        carousel.defaultSelectedIndex = 3
        carousel.delegate = self
    }
    
    func labelForString(string: String) -> UILabel {
        let text = UILabel()
        text.text = string
        text.textColor = .blackColor()
        text.textAlignment = .Center
        text.font = .systemFontOfSize(24.0)
        text.numberOfLines = 0
        
        return text
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func selectTigers(sender: AnyObject) {
        carousel.selectItem(1, animated: true)
    }
}


extension ViewController: SwiftCarouselDelegate {
    
    func didSelectItem(item item: UIView, index: Int) -> UIView? {
        if let animal = item as? UILabel {
            animal.textColor = UIColor.redColor()
            selectedTextLabel.text = "So you like \(animal.text!), eh?"
            
            return animal
        }
        
        return item
    }
    
    func didDeselectItem(item item: UIView, index: Int) -> UIView? {
        if let animal = item as? UILabel {
            animal.textColor = .blackColor()
            
            return animal
        }
        
        return item
    }
    
    func didScroll(toOffset offset: CGPoint) {
        selectedTextLabel.text = "Spinning up!"
    }
    
    func willBeginDragging(withOffset offset: CGPoint) {
        selectedTextLabel.text = "So you're gonna drag me now?"
    }
    
    func didEndDragging(withOffset offset: CGPoint) {
        selectedTextLabel.text = "Oh, here we go!"
    }
}
