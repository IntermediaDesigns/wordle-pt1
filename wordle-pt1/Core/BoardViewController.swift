//
//  BoardViewController.swift
//  wordle
//
//  Created by Lynjai Jimenez on 2/10/25.
//

import UIKit

protocol BoardViewControllerDataSource: AnyObject {
    var currentGuesses: [[Character?]] { get }
    func boxColor(at indexPath: IndexPath) -> UIColor?
}

class BoardViewController: UIViewController, UICollectionViewDelegateFlowLayout,
                           UICollectionViewDelegate,
                           UICollectionViewDataSource
{
    
    weak var dataSource: BoardViewControllerDataSource?
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        let collectionView = UICollectionView(
            frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(
            KeyCell.self, forCellWithReuseIdentifier: KeyCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -20),
            collectionView.topAnchor.constraint(
                equalTo: view.topAnchor, constant: 30),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
    }
    
    public func reloadData() {
        collectionView.reloadData()
    }
}

extension BoardViewController {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.currentGuesses.count ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView, numberOfItemsInSection section: Int
    ) -> Int {
        let guesses = dataSource?.currentGuesses ?? []
        return guesses[section].count
    }
    
    func collectionView(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: KeyCell.identifier, for: indexPath)
                as? KeyCell
        else { fatalError() }
        
        // Get the box color (green or orange for correct/partial matches)
        let boxColor = dataSource?.boxColor(at: indexPath)
        
        // Set background color - use systemGray3 if no special color is specified
        cell.contentView.backgroundColor = boxColor ?? .systemGray3
        cell.layer.cornerRadius = 5
        
        // Set border based on cell color
        if boxColor == .systemGreen {
            cell.layer.borderWidth = 2
            cell.layer.borderColor = UIColor.black.cgColor
        } else {
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.systemGray4.cgColor
        }
        
        let guesses = dataSource?.currentGuesses ?? []
        if let letter = guesses[indexPath.section][indexPath.row] {
            cell.configure(with: letter)
        }
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        let margin: CGFloat = 20
        let size = CGFloat(collectionView.frame.width - margin) / 5
        return CGSize(width: size, height: size)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    }
    
    func collectionView(
        _ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath
    ) {
        
    }
}
