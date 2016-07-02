//
//  CommonResourceOperation.swift
//  LoadIt
//
//  Created by Luciano Marisi on 02/07/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation
import LoadIt

final class CommonResourceOperation<ResourceService: ResourceServiceType>: BaseOperation, ResourceOperationType {
  
  typealias Resource = ResourceService.Resource
  
  private let resource: Resource
  private let service: ResourceService
  
  var didFinishFetchingResourceCallback: ((CommonResourceOperation<ResourceService>, Result<Resource.Model>) -> Void)?
  
  init(resource: ResourceService.Resource, service: ResourceService = ResourceService()) {
    self.resource = resource
    self.service = service
    super.init()
  }
  
  override func execute() {
    fetch(resource: resource, usingService: service)
  }
  
  func didFinishFetchingResource(result result: Result<Resource.Model>) {
    didFinishFetchingResourceCallback?(self, result)
  }
  
}
