import Foundation

/// Simple XML parser.
public class SWXMLHash {
    /**
    Method to parse XML passed in as a string.
    
    :param: xml The XML to be parsed
    
    :returns: An XMLIndexer instance that is used to look up elements in the XML
    */
    class public func parse(xml: String) -> XMLIndexer {
        return parse((xml as NSString).dataUsingEncoding(NSUTF8StringEncoding)!)
    }
    
    /**
    Method to parse XML passed in as an NSData instance.
    
    :param: xml The XML to be parsed
    
    :returns: An XMLIndexer instance that is used to look up elements in the XML
    */
    class public func parse(data: NSData) -> XMLIndexer {
        var parser = XMLParser()
        return parser.parse(data)
    }
}// end class SWXMLHash

/// The implementation of NSXMLParserDelegate and where the parsing actually happens.
class XMLParser : NSObject, NSXMLParserDelegate {
    var parsingElement: String = ""
    
    override init() {
        currentNode = root
        super.init()
    }
    
    var lastResults: String = ""
    
    var root = XMLElement(name: "root")
    var currentNode: XMLElement
    var parentStack = [XMLElement]()
    
    func parse(data: NSData) -> XMLIndexer {
        // clear any prior runs of parse... expected that this won't be necessary, but you never know
        parentStack.removeAll(keepCapacity: false)
        root = XMLElement(name: "root")
        
        parentStack.append(root)
        
        let parser = NSXMLParser(data: data)
        parser.delegate = self
        parser.parse()
        
        return XMLIndexer(root)
    }
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName: String!, attributes attributeDict: NSDictionary!) {
        
        self.parsingElement = elementName
        
        currentNode = parentStack[parentStack.count - 1].addElement(elementName, withAttributes: attributeDict)
        parentStack.append(currentNode)
        
        lastResults = ""
    }
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        if parsingElement == currentNode.name {
            lastResults += string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
    }
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        parsingElement = elementName
        
        if !lastResults.isEmpty {
            currentNode.text = lastResults
        }
        
        parentStack.removeLast()
    }
}

/// Returned from SWXMLHash, allows easy element lookup into XML data.
public enum XMLIndexer : SequenceType {
    case Element(XMLElement)
    case List([XMLElement])
    case Error(NSError)
    
    /// The underlying XMLElement at the currently indexed level of XML.
    public var element: XMLElement? {
        get {
            switch self {
            case .Element(let elem):
                return elem
            default:
                return nil
            }
        }
    }
    
    /// The underlying array of XMLElements at the currently indexed level of XML.
    public var all: [XMLIndexer] {
        get {
            switch self {
            case .List(let list):
                var xmlList = [XMLIndexer]()
                for elem in list {
                    xmlList.append(XMLIndexer(elem))
                }
                return xmlList
            case .Element(let elem):
                return [XMLIndexer(elem)]
            default:
                return []
            }
        }
    }
    
    /**
    Initializes the XMLIndexer
    
    :param: _ should be an instance of XMLElement, but supports other values for error handling
    
    :returns: instance of XMLIndexer
    */
    public init(_ rawObject: AnyObject) {
        switch rawObject {
        case let value as XMLElement:
            self = .Element(value)
        default:
            self = .Error(NSError(domain: "SWXMLDomain", code: 1000, userInfo: nil))
        }
    }
    
    /**
    Find an XML element at the current level by element name
    
    :param: key The element name to index by
    
    :returns: instance of XMLIndexer to match the element (or elements) found by key
    */
    public subscript(key: String) -> XMLIndexer {
        get {
            let userInfo = [NSLocalizedDescriptionKey: "XML Element Error: Incorrect key [\"\(key)\"]"]
            switch self {
            case .Element(let elem):
                if let match = elem.elements[key] {
                    if match.count == 1 {
                        return .Element(match[0])
                    }
                    else {
                        return .List(match)
                    }
                }
                return .Error(NSError(domain: "SWXMLDomain", code: 1000, userInfo: userInfo))
            default:
                return .Error(NSError(domain: "SWXMLDomain", code: 1000, userInfo: userInfo))
            }
        }
    }
    
