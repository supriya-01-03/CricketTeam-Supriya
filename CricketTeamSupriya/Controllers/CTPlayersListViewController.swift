//
//  CTPlayersListViewController.swift
//  CricketTeamSupriya
//
//  Created by Supriya Malgaonkar on 21/02/19.
//  Copyright © 2019 Supriya Malgaonkar. All rights reserved.
//

import UIKit
import SwiftyJSON

class CTPlayersListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var listCollectionViewView: UICollectionView!
    
    
    private var dataArray: [JSON] = []
    private var isLoading = false
    
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Select player for details"
        self.getPlayers()
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
                self.dataArray = response["data"]["players"].arrayValue
            }
            else {
                showAlert(titleVal: "Error", messageVal: "Something went wrong. Please try after sometime.", withNavController: self.navigationController, completion: { (_) in
                })
            }
            self.listCollectionViewView.reloadData()
        }
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
            return CGSize(width: collectionView.frame.width/3, height: collectionView.frame.width/3)
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

}
