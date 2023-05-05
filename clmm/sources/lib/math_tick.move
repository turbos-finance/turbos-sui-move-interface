// Copyright (c) Turbos Finance, Inc.
// SPDX-License-Identifier: MIT

module turbos_clmm::math_tick {
    use turbos_clmm::i32::{Self, I32};
    use turbos_clmm::i128;
    use turbos_clmm::math_u128;
    use turbos_clmm::full_math_u128;

    const MAX_U64: u64 = 0xffffffffffffffff;
    const MAX_U128: u128 = 0xffffffffffffffffffffffffffffffff;
    const MAX_TICK_INDEX: u32 = 443636;
    const MAX_SQRT_PRICE_X64: u128 = 79226673515401279992447579055;
    const MIN_SQRT_PRICE_X64: u128 = 4295048016;
    const BIT_PRECISION: u32 = 14;
    const LOG_B_2_X32: u128 = 59543866431248;
    const LOG_B_P_ERR_MARGIN_LOWER_X64: u128 = 184467440737095516; // 0.01
    const LOG_B_P_ERR_MARGIN_UPPER_X64: u128 = 15793534762490258745; // 2^-precision / log_2_b + 0.01

    public fun get_min_tick(tick_sacing: u32): I32 {
		i32::neg_from(MAX_TICK_INDEX / tick_sacing * tick_sacing)
    }

	public fun get_max_tick(tick_sacing: u32): I32 {
		i32::from(MAX_TICK_INDEX / tick_sacing * tick_sacing)
    }

    public fun max_liquidity_per_tick(tick_spacing: u32): u128 {
        let min_tick_index = get_min_tick(tick_spacing);
        let max_tick_index = get_max_tick(tick_spacing);
		let num_ticks = i32::abs_u32(
                i32::div(
                    i32::sub(max_tick_index, min_tick_index),
                    i32::from(tick_spacing)
                )
            ) + 1;
		let liquidity = MAX_U128 / (num_ticks as u128);

        liquidity
    }

    public fun tick_index_from_sqrt_price(sqrt_price_x64: u128): i32::I32 {
        let msb: u8 = 128 - math_u128::leading_zeros(sqrt_price_x64) - 1;
        let log2p_integer_x32: i128::I128 = i128::shl(i128::sub(i128::from((msb as u128)), i128::from(64)), 32u8);

        let bit: i128::I128 = i128::from(0x8000_0000_0000_0000);
        let precision = 0;
        let log2p_fraction_x64: i128::I128 = i128::zero();
        let r: u128 = if (msb >= 64) sqrt_price_x64 >> (msb - 63) else sqrt_price_x64 << (63 - msb);

        while (i128::gt(bit, i128::zero()) && precision < BIT_PRECISION) {
            r = r * r;
            let is_r_more_than_two = (r >> 127 as u32);
            r = r >> (63 + is_r_more_than_two as u8);
            log2p_fraction_x64 = i128::add(log2p_fraction_x64, i128::mul(bit, i128::from((is_r_more_than_two as u128))));
            bit = i128::shr(bit, 1u8);
            precision = precision + 1;
        };

        let log2p_fraction_x32 = i128::shr(log2p_fraction_x64, 32u8);
        let log2p_x32: i128::I128 = i128::add(log2p_integer_x32, log2p_fraction_x32);

        // Transform from base 2 to base b
        let logbp_x64: i128::I128 = i128::mul(log2p_x32, i128::from(LOG_B_2_X32));

        let tick_low: i32::I32 = i128::as_i32(i128::shr(i128::sub(logbp_x64, i128::from(LOG_B_P_ERR_MARGIN_LOWER_X64)), 64u8));
        let tick_high: i32::I32 = i128::as_i32(i128::shr(i128::add(logbp_x64, i128::from(LOG_B_P_ERR_MARGIN_UPPER_X64)), 64u8));

        let result_tick;
        if (i32::eq(tick_low, tick_high)) {
            result_tick = tick_low;
        } else {
            let actual_tick_high_sqrt_price_x64 = sqrt_price_from_tick_index(tick_high);
            if (actual_tick_high_sqrt_price_x64 <= sqrt_price_x64) {
                result_tick = tick_high
            } else {
                result_tick = tick_low
            };
        };

        result_tick
    }

    public fun sqrt_price_from_tick_index(tick: i32::I32) : u128 {
        let sqrt_price;
        if (i32::gte(tick, i32::zero())) {
            sqrt_price = get_sqrt_price_positive_tick(tick)
        } else {
            sqrt_price = get_sqrt_price_negative_tick(tick)
        };
        
        sqrt_price
    }

