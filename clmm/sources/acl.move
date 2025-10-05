module turbos_clmm::acl {

    use sui::linked_table::{LinkedTable};
    use sui::object::{UID};

    struct ACL has key, store {
        id: UID,
        permissions: LinkedTable<address, u128>,
    }

    struct Member has store, drop, copy {
        address: address,
        permission: u128,
    }
}
