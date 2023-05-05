// Copyright (c) Turbos Finance, Inc.
// SPDX-License-Identifier: MIT

module turbos_clmm::math_sqrt_price {
    use turbos_clmm::math_u128;
    use turbos_clmm::math_u256;
    use turbos_clmm::full_math_u128;
    use turbos_clmm::i128::{Self, I128};

    const EInvildSqrtPrice: u64 = 0;
    const ELiquidity: u64 = 1;
    const EDenominatorOverflow: u64 = 2;

    const RESOLUTION: u8 = 64;
    const Q64: u128 = 0x10000000000000000;
    const MAX_U64: u128 = 0xffffffffffffffff;
    const SCALE_FACTOR: u128 = 10000;
    const DECIMAL_PLACES: u8 = 64;

    /// @notice Gets the amount0 delta between two prices
    /// @dev Calculates liquidity / sqrt(lower) - liquidity / sqrt(upper),
    /// i.e. liquidity * (sqrt(upper) - sqrt(lower)) / (sqrt(upper) * sqrt(lower))
    /// @param sqrt_price_a A sqrt price
    /// @param sqrt_price_b Another sqrt price
    /// @param liquidity The amount of usable liquidity
    /// @param round_up Whether to round the amount up or down
    /// @return amount0 Amount of token0 required to cover a position of size liquidity between the two passed prices
    public fun get_amount_a_delta_(
        sqrt_price_a: u128,
        sqrt_price_b: u128,
        liquidity: u128,
        round_up: bool,
    ): u128 {
        assert!(sqrt_price_a > 0, EInvildSqrtPrice);
        if (sqrt_price_a > sqrt_price_b) (sqrt_price_a, sqrt_price_b) = (sqrt_price_b, sqrt_price_a);
        let (sqrt_price_a_u256, sqrt_price_b_u256, liquidity_u256) = ((sqrt_price_a as u256), (sqrt_price_b as u256), (liquidity as u256));

        let numerator1 = liquidity_u256 << RESOLUTION;
        let numerator2 = sqrt_price_b_u256 - sqrt_price_a_u256;

        let amount_a;
        if (round_up) {
            amount_a = math_u256::div_round(
                numerator1 * numerator2 / sqrt_price_b_u256,
                sqrt_price_a_u256,
                true
            );
        } else {
            amount_a = numerator1 * numerator2 / sqrt_price_b_u256 / sqrt_price_a_u256;
        };

        (amount_a as u128)
    }

    /// @notice Gets the amount1 delta between two prices
    /// @dev Calculates liquidity * (sqrt(upper) - sqrt(lower))
    /// @param sqrt_price_a A sqrt price
    /// @param sqrt_price_b Another sqrt price
    /// @param liquidity The amount of usable liquidity
    /// @param round_up Whether to round the amount up, or down
    /// @return amount1 Amount of token1 required to cover a position of size liquidity between the two passed prices
    public fun get_amount_b_delta_(
        sqrt_price_a: u128,
        sqrt_price_b: u128,
        liquidity: u128,
        round_up: bool,
    ): u128 {
        if (sqrt_price_a > sqrt_price_b) (sqrt_price_a, sqrt_price_b) = (sqrt_price_b, sqrt_price_a);

        let amount_b;
        if (round_up) {
            amount_b = full_math_u128::mul_div_round(liquidity, sqrt_price_b - sqrt_price_a, Q64);
        } else {
            amount_b = full_math_u128::mul_div_floor(liquidity, sqrt_price_b - sqrt_price_a, Q64);
        };

        amount_b
    }

    public fun get_amount_a_delta(
        sqrt_price_a: u128,
        sqrt_price_b: u128,
        liquidity: I128,
    ): I128 {
        if (i128::is_neg(liquidity)) {
            i128::neg_from(
                get_amount_a_delta_(
                    sqrt_price_a,
                    sqrt_price_b,
                    i128::abs_u128(liquidity),
                    false
                )
            )
        } else {
            i128::from(
                get_amount_a_delta_(
                    sqrt_price_a,
                    sqrt_price_b,
                    i128::abs_u128(liquidity),
                    true
                )
            )
        }
    }

    /// @notice Helper that gets signed token1 delta
    /// @param sqrtRatioAX96 A sqrt price
    /// @param sqrtRatioBX96 Another sqrt price
    /// @param liquidity The change in liquidity for which to compute the amount1 delta
    /// @return amount1 Amount of token1 corresponding to the passed liquidityDelta between the two prices
    public fun get_amount_b_delta(
        sqrt_price_a: u128,
        sqrt_price_b: u128,
        liquidity: I128,
    ): I128 {
        if (i128::is_neg(liquidity)) {
            i128::neg_from(
                get_amount_b_delta_(
                    sqrt_price_a,
                    sqrt_price_b,
                    i128::abs_u128(liquidity),
                    false
                )
            )
        } else {
            i128::from(
                get_amount_b_delta_(
                    sqrt_price_a,
                    sqrt_price_b,
                    i128::abs_u128(liquidity),
                    true
                )
            )
        }
    }

