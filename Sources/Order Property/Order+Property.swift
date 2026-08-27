public import Comparison
public import Order
public import Order_Comparison
public import Property

extension Property where Tag == Order, Base: ~Copyable {

    /// Returns whether the wrapped value precedes `other` under `comparator`.
    @inlinable
    public func isBefore(
        _ other: borrowing Base,
        by comparator: Order.Comparator<Base>
    ) -> Bool {
        comparator(base, other).isLess
    }

    /// Returns whether the wrapped value follows `other` under `comparator`.
    @inlinable
    public func isAfter(
        _ other: borrowing Base,
        by comparator: Order.Comparator<Base>
    ) -> Bool {
        comparator(base, other).isGreater
    }

    /// Returns whether the wrapped value and `other` are equivalent under
    /// `comparator`.
    @inlinable
    public func isEquivalent(
        to other: borrowing Base,
        by comparator: Order.Comparator<Base>
    ) -> Bool {
        comparator(base, other).isEqual
    }
}

extension Property
where Tag == Order, Base: Comparison.`Protocol` & SendableMetatype & ~Copyable {

    /// Returns whether the wrapped value precedes `other` in ascending order.
    @inlinable
    public func isBefore(_ other: borrowing Base) -> Bool {
        isBefore(other, by: .ascending)
    }

    /// Returns whether the wrapped value follows `other` in ascending order.
    @inlinable
    public func isAfter(_ other: borrowing Base) -> Bool {
        isAfter(other, by: .ascending)
    }

    /// Returns whether the wrapped value equals `other` in ascending order.
    @inlinable
    public func isEquivalent(to other: borrowing Base) -> Bool {
        isEquivalent(to: other, by: .ascending)
    }
}
