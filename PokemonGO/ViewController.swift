//
//  ViewController.swift
//  PokemonGO
//
//  Created by Robson Magno on 05/02/19.
//  Copyright © 2019 Robson Magno. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapa: MKMapView!
    var managerLocalization = CLLocationManager()
    var count = 0
    var coreDataPokemon: CoreDataPokemon!
    var pokemons: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapa.delegate = self
        managerLocalization.delegate = self
        managerLocalization.requestWhenInUseAuthorization()
        managerLocalization.startUpdatingLocation()
        
        // Recupera os Pokemons
        self.coreDataPokemon = CoreDataPokemon()
        self.pokemons = self.coreDataPokemon.recoverAllPokemons()
        
        // Exibir Pokemons
        Timer.scheduledTimer(withTimeInterval: 8, repeats: true) { (timer) in
            
            // Obtem as coordenadas
            if let coordinations = self.managerLocalization.location?.coordinate {
                
                // Faz a contagem da quantidade de pokemons
                let totalPokemons = UInt32(self.pokemons.count)
                
                // Escolhe pokemon de forma aleatória
                let indexPokemonRandon = arc4random_uniform(totalPokemons)
                
                // Cria o pokemon que foi escolhido com o indice
                let pokemon = self.pokemons[ Int(indexPokemonRandon) ]
                
                // Cria uma anotação customizada para mostrar o pokemon recebendo as coordenadas
                let anotation = PokemonAnotation(coordinates: coordinations, pokemon: pokemon)
                
                let latRandon = (Double(arc4random_uniform(400)) - 200) / 100000.0
                let longRandon = (Double(arc4random_uniform(400)) - 200) / 100000.0
                
                anotation.coordinate.latitude += latRandon
                anotation.coordinate.longitude += longRandon
                
                self.mapa.addAnnotation(anotation)
            }
            
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let anotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        if anotationView.annotation is MKUserLocation {
            anotationView.image = UIImage(named: "player")
        }else{
            let pokemon = (annotation as! PokemonAnotation).pokemon
            
            anotationView.image = UIImage(named: pokemon.nameImage!)
        }
        
        var frame = anotationView.frame
        frame.size.height = 40
        frame.size.width = 40
        anotationView.frame = frame
        
        return anotationView
    }
    
    // Seleciona anotação clicada (Pokemon)
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        // Obtem a anotação à partir da view passada
        let anotation = view.annotation
        
        // Obtem o pokemon apartir da anotação
        let pokemon = (view.annotation as! PokemonAnotation).pokemon
        
        // Desmarca anotação selecionada (Pokemon)
        mapView.deselectAnnotation(anotation, animated: true)
        
        // Verifica que não é o MKUserLocation
        if anotation is MKUserLocation {
            return
        }
        
        if let coordAnotation = anotation?.coordinate {
            let region = MKCoordinateRegion.init(center: coordAnotation, latitudinalMeters: 200, longitudinalMeters: 200)
            mapa.setRegion(region, animated: true)
        }
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            
            if let coord = self.managerLocalization.location?.coordinate{
                
                if self.mapa.visibleMapRect.contains(MKMapPoint.init(coord)){
                    print("Você pode Capturar o pokemon")
                    self.coreDataPokemon.savePokemon(pokemon: pokemon)
                    self.mapa.removeAnnotation(anotation!)
                    
                    self.createAlert(title: "Parabéns!!!", message: "Você capturou o pokemon \(pokemon.name!)")
                }else{
                    
                    self.createAlert(title: "Você não pode Capturar!!!", message: "Você precisa se aproximar mais para capturar o pokemon \(pokemon.name!)")
                }
            }
        }
    }
    
    // Criação do alerta
    func createAlert(title: String, message: String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

    // Usado para quando o usuario nega permissao de uso da localizacao
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status != .authorizedWhenInUse && status != .notDetermined {
            
            createAlert()
        }
    }
    
    // Esse método mantem o objeto da localização centralizado
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if count < 3 {
            
            centralization()
            
            count += 1
            
        }else{
            // Esse método para de centralizar o objeto da localização
            managerLocalization.stopUpdatingLocation()
            
        }
        
    }
    
    // Ação do Botão para Centraliza o Jogador
    @IBAction func centerPlay(_ sender: Any) {
        
        centralization()
        
    }
    
    // Ação do Botão para Abrir a Pokeagenda
    @IBAction func openPokedex(_ sender: Any) {
    }
    
    // Centralização do Jogador
    func centralization(){
        
        if let coordinate = managerLocalization.location?.coordinate {
            let region = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
            mapa.setRegion(region, animated: true)
        }
    }
    
    // Criar alerta
    func createAlert(){
        
        let alertController = UIAlertController(title: "Permissão de Localização",
                                                message: "Para que você possa caçar pokemons, precisamos de sua localização!! por favor habilite", preferredStyle: .alert)
        
        let actionConfiguration = UIAlertAction(title: "Abrir Configurações", style: .default) { (alertConfiguration) in
            if let configuration = NSURL(string: UIApplication.openSettingsURLString){
                UIApplication.shared.open(configuration as URL)
            }
        }
        
        let actionCancel = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        
        alertController.addAction(actionConfiguration)
        alertController.addAction(actionCancel)
        present(alertController, animated: true, completion: nil)
        
    }
}

