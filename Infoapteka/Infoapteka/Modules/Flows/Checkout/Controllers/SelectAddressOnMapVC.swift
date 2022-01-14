//
//  SelectAddressOnMapVC.swift
//  Infoapteka
//
//

import UIKit
import MapKit

class LocationAnnotation: MKPointAnnotation {
    var name: String?
    var icon: UIImage?
}

var shuttleAnnotations: [MKAnnotation] = []

// MARK: Appearance
extension SelectAddressOnMapVC {
    struct Appearance {
        let backgroundColor: UIColor = Asset.mainWhite.color

        let tableViewBackgroundColor: UIColor = Asset.mainWhite.color
        let tableViewSeparatorColor: UIColor = Asset.secondaryGrayLight.color

        let title    : String = "Адрес на карте"
        let titleFont: UIFont = FontFamily.Inter.semiBold.font(size: 18.0)
        let titleColor   : UIColor = Asset.mainBlack.color
        let subtitleColor: UIColor = Asset.secondaryGray3.color

        let regionInMeters: Double = 1000
        let openSettingAppMessage = NSLocalizedString("1. Перейдите в «Настройки»> «Конфиденциальность», затем выберите «Службы геолокации». \n2. Выберите приложение, затем включите или выключите «Точное местоположение».", comment: "")

        let placeAnOrderViewHeight: CGFloat = Constants.distanceBetweenSuperSafeViews + 82.0
    }
}

class SelectAddressOnMapVC: BaseVC {

    // MARK: -- UI Properties
    lazy private var titleLbl: UILabel = {
        let view = UILabel(frame: .init(x: 0, y: 0, width: 0, height: 44))
        view.textAlignment = .center
        return view
    }()

    let mapView: MKMapView = {
        let view = MKMapView()
        view.mapType = MKMapType.standard
        view.isZoomEnabled = true
        view.isScrollEnabled = true
        view.isRotateEnabled = true
        view.showsUserLocation = true
        view.setUserTrackingMode(.followWithHeading, animated: true)
        view.showsCompass = true
        return view
    }()

    private lazy var selectAddressOnMapView: SelectAddressOnMapView = { SelectAddressOnMapView() }()
    private lazy var locationManager: CLLocationManager = { CLLocationManager() }()
    private var appearance = Appearance()
    private var location: Location?
    private var locationAnnotations: [MKAnnotation] = []
    private let geoCoder = CLGeocoder()
    var selectedAddress: ((Location) -> ())?


    init(_ location: Location?) {
        self.location = location
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(mapView)
        mapView.delegate = self
        let tapOnMap = UITapGestureRecognizer(target: self,
                                              action: #selector(didTappedOnMap(_:)))
        mapView.isUserInteractionEnabled = true
        mapView.addGestureRecognizer(tapOnMap)
        mapView.snp.makeConstraints { (maker) in
            maker.left.top.right.bottom.equalToSuperview()
        }

        view.addSubview(selectAddressOnMapView)
        selectAddressOnMapView.delegate = self
        selectAddressOnMapView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom)
            make.height.equalTo(appearance.placeAnOrderViewHeight)
            make.width.equalTo(Constants.screenWidth)
        }

