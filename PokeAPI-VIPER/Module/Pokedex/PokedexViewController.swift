//
//  PokedexViewController.swift
//  PokeAPI-VIPER
//
//  Created by alif rama on 17/09/25.
//

import RxCocoa
import RxDataSources
import RxSwift
import SnapKit
import UIKit

final class PokedexViewController: UIViewController {
    
    // MARK: - Accessable
    
    var presenter: PokedexPresenterProtocol?
    
    // MARK: - Private
    
    private let disposeBag = DisposeBag()
    
    private let imageHeader: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "pokeball")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        return imageView
    }()
    
    private let labelHeader: UILabel = {
        let label = UILabel()
        label.font = FontUtils.headerHeadline
        label.textColor = .white
        label.textAlignment = .left
        label.text = "Pokédex"
        return label
    }()
    
    private let searchBox: SearchBox = {
        let searchBox = SearchBox()
        searchBox.translatesAutoresizingMaskIntoConstraints = false
        return searchBox
    }()
    
    private let sortButton: SortButton = {
        let sortButton = SortButton()
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        return sortButton
    }()
    
    private let container: UIView = {
        let container: UIView = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .white
        container.layer.cornerRadius = 8
        container.clipsToBounds = true
        return container
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PokemonCardCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    private let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfPokedex>(
        configureCell: { _, collectionView, indexPath, item in
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PokemonCardCell {
                cell.configContent(with: item)
                return cell
            }
            return UICollectionViewCell()
        }
    )
    
    private func setupHeader() {
        [imageHeader, labelHeader, searchBox, sortButton, container].forEach { item in
            self.view.addSubview(item)
        }
        
        imageHeader.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.layoutFrame.minX + 16)
            make.width.height.equalTo(32)
        }
        
        labelHeader.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(imageHeader.snp.trailing).offset(8)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.layoutFrame.maxX - 16)
            make.centerY.equalTo(imageHeader.snp.centerY)
        }
        
        sortButton.snp.makeConstraints { make in
            make.top.equalTo(imageHeader.snp.bottom).offset(8)
            make.width.height.equalTo(32)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-16)
        }
        
        searchBox.snp.makeConstraints { make in
            make.top.equalTo(imageHeader.snp.bottom).offset(8)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(16)
            make.trailing.equalTo(sortButton.snp.leading).offset(-8)
            make.height.equalTo(32)
        }
        
        container.snp.makeConstraints { make in
            make.top.equalTo(searchBox.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(16)
        }
        
        searchBox.textChanged
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind { [weak self] query in
                guard let `self` = self else { return }
                self.presenter?.didUpdateSearchQuery(query ?? "")
            }
            .disposed(by: disposeBag)
        
        searchBox.clearTapped
            .bind { [weak self] in
                guard let `self` = self else { return }
                self.searchBox.clearText()
                self.presenter?.didClearSearch()
            }
            .disposed(by: disposeBag)
    }
    
    private func setupCollection() {
        self.container.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        collectionView.rx.contentOffset
            .observe(on: MainScheduler.instance)
            .flatMapLatest { [weak self] offset -> Observable<Void> in
                guard let `self` = self else { return .empty() }
                
                let visibleHeight = self.collectionView.frame.height
                let contentHeight = self.collectionView.contentSize.height
                let yOffset = offset.y
                let threshold = max(0.0, contentHeight - visibleHeight - 100)
                
                if yOffset > threshold {
                    return Observable.just(())
                }
                
                return Observable.empty()
            }
            .withLatestFrom(presenter?.isSearching ?? BehaviorRelay<Bool>(value: false))
            .filter { !$0 }
            .map { _ in () }
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.presenter?.loadMore()
            })
            .disposed(by: disposeBag)
        
        Observable.zip(
            collectionView.rx.itemSelected,
            collectionView.rx.modelSelected(Pokedex.Result.self)
        )
        .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
        .subscribe(onNext: { [weak self] indexPath, selectedPokemon in
            guard let `self` = self else { return }
            self.presenter?.didSelectPokemon(withSelectedIndex: indexPath.item)
        })
        .disposed(by: disposeBag)
    }
    
    private func bindPresenter() {
        self.presenter?.isLoadingObservable
            .bind(to: self.view.rx.hudVisible)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = ColorUtils.primary
        self.setupHeader()
        self.setupCollection()
        self.bindPresenter()
        self.presenter?.didLoad()
    }
}

extension PokedexViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 32) / 3
        return CGSize(width: width, height: 108)
    }
}

// MARK: - Extension PRESENTER -> VIEW

extension PokedexViewController: PokedexViewProtocol {
    
    func bindPokedex(_ pokedex: Observable<[Pokedex.Result]>) {
        pokedex
            .map { [SectionOfPokedex(header: "pokedex", items: $0)] }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
