import UIKit

// word banks
let foodWordBank = ["APPLE", "LASAGNA", "BACON", "BANANA", "BURRITO", "COFFEE", "CHOCOLATE", "DOUGHNUT", "FISH", "HAMBURGER", "PIZZA", "HONEY", "JUICE", "CHEESE", "MILK", "POPCORN", "BREAD", "SANDWICH", "TACO", "CINNAMON"]
let countryWordBank = ["ARGENTINA", "AUSTRALIA", "BRAZIL", "CANADA", "CHINA", "CROATIA", "FRANCE", "GERMANY", "GREECE", "INDIA", "IRAN", "JAPAN", "MEXICO", "RUSSIA", "UKRAINE", "SERBIA", "SPAIN", "SWEDEN", "UGANDA", "SINGAPORE"]
let animalWordBank = ["ALLIGATOR", "BEAR", "BOBCAT", "BUFFALO", "CAT", "CRAB", "DOG", "EAGLE", "FALCON", "GECKO", "GORILLA", "HORSE", "JELLYFISH", "KANGAROO", "LEOPARD", "LOBSTER", "OCTOPUS", "RABBIT", "SCORPION", "TIGER"]

class ViewController: UIViewController {
    
    // all outlets for the buttons and labels
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var hint: UIButton!
    @IBOutlet weak var giveUp: UIButton!
    @IBOutlet weak var delete: UIButton!
    @IBOutlet weak var skip: UIButton!
    @IBOutlet weak var finish: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var endGameLabel: UILabel!
    
    // all image view for empty boxes
    @IBOutlet var answerBoxes: [UIImageView]!
    var boxes = [CGPoint]()
    var isTaken = [Bool]()
    // all image view for letter choices
    @IBOutlet var choiceBlocks: [UIImageView]!
    var centers = [CGPoint]()
    
    // create a new Word
    var currentWord = Word(original: "Nothing")
    var category = 0
    // initialize score and update whenever it is changed
    var score = 0 {
        didSet {
            scoreLabel.text = "\(score)"
        }
    }
    var name: String? = ""
    // names and scores array for the userdefaults
    var names = [String]()
    var scores = [Int]()
    
    var lastAnsBoxIndex = [Int]()
    var lastChoiceBoxIndex = [Int]()
    
    // initializing the view when view loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        // put the background into the view
        assignBackground()
        
        // choosing random word
        let randomWordIndex = Int.random(in: 0...19);
        category = Int.random(in: 1...3)
        if(category == 1) {
            currentWord.changeWord(newWord: foodWordBank[randomWordIndex])
        } else if (category == 2) {
            currentWord.changeWord(newWord: countryWordBank[randomWordIndex])
        } else if (category == 3) {
            currentWord.changeWord(newWord: animalWordBank[randomWordIndex])
        }
        
        // scramble the word
        currentWord.scramble()
        let scrambled = currentWord.scrambledArray
        print(currentWord.charArray)
        
        // display proper amount of empty boxes
        for index in 0..<answerBoxes.count {
            answerBoxes[index].isHidden = true
            choiceBlocks[index].isHidden = true
            choiceBlocks[index].isUserInteractionEnabled = false
        }
        
        // display proper scrambled letters
        for index in 0..<currentWord.length {
            answerBoxes[index].image = #imageLiteral(resourceName: "empty_box.png")
            answerBoxes[index].isHidden = false
            boxes.append(answerBoxes[index].center)
            isTaken.append(false)
            
            choiceBlocks[index].image = convertImage(letter: scrambled[index])
            choiceBlocks[index].isHidden = false
            choiceBlocks[index].isUserInteractionEnabled = true
            centers.append(choiceBlocks[index].center)
        }
        
        // hide end game label
        endGameLabel.isHidden = true
        
