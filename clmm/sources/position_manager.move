// Copyright (c) Turbos Finance, Inc.
// SPDX-License-Identifier: MIT

module turbos_clmm::position_manager {
	use std::vector;
    use std::type_name::{Self};
    use sui::transfer;
    use sui::event;
    use std::string::{Self, String};
    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self, TxContext};
    use sui::dynamic_object_field as dof;
	use sui::coin::{Coin};
    use sui::table::{Self, Table};
    use turbos_clmm::i32::{Self, I32};
    use turbos_clmm::math_liquidity;
    use turbos_clmm::math_tick;
    use turbos_clmm::pool::{Self, Pool, PositionRewardInfo as PositionRewardInfoInPool, PoolRewardVault, Versioned};
    use turbos_clmm::position_nft::{Self, TurbosPositionNFT};
    use sui::clock::{Self, Clock};
    
    struct PositionRewardInfo has store {
        reward_growth_inside: u128,
        amount_owed: u64,
    }

	struct Position has key, store {
        id: UID,
        tick_lower_index: I32,
        tick_upper_index: I32,
        liquidity: u128,
        fee_growth_inside_a: u128,
        fee_growth_inside_b: u128,
        tokens_owed_a: u64,
        tokens_owed_b: u64,
        reward_infos: vector<PositionRewardInfo>,
    }

	struct Positions has key, store {
        id: UID,
		nft_minted: u64,
        user_position: Table<address, ID>,
        nft_name: String,
        nft_description: String,
        nft_img_url: String,
    }

    public fun mint_with_return_<CoinTypeA, CoinTypeB, FeeType>(
        pool: &mut Pool<CoinTypeA, CoinTypeB, FeeType>,
        positions: &mut Positions,
        coins_a: vector<Coin<CoinTypeA>>, 
        coins_b: vector<Coin<CoinTypeB>>, 
        tick_lower_index: u32,
        tick_lower_index_is_neg: bool,
        tick_upper_index: u32,
        tick_upper_index_is_neg: bool,
        amount_a_desired: u64,
        amount_b_desired: u64,
        amount_a_min: u64,
        amount_b_min: u64,
        deadline: u64,
        clock: &Clock,
        versioned: &Versioned,
        ctx: &mut TxContext
    ): (TurbosPositionNFT, Coin<CoinTypeA>, Coin<CoinTypeB>) {
        abort 0
    }

    public fun increase_liquidity_with_return_<CoinTypeA, CoinTypeB, FeeType>(
        pool: &mut Pool<CoinTypeA, CoinTypeB, FeeType>,
        positions: &mut Positions,
        coins_a: vector<Coin<CoinTypeA>>, 
        coins_b: vector<Coin<CoinTypeB>>, 
        nft: &mut TurbosPositionNFT,
        amount_a_desired: u64,
        amount_b_desired: u64,
        amount_a_min: u64,
        amount_b_min: u64,
        deadline: u64,
        clock: &Clock,
        versioned: &Versioned,
        ctx: &mut TxContext
    ): (Coin<CoinTypeA>, Coin<CoinTypeB>) {
        abort 0
    }

    public fun decrease_liquidity_with_return_<CoinTypeA, CoinTypeB, FeeType>(
        pool: &mut Pool<CoinTypeA, CoinTypeB, FeeType>,
        positions: &mut Positions,
        nft: &mut TurbosPositionNFT,
        liquidity: u128,
        amount_a_min: u64,
        amount_b_min: u64,
        deadline: u64,
        clock: &Clock,
        versioned: &Versioned,
        ctx: &mut TxContext
    ): (Coin<CoinTypeA>, Coin<CoinTypeB>) {
        abort 0
    }

    public entry fun mint<CoinTypeA, CoinTypeB, FeeType>(
		pool: &mut Pool<CoinTypeA, CoinTypeB, FeeType>,
		positions: &mut Positions,
		coins_a: vector<Coin<CoinTypeA>>, 
		coins_b: vector<Coin<CoinTypeB>>, 
		tick_lower_index: u32,
		tick_lower_index_is_neg: bool,
        tick_upper_index: u32,
		tick_upper_index_is_neg: bool,
		amount_a_desired: u64,
        amount_b_desired: u64,
        amount_a_min: u64,
        amount_b_min: u64,
        recipient: address,
        deadline: u64,
        clock: &Clock,
        versioned: &Versioned,
		ctx: &mut TxContext
    ) {
        abort 0
    }

    public entry fun burn<CoinTypeA, CoinTypeB, FeeType>(
        positions: &mut Positions,
        nft: TurbosPositionNFT,
        versioned: &Versioned,
        _ctx: &mut TxContext
    ) {
        abort 0
    }

    public entry fun increase_liquidity<CoinTypeA, CoinTypeB, FeeType>(
		pool: &mut Pool<CoinTypeA, CoinTypeB, FeeType>,
		positions: &mut Positions,
		coins_a: vector<Coin<CoinTypeA>>, 
		coins_b: vector<Coin<CoinTypeB>>, 
		nft: &mut TurbosPositionNFT,
		amount_a_desired: u64,
        amount_b_desired: u64,
        amount_a_min: u64,
        amount_b_min: u64,
        deadline: u64,
        clock: &Clock,
        versioned: &Versioned,
		ctx: &mut TxContext
    ) {
        abort 0
    }

    public entry fun decrease_liquidity<CoinTypeA, CoinTypeB, FeeType>(
		pool: &mut Pool<CoinTypeA, CoinTypeB, FeeType>,
		positions: &mut Positions,
		nft: &mut TurbosPositionNFT,
		liquidity: u128,
        amount_a_min: u64,
        amount_b_min: u64,
        deadline: u64,
        clock: &Clock,
        versioned: &Versioned,
		ctx: &mut TxContext
    ) {
        abort 0
    }

    public fun collect_with_return_<CoinTypeA, CoinTypeB, FeeType>(
        pool: &mut Pool<CoinTypeA, CoinTypeB, FeeType>,
        positions: &mut Positions,
        nft: &mut TurbosPositionNFT,
        amount_a_max: u64,
        amount_b_max: u64,
        recipient: address,
        deadline: u64,
        clock: &Clock,
        versioned: &Versioned,
        ctx: &mut TxContext
    ): (Coin<CoinTypeA>, Coin<CoinTypeB>) {
        abort 0
    }

    public entry fun collect<CoinTypeA, CoinTypeB, FeeType>(
		pool: &mut Pool<CoinTypeA, CoinTypeB, FeeType>,
		positions: &mut Positions,
		nft: &mut TurbosPositionNFT,
        amount_a_max: u64,
        amount_b_max: u64,
        recipient: address,
        deadline: u64,
        clock: &Clock,
        versioned: &Versioned,
		ctx: &mut TxContext
    ) {
        abort 0
    }

    public fun collect_reward_with_return_<CoinTypeA, CoinTypeB, FeeType, RewardCoin>(
        pool: &mut Pool<CoinTypeA, CoinTypeB, FeeType>,
        positions: &mut Positions,
        nft: &mut TurbosPositionNFT,
        vault: &mut PoolRewardVault<RewardCoin>,
        reward_index: u64,
        amount_max: u64,
        recipient: address,
        deadline: u64,
        clock: &Clock,
        versioned: &Versioned,
        ctx: &mut TxContext
    ): Coin<RewardCoin> {
        abort 0
    }

    public entry fun collect_reward<CoinTypeA, CoinTypeB, FeeType, RewardCoin>(
		pool: &mut Pool<CoinTypeA, CoinTypeB, FeeType>,
		positions: &mut Positions,
		nft: &mut TurbosPositionNFT,
        vault: &mut PoolRewardVault<RewardCoin>,
        reward_index: u64,
        amount_max: u64,
        recipient: address,
        deadline: u64,
        clock: &Clock,
        versioned: &Versioned,
		ctx: &mut TxContext
    ) {
        abort 0
    }

    public fun get_position_info(
        positions: &Positions,
        nft_address: address,
    ): (I32, I32, u128) {
        abort 0
    }
}