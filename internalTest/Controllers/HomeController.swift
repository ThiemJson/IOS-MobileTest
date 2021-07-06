//
//  ViewController.swift
//  internalTest
//
//  Created by Teneocto on 05/07/2021.
//

import UIKit
import Combine

class HomeController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeightLayout: NSLayoutConstraint!
    
    var todayScorebats = [ScorebatModel]()
    var nearlyScorebats = [ScorebatModel]()
    var selectedScorebat : ScorebatModel?
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewSetup()
        self.collectionViewSetup()
        self.performRequest()
        
        self.refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        self.scrollView.addSubview(refreshControl)
        self.scrollView.alwaysBounceVertical = true
        self.scrollView.delegate = self
        
        self.title = "Scorebat"
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = -40.0
        if scrollView.contentOffset.y < CGFloat(defaultOffset) {return}
        
        let alpha = max(0, 1 - (abs(CGFloat(defaultOffset) - scrollView.contentOffset.y) / (self.collectionView.frame.size.height)))
        
        self.collectionView.alpha = alpha
    }
    
    deinit {
        self.tableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    private func showErrorAlert(){
        let alertController = UIAlertController(title: "This pages could not loaded", message: "Please check your internet connection and try again", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Reload", style: .default) {
            [weak self] (alert: UIAlertAction!) in
            self?.performRequest()
        }
        
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil )
    }
    @objc private func refresh(){
        self.performRequest()
    }
    
    private func performRequest(){
        ApiManager.shared().sendRequest(with: AppConst.url) { [weak self] completion in
            self?.todayScorebats = []
            self?.nearlyScorebats = []
            
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
                    self?.refreshControl.endRefreshing()
                }
                
                break
            case .failure(let error):
                print("==> \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.showErrorAlert()
                    self?.refreshControl.endRefreshing()
                }
                break
            }
        }
    }
}

// MARK: NearlyScorebats UITableView Delegate, Datasource
extension HomeController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nearlyScorebats.count == 0 ? 5 : self.nearlyScorebats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = self.tableView.dequeueReusableCell(withIdentifier: ScorebatNearlyCell.identifier, for: indexPath) as! ScorebatNearlyCell
        
        if self.nearlyScorebats.count == 0 { return tableCell }
        
        tableCell.scorebat = self.nearlyScorebats[indexPath.row]
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedScorebat = self.nearlyScorebats[indexPath.row]
        performSegue(withIdentifier: AppConst.Segue.goToDetail, sender: self)
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
        return self.todayScorebats.count == 0 ? 5 : self.todayScorebats.count
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
        self.selectedScorebat = self.todayScorebats[indexPath.row]
        performSegue(withIdentifier: AppConst.Segue.goToDetail, sender: self)
        self.collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: Segue
extension HomeController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == AppConst.Segue.goToDetail {
            let detailVC = segue.destination as! DetailController
            detailVC.scorebat = self.selectedScorebat!
        }
    }
}
