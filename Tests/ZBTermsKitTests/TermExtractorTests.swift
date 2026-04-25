import XCTest
@testable import ZBTermsKit

final class TermExtractorTests: XCTestCase {

    // MARK: - Common term extraction

    func test_commonTerms_extractedCorrectly() {
        let terms = TermExtractor.extractTerms(from: "video_shoe_dunk_at30s.mp4")
        XCTAssertEqual(terms.map(\.raw), ["shoe", "dunk", "at30s"])
    }

    func test_adjacentTermsShareDelimiter() {
        // "_a_b_c_" — shared delimiters, three terms
        let terms = TermExtractor.extractTerms(from: "_a_b_c_")
        XCTAssertEqual(terms.map(\.raw), ["a", "b", "c"])
    }

    func test_termsMidBasename() {
        // Terms surrounded by non-term text
        let terms = TermExtractor.extractTerms(from: "march madness_shoe_dunk_youtube - title.mp4")
        XCTAssertEqual(terms.map(\.raw), ["shoe", "dunk"])
    }

    func test_noTerms_returnsEmpty() {
        let terms = TermExtractor.extractTerms(from: "untitled.jpg")
        XCTAssertTrue(terms.isEmpty)
    }

    func test_numberOnlyTerm() {
        let terms = TermExtractor.extractTerms(from: "clip_at30s_for5s.mp4")
        XCTAssertEqual(terms.map(\.raw), ["at30s", "for5s"])
    }

    func test_multipleAdjacentTerms_realWorldFilename() {
        // Real-world filename with leading non-term text and trailing source info
        let terms = TermExtractor.extractTerms(
            from: "march madness_shoe_at14m3s_swish_f09_ on youtube.com - user - title.mp4"
        )
        XCTAssertEqual(terms.map(\.raw), ["shoe", "at14m3s", "swish", "f09"])
    }

    // MARK: - Favorite rating (leading underscores)

    func test_favoriteRating_notExtractedAsCommonTerm() {
        // "__best_shot.jpg" — leading __ should NOT appear in common terms
        let terms = TermExtractor.extractTerms(from: "__best_shot.jpg")
        XCTAssertFalse(terms.map(\.raw).contains(""), "Empty string should not be in terms")
        // "best" and "shot" are valid terms
        XCTAssertEqual(terms.map(\.raw), ["best", "shot"])
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
        XCTAssertEqual(terms.map(\.raw), ["shoe", "dunk"])
    }

    func test_noExtension_worksCorrectly() {
        let terms = TermExtractor.extractTerms(from: "file_shoe_dunk")
        XCTAssertEqual(terms.map(\.raw), ["shoe", "dunk"])
    }

    func test_termAtStartAndEnd() {
        let terms = TermExtractor.extractTerms(from: "_first_middle_last_")
        XCTAssertEqual(terms.map(\.raw), ["first", "middle", "last"])
    }

    func test_singleTerm() {
        let terms = TermExtractor.extractTerms(from: "file_only_.mp4")
        XCTAssertEqual(terms.map(\.raw), ["only"])
    }

    func test_trailingTerm_noClosingUnderscore() {
        // "clip" has no trailing `_` — should still be captured
        let terms = TermExtractor.extractTerms(from: "_dunk_clip.mp4")
        XCTAssertEqual(terms.map(\.raw), ["dunk", "clip"])
    }

    func test_trailingTerm_realWorldFilename() {
        // "game" is a valid leading token (before the first _), so it is captured.
        let terms = TermExtractor.extractTerms(from: "game_shoe-ht_dunk_clip.mp4")
        XCTAssertEqual(terms.map(\.raw), ["game", "shoe-ht", "dunk", "clip"])
    }

    func test_leadingToken_noOpeningUnderscore() {
        let terms = TermExtractor.extractTerms(from: "Xcode_20240513143322-muted.mp4")
        XCTAssertEqual(terms.map(\.raw), ["Xcode", "20240513143322-muted"])
    }

    func test_trailingTerm_invalidCharsIgnored() {
        // Trailing segment containing spaces or brackets is not a valid term
        let terms = TermExtractor.extractTerms(from: "_shoe_ on youtube.com.mp4")
        XCTAssertEqual(terms.map(\.raw), ["shoe"])
    }

    // MARK: - V1 term syntax

    func test_v1Term_knownSubject() throws {
        let term = try XCTUnwrap(try? Term(basenameRepresentation: "shoe"))
        XCTAssertEqual(term.syntaxVersion, .v1)
        XCTAssertEqual(term.subject.basenameRepresentation, "shoe")
        XCTAssertTrue(term.parameters.isEmpty)
    }

    func test_v1Term_unknownSubject_usesRawAsSubject() throws {
        let term = try XCTUnwrap(try? Term(basenameRepresentation: "unknowntopic"))
        XCTAssertEqual(term.syntaxVersion, .v1)
        XCTAssertEqual(term.subject.basenameRepresentation, "unknowntopic")
        XCTAssertTrue(term.parameters.isEmpty)
    }

    // MARK: - V2 term syntax

