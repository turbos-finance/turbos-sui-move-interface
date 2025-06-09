// Copyright (c) Turbos Finance, Inc.
// SPDX-License-Identifier: MIT

module turbos_clmm::swap_router {
    use sui::tx_context::{TxContext};
    use turbos_clmm::pool::{Pool, Versioned};
	use sui::coin::{Coin};
    use sui::clock::{Clock};
    use turbos_clmm::partner::{Partner};

    public fun swap_a_b_with_return_<CoinTypeA, CoinTypeB, FeeType>(
        _pool: &mut Pool<CoinTypeA, CoinTypeB, FeeType>,
        _coins_a: vector<Coin<CoinTypeA>>, 
        _amount: u64,
        _amount_threshold: u64,
        _sqrt_price_limit: u128,
        _is_exact_in: bool,
        _recipient: address,
        _deadline: u64,
        _clock: &Clock,
        _versioned: &Versioned,
        _ctx: &mut TxContext
    ): (Coin<CoinTypeB>, Coin<CoinTypeA>) {
        abort 0
    }

    public entry fun swap_a_b<CoinTypeA, CoinTypeB, FeeType>(
		_pool: &mut Pool<CoinTypeA, CoinTypeB, FeeType>,
		_coins_a: vector<Coin<CoinTypeA>>, 
		_amount: u64,
        _amount_threshold: u64,
        _sqrt_price_limit: u128,
        _is_exact_in: bool,
        _recipient: address,
        _deadline: u64,
        _clock: &Clock,
        _versioned: &Versioned,
		_ctx: &mut TxContext
    ) {
        abort 0
    }

    public fun swap_b_a_with_return_<CoinTypeA, CoinTypeB, FeeType>(
        _pool: &mut Pool<CoinTypeA, CoinTypeB, FeeType>,
        _coins_b: vector<Coin<CoinTypeB>>, 
        _amount: u64,
        _amount_threshold: u64,
        _sqrt_price_limit: u128,
        _is_exact_in: bool,
        _recipient: address,
        _deadline: u64,
        _clock: &Clock,
        _versioned: &Versioned,
        _ctx: &mut TxContext
    ): (Coin<CoinTypeA>, Coin<CoinTypeB>) {
        abort 0
    }

    public entry fun swap_b_a<CoinTypeA, CoinTypeB, FeeType>(
		_pool: &mut Pool<CoinTypeA, CoinTypeB, FeeType>,
		_coins_b: vector<Coin<CoinTypeB>>, 
		_amount: u64,
        _amount_threshold: u64,
        _sqrt_price_limit: u128,
        _is_exact_in: bool,
        _recipient: address,
        _deadline: u64,
        _clock: &Clock,
        _versioned: &Versioned,
		_ctx: &mut TxContext
    ) {
        abort 0
    }

    public fun swap_a_b_b_c_with_return_<CoinTypeA, FeeTypeA, CoinTypeB, FeeTypeB, CoinTypeC>(
        _pool_a: &mut Pool<CoinTypeA, CoinTypeB, FeeTypeA>,
        _pool_b: &mut Pool<CoinTypeB, CoinTypeC, FeeTypeB>,
        _coins_a: vector<Coin<CoinTypeA>>, 
        _amount: u64,
        _amount_threshold: u64,
        _sqrt_price_limit_one: u128,
        _sqrt_price_limit_two: u128,
        _is_exact_in: bool,
        _recipient: address,
        _deadline: u64,
        _clock: &Clock,
        _versioned: &Versioned,
        _ctx: &mut TxContext
    ): (Coin<CoinTypeC>, Coin<CoinTypeA>) {
        abort 0
    }