    public fun get_next_sqrt_price(
        sqrt_price: u128,
        liquidity: u128,
        amount: u128,
        amount_specified_is_input: bool,
        a_to_b: bool,
    ): u128 {
        if (amount_specified_is_input == a_to_b) {
            get_next_sqrt_price_from_amount_a_rounding_up(
                sqrt_price,
                liquidity,
                amount,
                amount_specified_is_input,
            )
        } else {
            get_next_sqrt_price_from_amount_b_rounding_down(
                sqrt_price,
                liquidity,
                amount,
                amount_specified_is_input,
            )
        }
    }

    /// @notice Gets the next sqrt price given a delta of token0
    /// @dev Always rounds up, because in the exact output case (increasing price) we need to move the price at least
    /// far enough to get the desired output amount, and in the exact input case (decreasing price) we need to move the
    /// price less in order to not send too much output.
    /// The most precise formula for this is liquidity * sqrt_price / (liquidity +- amount * sqrt_price),
    /// if this is impossible because of overflow, we calculate liquidity / (liquidity / sqrt_price +- amount).
    /// @param sqrt_price The starting price, i.e. before accounting for the token0 delta
    /// @param liquidity The amount of usable liquidity
    /// @param amount How much of token0 to add or remove from virtual reserves
    /// @param add Whether to add or remove the amount of token0
    /// @return The price after adding or removing amount, depending on add
    fun get_next_sqrt_price_from_amount_a_rounding_up(
        sqrt_price: u128,
        liquidity: u128,
        amount: u128,
        add: bool
    ): u128 {
        if (amount == 0) return sqrt_price;
        let (sqrt_price_u256, liquidity_u256, amount_u256) = ((sqrt_price as u256), (liquidity as u256), (amount as u256));

        let p = amount_u256 * sqrt_price_u256;
        let numerator = (liquidity_u256 * sqrt_price_u256) << RESOLUTION;
        //todo check numerator overflow u256
        let liquidity_shl = liquidity_u256 << RESOLUTION;
        let denominator = if (add) liquidity_shl + p else liquidity_shl - p;

        (math_u256::div_round(numerator, denominator, true) as u128)
    }

    public fun mul_div_round_fixed(num1: u256, num2: u256, denom: u256): u128 {
        let r = (num1 * num2  + (denom >> 1)) / denom;
        (r as u128)
    }

    /// @notice Gets the next sqrt price given a delta of token1
    /// @dev Always rounds down, because in the exact output case (decreasing price) we need to move the price at least
    /// far enough to get the desired output amount, and in the exact input case (increasing price) we need to move the
    /// price less in order to not send too much output.
    /// The formula we compute is within <1 wei of the lossless version: sqrt_price +- amount / liquidity
    /// @param sqrt_price The starting price, i.e., before accounting for the token1 delta
    /// @param liquidity The amount of usable liquidity
    /// @param amount How much of token1 to add, or remove, from virtual reserves
    /// @param add Whether to add, or remove, the amount of token1
    /// @return The price after adding or removing `amount`
    fun get_next_sqrt_price_from_amount_b_rounding_down(
        sqrt_price: u128,
        liquidity: u128,
        amount: u128,
        add: bool
    ): u128 {
        // if we're adding (subtracting), rounding down requires rounding the quotient down (up)
        // in both cases, avoid a mulDiv for most inputs
        if (add) {
            let quotient = if (amount <= MAX_U64) {
                (amount << RESOLUTION) / liquidity
            } else {
                full_math_u128::mul_div_floor(amount, Q64, liquidity)
            };
            sqrt_price + quotient
        } else {
            let quotient = if (amount <= MAX_U64) {
                math_u128::checked_div_round(amount << RESOLUTION, liquidity, true)
            } else {
                full_math_u128::mul_div_round(amount, Q64, liquidity)
            };

            assert!(sqrt_price > quotient, EInvildSqrtPrice);

            sqrt_price - quotient
        }
    }
    
    #[test_only]
    fun div_with_scale(a: u128, b: u128): u128 {
        (a * SCALE_FACTOR) / b
    }

    #[test_only]
    fun div_with_decimal(a: u128, b: u128, decimal_places: u8): u128 {
        (a << decimal_places) / b
    }

    #[test_only]
    public fun encode_price_sqrt(reserve1: u128, reserve0: u128): u128 {
        // Calculate the square root of (reserve1 * SCALE_FACTOR) / reserve0
        let ratio = div_with_scale(reserve1, reserve0);
        let sqrt_ratio = sui::math::sqrt_u128(ratio);

        // Multiply by 2^64 and round to the nearest integer
        //let integer_result = sqrt_ratio * (1 << 64) / sqrt scale;
        let integer_result = sqrt_ratio * (1 << 64) / sui::math::sqrt_u128(SCALE_FACTOR);

        integer_result
    }

    #[test]
    fun test_get_amount_b_delta_() {
        let delta = get_amount_b_delta_(
            18446743083709604748,
            18446744073709551616,
            18446744073709551616,
            false
        );
        assert!(delta == 989999946868, 1);
    }

    #[test]
    fun test_encode_price_sqrt() {
        assert!(encode_price_sqrt(1, 1) == 18446744073709551616, 0);
        assert!(encode_price_sqrt(1, 100) == 1844674407370955161, 0);
    }
}
