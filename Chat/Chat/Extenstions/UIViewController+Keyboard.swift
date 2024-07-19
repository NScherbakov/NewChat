//
//  UIViewController+Keyboard.swift
//  Chat
//
//  Created by Nikolay Scherbakov on 23.01.2024.
//

import UIKit

extension UIViewController {
  func setupHideKeyboardOnTap() {
    self.view.addGestureRecognizer(self.endEditingRecognizer())
    self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
  }
  
  /// Dismisses the keyboard from self.view
  private func endEditingRecognizer() -> UIGestureRecognizer {
    let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
    tap.cancelsTouchesInView = false
    return tap
  }
}
