//
//  ChatComponent.swift
//  Minecraft
//
//  Created by Rohan van Klinken on 16/2/21.
//

import Foundation

protocol ChatComponent {
  var style: ChatStyle { get set }
  var siblings: [ChatComponent] { get set }
  
  init(from json: JSON, locale: MinecraftLocale)
  
  func toText() -> String
}


