public struct SGFPropertyEntry<Game: SGFGame> {
    public let name: String
    public let type: PropertyType
}

extension SGFPropertyEntry {
    public struct PropertyType {
        let type: SGFValueUnionType
        let listType: PropertyListType
    }

    public enum PropertyListType {
        case single, list, elist
    }
}

extension SGFPropertyEntry.PropertyType {
    public static func single(_ type: SGFValueUnionType) -> SGFPropertyEntry.PropertyType {
        .init(type: type, listType: .single)
    }

    public static func union(_ first: SGFValueComposedType, or second: SGFValueComposedType) -> SGFPropertyEntry.PropertyType {
        .init(type: .union(first, second), listType: .single)
    }

    public static func list(of type: SGFValueUnionType) -> SGFPropertyEntry.PropertyType {
        .init(type: type, listType: .list)
    }

    public static func elist(of type: SGFValueUnionType) -> SGFPropertyEntry.PropertyType {
        .init(type: type, listType: .elist)
    }    

    public static var none: SGFPropertyEntry.PropertyType { .single(.none) }
    public static var number: SGFPropertyEntry.PropertyType { .single(.number) }
    public static var real: SGFPropertyEntry.PropertyType { .single(.real) }
    public static var double: SGFPropertyEntry.PropertyType { .single(.double) }
    public static var color: SGFPropertyEntry.PropertyType { .single(.color) }
    public static var simpleText: SGFPropertyEntry.PropertyType { .single(.simpleText) }
    public static var text: SGFPropertyEntry.PropertyType { .single(.text) }
    public static var point: SGFPropertyEntry.PropertyType { .single(.point) }
    public static var move: SGFPropertyEntry.PropertyType { .single(.move) }
    public static var stone: SGFPropertyEntry.PropertyType { .single(.stone) }
}

// MARK: - Predefined Properties

extension SGFPropertyEntry {
    // MARK: - Move
    static var black: Self { SGFPropertyEntry(name: "B", type: .move) }
    static var blackTimeLeft: Self { SGFPropertyEntry(name: "BL", type: .real) }
    static var badMove: Self { SGFPropertyEntry(name: "BM", type: .double) }
    static var doubtful: Self { SGFPropertyEntry(name: "DO", type: .none) }
    static var interesting: Self { SGFPropertyEntry(name: "IT", type: .none) }
    static var ko: Self { SGFPropertyEntry(name: "KO", type: .none) }
    static var moveNumber: Self { SGFPropertyEntry(name: "MN", type: .number) }
    static var otStoneBlack: Self { SGFPropertyEntry(name: "OB", type: .number) }
    static var otStoneWhite: Self { SGFPropertyEntry(name: "OW", type: .number) }
    static var tesuji: Self { SGFPropertyEntry(name: "TE", type: .double) }
    static var white: Self { SGFPropertyEntry(name: "W", type: .move) }
    static var whirteTimeLeft: Self { SGFPropertyEntry(name: "WL", type: .real) }

    // MARK: - Setup
    static var addBlack: Self { SGFPropertyEntry(name: "AB", type: .list(of: .stone)) }
    static var addEmpty: Self { SGFPropertyEntry(name: "AE", type: .list(of: .point)) }
    static var addWhite: Self { SGFPropertyEntry(name: "AW", type: .list(of: .stone)) }
    static var playerToPlay: Self { SGFPropertyEntry(name: "PL", type: .color) }

    // MARK: - None
    static var arrow: Self { SGFPropertyEntry(name: "AR", type: .list(of: .compose(.point, .point))) }
    static var comment: Self { SGFPropertyEntry(name: "C", type: .text) }
    static var circle: Self { SGFPropertyEntry(name: "CR", type: .list(of: .point)) }
    static var dimPoints: Self { SGFPropertyEntry(name: "DD", type: .elist(of: .point)) }
    static var evenPosition: Self { SGFPropertyEntry(name: "DM", type: .double) }
    static var figure: Self { SGFPropertyEntry(name: "FG", type: .union(.none, or: .compose(.number, .simpleText))) }
    static var goodForBlack: Self { SGFPropertyEntry(name: "GB", type: .double) }
    static var goodForWhite: Self { SGFPropertyEntry(name: "GW", type: .double) }
    static var hotspot: Self { SGFPropertyEntry(name: "HO", type: .double) }
    static var label: Self { SGFPropertyEntry(name: "LB", type: .list(of: .compose(.point, .simpleText))) }
    static var line: Self { SGFPropertyEntry(name: "LN", type: .list(of: .compose(.point, .point))) }
    static var mark: Self { SGFPropertyEntry(name: "MA", type: .list(of: .point)) }
    static var nodeName: Self { SGFPropertyEntry(name: "N", type: .simpleText) }
    static var printMoveMode: Self { SGFPropertyEntry(name: "PM", type: .number) }
    static var selected: Self { SGFPropertyEntry(name: "SL", type: .list(of: .point)) }
    static var square: Self { SGFPropertyEntry(name: "SQ", type: .list(of: .point)) }
    static var triangle: Self { SGFPropertyEntry(name: "TR", type: .list(of: .point)) }
    static var unclearPos: Self { SGFPropertyEntry(name: "UC", type: .double) }
    static var value: Self { SGFPropertyEntry(name: "V", type: .real) }
    static var view: Self { SGFPropertyEntry(name: "VW", type: .elist(of: .point)) }

