// Copyright (c) Turbos Finance, Inc.
// SPDX-License-Identifier: MIT

module turbos_clmm::swap_router {
    use sui::tx_context::{TxContext};
    use turbos_clmm::pool::{Self, Pool, Versioned};
	use sui::coin::{Coin};
    use sui::clock::{Self, Clock};

    public entry fun swap_a_b<CoinTypeA, CoinTypeB, FeeType>(
		pool: &mut Pool<CoinTypeA, CoinTypeB, FeeType>,
		coins_a: vector<Coin<CoinTypeA>>, 
		amount: u64,
        amount_threshold: u64,
        sqrt_price_limit: u128,
        is_exact_in: bool,
        recipient: address,
        deadline: u64,
        clock: &Clock,
        versioned: &Versioned,
		ctx: &mut TxContext
    ) {
        abort 0
    }

    public entry fun swap_b_a<CoinTypeA, CoinTypeB, FeeType>(
		pool: &mut Pool<CoinTypeA, CoinTypeB, FeeType>,
		coins_b: vector<Coin<CoinTypeB>>, 
		amount: u64,
        amount_threshold: u64,
        sqrt_price_limit: u128,
        is_exact_in: bool,
        recipient: address,
        deadline: u64,
        clock: &Clock,
        versioned: &Versioned,
		ctx: &mut TxContext
    ) {
        abort 0
    }

    // such as: pool a: BTC/USDC, pool b: USDC/ETH
    // if swap BTC to ETH,route is BTC -> USDC -> ETH,fee paid in BTC and USDC 
    // step one: swap BTC to USDC (a to b), step two: swap USDC to ETH (a to b)
    public entry fun swap_a_b_b_c<CoinTypeA, FeeTypeA, CoinTypeB, FeeTypeB, CoinTypeC>(
		pool_a: &mut Pool<CoinTypeA, CoinTypeB, FeeTypeA>,
        pool_b: &mut Pool<CoinTypeB, CoinTypeC, FeeTypeB>,
		coins_a: vector<Coin<CoinTypeA>>, 
		amount: u64,
        amount_threshold: u64,
        sqrt_price_limit_one: u128,
        sqrt_price_limit_two: u128,
        is_exact_in: bool,
        recipient: address,
        deadline: u64,
        clock: &Clock,
        versioned: &Versioned,
		ctx: &mut TxContext
    ) {
        abort 0
    }

    // such as: pool a: BTC/USDC, pool b: ETH/USDC
    // if swap BTC to ETH, route is BTC -> USDC -> ETH,fee paid in BTC and USDC 
    // step one: swap BTC to USDC (a to b), step two: swap USDC to ETH (b to a)
    public entry fun swap_a_b_c_b<CoinTypeA, FeeTypeA, CoinTypeB, FeeTypeB, CoinTypeC>(
		pool_a: &mut Pool<CoinTypeA, CoinTypeB, FeeTypeA>,
        pool_b: &mut Pool<CoinTypeC, CoinTypeB, FeeTypeB>,
		coins_a: vector<Coin<CoinTypeA>>, 
		amount: u64,
        amount_threshold: u64,
        sqrt_price_limit_one: u128,
        sqrt_price_limit_two: u128,
        is_exact_in: bool,
        recipient: address,
        deadline: u64,
        clock: &Clock,
        versioned: &Versioned,
		ctx: &mut TxContext
    ) {
        abort 0
    }

    // such as: pool a: USDC/BTC, pool b: USDC/ETH
    // if swap BTC to ETH, route is BTC -> USDC -> ETH, fee paid in BTC and USDC 
    // step one: swap BTC to USDC (b to a), step two: swap USDC to ETH (a to b)
    public entry fun swap_b_a_b_c<CoinTypeA, FeeTypeA, CoinTypeB, FeeTypeB, CoinTypeC>(
		pool_a: &mut Pool<CoinTypeB, CoinTypeA, FeeTypeA>,
        pool_b: &mut Pool<CoinTypeB, CoinTypeC, FeeTypeB>,
		coins_a: vector<Coin<CoinTypeA>>, 
		amount: u64,
        amount_threshold: u64,
        sqrt_price_limit_one: u128,
        sqrt_price_limit_two: u128,
        is_exact_in: bool,
        recipient: address,
        deadline: u64,
        clock: &Clock,
        versioned: &Versioned,
		ctx: &mut TxContext
    ) {
        abort 0
    }

    // such as: pool a: USDC/BTC, pool b: ETH/USDC
    // if swap BTC to ETH, route is BTC -> USDC -> ETH, fee paid in BTC and USDC 
    // step one: swap BTC to USDC (b to a), step two: swap USDC to ETH (b to a)
    public entry fun swap_b_a_c_b<CoinTypeA, FeeTypeA, CoinTypeB, FeeTypeB, CoinTypeC>(
		pool_a: &mut Pool<CoinTypeB, CoinTypeA, FeeTypeA>,
        pool_b: &mut Pool<CoinTypeC, CoinTypeB, FeeTypeB>,
		coins_a: vector<Coin<CoinTypeA>>, 
		amount: u64,
        amount_threshold: u64,
        sqrt_price_limit_one: u128,
        sqrt_price_limit_two: u128,
        is_exact_in: bool,
        recipient: address,
        deadline: u64,
        clock: &Clock,
        versioned: &Versioned,
		ctx: &mut TxContext
    ) {
        abort 0
    }
}