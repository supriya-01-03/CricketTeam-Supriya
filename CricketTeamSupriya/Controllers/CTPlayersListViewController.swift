//
//  CTPlayersListViewController.swift
//  CricketTeamSupriya
//
//  Created by Supriya Malgaonkar on 21/02/19.
//  Copyright © 2019 Supriya Malgaonkar. All rights reserved.
//

import UIKit
import SwiftyJSON

class CTPlayersListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate, CTActionPerformDelgate {
    
    @IBOutlet weak var listCollectionViewView: UICollectionView!
    @IBOutlet weak var filterTableView: UITableView!
    @IBOutlet weak var filterBackView: UIView!
    
    
    private var dataArray: [JSON] = []
    private var filterList: JSON = []
    
    private let filterKeys = ["categories", "buildings", "skills", "team_status"]
    
    private var filteredCategories: [String] = []
    private var filteredSkills: [String] = []
    private var filteredBuildings: [String] = []
    private var selectedTeamStatus: String = ""
    private var isLoading = false
    private var isShowingFilter = false
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.hidesBackButton = true
        self.title = "Select player for details"
        
        self.filterTableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        
        self.getPlayers()
        self.getFilters()
        
        self.setNavigation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    
    //MARK: - Server Call
    
    private func getPlayers() {
        self.isLoading = true
        self.listCollectionViewView.reloadData()
        
        CTRequestManager.getSharedManager().getAllPlayers { (response) in
            self.isLoading = false
            if response["success"].boolValue {
                self.updateDatabase(withValues: response["data"]["players"].arrayValue)
            }
            else {
                showAlert(titleVal: "Error", messageVal: "Something went wrong. Please try after sometime.", withNavController: self.navigationController, completion: { (_) in
                })
            }
            self.listCollectionViewView.reloadData()
        }
    }
    
    private func getFilters() {
        CTRequestManager.getSharedManager().getFilters { (response) in
            if response["success"].boolValue {
                self.filterList = response["data"]
                self.filterTableView.reloadData()
            }
        }
    }
    
    
    //MARK: - Update DB
    
    private func updateDatabase(withValues: [JSON]) {
        Player.savePlayers(details: withValues) { (isComplete) in
            self.showAllPlayers()
        }
    }
    
