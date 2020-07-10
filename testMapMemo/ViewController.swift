//
//  ViewController.swift
//  testMapMemo
//
//  Created by 宮本翼 on 2020/07/04.
//  Copyright © 2020 宮本翼. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var toDoList: UILabel!
    @IBOutlet weak var inputToDo: UITextView!
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var searchMap: UIButton!
    
    var outPutLocation : CGPoint!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func searchButton(_ sender: Any) {
        let myMapViewController = self.storyboard?.instantiateViewController(withIdentifier: "MyMapViewController") as! MyMapViewController
        self.present(myMapViewController, animated: true, completion: nil)
        outPutLocation = myMapViewController.keepLocation
        print(outPutLocation!)
    }
    
    

}