    // Performs the exponential conversion with Q64.64 precision
    public fun get_sqrt_price_positive_tick(tick: i32::I32) : u128 {
        let ratio: u128;
        if (!i32::eq(i32::and(tick, i32::from(1u32)), i32::zero())) {
            ratio = 79232123823359799118286999567
        } else {
            ratio = 79228162514264337593543950336
        };
        if (!i32::eq(i32::and(tick, i32::from(2u32)), i32::zero())) {
            ratio = full_math_u128::mul_shr(ratio, 79236085330515764027303304731, 96u8);
        };
        if (!i32::eq(i32::and(tick, i32::from(4u32)), i32::zero())) {
            ratio = full_math_u128::mul_shr(ratio, 79244008939048815603706035061, 96u8);
        };
        if (!i32::eq(i32::and(tick, i32::from(8u32)), i32::zero())) {
            ratio = full_math_u128::mul_shr(ratio, 79259858533276714757314932305, 96u8);
        };
        if (!i32::eq(i32::and(tick, i32::from(16u32)), i32::zero())) {
            ratio = full_math_u128::mul_shr(ratio, 79291567232598584799939703904, 96u8);
        };
        if (!i32::eq(i32::and(tick, i32::from(32u32)), i32::zero())) {
            ratio = full_math_u128::mul_shr(ratio, 79355022692464371645785046466, 96u8);
        };
        if (!i32::eq(i32::and(tick, i32::from(64u32)), i32::zero())) {
            ratio = full_math_u128::mul_shr(ratio, 79482085999252804386437311141, 96u8);
        };
        if (!i32::eq(i32::and(tick, i32::from(128u32)), i32::zero())) {
            ratio = full_math_u128::mul_shr(ratio, 79736823300114093921829183326, 96u8);
        };
        if (!i32::eq(i32::and(tick, i32::from(256u32)), i32::zero())) {
            ratio = full_math_u128::mul_shr(ratio, 80248749790819932309965073892, 96u8);
        };
        if (!i32::eq(i32::and(tick, i32::from(512u32)), i32::zero())) {
            ratio = full_math_u128::mul_shr(ratio, 81282483887344747381513967011, 96u8);
        };
        if (!i32::eq(i32::and(tick, i32::from(1024u32)), i32::zero())) {
            ratio = full_math_u128::mul_shr(ratio, 83390072131320151908154831281, 96u8);
        };
        if (!i32::eq(i32::and(tick, i32::from(2048u32)), i32::zero())) {
            ratio = full_math_u128::mul_shr(ratio, 87770609709833776024991924138, 96u8);
        };
        if (!i32::eq(i32::and(tick, i32::from(4096u32)), i32::zero())) {
            ratio = full_math_u128::mul_shr(ratio, 97234110755111693312479820773, 96u8);
        };
        if (!i32::eq(i32::and(tick, i32::from(8192u32)), i32::zero())) {
            ratio = full_math_u128::mul_shr(ratio, 119332217159966728226237229890, 96u8);
        };
        if (!i32::eq(i32::and(tick, i32::from(16384u32)), i32::zero())) {
            ratio = full_math_u128::mul_shr(ratio, 179736315981702064433883588727, 96u8);
        };
        if (!i32::eq(i32::and(tick, i32::from(32768u32)), i32::zero())) {
            ratio = full_math_u128::mul_shr(ratio, 407748233172238350107850275304, 96u8);
        };
        if (!i32::eq(i32::and(tick, i32::from(65536u32)), i32::zero())) {
            ratio = full_math_u128::mul_shr(ratio, 2098478828474011932436660412517, 96u8);
        };
        if (!i32::eq(i32::and(tick, i32::from(131072u32)), i32::zero())) {
            ratio = full_math_u128::mul_shr(ratio, 55581415166113811149459800483533, 96u8);
        };
        if (!i32::eq(i32::and(tick, i32::from(262144u32)), i32::zero())) {
            ratio = full_math_u128::mul_shr(ratio, 38992368544603139932233054999993551, 96u8);
        };

        (ratio >> 32)
    }

