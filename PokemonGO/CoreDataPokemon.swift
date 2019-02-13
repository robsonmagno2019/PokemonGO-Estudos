
import UIKit
import CoreData

class CoreDataPokemon{
    
    // Recupera o contexto
    func getContext() -> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        return context!
    }
    
    // Recuperar pokemons capturados
    func recoverPokemonsCaptured(captured: Bool) -> [Pokemon] {
        
        let context = self.getContext()
        
        let request = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
        // O código foi trocado
        request.predicate = NSPredicate(format: "captured = %@", NSNumber(value: captured))
        
        do{
            
            let pokemons = try context.fetch(request) as [Pokemon]
            
            return pokemons
            
        }catch{
            
        }
        
        return []
    }
    
    // Recuperar todos os pokemons
    func recoverAllPokemons() -> [Pokemon]{
        
        let context = self.getContext()
        
        do{
            let pokemons = try context.fetch(Pokemon.fetchRequest()) as! [Pokemon]
            
            if pokemons.count == 0 {
                
                self.addAllPokemons()
                return self.recoverAllPokemons()
            }
            
            return pokemons
        }catch{
            
        }
        return []
    }
    
    // Salva pokemon
    func savePokemon( pokemon: Pokemon){
        
        let context = self.getContext()
        
        pokemon.captured = true
        
        do{
            try context.save()
        }catch{
            
        }
    }
    
    // Adiciona todos os pokemons
    func addAllPokemons(){
        
        let context = self.getContext()
        
        self.createPokemon(name: "Abra", nameImage: "abra", captured: false)
        self.createPokemon(name: "Mew", nameImage: "mew", captured: false)
        self.createPokemon(name: "Meowth", nameImage: "meowth", captured: false)
        self.createPokemon(name: "Pikachu", nameImage: "pikachu-2", captured: true)
        self.createPokemon(name: "Squirtle", nameImage: "squirtle", captured: false)
        self.createPokemon(name: "Caterpie", nameImage: "caterpie", captured: false)
        self.createPokemon(name: "Charmander", nameImage: "charmander", captured: false)
        self.createPokemon(name: "Caterpie", nameImage: "caterpie", captured: false)
        self.createPokemon(name: "Dratini", nameImage: "dratini", captured: false)
        self.createPokemon(name: "Eevee", nameImage: "eevee", captured: false)
        self.createPokemon(name: "Jigglypuff", nameImage: "jigglypuff", captured: false)
        self.createPokemon(name: "Mankey", nameImage: "mankey", captured: false)
        self.createPokemon(name: "Pidgey", nameImage: "pidgey", captured: false)
        self.createPokemon(name: "Venonat", nameImage: "venonat", captured: false)
        self.createPokemon(name: "Weedle", nameImage: "weedle", captured: false)
        self.createPokemon(name: "Bullbasaur", nameImage: "bullbasaur", captured: false)
        self.createPokemon(name: "Bellsprout", nameImage: "bellsprout", captured: false)
        self.createPokemon(name: "Psyduck", nameImage: "psyduck", captured: false)
        self.createPokemon(name: "Rattata", nameImage: "rattata", captured: false)
        self.createPokemon(name: "Snorlax", nameImage: "snorlax", captured: false)
        self.createPokemon(name: "Zubat", nameImage: "zubat", captured: false)
        
        do{
            try context.save()
        }catch{
            
        }
        
    }
    
    // Criar pokemon
    func createPokemon(name: String, nameImage: String, captured: Bool){
        
        let context = self.getContext()
        let pokemon = Pokemon(context: context)
        pokemon.name = name
        pokemon.nameImage = nameImage
        pokemon.captured = captured
    }
}
