public protocol SGFPropertyEntryProtocol<Game>: Hashable & Sendable {
    var name: String { get }
    associatedtype Game: SGFGame

    var rootType: SGFType<Game> { get }
}

public struct SGFPropertyEntry<Game: SGFGame, Object: Sendable & Hashable>: Hashable & Sendable, SGFPropertyEntryProtocol {
    public let name: String
    public let type: SGFTypeInformation<Game, Object>

    public var rootType: SGFType<Game> {
        type.type
    }
}

// MARK: - Predefined Properties

enum SGFGeneralProperties<Game: SGFGame> {

    public typealias Entry<Object: Hashable & Sendable> = SGFPropertyEntry<Game, Object>
    public typealias List<Object: Hashable & Sendable> = SGFTypes<Game>.ListType<Object>
    public typealias EList<Object: Hashable & Sendable> = SGFTypes<Game>.EListType<Object>
    public typealias Compose<ObjectA: Hashable & Sendable, ObjectB: Hashable & Sendable> = SGFTypes<Game>.ComposeType<ObjectA, ObjectB>
    public typealias Union<ObjectA: Hashable & Sendable, ObjectB: Hashable & Sendable> = SGFTypes<Game>.UnionType<ObjectA, ObjectB>

    // MARK: - Move
    static var black: Entry<Game.Move> { .init(name: "B", type: .move) }
    static var blackTimeLeft: Entry<Double> { .init(name: "BL", type: .real) }
    static var badMove: Entry<SGFDouble> { .init(name: "BM", type: .double) }
    static var doubtful: Entry<Never> { .init(name: "DO", type: .none) }
    static var interesting: Entry<Never> { .init(name: "IT", type: .none) }
    static var ko: Entry<Never> { .init(name: "KO", type: .none) }
    static var moveNumber: Entry<Int> { .init(name: "MN", type: .number) }
    static var otStoneBlack: Entry<Int> { .init(name: "OB", type: .number) }
    static var otStoneWhite: Entry<Int> { .init(name: "OW", type: .number) }
    static var tesuji: Entry<SGFDouble> { .init(name: "TE", type: .double) }
    static var white: Entry<Game.Move> { .init(name: "W", type: .move) }
    static var whirteTimeLeft: Entry<Double> { .init(name: "WL", type: .real) }

    // MARK: - Setup
    static var addBlack: Entry<List<Game.Stone>> { .init(name: "AB", type: .list(of: .stone)) }
    static var addEmpty: Entry<List<Game.Point>> { .init(name: "AE", type: .list(of: .point)) }
    static var addWhite: Entry<List<Game.Stone>> { .init(name: "AW", type: .list(of: .stone)) }
    static var playerToPlay: Entry<SGFColor> { .init(name: "PL", type: .color) }

    // MARK: - None
    static var arrow: Entry<List<Compose<Game.Point, Game.Point>>> { .init(name: "AR", type: .list(of: .compose(.point, .point))) }
    static var comment: Entry<String> { .init(name: "C", type: .text) }
    static var circle: Entry<List<Game.Point>> { .init(name: "CR", type: .list(of: .point)) }
    static var dimPoints: Entry<EList<Game.Point>> { .init(name: "DD", type: .elist(of: .point)) }
    static var evenPosition: Entry<SGFDouble> { .init(name: "DM", type: .double) }
    static var figure: Entry<Union<Never, Compose<Int, String>>> { .init(name: "FG", type: .union(.none, or: .compose(.number, .simpleText))) }
    static var goodForBlack: Entry<SGFDouble> { .init(name: "GB", type: .double) }
    static var goodForWhite: Entry<SGFDouble> { .init(name: "GW", type: .double) }
    static var hotspot: Entry<SGFDouble> { .init(name: "HO", type: .double) }
    static var label: Entry<List<Compose<Game.Point, String>>> { .init(name: "LB", type: .list(of: .compose(.point, .simpleText))) }
    static var line: Entry<List<Compose<Game.Point, Game.Point>>> { .init(name: "LN", type: .list(of: .compose(.point, .point))) }
    static var mark: Entry<List<Game.Point>> { .init(name: "MA", type: .list(of: .point)) }
    static var nodeName: Entry<String> { .init(name: "N", type: .simpleText) }
    static var printMoveMode: Entry<Int> { .init(name: "PM", type: .number) }
    static var selected: Entry<List<Game.Point>> { .init(name: "SL", type: .list(of: .point)) }
    static var square: Entry<List<Game.Point>> { .init(name: "SQ", type: .list(of: .point)) }
    static var triangle: Entry<List<Game.Point>> { .init(name: "TR", type: .list(of: .point)) }
    static var unclearPos: Entry<SGFDouble> { .init(name: "UC", type: .double) }
    static var value: Entry<Double> { .init(name: "V", type: .real) }
    static var view: Entry<EList<Game.Point>> { .init(name: "VW", type: .elist(of: .point)) }

    // MARK: - Root
    static var application: Entry<Compose<String, Int>> { .init(name: "AP", type: .compose(.simpleText, .number)) }
    static var charset: Entry<String> { .init(name: "CA", type: .simpleText) }
    static var fileformat: Entry<Int> { .init(name: "FF", type: .number) }
    static var game: Entry<Int> { .init(name: "GM", type: .number) }
    static var style: Entry<Int> { .init(name: "ST", type: .number) }
    static var size: Entry<Union<Int, Compose<Int, Int>>> { .init(name: "SZ", type: .union(.number, or: .compose(.number, .number))) }

