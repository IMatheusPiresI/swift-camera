//
//  PhotoPreviewView.swift
//  Camera
//
//  Created by Matheus Pires de Sousa on 03/07/24.
//

import UIKit
protocol PhotoPreviewViewDelegate: AnyObject {
    func dismissPreview()
}
class PhotoPreviewView: UIView {
    private weak var delegate: PhotoPreviewViewDelegate?
    public func delegate(delegate: PhotoPreviewViewDelegate) {
        self.delegate = delegate
    }
    
    lazy var photoImage: UIImageView = {
        let image = UIImageView()
        
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        
        return image
    }()
    
    lazy var buttonClose: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        let symbolImage = UIImage(systemName: "xmark", withConfiguration: symbolConfig)
        button.setImage(symbolImage, for: .normal)
        button.imageView?.tintColor = .white
        button.addOpacityEffect()
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        button.layer.cornerRadius = 18
        
        return button
    }()
    
    @objc
    func closeButtonTapped() {
        self.delegate?.dismissPreview()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(photoImage)
        self.addSubview(buttonClose)
        
        configConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configConstraints() {
        NSLayoutConstraint.activate([
            photoImage.topAnchor.constraint(equalTo: self.topAnchor),
            photoImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            photoImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            photoImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            buttonClose.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            buttonClose.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            buttonClose.heightAnchor.constraint(equalToConstant: 36),
            buttonClose.widthAnchor.constraint(equalToConstant: 36),
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
