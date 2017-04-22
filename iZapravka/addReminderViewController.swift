//
//  addReminderViewController.swift
//  iZapravka
//
//  Created by user on 17.02.17.
//  Copyright © 2017 Johhhny. All rights reserved.
//

import UIKit
import CoreData

class addReminderViewController: UIViewController {

    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldValue: UITextField!
    @IBOutlet weak var segmControl: UISegmentedControl!
    @IBOutlet weak var doneImage: UIImageView!
    @IBOutlet weak var buttomAdd: UIButton!
    
    let datePicker = UIDatePicker()
    var strWay = String()
    
    @IBAction func changeSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            textFieldValue.placeholder = strWay
            textFieldValue.keyboardType = .numberPad
            textFieldValue.inputView = nil
            textFieldValue.text = nil
            textFieldValue.endEditing(true)
        } else if sender.selectedSegmentIndex == 1 {
            datePicker.datePickerMode = .date
            datePicker.minimumDate = Date()
            textFieldValue.placeholder = "Выберете дату"
            textFieldValue.inputView = datePicker
            textFieldValue.text = nil
            textFieldValue.endEditing(true)
        }
    }
    
    
    @IBAction func saveValueInTextFieldValue(_ sender: UITextField) {
        if segmControl.selectedSegmentIndex == 1 {
            let form = DateFormatter()
            form.dateFormat = "dd.MM.yyyy"
            textFieldValue.text = form.string(from: datePicker.date)
        }
    }
    
    //Убирать клавиатуру при нажатии на пустое поле
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //---
    //Убирать клавиатуру при нажатии на кнопку Return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func createReminder(_ sender: UIButton) {
        if textFieldName.text != "" && textFieldValue.text != "" {
            if requestGasStation.arrayForGasStations.count != 0 || segmControl.selectedSegmentIndex == 1 {
                //---Подготавливаем к записи дату создания напоминания
                let currentDate : String
                let form = DateFormatter()
                form.dateFormat = "dd.MM.yyyy"
                currentDate = form.string(from: Date())
                //---Проверка создания даты или расстояния
                let reminderWayAndDate: String
                var currentDistance: Int?
                if let wayInt = Int(textFieldValue.text!) {
                    //---Подготавливаем к записи введенное расстояние
                    currentDistance = wayInt
                    //---Подготавливаем к записи конечный пробег и вычисляем его
                    let lastWay = requestGasStation.arrayForGasStations[0].value(forKey: "way") as! String
                    reminderWayAndDate = String((Int(lastWay)! + wayInt))
                } else {
                    //---Подготавливаем к записи конечную дату
                    reminderWayAndDate = textFieldValue.text!
                }
                
                let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
                let context = appDel.persistentContainer.viewContext
                let newRow = NSEntityDescription.insertNewObject(forEntityName: "Reminders", into: context)
                //---Записываем название напоминания
                newRow.setValue(textFieldName.text, forKey: "name")
                //---Записываем дату создания напоминания
                newRow.setValue(currentDate, forKey: "recordDate")
                //---Записываем конечную дату или конечный пробег
                newRow.setValue(reminderWayAndDate, forKey: "endDateOrLastWay")
                //---Записываем расстояние (может быть nil)
                newRow.setValue(currentDistance, forKey: "distance")
                do {
                    try context.save()
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
                doneImage.isHidden = false
                buttomAdd.isEnabled = false
                buttomAdd.setTitleColor(.gray, for: .normal)
            } else {
                print("Создать алерт1")
            }
        } else {
            print("Создать алерт2")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if requestGasStation.arrayForGasStations.count != 0 {
            strWay = "Последний пробег: \(requestGasStation.arrayForGasStations[0].value(forKey: "way")!)"
        } else {
            strWay = "Нет информации о пробеге"
        }
        textFieldValue.placeholder = strWay
        buttomAdd.isEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldValue.keyboardType = .numberPad
        doneImage.isHidden = true
        buttomAdd.layer.masksToBounds = true
        buttomAdd.layer.cornerRadius = 12
        // Do any additional setup after loading the view.
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
