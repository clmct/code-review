//
//  AboutYourselfViewController.swift
//  ITindr
//
//  Created by Эдуард Логинов on 11.10.2021.
//

import UIKit
import SnapKit

class AboutYourselfViewController: UpdateUserProfileViewController {
    
    // MARK: Properties
    private let appLogoImageView = UIImageView(image: UIImage(named: ImageNames.appLogo))
    
    // MARK: Init
    init(networkManager: NetworkService?, user: User? = nil) {
        super.init(networkManager: networkManager,
                   user: user,
                   aboutHeader: Strings.aboutYourselfHeader,
                   topicsHeader: Strings.aboutYourselfTopicsHeader)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    // MARK: Public Overrided Methods
    override func setup() {
        super.setup()
        setupView()
        setupAppLogoImageView()
        setupScrollView()
        setupEditUserCardView()
        setupSaveButton()
    }
    
    override func onUpdatingComplete(networkManager: NetworkService?) {
        navigationController?.setViewControllers(
            [TabBarViewController(networkManager: networkManager)],
            animated: true)
    }
    
    // MARK: Private Setup Methods
    private func setupView() {
        view.addSubview(appLogoImageView)
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
    
    private func setupEditUserCardView() {
        editUserCardView.snp.makeConstraints { make in
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
    
    private func setupSaveButton() {
        saveButton.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Dimensions.defaultInset)
            make.height.equalTo(Dimensions.defaultHeight)
        }
    }
}
