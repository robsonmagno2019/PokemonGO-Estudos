
import UIKit

class PokeSchedulingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var pokemonsCaptured: [Pokemon] = []
    var pokemonsNotCaptured: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let coreDataPokemon = CoreDataPokemon()
        
        self.pokemonsCaptured = coreDataPokemon.recoverPokemonsCaptured(captured: true)
        self.pokemonsNotCaptured = coreDataPokemon.recoverPokemonsCaptured(captured: false)
    }
    
    // Define a quantidade de Sessão
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // Define o título do Cabeçalho da Sessão
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return "Capturados"
        }else{
            return "Não Capturados"
        }
    }
    
    // Retorna a quantidade de elementos da sessção
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return self.pokemonsCaptured.count
        }else{
            return self.pokemonsNotCaptured.count
        }
    }
    
    // Preenche as Sessões com os objetos
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let pokemon: Pokemon
        
        if indexPath.section == 0 {
            pokemon = self.pokemonsCaptured[ indexPath.row ]
        }else{
            pokemon = self.pokemonsNotCaptured[ indexPath.row ]
        }
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = pokemon.name
        cell.imageView?.image = UIImage(named: pokemon.nameImage!)
        
        return cell
    }
    
    @IBAction func backToMap(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
}
