module turbos_clmm::partner {
	use sui::object::{UID, ID};
    use sui::vec_map::{Self};
    use std::string::{String};
    use sui::bag::{Self};
    use sui::tx_context::{TxContext};

    friend turbos_clmm::pool_factory;

	struct PartnerAdminCap has key, store { 
		id: UID
	}

    struct Partners has key {
        id: UID,
        partners: vec_map::VecMap<String, ID>,
    }

    struct PartnerCap has store, key {
        id: UID,
        name: String,
        partner_id: ID,
    }

    struct Partner has store, key {
        id: UID,
        name: String,
        ref_fee_rate: u64,
        start_time: u64,
        end_time: u64,
        balances: bag::Bag,
    }

    public fun claim_ref_fee<CoinType>(_partner_cap: &PartnerCap, _partner: &mut Partner, _ctx: &mut TxContext) {
       abort 0
    }

    public fun balances(_partner: &Partner) : &bag::Bag {
       abort 0
    }

    public fun current_ref_fee_rate(_partner: &Partner, _current_time: u64) : u64 {
        abort 0
    }

    public fun end_time(_partner: &Partner) : u64 {
        abort 0
    }

    public fun name(_partner: &Partner) : String {
        abort 0
    }

    public fun ref_fee_rate(_partner: &Partner) : u64 {
        abort 0
    }

    public fun start_time(_partner: &Partner) : u64 {
        abort 0
    }
}