    // MARK: - Game Info
    static var annotation: Entry<String> { .init(name: "AN", type: .simpleText) }
    static var blackRank: Entry<String> { .init(name: "BR", type: .simpleText) }
    static var blackTeam: Entry<String> { .init(name: "BT", type: .simpleText) }
    static var copyright: Entry<String> { .init(name: "CP", type: .simpleText) }
    static var date: Entry<String> { .init(name: "DT", type: .simpleText) }
    static var event: Entry<String> { .init(name: "EV", type: .simpleText) }
    static var gameComment: Entry<String> { .init(name: "GC", type: .text) }
    static var gameName: Entry<String> { .init(name: "GN", type: .simpleText) }
    static var opening: Entry<String> { .init(name: "ON", type: .simpleText) }
    static var overtime: Entry<String> { .init(name: "OT", type: .simpleText) }
    static var playerBlack: Entry<String> { .init(name: "PB", type: .simpleText) }
    static var place: Entry<String> { .init(name: "PC", type: .simpleText) }
    static var playerWhite: Entry<String> { .init(name: "PW", type: .simpleText) }
    static var result: Entry<String> { .init(name: "RE", type: .simpleText) }
    static var round: Entry<String> { .init(name: "RO", type: .simpleText) }
    static var rules: Entry<String> { .init(name: "RU", type: .simpleText) }
    static var source: Entry<String> { .init(name: "SO", type: .simpleText) }
    static var timeLimit: Entry<Double> { .init(name: "TM", type: .real) }
    static var user: Entry<String> { .init(name: "US", type: .simpleText) }
    static var whiteRank: Entry<String> { .init(name: "WR", type: .simpleText) }
    static var whiteTeam: Entry<String> { .init(name: "WT", type: .simpleText) }
}

extension SGFGeneralProperties {
    static var generalEntries: [any SGFPropertyEntryProtocol<Game>] {
        [
            SGFGeneralProperties<Game>.black,
            SGFGeneralProperties<Game>.blackTimeLeft,
            SGFGeneralProperties<Game>.badMove,
            SGFGeneralProperties<Game>.doubtful,
            SGFGeneralProperties<Game>.interesting,
            SGFGeneralProperties<Game>.ko,
            SGFGeneralProperties<Game>.moveNumber,
            SGFGeneralProperties<Game>.otStoneBlack,
            SGFGeneralProperties<Game>.otStoneWhite,
            SGFGeneralProperties<Game>.tesuji,
            SGFGeneralProperties<Game>.white,
            SGFGeneralProperties<Game>.whirteTimeLeft,
            SGFGeneralProperties<Game>.addBlack,
            SGFGeneralProperties<Game>.addEmpty,
            SGFGeneralProperties<Game>.addWhite,
            SGFGeneralProperties<Game>.playerToPlay,
            SGFGeneralProperties<Game>.arrow,
            SGFGeneralProperties<Game>.comment,
            SGFGeneralProperties<Game>.circle,
            SGFGeneralProperties<Game>.dimPoints,
            SGFGeneralProperties<Game>.evenPosition,
            SGFGeneralProperties<Game>.figure,
            SGFGeneralProperties<Game>.goodForBlack,
            SGFGeneralProperties<Game>.goodForWhite,
            SGFGeneralProperties<Game>.hotspot,
            SGFGeneralProperties<Game>.label,
            SGFGeneralProperties<Game>.line,
            SGFGeneralProperties<Game>.mark,
            SGFGeneralProperties<Game>.nodeName,
            SGFGeneralProperties<Game>.printMoveMode,
            SGFGeneralProperties<Game>.selected,
            SGFGeneralProperties<Game>.square,
            SGFGeneralProperties<Game>.triangle,
            SGFGeneralProperties<Game>.unclearPos,
            SGFGeneralProperties<Game>.value,
            SGFGeneralProperties<Game>.view,
            SGFGeneralProperties<Game>.application,
            SGFGeneralProperties<Game>.charset,
            SGFGeneralProperties<Game>.fileformat,
            SGFGeneralProperties<Game>.game,
            SGFGeneralProperties<Game>.style,
            SGFGeneralProperties<Game>.size,
            SGFGeneralProperties<Game>.annotation,
            SGFGeneralProperties<Game>.blackRank,
            SGFGeneralProperties<Game>.blackTeam,
            SGFGeneralProperties<Game>.copyright,
            SGFGeneralProperties<Game>.date,
            SGFGeneralProperties<Game>.event,
            SGFGeneralProperties<Game>.gameComment,
            SGFGeneralProperties<Game>.gameName,
            SGFGeneralProperties<Game>.opening,
            SGFGeneralProperties<Game>.overtime,
            SGFGeneralProperties<Game>.playerBlack,
            SGFGeneralProperties<Game>.place,
            SGFGeneralProperties<Game>.playerWhite,
            SGFGeneralProperties<Game>.result,
            SGFGeneralProperties<Game>.round,
            SGFGeneralProperties<Game>.rules,
            SGFGeneralProperties<Game>.source,
            SGFGeneralProperties<Game>.timeLimit,
            SGFGeneralProperties<Game>.user,
            SGFGeneralProperties<Game>.whiteRank,
            SGFGeneralProperties<Game>.whiteTeam,
        ]
    }
}
