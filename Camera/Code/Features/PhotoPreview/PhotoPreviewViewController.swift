//
//  PhotoPreviewViewController.swift
//  Camera
//
//  Created by Matheus Pires de Sousa on 03/07/24.
//

import UIKit

class PhotoPreviewViewController: UIViewController {

    var screen: PhotoPreviewView?
    var photo: UIImage?
    
    override func loadView() {
        self.screen = PhotoPreviewView()
        self.view = screen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screen?.delegate(delegate: self)
        showPhoto()
        // Do any additional setup after loading the view.
    }
    
    func showPhoto(){
        self.screen?.photoImage.image = photo
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PhotoPreviewViewController: PhotoPreviewViewDelegate {
    func dismissPreview() {
        self.dismiss(animated: false)
    }
}
