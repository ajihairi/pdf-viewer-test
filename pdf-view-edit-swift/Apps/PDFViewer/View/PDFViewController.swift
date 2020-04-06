//
//  PDFViewController.swift
//  pdf-view-edit-swift
//
//  Created by Hamzhya Salsatinnov Hairy on 06/04/20.
//  Copyright © 2020 Hamzhya Salsatinnov Hairy. All rights reserved.
//

import UIKit
import PDFKit

class PDFViewController: UIViewController, PDFViewDelegate, PDFDocumentDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var pdfdocument: PDFDocument?
    var pdfFile = filesData()
    var pdfview: PDFView!
    var pdfthumbView: PDFThumbnailView!
    let toolView = ToolView.instanceFromNib()
    var currentlySelectedAnnotation: PDFAnnotation?
    
    var imagePicker = UIImagePickerController()
    var stampedImage: UIImage?
    
    weak var observe : NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolView.frame = CGRect(x: 10, y: view.frame.height - 50, width: self.view.frame.width - 20, height: 40)
        
        pdfview = PDFView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        pdfview.displayMode = PDFDisplayMode.singlePageContinuous
        pdfview.autoScales = true
        self.setupPDFView()
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        view.addGestureRecognizer(tapgesture)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    func setupPDFView() {
        self.navigationController?.title = self.pdfFile.name ?? "-"
        // Download simple pdf document
        self.showSpinner(onView: self.view)
        if let documentURL = URL(string: self.pdfFile.file ?? "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"),
            let data = try? Data(contentsOf: documentURL),
            let document = PDFDocument(data: data) {
            
            // Set document to the view, center it, and set background color
            pdfview.document = document
            pdfview.autoScales = true
            pdfview.backgroundColor = UIColor.lightGray
            self.view.addSubview(pdfview)
            self.view.addSubview(toolView)
            toolView.bringSubviewToFront(self.view)
            self.removeSpinner()
            toolView.thumbBtn.addTarget(self, action: #selector(thumbBtnClick), for: .touchUpInside)
            toolView.outlineBtn.addTarget(self, action: #selector(outlineBtnClick), for: .touchUpInside)
            toolView.searchBtn.addTarget(self, action: #selector(searchBtnClick), for: .touchUpInside)
            toolView.editBtn.addTarget(self, action: #selector(editBtn(_:)), for: .touchUpInside)
            let panAnnotationGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanAnnotation(sender:)))
            pdfview.addGestureRecognizer(panAnnotationGesture)
            
        }
    }
    
    @objc func editBtn(_ sender: UIButton!) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        self.stampedImage = image
        addedImage()
    }
    
    func addedImage() {
        guard let signatureImage = stampedImage, let page = pdfview.currentPage else { return }
        let pageBounds = page.bounds(for: .cropBox)
        let imageBounds = CGRect(x: pageBounds.midX, y: pageBounds.midY, width: 500, height: 500)
        let imageStamp = ImageStampAnnotation(with: signatureImage, forBounds: imageBounds, withProperties: nil)
        page.addAnnotation(imageStamp)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        self.stampedImage = UIImage()
    }
    
    @objc func tapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        UIView.animate(withDuration: CATransaction.animationDuration()) { [weak self] in
            self?.toolView.alpha = 1 - (self?.toolView.alpha)!
            
        }
    }
    
    @objc func didPanAnnotation(sender: UIPanGestureRecognizer) {
        let touchLocation = sender.location(in: pdfview)
        
        guard let page = pdfview.page(for: touchLocation, nearest: true)
            else {
                return
        }
        let locationOnPage = pdfview.convert(touchLocation, to: page)
        
        switch sender.state {
        case .began:
            
            guard let annotation = page.annotation(at: locationOnPage) else {
                return
            }
            
            if annotation.isKind(of: ImageStampAnnotation.self) {
                currentlySelectedAnnotation = annotation
            }
            
        case .changed:
            
            guard let annotation = currentlySelectedAnnotation else {
                return
            }
            let initialBounds = annotation.bounds
            // Set the center of the annotation to the spot of our finger
            annotation.bounds = CGRect(x: locationOnPage.x - (initialBounds.width / 2), y: locationOnPage.y - (initialBounds.height / 2), width: initialBounds.width, height: initialBounds.height)
            
            
            print("move to \(locationOnPage)")
        case .ended, .cancelled, .failed:
            currentlySelectedAnnotation = nil
        default:
            break
        }
    }
    
    @objc func thumbBtnClick(sender: UIButton!) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 20
        
        let width = (view.frame.width - 10 * 4) / 3
        let height = width * 1.5
        
        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let thumbnailGridViewController = ThumbnailGridViewController(collectionViewLayout: layout)
        thumbnailGridViewController.pdfDocument = pdfdocument
        thumbnailGridViewController.delegate = self
        
        let nav = UINavigationController(rootViewController: thumbnailGridViewController)
        
        self.present(nav, animated: true, completion:nil)
    }
    
    @objc func outlineBtnClick(sender: UIButton) {
        
        if let pdfoutline = pdfdocument?.outlineRoot {
            let oulineViewController = OulineTableviewController(style: UITableView.Style.plain)
            oulineViewController.pdfOutlineRoot = pdfoutline
            oulineViewController.delegate = self
            
            let nav = UINavigationController(rootViewController: oulineViewController)
            self.present(nav, animated: true, completion:nil)
        }
        
    }
    
    @objc func searchBtnClick(sender: UIButton) {
        let searchViewController = SearchTableViewController()
        searchViewController.pdfDocument = pdfdocument
        searchViewController.delegate = self
        
        let nav = UINavigationController(rootViewController: searchViewController)
        self.present(nav, animated: true, completion:nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PDFViewController: OulineTableviewControllerDelegate {
    func oulineTableviewController(_ oulineTableviewController: OulineTableviewController, didSelectOutline outline: PDFOutline) {
        let action = outline.action
        if let actiongoto = action as? PDFActionGoTo {
            pdfview.go(to: actiongoto.destination)
        }
    }
}

extension PDFViewController: ThumbnailGridViewControllerDelegate {
    func thumbnailGridViewController(_ thumbnailGridViewController: ThumbnailGridViewController, didSelectPage page: PDFPage) {
        pdfview.go(to: page)
    }
}

extension PDFViewController: SearchTableViewControllerDelegate {
    func searchTableViewController(_ searchTableViewController: SearchTableViewController, didSelectSerchResult selection: PDFSelection) {
        selection.color = UIColor.yellow
        pdfview.currentSelection = selection
        pdfview.go(to: selection)
    }
}
