//
//  SignUpViewController.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 15.10.2025.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth

protocol SignUpViewProtocol: AnyObject {
    func showLoading(_ show: Bool)
    func showError(_ message: String)
    func showSuccess(_ user: User)
}


final class SignUpViewController: UIViewController {
    
    private let viewModel: SignUpViewModelProtocol
    
    private let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.borderStyle = .none
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    private let surnameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Surname"
        tf.borderStyle = .none
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.borderStyle = .none
        tf.autocapitalizationType = .none
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.borderStyle = .none
        tf.autocapitalizationType = .none
        tf.isSecureTextEntry = true
        tf.textContentType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.smartQuotesType = .no
        tf.smartDashesType = .no
        tf.smartInsertDeleteType = .no
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let signUpButton: UIButton = {
        let bt = UIButton()
        bt.setTitle("Sign Up", for: .normal)
        bt.setTitleColor(.white, for: .normal)
        bt.backgroundColor = .systemGreen
        bt.layer.cornerRadius = 16
        bt.translatesAutoresizingMaskIntoConstraints = false
        return bt
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .medium)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.hidesWhenStopped = true
        return ai
    }()
    
    init(viewModel: SignUpViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.view = self
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupActions()
        
    }
    
    private func setupViews(){
        
        view.backgroundColor = .white
        
        [nameTextField, surnameTextField, emailTextField, passwordTextField, signUpButton, activityIndicator].forEach {view.addSubview($0)}
        
        NSLayoutConstraint.activate([
            nameTextField.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 16),
            nameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -94),
            nameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            surnameTextField.leftAnchor.constraint(equalTo: nameTextField.rightAnchor,constant: 16),
            surnameTextField.topAnchor.constraint(equalTo: nameTextField.topAnchor),
            surnameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            emailTextField.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 16),
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 32),
            emailTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            passwordTextField.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 16),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 32),
            passwordTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            signUpButton.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 16),
            signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 64),
            signUpButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        nameTextField.updateBottomBorderFrame()
        surnameTextField.updateBottomBorderFrame()
        emailTextField.updateBottomBorderFrame()
        passwordTextField.updateBottomBorderFrame()
        
        nameTextField.addBottomBorder()
        surnameTextField.addBottomBorder()
        emailTextField.addBottomBorder()
        passwordTextField.addBottomBorder()
    }
    
    private func setupActions() {
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
    }

    @objc private func signUpTapped() {
        let name = nameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        viewModel.signUp(name: name, email: email, password: password)
    }


}

extension SignUpViewController: SignUpViewProtocol {
    func showLoading(_ show: Bool) {
        show ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        self.signUpButton.isEnabled = !show
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }

    func showSuccess(_ user: User) {
        let alert = UIAlertController(title: "Success", message: "Account created for \(user.email ?? "")", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        })
        self.present(alert, animated: true)
    }
}
