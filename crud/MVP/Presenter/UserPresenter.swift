import RealmSwift

protocol UserPresenterLogic {
    func viewDidLoad()
    func buttonTap()
    func deleteUs(_ user: User)
    func updateUs(to name: String?, to surname: String?, to password: String?, at index: Int)
}

class UserPresenter {
    var view: UserView?
    let realm = try! Realm()

    func getUsers() {
        let users = realm.objects(User.self)
        view?.getUsers(users)
    }

    func buttonTap() {
        let newUser = User()
        try! realm.write {
            realm.add(newUser)
        }
        getUsers()
    }

    func deleteUs(_ user: User) {
        try! realm.write {
            realm.delete(user)
        }
        getUsers()
    }

    func updateUs(to name: String?, to surname: String?, to password: String?, at index: Int) {
        let user = realm.objects(User.self)[index]
        try! realm.write {
            if let name = name, !name.isEmpty {
                user.name = name
            }
            if let surname = surname, !surname.isEmpty {
                user.surname = surname
            }
            if let password = password, !password.isEmpty {
                user.password = password
            }
        }
        getUsers()
    }
}

extension UserPresenter: UserPresenterLogic {
    func viewDidLoad() {
        getUsers()
    }
}
