//
//  ChatTextCell.swift
//  Chat
//
//  Created by Nikolay Scherbakov on 19.07.2024.
//

import UIKit

class ChatTextCell: UITableViewCell {
  
  @IBOutlet private weak var messageLabel: UILabel!
  @IBOutlet private weak var bubbleView: UIView!
  private var deleteAction: ((UITableViewCell) -> Void)?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    configureCell()
    setupContextMenu()
  }
  
  func updateWith(message: String?, deleteAction: ((UITableViewCell) -> Void)?) {
    messageLabel.text = message
    self.deleteAction = deleteAction
  }
}

// MARK: - Private
private extension ChatTextCell {
  func makeContextMenu() -> UIMenu {
    let delete = UIAction(
      title: "Delete Message",
      image: UIImage(systemName: "trash"),
      attributes: .destructive
    ) { [weak self] action in
      guard let self = self else { return }
      self.deleteAction?(self)
    }

    return UIMenu(title: "Actions", children: [delete])
  }
  
  func setupContextMenu() {
    let interaction = UIContextMenuInteraction(delegate: self)
    bubbleView.addInteraction(interaction)
  }
  
  func configureCell() {
    transform = CGAffineTransform(scaleX: 1, y: -1)
    selectionStyle = .none
    bubbleView.layer.cornerRadius = 8
  }
}

// MARK: - UIContextMenuInteractionDelegate
extension ChatTextCell: UIContextMenuInteractionDelegate {
  func contextMenuInteraction(
    _ interaction: UIContextMenuInteraction,
    configurationForMenuAtLocation location: CGPoint
  ) -> UIContextMenuConfiguration? {
    
    return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { _ in
      return self.makeContextMenu()
    })
  }
}
