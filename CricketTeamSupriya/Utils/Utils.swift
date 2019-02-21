//
//  Utils.swift
//  CricketTeamSupriya
//
//  Created by Supriya Malgaonkar on 21/02/19.
//  Copyright © 2019 Supriya Malgaonkar. All rights reserved.
//

import UIKit

let BASE_URL = "http://13.233.218.85/api/"

let DEFAULT_CORNER_RADIUS = CGFloat(10)

//MARK: - Helper Functions

func setUserToken(tokenVal: String) {
    UserDefaults.standard.set(tokenVal, forKey: "userToken")
}

func getUserToken() -> String? {
    if let tokenVal = UserDefaults.standard.value(forKey: "userToken") as? String {
        return tokenVal
    }
    return ""
}

func getPlaceholderImage() -> UIImage? {
    return UIImage(named: "placeholder")
}


//MARK: - UI Helpers

open class CustomLoadingView {
    
    static let customLoaderInstance: CustomLoadingView = CustomLoadingView()
    
    private var loaderInstance: UIActivityIndicatorView?
    private var loaderBackInstance: UIView?
    
    func showLoader(onView: UIView, style: UIActivityIndicatorView.Style, loaderColor: UIColor = UIColor.gray, cornerRadius:CGFloat = 0.0, backViewAlpha: CGFloat = 0.6) {
        
        if loaderInstance != nil {
            self.hideLoader()
        }
        
        loaderBackInstance = UIView(frame: CGRect(x: 0, y: 0, width: onView.frame.size.width, height: onView.frame.size.height))
        if(cornerRadius != 0.0){
            loaderBackInstance?.layer.cornerRadius = cornerRadius
        }else{
            loaderBackInstance?.layer.cornerRadius = onView.layer.cornerRadius
        }
        loaderBackInstance?.backgroundColor = UIColor.black.withAlphaComponent(backViewAlpha)
        loaderBackInstance?.isUserInteractionEnabled = false
        onView.addSubview(loaderBackInstance!)
        
        loaderInstance = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        loaderInstance?.style = style
        loaderInstance?.hidesWhenStopped = true
        loaderInstance?.color = loaderColor
        loaderBackInstance!.addSubview(loaderInstance!)
        loaderInstance?.center = loaderBackInstance!.center
        loaderInstance?.startAnimating()
    }
    
    func hideLoader() {
        loaderInstance?.stopAnimating()
        loaderInstance?.removeFromSuperview()
        loaderBackInstance?.removeFromSuperview()
        
        loaderInstance = nil
        loaderBackInstance = nil
    }
    
}

func showAlert(titleVal: String, messageVal: String, withNavController: UINavigationController?, completion: @escaping ((Bool) -> Void)) {
    
    let errorAlert = UIAlertController(title: titleVal, message: messageVal, preferredStyle: UIAlertController.Style.alert)
    let DestructiveAction = UIAlertAction(title: "Ok", style: .destructive) {
        (result : UIAlertAction) -> Void in
        completion(true)
    }
    errorAlert.addAction(DestructiveAction)
    withNavController?.present(errorAlert, animated: true, completion: nil)
}

func getImageURL(fromURLString: String) -> URL? {
    var returnImageURLString = fromURLString
    let escapedString = fromURLString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
    if escapedString != nil {
        returnImageURLString = escapedString!
    }
    
    return URL(string: returnImageURLString)
}
