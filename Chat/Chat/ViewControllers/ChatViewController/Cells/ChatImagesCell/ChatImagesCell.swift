//
//  ChatImagesCell.swift
//  Chat
//
//  Created by Nikolay Scherbakov on 19.07.2024.
//

import UIKit

class ChatImagesCell: UITableViewCell {
  private let scrollView: UIScrollView = {
    let view = UIScrollView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private let scrollStackViewContainer: UIStackView = {
    let view = UIStackView()
    view.axis = .horizontal
    view.spacing = 5
    view.alignment = .trailing
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private var deleteAction: ((UITableViewCell) -> Void)?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    configureCell()
    setupContextMenu()
  }
  
  func updateWith(images: [UIImage]?, deleteAction: ((UITableViewCell) -> Void)?) {
    guard let images else { return }
    self.deleteAction = deleteAction
    
    let margins = contentView.layoutMarginsGuide

    contentView.addSubview(scrollView)
    scrollView.addSubview(scrollStackViewContainer)
    
    if CGFloat(images.count) * 100.0 < contentView.frame.size.width {
      let size = contentView.frame.size.width - CGFloat(images.count) * 100.0
      scrollView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: size).isActive =  true
    } else {
      scrollView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive =  true
    }

    scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    scrollView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    scrollView.addSubview(scrollStackViewContainer)
    
    scrollStackViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
    scrollStackViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
    scrollStackViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
    scrollStackViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    scrollStackViewContainer.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
    
    images.forEach {
      let imageView = UIImageView(image: $0)
      imageView.contentMode = .scaleAspectFit
      imageView.translatesAutoresizingMaskIntoConstraints = false
      imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
      scrollStackViewContainer.addArrangedSubview(imageView)
    }
  }
}

// MARK: Private
private extension ChatImagesCell {
  func makeContextMenu() -> UIMenu {
    let delete = UIAction(
      title: "Delete Images",
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
    scrollStackViewContainer.addInteraction(interaction)
  }
  
  func configureCell() {
    transform = CGAffineTransform(scaleX: 1, y: -1)
    selectionStyle = .none
  }
}

// MARK: - UIContextMenuInteractionDelegate
extension ChatImagesCell: UIContextMenuInteractionDelegate {
  func contextMenuInteraction(
    _ interaction: UIContextMenuInteraction,
    configurationForMenuAtLocation location: CGPoint
  ) -> UIContextMenuConfiguration? {
    
    return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { _ in
      return self.makeContextMenu()
    })
  }
}
