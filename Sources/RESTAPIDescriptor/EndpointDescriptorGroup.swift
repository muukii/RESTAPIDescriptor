//
//  EndpointDescriptorGroup.swift
//  RESTAPIDescriptor
//
//  Created by muukii on 2019/10/28.
//

import Foundation

public struct EndpointDescriptorGroup {
  
  public let name: String
  public var endpoints: Set<EndpointDescriptor>
  
  public init(name: String, endpoints: [EndpointDescriptor]) {
    self.name = name
    self.endpoints = .init(endpoints)
  }
}
