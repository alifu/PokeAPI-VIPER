//
//  PokemonRouter.swift
//  PokeAPI-VIPER
//
//  Created by Alif Phincon on 17/09/25.
//

import UIKit

final class PokemonRouter: PokemonRouteProtocol {

    // MARK: - Create Modul
    
    class func createModule(
        pokedex: [Pokedex.Result],
        startIndex: Int,
        repository: PokedexRepository,
        apiService: PokemonAPI
    ) -> UIViewController {
        let view = PokemonViewController()
        let presenter: PokemonPresenterProtocol & PokemonInteractorOutputProtocol = PokemonPresenter()
        let interactor: PokemonInteractorInputProtocol = PokemonInteractor(
            repository: repository,
            apiService: apiService,
            pokemonNavigator: PokemonNavigator(results: pokedex, startIndex: startIndex)
        )
        let router: PokemonRouteProtocol = PokemonRouter()

        // Connecting
        view.presenter = presenter
        presenter.view = view
        presenter.wireFrame = router
        presenter.interactor = interactor
        interactor.presenter = presenter

        return view
    }
}
