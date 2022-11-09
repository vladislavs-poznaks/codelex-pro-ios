//
//  DownloadsViewController.swift
//  Netflix
//
//  Created by Vladislavs on 29/10/2022.
//

import UIKit

class DownloadsViewController: UIViewController {
    
    private var titles: [TitleItem] = [TitleItem]()
    
    private let downloadsTableView: UITableView = {
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
        
        downloadsTableView.frame = view.bounds
    }
    
    func setupViews() {
        title = "Downloads"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(downloadsTableView)
        
        downloadsTableView.delegate = self
        downloadsTableView.dataSource = self
        
        navigationController?.navigationBar.tintColor = .white
        
        fetchData()
    }
    
    private func fetchData() {
        DataPersistanceManager.shared.fetchTitlesFromDatabase {[weak self] result in
            switch result {
            case .success(let titltes):
                self?.titles = titltes
                self?.downloadsTableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension DownloadsViewController: UITableViewDelegate {
    
}

extension DownloadsViewController: UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        
        guard let titleName = title.original_title ?? title.original_name else {return}
        
        APICaller.shared.getMovie(with: "\(titleName) trailer") { [weak self] result in
            switch result {
            case .success(let result):
                
                let title = self?.titles[indexPath.row]
                
                guard let titleName = title?.original_title ?? title?.original_name else {return}
                guard let titleOverview = title?.overview else {return}
                                
                let viewModel = TitlePreviewViewModel(title: titleName, overview: titleOverview, youtubeVideo: result.id)
                
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: viewModel)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DataPersistanceManager.shared.deleteTitleWith(title: titles[indexPath.row]) {[weak self] result in
                switch result {
                case .success():
                    print("Successfully deleted")
                    self?.titles.remove(at: indexPath.row)
                    tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            break;
        }
    }
}
