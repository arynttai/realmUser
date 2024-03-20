import Foundation
import RealmSwift

class User: Object{
    @Persisted var name: String
    @Persisted var surname: String
    @Persisted var password: String
    
//    init(name: String, surname: String, password: String) {
//        self.name = name
//        self.surname = surname
//        self.password = password
//    }

}
