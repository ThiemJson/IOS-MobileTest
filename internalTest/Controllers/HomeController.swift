//
//  ViewController.swift
//  internalTest
//
//  Created by Teneocto on 05/07/2021.
//

import UIKit
import Combine

class HomeController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeightLayout: NSLayoutConstraint!
    
    var todayScorebats = [ScorebatModel]()
    var nearlyScorebats = [ScorebatModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        ApiManager.shared().sendRequest(with: AppConst.url) { [weak self] completion in
            switch completion {
            case .success(let results):
                for score in results {
                    if score.date.isOnSameDay(with: Date()){
                        self?.todayScorebats.append(score)
                    }
                    else{
                        self?.nearlyScorebats.append(score)
                    }
                }
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.collectionView.reloadData()
                }
                break
            case .failure(let error):
                print("==> \(error.localizedDescription)")
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewSetup()
        self.collectionViewSetup()
    }
    
    deinit {
        self.tableView.removeObserver(self, forKeyPath: "contentSize")
    }
}

// MARK: NearlyScorebats UITableView Delegate, Datasource
extension HomeController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nearlyScorebats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = self.tableView.dequeueReusableCell(withIdentifier: ScorebatNearlyCell.identifier, for: indexPath) as! ScorebatNearlyCell
        
        if self.nearlyScorebats.count == 0 { return tableCell }
        
        tableCell.scorebat = self.nearlyScorebats[indexPath.row]
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        
        if let obj = object as? UITableView,
           obj == self.tableView &&
            keyPath == "contentSize" {
            self.tableHeightLayout.constant = tableView.contentSize.height
        }
    }
    
    private func tableViewSetup(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: ScorebatNearlyCell.identifier, bundle: nil), forCellReuseIdentifier: ScorebatNearlyCell.identifier)
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.tableView.isScrollEnabled = false
        
    }
}

// MARK: TodayScorebats UICollectionView Delegate, Datasource
extension HomeController : UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.todayScorebats.count
    }
    
    private func collectionViewSetup(){
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.register(UINib(nibName: ScorebatTodayCell.identifier, bundle: nil), forCellWithReuseIdentifier: ScorebatTodayCell.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: ScorebatTodayCell.identifier, for: indexPath) as! ScorebatTodayCell
        
        if self.todayScorebats.count == 0 { return collectionCell }
        
        collectionCell.scorebat = self.todayScorebats[indexPath.row]
        return collectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.deselectItem(at: indexPath, animated: true)
    }
}
