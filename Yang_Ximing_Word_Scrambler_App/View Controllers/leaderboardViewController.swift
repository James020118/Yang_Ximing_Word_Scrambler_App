
import UIKit

class leaderboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // arrays to store data
    var names = [String]()
    var scores = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // display background
        assignBackground()
        
        // fetch persistent data
        if UserDefaults.standard.object(forKey: "names") != nil && UserDefaults.standard.object(forKey: "scores") != nil {
            names = UserDefaults.standard.array(forKey: "names") as! [String]
            scores = UserDefaults.standard.array(forKey: "scores") as! [Int]
        } else {
            UserDefaults.standard.set(names, forKey: "names")
            UserDefaults.standard.set(scores, forKey: "scores")
        }
        
        // sort the score array and the name array using selection sort
        if names.count > 1 && scores.count > 1 {
            for i in 0..<scores.count - 1 {
                var k = i
                for j in (i + 1)..<scores.count {
                    if scores[j] > scores[k] {
                        k = j
                    }
                }
                if i != k {
                    swap(&scores[i], &scores[k])
                    swap(&names[i], &names[k])
                }
            }
        }
    }
    
    // manipulate background
    func assignBackground(){
        let background = #imageLiteral(resourceName: "bg3.jpg")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
    // inform the row number of table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    // put each element into each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = names[indexPath.row]
        cell?.detailTextLabel?.text = String(scores[indexPath.row])
        cell?.textLabel?.textColor = UIColor.yellow
        cell?.detailTextLabel?.textColor = UIColor.yellow
        return cell!
    }
}
