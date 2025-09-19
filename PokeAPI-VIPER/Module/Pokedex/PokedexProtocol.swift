//
//  PokedexProtocol.swift
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
protocol PokedexViewProtocol: AnyObject {
    var presenter: PokedexPresenterProtocol? { get set }
    
    func bindPokedex(_ pokedex: Observable<[Pokedex.Result]>)
}

/// PRESENTER -> WIREFRAME
///
/// Please add protocol definition in here
protocol PokedexRouteProtocol: AnyObject {
    var viewController: UIViewController? { get set }
    
    func openPokemon(_ pokedex: [Pokedex.Result], withSelectedId id: Int)
}

/// VIEW -> PRESENTER
///
/// Please add protocol definition in here
protocol PokedexPresenterProtocol: AnyObject {
    var view: PokedexViewProtocol? { get set }
    var interactor: PokedexInteractorInputProtocol? { get set }
    var wireFrame: PokedexRouteProtocol? { get set }
    var pokedexRelay: PublishRelay<[Pokedex.Result]> { get set }
    var isLoadingObservable: Observable<Bool> { get }
    var isSearching: BehaviorRelay<Bool> { get set }
    
    func didLoad()
    func loadMore()
    func didUpdateSearchQuery(_ query: String)
    func didClearSearch()
    func didSelectPokemon(withSelectedIndex index: Int)
}

/// INTERACTOR -> PRESENTER
///
/// Please add protocol definition in here
protocol PokedexInteractorOutputProtocol: AnyObject {
    var filteredPokemon: BehaviorRelay<[Pokedex.Result]> { get set }
}

/// PRESENTER -> INTERACTOR
///
/// Please add protocol definition in here
protocol PokedexInteractorInputProtocol: AnyObject {
    var presenter: PokedexInteractorOutputProtocol? { get set }
    
    func fetchPokedex() -> Single<[Pokedex.Result]>
    func updateSearchQuery(_ query: String) -> Single<[Pokedex.Result]>
    func clearSearch() -> Single<[Pokedex.Result]>
    func getPokedex() -> [Pokedex.Result]
}