        checkLocationServices()
        if let location = location {
            showAnnotations(location)
        }
    }

    @objc private func didTappedOnMap(_ gestureRecognizer: UITapGestureRecognizer) {
        let point = gestureRecognizer.location(in: mapView)
        let tapPoint = mapView.convert(point, toCoordinateFrom: view)
        geoCoder.reverseGeocodeLocation(.init(latitude: tapPoint.latitude,
                                              longitude: tapPoint.longitude)) { markers, error in

            guard error == nil else {
                BannerTop.showToast(message: error?.localizedDescription, and: .systemRed)
                return
            }

            guard let marker = markers?.first, let coordinate = marker.location?.coordinate  else {
                self.showAnnotations(.init(title: "\(tapPoint.latitude) \(tapPoint.longitude)",
                                           latitude: tapPoint.latitude, longitude: tapPoint.longitude))
                return
            }

            let location = Location(title: marker.compactAddress ?? "\(coordinate.latitude) \(coordinate.longitude)",
                                    latitude: coordinate.latitude,
                                    longitude: coordinate.longitude)
            self.showAnnotations(location)
        }
    }

    private func showAnnotations(_ location: Location) {
        self.location = location
        let annotation = LocationAnnotation()
        annotation.title = location.title

        let latitude = String("\(String(format: "%.3f", location.latitude ?? 0.0))".prefix(5))
        let longitude = String("\(String(format: "%.3f", location.longitude ?? 0.0))".prefix(5))
        let subtitle: String = "\(latitude) \(longitude)"
        annotation.subtitle = subtitle

        annotation.icon = Asset.icMapPing.image
        annotation.coordinate = .init(latitude: location.latitude ?? 0.0,
                                      longitude: location.longitude ?? 0.0)

        mapView.removeAnnotations(locationAnnotations)

        locationAnnotations = [annotation]
        mapView.showAnnotations(locationAnnotations, animated: true)
        selectAddressOnMapView.setTitle(location.title ?? subtitle)
    }

    private func setMapRegion(_ coordinate: CLLocationCoordinate2D) {
        let coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude,
                                                longitude: coordinate.longitude)
        let region = MKCoordinateRegion.init(center: coordinate,
                                             latitudinalMeters: appearance.regionInMeters,
                                             longitudinalMeters: appearance.regionInMeters)
        mapView.setRegion(region, animated: true)
        mapView.regionThatFits(region)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNavBar()
    }

    private func updateNavBar() {
        view.backgroundColor = appearance.backgroundColor
        setNavBarBackColor(title: "",
                           statusBarBackColor: .white,
                           navBarBackColor: .white,
                           navBarTintColor: .white,
                           prefersLargeTitles: false)
        updateTitleLbl()
    }

    fileprivate func updateTitleLbl() {
        let attributedText = NSMutableAttributedString(string: appearance.title,
                                                       attributes: [.font: appearance.titleFont,
                                                                    .foregroundColor: appearance.titleColor])
        titleLbl.attributedText = attributedText
        navigationItem.titleView = titleLbl
    }
}

extension SelectAddressOnMapVC: CLLocationManagerDelegate {
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            openSettingApp(message: appearance.openSettingAppMessage)
        }
    }

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            mapView.showsUserLocation = true
            setMapRegion(mapView.userLocation.coordinate)
            locationManager.startUpdatingLocation()
            break
        case .denied, .restricted:
            openSettingApp(message: appearance.openSettingAppMessage)
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            fatalError()
        }
    }

    //open location settings for app
    private func openSettingApp(message: String) {
        let alertController = UIAlertController (title: "Infoapteka",
                                                 message: message,
                                                 preferredStyle: .actionSheet)
        let settingsAction = UIAlertAction(title: "Настройки",
                                           style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, options: [:],
                                          completionHandler: nil)
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Отмена",
                                         style: .default,
                                         handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion.init(center: location.coordinate,
                                             latitudinalMeters: appearance.regionInMeters,
                                             longitudinalMeters: appearance.regionInMeters)
        mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
    }


    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension SelectAddressOnMapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        var annotationView: MKAnnotationView?
        var icon: UIImage?

        if let locationAnnotation = annotation as? LocationAnnotation {
            annotationView = MKAnnotationView(annotation: locationAnnotation,
                                              reuseIdentifier: AnnotationIdentifier.LocationAnnotation.rawValue)
            annotationView?.annotation = locationAnnotation
            icon = locationAnnotation.icon
        }

        annotationView?.isDraggable = false
        annotationView?.canShowCallout = true

        let resizeRenderimageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 49.0, height: 57.0))
        resizeRenderimageView.contentMode = .scaleAspectFill
        resizeRenderimageView.image = icon

        UIGraphicsBeginImageContextWithOptions(resizeRenderimageView.frame.size, false, 0.0)
        resizeRenderimageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let thumbnail = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        annotationView?.image = thumbnail
        return annotationView
    }
}

extension SelectAddressOnMapVC: PlaceAnOrderViewDelegate {
    func didTappedSubmitBtn() {
        guard let location = location else {
            BannerTop.showToast(message: "Выберите адрес на карте", and: .systemRed)
            return
        }
        selectedAddress?(location)
    }
}

extension CLPlacemark {
    var compactAddress: String? {
        if let name = name {
            var result = name
            if let street = thoroughfare {
                result += ", \(street)"
            }
            if let city = locality {
                result += ", \(city)"
            }
            if let country = country {
                result += ", \(country)"
            }
            return result
        }
        return nil
    }
}
