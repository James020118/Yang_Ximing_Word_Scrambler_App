
import UIKit

class mainMenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignBackground()
        // Do any additional setup after loading the view.
        
//        UserDefaults.standard.removeObject(forKey: "names")
//        UserDefaults.standard.removeObject(forKey: "scores")
    }
    
    // segue going to the game
    @IBAction func goToGame(_ sender: UIButton) {
        performSegue(withIdentifier: "toGame", sender: sender)
    }
    
    // segue going to the leaderboard
    @IBAction func goToLeaderboard(_ sender: UIButton) {
        performSegue(withIdentifier: "toLeaderboard", sender: sender)
    }
    
    // set proper background
    func assignBackground(){
        let background = #imageLiteral(resourceName: "bg1.jpg")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
    // unwind segue
    @IBAction func unwindToMain(unwind: UIStoryboardSegue){}
}
