public protocol SGFTypeProtocol: Hashable, Sendable {
    associatedtype Return: Hashable, Sendable
}

public enum SGFType<Game: SGFGame>: Hashable & Sendable {
    case single(SGFTypes<Game>.Sequence)
    case union(SGFTypes<Game>.Sequence, SGFTypes<Game>.Sequence)
}

public struct SGFTypeInformation<Game: SGFGame, Value: Hashable & Sendable>: Hashable, Sendable {
    public typealias PrimitiveType<V: Sendable & Hashable> = SGFTypes<Game>.SGFValuePrimitiveType<V>
    public typealias ListType<V: Sendable & Hashable> = SGFTypes<Game>.ListType<V>
    public typealias EListType<V: Sendable & Hashable> = SGFTypes<Game>.EListType<V>
    public typealias UnionType<V1: Sendable & Hashable, V2: Sendable & Hashable> = SGFTypes<Game>.UnionType<V1, V2>
    public typealias ComposedType<V1: Sendable & Hashable, V2: Sendable & Hashable> = SGFTypes<Game>.ComposeType<V1, V2>

    var type: SGFType<Game>

    public static func list<V: Hashable & Sendable>(of value: PrimitiveType<V>) -> SGFTypeInformation<Game, ListType<V>> {
        .init(type: .single(.list(.init(compose: .single(value.type)))))
    }

    public static func list<
        V1: Hashable & Sendable,
        V2: Hashable & Sendable
    >(
        of value: ComposedType<V1, V2>
    ) -> SGFTypeInformation<Game, ListType<ComposedType<V1, V2>>> {
        .init(type: .single(.list(.init(compose: value.compose))))
    }

    public static func elist<V: Hashable & Sendable>(
        of value: PrimitiveType<V>
    ) -> SGFTypeInformation<Game, EListType<V>> {
        .init(type: .single(.elist(.init(compose: .single(value.type)))))
    }

    public static func union<
        TypeA: Hashable & Sendable,
        TypeB: Hashable & Sendable,
        TypeC: Hashable & Sendable,
        TypeD: Hashable & Sendable
    >(
        _ first: ComposedType<TypeA, TypeB>,
        or second: ComposedType<TypeC, TypeD>
    ) -> SGFTypeInformation<Game, UnionType<ComposedType<TypeA, TypeB>, ComposedType<TypeC, TypeD>>> {
        .init(type: .union(.single(first.compose), .single(second.compose)))
    }

    public static func union<
        ValueA: Hashable & Sendable,
        ValueB: Hashable & Sendable,
        ValueC: Hashable & Sendable
    >(
        _ first: PrimitiveType<ValueA>,
        or second: ComposedType<ValueB, ValueC>
    ) -> SGFTypeInformation<Game, UnionType<ValueA, ComposedType<ValueB, ValueC>>> {
        .init(type: .union(.single(.single(first.type)), .single(second.compose)))
    }

    public static func compose<
        V1: Hashable & Sendable,
        V2: Hashable & Sendable
    >(
        _ first: PrimitiveType<V1>,
        _ second: PrimitiveType<V2>
    ) -> SGFTypeInformation<Game, ComposedType<V1, V2>>  {
        .init(type: .single(.single(.compose(first.type, second.type))))
    }

    public static func single<V: Hashable & Sendable>(
        _ value: SGFTypes<Game>.SGFValuePrimitiveType<V>
    ) -> SGFTypeInformation<Game, V> {
        .init(type: .single(.single(.single(value.type))))
    }

    public static var none: SGFTypeInformation<Game, Never> { .single(.none) }
    public static var number: SGFTypeInformation<Game, Int> { .single(.number) }
    public static var real: SGFTypeInformation<Game, Double> { .single(.real) }
    public static var double: SGFTypeInformation<Game, SGFDouble> { .single(.double) }
    public static var color: SGFTypeInformation<Game, SGFColor> { .single(.color) }
    public static var simpleText: SGFTypeInformation<Game, String> { .single(.simpleText) }
    public static var text: SGFTypeInformation<Game, String> { .single(.text) }
    public static var point: SGFTypeInformation<Game, Game.Point> { .single(.point) }
    public static var move: SGFTypeInformation<Game, Game.Move> { .single(.move) }
    public static var stone: SGFTypeInformation<Game, Game.Stone> { .single(.stone) }
}

public enum SGFTypes<Game: SGFGame> {
    // MARK: - Union

    public struct Union: Hashable, Sendable {
        public var first: Sequence
        public var second: Sequence?
    }

    public struct UnionType<PrimitiveTypeA: Hashable & Sendable, PrimitiveTypeB: Hashable & Sendable>: Hashable, Sendable {
        let union: Union

        public static func single<ValueA: Hashable & Sendable>(_ type: SGFValuePrimitiveType<ValueA>) -> UnionType<ValueA, Never> {
            .init(union: .init(first: .single(.single(type.type))))
        }

        public static func compose<ValueA: Hashable & Sendable, ValueB: Hashable & Sendable>(_ type: ComposeType<ValueA, ValueB>) -> UnionType<ValueA, ValueB> {
            .init(union: .init(first: .single(type.compose)))
        }

