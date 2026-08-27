import Testing

import Comparison
import Order
import Order_Comparison

@testable import Order_Property

@Suite
struct `Order Property Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
    @Suite(.serialized) struct Performance {}
}

extension `Order Property Tests`.Unit {
    @Suite struct `Copyable Types` {}
    @Suite struct `Noncopyable Types` {}
    @Suite struct `Comparison.Protocol Convenience` {}
    @Suite struct `Descending Order` {}
    @Suite struct `Orderable Protocol` {}
    @Suite struct `Standard Type Conformances` {}
    @Suite struct `Swift.Comparable Convenience` {}
}

private struct Person: Order.Orderable {
    let name: String
    let age: Int
}

private struct Token: ~Copyable, Order.Orderable, Comparison.`Protocol` {
    let id: Int
}

extension Token {
    static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.id < rhs.id
    }

    static func == (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.id == rhs.id
    }
}

extension `Order Property Tests`.Unit.`Copyable Types` {
    @Test
    func `isBefore with explicit comparator`() {
        var alice = Person(name: "Alice", age: 30)
        var bob = Person(name: "Bob", age: 25)

        let byAge = Order.Comparator<Person> { lhs, rhs in
            Comparison(lhs.age, rhs.age)
        }

        #expect(alice.order.isBefore(bob, by: byAge) == false)
        #expect(bob.order.isBefore(alice, by: byAge) == true)
    }

    @Test
    func `isAfter with explicit comparator`() {
        var alice = Person(name: "Alice", age: 30)
        var bob = Person(name: "Bob", age: 25)

        let byAge = Order.Comparator<Person> { lhs, rhs in
            Comparison(lhs.age, rhs.age)
        }

        #expect(alice.order.isAfter(bob, by: byAge) == true)
        #expect(bob.order.isAfter(alice, by: byAge) == false)
    }

    @Test
    func `isEquivalent with explicit comparator`() {
        var alice = Person(name: "Alice", age: 30)
        let carol = Person(name: "Carol", age: 30)
        let bob = Person(name: "Bob", age: 25)

        let byAge = Order.Comparator<Person> { lhs, rhs in
            Comparison(lhs.age, rhs.age)
        }

        #expect(alice.order.isEquivalent(to: carol, by: byAge) == true)
        #expect(alice.order.isEquivalent(to: bob, by: byAge) == false)
    }

    @Test
    func `Multiple comparators on same type`() {
        var alice = Person(name: "Alice", age: 30)
        let bob = Person(name: "Bob", age: 25)

        let byAge = Order.Comparator<Person> { lhs, rhs in
            Comparison(lhs.age, rhs.age)
        }
        let byName = Order.Comparator<Person> { lhs, rhs in
            Comparison(lhs.name, rhs.name)
        }

        #expect(alice.order.isAfter(bob, by: byAge) == true)

        #expect(alice.order.isBefore(bob, by: byName) == true)
    }
}

extension `Order Property Tests`.Unit.`Noncopyable Types` {
    @Test
    func `isBefore with explicit comparator`() {
        let comparator: Order.Comparator<Token> = .ascending

        #expect(Token(id: 5).ordered().isBefore(Token(id: 10), by: comparator) == true)
        #expect(Token(id: 10).ordered().isBefore(Token(id: 5), by: comparator) == false)
    }

    @Test
    func `isAfter with explicit comparator`() {
        let comparator: Order.Comparator<Token> = .ascending

        #expect(Token(id: 5).ordered().isAfter(Token(id: 10), by: comparator) == false)
        #expect(Token(id: 10).ordered().isAfter(Token(id: 5), by: comparator) == true)
    }

    @Test
    func `isEquivalent with explicit comparator`() {
        let comparator: Order.Comparator<Token> = .ascending

        #expect(Token(id: 5).ordered().isEquivalent(to: Token(id: 5), by: comparator) == true)
        #expect(Token(id: 5).ordered().isEquivalent(to: Token(id: 10), by: comparator) == false)
    }
}

extension `Order Property Tests`.Unit.`Comparison.Protocol Convenience` {
    @Test
    func `isBefore without explicit comparator`() {
        #expect(Token(id: 5).ordered().isBefore(Token(id: 10)) == true)
        #expect(Token(id: 10).ordered().isBefore(Token(id: 5)) == false)
    }

    @Test
    func `isAfter without explicit comparator`() {
        #expect(Token(id: 5).ordered().isAfter(Token(id: 10)) == false)
        #expect(Token(id: 10).ordered().isAfter(Token(id: 5)) == true)
    }

    @Test
    func `isEquivalent without explicit comparator`() {
        #expect(Token(id: 5).ordered().isEquivalent(to: Token(id: 5)) == true)
        #expect(Token(id: 5).ordered().isEquivalent(to: Token(id: 10)) == false)
    }
}

extension `Order Property Tests`.Unit.`Descending Order` {
    @Test
    func `isBefore with descending comparator`() {
        let descending: Order.Comparator<Token> = .descending

        #expect(Token(id: 5).ordered().isBefore(Token(id: 10), by: descending) == false)
        #expect(Token(id: 10).ordered().isBefore(Token(id: 5), by: descending) == true)
    }

    @Test
    func `isAfter with descending comparator`() {
        let descending: Order.Comparator<Token> = .descending

        #expect(Token(id: 5).ordered().isAfter(Token(id: 10), by: descending) == true)
        #expect(Token(id: 10).ordered().isAfter(Token(id: 5), by: descending) == false)
    }
}

extension `Order Property Tests`.Unit.`Orderable Protocol` {
    @Test
    func `Type conforming to Orderable gets .order property`() {
        struct Sample: Order.Orderable {
            let x: Int
        }

        var value = Sample(x: 10)
        let other = Sample(x: 5)

        let comparator = Order.Comparator<Sample> { lhs, rhs in
            Comparison(lhs.x, rhs.x)
        }

        #expect(value.order.isAfter(other, by: comparator) == true)
    }

    @Test
    func `~Copyable type can conform to Orderable`() {
        struct Resource: ~Copyable, Order.Orderable {
            let priority: Int
        }

        var high = Resource(priority: 10)
        let low = Resource(priority: 1)

        let byPriority = Order.Comparator<Resource> { lhs, rhs in
            Comparison(lhs.priority, rhs.priority)
        }

        #expect(high.ordered().isAfter(low, by: byPriority) == true)
    }
}

extension `Order Property Tests`.Unit.`Standard Type Conformances` {
    @Test
    func `Int has .order property`() {
        var a = 5
        let b = 10

        #expect(a.order.isBefore(b) == true)
        #expect(a.order.isAfter(b) == false)
    }

    @Test
    func `String has .order property with explicit comparator`() {
        var apple = "apple"
        let banana = "banana"

        let comparator: Order.Comparator<String> = .ascending

        #expect(apple.order.isBefore(banana, by: comparator) == true)
        #expect(apple.order.isAfter(banana, by: comparator) == false)
    }

    @Test
    func `Double has .order property with explicit comparator`() {
        var a = 1.5
        let b = 2.5

        let comparator: Order.Comparator<Double> = .ascending

        #expect(a.order.isBefore(b, by: comparator) == true)
        #expect(a.order.isAfter(b, by: comparator) == false)
    }

    @Test
    func `UInt8 has .order property with convenience methods`() {
        var a: UInt8 = 100
        let b: UInt8 = 200

        #expect(a.order.isBefore(b) == true)
        #expect(a.order.isEquivalent(to: a) == true)
    }
}

extension `Order Property Tests`.Unit.`Swift.Comparable Convenience` {
    @Test
    func `String has convenience methods without explicit comparator`() {
        var apple = "apple"
        let banana = "banana"

        #expect(apple.order.isBefore(banana) == true)
        #expect(apple.order.isAfter(banana) == false)
        #expect(apple.order.isEquivalent(to: "apple") == true)
    }

    @Test
    func `Double has convenience methods without explicit comparator`() {
        var a = 1.5
        let b = 2.5

        #expect(a.order.isBefore(b) == true)
        #expect(a.order.isAfter(b) == false)
        #expect(a.order.isEquivalent(to: 1.5) == true)
    }

    @Test
    func `Float has convenience methods`() {
        var a: Float = 3.14
        let b: Float = 2.71

        #expect(a.order.isBefore(b) == false)
        #expect(a.order.isAfter(b) == true)
    }

    @Test
    func `Character has convenience methods`() {
        var a: Character = "a"
        let z: Character = "z"

        #expect(a.order.isBefore(z) == true)
        #expect(a.order.isAfter(z) == false)
    }
}
