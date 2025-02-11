//
//  ViewController.swift
//  wordle
//
//  Created by Lynjai Jimenez on 2/10/25.
//

import UIKit

class ViewController: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "GUESS THE WORDLE"
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    private func showVictoryAlert() {
        let alert = UIAlertController(
            title: "Congratulations! 🎉",
            message: "You guessed the word correctly!",
            preferredStyle: .alert
        )

        let playAgainAction = UIAlertAction(
            title: "Play Again", style: .default
        ) { [weak self] _ in
            self?.resetGame()
        }

        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel)

        alert.addAction(playAgainAction)
        alert.addAction(dismissAction)

        present(alert, animated: true)
    }

    private func showGameOverAlert() {
        let alert = UIAlertController(
            title: "Game Over",
            message: "The word was: \(answer). Would you like to try again?",
            preferredStyle: .alert
        )

        let tryAgainAction = UIAlertAction(title: "Try Again", style: .default)
        { [weak self] _ in
            self?.resetGame()
        }

        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel)

        alert.addAction(tryAgainAction)
        alert.addAction(dismissAction)

        present(alert, animated: true)
    }

    private func isGameOver() -> Bool {
        for row in guesses {
            if row.contains(nil) {
                return false
            }
        }
        return true
    }

    private func resetGame() {
        // Reset the game state
        answer = WordList.getRandomWord()
        guesses = Array(repeating: Array(repeating: nil, count: 5), count: 6)
        boardVC.reloadData()
    }

    var answer = ""

    private var guesses: [[Character?]] = Array(
        repeating: Array(repeating: nil, count: 5), count: 6)

    let keyboardVC = KeyboardViewController()
    let boardVC = BoardViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        answer = WordList.getRandomWord()
        view.backgroundColor = .systemGray6
        addChildren()
    }

    private func addChildren() {
        view.addSubview(titleLabel)

        addChild(keyboardVC)
        keyboardVC.didMove(toParent: self)
        keyboardVC.delegate = self
        keyboardVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyboardVC.view)

        addChild(boardVC)
        boardVC.didMove(toParent: self)
        boardVC.view.translatesAutoresizingMaskIntoConstraints = false
        boardVC.dataSource = self
        view.addSubview(boardVC.view)

        addConstraints()
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            boardVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            boardVC.view.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            boardVC.view.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor, constant: 10),
            boardVC.view.bottomAnchor.constraint(
                equalTo: keyboardVC.view.topAnchor),
            boardVC.view.heightAnchor.constraint(
                equalTo: view.heightAnchor, multiplier: 0.6),

            keyboardVC.view.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            keyboardVC.view.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            keyboardVC.view.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

}

extension ViewController: KeyboardViewControllerDelegate {
    func keyboardViewController(
        _ keyboardViewController: KeyboardViewController,
        didTapKey letter: Character
    ) {
        // Update guesses
        var stop = false
        for i in 0..<guesses.count {
            for j in 0..<guesses[i].count {
                if guesses[i][j] == nil {
                    guesses[i][j] = letter
                    stop = true
                    break
                }
            }
            if stop {
                break
            }
        }

        boardVC.reloadData()

        // Check if user completed a word
        for row in 0..<guesses.count {
            let rowGuesses = guesses[row]
            if rowGuesses.compactMap({ $0 }).count == 5 {
                let guessWord = String(rowGuesses.compactMap({ $0 }))
                if guessWord == answer {
                    // User won! Show victory popup after a short delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        [weak self] in
                        self?.showVictoryAlert()
                    }
                    return
                }
                // Check if this was the last row and the guess was wrong
                if row == guesses.count - 1 || isGameOver() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        [weak self] in
                        self?.showGameOverAlert()
                    }
                    return
                }
            }
        }
    }
}

extension ViewController: BoardViewControllerDataSource {
    var currentGuesses: [[Character?]] {
        return guesses
    }

    func boxColor(at indexPath: IndexPath) -> UIColor? {
        let rowIndex = indexPath.section
        let count = guesses[rowIndex].compactMap({ $0 }).count
        guard count == 5 else {
            return nil
        }
        let indexedAnswer = Array(answer)

        guard let letter = guesses[indexPath.section][indexPath.row],
            indexedAnswer.contains(letter)
        else {
            return nil
        }

        if indexedAnswer[indexPath.row] == letter {
            return .systemGreen
        }

        return .systemOrange
    }

}
