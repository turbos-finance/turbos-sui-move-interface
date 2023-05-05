// Copyright (c) Turbos Finance, Inc.
// SPDX-License-Identifier: MIT

module turbos_clmm::math_bit {

    const EXMustGtZero: u64 = 0;
   /// @notice Returns the index of the most significant bit of the number,
    ///     where the least significant bit is at index 0 and the most significant bit is at index 255
    /// @dev The function satisfies the property:
    ///     x >= 2**mostSignificantBit(x) and x < 2**(mostSignificantBit(x)+1)
    /// @param x the value for which to compute the most significant bit, must be greater than 0
    /// @return r the index of the most significant bit
    public fun most_significant_bit(x: u256): u8 {
        assert!(x > 0, EXMustGtZero);
        let r: u8 = 0;

        if (x >= 0x100000000000000000000000000000000) {
            x = x >> 128;
            r = r + 128;
        };
        if (x >= 0x10000000000000000) {
            x = x >> 64;
            r = r + 64;
        };
        if (x >= 0x100000000) {
            x = x >> 32;
            r = r + 32;
        };
        if (x >= 0x10000) {
            x = x >> 16;
            r = r + 16;
        };
        if (x >= 0x100) {
            x = x >> 8;
            r = r + 8;
        };
        if (x >= 0x10) {
            x = x >> 4;
            r = r + 4;
        };
        if (x >= 0x4) {
            x = x >> 2;
            r = r + 2;
        };
        if (x >= 0x2) r = r + 1;

        r
    }

    /// @notice Returns the index of the least significant bit of the number,
    ///     where the least significant bit is at index 0 and the most significant bit is at index 255
    /// @dev The function satisfies the property:
    ///     (x & 2**leastSignificantBit(x)) != 0 and (x & (2**(leastSignificantBit(x)) - 1)) == 0)
    /// @param x the value for which to compute the least significant bit, must be greater than 0
    /// @return r the index of the least significant bit
    public fun least_significant_bit(x: u256): u8 {
        assert!(x > 0, EXMustGtZero);

        let r: u8 = 255;
        if (x & 0xffffffffffffffffffffffffffffffff > 0) {
            r = r - 128;
        } else {
            x = x >> 128;
        };
        if (x & 0xffffffffffffffff > 0) {
            r = r - 64;
        } else {
            x = x >> 64;
        };
        if (x & 0xffffffff > 0) {
            r = r - 32;
        } else {
            x = x >> 32;
        };
        if (x & 0xffff > 0) {
            r = r - 16;
        } else {
            x = x >> 16;
        };
        if (x & 0xff > 0) {
            r = r - 8;
        } else {
            x = x >> 8;
        };
        if (x & 0xf > 0) {
            r = r - 4;
        } else {
            x = x >> 4;
        };
        if (x & 0x3 > 0) {
            r = r - 2;
        } else {
            x = x >> 2;
        };
        if (x & 0x1 > 0) r = r - 1;

        r
    }
}
