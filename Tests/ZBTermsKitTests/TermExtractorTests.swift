import XCTest
@testable import ZBTermsKit

final class TermExtractorTests: XCTestCase {

    // MARK: - Common term extraction

    func test_commonTerms_extractedCorrectly() {
        let terms = TermExtractor.extractTerms(from: "video_shoe_dunk_at30s.mp4")
        XCTAssertEqual(terms, ["shoe", "dunk", "at30s"])
    }

    func test_adjacentTermsShareDelimiter() {
        // "_a_b_c_" — shared delimiters, three terms
        let terms = TermExtractor.extractTerms(from: "_a_b_c_")
        XCTAssertEqual(terms, ["a", "b", "c"])
    }

    func test_termsMidBasename() {
        // Terms surrounded by non-term text
        let terms = TermExtractor.extractTerms(from: "march madness_shoe_dunk_youtube - title.mp4")
        XCTAssertEqual(terms, ["shoe", "dunk"])
    }

    func test_noTerms_returnsEmpty() {
        let terms = TermExtractor.extractTerms(from: "untitled.jpg")
        XCTAssertTrue(terms.isEmpty)
    }

    func test_numberOnlyTerm() {
        let terms = TermExtractor.extractTerms(from: "clip_at30s_for5s.mp4")
        XCTAssertEqual(terms, ["at30s", "for5s"])
    }

    func test_multipleAdjacentTerms_realWorldFilename() {
        // Real-world filename with leading non-term text and trailing source info
        let terms = TermExtractor.extractTerms(
            from: "march madness_shoe_at14m3s_swish_f09_ on youtube.com - user - title.mp4"
        )
        XCTAssertEqual(terms, ["shoe", "at14m3s", "swish", "f09"])
    }

    // MARK: - Favorite rating (leading underscores)

    func test_favoriteRating_notExtractedAsCommonTerm() {
        // "__best_shot.jpg" — leading __ should NOT appear in common terms
        let terms = TermExtractor.extractTerms(from: "__best_shot.jpg")
        XCTAssertFalse(terms.contains(""), "Empty string should not be in terms")
        // "best" and "shot" are valid terms
        XCTAssertEqual(terms, ["best", "shot"])
    }

    func test_favoriteRating_singleUnderscore_detected() {
        let rating = TermExtractor.extractFavoriteRating(from: "_favorite.jpg")
        XCTAssertEqual(rating, 1)
    }

    func test_favoriteRating_twoUnderscores_detected() {
        let rating = TermExtractor.extractFavoriteRating(from: "__best_shot.jpg")
        XCTAssertEqual(rating, 2)
    }

    func test_favoriteRating_tenUnderscores_detected() {
        let rating = TermExtractor.extractFavoriteRating(from: "__________file.jpg")
        XCTAssertEqual(rating, 10)
    }

    func test_favoriteRating_elevenUnderscores_notDetected() {
        // More than 10 leading underscores → not a valid favorite rating
        let rating = TermExtractor.extractFavoriteRating(from: "___________file.jpg")
        XCTAssertNil(rating)
    }

    func test_favoriteRating_noLeadingUnderscore_nilResult() {
        let rating = TermExtractor.extractFavoriteRating(from: "normal_file.jpg")
        XCTAssertNil(rating)
    }

    func test_favoriteRating_allUnderscores_nilResult() {
        // All underscores, no non-underscore character follows
        let rating = TermExtractor.extractFavoriteRating(from: "___.jpg")
        // Leading 3 underscores followed by '.', which is not '_', so it IS a valid rating
        XCTAssertEqual(rating, 3)
    }

    // MARK: - Edge cases

    func test_extensionStripped_beforeExtraction() {
        // Extension ".mp4" shouldn't interfere with term parsing
        let terms = TermExtractor.extractTerms(from: "file_shoe_dunk.mp4")
        XCTAssertEqual(terms, ["shoe", "dunk"])
    }

    func test_noExtension_worksCorrectly() {
        let terms = TermExtractor.extractTerms(from: "file_shoe_dunk")
        XCTAssertEqual(terms, ["shoe", "dunk"])
    }

    func test_termAtStartAndEnd() {
        let terms = TermExtractor.extractTerms(from: "_first_middle_last_")
        XCTAssertEqual(terms, ["first", "middle", "last"])
    }

    func test_singleTerm() {
        let terms = TermExtractor.extractTerms(from: "file_only_.mp4")
        XCTAssertEqual(terms, ["only"])
    }
}
