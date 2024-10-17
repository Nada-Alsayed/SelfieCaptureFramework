//
//  valifyFrameworkManager.swift
//  ValifyFrameWork
//
//  Created by Nada_Hamed on 17/10/2024.
//

import Foundation
import UIKit

public class ValifyFrameworkManager{
    public init() {}
    
    public static func takeSelfie(from viewController: UIViewController, delegate: ApprovableProtocol) {
    
        let selfieViewController = TakeSelfieViewController()
        selfieViewController.approveDelegate = delegate
        
        let navigationController = UINavigationController(rootViewController: selfieViewController)
        navigationController.navigationBar.isHidden = true
        navigationController.modalPresentationStyle = .fullScreen
        viewController.present(navigationController, animated: true)
    }
}
