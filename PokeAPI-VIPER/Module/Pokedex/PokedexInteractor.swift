//
//  PokedexInteractor.swift
//  PokeAPI-VIPER
//
//  Created by Alif Phincon on 17/09/25.
//

import RxCocoa
import RxSwift
import UIKit

final class PokedexInteractor: PokedexInteractorInputProtocol {
    
    // MARK: - Accessable
    
    weak var presenter: PokedexInteractorOutputProtocol?
    
    // MARK: - Private
    
    private let repository: PokedexRepository
    private let apiService: PokemonAPI
    private let disposeBag = DisposeBag()
    private let limit = 24
    private var offset = 0
    private var pokedex: [Pokedex.Result] = []
    private var filteredPokedex: [Pokedex.Result] = []
    
    // MARK: - Init
    
    init(
        repository: PokedexRepository,
        apiService: PokemonAPI
    ) {
        self.repository = repository
        self.apiService = apiService
    }
    
    func fetchPokedex() -> Single<[Pokedex.Result]> {
        return Single.create { [weak self] single in
            guard let `self` = self else {
                single(.failure(NSError(domain: "self deallocated", code: -1)))
                return Disposables.create()
            }
            
            let localPokedex = self.repository.getPokedex(limit: self.limit, offset: self.offset)
            
            if localPokedex.isEmpty {
                // Fetch from API
                let disposable = self.apiService.fetchPokedex(limit: self.limit, offset: self.offset)
                    .subscribe(
                        onSuccess: { [weak self] response in
                            guard let `self` = self else { return }
                            
                            let pokemonEntities = response.results.map { result in
                                let entity = PokemonEntity()
                                entity.idPokemon = Int(result.id ?? "") ?? 0
                                entity.name = result.name
                                entity.url = result.url
                                return entity
                            }
                            
                            self.repository.storePokedex(pokemonEntities)
                            
                            // Update paging + cache
                            self.offset += self.limit
                            self.pokedex.append(contentsOf: response.results)
                            
                            single(.success(self.pokedex))
                        },
                        onFailure: { error in
                            single(.failure(error))
                        }
                    )
                
                return Disposables.create { disposable.dispose() }
            } else {
                // Return local data
                let localResults = localPokedex.map { Pokedex.Result(from: $0) }
                
                self.offset += self.limit
                self.pokedex.append(contentsOf: localResults)
                
                single(.success(self.pokedex))
                return Disposables.create()
            }
        }
    }
    
    func updateSearchQuery(_ query: String) -> Single<[Pokedex.Result]> {
        return Single.create { [weak self] single in
            guard let `self` = self else {
                single(.failure(NSError(domain: "self deallocated", code: -1)))
                return Disposables.create()
            }
            
            if query.isEmpty {
                filteredPokedex = pokedex
            } else {
                filteredPokedex = pokedex.filter { result in
                    result.name.lowercased().contains(query.lowercased())
                }
            }
            single(.success(filteredPokedex))
            return Disposables.create()
        }
    }
    
    func clearSearch() -> Single<[Pokedex.Result]> {
        return Single.create { [weak self] single in
            guard let `self` = self else {
                single(.failure(NSError(domain: "self deallocated", code: -1)))
                return Disposables.create()
            }
            
            filteredPokedex = pokedex
            single(.success(filteredPokedex))
            return Disposables.create()
        }
    }
    
    func getPokedex() -> [Pokedex.Result] {
        return pokedex
    }
}
