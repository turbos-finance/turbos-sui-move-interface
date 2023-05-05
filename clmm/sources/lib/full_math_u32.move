module turbos_clmm::full_math_u32 {
    public fun mul_div_floor(num1: u32, num2: u32, denom: u32): u32 {
        let r = full_mul(num1, num2) / (denom as u64);
        (r as u32)
    }
    
    public fun mul_div_round(num1: u32, num2: u32, denom: u32): u32 {
        let r = (full_mul(num1, num2) + ((denom as u64) >> 1)) / (denom as u64);
        (r as u32)
    }
    
    public fun mul_div_ceil(num1: u32, num2: u32, denom: u32): u32 {
        let r = (full_mul(num1, num2) + ((denom as u64) - 1)) / (denom as u64);
        (r as u32)
    }
    
    public fun mul_shr(num1: u32, num2: u32, shift: u8): u32 {
        let r = full_mul(num1, num2) >> shift;
        (r as u32)
    }
    
    public fun mul_shl(num1: u32, num2: u32, shift: u8): u32 {
        let r = full_mul(num1, num2) << shift;
        (r as u32)
    }

    public fun full_mul(num1: u32, num2: u32): u64 {
        ((num1 as u64) * (num2 as u64))
    }
}

