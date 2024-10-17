//
//  PresentSelfieViewController.swift
//  ValifyFrameWork
//
//  Created by Nada_Hamed on 17/10/2024.
//

import UIKit

class PresentSelfieViewController: UIViewController {
    
    // MARK: UI_Properties
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.tintColor = .orange
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let selfieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    let retakeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retake", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .orange
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let approveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Approve", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .orange
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: Properties
    
    var passedImage : UIImage?
    var navigationDelegate:NavigationProtocol?
    var approveDelegate:ApprovableProtocol?
    
    // MARK: Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selfieImageView.image = self.passedImage
        bindButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.backgroundColor = .white
        
        view.addSubview(backButton)
        view.addSubview(selfieImageView)
        view.addSubview(retakeButton)
        view.addSubview(approveButton)
        
        setupConstraints()
    }
}

// MARK: - Configrations

private extension PresentSelfieViewController {
    func bindButtons(){
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        approveButton.addTarget(self, action: #selector(approveButtonAction), for: .touchUpInside)
        retakeButton.addTarget(self, action: #selector(retakeButtonAction), for: .touchUpInside)
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
        
        NSLayoutConstraint.activate([
            selfieImageView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 24),
            selfieImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            selfieImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            selfieImageView.bottomAnchor.constraint(lessThanOrEqualTo: retakeButton.topAnchor, constant: -24)
        ])
        
        NSLayoutConstraint.activate([
            retakeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            retakeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            retakeButton.widthAnchor.constraint(equalToConstant: 120),
            retakeButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        NSLayoutConstraint.activate([
            approveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            approveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            approveButton.widthAnchor.constraint(equalToConstant: 120),
            approveButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}

// MARK: - Private Handlers

private extension PresentSelfieViewController {
    @objc private func backButtonAction() {
        print("Back button clicked")
        self.navigationController?.popViewController(animated: true)
        navigationDelegate?.navigateBack()
    }
    
    @objc private func approveButtonAction() {
        print("approve button clicked")
        guard let passedImage = self.passedImage else { return }
        approveDelegate?.passCapturedImage(selfie: passedImage)
        dismissNavigationController()
    }
    
    @objc private func retakeButtonAction() {
        print("Retake button clicked")
        self.navigationController?.popViewController(animated: true)
        navigationDelegate?.navigateBack()
    }
}

// MARK: - Private Handlers

private extension PresentSelfieViewController {
    func dismissNavigationController(){
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

