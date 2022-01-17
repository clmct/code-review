//
//  PeopleViewController.swift
//  ITindr
//
//  Created by Эдуард Логинов on 15.11.2021.
//

import UIKit
import SnapKit

class PeopleViewController: BaseViewController {
    
    // MARK: Properties
    private let viewModel: PeopleViewModel
    private let peopleCollectionView = PeopleCollectionView()
    
    private var peopleCollectionViewLayout: PeopleCollectionViewLayout {
        let layout = PeopleCollectionViewLayout()
        layout.centerColumnTopOffset = Dimensions.largeInset
        layout.minimumInteritemSpacing = Dimensions.defaultInset
        layout.minimumLineSpacing = Dimensions.lineSpacing
        return layout
    }
    
    // MARK: Init
    init(networkManager: NetworkService) {
        viewModel = PeopleViewModel(networkManager: networkManager)
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToViewModel()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getPeople()
    }
    
    // MARK: Public Methods
    override func bindToViewModel() {
        super.bindToViewModel()
        
        viewModel.didRecievePeople = { [weak self] in
            self?.peopleCollectionView.reloadData()
        }
        
        viewModel.didTapUserCell = { [weak self] networkManager, user in
            self?.navigationController?.pushViewController(
                UserViewController(networkManager: networkManager, user: user),
                animated: true)
        }
    }
    
    // MARK: Private Setup Methods
    private func setup() {
        setupView()
        setupPeopleCollectionView()
    }
    
    private func setupView() {
        setupBackButton()
        navigationItem.title = Strings.people
        view.backgroundColor = Colors.white
        view.addSubview(peopleCollectionView)
    }
    
    private func setupPeopleCollectionView() {
        peopleCollectionView.contentInset = UIEdgeInsets(
            top: Dimensions.defaultInset,
            left: Dimensions.defaultInset,
            bottom: 0,
            right: Dimensions.defaultInset)
        peopleCollectionView.collectionViewLayout = peopleCollectionViewLayout
        peopleCollectionView.delegate = self
        peopleCollectionView.dataSource = self
        peopleCollectionView.register(PeopleCollectionViewCell.self, forCellWithReuseIdentifier: ReuseIdentifiers.peopleCell)
        peopleCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension PeopleViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.peopleCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let peopleCell = peopleCollectionView.dequeueReusableCell(
            withReuseIdentifier: ReuseIdentifiers.peopleCell,
            for: indexPath) as? PeopleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let cellViewModel = viewModel.getPeopleViewModel(index: indexPath.item)
        peopleCell.configure(with: cellViewModel)
        cellViewModel.start()
        return peopleCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.userCellTap(index: indexPath.item)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let distanceFromBottom = scrollView.contentSize.height - scrollView.contentOffset.y
        viewModel.getPeopleIfExists(distanceFromBottom: distanceFromBottom, frameHeight: height)
    }
}

// MARK: Dimensions
private extension Dimensions {
    static let lineSpacing: CGFloat = 24
}
