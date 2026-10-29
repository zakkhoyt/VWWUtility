//
//  Ansi+Hyperlink.swift
//
//
//  Created by Zakk Hoyt.
//

import Foundation

extension ANSI {
    /// Operating System Command (`OSC`) escape-sequence building blocks.
    ///
    /// Unlike ``ANSI/Endcap`` (which builds `CSI` sequences of the form `ESC [ … m`), `OSC`
    /// sequences open with `ESC ]` and close with a String Terminator (`ST`). `OSC 8`
    /// specifically is used for clickable terminal hyperlinks (analogous to HTML's
    /// `<a href="…">…</a>`).
    ///
    /// - Note: `OSC` is **not** part of `ECMA-48`'s `CSI` sequences — it uses a different
    /// opener (`ESC ]` instead of `ESC [`).
    /// - SeeAlso: [Hyperlinks in terminal emulators — egmontkob](https://gist.github.com/egmontkob/eb114294efbcd5adb1944c9f3cb5feda)
    public enum OSC {
        /// The `OSC` opener: `ESC ]` (bytes `0x1B 0x5D`).
        public static let prefix = "\(String(Unicode.Scalar(UInt8(0x1B))))]"

        /// The printable (human-readable) form of the `OSC` opener: `\x1B]`.
        public static let printablePrefix = "\\x1B]"

        /// The String Terminator (`ST`) in `ECMA-48` form: `ESC \` (bytes `0x1B 0x5C`).
        ///
        /// Preferred over the legacy `BEL` (`0x07`) terminator, which can produce an audible
        /// bell on misconfigured terminals.
        public static let stringTerminator = "\(String(Unicode.Scalar(UInt8(0x1B))))\\"

        /// The printable (human-readable) form of the String Terminator: `\x1B\`.
        public static let printableStringTerminator = "\\x1B\\"
    }

    /// An `OSC 8` terminal hyperlink: a URI wrapped around visible title text.
    ///
    /// The emitted sequence follows the open / text / close pattern:
    /// ```
    /// ESC ]8;;<URI> ST   <title>   ESC ]8;;ST
    /// ```
    /// The URI field of the closing sequence is intentionally left empty to terminate the link.
    /// The optional `params` field (whose only defined key is `id=`) is left empty — each
    /// `Hyperlink` is self-contained, so there is nothing to group.
    ///
    /// ## Example
    /// ```swift
    /// let link = ANSI.Hyperlink(uri: "https://example.com", title: "Example")
    /// FileDescriptor.stdout.writeLine(link.code)
    /// ```
    ///
    /// - SeeAlso: [Hyperlinks in terminal emulators — egmontkob](https://gist.github.com/egmontkob/eb114294efbcd5adb1944c9f3cb5feda)
    public struct Hyperlink {
        /// The link target. Should include a scheme (e.g. `https://`, `file://`, `mailto:`).
        public let uri: String

        /// The visible text of the link.
        public let title: String

        /// The real escape sequence (contains raw `ESC` bytes). Write this to a terminal.
        public let code: String

        /// The human-readable escape sequence (uses `\x1B` spellings). Suitable for copying
        /// into shell/source, and consistent with ``ANSI/Item/printableCode``.
        public let printableCode: String

        /// - Parameters:
        ///   - uri: The link target (should include a scheme).
        ///   - title: The visible text of the link.
        ///   - style: Optional `ANSI` codes applied to the visible title (e.g. the `.url`
        ///     style). The style is reset (`.default`) before the closing sequence so it
        ///     does not leak into following output. Terminal hyperlinks carry no styling of
        ///     their own, so this is how a link gets a visual affordance.
        public init(
            uri: String,
            title: String,
            style: [ANSI] = []
        ) {
            self.uri = uri
            self.title = title

            // Build the (optionally styled) visible text in both real and printable forms.
            let styleCode = style.map { ANSI.Item($0).code }.joined()
            let stylePrintableCode = style.map { ANSI.Item($0).printableCode }.joined()
            let reset = style.isEmpty ? "" : ANSI.Item(.default).code
            let resetPrintable = style.isEmpty ? "" : ANSI.Item(.default).printableCode

            func build(
                osc: String,
                stringTerminator: String,
                visibleText: String
            ) -> String {
                [
                    osc, "8;;", uri, stringTerminator, // open
                    visibleText, // visible text (optionally styled)
                    osc, "8;;", stringTerminator // close (empty URI)
                ].joined()
            }

            self.code = build(
                osc: OSC.prefix,
                stringTerminator: OSC.stringTerminator,
                visibleText: styleCode + title + reset
            )
            self.printableCode = build(
                osc: OSC.printablePrefix,
                stringTerminator: OSC.printableStringTerminator,
                visibleText: stylePrintableCode + title + resetPrintable
            )
        }
    }
}
