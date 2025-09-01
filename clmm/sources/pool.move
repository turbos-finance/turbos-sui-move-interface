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
    use turbos_clmm::partner::{Partner};
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

    struct FlashSwapReceipt<phantom CoinTypeA, phantom CoinTypeB> {
        pool_id: ID,
        a_to_b: bool,
        pay_amount: u64,
    }

    struct FlashSwapReceiptPartner<phantom CoinTypeA, phantom CoinTypeB> {
        pool_id: ID,
        a_to_b: bool,
        pay_amount: u64,
        partner_id: ID,
        partner_fee_amount: u64,
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

    public fun version(_versioned: &Versioned): u64 {
       abort 0
    }

    public fun check_version(_versioned: &Versioned) {
        abort 0
    }

	public fun position_tick(_tick: I32): (I32, u8) {
		abort 0
    }

	public fun get_tick<CoinTypeA, CoinTypeB, FeeType>(
        _pool: &Pool<CoinTypeA, CoinTypeB, FeeType>,
        _index: I32
    ): &Tick {
        abort 0
	}

    public fun get_position<CoinTypeA, CoinTypeB, FeeType>(
        _pool: &Pool<CoinTypeA, CoinTypeB, FeeType>,
        _owner: address,
        _tick_lower_index: I32,
        _tick_upper_index: I32,
    ): &Position {
        abort 0
    }

    public fun check_position_exists<CoinTypeA, CoinTypeB, FeeType>(
        _pool: &Pool<CoinTypeA, CoinTypeB, FeeType>,
        _owner: address,
        _tick_lower_index: I32,
        _tick_upper_index: I32,
    ): bool {
        abort 0
    }

    public fun get_position_key(
        _owner: address,
        _tick_lower_index: I32,
        _tick_upper_index: I32,
    ): String {
        abort 0
    }

    public fun get_pool_fee<CoinTypeA, CoinTypeB, FeeType>(
        _pool: &Pool<CoinTypeA, CoinTypeB, FeeType>,
    ): u32 {
        abort 0
    }

    public fun get_pool_sqrt_price<CoinTypeA, CoinTypeB, FeeType>(
        _pool: &Pool<CoinTypeA, CoinTypeB, FeeType>,
    ): u128 {
        abort 0
    }

    public fun get_pool_tick_spacing<CoinTypeA, CoinTypeB, FeeType>(
        _pool: &Pool<CoinTypeA, CoinTypeB, FeeType>,
    ): u32 {
        abort 0
    }

    public fun get_pool_current_index<CoinTypeA, CoinTypeB, FeeType>(
        _pool: &Pool<CoinTypeA, CoinTypeB, FeeType>,
    ): I32 {
        abort 0
    }

     public fun get_pool_liquidity<CoinTypeA, CoinTypeB, FeeType>(
        _pool: &Pool<CoinTypeA, CoinTypeB, FeeType>,
    ): u128 {
        abort 0
    }

    public fun get_tick_liquidity_gross(
        _tick: &Tick,
    ): u128 {
        abort 0
    }

    public fun get_tick_liquidity_net(
        _tick: &Tick,
    ): I128 {
        abort 0
    }

    public fun get_tick_initialized(
        _tick: &Tick,
    ): bool {
        abort 0
    }

    public fun get_tick_fee_growth_outside(
        _tick: &Tick,
    ): (u128, u128) {
        abort 0
    }

    public fun get_tick_reward_growths_outside(
        _tick: &Tick,
    ): vector<u128> {
        abort 0
    }

    public fun get_pool_fee_growth_global<CoinTypeA, CoinTypeB, FeeType>(
        _pool: &Pool<CoinTypeA, CoinTypeB, FeeType>,
    ): (u128, u128) {
        abort 0
    }

    public fun get_pool_reward_last_updated_time_ms<CoinTypeA, CoinTypeB, FeeType>(
        _pool: &Pool<CoinTypeA, CoinTypeB, FeeType>,
    ): u64 {
        abort 0
    }

    public fun get_position_fee_growth_inside_a<CoinTypeA, CoinTypeB, FeeType>(
        _pool: &Pool<CoinTypeA, CoinTypeB, FeeType>,
        _key: String
    ): u128 {
        abort 0
    }

    // position.liquidity,
    // position.fee_growth_inside_a,
    // position.fee_growth_inside_b,
    // position.tokens_owed_a,
    // position.tokens_owed_b,
    // &position.reward_infos
    public fun get_position_base_info<CoinTypeA, CoinTypeB, FeeType>(
        _pool: &Pool<CoinTypeA, CoinTypeB, FeeType>,
        _key: String
    ): (u128, u128, u128, u64, u64, &vector<PositionRewardInfo>) {
        abort 0
    }

    public fun get_position_reward_infos<CoinTypeA, CoinTypeB, FeeType>(
        _pool: &Pool<CoinTypeA, CoinTypeB, FeeType>,
        _key: String
    ): &vector<PositionRewardInfo> {
        abort 0
    }

    public fun get_position_reward_info(
        _reawrd_info: &PositionRewardInfo
    ): (u128, u64) {
        abort 0
    }

    public fun get_position_fee_growth_inside_b<CoinTypeA, CoinTypeB, FeeType>(
        _pool: &Pool<CoinTypeA, CoinTypeB, FeeType>,
        _key: String
    ): u128 {
        abort 0
    }

    public fun get_pool_balance<CoinTypeA, CoinTypeB, FeeType>(
		_pool: &Pool<CoinTypeA, CoinTypeB, FeeType>, 
	): (u64, u64) {
        abort 0
    }

    public fun flash_swap<CoinTypeA, CoinTypeB, FeeType>(
        _pool: &mut Pool<CoinTypeA, CoinTypeB, FeeType>,
        _recipient: address,
        _a_to_b: bool,
        _amount_specified: u128,
        _amount_specified_is_input: bool,
        _sqrt_price_limit: u128,
        _clock: &Clock,
        _versioned: &Versioned,
        _ctx: &mut TxContext,
    ): (Coin<CoinTypeA>, Coin<CoinTypeB>, FlashSwapReceipt<CoinTypeA, CoinTypeB>) {
        abort 0
    }

    public fun flash_swap_partner<CoinTypeA, CoinTypeB, FeeType>(
        _pool: &mut Pool<CoinTypeA, CoinTypeB, FeeType>,
        _partner: &Partner,
        _a_to_b: bool,
        _amount_specified: u128,
        _amount_specified_is_input: bool,
        _sqrt_price_limit: u128,
        _clock: &Clock,
        _versioned: &Versioned,
        _ctx: &mut TxContext,
    ): (Coin<CoinTypeA>, Coin<CoinTypeB>, FlashSwapReceiptPartner<CoinTypeA, CoinTypeB>) {
        abort 0
    }

    public fun repay_flash_swap<CoinTypeA, CoinTypeB, FeeType>(
        _pool: &mut Pool<CoinTypeA, CoinTypeB, FeeType>,
        _coin_a: Coin<CoinTypeA>,
        _coin_b: Coin<CoinTypeB>,
        _receipt: FlashSwapReceipt<CoinTypeA, CoinTypeB>,
        _versioned: &Versioned
    ) {
        abort 0
    }

    public fun repay_flash_swap_partner<CoinTypeA, CoinTypeB, FeeType>(
        _pool: &mut Pool<CoinTypeA, CoinTypeB, FeeType>,
        _partner: &mut Partner,
        _coin_a: Coin<CoinTypeA>,
        _coin_b: Coin<CoinTypeB>,
        _receipt: FlashSwapReceiptPartner<CoinTypeA, CoinTypeB>,
        _versioned: &Versioned,
    ) {
        abort 0
    }

    public fun next_initialized_tick_within_one_word<CoinTypeA, CoinTypeB, FeeType>(
        _pool: &mut Pool<CoinTypeA, CoinTypeB, FeeType>,
        _tick_current_index: I32,
        _lte: bool
    ): (I32, bool) {
        abort 0
    }
}