public struct PropertyDefinition<Game: SGFKit.Game, Value: PropertyValue>: ExpressibleByStringLiteral {
    let name: String

    public init(name: String, as: Value.Type = Value.self) {
        self.name = name
    }

    public init(stringLiteral value: StringLiteralType) {
        self.name = value
    }
}

extension PropertyDefinition {
    public typealias Property<V: PropertyValue> = PropertyDefinition<Game, V>

    public typealias Number = Int
    public typealias Real = SGFReal
    public typealias Double = SGFDouble
    public typealias Color = SGFColor
    public typealias SimpleText = SGFSimpleText
    public typealias Text = SGFText
    public typealias None = SGFNone
    public typealias Stone = Game.Stone
    public typealias Point = Game.Point
    public typealias Move = Game.Move

    public typealias List = SGFList
    public typealias EList = SGFEList
    public typealias Compose = SGFCompose
    public typealias Union = SGFUnion

    // MARK: - move
    public static var black: Property<Move> { "B" }
    public static var blackTimeLeft: Property<Real> { "BL" }
    public static var badMove: Property<Move> { "BM" }
    public static var doubtful: Property<None> { "DO" }
    public static var interesting: Property<None> { "IT" }
    public static var ko: Property<None> { "KO" }
    public static var setMoveNumber: Property<Number> { "MN" }
    public static var otStonesBlack: Property<Number> { "OB" }
    public static var otStonesWhite: Property<Number> { "OW" }
    public static var tesuji: Property<Double> { "TE" }
    public static var white: Property<Move> { "W" }
    public static var whiteTimeLeft: Property<Real> { "WL" }

    // MARK: - setup
    public static var addBlack: Property<List<Stone>> { "AB" }
    public static var addEmpty: Property<List<Point>> { "AE" }
    public static var addWhite: Property<List<Stone>> { "AW" }
    public static var playerToPlay: Property<Color> { "PL" }

    // MARK: - none
    public static var arrow: Property<List<Compose<Point, Point>>> { "AR" }
    public static var comment: Property<Text> { "C" }
    public static var circle: Property<List<Point>> { "CR" }
    public static var dimPoints: Property<EList<Point>> { "DD" }
    public static var eventPosition: Property<Double> { "DM" }
    public static var figure: Property<Union<None, Compose<Number, SimpleText>>> { "FG" }
    public static var goodForBlack: Property<Double> { "GB" }
    public static var goodForWhite: Property<Double> { "GW" }
    public static var hotspot: Property<Double> { "HO" }
    public static var label: Property<List<Compose<Point, SimpleText>>> { "LB" }
    public static var line: Property<List<Compose<Point, Point>>> { "LN" }
    public static var mark: Property<List<Point>> { "MA" }
    public static var nodename: Property<SimpleText> { "N" }
    public static var printMoveMode: Property<Number> { "PM" }
    public static var selected: Property<List<Point>> { "SL" }
    public static var square: Property<List<Point>> { "SQ" }
    public static var triangle: Property<List<Point>> { "TR" }
    public static var unclearPos: Property<Double> { "UC" }
    public static var value: Property<Real> { "V" }
    public static var view: Property<EList<Point>> { "VW" }

    // MARK: - root
    public static var application: Property<Compose<SimpleText, Number>> { "AP" }
    public static var charset: Property<SimpleText> { "CA" }
    public static var fileFormat: Property<Number> { "FF" }
    public static var game: Property<Number> { "GM" }
    public static var style: Property<Number> { "ST" }
    public static var size: Property<Union<Number, Compose<Number, Number>>> { "SZ" }

    // MARK: - game-info
    public static var annotation: Property<SimpleText> { "AN" }
    public static var blackRank: Property<SimpleText> { "BR" }
    public static var blackTeam: Property<SimpleText> { "BT" }
    public static var copyright: Property<SimpleText> { "CP" }
    public static var date: Property<SimpleText> { "DT" }
    public static var event: Property<SimpleText> { "EV" }
    public static var gameComment: Property<Text> { "GC" }
    public static var gameName: Property<SimpleText> { "GN" }
    public static var opening: Property<SimpleText> { "ON" }
    public static var overtime: Property<SimpleText> { "OT" }
    public static var playerBlack: Property<SimpleText> { "PB" }
    public static var place: Property<SimpleText> { "PC" }
    public static var playerWhite: Property<SimpleText> { "PW" }
    public static var result: Property<SimpleText> { "RE" }
    public static var round: Property<SimpleText> { "RO" }
    public static var rules: Property<SimpleText> { "RU" }
    public static var source: Property<SimpleText> { "SO" }
    public static var timeLimit: Property<Real> { "TM" }
    public static var user: Property<SimpleText> { "US" }
    public static var whiteRank: Property<SimpleText> { "WR" }
    public static var whiteTeam: Property<SimpleText> { "WT" }
}