    // such as: pool a: BTC/USDC, pool b: USDC/ETH
    // if swap BTC to ETH,route is BTC -> USDC -> ETH,fee paid in BTC and USDC 
    // step one: swap BTC to USDC (a to b), step two: swap USDC to ETH (a to b)
    public entry fun swap_a_b_b_c<CoinTypeA, FeeTypeA, CoinTypeB, FeeTypeB, CoinTypeC>(
		_pool_a: &mut Pool<CoinTypeA, CoinTypeB, FeeTypeA>,
        _pool_b: &mut Pool<CoinTypeB, CoinTypeC, FeeTypeB>,
		_coins_a: vector<Coin<CoinTypeA>>, 
		_amount: u64,
        _amount_threshold: u64,
        _sqrt_price_limit_one: u128,
        _sqrt_price_limit_two: u128,
        _is_exact_in: bool,
        _recipient: address,
        _deadline: u64,
        _clock: &Clock,
        _versioned: &Versioned,
		_ctx: &mut TxContext
    ) {
        abort 0
    }

    public fun swap_a_b_c_b_with_return_<CoinTypeA, FeeTypeA, CoinTypeB, FeeTypeB, CoinTypeC>(
        _pool_a: &mut Pool<CoinTypeA, CoinTypeB, FeeTypeA>,
        _pool_b: &mut Pool<CoinTypeC, CoinTypeB, FeeTypeB>,
        _coins_a: vector<Coin<CoinTypeA>>, 
        _amount: u64,
        _amount_threshold: u64,
        _sqrt_price_limit_one: u128,
        _sqrt_price_limit_two: u128,
        _is_exact_in: bool,
        _recipient: address,
        _deadline: u64,
        _clock: &Clock,
        _versioned: &Versioned,
        _ctx: &mut TxContext
    ): (Coin<CoinTypeC>, Coin<CoinTypeA>) {
        abort 0
    }

    // such as: pool a: BTC/USDC, pool b: ETH/USDC
    // if swap BTC to ETH, route is BTC -> USDC -> ETH,fee paid in BTC and USDC 
    // step one: swap BTC to USDC (a to b), step two: swap USDC to ETH (b to a)
    public entry fun swap_a_b_c_b<CoinTypeA, FeeTypeA, CoinTypeB, FeeTypeB, CoinTypeC>(
		_pool_a: &mut Pool<CoinTypeA, CoinTypeB, FeeTypeA>,
        _pool_b: &mut Pool<CoinTypeC, CoinTypeB, FeeTypeB>,
		_coins_a: vector<Coin<CoinTypeA>>, 
		_amount: u64,
        _amount_threshold: u64,
        _sqrt_price_limit_one: u128,
        _sqrt_price_limit_two: u128,
        _is_exact_in: bool,
        _recipient: address,
        _deadline: u64,
        _clock: &Clock,
        _versioned: &Versioned,
		_ctx: &mut TxContext
    ) {
        abort 0
    }

    public fun swap_b_a_b_c_with_return_<CoinTypeA, FeeTypeA, CoinTypeB, FeeTypeB, CoinTypeC>(
        _pool_a: &mut Pool<CoinTypeB, CoinTypeA, FeeTypeA>,
        _pool_b: &mut Pool<CoinTypeB, CoinTypeC, FeeTypeB>,
        _coins_a: vector<Coin<CoinTypeA>>, 
        _amount: u64,
        _amount_threshold: u64,
        _sqrt_price_limit_one: u128,
        _sqrt_price_limit_two: u128,
        _is_exact_in: bool,
        _recipient: address,
        _deadline: u64,
        _clock: &Clock,
        _versioned: &Versioned,
        _ctx: &mut TxContext
    ): (Coin<CoinTypeC>, Coin<CoinTypeA>) {
        abort 0
    }

    // such as: pool a: USDC/BTC, pool b: USDC/ETH
    // if swap BTC to ETH, route is BTC -> USDC -> ETH, fee paid in BTC and USDC 
    // step one: swap BTC to USDC (b to a), step two: swap USDC to ETH (a to b)
    public entry fun swap_b_a_b_c<CoinTypeA, FeeTypeA, CoinTypeB, FeeTypeB, CoinTypeC>(
		_pool_a: &mut Pool<CoinTypeB, CoinTypeA, FeeTypeA>,
        _pool_b: &mut Pool<CoinTypeB, CoinTypeC, FeeTypeB>,
		_coins_a: vector<Coin<CoinTypeA>>, 
		_amount: u64,
        _amount_threshold: u64,
        _sqrt_price_limit_one: u128,
        _sqrt_price_limit_two: u128,
        _is_exact_in: bool,
        _recipient: address,
        _deadline: u64,
        _clock: &Clock,
        _versioned: &Versioned,
		_ctx: &mut TxContext
    ) {
        abort 0
    }

