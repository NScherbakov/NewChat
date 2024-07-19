//
//  ChatViewController.swift
//  Chat
//
//  Created by Nikolay Scherbakov on 17.07.2024.
//

import UIKit
import Photos
import BSImagePicker

protocol ChatView: AnyObject {
  func reloadView()
  func removeObject(at index: Int)
}

class ChatViewController: UIViewController {
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet private weak var textFieldYPosition: NSLayoutConstraint!
  
  private var presenter: ChatViewPresenter!

  override func viewDidLoad() {
    super.viewDidLoad()
    setupPresenter()
    configureTableView()
    setupHideKeyboardOnTap()
    registerNotifications()
  }
  
  @IBAction func sendImages() {
    let imagePicker = ImagePickerController()

    presentImagePicker(imagePicker, select: { (asset) in
    }, deselect: { _ in
    }, cancel: { _ in
    }, finish: { [weak self] assets in
      self?.presenter.addMessage(assets: assets)
    })
  }
}

// MARK: ChatView
extension ChatViewController: ChatView {
  func reloadView() {
    tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .right)
  }
  
  func removeObject(at index: Int) {
    tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .right)
  }
}

// MARK: UITableViewDataSource
extension ChatViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    presenter.itemsCount()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let message = presenter.itemsAt(index: indexPath.row) else { return UITableViewCell() }
    switch message.kind {
      case .images(let images):
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatImagesCell", for: indexPath) as? ChatImagesCell
        guard let cell = cell else { return UITableViewCell() }

        cell.updateWith(images: images) { [weak self] cell in
          self?.tappedDelete(cell: cell)
        }
        return cell
        
      case .text(let text):
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTextCell", for: indexPath) as? ChatTextCell
        guard let cell = cell else { return UITableViewCell() }

        cell.updateWith(message: text) { [weak self] cell in
          self?.tappedDelete(cell: cell)
        }
        return cell
    }
  }
}

// MARK: UITextFieldDelegate
extension ChatViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    guard let text = textField.text else { return false }
    presenter.addMessage(text: text)
    
    textField.text = ""
    return true
  }
}

// MARK: Private
private extension ChatViewController {
  func tappedDelete(cell: UITableViewCell) {
    guard let indexPath = tableView.indexPath(for: cell) else { return }
    presenter.deleteMessage(at: indexPath.row)
  }
  
  func setupPresenter() {
    presenter = ChatPresenter()
    presenter.view = self
  }
  
  func configureTableView() {
    tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
    tableView.separatorStyle = .none
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 44.0
    tableView.register(
      UINib(nibName: "ChatTextCell", bundle: nil),
      forCellReuseIdentifier: "ChatTextCell"
    )
    tableView.register(
      UINib(nibName: "ChatImagesCell", bundle: nil),
      forCellReuseIdentifier: "ChatImagesCell"
    )
  }
  
  func registerNotifications() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
  }
  
  @objc func keyboardWillShow(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      textFieldYPosition.constant = keyboardSize.height
      view.layoutIfNeeded()
    }
  }
  
  @objc func keyboardWillHide(notification: NSNotification) {
    textFieldYPosition.constant = 0
    view.layoutIfNeeded()
  }
}
