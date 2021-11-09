//
//  ViewController.swift
//  Http Session
//
//  Created by Evgeniy Goncharov on 27.10.2021.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var discriptin: UITextView!
    
    @IBOutlet weak var rightButtom: UIBarButtonItem!
    @IBOutlet weak var leftButtom: UIBarButtonItem!
    
    // MARK: - Properties
    var date = Date()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        rightButtom.isEnabled = false
        loadReguest(date: date)
        
        
    }
    
    // MARK: - Private Methods
    private func loadReguest(date: Date) {
        let baseURL = URL(string: "https://api.nasa.gov/planetary/apod")!
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        formater.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
        let stringDate = formater.string(from: date)

        
        
        let query = [
            "api_key": "RGmX0iSCmnya8QumYKAgIhef0rIek3ZYY5eDPcI2",
            "hd": "true",
            "thumbs": "true",
            "date": formater.string(from: date),
        ]
        
        self.navigationItem.title = "Loading for \(stringDate)"
        
        let url = baseURL.withQueries(query)!
        let task = URLSession.shared.dataTask(with: url) { data, response , error in
            guard let data = data else {
                print(#line, #function, error?.localizedDescription ?? "no Description")
                return
            }
            
            
            let decoder = JSONDecoder()
            
            // Try to decode data from model
            guard let photoInfo = try? decoder.decode(PhotoInfo.self, from: data) else {
                
                // Get string decode as UTF8 from data
                guard let stringData = String(data: data, encoding: .utf8) else {
                    print(#function, #line, "Eror: can't decode \(data) as UTF8")
                    return
                }
                
                print(#line, #function, "Error: can't decode date from \(stringData)")
                return
                
            }
            
            // Clear old image
            OperationQueue.main.addOperation {
                self.imageView.image = nil
                
            }
            // Load new image
            URLSession.shared.dataTask(with: photoInfo.url) {imageData, _, _ in
                guard let imageData = imageData else { return }
                OperationQueue.main.addOperation {
                    self.imageView.image = UIImage(data: imageData)
                }
            }.resume()
            
            // Loading base information
            DispatchQueue.main.async {
                self.discriptin.text = photoInfo.description
                self.discriptin.isSelectable = false
                self.discriptin.font = UIFont.systemFont(ofSize: 17)
                self.navigationItem.title = photoInfo.title
            }
            
            //            OperationQueue.main.addOperation {
            //                self.descriptin.text = photoInfo.description
            //                self.navigationItem.title = photoInfo.title
            //            }
            
            //print(photoInfo)
        }
        task.resume()
    }
    
    @IBAction func ButtonPressed(_ sender: UIBarButtonItem) {
        let secondsInDare = TimeInterval(24 * 60 * 60)
        switch sender {
        case leftButtom:
            print(#line, #function, "Left button pressed")
            date = date.addingTimeInterval(-secondsInDare)
            loadReguest(date: date)
            rightButtom.isEnabled = true
            
            
        case rightButtom:
            let tommorow = date.addingTimeInterval(secondsInDare)
            let afterTommorow = tommorow.addingTimeInterval(secondsInDare)
            
            rightButtom.isEnabled = afterTommorow <= Date()
            guard tommorow <= Date() else { return }
            date = tommorow
            
            print(#line, #function, "Right button pressed")
            
        default:
            print(#line, #function, "Unknown pressed")
            return
        }
        loadReguest(date: date)
    }
    
}

