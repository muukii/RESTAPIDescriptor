//
//  QueryParameterDescriptor.swift
//  RESTAPIDescriptor
//
//  Created by muukii on 2019/10/28.
//

import Foundation

public struct URLParameterDescriptor: Hashable {
  
  public struct Property: Hashable {
    public var key: String
    public var required: Bool
    public var valueDescription: String
  }
  
  public var properties: [Property] = []
  
  public init() {
    
  }
  
  public func addProperty(key: String, required: Bool, valueDescription: String) -> Self {
    var _self = self
    _self.properties.append(Property(key: key, required: required, valueDescription: valueDescription))
    return _self
  }
}