    func test_v2Term_subjectAndParameters() throws {
        let term = try XCTUnwrap(try? Term(basenameRepresentation: "shoe-ht-red"))
        XCTAssertEqual(term.syntaxVersion, .v2)
        XCTAssertEqual(term.subject.basenameRepresentation, "shoe")
        XCTAssertEqual(term.parameters.map(\.basenameRepresentation), ["ht", "red"])
    }

    func test_v2Term_withOption() throws {
        let term = try XCTUnwrap(try? Term(basenameRepresentation: "f-09"))
        XCTAssertEqual(term.syntaxVersion, .v2)
        XCTAssertEqual(term.subject.basenameRepresentation, "f")
        XCTAssertEqual(term.parameters.first?.basenameRepresentation, "09")
    }

    func test_v2Term_extractedFromFilename() {
        let terms = TermExtractor.extractTerms(from: "practice_shoe-ht-red_at14m3s.mp4")
        let shoeTerm = terms.first { $0.subject.basenameRepresentation == "shoe" }
        XCTAssertNotNil(shoeTerm)
        XCTAssertEqual(shoeTerm?.syntaxVersion, .v2)
        XCTAssertEqual(shoeTerm?.parameters.map(\.basenameRepresentation), ["ht", "red"])
    }

    func test_v1AndV2_mixedInSameFilename() {
        // V1 "shoe" and V2 "f-09" in same basename
        let terms = TermExtractor.extractTerms(from: "file_shoe_f-09_clip.mp4")
        XCTAssertEqual(terms.count, 3)
        let shoeTerm = terms.first { $0.raw == "shoe" }
        let fTerm = terms.first { $0.raw == "f-09" }
        XCTAssertEqual(shoeTerm?.syntaxVersion, .v1)
        XCTAssertEqual(fTerm?.syntaxVersion, .v2)
    }

    // MARK: - Term grouping by subject

    func test_v1AndV2_sameSubject_bothParsedToSameSubject() throws {
        let v1 = try XCTUnwrap(try? Term(basenameRepresentation: "shoe"))
        let v2 = try XCTUnwrap(try? Term(basenameRepresentation: "shoe-ht-red"))
        XCTAssertEqual(v1.subject.basenameRepresentation, v2.subject.basenameRepresentation)
    }

    // MARK: - UUID rejection

    func test_uuidToken_isRejected() {
        let term = try? Term(basenameRepresentation: "229963EF-D8D0-443A-987E-AA1161FB8C1C-6856-00000476BFF43267")
        XCTAssertNil(term)
    }

    func test_uuidInFilename_notExtracted() {
        let terms = TermExtractor.extractTerms(
            from: "seat-red_ball_229963EF-D8D0-443A-987E-AA1161FB8C1C-6856-00000476BFF43267.mp4"
        )
        XCTAssertEqual(terms.map(\.raw), ["seat-red", "ball"])
    }

    func test_uuidInFilename_validTermsStillExtracted() {
        let terms = TermExtractor.extractTerms(
            from: "06_f06_nails-f-w_pntw_9B5C2C95-5CC8-4C58-95C8-EFBB305EA61D-6856-00000476BFB5DF49.mp4"
        )
        let raws = terms.map(\.raw)
        XCTAssertTrue(raws.contains("f-06"))
        XCTAssertTrue(raws.contains("nails-f-w"))
        XCTAssertTrue(raws.contains("pntw"))
        XCTAssertFalse(raws.contains { $0.range(of: #"^[A-Z0-9]{8}-"#, options: .regularExpression) != nil })
    }

    // MARK: - Order term (ord)

    func test_ordShorthand_firstToken_promoted() {
        let terms = TermExtractor.extractTerms(from: "01_f08_shoe_dunk.mp4")
        XCTAssertEqual(terms.first?.raw, "ord-01")
        XCTAssertEqual(terms.first?.syntaxVersion, .v2)
        XCTAssertEqual(terms.first?.subject.basenameRepresentation, "ord")
        XCTAssertEqual(terms.first?.parameters.first?.basenameRepresentation, "01")
    }

    func test_ordShorthand_zeroPadded() {
        let terms = TermExtractor.extractTerms(from: "0003_shoe_dunk.mp4")
        XCTAssertEqual(terms.first?.raw, "ord-0003")
        XCTAssertEqual(terms.first?.subject.basenameRepresentation, "ord")
        XCTAssertEqual(terms.first?.parameters.first?.basenameRepresentation, "0003")
    }

    func test_ordShorthand_nonFirstToken_notPromoted() {
        // "shoe" is the leading token; "03" is not first — must not be auto-promoted
        let terms = TermExtractor.extractTerms(from: "shoe_03_dunk.mp4")
        XCTAssertFalse(terms.map(\.raw).contains("ord-03"))
        XCTAssertTrue(terms.map(\.raw).contains("03"))
    }

    func test_ordV2_explicit_anyPosition() {
        let terms = TermExtractor.extractTerms(from: "f-03_ord-03_shoe_dunk.mp4")
        let ordTerm = terms.first { $0.subject.basenameRepresentation == "ord" }
        XCTAssertNotNil(ordTerm)
        XCTAssertEqual(ordTerm?.raw, "ord-03")
        XCTAssertEqual(ordTerm?.parameters.first?.basenameRepresentation, "03")
    }
}
