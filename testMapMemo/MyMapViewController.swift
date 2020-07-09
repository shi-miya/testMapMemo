//
//  MyMapViewController.swift
//  testMapMemo
//
//  Created by 宮本翼 on 2020/07/09.
//  Copyright © 2020 宮本翼. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MyMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var myPin: MKPointAnnotation!
    var myMapView: MKMapView!
    var myLocationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        // LocationManagerの生成.
        myLocationManager = CLLocationManager()

        // Delegateの設定.
        myLocationManager.delegate = self

        // 距離のフィルタ.
        myLocationManager.distanceFilter = 100.0

        // 精度.
        myLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters

        // セキュリティ認証のステータスを取得.
        let status = CLLocationManager.authorizationStatus()

        // まだ認証が得られていない場合は、認証ダイアログを表示.
        if(status != CLAuthorizationStatus.authorizedWhenInUse) {

            print("not determined")
            // まだ承認が得られていない場合は、認証ダイアログを表示.
            myLocationManager.requestWhenInUseAuthorization()
        }
        // 位置情報の更新を開始.
        myLocationManager.startUpdatingLocation()

        // MapViewの生成.
        myMapView = MKMapView()

        // MapViewのサイズを画面全体に.
        myMapView.frame = self.view.bounds

        // Delegateを設定.
        myMapView.delegate = self

        // MapViewをViewに追加.
        self.view.addSubview(myMapView)
        
        // UIButtonを作成する.
        let myButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        myButton.layer.position = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height-100)
        myButton.layer.masksToBounds = true
        myButton.layer.cornerRadius = 20.0
        myButton.setTitle("目的地に設定", for: .normal)
        myButton.backgroundColor = UIColor.red
        myButton.setTitleColor(UIColor.white, for: .normal)
        myButton.addTarget(self, action: #selector(MyMapViewController.onClickMyButton(sender:)), for: .touchUpInside)
         // UIButtonをviewに追加.
        self.view.addSubview(myButton)
         
         // 長押しのUIGestureRecognizerを生成.
         let myLongPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
         myLongPress.addTarget(self, action: #selector(MyMapViewController.recognizeLongPress(sender:)))

         // MapViewにUIGestureRecognizerを追加.
         myMapView.addGestureRecognizer(myLongPress)

         // 中心点の緯度経度.
         let myLat: CLLocationDegrees = 37.506804
         let myLon: CLLocationDegrees = 139.930531
         let myCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(myLat, myLon) as CLLocationCoordinate2D

         // 縮尺.
         let myLatDist : CLLocationDistance = 100
         let myLonDist : CLLocationDistance = 100

         // Regionを作成.
         let myRegion: MKCoordinateRegion = MKCoordinateRegion(center: myCoordinate, latitudinalMeters: myLatDist, longitudinalMeters: myLonDist);

         // MapViewに反映.
         myMapView.setRegion(myRegion, animated: true)
    }
    
    // GPSから値を取得した際に呼び出されるメソッド.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        print("didUpdateLocations")

        // 配列から現在座標を取得.
        let myLocations: NSArray = locations as NSArray
        let myLastLocation: CLLocation = myLocations.lastObject as! CLLocation
        let myLocation:CLLocationCoordinate2D = myLastLocation.coordinate

        print("\(myLocation.latitude), \(myLocation.longitude)")

        // 縮尺.
        let myLatDist : CLLocationDistance = 100
        let myLonDist : CLLocationDistance = 100

        // Regionを作成.
        let myRegion: MKCoordinateRegion = MKCoordinateRegion(center: myLocation, latitudinalMeters: myLatDist, longitudinalMeters: myLonDist);

        // MapViewに反映.
        myMapView.setRegion(myRegion, animated: true)
    }

    // Regionが変更した時に呼び出されるメソッド.
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("regionDidChangeAnimated")
    }

    // 認証が変更された時に呼び出されるメソッド.
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status{
        case .authorizedWhenInUse:
            print("AuthorizedWhenInUse")
        case .authorizedAlways:
            print("AuthorizedAlways")
        case .denied:
            print("Denied")
        case .restricted:
            print("Restricted")
        case .notDetermined:
            print("NotDetermined")
        }
    }
    
    /*
     長押しを感知した際に呼ばれるメソッド.
     */
    @objc func recognizeLongPress(sender: UILongPressGestureRecognizer) {

        // 長押しの最中に何度もピンを生成しないようにする.
        if sender.state != UIGestureRecognizer.State.began {
            return
        }

        // 長押しした地点の座標を取得.
        let location = sender.location(in: myMapView)

        // locationをCLLocationCoordinate2Dに変換.
        let myCoordinate: CLLocationCoordinate2D = myMapView.convert(location, toCoordinateFrom: myMapView)

        // ピンを生成.
        let myPin: MKPointAnnotation = MKPointAnnotation()

        // 座標を設定.
        myPin.coordinate = myCoordinate

        // タイトルを設定.
        myPin.title = "タイトル"

        // サブタイトルを設定.
        myPin.subtitle = "サブタイトル"

        // MapViewにピンを追加.
        myMapView.addAnnotation(myPin)
    }

    /*
     addAnnotationした際に呼ばれるデリゲートメソッド.
     */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        let myPinIdentifier = "PinAnnotationIdentifier"

        // ピンを生成.
        let myPinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: myPinIdentifier)

        // アニメーションをつける.
        myPinView.animatesDrop = true

        // コールアウトを表示する.
        myPinView.canShowCallout = true

        // annotationを設定.
        myPinView.annotation = annotation

        return myPinView
    }
    
    @objc func onClickMyButton(sender: UIButton) {
    }
}
