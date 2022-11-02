//
//  UpcomingViewController.swift
//  Netflix
//
//  Created by Vladislavs on 29/10/2022.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    private var titles: [Title] = [Title]()

    private let upcomingTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        upcomingTableView.frame = view.bounds
    }
    
    func setupViews() {
        title = "Upcoming"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(upcomingTableView)
                
        upcomingTableView.delegate = self
        upcomingTableView.dataSource = self
        
        fetchData()
    }
    
    private func fetchData() {
        APICaller.shared.getUpcomingMovies() { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.upcomingTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension UpcomingViewController: UITableViewDelegate {
    
}

extension UpcomingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell {
            
            let title = titles[indexPath.row]
            
            cell.configure(with: TitleViewModel(titleName: title.original_title ?? title.original_name ?? "Uknown", posterURL: title.poster_path ?? ""))
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
