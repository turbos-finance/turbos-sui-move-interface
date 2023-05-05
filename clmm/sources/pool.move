// Copyright (c) Turbos Finance, Inc.
// SPDX-License-Identifier: MIT

module turbos_clmm::pool {
	use std::vector;
    use std::type_name;
	use sui::pay;
    use sui::event;
    use sui::transfer;
    use std::string::{Self, String};
    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self, TxContext};
    use sui::dynamic_object_field as dof;
	use sui::dynamic_field as df;
    use sui::balance::{Self, Balance};
    use sui::coin::{Self, Coin};
	use turbos_clmm::math_tick;
	use turbos_clmm::math_swap;
    use turbos_clmm::string_tools;
	use turbos_clmm::i32::{Self, I32};
	use turbos_clmm::i128::{Self, I128};
	use turbos_clmm::math_liquidity;
	use turbos_clmm::math_sqrt_price;
    use turbos_clmm::math_u64;
    use turbos_clmm::full_math_u128;
    use turbos_clmm::math_u128;
	use turbos_clmm::math_bit;
    use sui::table::{Self, Table};
    use sui::clock::{Self, Clock};

    struct Versioned has key, store {
        id: UID,
        version: u64,
    }

	struct Tick has key, store {
		id: UID,
        liquidity_gross: u128,
        liquidity_net: I128,
        fee_growth_outside_a: u128,
		fee_growth_outside_b: u128,
        reward_growths_outside: vector<u128>,
        initialized: bool,
    }

    struct PositionRewardInfo has store {
        reward_growth_inside: u128,
        amount_owed: u64,
    }

    struct Position has key, store {
        id: UID,
		// the amount of liquidity owned by this position
        liquidity: u128,
		// fee growth per unit of liquidity as of the last update to liquidity or fees owed
        fee_growth_inside_a: u128,
        fee_growth_inside_b: u128,
		// the fees owed to the position owner in token0/token1
        tokens_owed_a: u64,
        tokens_owed_b: u64,
        reward_infos: vector<PositionRewardInfo>,
    }

    struct PoolRewardVault<phantom RewardCoin> has key, store {
        id: UID,
        coin: Balance<RewardCoin>,
    }
    
    struct PoolRewardInfo has key, store {
        id: UID,
        vault: address,
        vault_coin_type: String,
        emissions_per_second: u128,
        growth_global: u128,
        manager: address,
    }

    struct Pool<phantom CoinTypeA, phantom CoinTypeB, phantom FeeType> has key, store {
        id: UID,
        coin_a: Balance<CoinTypeA>,
        coin_b: Balance<CoinTypeB>,
        protocol_fees_a: u64,
        protocol_fees_b: u64,
        sqrt_price: u128,
        tick_current_index: I32,
        tick_spacing: u32,
        max_liquidity_per_tick: u128,
        fee: u32,
        fee_protocol: u32,
        unlocked: bool,
        fee_growth_global_a: u128,
        fee_growth_global_b: u128,
        liquidity: u128,
		tick_map: Table<I32, u256>,
        deploy_time_ms: u64,
        reward_infos: vector<PoolRewardInfo>,
        reward_last_updated_time_ms: u64,
    }

    struct ComputeSwapState has copy, drop {
        amount_a: u128,
        amount_b: u128, 
        amount_specified_remaining: u128,
        amount_calculated: u128,
        sqrt_price: u128,
        tick_current_index: I32,
        fee_growth_global: u128,
        protocol_fee: u128,
        liquidity: u128,
        fee_amount: u128,
    }

    public fun version(versioned: &Versioned): u64 {
       abort 0
    }

    public fun check_version(versioned: &Versioned) {
        abort 0
    }

	public fun position_tick(tick: I32): (I32, u8) {
		abort 0
    }

	public fun get_tick<CoinTypeA, CoinTypeB, FeeType>(
        pool: &Pool<CoinTypeA, CoinTypeB, FeeType>,
        index: I32
    ): &Tick {
        abort 0
	}

    public fun get_position<CoinTypeA, CoinTypeB, FeeType>(
        pool: &Pool<CoinTypeA, CoinTypeB, FeeType>,
        owner: address,
        tick_lower_index: I32,
        tick_upper_index: I32,
    ): &Position {
        abort 0
    }

    public fun get_position_key(
        owner: address,
        tick_lower_index: I32,
        tick_upper_index: I32,
    ): String {
        abort 0
    }

    public fun get_pool_fee<CoinTypeA, CoinTypeB, FeeType>(
        pool: &Pool<CoinTypeA, CoinTypeB, FeeType>,
    ): u32 {
        abort 0
    }

    public fun get_pool_sqrt_price<CoinTypeA, CoinTypeB, FeeType>(
        pool: &Pool<CoinTypeA, CoinTypeB, FeeType>,
    ): u128 {
        abort 0
    }

    public fun get_position_fee_growth_inside_a<CoinTypeA, CoinTypeB, FeeType>(
        pool: &Pool<CoinTypeA, CoinTypeB, FeeType>,
        key: String
    ): u128 {
        abort 0
    }

    public fun get_position_base_info<CoinTypeA, CoinTypeB, FeeType>(
        pool: &Pool<CoinTypeA, CoinTypeB, FeeType>,
        key: String
    ): (u128, u128, u128, u64, u64, &vector<PositionRewardInfo>) {
        abort 0
    }

    public fun get_position_reward_infos<CoinTypeA, CoinTypeB, FeeType>(
        pool: &Pool<CoinTypeA, CoinTypeB, FeeType>,
        key: String
    ): &vector<PositionRewardInfo> {
        abort 0
    }

    public fun get_position_reward_info(
        reawrd_info: &PositionRewardInfo
    ): (u128, u64) {
        abort 0
    }

    public fun get_position_fee_growth_inside_b<CoinTypeA, CoinTypeB, FeeType>(
        pool: &Pool<CoinTypeA, CoinTypeB, FeeType>,
        key: String
    ): u128 {
        abort 0
    }

    public fun get_pool_balance<CoinTypeA, CoinTypeB, FeeType>(
		pool: &Pool<CoinTypeA, CoinTypeB, FeeType>, 
	): (u64, u64) {
        abort 0
    }
}