//
//  UserViewController.swift
//  ITindr
//
//  Created by Эдуард Логинов on 01.12.2021.
//

import UIKit
import SnapKit
import TPKeyboardAvoiding

class UserViewController: BaseViewController {
    
    // MARK: Properties
    private let viewModel: UserViewModel
    
    private let scrollView = TPKeyboardAvoidingScrollView()
    private let userCardView = UserCardView()
    private let declineButton = SolidButton(Strings.decline, icon: UIImage(named: ImageNames.crossIcon))
    private let likeButton = GradientButton(Strings.like, icon: UIImage(named: ImageNames.heartIcon))
    
    // MARK: Init
    init(networkManager: NetworkService, user: User) {
        viewModel = UserViewModel(networkManager: networkManager, user: user)
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
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: Public Methods
    override func bindToViewModel() {
        super.bindToViewModel()
        
        viewModel.didFinishRequest = { [weak self] in
            self?.enableUserInteraction()
            self?.navigationController?.popViewController(animated: true)
        }
        
        viewModel.didMatch = { [weak self] userId, networkManager in
            let matchViewController = MatchViewController(
                userId: userId,
                networkManager: networkManager,
                tabController: self?.tabBarController)
            self?.tabBarController?.present(matchViewController, animated: true)
            self?.enableUserInteraction()
        }
        
        viewModel.didTapUserCard = { [weak self] user in
            let aboutUserVC = AboutUserViewController(withUser: user)
            self?.navigationController?.pushViewController(aboutUserVC, animated: true)
        }
    }
    
    // MARK: Actions
    @objc private func likeUser() {
        viewModel.likeUser()
    }
    
    @objc private func dislikeUser() {
        viewModel.dislikeUser()
    }
    
    // MARK: Private Setup Methods
    private func setup() {
        setupView()
        setupScrollView()
        setupUserCardView()
        setupDeclineButton()
        setupLikeButton()
    }
    
    private func setupView() {
        setupBackButton(text: Strings.back, font: .mediumLabel, color: Colors.white)
        navigationItem.title = Strings.profile
        view.backgroundColor = Colors.white
        view.addSubview(scrollView)
        scrollView.addSubview(userCardView)
        view.addSubview(declineButton)
        view.addSubview(likeButton)
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
                    top: Dimensions.mediumInset,
                    left: Dimensions.defaultInset,
                    bottom: Dimensions.largerInset,
                    right: -Dimensions.defaultInset))
            make.centerX.equalTo(scrollView)
            make.width.equalTo(scrollView.frameLayoutGuide).priority(750)
            make.height.equalTo(0).priority(500)
        }
    }
    
    private func setupDeclineButton() {
        declineButton.addTarget(self, action: #selector(dislikeUser), for: .touchUpInside)
        declineButton.snp.makeConstraints { make in
            make.bottom.leading.equalTo(view.safeAreaLayoutGuide).inset(Dimensions.defaultInset)
            make.trailing.equalTo(likeButton.snp.leading).inset(-Dimensions.defaultInset)
            make.width.equalTo(likeButton)
            make.height.equalTo(Dimensions.defaultHeight)
        }
    }
    
    private func setupLikeButton() {
        likeButton.addTarget(self, action: #selector(likeUser), for: .touchUpInside)
        likeButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(Dimensions.defaultInset)
            make.centerY.equalTo(declineButton)
            make.height.equalTo(declineButton)
        }
    }
}
