
; RUN: clspv-opt --passes=replace-opencl-builtin,replace-llvm-intrinsics -hack-clamp-width %s -o %t.ll
; RUN: FileCheck %s < %t.ll

; AUTO-GENERATED TEST FILE
; This test was generated by add_sat_hack_clamp_test_gen.cpp.
; Please modify the that file and regenerate the tests to make changes.

target datalayout = "e-p:32:32-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "spir-unknown-unknown"

define <3 x i64> @add_sat_long3(<3 x i64> %a, <3 x i64> %b) {
entry:
 %call = call <3 x i64> @_Z7add_satDv3_lS_(<3 x i64> %a, <3 x i64> %b)
 ret <3 x i64> %call
}

declare <3 x i64> @_Z7add_satDv3_lS_(<3 x i64>, <3 x i64>)

; CHECK: [[add:%[a-zA-Z0-9_.]+]] = add <3 x i64> %a, %b
; CHECK: [[b_lt_0:%[a-zA-Z0-9_.]+]] = icmp slt <3 x i64> %b, zeroinitializer
; CHECK: [[add_gt_a:%[a-zA-Z0-9_.]+]] = icmp sgt <3 x i64> [[add]], %a
; CHECK: [[add_lt_a:%[a-zA-Z0-9_.]+]] = icmp slt <3 x i64> [[add]], %a
; CHECK: [[min_clamp:%[a-zA-Z0-9_.]+]] = select <3 x i1> [[add_gt_a]], <3 x i64> splat (i64 -9223372036854775808), <3 x i64> [[add]]
; CHECK: [[max_clamp:%[a-zA-Z0-9_.]+]] = select <3 x i1> [[add_lt_a]], <3 x i64> splat (i64 9223372036854775807), <3 x i64> [[add]]
; CHECK: [[sel:%[a-zA-Z0-9_.]+]] = select <3 x i1> [[b_lt_0]], <3 x i64> [[min_clamp]], <3 x i64> [[max_clamp]]
; CHECK: ret <3 x i64> [[sel]]
