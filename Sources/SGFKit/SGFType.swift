public protocol SGFTypeProtocol: Hashable, Sendable {
    associatedtype Return: Hashable, Sendable
}

public enum SGFType<Game: SGFGame>: Hashable & Sendable {
    case single(SGFValueTypeCollection<Game>.SGFValueSequence)
    case union(SGFValueTypeCollection<Game>.SGFValueSequence, SGFValueTypeCollection<Game>.SGFValueSequence)
}

public struct SGFValueRootTypeInformation<Game: SGFGame, Value: Hashable & Sendable>: Hashable, Sendable {
    public typealias PrimitiveType<V: Sendable & Hashable> = SGFValueTypeCollection<Game>.SGFValuePrimitiveType<V>
    public typealias ListType<V: Sendable & Hashable> = SGFValueTypeCollection<Game>.SGFValueListType<V>
    public typealias EListType<V: Sendable & Hashable> = SGFValueTypeCollection<Game>.SGFValueEListType<V>
    public typealias UnionType<V1: Sendable & Hashable, V2: Sendable & Hashable> = SGFValueTypeCollection<Game>.SGFValueUnionType<V1, V2>
    public typealias ComposedType<V1: Sendable & Hashable, V2: Sendable & Hashable> = SGFValueTypeCollection<Game>.SGFValueComposedType<V1, V2>

    var type: SGFType<Game>

    public static func list<V: Hashable & Sendable>(of value: PrimitiveType<V>) -> SGFValueRootTypeInformation<Game, ListType<V>> {
        .init(type: .single(.list(.init(compose: .single(value.type)))))
    }

    public static func list<
        V1: Hashable & Sendable,
        V2: Hashable & Sendable
    >(
        of value: ComposedType<V1, V2>
    ) -> SGFValueRootTypeInformation<Game, ListType<ComposedType<V1, V2>>> {
        .init(type: .single(.list(.init(compose: value.compose))))
    }

    public static func elist<V: Hashable & Sendable>(
        of value: PrimitiveType<V>
    ) -> SGFValueRootTypeInformation<Game, EListType<V>> {
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
    ) -> SGFValueRootTypeInformation<Game, UnionType<ComposedType<TypeA, TypeB>, ComposedType<TypeC, TypeD>>> {
        .init(type: .union(.single(first.compose), .single(second.compose)))
    }

    public static func union<
        ValueA: Hashable & Sendable,
        ValueB: Hashable & Sendable,
        ValueC: Hashable & Sendable
    >(
        _ first: PrimitiveType<ValueA>,
        or second: ComposedType<ValueB, ValueC>
    ) -> SGFValueRootTypeInformation<Game, UnionType<ValueA, ComposedType<ValueB, ValueC>>> {
        .init(type: .union(.single(.single(first.type)), .single(second.compose)))
    }

    public static func compose<
        V1: Hashable & Sendable,
        V2: Hashable & Sendable
    >(
        _ first: PrimitiveType<V1>,
        _ second: PrimitiveType<V2>
    ) -> SGFValueRootTypeInformation<Game, ComposedType<V1, V2>>  {
        .init(type: .single(.single(.compose(first.type, second.type))))
    }

    public static func single<V: Hashable & Sendable>(
        _ value: SGFValueTypeCollection<Game>.SGFValuePrimitiveType<V>
    ) -> SGFValueRootTypeInformation<Game, V> {
        .init(type: .single(.single(.single(value.type))))
    }

    public static var none: SGFValueRootTypeInformation<Game, Never> { .single(.none) }
    public static var number: SGFValueRootTypeInformation<Game, Int> { .single(.number) }
    public static var real: SGFValueRootTypeInformation<Game, Double> { .single(.real) }
    public static var double: SGFValueRootTypeInformation<Game, SGFDouble> { .single(.double) }
    public static var color: SGFValueRootTypeInformation<Game, SGFColor> { .single(.color) }
    public static var simpleText: SGFValueRootTypeInformation<Game, String> { .single(.simpleText) }
    public static var text: SGFValueRootTypeInformation<Game, String> { .single(.text) }
    public static var point: SGFValueRootTypeInformation<Game, Game.Point> { .single(.point) }
    public static var move: SGFValueRootTypeInformation<Game, Game.Move> { .single(.move) }
    public static var stone: SGFValueRootTypeInformation<Game, Game.Stone> { .single(.stone) }
}

public enum SGFValueTypeCollection<Game: SGFGame> {
    // MARK: - Union

    public struct SGFValueUnion: Hashable, Sendable {
        public var first: SGFValueSequence
        public var second: SGFValueSequence?
    }

    public struct SGFValueUnionType<PrimitiveTypeA: Hashable & Sendable, PrimitiveTypeB: Hashable & Sendable>: Hashable, Sendable {
        let union: SGFValueUnion

        public static func single<ValueA: Hashable & Sendable>(_ type: SGFValuePrimitiveType<ValueA>) -> SGFValueUnionType<ValueA, Never> {
            .init(union: .init(first: .single(.single(type.type))))
        }

        public static func compose<ValueA: Hashable & Sendable, ValueB: Hashable & Sendable>(_ type: SGFValueComposedType<ValueA, ValueB>) -> SGFValueUnionType<ValueA, ValueB> {
            .init(union: .init(first: .single(type.compose)))
        }

