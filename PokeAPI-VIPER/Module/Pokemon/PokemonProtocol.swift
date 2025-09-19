//
//  PokemonProtocol.swift
//  PokeAPI-VIPER
//
//  Created by Alif Phincon on 17/09/25.
//

import RxCocoa
import RxSwift
import UIKit

/// PRESENTER -> VIEW
///
/// Please add protocol definition in here
protocol PokemonViewProtocol: AnyObject {
    var presenter: PokemonPresenterProtocol? { get set }
}

/// PRESENTER -> WIREFRAME
///
/// Please add protocol definition in here
protocol PokemonRouteProtocol: AnyObject { }

/// VIEW -> PRESENTER
///
/// Please add protocol definition in here
protocol PokemonPresenterProtocol: AnyObject {
    var view: PokemonViewProtocol? { get set }
    var interactor: PokemonInteractorInputProtocol? { get set }
    var wireFrame: PokemonRouteProtocol? { get set }
    var isLoadingObservable: Observable<Bool> { get }
    var pokemonObservable: Observable<PokemonInfoWrapper> { get }
    var speciesObservable: Observable<String> { get }
    
    func didLoad()
    func navigateToNextPokemon()
    func navigateToPreviousPokemon()
}

/// INTERACTOR -> PRESENTER
///
/// Please add protocol definition in here
protocol PokemonInteractorOutputProtocol: AnyObject { }

/// PRESENTER -> INTERACTOR
///
/// Please add protocol definition in here
protocol PokemonInteractorInputProtocol: AnyObject {
    var presenter: PokemonInteractorOutputProtocol? { get set }
    
    func fetchPokemon() -> Single<PokemonInfoWrapper>
    func fetchPokemonSpecies() -> Single<String>
    func getPokemonNavigator() -> PokemonNavigator
    func fetchNextPokemon() -> Completable
    func fetchPreviousPokemon() -> Completable
}
