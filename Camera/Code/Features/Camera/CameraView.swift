//
//  CameraView.swift
//  Camera
//
//  Created by Matheus Pires de Sousa on 29/06/24.
//

import UIKit

protocol CameraViewDelegate: AnyObject {
    func onTakePhoto()
    func goBack()
    func toggleFlash()
    func tapToFocusCam(gesture: UITapGestureRecognizer)
    func pinchToZoomCam(gesture: UIPinchGestureRecognizer)
}

class CameraView: UIView {
    private weak var delegate: CameraViewDelegate?
    public func delegate(delegate: CameraViewDelegate?){
        self.delegate = delegate
    }
    
    lazy var viewCameraContent: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapToFocus(_:))))
        view.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(handlePinchToZoom(_:))))
        return view
    }()
    
    lazy var viewActionButtons: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var viewWhiteInsideButton: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30
        view.backgroundColor = .white
        view.isUserInteractionEnabled = false
        return view
        
    }()
    
    lazy var buttonTakePhoto: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.layer.borderWidth = 2
        button.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        button.layer.cornerRadius = 35
        button.addSubview(viewWhiteInsideButton)
        button.addOpacityEffect()
        
        button.addTarget(self, action: #selector(handleTakePhoto), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonClose: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        let symbolImage = UIImage(systemName: "xmark", withConfiguration: symbolConfig)
        button.setImage(symbolImage, for: .normal)
        button.imageView?.tintColor = .white
        button.addOpacityEffect()
        button.addTarget(self, action: #selector(handleCloseButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 18
        
        return button
    }()
    
    lazy var buttonFlash: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        let symbolImage = UIImage(systemName: "bolt.slash.fill", withConfiguration: symbolConfig)
        button.setImage(symbolImage, for: .normal)
        button.imageView?.tintColor = .white
        button.addOpacityEffect()
        button.addTarget(self, action: #selector(handleToggleFlash), for: .touchUpInside)
        button.isHidden = true
        
        return button
    }()
    
    lazy var viewCameraFocus: UIView = {
        let view = UIView()
            
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        view.layer.borderWidth = 2
        view.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        view.isHidden = true
        
        return view
    }()
    
    @objc
    func handleCloseButtonTapped() {
        self.delegate?.goBack()
    }
    
    @objc
    func handleToggleFlash() {
        self.delegate?.toggleFlash()
    }
    
    @objc
    func handleTapToFocus(_ gesture: UITapGestureRecognizer) {
        self.delegate?.tapToFocusCam(gesture: gesture)
    }    
    
    @objc
    func handlePinchToZoom(_ gesture: UIPinchGestureRecognizer) {
        self.delegate?.pinchToZoomCam(gesture: gesture)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        self.addSubview(viewCameraContent)
        self.addSubview(viewActionButtons)
        self.addSubview(buttonTakePhoto)
        self.addSubview(buttonClose)
        self.addSubview(buttonFlash)
        self.addSubview(viewCameraFocus)
        
        configConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func handleTakePhoto() {
        self.delegate?.onTakePhoto()
    }
    
    private func configConstraints() {
        NSLayoutConstraint.activate([
            viewCameraContent.topAnchor.constraint(equalTo: self.topAnchor),
            viewCameraContent.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            viewCameraContent.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            viewCameraContent.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            
            viewActionButtons.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            viewActionButtons.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            viewActionButtons.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            viewActionButtons.heightAnchor.constraint(equalToConstant: 120),
            
            buttonTakePhoto.centerXAnchor.constraint(equalTo: self.viewActionButtons.centerXAnchor),
            buttonTakePhoto.centerYAnchor.constraint(equalTo: self.viewActionButtons.centerYAnchor),
            buttonTakePhoto.widthAnchor.constraint(equalToConstant: 70),
            buttonTakePhoto.heightAnchor.constraint(equalToConstant: 70),
            
            viewWhiteInsideButton.widthAnchor.constraint(equalToConstant: 60),
            viewWhiteInsideButton.heightAnchor.constraint(equalToConstant: 60),
            viewWhiteInsideButton.centerYAnchor.constraint(equalTo: self.buttonTakePhoto.centerYAnchor),
            viewWhiteInsideButton.centerXAnchor.constraint(equalTo: self.buttonTakePhoto.centerXAnchor),
            
            buttonClose.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            buttonClose.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            buttonClose.heightAnchor.constraint(equalToConstant: 36),
            buttonClose.widthAnchor.constraint(equalToConstant: 36),
            
            buttonFlash.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            buttonFlash.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            buttonFlash.heightAnchor.constraint(equalToConstant: 36),
            buttonFlash.widthAnchor.constraint(equalToConstant: 36),
            
            viewCameraFocus.heightAnchor.constraint(equalToConstant: 50),
            viewCameraFocus.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
