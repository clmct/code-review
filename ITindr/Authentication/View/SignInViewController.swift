//
//  SignInViewController.swift
//  ITindr
//
//  Created by Эдуард Логинов on 11.10.2021.
//

import UIKit
import SnapKit

class SignInViewController: BaseViewController {
    
    // MARK: Properties
    private let viewModel: SignInViewModel
    private let authView = AuthView()
    
    // MARK: Init
    init(networkManager: NetworkService) {
        viewModel = SignInViewModel(networkManager: networkManager)
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToViewModel()
        authView.configure(with: viewModel.authViewModel)
        viewModel.start()
        setup()
    }
    
    // MARK: Public Methods
    override func bindToViewModel() {
        super.bindToViewModel()
        
        viewModel.didSignIn = { [weak self] networkManager in
            self?.navigationController?.setViewControllers(
                [TabBarViewController(networkManager: networkManager)],
                animated: true)
        }
        
        viewModel.didTapBack = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: Private Setup Methods
    private func setup() {
        setupView()
        setupAuthView()
    }
    
    private func setupView() {
        view.backgroundColor = Colors.white
        view.addSubview(authView)
    }
    
    private func setupAuthView() {
        authView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
