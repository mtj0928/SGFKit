/// A definition of a node property.
///
/// By defining a static value of this class, a value can be read and written in a type-safe manner.
/// ```swift
/// extension PropertyDefinition {
///     static var  black: Property<Move> { Property(name: "B", inherit: false) }
/// }
///
/// let node: Node<Go> = ...
/// let move: Go.Move = node.propertyValue(of: .black)
/// ```
///
/// Because this struct conforms to `ExpressibleByStringLiteral`, the node can be defined with a string literal.
/// In this case, `inherit` is `false`.
/// ```swift
/// extension PropertyDefinition {
///     static var black: Property<Move> { "B" }
/// }
/// ```
public struct PropertyDefinition<Game: SGFKit.Game, Value: PropertyValue>: ExpressibleByStringLiteral, Sendable {
    public let name: String
    public let inherit: Bool

    public init(name: String, inherit: Bool, as: Value.Type = Value.self) {
        self.name = name
        self.inherit = inherit
    }

    public init(stringLiteral value: StringLiteralType) {
        self.name = value
        self.inherit = false
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

    /// A definition for `B`. This receives `Move` as a value.
    ///
    /// Execute a black move. This is one of the most used properties in actual collections.
    /// As long as the given move is syntactically correct it should be executed.
    /// It doesn't matter if the move itself is illegal (e.g. recapturing a ko in a Go game).
    /// Have a look at how to execute a Go-move.
    /// B and W properties must not be mixed within a node.
    public static var black: Property<Move> { "B" }

    /// A definition for `BL`. This receives `Real` as a value.
    ///
    /// Black time left after the move was made. The time is given in seconds.
    public static var blackTimeLeft: Property<Real> { "BL" }

    /// A definition for `BM`. This receives `Double` as a value.
    ///
    /// Marks the move as a bad move. Viewers should display a symbol indicating a bad move.
    /// This property cannot be mixed with `TE`, `DO`, or `IT` properties in the same node.
    public static var badMove: Property<Double> { "BM" }

    /// A definition for `DO`. This receives `None` as a value.
    ///
    /// Marks the move as doubtful. Viewers should display a symbol indicating a doubtful move.
    /// This property cannot be mixed with `BM`, `TE`, or `IT` properties in the same node.
    public static var doubtful: Property<None> { "DO" }

    /// A definition for `IT`. This receives `None` as a value.
    ///
    /// Marks the move as interesting. Viewers should display a symbol indicating an interesting move.
    /// This property cannot be mixed with `BM`, `DO`, or `TE` properties in the same node.
    public static var interesting: Property<None> { "IT" }

    /// A definition for `KO`. This receives `None` as a value.
    ///
    /// Execute the given move even if it's illegal. This property is used for compatibility with other applications.
    /// A node containing this property must also contain either a `B` or `W` property.
    public static var ko: Property<None> { "KO" }

    /// A definition for `MN`. This receives `Number` as a value.
    ///
    /// Sets the move number to the specified value. This is useful for variations or printing.
    public static var setMoveNumber: Property<Number> { "MN" }

    /// A definition for `OB`. This receives `Number` as a value.
    ///
    /// Overtime stones left (byo-yomi) for black. The number of moves left in the overtime period.
    public static var otStonesBlack: Property<Number> { "OB" }

    /// A definition for `OW`. This receives `Number` as a value.
    ///
    /// Overtime stones left (byo-yomi) for white. The number of moves left in the overtime period.
    public static var otStonesWhite: Property<Number> { "OW" }

    /// A definition for `TE`. This receives `Double` as a value.
    ///
    /// Marks the move as a tesuji (good move). Viewers should display a symbol indicating a good move.
    /// This property cannot be mixed with `BM`, `DO`, or `IT` properties in the same node.
    public static var tesuji: Property<Double> { "TE" }

    /// A definition for `W`. This receives `Move` as a value.
    ///
    /// Execute a white move. This is one of the most used properties in actual collections.
    /// As long as the given move is syntactically correct it should be executed.
    /// It doesn't matter if the move itself is illegal (e.g. recapturing a ko in a Go game).
    /// B and W properties must not be mixed within a node.
    public static var white: Property<Move> { "W" }

    /// A definition for `WL`. This receives `Real` as a value.
    ///
    /// White time left after the move was made. The time is given in seconds.
    public static var whiteTimeLeft: Property<Real> { "WL" }

    // MARK: - setup

    /// A definition for `AB`. This receives `List<Stone>` as a value.
    ///
    /// Adds black stones to the board. This is used for setting up positions or problems.
    /// Points must be unique. Existing stones at the specified points can be overwritten.
    public static var addBlack: Property<List<Stone>> { "AB" }

    /// A definition for `AE`. This receives `List<Point>` as a value.
    ///
    /// Clears the specified points on the board, removing any stones.
    /// This provides flexibility when setting up board positions. Points must be unique.
    public static var addEmpty: Property<List<Point>> { "AE" }

    /// A definition for `AW`. This receives `List<Stone>` as a value.
    ///
    /// Adds white stones to the board. This is used for setting up positions or problems.
    /// Points must be unique. Existing stones at the specified points can be overwritten.
    public static var addWhite: Property<List<Stone>> { "AW" }

    /// A definition for `PL`. This receives `Color` as a value.
    ///
    /// Specifies which player is to move next. This is used for turn management,
    /// particularly when setting up positions or problems.
    public static var playerToPlay: Property<Color> { "PL" }

    // MARK: - none

    /// A definition for `AR`. This receives `List<Compose<Point, Point>>` as a value.
    ///
    /// Draws an arrow from the first point to the second point.
    /// The same arrow cannot be specified more than once. Different arrows may share end points.
    /// An arrow from a point to itself is illegal.
    public static var arrow: Property<List<Compose<Point, Point>>> { "AR" }

    /// A definition for `C`. This receives `Text` as a value.
    ///
    /// Provides a comment for the node. Comments can be combined with node names for both
    /// short identification and detailed descriptions.
    public static var comment: Property<Text> { "C" }

    /// A definition for `CR`. This receives `List<Point>` as a value.
    ///
    /// Marks the specified points with a circle. Points must be unique.
    public static var circle: Property<List<Point>> { "CR" }

    /// A definition for `DD`. This receives `EList<Point>` as a value.
    ///
    /// Dims (grays out) the specified points on the board.
    /// Use `DD[]` with an empty list to restore all dimmed points. This property inherits.
    public static var dimPoints: Property<EList<Point>> { Property(name: "DD", inherit: true) }

    /// A definition for `DM`. This receives `Double` as a value.
    ///
    /// Indicates an even position where neither player has an advantage. Viewers should display this.
    /// This can also mark the main variation in joseki collections.
    /// This property cannot be mixed with `UC`, `GB`, or `GW` in the same node.
    public static var evenPosition: Property<Double> { "DM" }

    /// A definition for `FG`. This receives `Union<None, Compose<Number, SimpleText>>` as a value.
    ///
    /// Divides the game into figures for printing. The flags control display of coordinates,
    /// diagram name, and move numbers.
    /// Flag values: 0/1 (coordinates), 0/2 (diagram name), 0/4 (list moves not shown in figure),
    /// 0/256 (remove captures), 0/512 (hoshi dots), 32768 (ignore flags).
    public static var figure: Property<Union<None, Compose<Number, SimpleText>>> { "FG" }

    /// A definition for `GB`. This receives `Double` as a value.
    ///
    /// Indicates the position is good for black. Viewers should display a symbol.
    /// This property cannot be mixed with `GW`, `DM`, or `UC` in the same node.
    public static var goodForBlack: Property<Double> { "GB" }

    /// A definition for `GW`. This receives `Double` as a value.
    ///
    /// Indicates the position is good for white. Viewers should display a symbol.
    /// This property cannot be mixed with `GB`, `DM`, or `UC` in the same node.
    public static var goodForWhite: Property<Double> { "GW" }

    /// A definition for `HO`. This receives `Double` as a value.
    ///
    /// Marks the node as a hotspot, indicating an interesting or game-deciding position.
    public static var hotspot: Property<Double> { "HO" }

    /// A definition for `LB`. This receives `List<Compose<Point, SimpleText>>` as a value.
    ///
    /// Writes text labels on the board at the specified points. Supports long labels.
    /// Points must be unique.
    public static var label: Property<List<Compose<Point, SimpleText>>> { "LB" }

    /// A definition for `LN`. This receives `List<Compose<Point, Point>>` as a value.
    ///
    /// Draws a line between two points.
    /// The same line cannot be specified more than once. A line from a point to itself is illegal.
    public static var line: Property<List<Compose<Point, Point>>> { "LN" }

    /// A definition for `MA`. This receives `List<Point>` as a value.
    ///
    /// Marks the specified points with an X symbol. Points must be unique.
    public static var mark: Property<List<Point>> { "MA" }

    /// A definition for `N`. This receives `SimpleText` as a value.
    ///
    /// Provides a name for the node. This is used for short identification, such as "doesn't work".
    public static var nodename: Property<SimpleText> { "N" }

    /// A definition for `PM`. This receives `Number` as a value.
    ///
    /// Controls how move numbers are printed. 0 = don't print, 1 = print as is, 2 = print modulo 100.
    /// Default value is 1. This property inherits.
    public static var printMoveMode: Property<Number> { Property(name: "PM", inherit: true) }

    /// A definition for `SL`. This receives `List<Point>` as a value.
    ///
    /// Marks the specified points as selected. In SGB, selected points are displayed with inverted colors.
    /// Points must be unique.
    public static var selected: Property<List<Point>> { "SL" }

    /// A definition for `SQ`. This receives `List<Point>` as a value.
    ///
    /// Marks the specified points with a square. Points must be unique.
    public static var square: Property<List<Point>> { "SQ" }

    /// A definition for `TR`. This receives `List<Point>` as a value.
    ///
    /// Marks the specified points with a triangle. Points must be unique.
    public static var triangle: Property<List<Point>> { "TR" }

    /// A definition for `UC`. This receives `Double` as a value.
    ///
    /// Indicates an unclear position where it's difficult to evaluate who has the advantage.
    /// Viewers should display this.
    /// This property cannot be mixed with `DM`, `GB`, or `GW` in the same node.
    public static var unclearPos: Property<Double> { "UC" }

    /// A definition for `V`. This receives `Real` as a value.
    ///
    /// Provides a value for the node (score estimate). Positive values indicate good for black,
    /// negative values indicate good for white.
    public static var value: Property<Real> { "V" }

    /// A definition for `VW`. This receives `EList<Point>` as a value.
    ///
    /// Restricts the view to show only a portion of the board containing the specified points.
    /// Use `VW[]` with an empty list to restore the full board view. This property inherits.
    public static var view: Property<EList<Point>> { Property(name: "VW", inherit: true) }

    // MARK: - root

    /// A definition for `AP`. This receives `Compose<SimpleText, Number>` as a value.
    ///
    /// Specifies the name and version of the application that created the SGF file.
    /// The version format should be comparable (e.g., "1.5" or "2.0").
    public static var application: Property<Compose<SimpleText, Number>> { "AP" }

    /// A definition for `CA`. This receives `SimpleText` as a value.
    ///
    /// Specifies the character set used for SimpleText and Text properties.
    /// Must follow RFC 1345. Default value is "ISO-8859-1".
    public static var charset: Property<SimpleText> { "CA" }

    /// A definition for `FF`. This receives `Number` as a value.
    ///
    /// Defines the file format version (1-4). Applications should support multiple formats.
    /// Default value is 1.
    public static var fileFormat: Property<Number> { "FF" }

    /// A definition for `GM`. This receives `Number` as a value.
    ///
    /// Defines the type of game. Go = 1, Othello = 2, Chess = 3, etc.
    public static var game: Property<Number> { "GM" }

    /// A definition for `ST`. This receives `Number` as a value.
    ///
    /// Defines the variation display style (0-3). Used for problem collections and
    /// synchronizing annotations with variations. Default value is 0.
    public static var style: Property<Number> { "ST" }

    /// A definition for `SZ`. This receives `Union<Number, Compose<Number, Number>>` as a value.
    ///
    /// Defines the board size. A single number indicates a square board, while a composition
    /// indicates a rectangular board (columns × rows).
    /// For Go, the maximum is 52×52. Default is 19×19 for Go.
    public static var size: Property<Union<Number, Compose<Number, Number>>> { "SZ" }

    // MARK: - game-info

    /// A definition for `AN`. This receives `SimpleText` as a value.
    ///
    /// Records the name of the person who annotated the game.
    public static var annotation: Property<SimpleText> { "AN" }

    /// A definition for `BR`. This receives `SimpleText` as a value.
    ///
    /// Records the rank of the black player. For Go, the recommended format is "..k" for kyu or "..d" for dan.
    /// Use "?" for uncertain rank, and append "*" for confirmed rank.
    public static var blackRank: Property<SimpleText> { "BR" }

    /// A definition for `BT`. This receives `SimpleText` as a value.
    ///
    /// Records the name of the black team in team games.
    public static var blackTeam: Property<SimpleText> { "BT" }

    /// A definition for `CP`. This receives `SimpleText` as a value.
    ///
    /// Records copyright information for the game.
    public static var copyright: Property<SimpleText> { "CP" }

    /// A definition for `DT`. This receives `SimpleText` as a value.
    ///
    /// Records the date when the game was played. Must use ISO format YYYY-MM-DD.
    /// Supports partial dates and multiple dates. Shortcuts like "1996-05,06" are allowed.
    public static var date: Property<SimpleText> { "DT" }

    /// A definition for `EV`. This receives `SimpleText` as a value.
    ///
    /// Records the name of the event (e.g., tournament). Additional information should be stored in `RO`.
    public static var event: Property<SimpleText> { "EV" }

    /// A definition for `GC`. This receives `Text` as a value.
    ///
    /// Provides background information or a summary of the game.
    public static var gameComment: Property<Text> { "GC" }

    /// A definition for `GN`. This receives `SimpleText` as a value.
    ///
    /// Records the name of the game. Used as a search identifier within collections.
    public static var gameName: Property<SimpleText> { "GN" }

    /// A definition for `ON`. This receives `SimpleText` as a value.
    ///
    /// Records opening information (e.g., "Sanrensei", "Chinese Opening").
    public static var opening: Property<SimpleText> { "ON" }

    /// A definition for `OT`. This receives `SimpleText` as a value.
    ///
    /// Records the overtime (byo-yomi) system used. For example, "5 mins Japanese style, 1 move/min".
    public static var overtime: Property<SimpleText> { "OT" }

    /// A definition for `PB`. This receives `SimpleText` as a value.
    ///
    /// Records the name of the black player.
    public static var playerBlack: Property<SimpleText> { "PB" }

    /// A definition for `PC`. This receives `SimpleText` as a value.
    ///
    /// Records the place where the game was played.
    public static var place: Property<SimpleText> { "PC" }

    /// A definition for `PW`. This receives `SimpleText` as a value.
    ///
    /// Records the name of the white player.
    public static var playerWhite: Property<SimpleText> { "PW" }

    /// A definition for `RE`. This receives `SimpleText` as a value.
    ///
    /// Records the result of the game. Format: "B+score", "W+score", "0"/"Draw", etc.
    /// Required formats include: B+R (resign), W+T (time), B+F (forfeit), Void, or "?" for unknown.
    public static var result: Property<SimpleText> { "RE" }

    /// A definition for `RO`. This receives `SimpleText` as a value.
    ///
    /// Records the round number and type. Format: "RO[xx (tt)]" where xx is the number and tt is the type.
    public static var round: Property<SimpleText> { "RO" }

    /// A definition for `RU`. This receives `SimpleText` as a value.
    ///
    /// Specifies the rules used. For Go, recommended values are "AGA", "GOE", "Japanese", or "NZ".
    public static var rules: Property<SimpleText> { "RU" }

    /// A definition for `SO`. This receives `SimpleText` as a value.
    ///
    /// Records the source of the game (e.g., book, magazine).
    public static var source: Property<SimpleText> { "SO" }

    /// A definition for `TM`. This receives `Real` as a value.
    ///
    /// Records the time limit in seconds.
    public static var timeLimit: Property<Real> { "TM" }

    /// A definition for `US`. This receives `SimpleText` as a value.
    ///
    /// Records the name of the person who entered the data or the program used.
    public static var user: Property<SimpleText> { "US" }

    /// A definition for `WR`. This receives `SimpleText` as a value.
    ///
    /// Records the rank of the white player. Same format as `BR` is recommended.
    public static var whiteRank: Property<SimpleText> { "WR" }

    /// A definition for `WT`. This receives `SimpleText` as a value.
    ///
    /// Records the name of the white team in team games.
    public static var whiteTeam: Property<SimpleText> { "WT" }
}
