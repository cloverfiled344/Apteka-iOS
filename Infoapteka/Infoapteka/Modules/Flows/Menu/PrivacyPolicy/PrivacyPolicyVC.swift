//
//  PrivacyPolicyVC.swift
//  Infoapteka
//
//  
//

import UIKit
import PDFKit

class PrivacyPolicyVC: UIViewController {
    
    private lazy var pdfView: PDFView = {
        let view = PDFView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var privacyPolicy: PrivacyPolicy? {
        didSet {
            guard let url = URL(string: privacyPolicy?.pdfFile ?? "") else { return }
            guard let document = PDFDocument(url: url) else { return }
            pdfView.document = document
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    private func setupUI() {
        self.view.addSubview(pdfView)
        self.pdfView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    func setupPDF(_ item: PrivacyPolicy?) {
        self.privacyPolicy = item
    }
}
