
import UIKit
import MapKit

class PokemonAnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var pokemon: Pokemon
    
    init(coordinates: CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coordinates
        self.pokemon = pokemon
    }
}
