//
//  PokedexRouter.swift
//  PokeAPI-VIPER
//
//  Created by Alif Phincon on 17/09/25.
//

import UIKit

final class PokedexRouter: PokedexRouteProtocol {
    
    weak var viewController: UIViewController?
    
    private var repository: PokedexRepository
    private var apiService: PokemonAPI
    
    init(repository: PokedexRepository, apiService: PokemonAPI) {
        self.repository = repository
        self.apiService = apiService
    }
    
    // MARK: - Create Modul
    
    class func createModule(repository: PokedexRepository, apiService: PokemonAPI) -> UIViewController {
        let view = PokedexViewController()
        let presenter: PokedexPresenterProtocol & PokedexInteractorOutputProtocol = PokedexPresenter()
        let interactor: PokedexInteractorInputProtocol = PokedexInteractor(
            repository: repository,
            apiService: apiService
        )
        let router: PokedexRouteProtocol = PokedexRouter(
            repository: repository,
            apiService: apiService
        )
        
        // Connecting
        view.presenter = presenter
        presenter.view = view
        presenter.wireFrame = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    func openPokemon(_ pokedex: [Pokedex.Result], withSelectedId id: Int) {
        let pokemon = PokemonRouter.createModule(
            pokedex: pokedex,
            startIndex: id,
            repository: repository,
            apiService: apiService
        )
        viewController?.navigationController?.pushViewController(pokemon, animated: true)
    }
}
