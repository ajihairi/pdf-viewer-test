//
//  HomeViewController.swift
//  pdf-view-edit-swift
//
//  Created by Hamzhya Salsatinnov Hairy on 06/04/20.
//  Copyright © 2020 Hamzhya Salsatinnov Hairy. All rights reserved.
//

import UIKit
import Foundation

class HomeViewController: BaseView, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    
    var viewModel = HomeViewModel()
    var pdfList = [filesData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.register(HomeCell.reusableNIB(), forCellReuseIdentifier: HomeCell.reusableIndentifier)
        tableview.rowHeight = UITableView.automaticDimension
        tableview.estimatedRowHeight = 100
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupViewModel()
    }
    
    func setupViewModel() {
        
        
        self.viewModel.showAlertClosure = { [weak self] in
            let alert = self?.viewModel.alertMessage ?? ""
            self?.showAlert(alert, completion: {})
        //            self?.showToast(message: alert, font: .systemFont(ofSize: 12))
        }
                
        self.viewModel.updateLoadingStatus = { [weak self] in
            if self?.viewModel.isLoading ?? true {
                self?.showSpinner(onView: self!.view)
            } else {
                self?.removeSpinner()
            }
        }
        self.viewModel.internetConnectionStatus = { [weak self] in
            print("Internet disconnected")
            self?.tableview.reloadData()
        }
        
        self.viewModel.serverErrorStatus = {
            print("Server Error / Unknown Error")
            // show UI Server is Error
        }
        
        self.viewModel.getPDFFiles {
            self.pdfList = self.viewModel.pdfFiles
            self.tableview.reloadData()
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pdfList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeCell.reusableIndentifier, for: indexPath) as! HomeCell
        cell.nameLabel.text = pdfList[indexPath.row].name ?? "-"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let cell = tableView.cellForRow(at: indexPath) as! HomeCell
        self.showSpinner(onView: cell)
        let detil = storyBoard.instantiateViewController(withIdentifier: "PDFViewController") as! PDFViewController
        detil.pdfFile = pdfList[indexPath.row]
        print(detil.pdfFile)
        detil.navigationItem.title = pdfList[indexPath.row].name ?? "-"
        self.navigationController?.pushViewController(detil, animated: true)
    }
    

}
