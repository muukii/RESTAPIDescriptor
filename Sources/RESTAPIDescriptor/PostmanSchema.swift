//
//  PostmanSchema.swift
//  APIDescriptor
//
//  Created by muukii on 2019/09/30.
//

import Foundation

struct AnyCodingKey: CodingKey {
  
  var stringValue: String
  
  init(_ string: String) {
    self.stringValue = string
  }
  
  init?(stringValue: String) {
    self.stringValue = stringValue
  }
  
  var intValue: Int?
  
  init?(intValue: Int) {
    self.stringValue = ""
    self.intValue = intValue
  }
    
}

public struct PostmanSchema: Encodable {
  
  public struct Info: Encodable {
    public var _postman_id: String
    public var name: String
    public var schema: String = "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
    
    public init(_postman_id: String, name: String) {
      self._postman_id = _postman_id
      self.name = name
    }
    
  }
  
  public struct Request: Encodable {
        
    var method: Endpoint.Method
    var url: String
    var description: String
   
    public init(
      method: Endpoint.Method,
      url: String,
      description: String
    ) {
      self.method = method
      self.url = url
      self.description = description
    }
  }
  
  public enum ItemNode: Encodable {
    case item(Item)
    case itemGroup(ItemGroup)
  
    public func encode(to encoder: Encoder) throws {
      switch self {
      case .item(let item):
        try item.encode(to: encoder)
      case .itemGroup(let itemGroup):
        try itemGroup.encode(to: encoder)
      }
    }
  }
  
  public struct ItemGroup: Encodable {
        
    public var name: String
    public var items: [ItemNode]
    public var description: String
    
    public init(name: String, items: [ItemNode], description: String) {
      self.name = name
      self.items = items
      self.description = description
    }
  }
  
  public struct Item: Encodable {
    public var name: String
    public var request: Request
    
    public init(
      name: String,
      request: Request
    ) {
      self.name = name
      self.request = request
    }
            
    public init(endpoint: Endpoint) {
      self.name = endpoint.name
      self.request = .init(method: endpoint.method, url: endpoint.path, description: endpoint.description)
    }
  }
  
  public var info: Info
  public var items: [ItemNode]
  
  public init(info: Info, items: [ItemNode]) {
    self.info = info
    self.items = items
  }
}
