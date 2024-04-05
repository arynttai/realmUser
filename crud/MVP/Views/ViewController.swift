import UIKit
import RealmSwift
import SnapKit

protocol UserView {
    func getUsers(_ users: Results<User>)
    func deleteUser(_ user: User)
    func updateUserName(to name: String?, to surname: String?, to password: String?, at index: Int)
}

class ViewController: UIViewController {
    let realm = try! Realm()
    var presenter: UserPresenter?

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
        tableView.delegate = self
        tableView.dataSource = self
        presenter?.viewDidLoad()
        presenter?.getUsers()
        setupViews()
        view.backgroundColor = .white
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

        presenter?.buttonTap()
    }
}

extension ViewController: UserView {
    func getUsers(_ users: Results<User>) {
        self.users = Array(users)
        tableView.reloadData()
    }

    func deleteUser(_ user: User) {
        presenter?.deleteUs(user)
    }

    func updateUserName(to name: String?, to surname: String?, to password: String?, at index: Int) {
        presenter?.updateUs(to: name, to: surname, to: password, at: index)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
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

    private func deleteUser(at indexPath: IndexPath) {
        let user = users[indexPath.row]
        presenter?.deleteUs(user)
    }

    private func editUser(at indexPath: IndexPath) {
        updateUserName(to: name.text, to: surname.text, to: password.text, at: indexPath.row)
        presenter?.updateUs(to: name.text, to: surname.text, to: password.text, at: indexPath.row)
    }
}
