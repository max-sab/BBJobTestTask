//
//  ViewController.swift
//  BBJobTestTask
//
//  Created by Maksym Sabadyshyn on 7/16/20.
//  Copyright © 2020 Maksym Sabadyshyn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var usersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NetworkRequest.getData(from: API.link, completion: {
            data, error in

            if let error = error {
                var titleString = ""
                var messageString = ""
                switch error {
                case .invalidURL:
                    titleString = "Invalid URL"
                    messageString = "Unable to get data"
                case .receivedInvalidData:
                    titleString = "Invalid data"
                    messageString = "Unable to decode data"
                }

                let errorAlert = UIAlertController(title: titleString , message: messageString, preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(errorAlert, animated: true)
                
            } else {

                if let data = data {
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                    let result = try? jsonDecoder.decode(User.self, from: data)
                }
            }


            //self.persons = res.people
            //reloading table in main thread
            DispatchQueue.main.async {
                self.usersTableView.reloadData()
            }



        })
    }


}

