//
//  Parser.swift
//  reddift
//
//  Created by sonson on 2015/04/20.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

/**
Uitility class.
Parser class parses JSON and generates objects from it.
*/
class Parser: NSObject {
	/**
	Parse thing object in JSON.
	This method dispatches element of JSON to eithr methods to extract classes derived from Thing class.
	*/
    class func parseThing(json:JSONDictionary) -> Any? {
        if let data = json["data"] as? JSONDictionary, kind = json["kind"] as? String {
            switch(kind) {
            case "t1":
                // comment
                return Comment(data:data)
            case "t2":
                // account
                return Account(data:data)
            case "t3":
                // link
                return Link(data:data)
            case "t4":
				// mesasge
                return Message(data:data)
            case "t5":
                // subreddit
                return Subreddit(data:data)
			case "more":
                return More(data:data)
            case "LabeledMulti":
                return Multireddit(json: data)
            case "LabeledMultiDescription":
                return MultiredditDescription(json: data)
            default:
                break
            }
        }
        return nil
    }
	
	/**
	Parse list object in JSON
	*/
    class func parseListing(json:JSONDictionary) -> Listing {
        var list:[Thing] = []
        var paginator:Paginator? = Paginator()
        
        if let data = json["data"] as? JSONDictionary {
            if let children = data["children"] as? JSONArray {
                for child in children {
                    if let child = child as? JSONDictionary {
                        let obj:Any? = parseJSON(child)
                        if let obj = obj as? Thing {
                            list.append(obj)
                        }
                    }
                }
            }
            
            if data["after"] != nil || data["before"] != nil {
                var a:String = data["after"] as? String ?? ""
                var b:String = data["before"] as? String ?? ""
                
                if !a.isEmpty || !b.isEmpty {
                    paginator = Paginator(after: a, before: b, modhash: data["modhash"] as? String ?? "")
                }
            }
        }
        return Listing(children:list, paginator: paginator ?? Paginator())
    }
    
	/**
	Parse JSON of the style which is Thing.
	*/
    class func parseJSON(json:JSON) -> RedditAny? {
        // array
        // json->[AnyObject]
        if let array = json as? JSONArray {
            var output:[Any] = []
            for element in array {
                if let element = element as? JSONDictionary {
                    let obj:Any? = self.parseJSON(element)
                    if let obj:Any = obj {
                        output.append(obj)
                    }
                }
            }
            return output;
        }
		// dictionary
		// json->JSONDictionary
        else if let json = json as? JSONDictionary {
            if let kind = json["kind"] as? String {
                if kind == "Listing" {
                    let listing = parseListing(json)
                    return listing
                }
                else {
                    return parseThing(json)
                }
            }
        }
        return nil
    }
}
