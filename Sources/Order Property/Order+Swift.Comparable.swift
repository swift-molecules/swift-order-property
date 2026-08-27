public import Order
internal import Property

extension Swift.Comparable where Self: Copyable {

    @_disfavoredOverload
    public var order: Property<Order, Self>.Inout {
        mutating _read {
            yield Property<Order, Self>.Inout(&self)
        }
    }
}
