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
            container: .file
        )
        let items = try await FileCrawler.crawl(options: options)
        XCTAssertTrue(items.allSatisfy { $0.pathContentType == .file },
                      "All items should be files when container is .file")
        XCTAssertFalse(items.isEmpty)
    }

    func test_containerDir_onlyDirs() async throws {
        let options = FileCrawler.Options(
            rootDir: tree.rootURL.path,
            container: .dir
        )
        let items = try await FileCrawler.crawl(options: options)
        XCTAssertTrue(items.allSatisfy { $0.pathContentType == .dir },
                      "All items should be dirs when container is .dir")
        XCTAssertFalse(items.isEmpty)
    }

    func test_containerAll_containsBothTypes() async throws {
        let options = FileCrawler.Options(
            rootDir: tree.rootURL.path,
            container: .all
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
            maxDepth: 1
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
            maxDepth: 0 // 0 = unlimited
        )
        let items = try await FileCrawler.crawl(options: options)
        let deepFile = items.first { $0.path.contains("nested") }
        XCTAssertNotNil(deepFile, "Depth-2 file should appear when maxDepth=0 (unlimited)")
    }

    // MARK: - Exclusion (single)

    func test_exclude_dropsMatchingBasenames() async throws {
        let options = FileCrawler.Options(
            rootDir: tree.rootURL.path,
            container: .file,
            excludes: ["*[clip]*"]
        )
        let items = try await FileCrawler.crawl(options: options)
        let clipFile = items.first { $0.extractablePath.contains("[clip]") }
        XCTAssertNil(clipFile, "Files matching exclude pattern should not appear")
    }

    func test_noExclude_allFilesPresent() async throws {
        let options = FileCrawler.Options(
            rootDir: tree.rootURL.path,
            container: .file
        )
        let items = try await FileCrawler.crawl(options: options)
        let clipFile = items.first { $0.extractablePath.contains("[clip]") }
        XCTAssertNotNil(clipFile, "Files should appear when no exclude pattern set")
    }

    // MARK: - Exclusion (multiple)

    func test_multipleExcludes_dropsAllMatchingPatterns() async throws {
        let options = FileCrawler.Options(
            rootDir: tree.rootURL.path,
            container: .file,
            excludes: ["*[clip]*", "*.txt"]
        )
        let items = try await FileCrawler.crawl(options: options)
        let clipFile = items.first { $0.extractablePath.contains("[clip]") }
        XCTAssertNil(clipFile, "Files matching first exclude pattern should not appear")
        let txtFile = items.first { $0.extractablePath.hasSuffix(".txt") }
        XCTAssertNil(txtFile, "Files matching second exclude pattern should not appear")
    }

    func test_multipleExcludes_keepsNonMatchingFiles() async throws {
        let options = FileCrawler.Options(
            rootDir: tree.rootURL.path,
            container: .file,
            excludes: ["*[clip]*", "*.txt"]
        )
        let items = try await FileCrawler.crawl(options: options)
        let mp4Files = items.filter { $0.extractablePath.hasSuffix(".mp4") }
        // Some .mp4 files are not named *[clip]* — they should still be present
        XCTAssertFalse(mp4Files.isEmpty, "Non-matching .mp4 files should still appear")
    }

    // MARK: - Inclusion (single)

    func test_include_keepsOnlyMatchingBasenames() async throws {
        let options = FileCrawler.Options(
            rootDir: tree.rootURL.path,
            container: .file,
            includes: ["shoe"]
        )
        let items = try await FileCrawler.crawl(options: options)
        XCTAssertFalse(items.isEmpty, "Expected at least one file containing 'shoe'")
        for item in items {
            XCTAssertTrue(
                item.extractablePath.localizedCaseInsensitiveContains("shoe"),
                "Item '\(item.extractablePath)' should contain 'shoe'"
            )
        }
    }

    func test_include_dropsNonMatchingBasenames() async throws {
        let options = FileCrawler.Options(
            rootDir: tree.rootURL.path,
            container: .file,
            includes: ["shoe"]
        )
        let items = try await FileCrawler.crawl(options: options)
        // "photos/untitled.jpg" has no terms and no 'shoe' — should be absent
        let untitled = items.first { $0.extractablePath == "untitled.jpg" }
        XCTAssertNil(untitled, "'untitled.jpg' does not contain 'shoe' and should be excluded")
    }

    func test_include_noneMatch_returnsEmpty() async throws {
        let options = FileCrawler.Options(
            rootDir: tree.rootURL.path,
            container: .file,
            includes: ["zzznomatch"]
        )
        let items = try await FileCrawler.crawl(options: options)
        XCTAssertTrue(items.isEmpty, "No files should match an include term that appears in no basename")
    }

    // MARK: - Inclusion (multiple)

    func test_multipleIncludes_ORsemantics() async throws {
        // "shoe" and "practice" appear in different files; both should be included
        let options = FileCrawler.Options(
            rootDir: tree.rootURL.path,
            container: .file,
            includes: ["shoe", "practice"]
        )
        let items = try await FileCrawler.crawl(options: options)
        let hasShoe = items.contains { $0.extractablePath.localizedCaseInsensitiveContains("shoe") }
        let hasPractice = items.contains { $0.extractablePath.localizedCaseInsensitiveContains("practice") }
        XCTAssertTrue(hasShoe, "Files with 'shoe' should be included")
        XCTAssertTrue(hasPractice, "Files with 'practice' should be included")
    }

    func test_multipleIncludes_itemPassingAnyTermIsKept() async throws {
        let options = FileCrawler.Options(
            rootDir: tree.rootURL.path,
            container: .file,
            includes: ["shoe", "zzznomatch"]
        )
        let items = try await FileCrawler.crawl(options: options)
        // Items containing 'shoe' should appear even though 'zzznomatch' matches nothing
        XCTAssertFalse(items.isEmpty)
        for item in items {
            let containsShoe = item.extractablePath.localizedCaseInsensitiveContains("shoe")
            let containsNoMatch = item.extractablePath.localizedCaseInsensitiveContains("zzznomatch")
            XCTAssertTrue(containsShoe || containsNoMatch,
                          "Item '\(item.extractablePath)' should match at least one include term")
        }
    }

    // MARK: - Exclude + Include combined

    func test_excludeThenInclude_excludeAppliedFirst() async throws {
        // Exclude .txt files, then include only files containing "shoe".
        // "docs/notes_shoe_practice.txt" matches both: exclude wins (it's a .txt).
        let options = FileCrawler.Options(
            rootDir: tree.rootURL.path,
            container: .file,
            excludes: ["*.txt"],
            includes: ["shoe"]
        )
        let items = try await FileCrawler.crawl(options: options)
        let txtFile = items.first { $0.extractablePath.hasSuffix(".txt") }
        XCTAssertNil(txtFile, "Excluded .txt should not reappear even if it also contains 'shoe'")
        for item in items {
            XCTAssertTrue(
                item.extractablePath.localizedCaseInsensitiveContains("shoe"),
                "Remaining items should all contain 'shoe'"
            )
        }
    }

    // MARK: - Path structure

    func test_pathItems_haveRelativePaths() async throws {
        let options = FileCrawler.Options(
            rootDir: tree.rootURL.path,
            container: .file
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
            container: .file
        )
        let items = try await FileCrawler.crawl(options: options)
        for item in items {
            let basename = URL(fileURLWithPath: item.absolutePath).lastPathComponent
            XCTAssertEqual(item.extractablePath, basename,
                           "File extractablePath should be basename")
        }
    }
}
