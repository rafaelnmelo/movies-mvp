//
//  BaseViewController.swift
//  Movies
//
//  Created by Rafael Melo on 12/04/23.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: Navigation Bar
    
    var showNavBar: Bool = true {
        didSet {
            if self.showNavBar {
                self.showNavigationBar()
            } else {
                self.hideNavigationBar()
            }
        }
    }
    
    func hideNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func showNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func showBackButtonTitle() {
        self.navigationController?.navigationBar.topItem?.backBarButtonItem?.title = "Voltar"
    }
    
    //MARK: Alert
    
    func getAlert(title: String, message: String) -> UIAlertController {
        return UIAlertController(title: title,
                                 message: message,
                                 preferredStyle: .alert)
    }
    
    func showAlert(title: String, message: String) {
        let alert = getAlert(title: title, message: message)
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: .default,
                                      handler: { (alert) in }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showCustomActionAlert(title: String, message: String, cancel: Bool = false, action: UIAlertAction) {
        let alert = getAlert(title: title, message: message)
        alert.addAction(action)
        cancel ? alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)) : nil
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Navigation
    
    func navigateToVc(vc: BaseViewController?) {
        guard let vc = vc else {return}
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateHiddingTab(vc: BaseViewController?) {
        guard let vc = vc else {return}
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func findController<T: UIViewController>(toControllerType: T.Type) -> UIViewController? {
        if let viewControllers: [UIViewController] = self.navigationController?.viewControllers {
            for currentViewController in viewControllers {
                if currentViewController.isKind(of: toControllerType) {
                    return currentViewController
                }
            }
        }
        return nil
    }
    
    //MARK: Right Button
    
    func setRightBarButtonItem(imageName: String, action: Selector) {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.tintColor = .cyan
        button.widthAnchor.constraint(equalToConstant: 20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true

        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }

}

