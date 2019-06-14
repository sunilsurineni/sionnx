; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

; Check the libcall and the intrinsic for each case with differing FMF.

; The transform to sqrt is allowed as long as we deal with -0.0 and -INF.

define double @pow_libcall_half_no_FMF(double %x) {
; CHECK-LABEL: @pow_libcall_half_no_FMF(
; CHECK-NEXT:    [[SQRT:%.*]] = call double @sqrt(double [[X:%.*]])
; CHECK-NEXT:    [[ABS:%.*]] = call double @llvm.fabs.f64(double [[SQRT]])
; CHECK-NEXT:    [[ISINF:%.*]] = fcmp oeq double [[X]], 0xFFF0000000000000
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 [[ISINF]], double 0x7FF0000000000000, double [[ABS]]
; CHECK-NEXT:    ret double [[TMP1]]
;
  %pow = call double @pow(double %x, double 5.0e-01)
  ret double %pow
}

define double @pow_intrinsic_half_no_FMF(double %x) {
; CHECK-LABEL: @pow_intrinsic_half_no_FMF(
; CHECK-NEXT:    [[SQRT:%.*]] = call double @llvm.sqrt.f64(double [[X:%.*]])
; CHECK-NEXT:    [[ABS:%.*]] = call double @llvm.fabs.f64(double [[SQRT]])
; CHECK-NEXT:    [[ISINF:%.*]] = fcmp oeq double [[X]], 0xFFF0000000000000
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 [[ISINF]], double 0x7FF0000000000000, double [[ABS]]
; CHECK-NEXT:    ret double [[TMP1]]
;
  %pow = call double @llvm.pow.f64(double %x, double 5.0e-01)
  ret double %pow
}

; This makes no difference, but FMF are propagated.

define double @pow_libcall_half_approx(double %x) {
; CHECK-LABEL: @pow_libcall_half_approx(
; CHECK-NEXT:    [[SQRT:%.*]] = call afn double @sqrt(double [[X:%.*]])
; CHECK-NEXT:    [[ABS:%.*]] = call afn double @llvm.fabs.f64(double [[SQRT]])
; CHECK-NEXT:    [[ISINF:%.*]] = fcmp afn oeq double [[X]], 0xFFF0000000000000
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 [[ISINF]], double 0x7FF0000000000000, double [[ABS]]
; CHECK-NEXT:    ret double [[TMP1]]
;
  %pow = call afn double @pow(double %x, double 5.0e-01)
  ret double %pow
}

define <2 x double> @pow_intrinsic_half_approx(<2 x double> %x) {
; CHECK-LABEL: @pow_intrinsic_half_approx(
; CHECK-NEXT:    [[SQRT:%.*]] = call afn <2 x double> @llvm.sqrt.v2f64(<2 x double> [[X:%.*]])
; CHECK-NEXT:    [[ABS:%.*]] = call afn <2 x double> @llvm.fabs.v2f64(<2 x double> [[SQRT]])
; CHECK-NEXT:    [[ISINF:%.*]] = fcmp afn oeq <2 x double> [[X]], <double 0xFFF0000000000000, double 0xFFF0000000000000>
; CHECK-NEXT:    [[TMP1:%.*]] = select <2 x i1> [[ISINF]], <2 x double> <double 0x7FF0000000000000, double 0x7FF0000000000000>, <2 x double> [[ABS]]
; CHECK-NEXT:    ret <2 x double> [[TMP1]]
;
  %pow = call afn <2 x double> @llvm.pow.v2f64(<2 x double> %x, <2 x double> <double 5.0e-01, double 5.0e-01>)
  ret <2 x double> %pow
}

define float @powf_intrinsic_half_fast(float %x) {
; CHECK-LABEL: @powf_intrinsic_half_fast(
; CHECK-NEXT:    [[SQRT:%.*]] = call fast float @llvm.sqrt.f32(float [[X:%.*]])
; CHECK-NEXT:    ret float [[SQRT]]
;
  %pow = call fast float @llvm.pow.f32(float %x, float 5.0e-01)
  ret float %pow
}

; If we can disregard INFs, no need for a select.

define double @pow_libcall_half_ninf(double %x) {
; CHECK-LABEL: @pow_libcall_half_ninf(
; CHECK-NEXT:    [[SQRT:%.*]] = call ninf double @sqrt(double [[X:%.*]])
; CHECK-NEXT:    [[ABS:%.*]] = call ninf double @llvm.fabs.f64(double [[SQRT]])
; CHECK-NEXT:    ret double [[ABS]]
;
  %pow = call ninf double @pow(double %x, double 5.0e-01)
  ret double %pow
}

define <2 x double> @pow_intrinsic_half_ninf(<2 x double> %x) {
; CHECK-LABEL: @pow_intrinsic_half_ninf(
; CHECK-NEXT:    [[SQRT:%.*]] = call ninf <2 x double> @llvm.sqrt.v2f64(<2 x double> [[X:%.*]])
; CHECK-NEXT:    [[ABS:%.*]] = call ninf <2 x double> @llvm.fabs.v2f64(<2 x double> [[SQRT]])
; CHECK-NEXT:    ret <2 x double> [[ABS]]
;
  %pow = call ninf <2 x double> @llvm.pow.v2f64(<2 x double> %x, <2 x double> <double 5.0e-01, double 5.0e-01>)
  ret <2 x double> %pow
}

; If we can disregard -0.0, no need for fabs.

define double @pow_libcall_half_nsz(double %x) {
; CHECK-LABEL: @pow_libcall_half_nsz(
; CHECK-NEXT:    [[SQRT:%.*]] = call nsz double @sqrt(double [[X:%.*]])
; CHECK-NEXT:    [[ISINF:%.*]] = fcmp nsz oeq double [[X]], 0xFFF0000000000000
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 [[ISINF]], double 0x7FF0000000000000, double [[SQRT]]
; CHECK-NEXT:    ret double [[TMP1]]
;
  %pow = call nsz double @pow(double %x, double 5.0e-01)
  ret double %pow
}

define double @pow_intrinsic_half_nsz(double %x) {
; CHECK-LABEL: @pow_intrinsic_half_nsz(
; CHECK-NEXT:    [[SQRT:%.*]] = call nsz double @llvm.sqrt.f64(double [[X:%.*]])
; CHECK-NEXT:    [[ISINF:%.*]] = fcmp nsz oeq double [[X]], 0xFFF0000000000000
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 [[ISINF]], double 0x7FF0000000000000, double [[SQRT]]
; CHECK-NEXT:    ret double [[TMP1]]
;
  %pow = call nsz double @llvm.pow.f64(double %x, double 5.0e-01)
  ret double %pow
}

; This is just sqrt.

define float @pow_libcall_half_ninf_nsz(float %x) {
; CHECK-LABEL: @pow_libcall_half_ninf_nsz(
; CHECK-NEXT:    [[SQRTF:%.*]] = call ninf nsz float @sqrtf(float [[X:%.*]])
; CHECK-NEXT:    ret float [[SQRTF]]
;
  %pow = call ninf nsz float @powf(float %x, float 5.0e-01)
  ret float %pow
}

define double @pow_intrinsic_half_ninf_nsz(double %x) {
; CHECK-LABEL: @pow_intrinsic_half_ninf_nsz(
; CHECK-NEXT:    [[SQRT:%.*]] = call ninf nsz double @llvm.sqrt.f64(double [[X:%.*]])
; CHECK-NEXT:    ret double [[SQRT]]
;
  %pow = call ninf nsz double @llvm.pow.f64(double %x, double 5.0e-01)
  ret double %pow
}

; Overspecified FMF to test propagation to the new op(s).

define float @pow_libcall_half_fast(float %x) {
; CHECK-LABEL: @pow_libcall_half_fast(
; CHECK-NEXT:    [[SQRTF:%.*]] = call fast float @sqrtf(float [[X:%.*]])
; CHECK-NEXT:    ret float [[SQRTF]]
;
  %pow = call fast float @powf(float %x, float 5.0e-01)
  ret float %pow
}

define double @pow_intrinsic_half_fast(double %x) {
; CHECK-LABEL: @pow_intrinsic_half_fast(
; CHECK-NEXT:    [[SQRT:%.*]] = call fast double @llvm.sqrt.f64(double [[X:%.*]])
; CHECK-NEXT:    ret double [[SQRT]]
;
  %pow = call fast double @llvm.pow.f64(double %x, double 5.0e-01)
  ret double %pow
}

; -0.5 means take the reciprocal.

define float @pow_libcall_neghalf_no_FMF(float %x) {
; CHECK-LABEL: @pow_libcall_neghalf_no_FMF(
; CHECK-NEXT:    [[SQRTF:%.*]] = call float @sqrtf(float [[X:%.*]])
; CHECK-NEXT:    [[ABS:%.*]] = call float @llvm.fabs.f32(float [[SQRTF]])
; CHECK-NEXT:    [[ISINF:%.*]] = fcmp oeq float [[X]], 0xFFF0000000000000
; CHECK-NEXT:    [[ABS_OP:%.*]] = fdiv float 1.000000e+00, [[ABS]]
; CHECK-NEXT:    [[RECIPROCAL:%.*]] = select i1 [[ISINF]], float 0.000000e+00, float [[ABS_OP]]
; CHECK-NEXT:    ret float [[RECIPROCAL]]
;
  %pow = call float @powf(float %x, float -5.0e-01)
  ret float %pow
}

define <2 x double> @pow_intrinsic_neghalf_no_FMF(<2 x double> %x) {
; CHECK-LABEL: @pow_intrinsic_neghalf_no_FMF(
; CHECK-NEXT:    [[SQRT:%.*]] = call <2 x double> @llvm.sqrt.v2f64(<2 x double> [[X:%.*]])
; CHECK-NEXT:    [[ABS:%.*]] = call <2 x double> @llvm.fabs.v2f64(<2 x double> [[SQRT]])
; CHECK-NEXT:    [[ISINF:%.*]] = fcmp oeq <2 x double> [[X]], <double 0xFFF0000000000000, double 0xFFF0000000000000>
; CHECK-NEXT:    [[ABS_OP:%.*]] = fdiv <2 x double> <double 1.000000e+00, double 1.000000e+00>, [[ABS]]
; CHECK-NEXT:    [[RECIPROCAL:%.*]] = select <2 x i1> [[ISINF]], <2 x double> zeroinitializer, <2 x double> [[ABS_OP]]
; CHECK-NEXT:    ret <2 x double> [[RECIPROCAL]]
;
  %pow = call <2 x double> @llvm.pow.v2f64(<2 x double> %x, <2 x double> <double -5.0e-01, double -5.0e-01>)
  ret <2 x double> %pow
}

; If we can disregard INFs, no need for a select.

define double @pow_libcall_neghalf_ninf(double %x) {
; CHECK-LABEL: @pow_libcall_neghalf_ninf(
; CHECK-NEXT:    [[SQRT:%.*]] = call ninf double @sqrt(double [[X:%.*]])
; CHECK-NEXT:    [[ABS:%.*]] = call ninf double @llvm.fabs.f64(double [[SQRT]])
; CHECK-NEXT:    [[RECIPROCAL:%.*]] = fdiv ninf double 1.000000e+00, [[ABS]]
; CHECK-NEXT:    ret double [[RECIPROCAL]]
;
  %pow = call ninf double @pow(double %x, double -5.0e-01)
  ret double %pow
}

define <2 x double> @pow_intrinsic_neghalf_ninf(<2 x double> %x) {
; CHECK-LABEL: @pow_intrinsic_neghalf_ninf(
; CHECK-NEXT:    [[SQRT:%.*]] = call ninf <2 x double> @llvm.sqrt.v2f64(<2 x double> [[X:%.*]])
; CHECK-NEXT:    [[ABS:%.*]] = call ninf <2 x double> @llvm.fabs.v2f64(<2 x double> [[SQRT]])
; CHECK-NEXT:    [[RECIPROCAL:%.*]] = fdiv ninf <2 x double> <double 1.000000e+00, double 1.000000e+00>, [[ABS]]
; CHECK-NEXT:    ret <2 x double> [[RECIPROCAL]]
;
  %pow = call ninf <2 x double> @llvm.pow.v2f64(<2 x double> %x, <2 x double> <double -5.0e-01, double -5.0e-01>)
  ret <2 x double> %pow
}

; If we can disregard -0.0, no need for fabs.

define double @pow_libcall_neghalf_nsz(double %x) {
; CHECK-LABEL: @pow_libcall_neghalf_nsz(
; CHECK-NEXT:    [[SQRT:%.*]] = call nsz double @sqrt(double [[X:%.*]])
; CHECK-NEXT:    [[ISINF:%.*]] = fcmp nsz oeq double [[X]], 0xFFF0000000000000
; CHECK-NEXT:    [[SQRT_OP:%.*]] = fdiv nsz double 1.000000e+00, [[SQRT]]
; CHECK-NEXT:    [[RECIPROCAL:%.*]] = select i1 [[ISINF]], double 0.000000e+00, double [[SQRT_OP]]
; CHECK-NEXT:    ret double [[RECIPROCAL]]
;
  %pow = call nsz double @pow(double %x, double -5.0e-01)
  ret double %pow
}

define double @pow_intrinsic_neghalf_nsz(double %x) {
; CHECK-LABEL: @pow_intrinsic_neghalf_nsz(
; CHECK-NEXT:    [[SQRT:%.*]] = call nsz double @llvm.sqrt.f64(double [[X:%.*]])
; CHECK-NEXT:    [[ISINF:%.*]] = fcmp nsz oeq double [[X]], 0xFFF0000000000000
; CHECK-NEXT:    [[SQRT_OP:%.*]] = fdiv nsz double 1.000000e+00, [[SQRT]]
; CHECK-NEXT:    [[RECIPROCAL:%.*]] = select i1 [[ISINF]], double 0.000000e+00, double [[SQRT_OP]]
; CHECK-NEXT:    ret double [[RECIPROCAL]]
;
  %pow = call nsz double @llvm.pow.f64(double %x, double -5.0e-01)
  ret double %pow
}

; This is just recip-sqrt.

define double @pow_intrinsic_neghalf_ninf_nsz(double %x) {
; CHECK-LABEL: @pow_intrinsic_neghalf_ninf_nsz(
; CHECK-NEXT:    [[SQRT:%.*]] = call ninf nsz double @llvm.sqrt.f64(double [[X:%.*]])
; CHECK-NEXT:    [[RECIPROCAL:%.*]] = fdiv ninf nsz double 1.000000e+00, [[SQRT]]
; CHECK-NEXT:    ret double [[RECIPROCAL]]
;
  %pow = call ninf nsz double @llvm.pow.f64(double %x, double -5.0e-01)
  ret double %pow
}

define float @pow_libcall_neghalf_ninf_nsz(float %x) {
; CHECK-LABEL: @pow_libcall_neghalf_ninf_nsz(
; CHECK-NEXT:    [[SQRTF:%.*]] = call ninf nsz float @sqrtf(float [[X:%.*]])
; CHECK-NEXT:    [[RECIPROCAL:%.*]] = fdiv ninf nsz float 1.000000e+00, [[SQRTF]]
; CHECK-NEXT:    ret float [[RECIPROCAL]]
;
  %pow = call ninf nsz float @powf(float %x, float -5.0e-01)
  ret float %pow
}

; Overspecified FMF to test propagation to the new op(s).

define float @pow_libcall_neghalf_fast(float %x) {
; CHECK-LABEL: @pow_libcall_neghalf_fast(
; CHECK-NEXT:    [[SQRTF:%.*]] = call fast float @sqrtf(float [[X:%.*]])
; CHECK-NEXT:    [[RECIPROCAL:%.*]] = fdiv fast float 1.000000e+00, [[SQRTF]]
; CHECK-NEXT:    ret float [[RECIPROCAL]]
;
  %pow = call fast float @powf(float %x, float -5.0e-01)
  ret float %pow
}

define float @powf_libcall_neghalf_approx(float %x) {
; CHECK-LABEL: @powf_libcall_neghalf_approx(
; CHECK-NEXT:    [[SQRTF:%.*]] = call afn float @sqrtf(float [[X:%.*]])
; CHECK-NEXT:    [[ABS:%.*]] = call afn float @llvm.fabs.f32(float [[SQRTF]])
; CHECK-NEXT:    [[ISINF:%.*]] = fcmp afn oeq float [[X]], 0xFFF0000000000000
; CHECK-NEXT:    [[ABS_OP:%.*]] = fdiv afn float 1.000000e+00, [[ABS]]
; CHECK-NEXT:    [[RECIPROCAL:%.*]] = select i1 [[ISINF]], float 0.000000e+00, float [[ABS_OP]]
; CHECK-NEXT:    ret float [[RECIPROCAL]]
;
  %pow = call afn float @powf(float %x, float -5.0e-01)
  ret float %pow
}

define double @pow_intrinsic_neghalf_fast(double %x) {
; CHECK-LABEL: @pow_intrinsic_neghalf_fast(
; CHECK-NEXT:    [[SQRT:%.*]] = call fast double @llvm.sqrt.f64(double [[X:%.*]])
; CHECK-NEXT:    [[RECIPROCAL:%.*]] = fdiv fast double 1.000000e+00, [[SQRT]]
; CHECK-NEXT:    ret double [[RECIPROCAL]]
;
  %pow = call fast double @llvm.pow.f64(double %x, double -5.0e-01)
  ret double %pow
}

declare double @llvm.pow.f64(double, double) #0
declare float @llvm.pow.f32(float, float) #0
declare <2 x double> @llvm.pow.v2f64(<2 x double>, <2 x double>) #0
declare <2 x float> @llvm.pow.v2f32(<2 x float>, <2 x float>) #0
declare <4 x float> @llvm.pow.v4f32(<4 x float>, <4 x float>) #0
declare double @pow(double, double)
declare float @powf(float, float)

attributes #0 = { nounwind readnone speculatable }
attributes #1 = { nounwind readnone }
