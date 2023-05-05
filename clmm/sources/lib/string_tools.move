// Copyright (c) Turbos Finance, Inc.
// SPDX-License-Identifier: MIT

module turbos_clmm::string_tools {
    use std::vector;
    use std::bcs;
    use std::string::{Self, String};
    use sui::math;

    const ERR_DIVIDE_BY_ZERO: u64 = 2000;
    
    //(owner, tickLower, tickUpper);
    public fun get_position_key(
        owner: address, 
        tick_lower_index: u32, 
        tick_lower_index_is_neg: bool, 
        tick_upper_index: u32, 
        tick_upper_index_is_neg: bool, 
    ): String {
        let address_str = address_to_hexstring(&owner);
        let tick_lower_index_str = u64_to_string((tick_lower_index as u64));
        let tick_lower_index_is_neg_str = if(tick_lower_index_is_neg) string::utf8(b"-") else string::utf8(b"+");
        let tick_upper_index_str = u64_to_string((tick_upper_index as u64));
        let tick_upper_index_is_neg_str = if(tick_upper_index_is_neg) string::utf8(b"-") else string::utf8(b"+");
        string::append(&mut address_str, tick_lower_index_is_neg_str);
        string::append(&mut address_str, tick_lower_index_str);
        string::append(&mut address_str, tick_upper_index_is_neg_str);
        string::append(&mut address_str, tick_upper_index_str);

        address_str
    }

    public fun address_to_hexstring(addr: &address): String {
        let bytes = bcs::to_bytes(addr);
        let char_mappping = &b"0123456789abcdef";

        let result_bytes = &mut b"0x";
        let index = 0;
        let still_zero = true;

        while (index < vector::length(&bytes)) {
            let byte = *vector::borrow(&bytes, index);
            index = index + 1;

            if (byte != 0) still_zero = false;
            if (still_zero) continue;

            vector::push_back(result_bytes, *vector::borrow(char_mappping, ((byte / 16) as u64)));
            vector::push_back(result_bytes, *vector::borrow(char_mappping, ((byte % 16) as u64)));
        };

        string::utf8(*result_bytes)
    }

    public fun u64_to_hexstring(num: u64): String {
        let a1 = num / 16;
        let a2 = num % 16;
        let alpha = &b"0123456789abcdef";
        let r = &mut b"";
        vector::push_back(r, *vector::borrow(alpha, a1));
        vector::push_back(r, *vector::borrow(alpha, a2));

        string::utf8(*r)
    }

    public fun bytes_to_hexstring(bytes: &vector<u8>): String {
        let r = &mut string::utf8(b"");

        let index = 0;
        while (index < vector::length(bytes)) {
            let byte = vector::borrow(bytes, index);
            string::append(r, u64_to_hexstring((*byte as u64)));

            index = index + 1;
        };

        *r
    }

    public fun u64_to_string(number: u64): String {
        if (number == 0) {
            return string::utf8(b"0")
        };
        let places = 20;
        let base = math::pow(10, 19);
        let i = places;

        let str = &mut string::utf8(vector[]);

        while (i > 0) {
            let quotient = number / base;
            if (quotient != 0) {
                number = number - quotient * base
            };

            if (!string::is_empty(str) || quotient != 0) {
                string::append_utf8(str, vector<u8>[((quotient + 0x30) as u8)])
            };

            base = base / 10;
            i = i - 1;
        };

        *str
    }

   #[test]
    public fun test_u64_to_string() {
        assert!(
            u64_to_string(123456) == string::utf8(b"123456"),
            1
        );
        assert!(
            u64_to_string(18446744073709551615) == string::utf8(b"18446744073709551615"),
            2
        );
        assert!(
            u64_to_string(124563165615123165) == string::utf8(b"124563165615123165"),
            3
        );
    }

    #[test]
    public fun test_address_to_hexstring() {
        assert!(address_to_hexstring(&@0xabcdef) == string::utf8(b"0xabcdef"), 1);
    }

    #[test]
    fun test_u64_to_hexstring() {
        assert!(u64_to_hexstring(72) == string::utf8(b"48"), 1);
        assert!(u64_to_hexstring(108) == string::utf8(b"6c"), 1);
        assert!(u64_to_hexstring(1) == string::utf8(b"01"), 1);
        assert!(u64_to_hexstring(0) == string::utf8(b"00"), 1);
    }

    #[test]
    fun test_zero_string() {
        assert!(u64_to_string(0) == string::utf8(b"0"), 0);
    }
}