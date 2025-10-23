//
//  LoginViewController.swift
//  BilyonerCase
//
//  Created by Abdulkadir Oruç on 15.10.2025.
//
import UIKit
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
    static let emailPlaceholder = "Email"
    static let passwordPlaceholder = "Password"
    static let loginButtonTitle = "Login"
    static let signUpButtonTitle = "Sign Up"
    static let errorAlertTitle = "Error"
    static let errorAlertButtonTitle = "OK"
}

protocol LoginViewDelegate: AnyObject {
    func showLoading(_ show: Bool)
    func showError(_ message: String)
    func showSuccess(_ user: User)
}

final class LoginViewController: UIViewController {

    private let viewModel: LoginViewModelDelegate

    private let emailTextField: UITextField = {
        let emailTextField = UITextField()
        emailTextField.placeholder = UI.emailPlaceholder
        emailTextField.borderStyle = .none
        emailTextField.autocapitalizationType = .none
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.accessibilityIdentifier = "LoginViewController.emailTextField"
        return emailTextField
    }()

    private let passwordTextField: UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.placeholder = UI.passwordPlaceholder
        passwordTextField.borderStyle = .none
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocapitalizationType = .none
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.accessibilityIdentifier = "LoginViewController.passwordTextField"
        return passwordTextField
    }()

    private let loginButton: UIButton = {
        let loginButton = UIButton(type: .system)
        loginButton.setTitle(UI.loginButtonTitle, for: .normal)
        loginButton.setTitleColor(Colors.buttonTextColor, for: .normal)
        loginButton.backgroundColor = Colors.buttonBackgroundColor
        loginButton.layer.cornerRadius = Layout.buttonCornerRadius
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.accessibilityIdentifier = "LoginViewController.loginButton"
        return loginButton
    }()
    
    private let noAccountLabel: UILabel = {
        let noAccountLabel = UILabel()
        noAccountLabel.text = "No account? Sign up"
        noAccountLabel.textColor = .systemGreen
        noAccountLabel.textAlignment = .center
        noAccountLabel.translatesAutoresizingMaskIntoConstraints = false
        noAccountLabel.accessibilityIdentifier = "LoginViewController.noAccountLabel"
        return noAccountLabel
    }()

    private let toSignUpButton: UIButton = {
        let toSignUpButton = UIButton(type: .system)
        toSignUpButton.setTitle(UI.signUpButtonTitle, for: .normal)
        toSignUpButton.setTitleColor(Colors.buttonTextColor, for: .normal)
        toSignUpButton.backgroundColor = Colors.buttonBackgroundColor
        toSignUpButton.layer.cornerRadius = Layout.buttonCornerRadius
        toSignUpButton.translatesAutoresizingMaskIntoConstraints = false
        toSignUpButton.accessibilityIdentifier = "LoginViewController.toSignUpButton"
        return toSignUpButton
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.accessibilityIdentifier = "LoginViewController.activityIndicator"
        return activityIndicator
    }()

    init(viewModel: LoginViewModelDelegate) {
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
        view.backgroundColor = Colors.viewBackgroundColor
        
        [emailTextField,
         passwordTextField,
         loginButton,
         noAccountLabel,
         toSignUpButton,
         activityIndicator
        ].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            emailTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Layout.standardMargin),
            emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -79),
            emailTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -Layout.standardMargin)
        ])
        
        NSLayoutConstraint.activate([
            passwordTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Layout.standardMargin),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 32),
            passwordTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -Layout.standardMargin)
        ])
        
        NSLayoutConstraint.activate([
            loginButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Layout.standardMargin),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 64),
            loginButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -Layout.standardMargin)
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

// MARK: - LoginViewDelegate
extension LoginViewController: LoginViewDelegate {
    func showLoading(_ show: Bool) {
        show ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        self.loginButton.isEnabled = !show
        self.loginButton.alpha = show ? 0.5 : 1.0
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: UI.errorAlertTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: UI.errorAlertButtonTitle, style: .default))
        self.present(alert, animated: true)
    }

    func showSuccess(_ user: User) {
        let alert = UIAlertController(title: "Success", message: "Welcome, \(user.email ?? "")!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
