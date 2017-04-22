//
//  StatisticsViewController.swift
//  iZapravka
//
//  Created by user on 29.01.17.
//  Copyright © 2017 Johhhny. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import ScrollableGraphView
import UIColor_Hex_Swift


class StatisticsViewController: UIViewController {
    
    @IBOutlet weak var labelKm: UILabel!
    @IBOutlet weak var labelSumma: UILabel!
    @IBOutlet weak var labelPetrol: UILabel!
    @IBOutlet weak var quantityWay: UIButton!
    @IBOutlet weak var segmControl: UISegmentedControl!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var viewGragh: UIView!
    @IBOutlet weak var quantityDay: UILabel!
    
    var beginDatePicker = UIDatePicker()
    var endDatePicker = UIDatePicker()
    var data = [Double]()
    var labels = [String]()
    
    func readReport() {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        let currentBeginDate = formatter.date(from: formatter.string(from: beginDatePicker.date))!
        let plusOneDay = Calendar.current.date(byAdding: .day, value: 1, to: endDatePicker.date)!
        let currentEndDate = formatter.date(from: formatter.string(from: plusOneDay))!
        labelDate.text = formatter.string(from: beginDatePicker.date) + " - " + formatter.string(from: endDatePicker.date)
        /*let a = currentEndDate.timeIntervalSinceReferenceDate
        let b = currentBeginDate.timeIntervalSinceReferenceDate
        print(a-b)*/
        
        var arrayNewRangeDates: [NSManagedObject] = []
        var sumMoney: Float = 0
        var sumLiters: Float = 0
        var quantityKm : Float = 0
        for i in 0..<requestGasStation.arrayForGasStations.count {
            let date = requestGasStation.arrayForGasStations[i].value(forKey: "date") as! Date
            //print(date)
            if (date >= currentBeginDate) && (date <= currentEndDate) {
                //print("Попала \(date)")
                sumMoney += Float(requestGasStation.arrayForGasStations[i].value(forKey: "price") as! String)!
                sumLiters += Float(requestGasStation.arrayForGasStations[i].value(forKey: "liter") as! String)!
                arrayNewRangeDates.append(requestGasStation.arrayForGasStations[i])
            }
        }
        if arrayNewRangeDates.count > 0 {
            let index = arrayNewRangeDates.endIndex - 1
            //print(index)
            quantityKm = Float(arrayNewRangeDates[0].value(forKey: "way") as! String)! -
                Float(arrayNewRangeDates[index].value(forKey: "way") as! String)!
            labelSumma.text = "\(sumMoney) руб"
            labelPetrol.text = "\(sumLiters) л"
            labelKm.text = "\(quantityKm) км"
            //labelDate.text = formatter.string(from: beginDatePicker.date) + " - " + formatter.string(from: endDatePicker.date)
            
            
            //---Рисовашки
            let formatterForArray = DateFormatter()
            formatterForArray.dateFormat = "dd.MM"
            for i in arrayNewRangeDates{
                labels.append(formatterForArray.string(from: i.value(forKey: "date") as! Date))
                data.append(Double(i.value(forKey: "price") as! String)!)
            }
            data.reverse()
            labels.reverse()
            //---Создание экземпляра класса График
            let graphView = ScrollableGraphView(frame:viewGragh.frame)
            graphView.set(data: data, withLabels: labels)
            graphView.backgroundFillColor = UIColor("#307289")//("#333333")
            graphView.rangeMax = data.max()!
            graphView.lineWidth = 1
            graphView.lineColor = UIColor("#777777")
            graphView.lineStyle = ScrollableGraphViewLineStyle.smooth
            graphView.shouldFill = true
            graphView.fillType = ScrollableGraphViewFillType.gradient
            graphView.fillColor = UIColor("#555555")
            graphView.fillGradientType = ScrollableGraphViewGradientType.linear
            graphView.fillGradientStartColor = UIColor("#ffff00")//("#fbf56c")//("#555555")
            graphView.fillGradientEndColor = UIColor("#ffffb4")//("#fdc51f")//("#444444")
            graphView.dataPointSpacing = 38
            graphView.dataPointSize = 3
            graphView.dataPointFillColor = UIColor.gray
            graphView.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 12)
            graphView.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
            graphView.referenceLineLabelColor = UIColor.black
            graphView.dataPointLabelColor = UIColor.black//.withAlphaComponent(0.5)
            
            self.view.addSubview(graphView)
            
            data = []
            labels = []
            //---
            
        } else {
            print("Здесь надо создать АЛЕРТ")
        }
    }
    
    @IBAction func createReport(_ sender: UISegmentedControl) {
        switch segmControl.selectedSegmentIndex {
        case 0:
            beginDatePicker.date = Calendar.current.date(byAdding: .day, value: -6, to: endDatePicker.date)!
            //endDatePicker.minimumDate = beginDatePicker.date

            readReport()
            
        case 1:
            beginDatePicker.date = Calendar.current.date(byAdding: .month, value: -1, to: endDatePicker.date)!
            beginDatePicker.date = Calendar.current.date(byAdding: .day, value: 1, to: beginDatePicker.date)!
            //endDatePicker.minimumDate = beginDatePicker.date
            
            readReport()

            data = []
            labels = []
        case 2:
            beginDatePicker.date = Calendar.current.date(byAdding: .month, value: -6, to: endDatePicker.date)!
            //endDatePicker.minimumDate = beginDatePicker.date
            
            readReport()
            
        default:
            break
        }
    }
    
    @IBAction func clearData(_ sender: UIButton) {
        let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let context = appDel.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "GasStation")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            var results = try context.fetch(request)
            print(results.count)
            try context.execute(deleteRequest)
            results = try context.fetch(request)
            print(results.count)
        } catch {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beginDatePicker.datePickerMode = .date
        endDatePicker.datePickerMode = .date
    }

    override func viewWillAppear(_ animated: Bool) {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        if requestGasStation.arrayForGasStations.count != 0 {
            let endDate = formatter.date(from: formatter.string(from: requestGasStation.arrayForGasStations[0].value(forKey: "date") as! Date))!
            let beginDate = formatter.date(from: formatter.string(from: requestGasStation.arrayForGasStations[requestGasStation.arrayForGasStations.endIndex - 1].value(forKey: "date") as! Date))!
            let raznica = Float(endDate.timeIntervalSinceReferenceDate - beginDate.timeIntervalSinceReferenceDate)
            quantityDay.text = "В среднем вы заправляетесь каждые: " + String(format: "%.2f", ((raznica/3600/24 + 1) / Float(requestGasStation.arrayForGasStations.count))) + " д"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
