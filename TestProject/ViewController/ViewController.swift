//
//  ViewController.swift
//  TestProject
//
//  Created by Ahmad Shaheer on 13/06/2024.
//

import UIKit

class ViewController: UIViewController {
    
    enum TableSection: Hashable {
        case main
    }
    
    //MARK: - IBOUTLETS
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var editViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewHeightCOnstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - PROPERTIES
    
    var keyboardHeight: CGFloat = 0.0
    var comment: [CommentModel] = [
        CommentModel(username: "ahmad", avatar: "", description: "This comment is my first comment on the post."),
        CommentModel(username: "hamid", avatar: "", description: "This comment is my second comment on the post."),
        CommentModel(username: "jaleel", avatar: "", description: "This comment is my third comment on the post."),
        CommentModel(username: "manan", avatar: "", description: "This comment is my fourth comment on the post."),
        CommentModel(username: "taseer", avatar: "", description: "This comment is my fifth comment on the post.")
    ]
    
    private lazy var tableViewDataSource: UITableViewDiffableDataSource<TableSection, CommentModel> = {
        let dataSource = UITableViewDiffableDataSource<TableSection, CommentModel>(tableView: tableView) {
            tableView, _, model in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CommentTableViewCell.self)) as? CommentTableViewCell else {
                return UITableViewCell()
            }
            
            cell.updateData(model: model)
            return cell
        }
        
        return dataSource
    }()
    
    
    //MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set delegate to monitor text changes
        textView.delegate = self
        
        textView.text = "Comment"
        textView.textColor = UIColor.lightGray
        
        configureTableView()
        
        
        // Set up keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Set initial height
        textViewDidChange(textView)
        
        //        tableView.dataSource = self
        tableView.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resignTextViewFirstResponder))
        view.addGestureRecognizer(tapGesture)
        
        configureInitialDiffableSnapshot()
    }
    
    //MARK: - SELECTOR METHODS
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        // Get keyboard height
        let keyboardHeight = keyboardFrame.height - 20
        
        // Animate UITextView frame adjustment to move it up
        UIView.animate(withDuration: 0.8) {
            self.editViewBottomConstraint.constant = keyboardHeight
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        // Animate UITextView frame adjustment to reset it to its original position
        UIView.animate(withDuration: 0.8) {
            self.editViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func resignTextViewFirstResponder() {
        textView.resignFirstResponder()
    }
    
    //MARK: - IBACTIONS
    
    @IBAction func sendBtnTap(_ sender: Any) {
        var oldSnapShot = tableViewDataSource.snapshot()
        oldSnapShot.appendItems([CommentModel(username: "ahad", avatar: "", description: "This is Ahad here!")])
        tableViewDataSource.apply(oldSnapShot, animatingDifferences: true)
    }
    
    
    //MARK: - PRIVATE METHODS
    
    private func configureTableView() {
        // Apply rounded border
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.backgroundColor = .white
        
        let nib = UINib(nibName: String(describing: CommentTableViewCell.self), bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: String(describing: CommentTableViewCell.self))
    }
    
    private func configureInitialDiffableSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<TableSection, CommentModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(comment, toSection: .main)
        tableViewDataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

// MARK: - UITEXTVIEW DELEGATE

extension ViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        // Update height based on content size
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        if size.height <= 100.0 {
            textViewHeightCOnstraint.constant = size.height
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Comment"
            textView.textColor = UIColor.lightGray
        }
    }
    
}

// MARK: - TABLEVIEW DELEGATE

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = UILabel()
        headerLabel.text = "Comments"
        headerLabel.textAlignment = .center
        headerLabel.textColor = .black
        headerLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        headerLabel.backgroundColor = .white
        
        return headerLabel
    }

}
