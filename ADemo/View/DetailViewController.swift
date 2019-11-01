//
//  DetailViewController.swift
//  ADemo
//
//  Created by Dalibor Kozak on 28/10/2019.
//  Copyright © 2019 Dalibor Kozak. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailOneLabel: UILabel!
    @IBOutlet weak var detailTwoLabel: UILabel!
    @IBOutlet weak var detailThreeLabel: UILabel!
    
    let bag = DisposeBag()
    var product: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let product = product, let id = product.id {
            title = product.name
            loadData(id: id)
        }
    }
    
    func loadData(id: Int) {
        DataProvider.shared.requestData(for: .detail(id))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (wrapper: DetailWrapper) in
                self.updateUI(product: wrapper.data)
            }, onError: { (error) in
                self.notifyUser(title: "Error", message: error.localizedDescription)
            })
            .disposed(by: bag)
    }
    
    func updateUI(product: ProductDetail) {
        if let url = product.imgs.first?.big_url,
            let data = try? Data(contentsOf: url) {
            detailImageView.image = UIImage(data: data)
        }
        
        detailOneLabel.text = product.name
        detailTwoLabel.text = product.price
        detailThreeLabel.text = product.spec
    }
}
