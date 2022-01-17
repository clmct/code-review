//
//  PeopleFlowViewController.swift
//  ITindr
//
//  Created by Эдуард Логинов on 17.10.2021.
//

import UIKit
import SnapKit
import TPKeyboardAvoiding

class PeopleFlowViewController: BaseViewController {
    
    // MARK: Properties
    private let viewModel: PeopleFlowViewModel
    
    private let appLogoImageView = UIImageView(image: UIImage(named: ImageNames.appLogo))
    private let scrollView = TPKeyboardAvoidingScrollView()
    private let userCardView = UserCardView()
    private let declineButton = SolidButton(Strings.decline, icon: UIImage(named: ImageNames.crossIcon))
    private let likeButton = GradientButton(Strings.like, icon: UIImage(named: ImageNames.heartIcon))
    private let placeholder = UILabel()
    
    // MARK: Init
    init(networkManager: NetworkService) {
        viewModel = PeopleFlowViewModel(networkManager: networkManager)
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
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.start()
    }
    
    // MARK: Public Methods
    override func bindToViewModel() {
        super.bindToViewModel()
        
        viewModel.didHidePlaceholder = { [weak self] hidden in
            self?.shouldHidePlaceholder(isHidden: hidden)
        }
        
        viewModel.didMatch = { [weak self] userId, networkManager in
            let matchViewController = MatchViewController(
                userId: userId,
                networkManager: networkManager,
                tabController: self?.tabBarController)
            self?.tabBarController?.present(matchViewController, animated: true)
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
    
    // MARK: Private Hiding Placeholder Method
    private func shouldHidePlaceholder(isHidden: Bool) {
        placeholder.isHidden = isHidden
        userCardView.isHidden = !isHidden
        declineButton.isHidden = !isHidden
        likeButton.isHidden = !isHidden
    }
    
    // MARK: Private Setup Methods
    private func setup() {
        setupView()
        setupAppLogoImageView()
        setupScrollView()
        setupUserCardView()
        setupDeclineButton()
        setupLikeButton()
        setupPlaceholder()
    }
    
    private func setupView() {
        setupBackButton(text: Strings.back, font: .mediumLabel, color: Colors.white)
        view.backgroundColor = Colors.white
        view.addSubview(appLogoImageView)
        view.addSubview(scrollView)
        scrollView.addSubview(userCardView)
        view.addSubview(declineButton)
        view.addSubview(likeButton)
        view.addSubview(placeholder)
    }
    
    private func setupAppLogoImageView() {
        appLogoImageView.contentMode = .scaleAspectFit
        appLogoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(Dimensions.defaultInset)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupScrollView() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(appLogoImageView.snp.bottom)
            make.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
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
    
    private func setupPlaceholder() {
        placeholder.text = Strings.peopleFlowPlaceholder
        placeholder.textColor = Colors.pink
        placeholder.font = .largerLabelBold
        placeholder.numberOfLines = 0
        placeholder.textAlignment = .center
        placeholder.isHidden = true
        placeholder.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Dimensions.defaultInset)
            make.centerY.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