    public fun get_sqrt_price_negative_tick(tick: i32::I32) : u128 {
        let abs_tick = i32::abs(tick);
        let ratio: u128;
        if (!i32::eq(i32::and(abs_tick, i32::from(1u32)), i32::zero())) {
            ratio = 18445821805675392311
        } else {
            ratio = 18446744073709551616
        };

        if (!i32::eq(i32::and(abs_tick, i32::from(2u32)), i32::zero())) {
            ratio = full_math_u128::mul_shr(ratio, 18444899583751176498, 64u8);
        };
        if (!i32::eq(i32::and(abs_tick, i32::from(4u32)), i32::zero())) {
            ratio = full_math_u128::mul_shr(ratio, 18443055278223354162, 64u8);
        };
        if (!i32::eq(i32::and(abs_tick, i32::from(8u32)), i32::zero())) {
            ratio = full_math_u128::mul_shr(ratio, 18439367220385604838, 64u8);
        };
        if (!i32::eq(i32::and(abs_tick, i32::from(16u32)), i32::zero())) {
            ratio = full_math_u128::mul_shr(ratio, 18431993317065449817, 64u8);
        };
        if (!i32::eq(i32::and(abs_tick, i32::from(32u32)), i32::zero())) {
            ratio = full_math_u128::mul_shr(ratio, 18417254355718160513, 64u8);
        };
        if (!i32::eq(i32::and(abs_tick, i32::from(64u32)), i32::zero())) {
            ratio = full_math_u128::mul_shr(ratio, 18387811781193591352, 64u8);
        };
        if (!i32::eq(i32::and(abs_tick, i32::from(128u32)), i32::zero())) {
            ratio = full_math_u128::mul_shr(ratio, 18329067761203520168, 64u8);
        };
        if (!i32::eq(i32::and(abs_tick, i32::from(256u32)), i32::zero())) {
            ratio = full_math_u128::mul_shr(ratio, 18212142134806087854, 64u8);
        };
        if (!i32::eq(i32::and(abs_tick, i32::from(512u32)), i32::zero())) {
            ratio = full_math_u128::mul_shr(ratio, 17980523815641551639, 64u8);
        };
        if (!i32::eq(i32::and(abs_tick, i32::from(1024u32)), i32::zero())) {
            ratio = full_math_u128::mul_shr(ratio, 17526086738831147013, 64u8);
        };
        if (!i32::eq(i32::and(abs_tick, i32::from(2048u32)), i32::zero())) {
            ratio = full_math_u128::mul_shr(ratio, 16651378430235024244, 64u8);
        };
        if (!i32::eq(i32::and(abs_tick, i32::from(4096u32)), i32::zero())) {
            ratio = full_math_u128::mul_shr(ratio, 15030750278693429944, 64u8);
        };
        if (!i32::eq(i32::and(abs_tick, i32::from(8192u32)), i32::zero())) {
            ratio = full_math_u128::mul_shr(ratio, 12247334978882834399, 64u8);
        };
        if (!i32::eq(i32::and(abs_tick, i32::from(16384u32)), i32::zero())) {
            ratio = full_math_u128::mul_shr(ratio, 8131365268884726200, 64u8);
        };
        if (!i32::eq(i32::and(abs_tick, i32::from(32768u32)), i32::zero())) {
            ratio = full_math_u128::mul_shr(ratio, 3584323654723342297, 64u8);
        };
        if (!i32::eq(i32::and(abs_tick, i32::from(65536u32)), i32::zero())) {
            ratio = full_math_u128::mul_shr(ratio, 696457651847595233, 64u8);
        };
        if (!i32::eq(i32::and(abs_tick, i32::from(131072u32)), i32::zero())) {
            ratio = full_math_u128::mul_shr(ratio, 26294789957452057, 64u8);
        };
        if (!i32::eq(i32::and(abs_tick, i32::from(262144u32)), i32::zero())) {
            ratio = full_math_u128::mul_shr(ratio, 37481735321082, 64u8);
        };

        ratio
    }

    #[test]
    fun test_sqrt_price_from_tick_index_at_max() {
        let r = tick_index_from_sqrt_price(MAX_SQRT_PRICE_X64);
        assert!(i32::eq(r, i32::from(MAX_TICK_INDEX)), 0);
    }

    #[test]
    fun test_sqrt_price_from_tick_index_at_min() {
        let r = tick_index_from_sqrt_price(MIN_SQRT_PRICE_X64);
        assert!(i32::eq(r, i32::neg_from(MAX_TICK_INDEX)), 0);
    }

