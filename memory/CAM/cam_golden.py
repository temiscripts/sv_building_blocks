# cam_golden.py
# Golden reference model for the Content Addressable Memory (CAM)
# Independently computes expected outputs for any sequence of writes and searches
# Used to verify RTL behavior against a software reference

class CAM:
    def __init__(self, depth=16, data_width=8):
        self.depth      = depth
        self.data_width = data_width
        self.max_val    = (1 << data_width) - 1

        self.cam_data   = [0] * depth       # storage array
        self.cam_valid  = [False] * depth   # valid bits
        self.write_ptr  = 0                 # circular write pointer

    def reset(self):
        self.cam_data   = [0] * self.depth
        self.cam_valid  = [False] * self.depth
        self.write_ptr  = 0

    def write(self, data):
        # mirrors always_ff write block exactly
        # auto-placement: write at write_ptr regardless of full or not
        # oldest entry evicted naturally when full, pointer just overwrites it
        self.cam_data[self.write_ptr]  = data & self.max_val
        self.cam_valid[self.write_ptr] = True
        self.write_ptr = (self.write_ptr + 1) % self.depth

    def search(self, search_key, search_enable):
        # mirrors combinational search and priority encoder 
        if not search_enable:
            return {
                'match':          False,
                'match_addr':     0,
                'match_multiple': False
            }

        # parallel comparator array. Check every row
        match_array = [
            self.cam_valid[i] and (self.cam_data[i] == search_key)
            for i in range(self.depth)
        ]

        # priority encoder — lowest index wins
        match          = False
        match_addr     = 0
        match_multiple = False

        for i in range(self.depth):
            if match_array[i]:
                if not match:
                    match_addr = i
                    match      = True
                else:
                    match_multiple = True

        return {
            'match':          match,
            'match_addr':     match_addr,
            'match_multiple': match_multiple
        }

    def is_full(self):
        return all(self.cam_valid)


def run_tests():
    cam    = CAM(depth=4, data_width=8)
    passed = 0
    failed = 0

    def check(description, result, exp_match, exp_addr, exp_multiple):
        nonlocal passed, failed
        if (result['match']          == exp_match and
            result['match_addr']     == exp_addr  and
            result['match_multiple'] == exp_multiple):
            print(f"PASS: {description}")
            print(f"      match={int(result['match'])} addr={result['match_addr']} multiple={int(result['match_multiple'])}")
            passed += 1
        else:
            print(f"FAIL: {description}")
            print(f"      got      match={int(result['match'])} addr={result['match_addr']} multiple={int(result['match_multiple'])}")
            print(f"      expected match={int(exp_match)} addr={exp_addr} multiple={int(exp_multiple)}")
            failed += 1

    # core functionality
    cam.reset()

    cam.write(0xAA)
    cam.write(0xBB)
    cam.write(0xCC)
    cam.write(0xDD)

    print(f"\nfull after 4 writes: {'PASS' if cam.is_full() else 'FAIL'}")

    check("search BB — exists at row 1",
          cam.search(0xBB, True), True, 1, False)

    check("search FF — never written",
          cam.search(0xFF, True), False, 0, False)

    check("search BB with search_enable=False — gate should block",
          cam.search(0xBB, False), False, 0, False)

    cam.write(0xEE)

    check("search AA — evicted by EE",
          cam.search(0xAA, True), False, 0, False)

    check("search EE — now at row 0",
          cam.search(0xEE, True), True, 0, False)

    check("search BB — untouched at row 1",
          cam.search(0xBB, True), True, 1, False)

    check("search CC — untouched at row 2",
          cam.search(0xCC, True), True, 2, False)

    check("search DD — untouched at row 3",
          cam.search(0xDD, True), True, 3, False)

    # multiple match
    cam.reset()

    cam.write(0xBB)   # row 0
    cam.write(0x11)   # row 1
    cam.write(0xBB)   # row 2 — duplicate

    check("search BB — duplicate at rows 0 and 2, lowest wins",
          cam.search(0xBB, True), True, 0, True)

    # Summary
    print(f"\n{'='*40}")
    print(f"Results: {passed} passed, {failed} failed")
    if failed == 0:
        print("ALL TESTS PASSED")
    else:
        print("SOME TESTS FAILED")


if __name__ == "__main__":
    run_tests()