    // MARK: - Root
    static var application: Self { SGFPropertyEntry(name: "AP", type: .single(.compose(.simpleText, .number))) }
    static var charset: Self { SGFPropertyEntry(name: "CA", type: .simpleText) }
    static var fileformat: Self { SGFPropertyEntry(name: "FF", type: .number) }
    static var game: Self { SGFPropertyEntry(name: "GM", type: .number) }
    static var style: Self { SGFPropertyEntry(name: "ST", type: .number) }
    static var size: Self { SGFPropertyEntry(name: "SZ", type: .union(.number, or: .compose(.number, .number))) }

    // MARK: - Game Info
    static var annotation: Self { SGFPropertyEntry(name: "AN", type: .simpleText) }
    static var blackRank: Self { SGFPropertyEntry(name: "BR", type: .simpleText) }
    static var blackTeam: Self { SGFPropertyEntry(name: "BT", type: .simpleText) }
    static var copyright: Self { SGFPropertyEntry(name: "CP", type: .simpleText) }
    static var date: Self { SGFPropertyEntry(name: "DT", type: .simpleText) }
    static var event: Self { SGFPropertyEntry(name: "EV", type: .simpleText) }
    static var gameComment: Self { SGFPropertyEntry(name: "GC", type: .text) }
    static var gameName: Self { SGFPropertyEntry(name: "GN", type: .simpleText) }
    static var opening: Self { SGFPropertyEntry(name: "ON", type: .simpleText) }
    static var overtime: Self { SGFPropertyEntry(name: "OT", type: .simpleText) }
    static var playerBlack: Self { SGFPropertyEntry(name: "PB", type: .simpleText) }
    static var place: Self { SGFPropertyEntry(name: "PC", type: .simpleText) }
    static var playerWhite: Self { SGFPropertyEntry(name: "PW", type: .simpleText) }
    static var result: Self { SGFPropertyEntry(name: "RE", type: .simpleText) }
    static var round: Self { SGFPropertyEntry(name: "RO", type: .simpleText) }
    static var rules: Self { SGFPropertyEntry(name: "RU", type: .simpleText) }
    static var source: Self { SGFPropertyEntry(name: "SO", type: .simpleText) }
    static var timeLimit: Self { SGFPropertyEntry(name: "TM", type: .real) }
    static var user: Self { SGFPropertyEntry(name: "US", type: .simpleText) }
    static var whiteRank: Self { SGFPropertyEntry(name: "WR", type: .simpleText) }
    static var whiteTeam: Self { SGFPropertyEntry(name: "WT", type: .simpleText) }
}

extension SGFPropertyEntry {
    static var generalEntries: [Self] {
        [
            .black,
            .blackTimeLeft,
            .badMove,
            .doubtful,
            .interesting,
            .ko,
            .moveNumber,
            .otStoneBlack,
            .otStoneWhite,
            .tesuji,
            .white,
            .whirteTimeLeft,
            .addBlack,
            .addEmpty,
            .addWhite,
            .playerToPlay,
            .arrow,
            .comment,
            .circle,
            .dimPoints,
            .evenPosition,
            .figure,
            .goodForBlack,
            .goodForWhite,
            .hotspot,
            .label,
            .line,
            .mark,
            .nodeName,
            .printMoveMode,
            .selected,
            .square,
            .triangle,
            .unclearPos,
            .value,
            .view,
            .application,
            .charset,
            .fileformat,
            .game,
            .style,
            .size,
            .annotation,
            .blackRank,
            .blackTeam,
            .copyright,
            .date,
            .event,
            .gameComment,
            .gameName,
            .opening,
            .overtime,
            .playerBlack,
            .place,
            .playerWhite,
            .result,
            .round,
            .rules,
            .source,
            .timeLimit,
            .user,
            .whiteRank,
            .whiteTeam,
        ]
    }
}
