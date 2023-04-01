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
    private var playerList: [Player]
    private var matchInEachBracket: [[Match]] = []
    private let numberOfMatchInEachBracketData: [Int] = [16,8,4,2,1]
    private var drawPositionForPlayers: [[Int]] = []
    private let hapticsManager: HapticsManagerProvider
    private var separatorSize = [Int]()
    private var cellWidth = 0
    private let cellHeight = 80
    private let cellsGap = 0
    private let levelHeight = 60
    
    
    // MARK: - Initialization
    
    init?(coder: NSCoder, playerList: [Player], hapticsManager: HapticsManagerProvider) {
        self.playerList = playerList
        self.hapticsManager = hapticsManager
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use `init(coder::)` to initialize an `TournamentBracketViewController` instance.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Draw"
        
        let result = SetDraw.shared.setDrawForPlayer(for: numberOfMatchInEachBracketData, with: &playerList)
        self.drawPositionForPlayers = result.drawPositionForPlayers
        self.matchInEachBracket = result.matchInEachBracket
        
        self.setupVC()
        self.setupScrollView()
        self.setupCollectionView()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.cellWidth = Int(view.frame.width / 1.7)
    }
    
    // MARK: - UI
    
    private func setupVC() {
        self.navigationItem.largeTitleDisplayMode = .never
        let winnerButton = UIBarButtonItem(
            title: "Winner",
            style: .done,
            target: self,
            action: #selector(didTapAddDWinnerButton)
        )
        
        navigationItem.rightBarButtonItems = [winnerButton]
    }
    
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
        
        for index in 0..<self.numberOfMatchInEachBracketData.count {
            if(index > 0) {
                var val = 0
                for item in self.separatorSize {
                    val += item
                }
                self.separatorSize.append(val + (cellHeight * index))
            } else {
                separatorSize.append(0)
            }
        }
    }
    
    // MARK: - Actions
    
    @objc private func didTapAddDWinnerButton() {
        let winnerPlayerIndex = self.drawPositionForPlayers[self.numberOfMatchInEachBracketData.count][0] - 1
        let winnerPlayer = self.playerList[winnerPlayerIndex]
        
        UIAlertController.showAlertUserMessage(self, title: "Winner", message: "\(winnerPlayer.firstName) \(winnerPlayer.lastName)")
        hapticsManager.vibrate(for: .success)
    }
    
}

extension TournamentBracketViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollView.subviews[0]
    }
}

extension TournamentBracketViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewInScrollWidth.constant = CGFloat(Int(self.cellWidth + self.cellsGap) * self.numberOfMatchInEachBracketData.count)
        
        if(self.numberOfMatchInEachBracketData.count > 0) {
            
            if(self.numberOfMatchInEachBracketData.count > 1){
                if(CGFloat((self.cellHeight + self.separatorSize[0]) * self.numberOfMatchInEachBracketData[0]) < CGFloat((self.cellHeight + self.separatorSize[1]) * self.numberOfMatchInEachBracketData[1])) {
                    self.viewInScrollHeight.constant = CGFloat(((self.cellHeight + self.separatorSize[1]) * self.numberOfMatchInEachBracketData[1]) + self.levelHeight)
                } else {
                    self.viewInScrollHeight.constant = CGFloat(((self.cellHeight + self.separatorSize[0]) * self.numberOfMatchInEachBracketData[0]) + self.levelHeight)
                }
            } else {
                self.viewInScrollHeight.constant = CGFloat(((self.cellHeight + self.separatorSize[0]) * self.numberOfMatchInEachBracketData[0]) + self.levelHeight)
            }
        }
        
        return self.numberOfMatchInEachBracketData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TournamentCollectionViewCell.identifier, for: indexPath) as? TournamentCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.tableView.dataSource = self
        cell.tableView.delegate = self
        
        cell.configure(indexPath: indexPath, tableViewTag: indexPath.row, sectionBracket: self.numberOfMatchInEachBracketData.count)
        
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
            frame.origin.y = CGFloat(((cellHeight / 2) + separatorSize[tableView.tag - 1]) + levelHeight)
        }
        
        tableView.frame = frame
        return numberOfMatchInEachBracketData[tableView.tag]
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TournamentTableViewCell.identifier) as? TournamentTableViewCell
        else {
            return UITableViewCell()
        }
        
        cell.configureUI(sectionBracket: self.numberOfMatchInEachBracketData.count, tableViewTag: tableView.tag, indexPath: indexPath, separatorSize: self.separatorSize)
        
        let match = self.matchInEachBracket[tableView.tag][indexPath.row]

        cell.configureData(with: match)
        
        return cell
    }
}

extension TournamentBracketViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(cellHeight + separatorSize[tableView.tag])
    }
}

// MARK: - StoryboardInstantiable
extension TournamentBracketViewController: StoryboardInstantiable {
    public class func instantiate(playerList: [Player], hapticsManager: HapticsManagerProvider) -> TournamentBracketViewController {
        let tournamentBracketViewController = instanceFromStoryboard(nil) { coder -> TournamentBracketViewController? in
            TournamentBracketViewController(coder: coder, playerList: playerList, hapticsManager: hapticsManager)
        }
        return tournamentBracketViewController
    }
}
