//
//  MainViewController.swift
//  ADemo
//
//  Created by Dalibor Kozak on 28/10/2019.
//  Copyright © 2019 Dalibor Kozak. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController, UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    let refresh = UIRefreshControl()
    
    var categoryData = [Category]()
    var productData = [Product]()
    
    var category: Category?
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView.refreshControl = refresh
        
        title = category?.name ?? "Kategorie"
        
        activityIndicator.startAnimating()
        loadData()
    }
    
    @objc  func loadData() {
        if let id = category?.id {
            DataProvider.shared.requestData(for: .product(id))
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { (wrapper: ProductWrapper) in
                    self.productData = wrapper.data
                }, onError: { (error) in
                    self.notifyUser(title: "Error", message: error.localizedDescription)
                }, onCompleted: {
                    self.refreshTable()
                })
                .disposed(by: bag)
            
        } else {
            DataProvider.shared.requestData(for: .category)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { (wrapper: CategoryWrapper) in
                    self.categoryData = wrapper.data
                }, onError: { (error) in
                    self.notifyUser(title: "Error", message: error.localizedDescription)},
                   onCompleted: {
                    self.refreshTable()
                })
                .disposed(by: bag)
        }
    }
    
    func refreshTable() {
        self.activityIndicator.stopAnimating()
        self.refresh.endRefreshing()
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category == nil ? categoryData.count : productData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item: Descriptive = category == nil ? categoryData[indexPath.row] : productData[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId, for: indexPath) as? ProductTableViewCell,
            let url = item.img,
            let data = try? Data(contentsOf: url) {
            cell.descriptionLabel.text = item.name
            cell.iconView.image = UIImage(data: data)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if category == nil {
            if let vc = storyboard?.instantiateViewController(withIdentifier: Constants.mainVcId) as? MainViewController {
                vc.category = categoryData[indexPath.row]
                self.category = nil
                navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            if let vc = storyboard?.instantiateViewController(withIdentifier: Constants.detailVcId) as? DetailViewController{
                vc.product = productData[indexPath.row]
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension UIViewController {
    func notifyUser(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}
