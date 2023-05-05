// Copyright (c) Turbos Finance, Inc.
// SPDX-License-Identifier: MIT

module turbos_clmm::math_swap {
    use turbos_clmm::full_math_u128;
    use turbos_clmm::math_sqrt_price;

    const EInvildSqrtPrice: u64 = 0;
    const ELiquidity: u64 = 1;
    const EDenominatorOverflow: u64 = 2;

    const RESOLUTION: u8 = 64;
    const Q64: u128 = 0x10000000000000000;
    const MAX_U64: u128 = 0xffffffffffffffff;
    const SCALE_FACTOR: u128 = 10000;
    const DECIMAL_PLACES: u8 = 64;

    public fun compute_swap(
        sqrt_price_current: u128,
        sqrt_price_target: u128,
        liquidity: u128,
        amount_remaining: u128,
        amount_specified_is_input: bool,
        fee_rate: u32,
    ): (u128, u128, u128, u128) {
        let a_to_b = sqrt_price_current >= sqrt_price_target;
        let fee_amount;

        let amount_fixed_delta = get_amount_fixed_delta(
            sqrt_price_current,
            sqrt_price_target,
            liquidity,
            amount_specified_is_input,
            a_to_b,
        );

        let amount_calc = amount_remaining;
        if (amount_specified_is_input) {
            amount_calc = full_math_u128::mul_div_floor(
                amount_remaining,
                ((1000000 - fee_rate) as u128),
                1000000,
            );
        };

        let next_sqrt_price = if (amount_calc >= amount_fixed_delta) {
            sqrt_price_target
        } else {
            math_sqrt_price::get_next_sqrt_price(
                sqrt_price_current,
                liquidity,
                amount_calc,
                amount_specified_is_input,
                a_to_b,
            )
        };

        let is_max_swap = next_sqrt_price == sqrt_price_target;

        let amount_unfixed_delta = get_amount_unfixed_delta(
            sqrt_price_current,
            next_sqrt_price,
            liquidity,
            amount_specified_is_input,
            a_to_b,
        );

        // If the swap is not at the max, we need to readjust the amount of the fixed token we are using
        if (!is_max_swap) {
                amount_fixed_delta = get_amount_fixed_delta(
                sqrt_price_current,
                next_sqrt_price,
                liquidity,
                amount_specified_is_input,
                a_to_b,
            );
        };

        let (amount_in, amount_out) = if (amount_specified_is_input) {
            (amount_fixed_delta, amount_unfixed_delta)
        } else {
            (amount_unfixed_delta, amount_fixed_delta)
        };

        // Cap output amount if using output
        if (!amount_specified_is_input && amount_out > amount_remaining) {
            amount_out = amount_remaining;
        };

        if (amount_specified_is_input && !is_max_swap) {
            fee_amount = amount_remaining - amount_in;
        } else {
            fee_amount = full_math_u128::mul_div_round(
                amount_in,
                (fee_rate as u128),
                ((1000000 - fee_rate) as u128),
            );
        };

        (next_sqrt_price, amount_in, amount_out, fee_amount)
    } 
    
    public fun get_amount_fixed_delta(
        sqrt_price_current: u128,
        sqrt_price_target: u128,
        liquidity: u128,
        amount_specified_is_input: bool,
        a_to_b: bool,
    ): u128 {
        if (a_to_b == amount_specified_is_input) {
            math_sqrt_price::get_amount_a_delta_(
                sqrt_price_current,
                sqrt_price_target,
                liquidity,
                amount_specified_is_input,
            )
        } else {
            math_sqrt_price::get_amount_b_delta_(
                sqrt_price_current,
                sqrt_price_target,
                liquidity,
                amount_specified_is_input,
            )
        }
    }

    public fun get_amount_unfixed_delta(
        sqrt_price_current: u128,
        sqrt_price_target: u128,
        liquidity: u128,
        amount_specified_is_input: bool,
        a_to_b: bool,
    ): u128 {
        if (a_to_b == amount_specified_is_input) {
            math_sqrt_price::get_amount_b_delta_(
                sqrt_price_current,
                sqrt_price_target,
                liquidity,
                !amount_specified_is_input,
            )
        } else {
            math_sqrt_price::get_amount_a_delta_(
                sqrt_price_current,
                sqrt_price_target,
                liquidity,
                !amount_specified_is_input,
            )
        }
    }
}
