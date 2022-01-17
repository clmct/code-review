//
//  UpdateUserProfileViewController.swift
//  ITindr
//
//  Created by Эдуард Логинов on 27.10.2021.
//

import UIKit
import TPKeyboardAvoiding

class UpdateUserProfileViewController: ImagePickingController {
    
    // MARK: Properties
    let scrollView = TPKeyboardAvoidingScrollView()
    let editUserCardView = EditUserCardView()
    let saveButton = GradientButton(Strings.save)
    
    private let viewModel: UpdateUserProfileViewModel
    
    // MARK: Init
    init(networkManager: NetworkService?,
         user: User? = nil,
         aboutHeader: String?,
         topicsHeader: String?) {
        viewModel = UpdateUserProfileViewModel(
            networkManager: networkManager ?? NetworkService(defaultsManager: UserDefaultsManager()),
            user: user,
            aboutHeader: aboutHeader,
            topicsHeader: topicsHeader)
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToViewModel()
        editUserCardView.configure(with: viewModel.editUserCardViewModel)
        viewModel.start()
        setup()
    }
    
    // MARK: Public Overrided Methods
    override func imageSelected(_ image: UIImage) {
        viewModel.setAvatar(image)
    }
    
    override func bindToViewModel() {
        super.bindToViewModel()
        
        viewModel.didCompleteUpdating = { [weak self] networkManager in
            self?.onUpdatingComplete(networkManager: networkManager)
        }
        
        viewModel.didTapChooseAvatar = { [weak self] in
            self?.chooseImage()
        }
    }
    
    // MARK: Public Methods
    func setup() {
        setupView()
        setupSaveButton()
    }
    
    func onUpdatingComplete(networkManager: NetworkService?) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Actions
    @objc private func saveUser() {
        viewModel.saveUpdatedUser()
    }
    
    // MARK: Private Setup Methods
    private func setupView() {
        view.backgroundColor = Colors.white
        view.addSubview(scrollView)
        view.addSubview(saveButton)
        scrollView.addSubview(editUserCardView)
    }
    
    private func setupSaveButton() {
        saveButton.addTarget(self, action: #selector(saveUser), for: .touchUpInside)
    }
}
