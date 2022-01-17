//
//  AboutUserViewController.swift
//  ITindr
//
//  Created by Эдуард Логинов on 15.11.2021.
//

import UIKit
import SnapKit

class AboutUserViewController: UIViewController {
    
    // MARK: Properties
    private let viewModel: AboutUserViewModel
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let aboutLabel = UILabel()
    private let topicsListView = TopicListView()
    
    private lazy var shadowGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.colors = [
            Colors.blackBackground?.cgColor ?? UIColor.black.cgColor,
            Colors.transparent.cgColor,
            Colors.transparent.cgColor,
            Colors.blackBackground?.cgColor ?? UIColor.black.cgColor
        ]
        gradient.locations = [
            0,
            Dimensions.shadowTopLocationEnd,
            Dimensions.shadowBottomLocationStart,
            1]
        view.layer.insertSublayer(gradient, at: 1)
        return gradient
    }()

    // MARK: Init
    init(withUser user: User) {
        self.viewModel = AboutUserViewModel(with: user)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToViewModel()
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        shadowGradient.frame = view.bounds
    }
    
    // MARK: Private Setup Methods
    private func bindToViewModel() {
        viewModel.didUpdateUser = { [weak self] in
            self?.updateUserInfo()
        }
    }
    
    private func updateUserInfo() {
        nameLabel.text = viewModel.name
        aboutLabel.text = viewModel.about
        topicsListView.addTags(viewModel.topicTitles ?? [])
        avatarImageView.image = viewModel.avatar
    }
    
    private func setup() {
        setupView()
        setupAvatarImageView()
        setupNameLabel()
        setupAboutLabel()
        setupTopicsListView()
    }
    
    private func setupView() {
        view.backgroundColor = Colors.white
        view.addSubview(avatarImageView)
        view.addSubview(nameLabel)
        view.addSubview(aboutLabel)
        view.addSubview(topicsListView)
    }
    
    private func setupAvatarImageView() {
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.masksToBounds = true
        avatarImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupNameLabel() {
        nameLabel.font = .largeLabelBold
        nameLabel.textColor = Colors.white
        nameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(aboutLabel.snp.top).inset(-Dimensions.smallInset)
            make.leading.trailing.equalToSuperview().inset(Dimensions.defaultInset)
        }
    }
    
    private func setupAboutLabel() {
        aboutLabel.font = .defaultLabel
        aboutLabel.textColor = Colors.white
        aboutLabel.numberOfLines = 2
        aboutLabel.snp.makeConstraints { make in
            make.bottom.equalTo(topicsListView.snp.top).inset(-Dimensions.defaultInset)
            make.leading.trailing.equalToSuperview().inset(Dimensions.defaultInset)
        }
    }
    
    private func setupTopicsListView() {
        topicsListView.backgroundColor = Colors.transparent
        topicsListView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Dimensions.topicsBottomInset)
            make.leading.trailing.equalToSuperview().inset(Dimensions.defaultInset)
        }
    }
}

// MARK: Dimensions
private extension Dimensions {
    static let shadowTopLocationEnd: NSNumber = 0.1576
    static let shadowBottomLocationStart: NSNumber = 0.7635
    static let topicsBottomInset: CGFloat = 6
}
