import Vapor
import Leaf
import LeafMarkdown

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    LeafServiceManager.shared.configure()

    // Basic "It works" example
    router.get { req -> Response in
        let description: [String] = ["# auroraプロジェクト API Stubサーバー",
                                     "### (c) i-enter Corporation."]
        let markdownResultString = LeafServiceManager.shared.render(markdownStringArray: description)
        return makeHtmlResponse(title: "auroraプロジェクト API Stubサーバー（アイエンター）", body: markdownResultString, req: req)
    }
    
    // Basic "Hello, world!" example

    router.get("hello") { req in
        return "Hello, world!"
    }

    // MARK: - Recipe

    router.group("recipe") { routerRecipe in
        routerRecipe.group("list", configure: { routerRecipeList in
            routerRecipeList.get("retrieve") { req in
                return makeJsonResponseOf(jsonType: .tanitaRanking, contentsOfFile: "ranking-stub_01", req: req)
            }
        })

        routerRecipe.group("detail") { routerRecipeDetail in
            routerRecipeDetail.get("retrieve") { req in
                return req.description
            }
        }
    }

    // Example of configuring a controller

    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
}

func makeHtmlResponse(title: String, body: String, req: Request) -> Response {
    let htmlBody = """
    <!DOCTYPE html>
    <html>
    <head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>\(title)</title>
    <meta charset="utf-8">
    <meta name="description" content="">
    <meta name="author" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="">
    <!--[if lt IE 9]>
    <script src="//cdn.jsdelivr.net/html5shiv/3.7.2/html5shiv.min.js"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
    <link rel="shortcut icon" href="">
    </head>
    <body>
    \(body)
    <!-- SCRIPTS -->
    </body>
    </html>
"""
    let headers = HTTPHeaders([("Content-Type", "text/html"),
                               ("Accept-Language", "ja-jp")])
    let httpResponse = HTTPResponse(status: HTTPResponseStatus(statusCode: 200),
                                    version: HTTPVersion(major: 1, minor: 0),
                                    headers: headers,
                                    body: htmlBody)
    let container = req.sharedContainer
    return Response(http: httpResponse, using: container)
}

enum JsonType {
    case tanitaWeekly
    case tanitaRanking
    case finc
    case errorFileNotFound
    case errorInvalidParameters

    private var resourceJsonDir: String {
        return "Sources/App/Resources/JSON"
    }

    var resourceDir: String {
        switch self {
        case .tanitaWeekly: return "\(resourceJsonDir)/Recipe/Tanita/Weekly"
        case .tanitaRanking: return "\(resourceJsonDir)/Recipe/Tanita/Ranking"
        case .finc: return "\(resourceJsonDir)/Recipe/Finc"
        case .errorFileNotFound: return "\(resourceJsonDir)/Error/error_file_not_found.json"
        case .errorInvalidParameters: return "\(resourceJsonDir)/Error/error_invalid_parameters.json"
        }
    }
}

func makeJsonResponseOf(jsonType: JsonType, contentsOfFile: String, req: Request) -> Response {
    let directory = DirectoryConfig.detect()

    let errorJsonFilepath = directory.workDir + JsonType.errorFileNotFound.resourceDir
    let errorJson = FileManager.default.contents(atPath: errorJsonFilepath)!

    let workDir = directory.workDir + jsonType.resourceDir
    let contentsOfFile = contentsOfFile.replacingOccurrences(of: ".json", with: "") + ".json"
    let myfile = "\(workDir)/\(contentsOfFile)"
    let contents = FileManager.default.contents(atPath: myfile) ?? errorJson

    let headers = HTTPHeaders([("Content-Type", "application/json"),
                               ("Accept-Language", "ja-jp")])
    let httpResponse = HTTPResponse(status: HTTPResponseStatus(statusCode: 200),
                                    version: HTTPVersion(major: 1, minor: 0),
                                    headers: headers,
                                    body: contents)
    let container = req.sharedContainer
    return Response(http: httpResponse, using: container)
}
