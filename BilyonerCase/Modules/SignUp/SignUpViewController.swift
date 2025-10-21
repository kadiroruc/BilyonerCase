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
        let nameTextField = UITextField()
        nameTextField.placeholder = "Name"
        nameTextField.borderStyle = .none
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        return nameTextField
    }()
    private let surnameTextField: UITextField = {
        let surnameTextField = UITextField()
        surnameTextField.placeholder = "Surname"
        surnameTextField.borderStyle = .none
        surnameTextField.translatesAutoresizingMaskIntoConstraints = false
        return surnameTextField
    }()
    
    private let emailTextField: UITextField = {
        let emailTextField = UITextField()
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .none
        emailTextField.autocapitalizationType = .none
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        return emailTextField
    }()
    
    private let passwordTextField: UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .none
        passwordTextField.autocapitalizationType = .none
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .none
        passwordTextField.autocorrectionType = .no
        passwordTextField.spellCheckingType = .no
        passwordTextField.smartQuotesType = .no
        passwordTextField.smartDashesType = .no
        passwordTextField.smartInsertDeleteType = .no
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        return passwordTextField
    }()
    
    private let signUpButton: UIButton = {
        let signUpButton = UIButton()
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.backgroundColor = .systemGreen
        signUpButton.layer.cornerRadius = 16
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        return signUpButton
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
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
