public import Order
public import Property

extension Order {

    public protocol Orderable: ~Copyable {}
}

extension Order.Orderable where Self: ~Copyable {

    public var order: Property<Order, Self>.Inout {
        mutating _read {
            yield Property<Order, Self>.Inout(&self)
        }
    }
}
