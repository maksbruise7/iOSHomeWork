import UIKit
import SnapKit

class InfoViewController: UIViewController {
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let personLabel: UILabel = {
        let label = UILabel()
        label.text = "⏳ Загрузка данных о человеке..."
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private let planetLabel: UILabel = {
        let label = UILabel()
        label.text = "⏳ Загрузка данных о планете..."
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let closeButton: CustomButton = {
        let button = CustomButton(
            title: "Закрыть",
            titleColor: .white,
            backgroundColor: .systemRed,
            font: .systemFont(ofSize: 16, weight: .semibold),
            cornerRadius: 12,
            height: 50
        )
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        loadData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBlue
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(personLabel)
        contentView.addSubview(planetLabel)
        contentView.addSubview(loadingIndicator)
        
        view.addSubview(closeButton)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(closeButton.snp.top).offset(-20)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        personLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        planetLabel.snp.makeConstraints { make in
            make.top.equalTo(personLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(50)
        }
        
        closeButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(50)
        }
    }
    
    private func setupActions() {
        closeButton.setAction { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    // MARK: - Data Loading
    private func loadData() {
        loadingIndicator.startAnimating()
        personLabel.text = "⏳ Загрузка данных о человеке..."
        personLabel.textColor = .white
        planetLabel.text = "⏳ Загрузка данных о планете..."
        planetLabel.textColor = .white
        
        print("🔍 Начинаем загрузку данных")
        
        // Загружаем человека
        NetworkService.fetchPerson(id: "8") { [weak self] person in
            DispatchQueue.main.async {
                if let person = person {
                    self?.personLabel.text = """
                    👤 ИНФОРМАЦИЯ О ЧЕЛОВЕКЕ
                    ─────────────────────
                    Имя: \(person.name)
                    Рост: \(person.height)
                    Вес: \(person.mass)
                    Цвет глаз: \(person.eyeColor)
                    Цвет волос: \(person.hairColor)
                    Пол: \(person.gender)
                    """
                    self?.personLabel.textColor = .green
                    print("✅ Загружен человек: \(person.name)")
                } else {
                    self?.personLabel.text = "❌ Не удалось загрузить данные о человеке"
                    self?.personLabel.textColor = .red
                    print("❌ Ошибка загрузки человека")
                }
                self?.checkLoadingComplete()
            }
        }
        
        // Загружаем планету
        NetworkService.fetchPlanet(id: "1") { [weak self] planet in
            DispatchQueue.main.async {
                if let planet = planet {
                    self?.planetLabel.text = """
                    🪐 ИНФОРМАЦИЯ О ПЛАНЕТЕ
                    ──────────────────────
                    Название: \(planet.name)
                    Период обращения: \(planet.orbitalPeriod) дней
                    Период вращения: \(planet.rotationPeriod) часов
                    Диаметр: \(planet.diameter) км
                    Климат: \(planet.climate)
                    Население: \(planet.population)
                    """
                    self?.planetLabel.textColor = .green
                    print("✅ Загружена планета: \(planet.name)")
                } else {
                    self?.planetLabel.text = "❌ Не удалось загрузить данные о планете"
                    self?.planetLabel.textColor = .red
                    print("❌ Ошибка загрузки планеты")
                }
                self?.checkLoadingComplete()
            }
        }
    }
    
    private func checkLoadingComplete() {
        loadingIndicator.stopAnimating()
        
        if personLabel.textColor == .red || planetLabel.textColor == .red {
            print("⚠️ Есть ошибки при загрузке данных")
        } else {
            print("✅ Все данные успешно загружены")
        }
    }
}
