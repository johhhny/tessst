//
//  TableViewControllerReminder.swift
//  iZapravka
//
//  Created by user on 17.02.17.
//  Copyright © 2017 Johhhny. All rights reserved.
//

import UIKit
import CoreData

class TableViewControllerReminder: UITableViewController, UITextFieldDelegate {

    @IBOutlet var tableViewReminder: UITableView!
    
    /*let sampleSegment = UISegmentedControl()
    let textFieldName = UITextField()
    let textFieldValue = UITextField()
    */
    
    var arrayReminders = [NSManagedObject]()
    
    func textColor(x: Double, y: Double) -> (UIColor) {
        if (x / y) > 0.3 {
            return UIColor.green
        } else if (x / y) > 0.15 && (x / y) <= 0.3 {
            return UIColor.yellow
        } else if (x / y) <= 0.15 {
            return UIColor.red
        } else {
            return UIColor.black
        }
    }
    
    @IBAction func addReminder(_ sender: UIBarButtonItem) {
        
       /* var alertController:UIAlertController = UIAlertController()
        
        textFieldName.delegate = self
        textFieldValue.delegate = self

        alertController = UIAlertController(title: "\n\n\n\n wewe", message: "123123", preferredStyle: .alert)
        let a = alertController.view.frame.width
        
        textFieldName.frame = CGRect(x: 0, y: 5, width: a - 50, height: 30)
        textFieldName.backgroundColor = UIColor.white
        textFieldName.textColor = UIColor.black
        textFieldName.tintColor = UIColor.black
        textFieldName.placeholder = "Название напоминания"
        
        sampleSegment.frame = CGRect(x: 0, y: 45, width: a - 50, height: 30)
        sampleSegment.tintColor = UIColor.black
        sampleSegment.backgroundColor = UIColor.white
        sampleSegment.contentVerticalAlignment = .center
        sampleSegment.insertSegment(withTitle: "Пробег", at: 0, animated: true)
        sampleSegment.insertSegment(withTitle: "Конечная дата", at: 1, animated: true)
        sampleSegment.selectedSegmentIndex = 0
        
        textFieldValue.frame = CGRect(x: 0, y: 85, width: a - 50, height: 30)
        textFieldValue.backgroundColor = UIColor.white
        textFieldValue.textColor = UIColor.black
        textFieldValue.tintColor = UIColor.black
        textFieldValue.placeholder = "тыр тыр"

        alertController.view.addSubview(textFieldName)
        alertController.view.addSubview(sampleSegment)
        alertController.view.addSubview(textFieldValue)
        
        alertController.addAction(UIAlertAction(title: "Добавить", style: UIAlertActionStyle.default, handler: { (action) in
            self.array.append("123")
            self.tableViewReminder.reloadData()
            self.sampleSegment.removeAllSegments()
            //alertController.dismiss(animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "Отмена", style: UIAlertActionStyle.default, handler: { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertController, animated: true, completion: nil)*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let context = appDel.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Reminders")
        do {
            arrayReminders = try context.fetch(request) as! [NSManagedObject]
            tableViewReminder.reloadData()
        } catch {

        }
        print("wefw")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayReminders.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let form = DateFormatter()
        form.dateFormat = "dd.MM.yyyy"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReminder", for: indexPath) as! TableCellForReminders
        //---Получаем каждое напоминание
        let reminder = arrayReminders[indexPath.row]
        //---Считываем название напоминания
        cell.labelName.text = (reminder.value(forKey: "name") as! String)
        //---Считываем дату создания напоминания
        cell.labelRecordDate.text = "Создано: " + (reminder.value(forKey: "recordDate") as! String)
        //---Определяем что считываем: конечную дату или конечный пробег
        if let distance = reminder.value(forKey: "distance") as? Int {
            //---Считываем конечный пробег из напоминания
            let lastWayFromReminder = (reminder.value(forKey: "endDateOrLastWay") as! String)
            if requestGasStation.arrayForGasStations.count != 0 {
                //Считываем пробег из последней заправки
                let lastWay = Double(requestGasStation.arrayForGasStations[0].value(forKey: "way") as! String)
                //---Остаток до окончания введенного расстояния
                let remainderWay = Double(lastWayFromReminder)! - lastWay!
                if remainderWay <= 0 {
                    cell.labelNumber.text = "Пора действовать!!!"
                } else {
                    //---Проверка на целое число
                    if remainderWay - Double(Int(remainderWay)) == 0 {
                        cell.labelNumber.text = "\(Int(remainderWay)) км"
                    } else {
                        cell.labelNumber.text = "\(remainderWay) км"
                    }
                    cell.labelNumber.textColor = textColor(x: remainderWay, y: Double(distance))
                }
            } else {
                cell.labelNumber.text = "неизвестен последний пробег"
            }
            cell.labelDistanceOrDate.text = "Заданное расстояние: \(distance) км"
        } else {
            //---Считываем конечную дату напоминания
            let endDate = form.date(from: reminder.value(forKey: "endDateOrLastWay") as! String)
            //---Вычисляем сколько дней осталось до напоминания
            let currentDate = form.date(from: form.string(from: Date()))
            let remainderDate = Int(((endDate?.timeIntervalSinceReferenceDate)! - (currentDate?.timeIntervalSinceReferenceDate)!) / 86400)
            if remainderDate <= 0 {
                cell.labelNumber.text = "Пора действовать!!!"
            } else {
                //---Проверка дней/дня/день
                var strDay = String()
                if (remainderDate % 100 > 10) && (remainderDate % 100 < 21) {
                    strDay = "дней"
                } else {
                    let value = remainderDate % 10
                    switch value {
                    case 0, 5, 6, 7, 8, 9: strDay = "дней"
                    case 1: strDay = "день"
                    case 2, 3, 4: strDay = "дня"
                    default: break
                    }
                }
                cell.labelNumber.text = "\(remainderDate) " + strDay
                //---Вычисляем сколько дней от начала записи до конца для определения цвета текста
                let beginDate = form.date(from: (reminder.value(forKey: "recordDate") as! String))
                let remainderDateValue = ((endDate?.timeIntervalSinceReferenceDate)! - (beginDate?.timeIntervalSinceReferenceDate)!) / 86400
                cell.labelNumber.textColor = textColor(x: Double(remainderDate), y: remainderDateValue)
            }
            cell.labelDistanceOrDate.text = "Срок окончания: " + form.string(from: endDate!)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
            let context =  appDel.persistentContainer.viewContext
            //---удаление строки в таблице и в хранилище
            context.delete(arrayReminders[indexPath.row])
            arrayReminders.remove(at: indexPath.row)
            //---
            do {
                try context.save()
                tableViewReminder.reloadData()
            } catch {
                
            }
        }
    }
  

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class TableCellForReminders: UITableViewCell {
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelNumber: UILabel!
    @IBOutlet weak var labelRecordDate: UILabel!
    @IBOutlet weak var labelDistanceOrDate: UILabel!
}

