//
//  WelcomeView.swift
//  Camera
//
//  Created by Matheus Pires de Sousa on 29/06/24.
//

import UIKit

protocol WelcomeViewDelegate: AnyObject {
    func onPressGoToCamera()
}

class WelcomeView: UIView {
    private weak var delegate: WelcomeViewDelegate?
    public func delegate(delegate: WelcomeViewDelegate?){
        self.delegate = delegate
    }
    
    lazy var imageCamera: UIImageView = {
        let image = UIImageView()
        
        image.image = UIImage(named: "camera-welcome")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    lazy var titleWelcome: UILabel = {
        let label = UILabel()
        
        label.text = "Welcome to a different Camera app!"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var descriptionWelcome: UILabel = {
        let label = UILabel()
        
        label.text = "This is a app for test camera IOS functionalities!"
        label.textAlignment = .justified
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var buttonGoToCamera: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go to Camera", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addOpacityEffect()
        button.addTarget(self, action: #selector(handlePressGoToCamera), for: .touchUpInside)
        return button
    }()
    
    @objc
    private func handlePressGoToCamera() {
        self.delegate?.onPressGoToCamera()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addSubview(imageCamera)
        self.addSubview(titleWelcome)
        self.addSubview(descriptionWelcome)
        self.addSubview(buttonGoToCamera)
        
        self.configConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configConstraints() {
        NSLayoutConstraint.activate([
            self.imageCamera.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.imageCamera.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.imageCamera.widthAnchor.constraint(equalToConstant: 250),
            self.imageCamera.heightAnchor.constraint(equalToConstant: 250),
            
            self.titleWelcome.topAnchor.constraint(equalTo: self.imageCamera.bottomAnchor, constant: 25),
            self.titleWelcome.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.titleWelcome.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            self.titleWelcome.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            
            self.descriptionWelcome.topAnchor.constraint(equalTo: self.titleWelcome.bottomAnchor, constant: 32),
            self.descriptionWelcome.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            self.descriptionWelcome.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            
            self.buttonGoToCamera.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            self.buttonGoToCamera.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            self.buttonGoToCamera.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            self.buttonGoToCamera.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}
