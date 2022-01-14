//
//  DrugStoreMapCVCell.swift
//  Infoapteka
//
//  
//

import UIKit
import MapKit

// MARK: Custom Drug Store Annotation
class DrugStoreAnnotation: MKPointAnnotation {
    private var _drugStore: DrugStore
    
    init(_ drugStore: DrugStore) {
        self._drugStore = drugStore
        super.init()
        self.coordinate = .init(latitude: .init(Double(drugStore.latitude ?? "") ?? 0.0),
                                longitude: .init(Double(drugStore.longitude ?? "") ?? 0.0))
    }
    
    var drugStore: DrugStore {
        get { _drugStore }
    }
}

protocol DrugStoreMapCVCellDelgate {
    func tappedDrugAnnotation(_ drugStore: DrugStore)
}

extension DrugStoreMapCVCell {
    struct Appearance {
        let heightOfBackgroudView: CGFloat = Constants.screenHeight / (Constants.screenHeight / 652)
        let anotaionIdenfier = "AnotationIdentifier"
    }
}

// MARK: Map BackgroundView
class DrugStoreMapCVCell: UICollectionViewCell {
    
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
    public var delegate: DrugStoreMapCVCellDelgate?
    private let appearance = Appearance()
    private var totalAnotations = [DrugStoreAnnotation]()
    private var drugStoreResult: DrugStoreResult? {
        didSet {
            guard let drugStoreResult = drugStoreResult else { return }
            DispatchQueue.main.async {
                self.mapView.removeAnnotations(self.totalAnotations)
                self.totalAnotations.removeAll()
                self.totalAnotations = drugStoreResult.results.compactMap { DrugStoreAnnotation($0) }
                self.mapView.showAnnotations(self.totalAnotations, animated: true)
            }
        }
    }
    
    // MARK: Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.top.left.equalTo(contentView).offset(20.0)
            make.right.bottom.equalTo(contentView).offset(-20.0)
        }
    }
    
    func setAnotations(_ drugStoreResult: DrugStoreResult) {
        self.drugStoreResult = drugStoreResult
    }
}

extension DrugStoreMapCVCell: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let selectedAnnotation = view.annotation as? DrugStoreAnnotation else {
            print("It's not DrugStoreAnnotation")
            return
        }
        delegate?.tappedDrugAnnotation(selectedAnnotation.drugStore)
    }
    
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
