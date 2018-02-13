//
//  PromptData.swift
//  PocketPrompter
//
//  Created by Balakumaran Srirangaswamy on 9/8/17.
//  Copyright © 2017 Bala. All rights reserved.
//

import UIKit

class PromptData: NSObject {
    
    //MARK: Properties
    
    var title: String?
    var dataText: String?
    
    //MARK: Initialization
    
    init?(title: String, dataText: String) {
        
        // Initialize stored properties.
        self.title = title
        self.dataText = dataText
        
    }

}

enum SavedUserData: String {
    case title = "title"
    case bodyText = "bodyText"
    case bodyImage = "bodyImage"
}
