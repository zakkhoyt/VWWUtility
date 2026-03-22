import XCTest
@testable import ZBTermsKit

final class FileCrawlerTests: XCTestCase {

    var tree: MockFileTree!

    override func setUp() async throws {
        try await super.setUp()
        tree = try MockFileTree.standard()
    }

    override func tearDown() async throws {
        tree = nil
        try await super.tearDown()
    }

    // MARK: - Container type filtering

    func test_containerFile_onlyFiles() async throws {
        let options = FileCrawler.Options(
            rootDir: tree.rootURL.path,
            container: .file,
            maxDepth: 0,
            exclude: nil,
            followSymlinks: false,
            isDryRun: false
        )
        let items = try await FileCrawler.crawl(options: options)
        XCTAssertTrue(items.allSatisfy { $0.pathContentType == .file },
                      "All items should be files when container is .file")
        XCTAssertFalse(items.isEmpty)
    }

    func test_containerDir_onlyDirs() async throws {
        let options = FileCrawler.Options(
            rootDir: tree.rootURL.path,
            container: .dir,
            maxDepth: 0,
            exclude: nil,
            followSymlinks: false,
            isDryRun: false
        )
        let items = try await FileCrawler.crawl(options: options)
        XCTAssertTrue(items.allSatisfy { $0.pathContentType == .dir },
                      "All items should be dirs when container is .dir")
        XCTAssertFalse(items.isEmpty)
    }

    func test_containerAll_containsBothTypes() async throws {
        let options = FileCrawler.Options(
            rootDir: tree.rootURL.path,
            container: .all,
            maxDepth: 0,
            exclude: nil,
            followSymlinks: false,
            isDryRun: false
        )
        let items = try await FileCrawler.crawl(options: options)
        let hasFiles = items.contains { $0.pathContentType == .file }
        let hasDirs = items.contains { $0.pathContentType == .dir }
        XCTAssertTrue(hasFiles, "Should include files")
        XCTAssertTrue(hasDirs, "Should include directories")
    }

    // MARK: - Max depth

    func test_maxDepth1_doesNotReachNestedDirs() async throws {
        let options = FileCrawler.Options(
            rootDir: tree.rootURL.path,
            container: .file,
            maxDepth: 1,
            exclude: nil,
            followSymlinks: false,
            isDryRun: false
        )
        let items = try await FileCrawler.crawl(options: options)
        // "deep/nested/file_shoe_deep.mp4" is at depth 2 — should not appear
        let deepFile = items.first { $0.path.contains("deep") && $0.path.contains("nested") }
        XCTAssertNil(deepFile, "Depth-2 file should not appear with maxDepth=1")
    }

    func test_maxDepth0_unlimited_reachesAllFiles() async throws {
        let options = FileCrawler.Options(
            rootDir: tree.rootURL.path,
            container: .file,
            maxDepth: 0, // 0 = unlimited
            exclude: nil,
            followSymlinks: false,
            isDryRun: false
        )
        let items = try await FileCrawler.crawl(options: options)
        let deepFile = items.first { $0.path.contains("nested") }
        XCTAssertNotNil(deepFile, "Depth-2 file should appear when maxDepth=0 (unlimited)")
    }

    // MARK: - Exclusion

    func test_exclude_dropsMatchingBasenames() async throws {
        let options = FileCrawler.Options(
            rootDir: tree.rootURL.path,
            container: .file,
            maxDepth: 0,
            exclude: "*[clip]*",
            followSymlinks: false,
            isDryRun: false
        )
        let items = try await FileCrawler.crawl(options: options)
        let clipFile = items.first { $0.extractablePath.contains("[clip]") }
        XCTAssertNil(clipFile, "Files matching exclude pattern should not appear")
    }

    func test_noExclude_allFilesPresent() async throws {
        let options = FileCrawler.Options(
            rootDir: tree.rootURL.path,
            container: .file,
            maxDepth: 0,
            exclude: nil,
            followSymlinks: false,
            isDryRun: false
        )
        let items = try await FileCrawler.crawl(options: options)
        let clipFile = items.first { $0.extractablePath.contains("[clip]") }
        XCTAssertNotNil(clipFile, "Files should appear when no exclude pattern set")
    }

    // MARK: - Path structure

    func test_pathItems_haveRelativePaths() async throws {
        let options = FileCrawler.Options(
            rootDir: tree.rootURL.path,
            container: .file,
            maxDepth: 0,
            exclude: nil,
            followSymlinks: false,
            isDryRun: false
        )
        let items = try await FileCrawler.crawl(options: options)
        for item in items {
            XCTAssertFalse(item.path.hasPrefix("/"),
                           "path should be relative, got: \(item.path)")
            XCTAssertTrue(item.absolutePath.hasPrefix("/"),
                          "absolutePath should be absolute, got: \(item.absolutePath)")
        }
    }

    func test_fileExtractablePath_isBasename() async throws {
        let options = FileCrawler.Options(
            rootDir: tree.rootURL.path,
            container: .file,
            maxDepth: 0,
            exclude: nil,
            followSymlinks: false,
            isDryRun: false
        )
        let items = try await FileCrawler.crawl(options: options)
        for item in items {
            let basename = URL(fileURLWithPath: item.absolutePath).lastPathComponent
            XCTAssertEqual(item.extractablePath, basename,
                           "File extractablePath should be basename")
        }
    }
}
