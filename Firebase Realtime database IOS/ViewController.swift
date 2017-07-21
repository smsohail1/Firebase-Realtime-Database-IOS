//
//  ViewController.swift
//  Firebase Realtime database IOS
//
//  Created by Abdul Ahad on 7/18/17.
//  Copyright © 2017 plash. All rights reserved.
//

import UIKit

import Firebase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet weak var artistName: UITextField!
    @IBOutlet weak var artistGenre: UITextField!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var artistTableView: UITableView!
    
    
    //defining firebase reference var
    var refArtists: DatabaseReference!
    
    //list to store all the artist
    var artistList = [ArtistModelViewController]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib. 
        
        //configuring firebase
        FirebaseApp.configure()
        
        //getting a reference to the node artists
        refArtists = Database.database().reference().child("artists");
        
        
        //observing the data changes
        refArtists.observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                self.artistList.removeAll()
                
                //iterating through all the values
                for artists in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let artistObject = artists.value as? [String: AnyObject]
                    let artistName  = artistObject?["artistName"]
                    let artistId  = artistObject?["id"]
                    let artistGenre = artistObject?["artistGenre"]
                    
                    //creating artist object with model and fetched values
                    let artist = ArtistModelViewController(id: artistId as! String?, name: artistName as! String?, genre: artistGenre as! String?)
                    
                    //appending it to list
                    self.artistList.append(artist)
                }
                
                //reloading the tableview
                self.artistTableView.reloadData()
            }
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func Add(_ sender: UIButton) {
        addArtist()
    }
    
    
    
    func addArtist(){
        //generating a new key inside artists node
        //and also getting the generated key
        let key = refArtists.childByAutoId().key
        
        //creating artist with the given values
        let artist = ["id":key,
                      "artistName": artistName.text! as String,
                      "artistGenre": artistGenre.text! as String
        ]
        
        //adding the artist inside the generated unique key
        refArtists.child(key).setValue(artist)
        
        //displaying message
        status.text = "Artist Added"
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return artistList.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        //creating a cell using the custom class
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableRowTableViewCell
        
        //the artist object
        let artist: ArtistModelViewController
        
        //getting the artist of selected position
        artist = artistList[indexPath.row]
        
        //adding values to labels
        cell.name.text = artist.name
        cell.genre.text = artist.genre
        
        //returning cell
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //getting the selected artist
        let artist  = artistList[indexPath.row]
        
        //building an alert
        let alertController = UIAlertController(title: artist.name, message: "Give new values to update ", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            
            //getting artist id
            let id = artist.id
            
            //getting new values
            let name = alertController.textFields?[0].text
            let genre = alertController.textFields?[1].text
            
            //calling the update method to update artist
            self.updateArtist(id: id!, name: name!, genre: genre!)
            
            

        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
        
            //deleting artist
            self.deleteArtist(id: artist.id!)
            
            
            //Remove selected row item from artist list
            self.artistList.remove(at: indexPath.row)
            //reloading the tableview
            self.artistTableView.reloadData()
        }
        
        //adding two textfields to alert
        alertController.addTextField { (textField) in
            textField.text = artist.name
        }
        alertController.addTextField { (textField) in
            textField.text = artist.genre
        }
        
        //adding action
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //presenting dialog
        present(alertController, animated: true, completion: nil)
    }


    func updateArtist(id:String, name:String, genre:String){
        //creating artist with the new given values
        let artist = ["id":id,
                      "artistName": name,
                      "artistGenre": genre
        ]
        
        //updating the artist using the key of the artist
        refArtists.child(id).setValue(artist)
        
        //displaying message
        status.text = "Artist Updated"
    }
    
    
    func deleteArtist(id:String){
        refArtists.child(id).setValue(nil)
        
        
        //reloading the tableview
        self.artistTableView.reloadData()
        
        //displaying message
        status.text = "Artist Deleted"
    }
}

