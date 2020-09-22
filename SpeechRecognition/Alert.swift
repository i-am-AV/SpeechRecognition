//
//  Alert.swift
//  SpeechRecognition
//
//  Created by  Alexander on 22.09.2020.
//

import UIKit

final class Alert: UIAlertController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let placeholder = "Скажите, что вы хотите найти"
        static let buttonColor = UIColor(red: 58/255,
                                         green: 131/255,
                                         blue: 241/255,
                                         alpha: 1)
        
    }
    
    // MARK: - Properties
    
    private let recordedTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.boldSystemFont(ofSize: 22)
        textField.placeholder = Constants.placeholder
        textField.isUserInteractionEnabled = false
        
        return textField
    }()
    
    private let recordButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0,
                                            width: 74, height: 74))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Constants.buttonColor
        button.setImage(#imageLiteral(resourceName: "Mic"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.cornerRadius = button.frame.height / 2
        
        return button
    }()
    
    private let keyboardButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0,
                                            width: 25, height: 25))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "Keyboard"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        
        
        return button
    }()
    
    // MARK: - Public methods
    
    func showCustomVoiceActionSheet() {
        let spacing = String(repeating: "\n", count: 9)
        let actionSheet = UIAlertController(title: spacing,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        let contentView = configurateContentView()
        actionSheet.view.addSubview(contentView)
        //present(actionSheet, animated: true, completion: nil)
        UIApplication.topViewController()?.present(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: - Private methods
    
    private func configurateContentView() -> UIView {
        let contentView = UIView(frame: CGRect(x: -8, y: 0,
                                               width: view.frame.width, height: 228))
        contentView.backgroundColor = .white
        contentView.roundCorners(corners: [.topLeft, .topRight], radius: 19)
        
        addingSubviews(to: contentView)
        
        return contentView
    }
    
    private func addingSubviews(to contentView: UIView) {
        contentView.addSubview(recordedTextField)
        recordedTextField.pin(to: contentView,
                              top: 24,
                              left: 24,
                              bottom: 176,
                              right: 24)
        
        contentView.addSubview(recordButton)
        setConstraints(to: recordButton, on: contentView)
        
        contentView.addSubview(keyboardButton)
        setConstraints(to: keyboardButton, on: contentView, and: recordButton)
    }
    
    // MARK: - RecordButton
    
    private func setConstraints(to button: UIButton, on view: UIView) {
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            button.heightAnchor.constraint(equalToConstant: 74),
            button.widthAnchor.constraint(equalToConstant: 74)
        ])
    }
    
    // MARK: - KeyboardButton
    
    private func setConstraints(to button: UIButton, on view: UIView, and rightOfButton: UIButton) {
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: rightOfButton.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
