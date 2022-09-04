
import UIKit
import MapKit

class DetailViewController: UIViewController, CLLocationManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var receiveTask: TaskDto!

    @IBOutlet var lblDate: UILabel!
    @IBOutlet var tfTitle: UITextField!
    @IBOutlet var tfDetail: UITextField!
    
    @IBOutlet var tfAddress: UITextField!
    @IBOutlet var myMap: MKMapView!
    
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var btnLoadImageFromLibrary: UIButton!
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    var captureImage: UIImage!
    var url: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 전달 받은 TaskDto 의 시간 정수 값을 시간 형식으로 변경하여 표시
        let date = Date(timeIntervalSince1970: TimeInterval(receiveTask.date))
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd EEE hh:mm a"
        lblDate.text = formatter.string(from: date)
        
        tfTitle.text = receiveTask.title
        tfDetail.text = receiveTask.detail
        tfAddress.text = receiveTask.address
        
        geoCoder.geocodeAddressString(tfAddress.text!) { [self] (placemark, error) in
            guard error == nil else {return print(error!.localizedDescription)}
            guard let location = placemark?.first?.location else { return print("데이터가 없습니다")}
            
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            print("위도 \(latitude)")
            print("경도 \(longitude)")
            
            setAnnotation(lattitudeValue: latitude, longitudeValue: longitude, delta: 0.001, title: self.tfAddress.text!)
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        myMap.showsUserLocation = true
        
        if let url = URL(string: receiveTask.icon!) {
            if let data = try? Data(contentsOf: url) {
                let image = UIImage(data: data)
                imgView.image = image
            }
        }
    }
    
    func receiveItem(_ task: TaskDto) {
        // TaskDto 가 잘 전달되었는지 확인
        print("received: \(task.id)")
        receiveTask = task
    }

    // 화면의 입력 값(제목, 내용) 으로 DB 수정
    @IBAction func btnModify(_ sender: UIButton) {
        let title = tfTitle.text
        let detail = tfDetail.text
        let address = tfAddress.text
        
        manager.updateData(Int32(receiveTask.id), title: title!, detail: detail!, address: address!, icon: url)
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    func goLocation(latitudeValue: CLLocationDegrees, longitudeValue: CLLocationDegrees, delta span: Double) -> CLLocationCoordinate2D {
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let pRegion = MKCoordinateRegion(center: pLocation, span: spanValue)
        myMap.setRegion(pRegion, animated: true)
        return pLocation
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let pLocation = locations.last
        _ = goLocation(latitudeValue: (pLocation?.coordinate.latitude)!, longitudeValue: (pLocation?.coordinate.longitude)!, delta: 0.01)
    }
    
    func setAnnotation(lattitudeValue: CLLocationDegrees, longitudeValue: CLLocationDegrees, delta span: Double, title strTitle: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = goLocation(latitudeValue: lattitudeValue, longitudeValue: longitudeValue, delta: span)
        annotation.title = strTitle
        myMap.addAnnotation(annotation)
    }
    
    func myAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnLoadImageFromLibrary(_ sender: UIButton) {
        if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = ["public.image"]
            imagePicker.allowsEditing = true
            
            present(imagePicker, animated: true, completion: nil)
        } else {
            myAlert("Photo album inaccessable", message: "Application cannot access the photo album")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        captureImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        
        url = (info[UIImagePickerController.InfoKey.imageURL] as? URL)!.absoluteString
        
        print(url)
        
        imgView.image = captureImage
        
        self.dismiss(animated: true, completion: nil)
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
