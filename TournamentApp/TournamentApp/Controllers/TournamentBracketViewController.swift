//
//  TournamentBracketViewController.swift
//  TournamentApp
//
//  Created by MacBook on 5/21/21.
//

import UIKit

class TournamentBracketViewController: BaseViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var viewInScrollHeight: NSLayoutConstraint!
    @IBOutlet weak var viewInScrollWidth: NSLayoutConstraint!
    
    // MARK: - Variable
    static let storyboardIdentifier = "TournamentBracketViewController"
    var playerList: [Player] = [Player]()
    var arrData = [
        ["a", "b", "c", "d", "e", "f", "g", "h", "a", "b", "c", "d", "e", "f", "g", "i","a", "b", "c", "d", "e", "f", "g", "h", "a", "b", "c", "d", "e", "f", "g", "i"],
        ["a", "b", "c", "d", "e", "f", "g", "h", "a", "b", "c", "d", "e", "f", "g", "i"],
        ["a", "b", "c", "d", "e", "f", "g", "h"],
        ["a", "b", "c", "d"],
        ["a", "d"],
        ["a"]
    ]
    
    var arrSeparatorSize = [Int]()
    
    var cellWidth = 0
    var cellHeight = 80
    var cellsGap = 0
    var levelHeight = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Draw"
        self.navigationItem.largeTitleDisplayMode = .never
        
        self.setupScrollView()
        self.setupCollectionView()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.cellWidth = Int(view.frame.width / 1.7)
    }
    
    // MARK: - UI
    
    private func setupScrollView() {
        self.scrollView.backgroundColor = .systemBackground
        self.scrollView.delegate = self
        self.scrollView.maximumZoomScale = 1.0
        self.scrollView.minimumZoomScale = 0.3
        self.scrollView.bounces = false
    }
    
    private func setupCollectionView() {
        self.collectionView.register(UINib(nibName: TournamentCollectionViewCell.identifier, bundle: nil),
                                     forCellWithReuseIdentifier: TournamentCollectionViewCell.identifier)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = .systemBackground
        self.collectionView.isScrollEnabled = false
        
        for index in 0..<self.arrData.count {
            if(index > 0) {
                var val = 0
                for item in self.arrSeparatorSize {
                    val += item
                }
                self.arrSeparatorSize.append(val + (cellHeight * index))
            } else {
                arrSeparatorSize.append(0)
            }
        }
    }
    
}

extension TournamentBracketViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollView.subviews[0]
    }
}

extension TournamentBracketViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewInScrollWidth.constant = CGFloat(Int(self.cellWidth + self.cellsGap) * self.arrData.count)
        
        if(self.arrData.count > 0) {
            
            if(self.arrData.count > 1){
                if(CGFloat((self.cellHeight + self.arrSeparatorSize[0]) * self.arrData[0].count) < CGFloat((self.cellHeight + self.arrSeparatorSize[1]) * self.arrData[1].count)) {
                    self.viewInScrollHeight.constant = CGFloat(((self.cellHeight + self.arrSeparatorSize[1]) * self.arrData[1].count) + self.levelHeight)
                } else {
                    self.viewInScrollHeight.constant = CGFloat(((self.cellHeight + self.arrSeparatorSize[0]) * self.arrData[0].count) + self.levelHeight)
                }
            } else {
                self.viewInScrollHeight.constant = CGFloat(((self.cellHeight + self.arrSeparatorSize[0]) * self.arrData[0].count) + self.levelHeight)
            }
        }
        
        return self.arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TournamentCollectionViewCell.identifier, for: indexPath) as? TournamentCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.tableView.dataSource = self
        cell.tableView.delegate = self
        
        cell.configure(indexPath: indexPath, tableViewTag: indexPath.row, sectionBracket: self.arrData.count)
        
        return cell
    }
}

extension TournamentBracketViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: CGFloat(self.cellWidth), height: self.viewInScrollHeight.constant )
        
        return size
    }
}

extension TournamentBracketViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var frame = tableView.frame
        if((tableView.tag - 1) >= 0) {
            frame.origin.y = CGFloat(((cellHeight / 2) + arrSeparatorSize[tableView.tag - 1]) + levelHeight)
        }
        
        tableView.frame = frame
        return arrData[tableView.tag].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TournamentTableViewCell.identifier) as? TournamentTableViewCell
        else {
            return UITableViewCell()
        }
        
        cell.configureUI(sectionBracket: self.arrData.count, tableViewTag: tableView.tag, indexPath: indexPath, arrSeparatorSize: self.arrSeparatorSize)
        
        return cell
    }
}

extension TournamentBracketViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(cellHeight + arrSeparatorSize[tableView.tag])
    }
}
