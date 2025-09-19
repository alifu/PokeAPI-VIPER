//
//  PokemonViewController.swift
//  PokeAPI-VIPER
//
//  Created by Alif Phincon on 17/09/25.
//

import Nuke
import RxCocoa
import RxSwift
import UIKit

final class PokemonViewController: UIViewController {
    
    // MARK: - Accessable
    
    var presenter: PokemonPresenterProtocol?
    
    // MARK: - Private
    
    private let disposeBag = DisposeBag()
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "arrow_back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = ColorUtils.white
        return button
    }()
    
    private let tagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "tag")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = ColorUtils.white
        return imageView
    }()
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.font = FontUtils.headerSubtitle2
        label.textColor = ColorUtils.white
        label.textAlignment = .left
        label.text = "0"
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = FontUtils.headerHeadline
        label.textColor = ColorUtils.white
        label.textAlignment = .left
        label.text = "Pokémon Name"
        return label
    }()
    
    private let pokeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "pokeball")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = ColorUtils.white.withAlphaComponent(0.1)
        return imageView
    }()
    
    private let bannerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let infoView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorUtils.white
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    private let pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "silhouette")
        return imageView
    }()
    
    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "chevron_left")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "chevron_right")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let chipsView: HorizontalChips = {
        let view = HorizontalChips()
        view.backgroundColor = .white
        return view
    }()
    
    private let aboutLabel: UILabel = {
        let label = UILabel()
        label.text = "About"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = FontUtils.headerSubtitle1
        label.textColor = ColorUtils.wireframe
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = FontUtils.body3
        label.textColor = ColorUtils.dark
        return label
    }()
    
    private let baseStatsLabel: UILabel = {
        let label = UILabel()
        label.text = "Base Stats"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = FontUtils.headerSubtitle1
        label.textColor = ColorUtils.wireframe
        return label
    }()
    
    private let infoImageViewBuilder: (UIImage?, UIColor) -> UIImageView = { (image: UIImage?, color: UIColor) in
        let imageView = UIImageView(image: image?.withRenderingMode(.alwaysTemplate))
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.tintColor = color
        return imageView
    }
    
    private let contentInfoLabelBuilder: (String) -> UILabel = { (text: String) in
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = FontUtils.body3
        label.textColor = ColorUtils.dark
        return label
    }
    
    private let titleInfoLabelBuilder: (String) -> UILabel = { (text: String) in
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = FontUtils.caption
        label.textColor = ColorUtils.grayscaleMedium
        return label
    }
    
    private let separatorInfoViewBuilder: () -> UIView = {
        let view = UIView()
        view.backgroundColor = ColorUtils.grayscaleLight
        return view
    }
    
    private let statsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()
    
    private var weightLabel = UILabel()
    private var heightLabel = UILabel()
    private var abilitiesLabel = UILabel()
    
    private func setupHeader() {
        self.view.backgroundColor = ColorUtils.wireframe
        [pokeImageView, infoView, headerView, bannerView].forEach { item in
            self.view.addSubview(item)
        }
        [backButton, nameLabel, tagImageView, tagLabel].forEach { item in
            headerView.addSubview(item)
        }
        
        pokeImageView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.height.equalTo(208)
        }
        
        infoView.snp.makeConstraints {
            $0.top.equalTo(pokeImageView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-8)
        }
        
        headerView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(75)
        }
        
        bannerView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(0)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(infoView.snp.top)
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalTo(headerView.snp.centerY)
            $0.leading.equalTo(headerView.snp.leading).offset(16)
            $0.width.height.equalTo(32)
        }
        
        tagLabel.snp.makeConstraints {
            $0.centerY.equalTo(headerView.snp.centerY)
            $0.trailing.equalTo(headerView.snp.trailing).offset(-16)
        }
        
        tagImageView.snp.makeConstraints {
            $0.centerY.equalTo(tagLabel.snp.centerY)
            $0.trailing.equalTo(tagLabel.snp.leading).offset(0)
            $0.width.height.equalTo(16)
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerY.equalTo(backButton.snp.centerY)
            $0.leading.equalTo(backButton.snp.trailing).offset(8)
            $0.width.greaterThanOrEqualTo(0)
        }
        
        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupBanner() {
        [previousButton, pokemonImageView, nextButton].forEach { item in
            self.bannerView.addSubview(item)
        }
        
        pokemonImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.height.equalTo(200)
            $0.centerX.equalTo(self.view.snp.centerX)
        }
        
        previousButton.snp.makeConstraints {
            $0.trailing.equalTo(pokemonImageView.snp.leading).offset(-16)
            $0.width.height.equalTo(32)
            $0.centerY.equalTo(pokemonImageView.snp.centerY)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.equalTo(pokemonImageView.snp.trailing).offset(16)
            $0.width.height.equalTo(32)
            $0.centerY.equalTo(pokemonImageView.snp.centerY)
        }
        
        previousButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.presenter?.navigateToPreviousPokemon()
            })
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.presenter?.navigateToNextPokemon()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupInfo() {
        let weightImageView = infoImageViewBuilder(UIImage(named: "weight"), ColorUtils.dark)
        weightLabel = contentInfoLabelBuilder("123")
        let weightTitleLabel = titleInfoLabelBuilder("Weight")
        let heightImageView = infoImageViewBuilder(UIImage(named: "straighten"), ColorUtils.dark)
        heightLabel = contentInfoLabelBuilder("123")
        let heightTitleLabel = titleInfoLabelBuilder("Height")
        abilitiesLabel = contentInfoLabelBuilder("123")
        let abilitiesTitleLabel = titleInfoLabelBuilder("Abilities")
        let separatorOneView = separatorInfoViewBuilder()
        let separatorTwoView = separatorInfoViewBuilder()
        [
            chipsView,
            aboutLabel,
            weightImageView,
            weightLabel,
            weightTitleLabel,
            separatorOneView,
            heightImageView,
            heightLabel,
            heightTitleLabel,
            separatorTwoView,
            abilitiesLabel,
            abilitiesTitleLabel,
            descriptionLabel,
            baseStatsLabel,
            statsStackView
        ].forEach { item in
            self.infoView.addSubview(item)
        }
        
        chipsView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(75)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(20)
        }
        
        aboutLabel.snp.makeConstraints {
            $0.top.equalTo(chipsView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        separatorOneView.snp.makeConstraints {
            $0.top.equalTo(aboutLabel.snp.bottom).offset(16)
            $0.width.equalTo(1)
            $0.height.equalTo(48)
            $0.centerX.equalTo(aboutLabel.snp.centerX).offset(-51)
        }
        
        separatorTwoView.snp.makeConstraints {
            $0.top.equalTo(aboutLabel.snp.bottom).offset(16)
            $0.width.equalTo(1)
            $0.height.equalTo(48)
            $0.centerX.equalTo(aboutLabel.snp.centerX).offset(51)
        }
        
        weightTitleLabel.snp.makeConstraints {
            $0.bottom.equalTo(separatorOneView.snp.bottom)
            $0.trailing.equalTo(separatorOneView.snp.leading)
            $0.width.equalTo(103)
        }
        
        heightTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(separatorOneView.snp.trailing)
            $0.bottom.equalTo(separatorOneView.snp.bottom)
            $0.trailing.equalTo(separatorTwoView.snp.leading)
        }
        
        abilitiesTitleLabel.snp.makeConstraints {
            $0.bottom.equalTo(separatorTwoView.snp.bottom)
            $0.leading.equalTo(separatorTwoView.snp.trailing)
            $0.width.equalTo(103)
        }
        
        abilitiesLabel.snp.makeConstraints {
            $0.bottom.equalTo(abilitiesTitleLabel.snp.top).offset(-8)
            $0.centerX.equalTo(abilitiesTitleLabel.snp.centerX)
        }
        
        heightLabel.snp.makeConstraints {
            $0.bottom.equalTo(heightTitleLabel.snp.top).offset(-16)
            $0.centerX.equalTo(heightTitleLabel.snp.centerX)
        }
        
        heightImageView.snp.makeConstraints {
            $0.trailing.equalTo(heightLabel.snp.leading)
            $0.centerY.equalTo(heightLabel.snp.centerY)
            $0.height.width.equalTo(16)
        }
        
        weightLabel.snp.makeConstraints {
            $0.bottom.equalTo(weightTitleLabel.snp.top).offset(-16)
            $0.centerX.equalTo(weightTitleLabel.snp.centerX)
        }
        
        weightImageView.snp.makeConstraints {
            $0.trailing.equalTo(weightLabel.snp.leading)
            $0.centerY.equalTo(weightLabel.snp.centerY)
            $0.height.width.equalTo(16)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(separatorOneView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        baseStatsLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        statsStackView.snp.makeConstraints {
            $0.top.equalTo(baseStatsLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func bindPresenter() {
        self.presenter?.isLoadingObservable
            .bind(to: self.view.rx.hudVisible)
            .disposed(by: disposeBag)
        
        self.presenter?.pokemonObservable
            .subscribe(onNext: { [weak self] pokemon in
                guard let `self` = self else { return }
                self.view.backgroundColor = colorStringToType(pokemon.types.first ?? "")
                self.loadPokemonImage(with: pokemon.banner)
                self.nameLabel.text = pokemon.name.capitalized
                self.tagLabel.text = "\(pokemon.id)"
                self.abilitiesLabel.text = pokemon.abilities.joined(separator: "\n")
                self.statsStackView.removeAllArrangedSubviews()
                pokemon.stats.forEach { item in
                    let stat = ProgressStats(
                        title: item.stat.displayName(),
                        stats: item.baseStat,
                        themeColor: colorStringToType(pokemon.types.first ?? ""))
                    self.statsStackView.addArrangedSubview(stat)
                    stat.snp.makeConstraints {
                        $0.height.equalTo(16)
                    }
                }
                self.chipsView.generateChips(with: pokemon.types)
                self.weightLabel.text = pokemon.weight.toKg
                self.heightLabel.text = pokemon.height.toMeters
                self.aboutLabel.textColor = colorStringToType(pokemon.types.first ?? "")
                self.baseStatsLabel.textColor = colorStringToType(pokemon.types.first ?? "")
            })
            .disposed(by: disposeBag)
        
        self.presenter?.speciesObservable
            .subscribe(onNext: { [weak self] species in
                guard let `self` = self else { return }
                self.descriptionLabel.text = species
            })
            .disposed(by: disposeBag)
    }
    
    private func loadPokemonImage(with urlString: String?) {
        self.pokemonImageView.image = UIImage(named: "silhouette")
        if let urlString, let url = URL(string: urlString) {
            let request = ImageRequest(url: url)
            ImagePipeline.shared.loadImage(with: request) { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(response):
                    self.pokemonImageView.image = response.image
                case .failure(_):
                    self.pokemonImageView.image = UIImage(named: "silhouette")
                }
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        setupBanner()
        setupInfo()
        bindPresenter()
        self.presenter?.didLoad()
    }
}

// MARK: - Extension PRESENTER -> VIEW

extension PokemonViewController: PokemonViewProtocol { }
