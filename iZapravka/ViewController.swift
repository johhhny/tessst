//
//  ViewController.swift
//  iZapravka
//
//  Created by user on 28.01.17.
//  Copyright © 2017 Johhhny. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class SingleClass: UIViewController {
    //ergerrgergerge
    var a = 6
    var arrayForGasStations = [NSManagedObject]()
    var loadBD: [NSManagedObject] {
        get {
            let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
            let context = appDel.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "GasStation")
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            do {
                return try context.fetch(request) as! [NSManagedObject]
            } catch {
                return arrayForGasStations
            }
        }
    }
    
    
}

var requestGasStation = SingleClass()

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

