import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.styleNavbar()
        self.navigationBar.barStyle = .black
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func styleNavbar() {
        let titleFont = UIFont(name: "SF-Pro", size: 20) ?? UIFont.systemFont(ofSize: 20)
        let textAttributes = [NSAttributedString.Key.font: titleFont, NSAttributedString.Key.foregroundColor: UIColor.lightText]
        self.navigationBar.titleTextAttributes = textAttributes
        self.navigationBar.largeTitleTextAttributes = textAttributes
        self.navigationBar.isTranslucent = false
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.barTintColor = UIColor.black
        
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes = textAttributes
            appearance.largeTitleTextAttributes = textAttributes
            appearance.backgroundColor = UIColor.black
            appearance.shadowColor = .black
            self.navigationBar.standardAppearance = appearance
            self.navigationBar.scrollEdgeAppearance = appearance
        }
        
        setBackButton()
    }
    
    func setBackButton() {
        let titleFont = UIFont(name: "SF-Pro", size: 18) ?? UIFont.systemFont(ofSize: 18)
        let textAttributes = [NSAttributedString.Key.font: titleFont, NSAttributedString.Key.foregroundColor: UIColor.lightText]
        let backButton = UIBarButtonItem()
        let appearance = UIBarButtonItem.appearance()
        appearance.setTitleTextAttributes(textAttributes, for: .normal)
        appearance.setTitleTextAttributes(textAttributes, for: .highlighted)
        backButton.tintColor = UIColor.lightText
        self.navigationBar.topItem?.backBarButtonItem = backButton
        
        if #available(iOS 15, *) {
            let buttonAppearance = UIBarButtonItemAppearance()
            buttonAppearance.normal.titleTextAttributes = textAttributes
            buttonAppearance.highlighted.titleTextAttributes = textAttributes
            self.navigationBar.standardAppearance.backButtonAppearance = buttonAppearance
            self.navigationBar.scrollEdgeAppearance?.backButtonAppearance = buttonAppearance
        }
    }

}