        // fetch userdefaults in order to update
        if UserDefaults.standard.object(forKey: "names") != nil && UserDefaults.standard.object(forKey: "scores") != nil {
            names = UserDefaults.standard.array(forKey: "names") as! [String]
            scores = UserDefaults.standard.array(forKey: "scores") as! [Int]
        } else {
            UserDefaults.standard.set(names, forKey: "names")
            UserDefaults.standard.set(scores, forKey: "scores")
        }
    }
    
    var imageNum = -1
    var isMoving = false
    // executed when user touches the letter
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            // inform the program which letter the user pressed on
            if touch.view == choiceBlocks[0] {
                imageNum = 0
                isMoving = true
            } else if touch.view == choiceBlocks[1] {
                imageNum = 1
                isMoving = true
            } else if touch.view == choiceBlocks[2] {
                imageNum = 2
                isMoving = true
            } else if touch.view == choiceBlocks[3] {
                imageNum = 3
                isMoving = true
            } else if touch.view == choiceBlocks[4] {
                imageNum = 4
                isMoving = true
            } else if touch.view == choiceBlocks[5] {
                imageNum = 5
                isMoving = true
            } else if touch.view == choiceBlocks[6] {
                imageNum = 6
                isMoving = true
            } else if touch.view == choiceBlocks[7] {
                imageNum = 7
                isMoving = true
            } else if touch.view == choiceBlocks[8] {
                imageNum = 8
                isMoving = true
            } else if touch.view == choiceBlocks[9] {
                imageNum = 9
                isMoving = true
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            // if the tile is moving, change its location to the mouse location
            if isMoving {
                let location = touch.location(in: self.view)
                choiceBlocks[imageNum].center = location
            }
        }
    }
    
    // executed when the touch ends
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self.view)
            if isMoving {
                // if the letter is not near the box, sends it back to the original position
                // else the letter snaps into position and disable it
                for i in 0..<currentWord.length {
                    if location.x > boxes[i].x - 37.5 && location.x < boxes[i].x + 37.5 && location.y > boxes[i].y - 37.5 && location.y < boxes[i].y + 37.5 && isTaken[i] == false {
                        answerBoxes[i].image = choiceBlocks[imageNum].image
                        choiceBlocks[imageNum].center = centers[imageNum]
                        choiceBlocks[imageNum].isUserInteractionEnabled = false
                        choiceBlocks[imageNum].isHidden = true
                        isTaken[i] = true
                        lastAnsBoxIndex.append(i)
                        lastChoiceBoxIndex.append(imageNum)
                    } else {
                        UIView.animate(withDuration: 0.3, animations: {
                            self.choiceBlocks[self.imageNum].center = self.centers[self.imageNum]
                        }, completion: nil)
                    }
                }
            }
            isMoving = false
        }
    }

    // function for checking if the user gets the correct answer
    @IBAction func checkAnswer(_ sender: UIButton) {
        var isCorrect = true
        // check every single letter if it is correct letter
        for index in 0..<currentWord.length {
            if answerBoxes[index].image != convertImage(letter: currentWord.charArray[index]) {
                isCorrect = false
            }
        }
        
        // if correct, display an alert view that says you are correct
        // if not correct, reset all the empty boxes and letter boxes
        if isCorrect {
            let alert = UIAlertController(title: "Correct!", message: "You spelled it correctly!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
            present(alert, animated: true)
            resetGame()
            score += 10
        } else {
            for index in 0..<currentWord.length {
                answerBoxes[index].image = #imageLiteral(resourceName: "empty_box.png")
                isTaken[index] = false
                choiceBlocks[index].isHidden = false
                choiceBlocks[index].isUserInteractionEnabled = true
            }
            if score >= 3{
                score -= 3
            } else {
                score = 0
            }
            lastAnsBoxIndex.removeAll()
            lastChoiceBoxIndex.removeAll()
        }
    }
    
    // give hints based on the category
    @IBAction func giveHint(_ sender: UIButton) {
        var message = ""
        switch category {
        case 1:
            message = "kind of food."
        case 2:
            message = "country."
        case 3:
            message = "type of animal."
        default:
            message = ""
        }
        let alert = UIAlertController(title: "Hint!", message: "The word represents a \(message) Beware, using hint costs you 1 point.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Got It!", style: .default, handler: nil))
        present(alert, animated: true)
        if score >= 1 {
            score -= 1
        } else {
            score = 0
        }
    }
    
    // executes when the player gives up
    @IBAction func playerGiveUp(_ sender: UIButton) {
        // disable all the letters
        for index in 0..<currentWord.length {
            answerBoxes[index].image = convertImage(letter: currentWord.charArray[index])
            isTaken[index] = true
            choiceBlocks[index].isHidden = true
            choiceBlocks[index].isUserInteractionEnabled = false
        }
        // subtract scores for giving up
        if score >= 6 {
            score -= 6
        } else {
            score = 0
        }
        submit.isEnabled = false
        hint.isEnabled = false
        giveUp.isEnabled = false
        delete.isEnabled = false
        skip.isEnabled = false
        finish.isEnabled = false
        // put delay on the app and reset the game
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.resetGame()
        }
    }
    
    // delete the last word the user put in
    @IBAction func deleteLastOne(_ sender: UIButton) {
        // check if there are words already put in
        guard lastAnsBoxIndex.count > 0 && lastChoiceBoxIndex.count > 0 else {return}
        
        // delete the letter based on the sequence in the array
        answerBoxes[lastAnsBoxIndex[lastAnsBoxIndex.count - 1]].image = #imageLiteral(resourceName: "empty_box.png")
        isTaken[lastAnsBoxIndex[lastAnsBoxIndex.count - 1]] = false
        choiceBlocks[lastChoiceBoxIndex[lastChoiceBoxIndex.count - 1]].isHidden = false
        choiceBlocks[lastChoiceBoxIndex[lastChoiceBoxIndex.count - 1]].isUserInteractionEnabled = true
        lastAnsBoxIndex.remove(at: lastAnsBoxIndex.count - 1)
        lastChoiceBoxIndex.remove(at: lastChoiceBoxIndex.count - 1)
    }
    
    // skip word and subtract marks
    @IBAction func skipToNextWord(_ sender: UIButton) {
        resetGame()
        score /= 2
    }
    
    // execute when finish button is pressed
    @IBAction func finishGame(_ sender: UIButton) {
        // hide all buttons
        finish.isHidden = true
        delete.isHidden = true
        giveUp.isHidden = true
        skip.isHidden = true
        hint.isHidden = true
        submit.isHidden = true
        
        // hide empty boxes and choice letters
        for index in 0..<10 {
            answerBoxes[index].isHidden = true
            choiceBlocks[index].isHidden = true
        }
        
        endGameLabel.isHidden = false
        
        // display alert view and update userdefaults
        let alert = UIAlertController(title: "Game Over!", message: "You have finished the game.", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {
            textfield in textfield.placeholder = "please input a name"
        })
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { textfield in
            if let str = alert.textFields?.first?.text {
                self.name = str
                self.names.append(self.name ?? "")
                self.scores.append(self.score)
                UserDefaults.standard.set(self.names, forKey: "names")
                UserDefaults.standard.set(self.scores, forKey: "scores")
            }
        }))
        
        present(alert, animated: true)
    }
    
    // process of reset the game
    func resetGame() {
        // remove all the elements in the arrays
        isTaken.removeAll()
        boxes.removeAll()
        centers.removeAll()
        lastAnsBoxIndex.removeAll()
        lastChoiceBoxIndex.removeAll()
        
        submit.isEnabled = true
        hint.isEnabled = true
        giveUp.isEnabled = true
        delete.isEnabled = true
        skip.isEnabled = true
        finish.isEnabled = true
        
        // choose a random new word
        let randomWordIndex = Int.random(in: 0...19);
        category = Int.random(in: 1...3)
        if(category == 1) {
            currentWord.changeWord(newWord: foodWordBank[randomWordIndex])
        } else if (category == 2) {
            currentWord.changeWord(newWord: countryWordBank[randomWordIndex])
        } else if (category == 3) {
            currentWord.changeWord(newWord: animalWordBank[randomWordIndex])
        }
        
        // scramble the word
        currentWord.scramble()
        let scrambled = currentWord.scrambledArray
        print(currentWord.charArray)
        
        // display proper amount of empty boxes
        for index in 0..<answerBoxes.count {
            answerBoxes[index].isHidden = true
            choiceBlocks[index].isHidden = true
            choiceBlocks[index].isUserInteractionEnabled = false
        }
        
        // display proper amount of letters
        for index in 0..<currentWord.length {
            answerBoxes[index].image = #imageLiteral(resourceName: "empty_box.png")
            answerBoxes[index].isHidden = false
            boxes.append(answerBoxes[index].center)
            isTaken.append(false)
            
            choiceBlocks[index].image = convertImage(letter: scrambled[index])
            choiceBlocks[index].isHidden = false
            choiceBlocks[index].isUserInteractionEnabled = true
            centers.append(choiceBlocks[index].center)
        }
    }
    
    // function for assigning background
    func assignBackground(){
        let background = #imageLiteral(resourceName: "bg2.jpg")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
    // convert the letter to image based on the letter
    // a giant switch statement
    func convertImage(letter: Character) -> UIImage {
        var image = #imageLiteral(resourceName: "empty_box.png")
        switch letter {
        case "A":
            image = #imageLiteral(resourceName: "letter-a")
        case "B":
            image = #imageLiteral(resourceName: "letter-b.png")
        case "C":
            image = #imageLiteral(resourceName: "letter-c.png")
        case "D":
            image = #imageLiteral(resourceName: "letter-d.png")
        case "E":
            image = #imageLiteral(resourceName: "letter-e.png")
        case "F":
            image = #imageLiteral(resourceName: "letter-f.png")
        case "G":
            image = #imageLiteral(resourceName: "letter-g.png")
        case "H":
            image = #imageLiteral(resourceName: "letter-h")
        case "I":
            image = #imageLiteral(resourceName: "letter-i.png")
        case "J":
            image = #imageLiteral(resourceName: "letter-j.png")
        case "K":
            image = #imageLiteral(resourceName: "letter-k.png")
        case "L":
            image = #imageLiteral(resourceName: "letter-l.png")
        case "M":
            image = #imageLiteral(resourceName: "letter-m.png")
        case "N":
            image = #imageLiteral(resourceName: "letter-n.png")
        case "O":
            image = #imageLiteral(resourceName: "letter-o.png")
        case "P":
            image = #imageLiteral(resourceName: "letter-p.png")
        case "Q":
            image = #imageLiteral(resourceName: "letter-q.png")
        case "R":
            image = #imageLiteral(resourceName: "letter-r.png")
        case "S":
            image = #imageLiteral(resourceName: "letter-s.png")
        case "T":
            image = #imageLiteral(resourceName: "letter-t.png")
        case "U":
            image = #imageLiteral(resourceName: "letter-u.png")
        case "V":
            image = #imageLiteral(resourceName: "letter-v.png")
        case "W":
            image = #imageLiteral(resourceName: "letter-w.png")
        case "X":
            image = #imageLiteral(resourceName: "letter-x.png")
        case "Y":
            image = #imageLiteral(resourceName: "letter-y.png")
        case "Z":
            image = #imageLiteral(resourceName: "letter-z.png")
        default:
            break
        }
        return image
    }
    
}

