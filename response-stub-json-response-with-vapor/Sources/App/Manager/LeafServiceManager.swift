//
//  LeafServiceManager.swift
//  App
//
//  Created by Naraki on 11/6/18.
//

import Leaf
import LeafMarkdown

final class LeafServiceManager {
    static let shared = LeafServiceManager()

    private var leafTagConfig = LeafTagConfig.default()
    private let container = BasicContainer(config: .init(), environment: .testing, services: .init(), on: EmbeddedEventLoop())
    private let template = "#markdown(data)"
    var renderer: LeafRenderer {
        return LeafRenderer(config: LeafConfig(tags: leafTagConfig, viewsDir: "", shouldCache: false), using: container)
    }

    func configure() {
        let tag = Markdown()
        leafTagConfig.use(tag, as: tag.name)
    }

    func render(markdown: String) -> String {
        let data = TemplateData.dictionary(["data": .string(markdown)])
        let result = try! renderer.render(template: template.data(using: .utf8)!, data).wait()
        return String(data: result.data, encoding: .utf8)!
    }

    func render(markdownStringArray: [String]) -> String {
        return render(markdown: markdownStringArray.joined(separator: "\n"))
    }
}
