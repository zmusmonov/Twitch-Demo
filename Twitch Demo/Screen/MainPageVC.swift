//
//  MainPageVC.swift
//  Twitch Demo
//
//  Created by ZiyoMukhammad Usmonov on 11/5/20.
//

import UIKit
import Network

class MainPageVC: UIViewController {

    let cellID = "CityCell"
    let tableView = UITableView()
    
    var games = [TopGames]()
    var totalEntries = 0
    var offset = 0
    
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureVC()
        configureTableView()
        fetchGames()
        getTopGamesLocally()
        pullRefresh()
    }
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        title = "Top Streamings"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureTableView() {
        tableView.register(TopGamesCell.self, forCellReuseIdentifier: cellID)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 84
        tableView.separatorStyle = .none
        view.addsubViews(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func fetchGames() {
        switch NetworkMonitor.shared.isReachable {
        case false:
            getTopGamesFromRemoteServer()
        case true:
            getTopGamesLocally()
        }
    }
    
    func getTopGamesLocally() {
        PersistanceManager.retrieveTopGames { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let games):
                self.updateUI(with: games)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func updateUI(with games: [TopGames]) {
        if games.isEmpty {
            print("No data")
        } else  {
            self.games = games
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.view.bringSubviewToFront(self.tableView)
            }
        }
    }
    
    func getTopGamesFromRemoteServer() {
        NetworkManager.shared.getTopGames(page: offset) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let response):
                self.totalEntries = response.total
                self.games += response.top
                PersistanceManager.save(games: self.games)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                self.offset += 10
            }
        }
    }
    
    func pullRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl) // n
    }
    
    @objc func refresh(_ sender: AnyObject) {
       fetchGames()
    }
}

extension MainPageVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! TopGamesCell
        let game = games[indexPath.row]
        cell.topGame = game
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == games.count - 1 {
            if games.count < totalEntries {
                getTopGamesFromRemoteServer()
            }
        }
    }
}
