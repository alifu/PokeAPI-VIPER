//
//  PokedexPresenter.swift
//  PokeAPI-VIPER
//
//  Created by Alif Phincon on 17/09/25.
//

import RxCocoa
import RxSwift
import UIKit

final class PokedexPresenter: PokedexPresenterProtocol {
    
    // MARK: - Accessable

    weak var view: PokedexViewProtocol?
    var interactor: PokedexInteractorInputProtocol?
    var wireFrame: PokedexRouteProtocol?
    var filteredPokemon = BehaviorRelay<[Pokedex.Result]>(value: [])
    var isLoadingObservable: Observable<Bool> {
        return isLoading.asObservable()
    }
    var pokedexRelay = PublishRelay<[Pokedex.Result]>()
    var isSearching: BehaviorRelay<Bool> = .init(value: false)

    // MARK: - Private
    
    private let disposeBag = DisposeBag()
    private var isLoading = PublishRelay<Bool>()

    // MARK: - Init
    
    init() { }
    
    private func loadPokedex() {
        interactor?.fetchPokedex()
            .subscribe(
                onSuccess: { [weak self] result in
                    guard let `self` = self else { return }
                    self.isLoading.accept(false)
                    self.pokedexRelay.accept(result)
                    
                },
                onFailure: { [weak self] error in
                    guard let `self` = self else { return }
                    self.isLoading.accept(false)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func didLoad() {
        view?.bindPokedex(pokedexRelay.asObservable())
        
        isLoading.accept(true)
        loadPokedex()
    }
    
    func loadMore() {
        loadPokedex()
    }
    
    func didUpdateSearchQuery(_ query: String) {
        interactor?.updateSearchQuery(query)
            .subscribe(
                onSuccess: { [weak self] result in
                    guard let `self` = self else { return }
                    self.isLoading.accept(false)
                    self.pokedexRelay.accept(result)
                    
                },
                onFailure: { [weak self] error in
                    guard let `self` = self else { return }
                    self.isLoading.accept(false)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func didClearSearch() {
        interactor?.clearSearch()
            .subscribe(
                onSuccess: { [weak self] result in
                    guard let `self` = self else { return }
                    self.isLoading.accept(false)
                    self.pokedexRelay.accept(result)
                    
                },
                onFailure: { [weak self] error in
                    guard let `self` = self else { return }
                    self.isLoading.accept(false)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func didSelectPokemon(withSelectedIndex index: Int) {
        self.wireFrame?.openPokemon(interactor?.getPokedex() ?? [], withSelectedId: index)
    }
}

// MARK: - Extension INTERACTOR -> PRESENTER

extension PokedexPresenter: PokedexInteractorOutputProtocol { }