        public static func union<
            ValueA: Hashable & Sendable,
            ValueB: Hashable & Sendable,
            ValueC: Hashable & Sendable
        >(
            _ first: SGFValuePrimitiveType<ValueA>,
            or second: SGFValueComposedType<ValueB, ValueC>
        ) -> SGFValueUnionType<ValueA, SGFValueComposedType<ValueB, ValueC>> {
            .init(union: .init(first: .single(.single(first.type)), second: .single(second.compose)))
        }

        public static func union<
            ValueA: Hashable & Sendable,
            ValueB: Hashable & Sendable,
            ValueC: Hashable & Sendable,
            ValueD: Hashable & Sendable
        >(
            _ first: SGFValueComposedType<ValueA, ValueB>,
            or second: SGFValueComposedType<ValueC, ValueD>
        ) -> SGFValueUnionType<SGFValueComposedType<ValueA, ValueB>, SGFValueComposedType<ValueC, ValueD>> {
            .init(union: .init(first: .single(first.compose), second: .single(second.compose)))
        }

        public static var none: SGFValueUnionType<Never, Never> { .single(.none) }
        public static var number: SGFValueUnionType<Int, Never> { .single(.number) }
        public static var real: SGFValueUnionType<Double, Never> { .single(.real) }
        public static var double: SGFValueUnionType<SGFDouble, Never> { .single(.double) }
        public static var color: SGFValueUnionType<SGFColor, Never> { .single(.color) }
        public static var simpleText: SGFValueUnionType<String, Never> { .single(.simpleText) }
        public static var text: SGFValueUnionType<String, Never> { .single(.text) }
        public static var point: SGFValueUnionType<Game.Point, Never> { .single(.point) }
        public static var move: SGFValueUnionType<Game.Move, Never> { .single(.move) }
        public static var stone: SGFValueUnionType<Game.Stone, Never> { .single(.stone) }
    }

    // MARK: - List

    public enum SGFValueSequence: Hashable, Sendable {
        case single(SGFCompose)
        case list(SGFValueList)
        case elist(SGFValueEList)
    }

    public enum SGFValueSequenceType<Object: Hashable & Sendable>: Hashable, Sendable {
        case single(Object)
        case list(Object)
        case elist(Object)
    }

    public struct SGFValueList: Hashable, Sendable {
        public var compose: SGFCompose
    }

    public struct SGFValueListType<Object: Hashable & Sendable>: Sendable, Hashable {
        var compose: SGFValueList

        public static func list(of value: SGFValuePrimitiveType<Object>) -> SGFValueListType<Object> {
            SGFValueListType(compose: SGFValueList(compose: .single(value.type)))
        }
    }

    public struct SGFValueEList: Hashable, Sendable {
        public var compose: SGFCompose
    }

    public struct SGFValueEListType<Object: Hashable & Sendable>: Hashable, Sendable {
        var list: SGFValueEList

        public static func elist(of value: SGFValuePrimitiveType<Object>) -> SGFValueEListType<Object> {
            SGFValueEListType(list: SGFValueEList(compose: .single(value.type)))
        }
    }
    // MARK: - Compose

    public enum SGFCompose: Hashable, Sendable {
        case single(SGFValuePrimitiveValue)
        case compose(SGFValuePrimitiveValue, SGFValuePrimitiveValue)
    }

    public struct SGFValueComposedType<PrimitiveTypeA: Hashable & Sendable, PrimitiveTypeB: Hashable & Sendable>: Hashable, Sendable {
        var compose: SGFCompose

        static func single<V: Hashable & Sendable>(_ type: SGFValuePrimitiveType<V>) -> SGFValueComposedType<V, Never> {
            .init(compose: .single(type.type))
        }

        static func compose<ValueA: Hashable & Sendable, ValueB: Hashable & Sendable>(
            _ typeA: SGFValuePrimitiveType<ValueA>,
            _ typeB: SGFValuePrimitiveType<ValueB>
        ) -> SGFValueComposedType<ValueA, ValueB> {
            .init(compose: .compose(typeA.type, typeB.type))
        }

        public static var none: SGFValueComposedType<Never, Never> { .single(.none) }
        public static var number: SGFValueComposedType<Int, Never> { .single(.number) }
        public static var real: SGFValueComposedType<Double, Never> { .single(.real) }
        public static var double: SGFValueComposedType<SGFDouble, Never> { .single(.double) }
        public static var color: SGFValueComposedType<SGFColor, Never> { .single(.color) }
        public static var simpleText: SGFValueComposedType<String, Never> { .single(.simpleText) }
        public static var text: SGFValueComposedType<String, Never> { .single(.text) }
        public static var point: SGFValueComposedType<Game.Point, Never> { .single(.point) }
        public static var move: SGFValueComposedType<Game.Move, Never> { .single(.move) }
        public static var stone: SGFValueComposedType<Game.Stone, Never> { .single(.stone) }
    }

    // MARK: - Primitive

    public enum SGFValuePrimitiveValue: Hashable, Sendable {
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
        let type: SGFValuePrimitiveValue

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
