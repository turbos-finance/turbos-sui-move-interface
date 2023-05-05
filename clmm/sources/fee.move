// Copyright (c) Turbos Finance, Inc.
// SPDX-License-Identifier: MIT

module turbos_clmm::fee {

	use sui::object::{Self, UID};
	use sui::tx_context::{TxContext};

	struct Fee<phantom T> has key, store {
        id: UID,
        fee: u32,
        tick_spacing: u32,
    }

	public fun get_fee<T>(self: &Fee<T>): u32 {
        abort 0
    }

    public fun get_tick_spacing<T>(self: &Fee<T>): u32 {
        abort 0
    }
}