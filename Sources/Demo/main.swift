
import RESTAPIDescriptor

let shopItem = JSONObjectDescriptor(name: "shopItem")
  .addProperty("stock", .number, .required)

let shopGroup = JSONObjectDescriptor(name: "shopItemGroup")
  .addProperty("category", .string, .required)
  .addProperty("instances", .array(.object(shopItem)), .required)

let shopItemListResponse = JSONObjectDescriptor(name: "shopItemListResponse")
  .addProperty("instances", .array(.object(shopGroup)), .required)

let firstEndpoint = EndpointDescriptor(
  path: "hoo/foo",
  method: .get,
  request: .init(header: nil, urlParameter: nil, body: nil),
  response: .init(header: nil, body: .json(.object(shopItemListResponse))),
  description: """
"""
)

let group = EndpointDescriptorGroup(
  name: "MyAPI",
  endpoints:  [
    firstEndpoint
  ]
)

class MyVisitor: EndpointsVisitor {
  override func visit(_ jsonValue: JSONValueDescriptor) {
    print(jsonValue)
    super.visit(jsonValue)
  }
}

let visitor = MyVisitor()
visitor.visit(group)

