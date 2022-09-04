
import UIKit

var items = [TaskDto]()         // Task 를 저장하는 전역변수
let manager = DBManager()       // DBManager 전역변수
var imageFileName = ["cart.png", "clock.png", "pencil.png"]

class TableViewController: UITableViewController {
    
    @IBOutlet var tvListView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        manager.initDatabase()
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = items[(indexPath as NSIndexPath).row].title
        //cell.imageView?.image = UIImage(named: items[(indexPath as NSIndexPath).row].icon!)
        if let url = URL(string: items[(indexPath as NSIndexPath).row].icon!) {
            if let data = try? Data(contentsOf: url) {
                let image = UIImage(data: data)
                let newImage = resizeImage(image: image!, height: image!.size.height)
                cell.imageView?.image = newImage
            }
        }
        
        
        return cell
    }
    
    func resizeImage(image: UIImage, height: CGFloat) -> UIImage {
        let width = height
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let id = items[(indexPath as NSIndexPath).row].id
            items.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            manager.deleteData(Int32(id))
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
    

//    DB에서 전체 데이터를 읽어온 후 items 배열 구성 후 화면에 표시
    override func viewWillAppear(_ animated: Bool) {
//        DB 에서 다시 데이터를 읽어와 목록에 추가하므로 기존 목록은 삭제
        items.removeAll()
        
//        DB에서 데이터를 읽어와 items에 추가 수행
        manager.readAllData()
        
        tvListView.reloadData()
    }
    
    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "sgDetail" {
            let cell = sender as! UITableViewCell
            let indexPath = self.tvListView.indexPath(for: cell)
            let detailView = segue.destination as! DetailViewController
            detailView.receiveItem(items[(indexPath! as NSIndexPath).row])
        }
    
    }
    

}
