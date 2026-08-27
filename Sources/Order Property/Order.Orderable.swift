public import Order
public import Property

extension Order {

    /// A value that opts into the fluent order-property surface.
    public protocol Orderable: ~Copyable {}
}

extension Order.Orderable where Self: Copyable {

    /// Copies the value into an order-tagged property wrapper.
    @inlinable
    public var order: Property<Order, Self> {
        Property(self)
    }
}

extension Order.Orderable where Self: ~Copyable {

    /// Consumes the value into an order-tagged property wrapper.
    @inlinable
    public consuming func ordered() -> Property<Order, Self> {
        Property(consume self)
    }
}
