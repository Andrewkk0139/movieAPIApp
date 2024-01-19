//
//  ViewController.swift
//  movieAPIApp
//
//  Created by ANDREW KAISER on 1/18/24.
//
struct Rating: Codable {
    var Source: String
    var Value: String
}
struct SearchResult: Codable {
    var Search: [Rating]
}


import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var labelOutlet: UILabel!
    @IBOutlet weak var searchFieldOutlet: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ghostMovie("ghost")
    }
    @IBAction func searchAction(_ sender: Any) {
        let title = searchFieldOutlet.text
        ghostMovie(title!)
    }
    
    
    func ghostMovie(_ title: String){
        print("func ran")
        let session = URLSession.shared

                //creating URL for api call (you need your apikey)
                let movieURL = URL(string: "http://www.omdbapi.com/?apikey=f61dccf3&t=\(title)")!

                // Making an api call and creating data in the completion handler
                let dataTask = session.dataTask(with: movieURL) {
                    // completion handler: happens on a different thread, could take time to get data
                    (data: Data?, response: URLResponse?, error: Error?) in

                    if let error = error {
                        print("Error:\n\(error)")
                    } else {
                        // if there is data
                        if let data = data {
                            // convert data to json Object
                            if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary {
                                print(jsonObj)
                                if let year = jsonObj.value(forKey: "Year") as? String{
                                    DispatchQueue.main.async {
                                        self.labelOutlet.text = "\(year)"
                                    }
                                }
                                
                                if let movieObj = try? JSONDecoder().decode(SearchResult.self, from: data){
                                    print("runnin")
                                    for r in movieObj.Search{
                                        print("\(r.Source), \(r.Value)")
                                    }
                                }
                            }else {
                                
                                print("Error: Can't convert data to json object")
                            }
                        }else {
                            print("Error: did not receive data")
                        }
                    }
                }

                dataTask.resume()
    }
}

