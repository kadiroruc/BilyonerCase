//
//  LoginViewController.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 15.10.2025.
//
import UIKit
import FirebaseAuth

protocol LoginViewProtocol: AnyObject {
    func showLoading(_ show: Bool)
    func showError(_ message: String)
    func showSuccess(_ user: User)
}

final class LoginViewController: UIViewController {

    private let viewModel: LoginViewModelProtocol

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
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocapitalizationType = .none
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        return passwordTextField
    }()

    private let loginButton: UIButton = {
        let loginButton = UIButton(type: .system)
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = .systemGreen
        loginButton.layer.cornerRadius = 16
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        return loginButton
    }()
    
    private let noAccountLabel: UILabel = {
        let noAccountLabel = UILabel()
        noAccountLabel.text = "No account? Sign up"
        noAccountLabel.textColor = .systemGreen
        noAccountLabel.textAlignment = .center
        noAccountLabel.translatesAutoresizingMaskIntoConstraints = false
        return noAccountLabel
    }()

    private let toSignUpButton: UIButton = {
        let toSignUpButton = UIButton(type: .system)
        toSignUpButton.setTitle("Sign Up Now", for: .normal)
        toSignUpButton.setTitleColor(.white, for: .normal)
        toSignUpButton.backgroundColor = .systemGreen
        toSignUpButton.layer.cornerRadius = 16
        toSignUpButton.translatesAutoresizingMaskIntoConstraints = false
        return toSignUpButton
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()

    init(viewModel: LoginViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.view = self
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        emailTextField.updateBottomBorderFrame()
        passwordTextField.updateBottomBorderFrame()
        
        emailTextField.addBottomBorder()
        passwordTextField.addBottomBorder()
    }


    private func setupUI() {
        view.backgroundColor = .white
        
        [emailTextField,
         passwordTextField,
         loginButton,
         noAccountLabel,
         toSignUpButton,
         activityIndicator
        ].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            emailTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -79),
            emailTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            passwordTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 32),
            passwordTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            loginButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 64),
            loginButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            noAccountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noAccountLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -128),
            noAccountLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6)
        ])
        
        NSLayoutConstraint.activate([
            toSignUpButton.centerXAnchor.constraint(equalTo: noAccountLabel.centerXAnchor),
            toSignUpButton.topAnchor.constraint(equalTo: noAccountLabel.bottomAnchor, constant: 32),
            toSignUpButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3)
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setupActions() {
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        toSignUpButton.addTarget(self, action: #selector(toSignUpTapped), for: .touchUpInside)
    }

    @objc private func loginTapped() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        viewModel.login(email: email, password: password)
    }

    @objc private func toSignUpTapped() {
        let signUpVM = SignUpViewModel(authService: AuthService())
        let signUpVC = SignUpViewController(viewModel: signUpVM)
        navigationController?.pushViewController(signUpVC, animated: true)
    }

    private func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - LoginViewProtocol
extension LoginViewController: LoginViewProtocol {
    func showLoading(_ show: Bool) {
        show ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        self.loginButton.isEnabled = !show
        self.loginButton.alpha = show ? 0.5 : 1.0
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }

    func showSuccess(_ user: User) {
        let alert = UIAlertController(title: "Success", message: "Welcome, \(user.email ?? "")!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