    private func showAllPlayers() {
        Player.getAllPlayers(completion: { (listPlayers) in
            DispatchQueue.main.async(execute: {
                self.dataArray = listPlayers
                self.listCollectionViewView.reloadData()
            })
        })
    }
    
    
    //MARK: - CollectionView Datasource & Delegates
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count + (isLoading ? 1 : 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row < dataArray.count {
            return CGSize(width: collectionView.frame.width/3, height: (((UIScreen.main.bounds.width-16)/3)*0.5 + 60))
        }
        else {
            return collectionView.frame.size
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < dataArray.count {
            let playerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "playerCell", for: indexPath) as! CTPlayerListCollectionViewCell
            playerCell.setData(detailData: dataArray[indexPath.row])
            return playerCell
        }
        else {
            let loadingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "loadingCell", for: indexPath) as! CTLoadingCollectionViewCell
            return loadingCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < dataArray.count {
            let selectedData = dataArray[indexPath.item]
            let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "playerDetailView") as! CTPlayerDetailViewController
            detailVC.detailJSON = selectedData
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    
    //MARK: - Tableview Datasource & Delegates
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (filterList.isEmpty ? 0 : 5)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section < filterKeys.count {
            return 20
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < filterKeys.count {
            return filterKeys[section].capitalized
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < filterKeys.count {
            return filterList[filterKeys[section]].arrayValue.count
        }
        return 1
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section < filterKeys.count {
//            return 44.0
//        }
//        return 60.0
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section < filterKeys.count {
            let cellData = filterList[filterKeys[indexPath.section]].arrayValue[indexPath.row]
            let filterCell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath) as! CTFilterTableviewCell
            filterCell.setData(filterName: cellData["name"].stringValue, isSelected: isFilterSelected(filterValue: cellData["id"].stringValue, fromSection: indexPath.section))
            return filterCell
        }
        else {
            let actionCell = tableView.dequeueReusableCell(withIdentifier: "actionCell", for: indexPath) as! CTActionTableviewCell
            actionCell.setDelegate(delegate: self)
            return actionCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedCellData = filterList[filterKeys[indexPath.section]].arrayValue[indexPath.row]
        
        self.toggleFilterSelection(filterData: selectedCellData, fromSection: indexPath.section)
        if indexPath.section == 3 {
            tableView.reloadSections(IndexSet([3]), with: .automatic)
        }
        else {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    //MARK: - Action Delegates
    
    func applyFilters() {
        CTRequestManager.getSharedManager().getAllPlayers(categoryF: filteredCategories.joined(separator: ","), skillF: filteredSkills.joined(separator: ","), buildingF: filteredBuildings.joined(separator: ","), team_statusF: selectedTeamStatus) { (response) in
            
            if response["success"].boolValue {
                self.dataArray = response["data"]["players"].arrayValue
            }
            
            self.toggleFilterView(nil)
            self.listCollectionViewView.reloadData()
        }
    }
    
    func clearFilters() {
        self.clearSelectedFilterData()
        self.showAllPlayers()
    }
    
    func clearSelectedFilterData() {
        self.filteredCategories = []
        self.filteredSkills = []
        self.filteredBuildings = []
        self.selectedTeamStatus = ""
        self.filterTableView.reloadData()
    }
    
    
    //MARK: - Helper Function
    
    @objc private func toggleFilterView(_ sender: UIButton?) {
        
        print("\n toggleFilterView called")
        
        self.isShowingFilter = !isShowingFilter
        
        if self.isShowingFilter {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
                self.filterBackView.alpha = 1
                self.filterTableView.frame = CGRect(x: (self.view.frame.width - self.filterTableView.frame.width), y: self.filterTableView.frame.origin.y, width: self.filterTableView.frame.width, height: self.filterTableView.frame.height)
            }) { (_) in
                self.filterTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
        }
        else {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
                self.filterBackView.alpha = 0
                self.filterTableView.frame = CGRect(x: (self.view.frame.width), y: self.filterTableView.frame.origin.y, width: self.filterTableView.frame.width, height: self.filterTableView.frame.height)
            }) { (_) in
            }
        }
        
    }
    
    private func isFilterSelected(filterValue: String, fromSection: Int) -> Bool {
        if ((fromSection == 0) && (filteredCategories.contains(filterValue))) {
            return true
        }
        else if ((fromSection == 1) && (filteredBuildings.contains(filterValue))) {
            return true
        }
        else if ((fromSection == 2) && (filteredSkills.contains(filterValue))) {
            return true
        }
        else if ((fromSection == 3) && (selectedTeamStatus == filterValue)) {
            return true
        }
        return false
    }
    
    private func toggleFilterSelection(filterData: JSON, fromSection: Int) {
        if fromSection == 0 {
            if filteredCategories.contains(filterData["id"].stringValue) {
                filteredCategories = filteredCategories.filter(){$0 != filterData["id"].stringValue}
            }
            else {
                filteredCategories.append(filterData["id"].stringValue)
            }
        }
        else if fromSection == 1 {
            if filteredBuildings.contains(filterData["id"].stringValue) {
                filteredBuildings = filteredBuildings.filter(){$0 != filterData["id"].stringValue}
            }
            else {
                filteredBuildings.append(filterData["id"].stringValue)
            }
        }
        else if fromSection == 2 {
            if filteredSkills.contains(filterData["id"].stringValue) {
                filteredSkills = filteredSkills.filter(){$0 != filterData["id"].stringValue}
            }
            else {
                filteredSkills.append(filterData["id"].stringValue)
            }
        }
        else if fromSection == 3 {
            if selectedTeamStatus == filterData["id"].stringValue {
                selectedTeamStatus = ""
            }
            else {
                selectedTeamStatus = filterData["id"].stringValue
            }
        }
    }
    
    private func setNavigation() {
        
        let rightButton = UIButton()
        rightButton.frame = CGRect(x: 0, y: 10, width: 25, height: 25)
        rightButton.setImage(UIImage(named: "filterIcon"), for: .normal)
        rightButton.imageView?.contentMode = .scaleAspectFit
        rightButton.imageView?.clipsToBounds = true
        rightButton.addTarget(self, action: #selector(self.toggleFilterView(_:)), for: .touchUpInside)
        let widthConstraint = rightButton.widthAnchor.constraint(equalToConstant: rightButton.frame.width)
        let heightConstraint = rightButton.heightAnchor.constraint(equalToConstant: rightButton.frame.height)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    
    
}