    /**
    Find an XML element by index within a list of XML Elements at the current level
    
    :param: index The 0-based index to index by
    
    :returns: instance of XMLIndexer to match the element (or elements) found by key
    */
    public subscript(index: Int) -> XMLIndexer {
        get {
            let userInfo = [NSLocalizedDescriptionKey: "XML Element Error: Incorrect index [\"\(index)\"]"]
            switch self {
            case .List(let list):
                if index <= list.count {
                    return .Element(list[index])
                }
                return .Error(NSError(domain: "SWXMLDomain", code: 1000, userInfo: userInfo))
            case .Element(let elem):
                if index == 0 {
                    return .Element(elem)
                }
                else {
                    return .Error(NSError(domain: "SWXMLDomain", code: 1000, userInfo: userInfo))
                }
            default:
                return .Error(NSError(domain: "SWXMLDomain", code: 1000, userInfo: userInfo))
            }
        }
    }
    
    typealias GeneratorType = XMLIndexer
    
    public func generate() -> IndexingGenerator<[XMLIndexer]> {
        return all.generate()
    }
}

/// XMLIndexer extensions
extension XMLIndexer: BooleanType {
    /// True if a valid XMLIndexer, false if an error type
    public var boolValue: Bool {
        get {
            switch self {
            case .Error:
                return false
            default:
                return true
            }
        }
    }
}

/// Models an XML element, including name, text and attributes
public class XMLElement {
    /// The name of the element
    public let name: String
    /// The inner text of the element, if it exists
    public var text: String?
    /// The attributes of the element
    public var attributes = [String:String]()
    
    var elements = [String:[XMLElement]]()
    
    /**
    Initialize an XMLElement instance
    
    :param: name The name of the element to be initialized
    
    :returns: a new instance of XMLElement
    */
    init(name: String) {
        self.name = name
    }
    
    /**
    Adds a new XMLElement underneath this instance of XMLElement
    
    :param: name The name of the new element to be added
    :param: withAttributes The attributes dictionary for the element being added
    
    :returns: The XMLElement that has now been added
    */
    func addElement(name: String, withAttributes attributes: NSDictionary) -> XMLElement {
        let element = XMLElement(name: name)
        
        if var group = elements[name] {
            group.append(element)
            elements[name] = group
        }
        else {
            elements[name] = [element]
        }
        
        for (keyAny,valueAny) in attributes {
            let key = keyAny as String
            let value = valueAny as String
            element.attributes[key] = value
        }
        
        return element
    }
}
//////

let xmlToParse = "<root><header><title>Test Title Header</title></header><catalog><book id=\"bk101\"><author>Gambardella, Matthew</author><title>XML Developer's Guide</title><genre>Computer</genre><price>44.95</price><publish_date>2000-10-01</publish_date><description>An in-depth look at creating applications with XML.</description></book><book id=\"bk102\"><author>Ralls, Kim</author><title>Midnight Rain</title><genre>Fantasy</genre><price>5.95</price><publish_date>2000-12-16</publish_date><description>A former architect battles corporate zombies, an evil sorceress, and her own childhood to become queen of the world.</description></book><book id=\"bk103\"><author>Corets, Eva</author><title>Maeve Ascendant</title><genre>Fantasy</genre><price>5.95</price><publish_date>2000-11-17</publish_date><description>After the collapse of a nanotechnology society in England, the young survivors lay the foundation for a new society.</description></book></catalog></root>"

var xml = XMLIndexer("to be set")
xml = SWXMLHash.parse(xmlToParse)

xml["root"]["header"]["title"].element

// will return "Ralls, Kim"
xml["root"]["catalog"]["book"][1]["author"].element?.text

// will return "bk102"
xml["root"]["catalog"]["book"][1].element?.attributes["id"]


//var url = NSURL(string: "http://192.168.1.129/car/api.php?appid=1&appkey=0958d204a06d6e9e36c45bb9a88410ea&fun=getpositionuser&uid=219848&lng=103.986542&lat=30.637901")

var url1 = NSURL(scheme: "http", host: "192.168.1.129", path: "/car/api.php?appid=1&appkey=0958d204a06d6e9e36c45bb9a88410ea&fun=getpositionuser&uid=219848&lng=103.986542&lat=30.637901")

var data = NSData(contentsOfURL: url1!, options:NSDataReadingOptions.DataReadingUncached, error:nil)

var str = NSString(data:data!, encoding: NSUTF8StringEncoding)
var userdata = XMLIndexer("user info")
userdata = SWXMLHash.parse(str!)

userdata["root"]["body"]["items"]["uinfo"]["userInfo"]["id"].element?.text


