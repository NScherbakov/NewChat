//
//  Message.swift
//  Chat
//
//  Created by Nikolay Scherbakov on 17.07.2024.
//

import UIKit

struct Message {
  enum Kind {
    case text(String)
    case images([UIImage])
  }
  
  let kind: Kind
}
