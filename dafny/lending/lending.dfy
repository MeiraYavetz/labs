include "number.dfy"
include "arrays.dfy"
include "math.dfy"

class Counter {
    var count: int

    constructor () {
        count := 0;
    }

    method Increment() {
        count := count + 1;
    }

    method GetCount() returns (c: int) {
        c := count;
    }
}
