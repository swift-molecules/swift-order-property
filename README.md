# Order Property

Integration of the `Order` domain with `Property`: `Order.Orderable`, the
`.order` fluent accessor, and the `Property<Order, Base>` predicates
`isBefore`, `isAfter`, and `isEquivalent`. Copyable values enter the fluent
surface through `.order`; a noncopyable `Orderable` value is consumed through
`ordered()` to make its ownership transition explicit.
