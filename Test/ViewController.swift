//
//  ViewController.swift
//  Test
//
//  Created by Pankaj on 03/12/19.
//  Copyright © 2019 Pankaj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var dataTable: UITableView!

    var productArr = [Product]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            WebApiClient.shared.getData(period: "7") { [weak self] (result) in
                guard let data = result else { return }
                self?.productArr = data
                self?.dataTable.reloadData()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    
}



extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ProductTableCell
        cell.product = productArr[indexPath.row]
        cell.refreshCellData()
        return cell
    }
    
    
}






class ProductTableCell: UITableViewCell {
    @IBOutlet var productName: UILabel!
    @IBOutlet var byLabel: UILabel!
    @IBOutlet var dateTime: UILabel!

    var product : Product!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    // refresh cell data
    func refreshCellData(){
        productName.text = product.title
        byLabel.text = product.byline
        dateTime.text = product.published_date
    }
}
