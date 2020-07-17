//
//  ViewController.swift
//  BBJobTestTask
//
//  Created by Maksym Sabadyshyn on 7/16/20.
//  Copyright © 2020 Maksym Sabadyshyn. All rights reserved.
//

import UIKit
import Network

class ViewController: UIViewController {

    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var sortButton: UIButton!
    private var users = [User]()
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "InternetAvailabilityMonitor")
    private var sortInAlphabeticalOrder = true
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        populateTable()
        configureMonitor()
        configureRefresh()
        usersTableView.dataSource = self
        usersTableView.delegate = self
    }

    @IBAction func sortButtonPressed(_ sender: UIButton) {
        if sortInAlphabeticalOrder {
            users = users.sorted {
                return $0.firstName < $1.firstName
            }
        } else {
            users = users.sorted {
                return $0.firstName > $1.firstName
            }
        }

        sortInAlphabeticalOrder = !sortInAlphabeticalOrder
        usersTableView.reloadData()
    }

    @objc func refreshAfterPullDown(_ refreshControl: UIRefreshControl){
        ImageProcessor.deleteAll()
        populateTable()
        refreshControl.endRefreshing()
    }

    func configureRefresh() {
        usersTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action:
            #selector(refreshAfterPullDown(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.red
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

    func configureMonitor() {
        monitor.pathUpdateHandler = { pathUpdateHandler in
            if pathUpdateHandler.status == .unsatisfied {

                //show alert if there is no internet connection on the phone.
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "No Internet Connection", message: "Please, connect to Internet to use latest data", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }

        }
        monitor.start(queue: queue)
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        usersTableView.deselectRow(at: indexPath, animated: true)

        let detailedInfoViewController = self.storyboard!.instantiateViewController(withIdentifier: "DetailedInfoVC") as! DetailedInfoViewController

        let image = (tableView.cellForRow(at: indexPath) as! UserCell).avatarImageView.image

        detailedInfoViewController.user = users[indexPath.row]
        if let image = image {
            detailedInfoViewController.userImage = image
        }

        self.present(detailedInfoViewController, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ImageProcessor.deleteFromCache(by: users[indexPath.row].avatar)
            users.remove(at: indexPath.row)
            tableView.deleteRows(at: [(indexPath as IndexPath)], with: .fade)
        }
    }
}

