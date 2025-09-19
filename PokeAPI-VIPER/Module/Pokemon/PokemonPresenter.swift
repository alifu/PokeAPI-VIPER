//
//  PokemonPresenter.swift
//  PokeAPI-VIPER
//
//  Created by Alif Phincon on 17/09/25.
//

import RxCocoa
import RxSwift
import UIKit

final class PokemonPresenter: PokemonPresenterProtocol  {
    
    // MARK: - Accessable
    
    weak var view: PokemonViewProtocol?
    var interactor: PokemonInteractorInputProtocol?
    var wireFrame: PokemonRouteProtocol?
    var isLoadingObservable: Observable<Bool> {
        return isLoading.asObservable()
    }
    var pokemonObservable: Observable<PokemonInfoWrapper> {
        return pokemon.asObservable()
    }
    var speciesObservable: Observable<String> {
        return species.asObservable()
    }
    
    // MARK: - Private
    
    private var isLoading = PublishRelay<Bool>()
    private var pokemon: PublishRelay<PokemonInfoWrapper> = .init()
    private var species: PublishRelay<String> = .init()
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    
    init() { }
    
    func didLoad() {
        
        isLoading.accept(true)
        
        guard let interactor = interactor else { return }
        
        Single.zip(
            interactor.fetchPokemon(),
            interactor.fetchPokemonSpecies()
        )
        .subscribe(
            onSuccess: { [weak self] pokemon, species in
                guard let `self` = self else { return }
                self.isLoading.accept(false)
                self.pokemon.accept(pokemon)
                self.species.accept(species)
            },
            onFailure: { [weak self] error in
                guard let `self` = self else { return }
                self.isLoading.accept(false)
            }
        )
        .disposed(by: disposeBag)
    }
    
    func navigateToNextPokemon() {
        
        guard let interactor = interactor else { return }
        
        Single.zip(
            interactor.fetchNextPokemon().andThen(.just(())),
            interactor.fetchPokemon(),
            interactor.fetchPokemonSpecies()
        )
        .subscribe(
            onSuccess: { [weak self] _, pokemon, species in
                guard let `self` = self else { return }
                self.isLoading.accept(false)
                self.pokemon.accept(pokemon)
                self.species.accept(species)
            },
            onFailure: { [weak self] error in
                guard let `self` = self else { return }
                self.isLoading.accept(false)
            }
        )
        .disposed(by: disposeBag)
    }
    
    func navigateToPreviousPokemon() {
        
        guard let interactor = interactor else { return }
        
        Single.zip(
            interactor.fetchPreviousPokemon().andThen(.just(())),
            interactor.fetchPokemon(),
            interactor.fetchPokemonSpecies()
        )
        .subscribe(
            onSuccess: { [weak self] _, pokemon, species in
                guard let `self` = self else { return }
                self.isLoading.accept(false)
                self.pokemon.accept(pokemon)
                self.species.accept(species)
            },
            onFailure: { [weak self] error in
                guard let `self` = self else { return }
                self.isLoading.accept(false)
            }
        )
        .disposed(by: disposeBag)
    }
}

// MARK: - Extension INTERACTOR -> PRESENTER

extension PokemonPresenter: PokemonInteractorOutputProtocol { }
