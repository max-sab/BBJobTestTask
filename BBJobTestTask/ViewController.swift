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

    private var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateTable()
        usersTableView.dataSource = self
        usersTableView.delegate = self
    }

    private func populateTable() {
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
                    let result = try? jsonDecoder.decode(UserWrapper.self, from: data)
                    if let result = result {
                        self.users = result.users
                        DispatchQueue.main.async {
                            self.usersTableView.reloadData()
                        }
                    }
                }
            }
        })
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userForCell = users[indexPath.row]

        let cell = usersTableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell

        cell.setUser(userForCell)

        return cell
    }
}

