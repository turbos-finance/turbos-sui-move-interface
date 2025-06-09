// Copyright (c) Turbos Finance, Inc.
// SPDX-License-Identifier: MIT

module turbos_clmm::pool_factory {
	use std::type_name::{TypeName};
    use sui::vec_map::{VecMap};
    use sui::object::{UID, ID};
    use sui::tx_context::{TxContext};
	use sui::coin::{Coin};
	use turbos_clmm::position_manager::{Positions};
	use turbos_clmm::position_nft::{TurbosPositionNFT};
    use turbos_clmm::fee::{Fee};
	use sui::clock::{Clock};
	use turbos_clmm::pool::{Versioned};
	use std::string::{String};
	use sui::table::{Table};
	use std::option::{Option};
    
	struct PoolFactoryAdminCap has key, store { id: UID }

	struct PoolSimpleInfo has copy, store {
        pool_id: ID,
		pool_key: ID,
        coin_type_a: TypeName,
		coin_type_b: TypeName,
		fee_type: TypeName,
		fee: u32,
        tick_spacing: u32,
    }

    struct PoolConfig has key, store {
        id: UID,
        fee_map: VecMap<String, ID>,
		fee_protocol: u32,
		pools: Table<ID, PoolSimpleInfo>,
    }

	public entry fun deploy_pool_and_mint<CoinTypeA, CoinTypeB, FeeType>(
		_pool_config: &mut PoolConfig,
		_feeType: &Fee<FeeType>,
		_sqrt_price: u128,
		_positions: &mut Positions,
		_coins_a: vector<Coin<CoinTypeA>>,
		_coins_b: vector<Coin<CoinTypeB>>,
		_tick_lower_index: u32,
		_tick_lower_index_is_neg: bool,
        _tick_upper_index: u32,
		_tick_upper_index_is_neg: bool,
		_amount_a_desired: u64,
        _amount_b_desired: u64,
        _amount_a_min: u64,
        _amount_b_min: u64,
        _recipient: address,
        _deadline: u64,
		_clock: &Clock,
		_versioned: &Versioned,
		_ctx: &mut TxContext
    ) {
		abort 0
    }

	public fun deploy_pool_and_mint_with_return_<CoinTypeA, CoinTypeB, FeeType>(
        _pool_config: &mut PoolConfig,
        _feeType: &Fee<FeeType>,
        _sqrt_price: u128,
        _positions: &mut Positions,
        _coins_a: vector<Coin<CoinTypeA>>,
        _coins_b: vector<Coin<CoinTypeB>>,
        _tick_lower_index: u32,
        _tick_lower_index_is_neg: bool,
        _tick_upper_index: u32,
        _tick_upper_index_is_neg: bool,
        _amount_a_desired: u64,
        _amount_b_desired: u64,
        _amount_a_min: u64,
        _amount_b_min: u64,
        _deadline: u64,
        _clock: &Clock,
        _versioned: &Versioned,
        _ctx: &mut TxContext
    ): (TurbosPositionNFT, Coin<CoinTypeA>, Coin<CoinTypeB>, ID) {
		abort 0
	}

    public entry fun deploy_pool<CoinTypeA, CoinTypeB, FeeType>(
		_pool_config: &mut PoolConfig,
		_feeType: &Fee<FeeType>,
		_sqrt_price: u128,
		_clock: &Clock,
		_versioned: &Versioned,
		_ctx: &mut TxContext
    ) {
		abort 0
    }

	public fun get_pool_id<CoinTypeA, CoinTypeB, FeeType>(
        _pool_config: &mut PoolConfig,
    ): Option<ID> {
        abort 0
    }
}