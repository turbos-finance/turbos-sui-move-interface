// Copyright (c) Turbos Finance, Inc.
// SPDX-License-Identifier: MIT

module turbos_clmm::math_liquidity {
    use turbos_clmm::full_math_u128;
    use turbos_clmm::i128::{Self, I128};

    const EAddDelta: u64 = 0;

    const Q64: u128 = 0x10000000000000000;
    const RESOLUTION: u8 = 64;

    /// Computes the maximum amount of liquidity received for a given amount of token_a, token_b, the current
    /// pool prices and the prices at the tick boundaries
    public fun get_liquidity_for_amounts(
        sqrt_price: u128,
        sqrt_price_a: u128,
        sqrt_price_b: u128,
        amount_a: u128,
        amount_b: u128
    ): u128 {
        let liquidity;
        if (sqrt_price_a > sqrt_price_b) (sqrt_price_a, sqrt_price_b) = (sqrt_price_b, sqrt_price_a);

        if (sqrt_price <= sqrt_price_a) {
            liquidity = get_liquidity_for_amount_a(sqrt_price_a, sqrt_price_b, amount_a);
        } else if (sqrt_price < sqrt_price_b) {
            let liquidity_a = get_liquidity_for_amount_a(sqrt_price, sqrt_price_b, amount_a);
            let liquidity_b = get_liquidity_for_amount_b(sqrt_price_a, sqrt_price, amount_b);

            liquidity = if (liquidity_a < liquidity_b) liquidity_a else liquidity_b;
        } else {
            liquidity = get_liquidity_for_amount_b(sqrt_price_a, sqrt_price_b, amount_b);
        };

        liquidity
    }

    /// Calculates amount_a * (sqrt(upper) * sqrt(lower)) / (sqrt(upper) - sqrt(lower))
    public fun  get_liquidity_for_amount_a(
        sqrt_price_a: u128,
        sqrt_price_b: u128,
        amount_a: u128,
    ): u128 {
        if (sqrt_price_a > sqrt_price_b) (sqrt_price_a, sqrt_price_b) = (sqrt_price_b, sqrt_price_a);
        let intermediate = full_math_u128::mul_div_floor(sqrt_price_a, sqrt_price_b, Q64);

        full_math_u128::mul_div_floor(amount_a, intermediate, sqrt_price_b - sqrt_price_a)
    }

    /// Calculates amount_b / (sqrt(upper) - sqrt(lower)).
    public fun  get_liquidity_for_amount_b(
        sqrt_price_a: u128,
        sqrt_price_b: u128,
        amount_b: u128,
    ): u128 {
        if (sqrt_price_a > sqrt_price_b) (sqrt_price_a, sqrt_price_b) = (sqrt_price_b, sqrt_price_a);

        full_math_u128::mul_div_floor(amount_b, Q64, sqrt_price_b - sqrt_price_a)
    }

    public fun add_delta(x: u128, y: I128): u128 {
        let z;
        let abs_y = i128::abs_u128(y);
        if (i128::is_neg(y)) {
            assert!(x >= abs_y, EAddDelta);
            z = x - abs_y;
        } else {
            z = x + abs_y;
            assert!(z >= x, EAddDelta);
        };

        z
    }

    public fun get_amount_for_liquidity(
        sqrt_price: u128,
        sqrt_price_a: u128,
        sqrt_price_b: u128,
        liquidity: u128
    ): (u128, u128) {
        if (sqrt_price_a > sqrt_price_b) (sqrt_price_a, sqrt_price_b) = (sqrt_price_b, sqrt_price_a);
        let amount_a = 0;
        let amount_b = 0;

        if (sqrt_price <= sqrt_price_a) {
            amount_a = get_amount_a_for_liquidity(sqrt_price_a, sqrt_price_b, liquidity);
        } else if (sqrt_price < sqrt_price_b) {
            amount_a = get_amount_a_for_liquidity(sqrt_price, sqrt_price_b, liquidity);
            amount_b = get_amount_b_for_liquidity(sqrt_price_a, sqrt_price, liquidity);
        } else {
            amount_b = get_amount_b_for_liquidity(sqrt_price_a, sqrt_price_b, liquidity);
        };
        
        (amount_a, amount_b)
    }

    public fun get_amount_a_for_liquidity(
        sqrt_price_a: u128,
        sqrt_price_b: u128,
        liquidity: u128
    ): u128 {
        if (sqrt_price_a > sqrt_price_b) (sqrt_price_a, sqrt_price_b) = (sqrt_price_b, sqrt_price_a);

        full_math_u128::mul_div_floor(
            liquidity << RESOLUTION,
            sqrt_price_b - sqrt_price_a,
            sqrt_price_b
        ) / sqrt_price_a
    }

    public fun get_amount_b_for_liquidity(
        sqrt_price_a: u128,
        sqrt_price_b: u128,
        liquidity: u128
    ): u128 {
        if (sqrt_price_a > sqrt_price_b) (sqrt_price_a, sqrt_price_b) = (sqrt_price_b, sqrt_price_a);

        full_math_u128::mul_div_floor(
            liquidity,
            sqrt_price_b - sqrt_price_a,
            Q64
        )
    }

     #[test]
    fun test_get_liquidity_for_amounts() {
        let l = get_liquidity_for_amounts(
            1832814330046721231834,
            1353803200641628255991,
            2466716266253144737284,
            1000000000,
            9871826150795
        );
        assert!(380164550184 == l, 1);
    }

     #[test]
    fun test_get_amount_for_liquidity() {
        let (a, b) = get_amount_for_liquidity(
            3545820817480387689280,
            3514404592553427687975,
            3556829366031005702047,
            10000000,
        );
        assert!(161 == a, 1);
        assert!(17030769 == b, 1);
    }
}
