public import Order
public import Property

extension Swift.Comparable where Self: Copyable {

    @_disfavoredOverload
    @inlinable
    public var order: Property<Order, Self> {
        Property(self)
    }
}