    #[test]
    fun test_sqrt_price_from_tick_index_at_max_add_one() {
        let sqrt_price_x64_max_add_one = MAX_SQRT_PRICE_X64 + 1;
        let tick_from_max_add_one = tick_index_from_sqrt_price(sqrt_price_x64_max_add_one);
        let sqrt_price_x64_max = MAX_SQRT_PRICE_X64;
        let tick_from_max = tick_index_from_sqrt_price(sqrt_price_x64_max);

        // We don't care about accuracy over the limit. We just care about it's equality properties.
        assert!(i32::eq(tick_from_max_add_one, tick_from_max), 0);
    }

    #[test]
    fun test_sqrt_price_from_tick_index_at_min_add_one() {
        let sqrt_price_x64 = MIN_SQRT_PRICE_X64 + 1;
        let r = tick_index_from_sqrt_price(sqrt_price_x64);
        assert!(i32::eq(r, i32::neg_from(MAX_TICK_INDEX)), 0);
    }

    #[test]
    fun test_sqrt_price_from_tick_index_at_max_sub_one() {
        let sqrt_price_x64 = MAX_SQRT_PRICE_X64 - 1;
        let r = tick_index_from_sqrt_price(sqrt_price_x64);
        assert!(i32::eq(r, i32::from(MAX_TICK_INDEX-1)), 0);
    }

    #[test]
    fun test_sqrt_price_from_tick_index_at_one() {
        let sqrt_price_x64: u128 = (MAX_U64 as u128) + 1;
        let r = tick_index_from_sqrt_price(sqrt_price_x64);
        assert!(i32::eq(r, i32::zero()), 0);
    }

    #[test]
    fun test_sqrt_price_from_tick_index_at_one_add_one() {
        let sqrt_price_x64: u128 = (MAX_U64 as u128) + 2;
        let r = tick_index_from_sqrt_price(sqrt_price_x64);
        assert!(i32::eq(r, i32::zero()), 0);
    }

    #[test]
    fun test_sqrt_price_from_tick_index_at_one_sub_one() {
        let sqrt_price_x64: u128 = (MAX_U64 as u128) - 1;
        let r = tick_index_from_sqrt_price(sqrt_price_x64);
        assert!(i32::eq(r, i32::neg_from(1)), 0);
    }

    #[test]
    #[expected_failure]
    fun test_tick_exceed_max() {
        let sqrt_price_from_max_tick_add_one = sqrt_price_from_tick_index(i32::from(MAX_TICK_INDEX + 1));
        let sqrt_price_from_max_tick = sqrt_price_from_tick_index(i32::from(MAX_TICK_INDEX));
        assert!(sqrt_price_from_max_tick_add_one > sqrt_price_from_max_tick, 0);
    }

    #[test]
    fun test_tick_below_min() {
        let sqrt_price_from_min_tick_sub_one = sqrt_price_from_tick_index(i32::sub(i32::neg_from(MAX_TICK_INDEX), (i32::from(1))));
        let sqrt_price_from_min_tick = sqrt_price_from_tick_index(i32::neg_from(MAX_TICK_INDEX));
        assert!(sqrt_price_from_min_tick_sub_one < sqrt_price_from_min_tick, 0);
    }

    #[test]
    fun test_tick_at_max() {
        let max_tick = i32::from(MAX_TICK_INDEX);
        let r = sqrt_price_from_tick_index(max_tick);
        assert!(r == MAX_SQRT_PRICE_X64, 0);
    }

    #[test]
    fun test_tick_at_min() {
        let min_tick = i32::neg_from(MAX_TICK_INDEX);
        let r = sqrt_price_from_tick_index(min_tick);
        assert!(r == MIN_SQRT_PRICE_X64, 0);
    }

    #[test]
    fun test_get_min_tick_10() {
        let min_tick = get_min_tick(10);
        let max_tick = get_max_tick(10);
        assert!(i32::eq(min_tick, i32::neg_from(443630)), 0);
        assert!(i32::eq(max_tick, i32::from(443630)), 0);
    }

    #[test]
    fun test_get_min_tick_300() {
        let min_tick = get_min_tick(200);
        let max_tick = get_max_tick(200);
        assert!(i32::eq(min_tick, i32::neg_from(443600)), 0);
        assert!(i32::eq(max_tick, i32::from(443600)), 0);
    }

    #[test]
    fun test_get_min_tick_max() {
        let min_tick = get_min_tick(16383);
        let max_tick = get_max_tick(16383);
        assert!(i32::eq(min_tick, i32::neg_from(442341)), 0);
        assert!(i32::eq(max_tick, i32::from(442341)), 0);
    }
}
