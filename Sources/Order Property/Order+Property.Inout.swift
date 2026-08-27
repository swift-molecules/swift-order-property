public import Comparison
public import Order
public import Order_Comparison
internal import Property

extension Property.Inout where Tag == Order, Base: ~Copyable {

    @inlinable
    public func isBefore(
        _ other: borrowing Base,
        by comparator: Order.Comparator<Base>
    ) -> Bool {
        comparator(base.value, other).isLess
    }

    @inlinable
    public func isAfter(
        _ other: borrowing Base,
        by comparator: Order.Comparator<Base>
    ) -> Bool {
        comparator(base.value, other).isGreater
    }

    @inlinable
    public func isEquivalent(
        to other: borrowing Base,
        by comparator: Order.Comparator<Base>
    ) -> Bool {
        comparator(base.value, other).isEqual
    }
}

extension Property.Inout
where Tag == Order, Base: Comparison.`Protocol` & SendableMetatype & ~Copyable {

    @inlinable
    public func isBefore(_ other: borrowing Base) -> Bool {
        isBefore(other, by: .ascending)
    }

    @inlinable
    public func isAfter(_ other: borrowing Base) -> Bool {
        isAfter(other, by: .ascending)
    }

    @inlinable
    public func isEquivalent(to other: borrowing Base) -> Bool {
        isEquivalent(to: other, by: .ascending)
    }
}
