//
//  ChatViewPresenter.swift
//  Chat
//
//  Created by Nikolay Scherbakov on 17.07.2024.
//

import UIKit
import Photos

protocol ChatViewPresenter {
  var view: ChatView? {get set}
  func itemsCount() -> Int
  func itemsAt(index: Int) -> Message?
  func addMessage(text: String)
  func addMessage(assets:  [PHAsset])
  func deleteMessage(at index: Int)
}

class ChatPresenter: ChatViewPresenter {
  weak var view: ChatView?
  private var messages: [Message] = []
  
  func itemsCount() -> Int {
    return messages.count
  }
  
  func itemsAt(index: Int) -> Message? {
    guard messages.count > index else { return nil }
    return messages[index]
  }
  
  func addMessage(text: String) {
    messages.insert(.init(kind: .text(text)), at: 0)
    view?.reloadView()
  }
  
  func deleteMessage(at index: Int) {
    messages.remove(at: index)
    view?.removeObject(at: index)
  }
  
  func addMessage(assets: [PHAsset]) {
    var images: [UIImage?] = []
    
    let dispatchGroup = DispatchGroup()
    assets.forEach {
      dispatchGroup.enter()
      
      PHImageManager.default().requestImage(
        for: $0,
        targetSize: CGSize(width: 100, height: 100),
        contentMode: .aspectFit,
        options: nil) { (image, info) in
          images.append(image)
          dispatchGroup.leave()
      }
    }
    
    dispatchGroup.notify(queue: .main) {
      let images = images.compactMap { $0 }
      let messageImages = Message.init(kind: .images(images))
      
      self.messages.insert(messageImages, at: 0)
      self.view?.reloadView()
    }
  }
}
