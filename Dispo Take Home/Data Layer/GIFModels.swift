import UIKit


struct GIFListResponse: Codable {
  var data: [GIF]
}

struct GIFResponse: Codable {
    var data: GIF
}

/**
        A complete GIF object.
    
    - Author: Julian Builes
*/
struct GIF: Codable {
  var id: String
  var title: String
  var sourceTld: String
  var rating: MPAARating
  /// Giphy URL (not gif url to be displayed)
  var url: URL
  var images: ImagesResponse

  struct ImagesResponse: Codable {
    var fixedHeight: Image

    struct Image: Codable {
      var url: URL
      var width: String
      var height: String
    }
  }
}

enum MPAARating: String, Codable, HumanReadable {
    
    case g = "g"
    case pg = "pg"
    case y = "y"
    case pg13 = "pg-13"
    case r = "R"
    case notYetRated
    
    func humanReadable() -> String {
        switch self {
            case .g: return "G"
            case .pg: return "PG"
            case .y: return "Y"
            case .pg13: return "PG-13"
            case .r: return "R"
            default: return "not yet rated"
        }
    }
}

/**
        Represents an incomplete GIF model to be fetched for more details to then create a complete GIF object.
    
    - Author: Julian Builes
*/
struct GIFStub {
  var id: String
  var gifUrl: URL
  var title: String
    
    init(_ gif: GIF) {
        id = gif.id
        gifUrl = gif.url
        title = gif.title
    }
}

/**
        Imposes a self-describing contract for objects to be readable by humans.
    
    - Author: Julian Builes
*/
protocol HumanReadable {
    func humanReadable() -> String
}
