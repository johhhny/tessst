//
//  TableViewControllerForGasStation.swift
//  iZapravka
//
//  Created by user on 28.01.17.
//  Copyright © 2017 Johhhny. All rights reserved.
//

import UIKit
import CoreData

class TableViewControllerForGasStation: SingleClass, UITableViewDelegate, UITableViewDataSource {
    
    //---Таблица заправок
    @IBOutlet var tableGasStations: UITableView!
    //---Кнопка, в которой оображается кол-во заправок. В навигаторБар
    @IBOutlet weak var quantityGasStation: UIButton!
    
    //---Функция для делегирования и создания контекста
    func createDelegContex() -> (NSManagedObjectContext) {
        let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        return appDel.persistentContainer.viewContext
    }
    
    //---показать что появится
    override func viewWillAppear(_ animated: Bool) {
        requestGasStation.arrayForGasStations = loadBD
        //arrayForGasStations = loadBD
        tableGasStations.reloadData()
        quantityGasStation.setTitle("Заправки: \(requestGasStation.arrayForGasStations.count)", for: .normal)

    }
    
    // MARK: - Заполнение таблицы заправок
    
    //---Определяем кол-во строк в таблице
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestGasStation.arrayForGasStations.count
    }
    //---Заполняем каждую строку в таблице
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //---присваиваем cell отдельный тип со свойствами
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCellForGasStation
        //---берем текущий индекс строки/массива
        let gasStation = requestGasStation.arrayForGasStations[indexPath.row]
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        let a = formatter.string(from: gasStation.value(forKey: "date") as! Date)
        
        //---заполнение каждой строки в соотвествии с текущим индексом
        cell.dateLabel.text = a
        cell.literLabel.text = "Заправка: " + (gasStation.value(forKey: "liter") as! String) + " л."
        cell.priceLabel.text = "Стоимость: " + (gasStation.value(forKey: "price") as! String) + " руб."
        cell.wayLabel.text = "Пробег: " + (gasStation.value(forKey: "way") as! String)
        
        //---Проверка след. строки относительно текущей на уменьшение пробега
            if requestGasStation.arrayForGasStations.count > indexPath.row + 1 {
                if Float((requestGasStation.arrayForGasStations[indexPath.row].value(forKey: "way") as! String))! < Float((requestGasStation.arrayForGasStations[indexPath.row + 1].value(forKey: "way") as! String))! {
                    cell.wayLabel.textColor = UIColor.red
                }
            }
        //---
        
        return cell
    }
 
    // Действия при редактировании и удалении строки
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = createDelegContex()
            //---удаление строки в таблице и в хранилище
                context.delete(requestGasStation.arrayForGasStations[indexPath.row])
                requestGasStation.arrayForGasStations.remove(at: indexPath.row)
            //---
            do {
                try context.save()
                tableView.reloadData()
                quantityGasStation.setTitle("Заправки: \(requestGasStation.arrayForGasStations.count)", for: .normal)
            } catch {
            
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "tabBarController")
            self.present(vc, animated: false, completion: nil)
        }
    }
    //---действие при выборе строки в таблице (открываем окно для редактирования)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //---Записываем данные этой строки в константу
        let gasStation = requestGasStation.arrayForGasStations[indexPath.row]
        //---Создаем экземпляр класса AddAndEditRowViewController(создание и редактирование заправок)
        let itemViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddAndSaveViewCont") as! AddAndEditRowViewController
        //---Заполняем переменные в этом классе данными из выбранной строки
        itemViewController.strForLiter = (gasStation.value(forKey: "liter") as! String)
        itemViewController.strForPrice = (gasStation.value(forKey: "price") as! String)
        itemViewController.strForWay = (gasStation.value(forKey: "way") as! String)
        itemViewController.currentDate = (gasStation.value(forKey: "date") as! Date)
        itemViewController.indexRow = indexPath.row
        itemViewController.buttonTitleSave = true
        //Создаем пустой НавигаторБар и открываем ViewController класса AddAndEditRowViewController
        let navigationController = UINavigationController(rootViewController: itemViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
}
