//
//  ViewController.swift
//  KeySearch
//
//  Created by ijinfeng on 08/19/2021.
//  Copyright (c) 2021 ijinfeng. All rights reserved.
//

import UIKit
import KeySearch

class ViewController: UIViewController {

    var textLabel: UILabel = {
        let label = UILabel()
//        label.text = "D座大道就在前方，你的呢dong东西呢"
        label.text = "D座大道"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .blue
        label.frame = CGRect(x: 0, y: 100, width: UIScreen.main.bounds.size.width, height: 200)
        
        return label
    }()
    
    var searchBar: UISearchBar = {
        let bar = UISearchBar()
        return bar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        PinYinManager.shared.loadPinyinData()
        
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        textLabel.backgroundColor = .lightGray
        view.addSubview(textLabel)
        
        
        
        print(textLabel)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = textLabel.text!
//        let arrs = text.getRanges(with: searchText)
//        let arrs = text.getRanges(with: ["B", "的"])
        var arrs: [Range<String.Index>] = []
        
        text.canMatch(with: searchText, all: &arrs)
        
        
        let att = NSMutableAttributedString.init(string: text)
        for range in arrs {
            print("+++r=\(text.rawRange(from: range))")
            att.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: text.nsRange(from: range))
        }
        
//        for (_, values) in arrs {
//            for range in values {
//                att.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: text.nsRange(from: range))
//            }
//        }
        
        textLabel.attributedText = att
    }
}
