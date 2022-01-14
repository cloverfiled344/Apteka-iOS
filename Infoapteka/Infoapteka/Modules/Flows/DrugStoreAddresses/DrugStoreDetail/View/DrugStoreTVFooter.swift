//
//  DrugStoreTVFooter.swift
//  Infoapteka
//
//  
//

import UIKit
import MapKit


extension DrugStoreTVFooter {
    struct Appearance {
        let backgroundColor: UIColor = Asset.mainWhite.color
        let mapViewHeight: CGFloat = Constants.screenHeight / (Constants.screenHeight / 270.0)
        let anotaionIdenfier = "AnotationIdentifier"
    }
}

class DrugStoreTVFooter: UITableViewHeaderFooterView {
    
    // MARK: UI Components
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
    private var anotations: [MKAnnotation] = []
    private let appearance = Appearance()
    private var drugStore: DrugStore? {
        didSet {
            guard let drugStore = drugStore else { return }
            anotations.removeAll()
            let anotation = MKPointAnnotation()
            anotation.coordinate = CLLocationCoordinate2D(latitude: Double(drugStore.latitude ?? "") ?? .zero,
                                                           longitude: Double(drugStore.longitude ?? "") ?? .zero)
            anotations.append(anotation)
            mapView.showAnnotations(anotations, animated: true)
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
        contentView.backgroundColor = appearance.backgroundColor
        contentView.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(12.0)
            make.leading.trailing.equalTo(contentView).inset(20)
            make.height.equalTo(appearance.mapViewHeight)
            make.bottom.equalTo(contentView.snp.bottom).offset(-20)
        }
    }
    
    func setupFooter(_ drugStore: DrugStore?) {
        self.drugStore = drugStore
    }
}


extension DrugStoreTVFooter: MKMapViewDelegate {
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
