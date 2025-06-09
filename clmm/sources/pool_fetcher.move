// Copyright (c) Turbos Finance, Inc.
// SPDX-License-Identifier: MIT

module turbos_clmm::pool_fetcher {
	use sui::tx_context::{Self, TxContext};
	use sui::clock::{Clock};
	use turbos_clmm::pool::{Self, Pool, ComputeSwapState, Versioned};

	public entry fun compute_swap_result<CoinTypeA, CoinTypeB, FeeType>(
        _pool: &mut Pool<CoinTypeA, CoinTypeB, FeeType>,
        _a_to_b: bool,
        _amount_specified: u128,
        _amount_specified_is_input: bool,
        _sqrt_price_limit: u128,
        _clock: &Clock,
		_versioned: &Versioned,
        _ctx: &mut TxContext,
    ): ComputeSwapState {
		abort 0
	}

    public entry fun fetch_ticks<CoinTypeA, CoinTypeB, FeeType>(
        _pool: &mut Pool<CoinTypeA, CoinTypeB, FeeType>,
        _start: vector<u32>,
        _start_index_is_neg: bool,
        _limit: u64,
        _versioned: &Versioned,
    ) {
        abort 0
    }
}