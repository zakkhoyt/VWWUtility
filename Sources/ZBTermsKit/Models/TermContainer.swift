/// Specifies what kind of filesystem entry to mine for terms.
public enum TermContainer: String, CaseIterable, Codable, Sendable {
    /// Mine only files — extract terms from each file's basename.
    case file
    /// Mine only directories — extract terms from each directory's leaf (last) component.
    case dir
    /// Mine both files and directories.
    case all
}
