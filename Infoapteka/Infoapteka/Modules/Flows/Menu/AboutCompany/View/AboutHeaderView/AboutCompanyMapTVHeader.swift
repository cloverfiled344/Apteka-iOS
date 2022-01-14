//
//  AboutCompanyMapTVHeader.swift
//  Infoapteka
//
//  
//

import UIKit
import MapKit

extension AboutCompanyMapTVHeader {
    struct Appearance {
        let heightOfBackgroudView: CGFloat = Constants.screenHeight / (Constants.screenHeight / 652)
        let anotaionIdenfier = "AnotationIdentifier"
        let backViewMaskedCorners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        let backViewCornerRadius: CGFloat = 16.0
        let backViewColor: UIColor = Asset.mainWhite.color
    }
}

class AboutCompanyMapTVHeader: UITableViewHeaderFooterView {
    
    // MARK: UI Components
    private lazy var backView = UIView().then {
        $0.backgroundColor = appearance.backViewColor
        $0.layer.cornerRadius = appearance.backViewCornerRadius
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
    }
    
    private lazy var mapView = MKMapView().then {
        $0.mapType = MKMapType.standard
        $0.isZoomEnabled = true
        $0.isScrollEnabled = true
        $0.isRotateEnabled = true
        $0.showsUserLocation = true
        $0.setUserTrackingMode(.followWithHeading, animated: true)
        $0.showsCompass = true
        $0.layer.cornerRadius = 12.0
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
        $0.delegate = self
    }
    
    // MARK: Properties
    private let appearance = Appearance()
    private var companyResult: AboutCompanyResult? {
        didSet {
            guard let companyResult = companyResult else { return }
            var anotations = [MKPointAnnotation]()
            let point = MKPointAnnotation()
            mapView.removeAnnotations(anotations)
            anotations.removeAll()
            point.coordinate = CLLocationCoordinate2D(latitude: Double(companyResult.latitude ?? "") ?? .zero,
                                                      longitude: Double(companyResult.longitude ?? "") ?? .zero)
            anotations.append(point)
            mapView.showAnnotations(anotations, animated: true)
            makeConstraints()
        }
    }
    
    // MARK: Initialize
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(backView)
        backView.addSubview(mapView)
    }
    
    fileprivate func makeConstraints() {
        backView.snp.remakeConstraints { make in
            make.top.bottom.equalTo(contentView).inset(8)
            make.left.right.equalToSuperview().inset(20)
        }
        
        mapView.snp.remakeConstraints { make in
            make.top.equalTo(backView.snp.top).offset(8)
            make.left.equalTo(backView.snp.left).offset(8)
            make.width.height.equalTo(Constants.screenHeight / (Constants.screenHeight / 374.0))
            make.bottom.right.equalTo(backView).offset(-8)
        }
    }
    
    func setLoactions(_ companyResult: AboutCompanyResult?) {
        self.companyResult = companyResult
    }
}

// MARK: MapKit Delegate
extension AboutCompanyMapTVHeader: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        
        var anotationView: MKAnnotationView?
        if let dequeueAnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: appearance.anotaionIdenfier) {
            anotationView = dequeueAnotationView
            anotationView?.annotation = annotation
        }
        else {
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            anotationView = av
        }
        
        if let anotationView = anotationView {
            anotationView.canShowCallout = true
            let unicorn = Asset.icGreenMapPin.image
            anotationView.image = unicorn
        }
        return anotationView
    }
}
