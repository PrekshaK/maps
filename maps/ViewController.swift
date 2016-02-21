import UIKit
import MapKit


let searchKey = ""
let GOOGLE_API_KEY = "AIzaSyB9Yzf1rT5v01NZBiv4mj4HPzRr4AhOC0w"
let baseURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=38.90,-77.016&radius=500&type=restaurant&name=\(searchKey)&key=\(GOOGLE_API_KEY)"
//let session = NSURLSession.sharedSession()
//let request = NSMutableURLRequest(URL: NSURL(string: baseURL)!)
//let task = session.dataTaskWithRequest(request)

class ViewController: UIViewController {
    
    
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
            let delta = 0.03
        let center = CLLocationCoordinate2DMake(38.90, -77.016)
        let region = MKCoordinateRegion(center:center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: baseURL)!)
        let task = session.dataTaskWithRequest(request){
            (data, response, error)-> Void in
            if error != nil {
                
                    print (error!.localizedDescription)
                    return
                }
                
                //do conver to json
                
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                    
                    if let items = json["results"] as? [[String: AnyObject]]{
                        for items in items{
                            //process items here
                            print (items)
                            
                            if let name = items["name"] as? String{
                                
                                let coords: [Double] = self.getCoords(items["geometry"] as! Dictionary)
                                
                                
                                let annotation = MKPointAnnotation()

                                annotation.coordinate = CLLocationCoordinate2D(
                                    latitude: coords[0],
                                    longitude: coords[1]
                                )
                                
                                annotation.title = name
                                
                                self.mapView.addAnnotation(annotation)
                            
                            
                            }
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                        }
                        //when finished, update the UI on the main thread
                        dispatch_async(dispatch_get_main_queue()){
                            self.mapView.setRegion(region, animated: true)
                        }
                    }
                    
                    
                    
                    
                    
                    
                }catch{
                //    print("error serializing json: \(error)")
                    print("error serializing json")
                }
            
            
            
        }
        task.resume()
        
    
        
//        self.mapView.setRegion(region, animated: true)
        
        
    }
    
    
    func getCoords(data: [String:AnyObject]) -> [Double]{
        let c = data["location"] as![String: AnyObject]
        print (c)
        return [c["lat"] as! Double, c["lng"] as! Double]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



//    let delta = 0.03
//    let region = MKCoordinateRegion();
//    region.center.latitude = 38.90;
//    region.enter.longitude = -77.016


