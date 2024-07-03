//
//  CameraAccessBlockView.swift
//  Camera
//
//  Created by Matheus Pires de Sousa on 01/07/24.
//

import UIKit

protocol CameraAccessBlockViewDelegate: AnyObject {
    func openAppSettings()
    func goBackToCamera()
}
class CameraAccessBlockView: UIView {
    private weak var delegate: CameraAccessBlockViewDelegate?
    public func delegate(delegate: CameraAccessBlockViewDelegate?){
        self.delegate = delegate
    }
    
    lazy var buttonGoBack: UIButton = {
        let button = UIButton()

        button.translatesAutoresizingMaskIntoConstraints = false
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 28, weight: .medium)
        let symbolImage = UIImage(systemName: "arrow.left", withConfiguration: symbolConfig)
        button.setImage(symbolImage, for: .normal)
        button.imageView?.tintColor = .black
        button.addOpacityEffect()
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        let insetAmount: CGFloat = 35
        
        if #available(iOS 15.0, *) {
            button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: insetAmount, leading: insetAmount, bottom: insetAmount, trailing: insetAmount)
        } else {
            button.contentEdgeInsets = UIEdgeInsets(top: insetAmount, left: insetAmount, bottom: insetAmount, right: insetAmount)
        }
        return button
    }()
    
    lazy var imageCameraBlock: UIImageView = {
        let image = UIImageView()
        
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "camera-blocked")
        image.contentMode = .scaleAspectFill
        
        return image
    }()
    
    lazy var titleCameraBlock: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Camera Access Blocked"
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var descriptionCameraBlock: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Camera permission denied. To use all features of the app, camera access is required. Please go to your app settings on your phone, find the permissions section, and enable camera access. This will ensure you can take photos and use other camera-dependent features."
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .justified
        label.textColor = .black
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var buttonGoSettings: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Go To Settings", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 8
        button.addOpacityEffect()
        button.addTarget(self, action: #selector(openAppSettings), for: .touchUpInside)
        
        return button
    }()
    
    @objc
    func goBack() {
        self.delegate?.goBackToCamera()
    }
    
    @objc
    func openAppSettings() {
        self.delegate?.openAppSettings()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addSubview(buttonGoBack)
        self.addSubview(imageCameraBlock)
        self.addSubview(titleCameraBlock)
        self.addSubview(descriptionCameraBlock)
        self.addSubview(buttonGoSettings)
        
        configConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configConstraints() {
        NSLayoutConstraint.activate([
            self.buttonGoBack.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.buttonGoBack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            
            self.imageCameraBlock.topAnchor.constraint(equalTo: buttonGoBack.bottomAnchor, constant: 10),
            self.imageCameraBlock.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.imageCameraBlock.widthAnchor.constraint(equalToConstant: 250),
            self.imageCameraBlock.heightAnchor.constraint(equalToConstant: 250),
            
            self.titleCameraBlock.topAnchor.constraint(equalTo: self.imageCameraBlock.bottomAnchor, constant: 25),
            self.titleCameraBlock.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.titleCameraBlock.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            self.titleCameraBlock.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            
            self.descriptionCameraBlock.topAnchor.constraint(equalTo: self.titleCameraBlock.bottomAnchor, constant: 25),
            self.descriptionCameraBlock.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            self.descriptionCameraBlock.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            
            self.buttonGoSettings.heightAnchor.constraint(equalToConstant: 40),
            self.buttonGoSettings.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            self.buttonGoSettings.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            self.buttonGoSettings.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
}
