//
//  ImagePostDetailTableViewController.swift
//  LambdaTimeline
//
//  Created by Spencer Curtis on 10/14/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit

class ImagePostDetailTableViewController: UITableViewController {
    
    var player: Player
    
    var recorder: Recorder
    
    var recordButton = UIButton() {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    required init?(coder: NSCoder) {
        print("init(coder)")
        player = Player()
        recorder = Recorder()
        
        super.init(coder: coder)
        
        player.delegate = self
        recorder.delegate = self
    }
    
    func updateViews() {
        
        guard let imageData = imageData,
            let image = UIImage(data: imageData) else { return }
        
        title = post?.title
        
        imageView.image = image
        
        titleLabel.text = post.title
        authorLabel.text = post.author.displayName
    }
    
    private func setRecordButton() {
        
        if recorder.isRecording {
            recordButton.setImage(#imageLiteral(resourceName: "stop"), for: .normal)
        } else {
            recordButton.setImage(#imageLiteral(resourceName: "record"), for: .normal)
        }
    }
    
    @objc func recordButtonTapped() {
        recorder.toggleRecording()
    }
    
    // MARK: - Table view data source
    
    @IBAction func createComment(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add a comment", message: "Write your comment below:", preferredStyle: .alert)
        
        var commentTextField: UITextField?
        
        
        
        alert.addTextField { (textField) in
            textField.text = "   "
            textField.placeholder = "   Comment:"
            textField.leftViewMode = .always
            textField.leftView = self.recordButton
            
            let rect = CGRect(x: 0, y: 0, width: 10, height: 10)
          
            self.recordButton.contentRect(forBounds: rect)
            self.recordButton.setImage(#imageLiteral(resourceName: "record"), for: .normal)
            self.recordButton.addTarget(self, action: #selector(self.recordButtonTapped), for: .touchUpInside)
            commentTextField = textField
            
        }
        
        let addCommentAction = UIAlertAction(title: "Add Comment", style: .default) { (_) in
            
            guard let commentText = commentTextField?.text else { return }
            
            self.postController.addComment(with: commentText, to: &self.post!)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addCommentAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (post?.comments.count ?? 0) - 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath)
        
        let comment = post?.comments[indexPath.row + 1]
        
        cell.textLabel?.text = comment?.text
        cell.detailTextLabel?.text = comment?.author.displayName
        
        return cell
    }
    
    var post: Post!
    var postController: PostController!
    var imageData: Data?
    
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var imageViewAspectRatioConstraint: NSLayoutConstraint!
}

extension ImagePostDetailTableViewController: PlayerDelegate {
    func playerDidChangeState(player: Player) {
        // update the UI
        
        updateViews()
    }
}

extension ImagePostDetailTableViewController: RecorderDelegate {
    func recorderDidChangeState(recorder: Recorder) {
        updateViews()
    }
    
    func recorderDidSaveFile(recorder: Recorder) {
        updateViews()
        
        // TODO: Play the file
        if let url = recorder.url, recorder.isRecording == false {
            // Recording is finished, let's try and play the file
            
            player = Player()
            player.delegate = self
        }
    }
}
