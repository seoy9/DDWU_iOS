
import UIKit
import MobileCoreServices

class AddViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet var dpPicker: UIDatePicker!
    @IBOutlet var tfTitle: UITextField!
    @IBOutlet var tfDetail: UITextField!
    
    @IBOutlet var btnLoadImageFromLibrary: UIButton!
    @IBOutlet var imageView: UIImageView!
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    var captureImage: UIImage!
    var url: String = ""
    
    @IBOutlet var tfAddress: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // DatePicker 에 현재 시간 설정
        let date = NSDate()
        dpPicker.setDate(date as Date, animated: true)
    }
    
    @IBAction func btnSave(_ sender: UIButton) {
        // 뷰에 입력한 값을 사용하여 DB에 추가
        let title = tfTitle.text
        let date = Int32(dpPicker.date.timeIntervalSince1970)
        let detail = tfDetail.text
        let icon = url
        let address = tfAddress.text
        
        manager.insertData(title: title!, date: date, detail: detail!, icon: icon, address: address!)
        
        _ = navigationController?.popViewController(animated: true)
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
        
        imageView.image = captureImage
        
        self.dismiss(animated: true, completion: nil)
    }
}