        public static func union<
            ValueA: Hashable & Sendable,
            ValueB: Hashable & Sendable,
            ValueC: Hashable & Sendable
        >(
            _ first: SGFValuePrimitiveType<ValueA>,
            or second: ComposeType<ValueB, ValueC>
        ) -> UnionType<ValueA, ComposeType<ValueB, ValueC>> {
            .init(union: .init(first: .single(.single(first.type)), second: .single(second.compose)))
        }

        public static func union<
            ValueA: Hashable & Sendable,
            ValueB: Hashable & Sendable,
            ValueC: Hashable & Sendable,
            ValueD: Hashable & Sendable
        >(
            _ first: ComposeType<ValueA, ValueB>,
            or second: ComposeType<ValueC, ValueD>
        ) -> UnionType<ComposeType<ValueA, ValueB>, ComposeType<ValueC, ValueD>> {
            .init(union: .init(first: .single(first.compose), second: .single(second.compose)))
        }

        public static var none: UnionType<Never, Never> { .single(.none) }
        public static var number: UnionType<Int, Never> { .single(.number) }
        public static var real: UnionType<Double, Never> { .single(.real) }
        public static var double: UnionType<SGFDouble, Never> { .single(.double) }
        public static var color: UnionType<SGFColor, Never> { .single(.color) }
        public static var simpleText: UnionType<String, Never> { .single(.simpleText) }
        public static var text: UnionType<String, Never> { .single(.text) }
        public static var point: UnionType<Game.Point, Never> { .single(.point) }
        public static var move: UnionType<Game.Move, Never> { .single(.move) }
        public static var stone: UnionType<Game.Stone, Never> { .single(.stone) }
    }

    // MARK: - List

    public enum Sequence: Hashable, Sendable {
        case single(Compose)
        case list(List)
        case elist(EList)
    }

    public enum SequenceType<Object: Hashable & Sendable>: Hashable, Sendable {
        case single(Object)
        case list(Object)
        case elist(Object)
    }

    public struct List: Hashable, Sendable {
        public var compose: Compose
    }

    public struct ListType<Object: Hashable & Sendable>: Sendable, Hashable {
        var compose: List

        public static func list(of value: SGFValuePrimitiveType<Object>) -> ListType<Object> {
            ListType(compose: List(compose: .single(value.type)))
        }
    }

    public struct EList: Hashable, Sendable {
        public var compose: Compose
    }

    public struct EListType<Object: Hashable & Sendable>: Hashable, Sendable {
        var list: EList

        public static func elist(of value: SGFValuePrimitiveType<Object>) -> EListType<Object> {
            EListType(list: EList(compose: .single(value.type)))
        }
    }
    // MARK: - Compose

    public enum Compose: Hashable, Sendable {
        case single(Primitive)
        case compose(Primitive, Primitive)
    }

    public struct ComposeType<PrimitiveTypeA: Hashable & Sendable, PrimitiveTypeB: Hashable & Sendable>: Hashable, Sendable {
        var compose: Compose

        static func single<V: Hashable & Sendable>(_ type: SGFValuePrimitiveType<V>) -> ComposeType<V, Never> {
            .init(compose: .single(type.type))
        }

        static func compose<ValueA: Hashable & Sendable, ValueB: Hashable & Sendable>(
            _ typeA: SGFValuePrimitiveType<ValueA>,
            _ typeB: SGFValuePrimitiveType<ValueB>
        ) -> ComposeType<ValueA, ValueB> {
            .init(compose: .compose(typeA.type, typeB.type))
        }

        public static var none: ComposeType<Never, Never> { .single(.none) }
        public static var number: ComposeType<Int, Never> { .single(.number) }
        public static var real: ComposeType<Double, Never> { .single(.real) }
        public static var double: ComposeType<SGFDouble, Never> { .single(.double) }
        public static var color: ComposeType<SGFColor, Never> { .single(.color) }
        public static var simpleText: ComposeType<String, Never> { .single(.simpleText) }
        public static var text: ComposeType<String, Never> { .single(.text) }
        public static var point: ComposeType<Game.Point, Never> { .single(.point) }
        public static var move: ComposeType<Game.Move, Never> { .single(.move) }
        public static var stone: ComposeType<Game.Stone, Never> { .single(.stone) }
    }

    // MARK: - Primitive

    public enum Primitive: Hashable, Sendable {
        case none
        case number
        case real
        case double
        case color
        case simpleText
        case text
        case point
        case move
        case stone
    }

    public struct SGFValuePrimitiveType<V: Hashable & Sendable>: Hashable, Sendable {
        let type: Primitive

        static var none: SGFValuePrimitiveType<Never> { .init(type: .none) }
        static var number: SGFValuePrimitiveType<Int> { .init(type: .number) }
        static var real: SGFValuePrimitiveType<Double> { .init(type: .real) }
        static var double: SGFValuePrimitiveType<SGFDouble> { .init(type: .double) }
        static var color: SGFValuePrimitiveType<SGFColor> { .init(type: .color) }
        static var simpleText: SGFValuePrimitiveType<String> { .init(type: .simpleText) }
        static var text: SGFValuePrimitiveType<String> { .init(type: .text) }
        static var point: SGFValuePrimitiveType<Game.Point> { .init(type: .point) }
        static var move: SGFValuePrimitiveType<Game.Move> { .init(type: .move) }
        static var stone: SGFValuePrimitiveType<Game.Stone> { .init(type: .stone) }
    }
}
