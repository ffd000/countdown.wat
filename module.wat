(module
    (import "console" "log" (func $console_log (param i32)))
    ;;(memory (export "memory") 1)
    (import "env" "memory" (memory 1 1 shared))
    (data (i32.const 8000) "0123456789")
    (global $string_buf i32 (i32.const 8010))

    (func $main (export "countdown") (param $ms i64)
        (local $h i32)
        (local $m i32)
        
        (local.get $ms)
        (call $countdown)

        (local.set $h
            (i32.wrap_i64 (i64.div_s (local.get $ms) (i64.const 3600000))))  ;; 3600000 ms = 1 hour
        (local.set $ms
            (i64.rem_s (local.get $ms) (i64.const 3600000)))  ;; Remaining milliseconds
        (local.set $m
            (i32.wrap_i64 (i64.div_s (local.get $ms) (i64.const 60000))))  ;; 60000 ms = 1 minute

        (local.get $h)
        (local.get $m)
        (call $time_format)
        (drop)
        (drop)
        (drop)
    )

    (func $countdown (param i64) (result i64)
        (i64.gt_s
            (local.get 0)
            (i64.const 0))
        (if (result i64)
            (then
                (i64.sub 
                (local.get 0)
                (i64.const 1))
                (call $countdown))
            (else
                (i64.const 0))))

    (func $time_format (param $hours i32) (param $minutes i32) (result i32 i32)
        (local $h_digits i32)
        (local $m_digits i32)
        (local $writeidx i32)
        (local $digit i32)
        (local $dchar i32)

        (local.set $h_digits (i32.div_s (local.get $hours) (i32.const 10)))
        (local.set $m_digits (i32.div_s (local.get $minutes) (i32.const 10)))

        (local.set $writeidx (global.get $string_buf))
        ;; write hours to buffer
        (local.set $dchar (i32.load8_u offset=8000 (local.get $h_digits)))
        (i32.store8 (local.get $writeidx) (local.get $dchar))

        (local.set $writeidx (i32.add (local.get $writeidx) (i32.const 1)))
        (local.set $dchar (i32.load8_u offset=8000 (i32.rem_s (local.get $hours) (i32.const 10))))
        (i32.store8 (local.get $writeidx) (local.get $dchar))

        ;; write ":"
        (local.set $writeidx (i32.add (local.get $writeidx) (i32.const 1)))
        (i32.store8 (local.get $writeidx) (i32.const 58))

        ;; write minutes to buffer
        (local.set $writeidx (i32.add (local.get $writeidx) (i32.const 1)))
        (local.set $dchar (i32.load8_u offset=8000 (local.get $m_digits)))
        (i32.store8 (local.get $writeidx) (local.get $dchar))

        (local.set $writeidx (i32.add (local.get $writeidx) (i32.const 1)))
        (local.set $dchar (i32.load8_u offset=8000 (i32.rem_s (local.get $minutes) (i32.const 10))))
        (i32.store8 (local.get $writeidx) (local.get $dchar))

        (global.get $string_buf)
        (i32.const 5))
)