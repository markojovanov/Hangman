import UIKit

class ViewController: UIViewController {
    @IBOutlet var incorrectAnswersLabel: UILabel!
    @IBOutlet var levelLabel: UILabel!
    @IBOutlet var correctWordLabel: UILabel!
    @IBOutlet var inputTextField: UITextField!
    @IBOutlet var submitButton: UIButton!
    
    var incorrectAnswers = 0 {
        didSet {
            incorrectAnswersLabel.text = "Incorrect answers: \(incorrectAnswers)/7"
        }
    }
    var level = 1
    var words = [String]()
    var submitedWords = [String]()
    var correctWord = ""
    var correctLetters = [Character]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let wordsLevelURL = Bundle.main.url(forResource: "level1",
                                               withExtension: "txt") {
            if let wordsContent = try? String(contentsOf: wordsLevelURL) {
                words = wordsContent.components(separatedBy: "\n")
            }
        }
        submitButton.setTitle("SUBMIT",
                              for: .normal)
        loadLevel()
        
    }
    @IBAction func submitAnswer(_ sender: Any) {
        if inputTextField.text?.count == 1 {
            if correctWord.contains(inputTextField.text!.uppercased()) {
                correctLetters.append(contentsOf: inputTextField.text!.uppercased())
                correctWordLabel.text = ""
                correctLetter()
                if correctWordLabel.text == correctWord {
                    levelUp()
                }
            }
            else {
                incorrectAnswerSubmited()
            }
        }
        else if inputTextField.text?.count == correctWord.count {
            if inputTextField.text?.uppercased() == correctWord {
                correctWordLabel.text = correctWord
                levelUp()
            } else {
                incorrectAnswerSubmited()
            }
        } else {
            let ac = UIAlertController(title: "You are wrong",
                                       message: "Correct word is not that many letters",
                                       preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Try again",
                                       style: .default))
            present(ac, animated: true)
        }
        inputTextField.text = ""
    }
    func incorrectAnswerSubmited() {
        incorrectAnswers += 1
        if incorrectAnswers == 7 {
            if level > 1 {
                level -= 1
            }
            let ac = UIAlertController(title: "You lose",
                                       message: "You are level down again",
                                       preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Keep trying",
                                       style: .default))
            present(ac, animated: true)
            correctLetters.removeAll()
            loadLevel()
        } else {
            let ac = UIAlertController(title: "You are wrong",
                                       message: "You have \(7 - incorrectAnswers) attempts left",
                                       preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Try again",
                                       style: .default))
            present(ac, animated: true)
        }
    }
    func loadLevel() {
        words.shuffle()
        incorrectAnswers = 0
        levelLabel.text = "Level: \(level)"
        correctWordLabel.text = ""
        incorrectAnswersLabel.text = "Incorrect answers: \(incorrectAnswers)/7"
        while submitedWords.contains(words[0]) {
            words.shuffle()
        }
        correctWord = words[0]
        print(correctWord)
        for _ in 0..<words[0].count {
            correctWordLabel.text! += "?"
        }
    }
    func checkForWinner() {
        if level == 7 {
            let ac = UIAlertController(title: "Congratulations",
                                       message: "You passed all the levels",
                                       preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "I'm the best",
                                       style: .default))
            present(ac, animated: true)
            submitedWords.removeAll()
            correctLetters.removeAll()
            level = 1
        }
    }
    func correctLetter() {
        for letter in correctWord {
            if correctLetters.contains(letter) {
                correctWordLabel.text! += String(letter)
            } else {
                correctWordLabel.text! += "?"
            }
        }
    }
    func levelUp() {
        level += 1
        if level % 7 == 0 {
            checkForWinner()
        } else {
            let ac = UIAlertController(title: "Congratulations",
                                       message: "You guessed the correct word - \(correctWord)",
                                       preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Let's try new level",
                                       style: .default))
            present(ac, animated: true)
            correctLetters.removeAll()
        }
        submitedWords.append(correctWord)
        loadLevel()
    }
}

