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

// MARK: - Constants

fileprivate enum Layout {
    static let standardMargin: CGFloat = 16
    static let textFieldHeight: CGFloat = 50
    static let buttonHeight: CGFloat = 50
    static let buttonCornerRadius: CGFloat = 16
    static let stackViewSpacing: CGFloat = 20
    static let stackViewTopMargin: CGFloat = 100
}

fileprivate enum Typography {
    static let buttonFont = UIFont.systemFont(ofSize: 16, weight: .medium)
}

fileprivate enum Colors {
    static let buttonBackgroundColor = UIColor.systemGreen
    static let buttonTextColor = UIColor.white
    static let viewBackgroundColor = UIColor.systemBackground
}

fileprivate enum UI {
    static let namePlaceholder = "Name"
    static let surnamePlaceholder = "Surname"
    static let emailPlaceholder = "Email"
    static let passwordPlaceholder = "Password"
    static let signUpButtonTitle = "Sign Up"
    static let backToLoginButtonTitle = "Back to Login"
    static let errorAlertTitle = "Error"
    static let errorAlertButtonTitle = "OK"
    static let successAlertTitle = "Success"
    static let successAlertButtonTitle = "OK"
}

protocol SignUpViewDelegate: AnyObject {
    func showLoading(_ show: Bool)
    func showError(_ message: String)
    func showSuccess(_ user: User)
}

// MARK: - SignUpViewController

final class SignUpViewController: UIViewController {
    
    private let viewModel: SignUpViewModelDelegate
    
    private let nameTextField: UITextField = {
        let nameTextField = UITextField()
        nameTextField.placeholder = UI.namePlaceholder
        nameTextField.borderStyle = .none
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.accessibilityIdentifier = "SignUpViewController.nameTextField"
        return nameTextField
    }()
    private let surnameTextField: UITextField = {
        let surnameTextField = UITextField()
        surnameTextField.placeholder = UI.surnamePlaceholder
        surnameTextField.borderStyle = .none
        surnameTextField.translatesAutoresizingMaskIntoConstraints = false
        surnameTextField.accessibilityIdentifier = "SignUpViewController.surnameTextField"
        return surnameTextField
    }()
    
    private let emailTextField: UITextField = {
        let emailTextField = UITextField()
        emailTextField.placeholder = UI.emailPlaceholder
        emailTextField.borderStyle = .none
        emailTextField.autocapitalizationType = .none
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.accessibilityIdentifier = "SignUpViewController.emailTextField"
        return emailTextField
    }()
    
    private let passwordTextField: UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.placeholder = UI.passwordPlaceholder
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
        passwordTextField.accessibilityIdentifier = "SignUpViewController.passwordTextField"
        return passwordTextField
    }()
    
    private let signUpButton: UIButton = {
        let signUpButton = UIButton()
        signUpButton.setTitle(UI.signUpButtonTitle, for: .normal)
        signUpButton.setTitleColor(Colors.buttonTextColor, for: .normal)
        signUpButton.backgroundColor = Colors.buttonBackgroundColor
        signUpButton.layer.cornerRadius = Layout.buttonCornerRadius
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.accessibilityIdentifier = "SignUpViewController.signUpButton"
        return signUpButton
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.accessibilityIdentifier = "SignUpViewController.activityIndicator"
        return activityIndicator
    }()
    
    init(viewModel: SignUpViewModelDelegate) {
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
        
        view.backgroundColor = Colors.viewBackgroundColor
        
        [nameTextField, surnameTextField, emailTextField, passwordTextField, signUpButton, activityIndicator].forEach {view.addSubview($0)}
        
        NSLayoutConstraint.activate([
            nameTextField.leftAnchor.constraint(equalTo: view.leftAnchor,constant: Layout.standardMargin),
            nameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -94),
            nameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5, constant: -Layout.standardMargin)
        ])
        
        NSLayoutConstraint.activate([
            surnameTextField.leftAnchor.constraint(equalTo: nameTextField.rightAnchor,constant: Layout.standardMargin),
            surnameTextField.topAnchor.constraint(equalTo: nameTextField.topAnchor),
            surnameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -Layout.standardMargin)
        ])
        
        NSLayoutConstraint.activate([
            emailTextField.leftAnchor.constraint(equalTo: view.leftAnchor,constant: Layout.standardMargin),
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 32),
            emailTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -Layout.standardMargin)
        ])
        
        NSLayoutConstraint.activate([
            passwordTextField.leftAnchor.constraint(equalTo: view.leftAnchor,constant: Layout.standardMargin),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 32),
            passwordTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -Layout.standardMargin)
        ])
        
        NSLayoutConstraint.activate([
            signUpButton.leftAnchor.constraint(equalTo: view.leftAnchor,constant: Layout.standardMargin),
            signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 64),
            signUpButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -Layout.standardMargin)
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

// MARK: - SignUpViewDelegate

extension SignUpViewController: SignUpViewDelegate {
    func showLoading(_ show: Bool) {
        show ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        self.signUpButton.isEnabled = !show
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: UI.errorAlertTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: UI.errorAlertButtonTitle, style: .default))
        self.present(alert, animated: true)
    }

    func showSuccess(_ user: User) {
        let alert = UIAlertController(title: UI.successAlertTitle, message: "Account created for \(user.email ?? "")", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: UI.successAlertButtonTitle, style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        })
        self.present(alert, animated: true)
    }
}
