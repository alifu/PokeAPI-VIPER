//
//  PokemonInteractor.swift
//  PokeAPI-VIPER
//
//  Created by alif rama on 17/09/25.
//

import RxCocoa
import RxSwift
import UIKit

final class PokemonInteractor: PokemonInteractorInputProtocol {
    
    // MARK: - Accessable
    
    weak var presenter: PokemonInteractorOutputProtocol?
    
    // MARK: - Private
    
    private let repository: PokedexRepository
    private let apiService: PokemonAPI
    private let pokemonNavigator: PokemonNavigator
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    
    init(
        repository: PokedexRepository,
        apiService: PokemonAPI,
        pokemonNavigator: PokemonNavigator
    ) {
        self.repository = repository
        self.apiService = apiService
        self.pokemonNavigator = pokemonNavigator
    }
    
    func fetchPokemon() -> Single<PokemonInfoWrapper> {
        
        return Single.deferred { [weak self] in
            guard let self = self else {
                return .error(NSError(domain: "self deallocated", code: -1))
            }
            
            let name = self.pokemonNavigator.currentRelay.value?.name ?? ""
            
            // 🔹 1. Try from repository
            if let pokemon = self.repository.getPokemon(withName: name) {
                let wrapper = PokemonInfoWrapper(
                    id: pokemon.idPokemon,
                    banner: pokemon.spritesOther?.officialArtwork ?? "",
                    name: pokemon.name,
                    abilities: pokemon.abilities.map { $0.name },
                    stats: pokemon.stats.map { result in
                        Pokemon.Stats(
                            baseStat: result.baseStat,
                            effort: result.effort,
                            stat: Pokemon.StatsInfo(name: result.stat, url: "")
                        )
                    },
                    types: pokemon.types.map { $0.type },
                    height: pokemon.height,
                    weight: pokemon.weight
                )
                return .just(wrapper)
            }
            
            // 🔹 2. Else, fetch from API
            return self.apiService.fetchPokemon(name: name)
                .map { response in
                    let wrapper = PokemonInfoWrapper(
                        id: response.id,
                        banner: response.sprites.other.officialArtwork.frontDefault,
                        name: response.name,
                        abilities: response.abilities.map { $0.ability.name },
                        stats: response.stats,
                        types: response.types.map { $0.type.name },
                        height: Double(response.height),
                        weight: Double(response.weight)
                    )
                    
                    // persist to repo
                    self.repository.storePokemon(
                        id: response.id,
                        name: response.name,
                        abilities: response.abilities,
                        spritesOther: response.sprites,
                        types: response.types,
                        weight: response.weight,
                        height: response.height,
                        stats: response.stats
                    )
                    
                    return wrapper
                }
        }
    }
    
    func fetchPokemonSpecies() -> Single<String> {
        
        let name = pokemonNavigator.currentRelay.value?.name ?? ""
        
        if let pokemon = repository.getPokemonSpecies(withName: name) {
            let rawAbout = pokemon.flavourTextEntries.first?.flavourText ?? ""
            return .just(rawAbout.replacingOccurrences(of: "\n", with: " "))
        } else {
            return apiService.fetchPokemonSpecies(name: name)
                .map { response in
                    let resultAbout = response.flavorTextEntries.first?.flavourText ?? ""
                    let rawAbout = resultAbout.replacingOccurrences(of: "\n", with: " ")
                    self.repository.storePokemonSpecies(
                        name: name,
                        flavourTextEntries: response.flavorTextEntries)
                    return rawAbout
                }
        }
    }
    
    func getPokemonNavigator() -> PokemonNavigator {
        return pokemonNavigator
    }
    
    func fetchNextPokemon() -> Completable {
        pokemonNavigator.moveNext()
        return .empty()
    }
    
    func fetchPreviousPokemon() -> Completable {
        pokemonNavigator.movePrevious()
        return .empty()
    }
}
