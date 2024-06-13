fn main() {
    // max value of felt252
    let x: felt252 = 3618502788666131213697322783095070105623107215331596699973092056135872020480;
    let y: felt252 = 1;
    assert(x + y == 0, 'P == 0 (mod P)');

    let o = 3618502788666131213697322783095070105623107215331596699973092056135872020480;
    let z = 1;
    assert(o + z == 0, 'P == 0 (mod P)');
}