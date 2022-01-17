//
//  ProfileViewController.swift
//  ITindr
//
//  Created by Эдуард Логинов on 27.10.2021.
//

import UIKit
import SnapKit
import TPKeyboardAvoiding

class ProfileViewController: BaseViewController {
    
    // MARK: Properties
    private let viewModel: ProfileViewModel
    
    private let scrollView = TPKeyboardAvoidingScrollView()
    private let userCardView = UserCardView()
    private let editButton = SolidButton(Strings.edit, icon: UIImage(named: ImageNames.editIcon))
    
    // MARK: Init
    init(networkManager: NetworkService) {
        viewModel = ProfileViewModel(networkManager: networkManager)
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToViewModel()
        userCardView.configure(with: viewModel.userCardViewModel)
        viewModel.start()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getUserProfileInfo()
    }
    
    // MARK: Public Methods
    override func bindToViewModel() {
        super.bindToViewModel()
        
        viewModel.didTapEditUser = { [weak self] networkManager, userData in
            self?.setupBackButton()
            self?.navigationController?.pushViewController(
                EditProfileViewController(networkManager: networkManager, user: userData),
                animated: true)
        }
        
        viewModel.didTapUserCard = { [weak self] user in
            self?.setupBackButton(text: Strings.back, font: .mediumLabel, color: Colors.white)
            self?.navigationController?.pushViewController(
                AboutUserViewController(withUser: user),
                animated: true)
        }
    }
    
    // MARK: Actions
    @objc private func navigateEditUser() {
        viewModel.userEditTap()
    }
    
    // MARK: Private Setup Methods
    private func setup() {
        setupView()
        setupScrollView()
        setupUserCardView()
        setupEditButton()
    }
    
    private func setupView() {
        navigationItem.title = Strings.profile
        view.backgroundColor = Colors.white
        view.addSubview(scrollView)
        view.addSubview(editButton)
        scrollView.addSubview(userCardView)
    }
    
    private func setupScrollView() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupUserCardView() {
        userCardView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
                .inset(UIEdgeInsets(
                    top: Dimensions.mediumPlusInset,
                    left: Dimensions.defaultInset,
                    bottom: Dimensions.largerInset,
                    right: -Dimensions.defaultInset))
            make.centerX.equalTo(scrollView)
            make.width.equalTo(scrollView.frameLayoutGuide).priority(750)
            make.height.equalTo(0).priority(500)
        }
    }
    
    private func setupEditButton() {
        editButton.addTarget(self, action: #selector(navigateEditUser), for: .touchUpInside)
        editButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Dimensions.defaultInset)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(Dimensions.editButtonWidthMultiplier)
            make.height.equalTo(Dimensions.defaultHeight)
        }
    }
}

// MARK: Dimensions
private extension Dimensions {
    static let editButtonWidthMultiplier: CGFloat = 0.6107
}
