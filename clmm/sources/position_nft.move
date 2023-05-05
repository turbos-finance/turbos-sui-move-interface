// Copyright (c) Turbos Finance, Inc.
// SPDX-License-Identifier: MIT

module turbos_clmm::position_nft {
    use std::vector;
    use sui::transfer;
    use sui::url::{Self, Url};
    use std::string::{Self, utf8, String};
    use sui::object::{Self, ID, UID};
    use sui::event;
    use sui::display;
    use sui::package;
    use sui::tx_context::{Self, TxContext};
    use std::type_name::{TypeName};

    struct TurbosPositionNFT has key, store {
        id: UID,
        name: String,
        description: String,
        img_url: Url,
        pool_id: ID,
        position_id: ID,
        coin_type_a: TypeName,
        coin_type_b: TypeName,
        fee_type: TypeName,
    }

    public fun pool_id(nft: &TurbosPositionNFT): ID {
        abort 0
    }

    public fun position_id(nft: &TurbosPositionNFT): ID {
        abort 0
    }

}