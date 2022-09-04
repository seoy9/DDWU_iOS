
import Foundation

class TaskDto {
    var id: Int
    var title: String?
    var date: Int32
    var detail: String?
    var icon: String?
    var address: String?

    init(id: Int, title: String, date: Int32, detail: String, icon: String, address: String) {
        self.id = id
        self.title = title
        self.date = date
        self.detail = detail
        self.icon = icon
        self.address = address
    }
}