    public fun swap_b_a_c_b_with_return_<CoinTypeA, FeeTypeA, CoinTypeB, FeeTypeB, CoinTypeC>(
        _pool_a: &mut Pool<CoinTypeB, CoinTypeA, FeeTypeA>,
        _pool_b: &mut Pool<CoinTypeC, CoinTypeB, FeeTypeB>,
        _coins_a: vector<Coin<CoinTypeA>>, 
        _amount: u64,
        _amount_threshold: u64,
        _sqrt_price_limit_one: u128,
        _sqrt_price_limit_two: u128,
        _is_exact_in: bool,
        _recipient: address,
        _deadline: u64,
        _clock: &Clock,
        _versioned: &Versioned,
        _ctx: &mut TxContext
    ): (Coin<CoinTypeC>, Coin<CoinTypeA>) {
        abort 0
    }

    // such as: pool a: USDC/BTC, pool b: ETH/USDC
    // if swap BTC to ETH, route is BTC -> USDC -> ETH, fee paid in BTC and USDC 
    // step one: swap BTC to USDC (b to a), step two: swap USDC to ETH (b to a)
    public entry fun swap_b_a_c_b<CoinTypeA, FeeTypeA, CoinTypeB, FeeTypeB, CoinTypeC>(
		_pool_a: &mut Pool<CoinTypeB, CoinTypeA, FeeTypeA>,
        _pool_b: &mut Pool<CoinTypeC, CoinTypeB, FeeTypeB>,
		_coins_a: vector<Coin<CoinTypeA>>, 
		_amount: u64,
        _amount_threshold: u64,
        _sqrt_price_limit_one: u128,
        _sqrt_price_limit_two: u128,
        _is_exact_in: bool,
        _recipient: address,
        _deadline: u64,
        _clock: &Clock,
        _versioned: &Versioned,
		_ctx: &mut TxContext
    ) {
        abort 0
    }

    public fun swap_with_partner<CoinTypeA, CoinTypeB, FeeType>(
        _pool: &mut Pool<CoinTypeA, CoinTypeB, FeeType>,
        _partner: &mut Partner,
        _coin_a: Coin<CoinTypeA>,
        _coin_b: Coin<CoinTypeB>,
        _a_to_b: bool,
        _amount: u64,
        _amount_threshold: u64,
        _sqrt_price_limit: u128,
        _is_exact_in: bool,
        _deadline: u64,
        _clock: &Clock,
        _versioned: &Versioned,
        _ctx: &mut TxContext
    ): (Coin<CoinTypeA>, Coin<CoinTypeB>) {
        abort 0
    }
    public fun swap_a_b_with_partner<CoinTypeA, CoinTypeB, FeeType>(
        _pool: &mut Pool<CoinTypeA, CoinTypeB, FeeType>,
        _partner: &mut Partner,
        _coin_a: Coin<CoinTypeA>,
        _amount: u64,
        _amount_threshold: u64,
        _sqrt_price_limit: u128,
        _is_exact_in: bool,
        _deadline: u64,
        _clock: &Clock,
        _versioned: &Versioned,
        _ctx: &mut TxContext
    ): (Coin<CoinTypeA>, Coin<CoinTypeB>) {
        abort 0
    }

    public fun swap_b_a_with_partner<CoinTypeA, CoinTypeB, FeeType>(
        _pool: &mut Pool<CoinTypeA, CoinTypeB, FeeType>,
        _partner: &mut Partner,
        _coin_b: Coin<CoinTypeB>,
        _amount: u64,
        _amount_threshold: u64,
        _sqrt_price_limit: u128,
        _is_exact_in: bool,
        _deadline: u64,
        _clock: &Clock,
        _versioned: &Versioned,
        _ctx: &mut TxContext
    ): (Coin<CoinTypeA>, Coin<CoinTypeB>) {
        abort 0
    }
}