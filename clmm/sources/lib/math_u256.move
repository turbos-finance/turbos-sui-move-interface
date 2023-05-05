module turbos_clmm::math_u256 {
    const MASK_U128: u256 = 0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff;
    const MASK_U64: u256  = 0x000000000000000000000000000000000000000000000000ffffffffffffffff;

    public fun div_mod(num: u256, denom: u256): (u256, u256) {
        let p = num / denom;
        let r: u256 = num - (p * denom);
        (p, r)
    }

    public fun shlw(n: u256): u256 {
        n << 64
    }

    public fun shrw(n: u256): u256 {
        n >> 64
    }

    public fun checked_shlw(n: u256): (u256, bool) {
        let mask = 0xffffffffffffffff << 192;
        if (n > mask) {
            (0, true)
        } else {
            ((n << 64), false)
        }
    }

    public fun div_round(num: u256, denom: u256, round_up: bool): u256 {
        let p = num / denom;
        if (round_up && ((p * denom) != num)) {
            p + 1
        } else {
            p
        }
    }

    #[test]
    fun test_div_round() {
        div_round(1, 1, true);
    }

    #[test]
    fun test_add() {
        1000u256 + 1000u256;
    }
}