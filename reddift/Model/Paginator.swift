//
//  Paginator.swift
//  reddift
//
//  Created by sonson on 2015/04/14.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

/**
Paginator object for paiging listing object.
*/
public struct Paginator {
	let after:String
	let before:String
    let modhash:String
    
    public init() {
        self.after = ""
        self.before = ""
        self.modhash = ""
    }
	
    public init(after:String, before:String, modhash:String) {
		self.after = after
		self.before = before
        self.modhash = modhash
	}
	
	public var isVacant : Bool {
		if (!after.isEmpty) || (!before.isEmpty) {
			return false
		}
		return true
	}
    
    /**
    Generate dictionary to add query parameters to URL.
	If paginator is vacant, returns vacant dictionary as [String:String].
    
    :returns: Dictionary object for paging.
    */
    public func parameters() -> [String:String] {
        var dict:[String:String] = [:]
        if count(after) > 0 {
            dict["after"] = after
        }
        if count(before) > 0 {
            dict["before"] = before
        }
        return dict
    }
}
