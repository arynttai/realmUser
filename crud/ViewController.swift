import UIKit
import RealmSwift
import SnapKit

class ViewController: UIViewController {
    
    let realm = try! Realm()
    
    var users = [User]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var name: UITextField = {
        let textfield = UITextField()
        textfield.borderStyle = .bezel
        textfield.placeholder = "enter a name"
        return textfield
    }()
    lazy var surname: UITextField = {
        let textfield = UITextField()
        textfield.borderStyle = .bezel
        textfield.placeholder = "enter a surname"
        return textfield
    }()
    lazy var password: UITextField = {
        let textfield = UITextField()
        textfield.borderStyle = .bezel
        textfield.placeholder = "enter the password"
        return textfield
    }()

    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("tap me", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.addTarget(self, action: #selector(setName), for: .touchDragInside)
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        getUsers()
    }
    
    private func setupViews() {
        view.addSubview(name)
        view.addSubview(surname)
        view.addSubview(password)
        view.addSubview(button)
        view.addSubview(tableView)
        view.backgroundColor = .white
        
        name.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        surname.snp.makeConstraints { make in
            make.top.equalTo(name.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        password.snp.makeConstraints { make in
            make.top.equalTo(surname.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }

        button.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.centerX.equalToSuperview()
            make.top.equalTo(password.snp.bottom).offset(12)
            make.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.equalTo(button.snp.bottom).offset(12)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc func buttonTapped() {
        let user = User()
        user.name = name.text ?? ""
        user.surname = surname.text ?? ""
        user.password = password.text ?? ""

        name.text = ""
        surname.text = ""
        password.text = ""

        try! realm.write {
            realm.add(user)
        }
        getUsers()
    }
    
    @objc func setName() {
        getUsers()
    }
    
    
    private func getUsers() {
        let users = realm.objects(User.self)
        
        self.users = users.map({ user in
            user
        })
    }
    
    private func deleteUser(_ user: User) {
        try! realm.write {
            realm.delete(user)
        }
    }
    
    private func updateUserName(to name: String?, to surname: String?, to password: String?, at index: Int) {
        
        let user = realm.objects(User.self)[index]
        
        try! realm.write ({
            if let name = name, !name.isEmpty {
                user.name = name
            }
            if let surname = surname, !surname.isEmpty {
                user.surname = surname
            }
            if let password = password, !password.isEmpty {
                user.password = password
            }
        })

    }
    
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let user = users[indexPath.row]
            cell.textLabel?.text = "\(user.name) \(user.surname) \(user.password)"

        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (_, _, completionHandler) in
            self?.editUser(at: indexPath)
            completionHandler(true)
        }
        editAction.backgroundColor = .blue
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            self?.deleteUser(at: indexPath)
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    

    private func editUser(at indexPath: IndexPath) {
        updateUserName(to: name.text ?? "", to: surname.text ?? "", to: password.text ?? "", at: indexPath.row)

        name.text = ""
        surname.text = ""
        password.text = ""
        getUsers()

    }
    
    private func deleteUser(at indexPath: IndexPath) {
        let user = users[indexPath.row]
        deleteUser(user)
        getUsers()
        
    }
}
