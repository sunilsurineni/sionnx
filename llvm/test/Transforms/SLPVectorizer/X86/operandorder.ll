; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basicaa -slp-vectorizer -slp-threshold=-100 -instcombine -dce -S -mtriple=i386-apple-macosx10.8.0 -mcpu=corei7-avx | FileCheck %s

target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:128:128-n8:16:32-S128"



; Make sure we order the operands of commutative operations so that we get
; bigger vectorizable trees.

define void @shuffle_operands1(double * noalias %from, double * noalias %to,
; CHECK-LABEL: @shuffle_operands1(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast double* [[FROM:%.*]] to <2 x double>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <2 x double>, <2 x double>* [[TMP1]], align 4
; CHECK-NEXT:    [[TMP3:%.*]] = insertelement <2 x double> undef, double [[V1:%.*]], i32 0
; CHECK-NEXT:    [[TMP4:%.*]] = insertelement <2 x double> [[TMP3]], double [[V2:%.*]], i32 1
; CHECK-NEXT:    [[TMP5:%.*]] = fadd <2 x double> [[TMP4]], [[TMP2]]
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast double* [[TO:%.*]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP5]], <2 x double>* [[TMP6]], align 4
; CHECK-NEXT:    ret void
;
  double %v1, double %v2) {
  %from_1 = getelementptr double, double *%from, i64 1
  %v0_1 = load double , double * %from
  %v0_2 = load double , double * %from_1
  %v1_1 = fadd double %v0_1, %v1
  %v1_2 = fadd double %v2, %v0_2
  %to_2 = getelementptr double, double * %to, i64 1
  store double %v1_1, double *%to
  store double %v1_2, double *%to_2
  ret void
}

define void @shuffle_preserve_broadcast(double * noalias %from,
; CHECK-LABEL: @shuffle_preserve_broadcast(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LP:%.*]]
; CHECK:       lp:
; CHECK-NEXT:    [[P:%.*]] = phi double [ 1.000000e+00, [[LP]] ], [ 0.000000e+00, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[FROM_1:%.*]] = getelementptr double, double* [[FROM:%.*]], i32 1
; CHECK-NEXT:    [[V0_1:%.*]] = load double, double* [[FROM]], align 4
; CHECK-NEXT:    [[V0_2:%.*]] = load double, double* [[FROM_1]], align 4
; CHECK-NEXT:    [[TMP0:%.*]] = insertelement <2 x double> undef, double [[V0_1]], i32 0
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <2 x double> [[TMP0]], <2 x double> undef, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <2 x double> undef, double [[P]], i32 0
; CHECK-NEXT:    [[TMP3:%.*]] = insertelement <2 x double> [[TMP2]], double [[V0_2]], i32 1
; CHECK-NEXT:    [[TMP4:%.*]] = fadd <2 x double> [[TMP1]], [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = bitcast double* [[TO:%.*]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP4]], <2 x double>* [[TMP5]], align 4
; CHECK-NEXT:    br i1 undef, label [[LP]], label [[EXT:%.*]]
; CHECK:       ext:
; CHECK-NEXT:    ret void
;
  double * noalias %to,
  double %v1, double %v2) {
entry:
br label %lp

lp:
  %p = phi double [ 1.000000e+00, %lp ], [ 0.000000e+00, %entry ]
  %from_1 = getelementptr double, double *%from, i64 1
  %v0_1 = load double , double * %from
  %v0_2 = load double , double * %from_1
  %v1_1 = fadd double %v0_1, %p
  %v1_2 = fadd double %v0_1, %v0_2
  %to_2 = getelementptr double, double * %to, i64 1
  store double %v1_1, double *%to
  store double %v1_2, double *%to_2
br i1 undef, label %lp, label %ext

ext:
  ret void
}

define void @shuffle_preserve_broadcast2(double * noalias %from,
; CHECK-LABEL: @shuffle_preserve_broadcast2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LP:%.*]]
; CHECK:       lp:
; CHECK-NEXT:    [[P:%.*]] = phi double [ 1.000000e+00, [[LP]] ], [ 0.000000e+00, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[FROM_1:%.*]] = getelementptr double, double* [[FROM:%.*]], i32 1
; CHECK-NEXT:    [[V0_1:%.*]] = load double, double* [[FROM]], align 4
; CHECK-NEXT:    [[V0_2:%.*]] = load double, double* [[FROM_1]], align 4
; CHECK-NEXT:    [[TMP0:%.*]] = insertelement <2 x double> undef, double [[P]], i32 0
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <2 x double> [[TMP0]], double [[V0_2]], i32 1
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <2 x double> undef, double [[V0_1]], i32 0
; CHECK-NEXT:    [[TMP3:%.*]] = shufflevector <2 x double> [[TMP2]], <2 x double> undef, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP4:%.*]] = fadd <2 x double> [[TMP1]], [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = bitcast double* [[TO:%.*]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP4]], <2 x double>* [[TMP5]], align 4
; CHECK-NEXT:    br i1 undef, label [[LP]], label [[EXT:%.*]]
; CHECK:       ext:
; CHECK-NEXT:    ret void
;
  double * noalias %to,
  double %v1, double %v2) {
entry:
br label %lp

lp:
  %p = phi double [ 1.000000e+00, %lp ], [ 0.000000e+00, %entry ]
  %from_1 = getelementptr double, double *%from, i64 1
  %v0_1 = load double , double * %from
  %v0_2 = load double , double * %from_1
  %v1_1 = fadd double %p, %v0_1
  %v1_2 = fadd double %v0_2, %v0_1
  %to_2 = getelementptr double, double * %to, i64 1
  store double %v1_1, double *%to
  store double %v1_2, double *%to_2
br i1 undef, label %lp, label %ext

ext:
  ret void
}

define void @shuffle_preserve_broadcast3(double * noalias %from,
; CHECK-LABEL: @shuffle_preserve_broadcast3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LP:%.*]]
; CHECK:       lp:
; CHECK-NEXT:    [[P:%.*]] = phi double [ 1.000000e+00, [[LP]] ], [ 0.000000e+00, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[FROM_1:%.*]] = getelementptr double, double* [[FROM:%.*]], i32 1
; CHECK-NEXT:    [[V0_1:%.*]] = load double, double* [[FROM]], align 4
; CHECK-NEXT:    [[V0_2:%.*]] = load double, double* [[FROM_1]], align 4
; CHECK-NEXT:    [[TMP0:%.*]] = insertelement <2 x double> undef, double [[P]], i32 0
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <2 x double> [[TMP0]], double [[V0_2]], i32 1
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <2 x double> undef, double [[V0_1]], i32 0
; CHECK-NEXT:    [[TMP3:%.*]] = shufflevector <2 x double> [[TMP2]], <2 x double> undef, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP4:%.*]] = fadd <2 x double> [[TMP1]], [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = bitcast double* [[TO:%.*]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP4]], <2 x double>* [[TMP5]], align 4
; CHECK-NEXT:    br i1 undef, label [[LP]], label [[EXT:%.*]]
; CHECK:       ext:
; CHECK-NEXT:    ret void
;
  double * noalias %to,
  double %v1, double %v2) {
entry:
br label %lp

lp:
  %p = phi double [ 1.000000e+00, %lp ], [ 0.000000e+00, %entry ]
  %from_1 = getelementptr double, double *%from, i64 1
  %v0_1 = load double , double * %from
  %v0_2 = load double , double * %from_1
  %v1_1 = fadd double %p, %v0_1
  %v1_2 = fadd double %v0_1, %v0_2
  %to_2 = getelementptr double, double * %to, i64 1
  store double %v1_1, double *%to
  store double %v1_2, double *%to_2
br i1 undef, label %lp, label %ext

ext:
  ret void
}


define void @shuffle_preserve_broadcast4(double * noalias %from,
; CHECK-LABEL: @shuffle_preserve_broadcast4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LP:%.*]]
; CHECK:       lp:
; CHECK-NEXT:    [[P:%.*]] = phi double [ 1.000000e+00, [[LP]] ], [ 0.000000e+00, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[FROM_1:%.*]] = getelementptr double, double* [[FROM:%.*]], i32 1
; CHECK-NEXT:    [[V0_1:%.*]] = load double, double* [[FROM]], align 4
; CHECK-NEXT:    [[V0_2:%.*]] = load double, double* [[FROM_1]], align 4
; CHECK-NEXT:    [[TMP0:%.*]] = insertelement <2 x double> undef, double [[V0_2]], i32 0
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <2 x double> [[TMP0]], double [[P]], i32 1
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <2 x double> undef, double [[V0_1]], i32 0
; CHECK-NEXT:    [[TMP3:%.*]] = shufflevector <2 x double> [[TMP2]], <2 x double> undef, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP4:%.*]] = fadd <2 x double> [[TMP1]], [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = bitcast double* [[TO:%.*]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP4]], <2 x double>* [[TMP5]], align 4
; CHECK-NEXT:    br i1 undef, label [[LP]], label [[EXT:%.*]]
; CHECK:       ext:
; CHECK-NEXT:    ret void
;
  double * noalias %to,
  double %v1, double %v2) {
entry:
br label %lp

lp:
  %p = phi double [ 1.000000e+00, %lp ], [ 0.000000e+00, %entry ]
  %from_1 = getelementptr double, double *%from, i64 1
  %v0_1 = load double , double * %from
  %v0_2 = load double , double * %from_1
  %v1_1 = fadd double %v0_2, %v0_1
  %v1_2 = fadd double %p, %v0_1
  %to_2 = getelementptr double, double * %to, i64 1
  store double %v1_1, double *%to
  store double %v1_2, double *%to_2
br i1 undef, label %lp, label %ext

ext:
  ret void
}

define void @shuffle_preserve_broadcast5(double * noalias %from,
; CHECK-LABEL: @shuffle_preserve_broadcast5(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LP:%.*]]
; CHECK:       lp:
; CHECK-NEXT:    [[P:%.*]] = phi double [ 1.000000e+00, [[LP]] ], [ 0.000000e+00, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[FROM_1:%.*]] = getelementptr double, double* [[FROM:%.*]], i32 1
; CHECK-NEXT:    [[V0_1:%.*]] = load double, double* [[FROM]], align 4
; CHECK-NEXT:    [[V0_2:%.*]] = load double, double* [[FROM_1]], align 4
; CHECK-NEXT:    [[TMP0:%.*]] = insertelement <2 x double> undef, double [[V0_1]], i32 0
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <2 x double> [[TMP0]], <2 x double> undef, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <2 x double> undef, double [[V0_2]], i32 0
; CHECK-NEXT:    [[TMP3:%.*]] = insertelement <2 x double> [[TMP2]], double [[P]], i32 1
; CHECK-NEXT:    [[TMP4:%.*]] = fadd <2 x double> [[TMP1]], [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = bitcast double* [[TO:%.*]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP4]], <2 x double>* [[TMP5]], align 4
; CHECK-NEXT:    br i1 undef, label [[LP]], label [[EXT:%.*]]
; CHECK:       ext:
; CHECK-NEXT:    ret void
;
  double * noalias %to,
  double %v1, double %v2) {
entry:
br label %lp

lp:
  %p = phi double [ 1.000000e+00, %lp ], [ 0.000000e+00, %entry ]
  %from_1 = getelementptr double, double *%from, i64 1
  %v0_1 = load double , double * %from
  %v0_2 = load double , double * %from_1
  %v1_1 = fadd double %v0_1, %v0_2
  %v1_2 = fadd double %p, %v0_1
  %to_2 = getelementptr double, double * %to, i64 1
  store double %v1_1, double *%to
  store double %v1_2, double *%to_2
br i1 undef, label %lp, label %ext

ext:
  ret void
}


define void @shuffle_preserve_broadcast6(double * noalias %from,
; CHECK-LABEL: @shuffle_preserve_broadcast6(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LP:%.*]]
; CHECK:       lp:
; CHECK-NEXT:    [[P:%.*]] = phi double [ 1.000000e+00, [[LP]] ], [ 0.000000e+00, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[FROM_1:%.*]] = getelementptr double, double* [[FROM:%.*]], i32 1
; CHECK-NEXT:    [[V0_1:%.*]] = load double, double* [[FROM]], align 4
; CHECK-NEXT:    [[V0_2:%.*]] = load double, double* [[FROM_1]], align 4
; CHECK-NEXT:    [[TMP0:%.*]] = insertelement <2 x double> undef, double [[V0_1]], i32 0
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <2 x double> [[TMP0]], <2 x double> undef, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <2 x double> undef, double [[V0_2]], i32 0
; CHECK-NEXT:    [[TMP3:%.*]] = insertelement <2 x double> [[TMP2]], double [[P]], i32 1
; CHECK-NEXT:    [[TMP4:%.*]] = fadd <2 x double> [[TMP1]], [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = bitcast double* [[TO:%.*]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP4]], <2 x double>* [[TMP5]], align 4
; CHECK-NEXT:    br i1 undef, label [[LP]], label [[EXT:%.*]]
; CHECK:       ext:
; CHECK-NEXT:    ret void
;
  double * noalias %to,
  double %v1, double %v2) {
entry:
br label %lp

lp:
  %p = phi double [ 1.000000e+00, %lp ], [ 0.000000e+00, %entry ]
  %from_1 = getelementptr double, double *%from, i64 1
  %v0_1 = load double , double * %from
  %v0_2 = load double , double * %from_1
  %v1_1 = fadd double %v0_1, %v0_2
  %v1_2 = fadd double %v0_1, %p
  %to_2 = getelementptr double, double * %to, i64 1
  store double %v1_1, double *%to
  store double %v1_2, double *%to_2
br i1 undef, label %lp, label %ext

ext:
  ret void
}

; Make sure we don't scramble operands when we reorder them and destroy
; 'good' source order.

@a = common global [32000 x float] zeroinitializer, align 16

define void @good_load_order() {
; CHECK-LABEL: @good_load_order(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_COND1_PREHEADER:%.*]]
; CHECK:       for.cond1.preheader:
; CHECK-NEXT:    [[TMP0:%.*]] = load float, float* getelementptr inbounds ([32000 x float], [32000 x float]* @a, i32 0, i32 0), align 16
; CHECK-NEXT:    br label [[FOR_BODY3:%.*]]
; CHECK:       for.body3:
; CHECK-NEXT:    [[TMP1:%.*]] = phi float [ [[TMP0]], [[FOR_COND1_PREHEADER]] ], [ [[TMP14:%.*]], [[FOR_BODY3]] ]
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ 0, [[FOR_COND1_PREHEADER]] ], [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY3]] ]
; CHECK-NEXT:    [[TMP2:%.*]] = trunc i64 [[INDVARS_IV]] to i32
; CHECK-NEXT:    [[TMP3:%.*]] = add i32 [[TMP2]], 1
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds [32000 x float], [32000 x float]* @a, i32 0, i32 [[TMP3]]
; CHECK-NEXT:    [[TMP4:%.*]] = trunc i64 [[INDVARS_IV]] to i32
; CHECK-NEXT:    [[ARRAYIDX5:%.*]] = getelementptr inbounds [32000 x float], [32000 x float]* @a, i32 0, i32 [[TMP4]]
; CHECK-NEXT:    [[TMP5:%.*]] = trunc i64 [[INDVARS_IV]] to i32
; CHECK-NEXT:    [[TMP6:%.*]] = add i32 [[TMP5]], 4
; CHECK-NEXT:    [[ARRAYIDX31:%.*]] = getelementptr inbounds [32000 x float], [32000 x float]* @a, i32 0, i32 [[TMP6]]
; CHECK-NEXT:    [[TMP7:%.*]] = bitcast float* [[ARRAYIDX]] to <4 x float>*
; CHECK-NEXT:    [[TMP8:%.*]] = load <4 x float>, <4 x float>* [[TMP7]], align 4
; CHECK-NEXT:    [[TMP9:%.*]] = insertelement <4 x float> undef, float [[TMP1]], i32 0
; CHECK-NEXT:    [[TMP10:%.*]] = shufflevector <4 x float> [[TMP9]], <4 x float> [[TMP8]], <4 x i32> <i32 0, i32 4, i32 5, i32 6>
; CHECK-NEXT:    [[TMP11:%.*]] = fmul <4 x float> [[TMP8]], [[TMP10]]
; CHECK-NEXT:    [[TMP12:%.*]] = bitcast float* [[ARRAYIDX5]] to <4 x float>*
; CHECK-NEXT:    store <4 x float> [[TMP11]], <4 x float>* [[TMP12]], align 4
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 5
; CHECK-NEXT:    [[TMP13:%.*]] = trunc i64 [[INDVARS_IV_NEXT]] to i32
; CHECK-NEXT:    [[ARRAYIDX41:%.*]] = getelementptr inbounds [32000 x float], [32000 x float]* @a, i32 0, i32 [[TMP13]]
; CHECK-NEXT:    [[TMP14]] = load float, float* [[ARRAYIDX41]], align 4
; CHECK-NEXT:    [[TMP15:%.*]] = extractelement <4 x float> [[TMP8]], i32 3
; CHECK-NEXT:    [[MUL45:%.*]] = fmul float [[TMP14]], [[TMP15]]
; CHECK-NEXT:    store float [[MUL45]], float* [[ARRAYIDX31]], align 4
; CHECK-NEXT:    [[TMP16:%.*]] = trunc i64 [[INDVARS_IV_NEXT]] to i32
; CHECK-NEXT:    [[CMP2:%.*]] = icmp slt i32 [[TMP16]], 31995
; CHECK-NEXT:    br i1 [[CMP2]], label [[FOR_BODY3]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.cond1.preheader

for.cond1.preheader:
  %0 = load float, float* getelementptr inbounds ([32000 x float], [32000 x float]* @a, i64 0, i64 0), align 16
  br label %for.body3

for.body3:
  %1 = phi float [ %0, %for.cond1.preheader ], [ %10, %for.body3 ]
  %indvars.iv = phi i64 [ 0, %for.cond1.preheader ], [ %indvars.iv.next, %for.body3 ]
  %2 = add nsw i64 %indvars.iv, 1
  %arrayidx = getelementptr inbounds [32000 x float], [32000 x float]* @a, i64 0, i64 %2
  %3 = load float, float* %arrayidx, align 4
  %arrayidx5 = getelementptr inbounds [32000 x float], [32000 x float]* @a, i64 0, i64 %indvars.iv
  %mul6 = fmul float %3, %1
  store float %mul6, float* %arrayidx5, align 4
  %4 = add nsw i64 %indvars.iv, 2
  %arrayidx11 = getelementptr inbounds [32000 x float], [32000 x float]* @a, i64 0, i64 %4
  %5 = load float, float* %arrayidx11, align 4
  %mul15 = fmul float %5, %3
  store float %mul15, float* %arrayidx, align 4
  %6 = add nsw i64 %indvars.iv, 3
  %arrayidx21 = getelementptr inbounds [32000 x float], [32000 x float]* @a, i64 0, i64 %6
  %7 = load float, float* %arrayidx21, align 4
  %mul25 = fmul float %7, %5
  store float %mul25, float* %arrayidx11, align 4
  %8 = add nsw i64 %indvars.iv, 4
  %arrayidx31 = getelementptr inbounds [32000 x float], [32000 x float]* @a, i64 0, i64 %8
  %9 = load float, float* %arrayidx31, align 4
  %mul35 = fmul float %9, %7
  store float %mul35, float* %arrayidx21, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 5
  %arrayidx41 = getelementptr inbounds [32000 x float], [32000 x float]* @a, i64 0, i64 %indvars.iv.next
  %10 = load float, float* %arrayidx41, align 4
  %mul45 = fmul float %10, %9
  store float %mul45, float* %arrayidx31, align 4
  %11 = trunc i64 %indvars.iv.next to i32
  %cmp2 = icmp slt i32 %11, 31995
  br i1 %cmp2, label %for.body3, label %for.end

for.end:
  ret void
}

; Check vectorization of following code for double data type-
;  c[0] = a[0]+b[0];
;  c[1] = b[1]+a[1]; // swapped b[1] and a[1]

define void @load_reorder_double(double* nocapture %c, double* noalias nocapture readonly %a, double* noalias nocapture readonly %b){
; CHECK-LABEL: @load_reorder_double(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast double* [[B:%.*]] to <2 x double>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <2 x double>, <2 x double>* [[TMP1]], align 4
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast double* [[A:%.*]] to <2 x double>*
; CHECK-NEXT:    [[TMP4:%.*]] = load <2 x double>, <2 x double>* [[TMP3]], align 4
; CHECK-NEXT:    [[TMP5:%.*]] = fadd <2 x double> [[TMP4]], [[TMP2]]
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast double* [[C:%.*]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP5]], <2 x double>* [[TMP6]], align 4
; CHECK-NEXT:    ret void
;
  %1 = load double, double* %a
  %2 = load double, double* %b
  %3 = fadd double %1, %2
  store double %3, double* %c
  %4 = getelementptr inbounds double, double* %b, i64 1
  %5 = load double, double* %4
  %6 = getelementptr inbounds double, double* %a, i64 1
  %7 = load double, double* %6
  %8 = fadd double %5, %7
  %9 = getelementptr inbounds double, double* %c, i64 1
  store double %8, double* %9
  ret void
}

; Check vectorization of following code for float data type-
;  c[0] = a[0]+b[0];
;  c[1] = b[1]+a[1]; // swapped b[1] and a[1]
;  c[2] = a[2]+b[2];
;  c[3] = a[3]+b[3];

define void @load_reorder_float(float* nocapture %c, float* noalias nocapture readonly %a, float* noalias nocapture readonly %b){
; CHECK-LABEL: @load_reorder_float(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast float* [[A:%.*]] to <4 x float>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x float>, <4 x float>* [[TMP1]], align 4
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast float* [[B:%.*]] to <4 x float>*
; CHECK-NEXT:    [[TMP4:%.*]] = load <4 x float>, <4 x float>* [[TMP3]], align 4
; CHECK-NEXT:    [[TMP5:%.*]] = fadd <4 x float> [[TMP2]], [[TMP4]]
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast float* [[C:%.*]] to <4 x float>*
; CHECK-NEXT:    store <4 x float> [[TMP5]], <4 x float>* [[TMP6]], align 4
; CHECK-NEXT:    ret void
;
  %1 = load float, float* %a
  %2 = load float, float* %b
  %3 = fadd float %1, %2
  store float %3, float* %c
  %4 = getelementptr inbounds float, float* %b, i64 1
  %5 = load float, float* %4
  %6 = getelementptr inbounds float, float* %a, i64 1
  %7 = load float, float* %6
  %8 = fadd float %5, %7
  %9 = getelementptr inbounds float, float* %c, i64 1
  store float %8, float* %9
  %10 = getelementptr inbounds float, float* %a, i64 2
  %11 = load float, float* %10
  %12 = getelementptr inbounds float, float* %b, i64 2
  %13 = load float, float* %12
  %14 = fadd float %11, %13
  %15 = getelementptr inbounds float, float* %c, i64 2
  store float %14, float* %15
  %16 = getelementptr inbounds float, float* %a, i64 3
  %17 = load float, float* %16
  %18 = getelementptr inbounds float, float* %b, i64 3
  %19 = load float, float* %18
  %20 = fadd float %17, %19
  %21 = getelementptr inbounds float, float* %c, i64 3
  store float %20, float* %21
  ret void
}

; Check we properly reorder the below code so that it gets vectorized optimally-
; a[0] = (b[0]+c[0])+d[0];
; a[1] = d[1]+(b[1]+c[1]);
; a[2] = (b[2]+c[2])+d[2];
; a[3] = (b[3]+c[3])+d[3];

define void @opcode_reorder(float* noalias nocapture %a, float* noalias nocapture readonly %b,
; CHECK-LABEL: @opcode_reorder(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast float* [[B:%.*]] to <4 x float>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x float>, <4 x float>* [[TMP1]], align 4
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast float* [[C:%.*]] to <4 x float>*
; CHECK-NEXT:    [[TMP4:%.*]] = load <4 x float>, <4 x float>* [[TMP3]], align 4
; CHECK-NEXT:    [[TMP5:%.*]] = fadd <4 x float> [[TMP2]], [[TMP4]]
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast float* [[D:%.*]] to <4 x float>*
; CHECK-NEXT:    [[TMP7:%.*]] = load <4 x float>, <4 x float>* [[TMP6]], align 4
; CHECK-NEXT:    [[TMP8:%.*]] = fadd <4 x float> [[TMP5]], [[TMP7]]
; CHECK-NEXT:    [[TMP9:%.*]] = bitcast float* [[A:%.*]] to <4 x float>*
; CHECK-NEXT:    store <4 x float> [[TMP8]], <4 x float>* [[TMP9]], align 4
; CHECK-NEXT:    ret void
;
  float* noalias nocapture readonly %c,float* noalias nocapture readonly %d){
  %1 = load float, float* %b
  %2 = load float, float* %c
  %3 = fadd float %1, %2
  %4 = load float, float* %d
  %5 = fadd float %3, %4
  store float %5, float* %a
  %6 = getelementptr inbounds float, float* %d, i64 1
  %7 = load float, float* %6
  %8 = getelementptr inbounds float, float* %b, i64 1
  %9 = load float, float* %8
  %10 = getelementptr inbounds float, float* %c, i64 1
  %11 = load float, float* %10
  %12 = fadd float %9, %11
  %13 = fadd float %7, %12
  %14 = getelementptr inbounds float, float* %a, i64 1
  store float %13, float* %14
  %15 = getelementptr inbounds float, float* %b, i64 2
  %16 = load float, float* %15
  %17 = getelementptr inbounds float, float* %c, i64 2
  %18 = load float, float* %17
  %19 = fadd float %16, %18
  %20 = getelementptr inbounds float, float* %d, i64 2
  %21 = load float, float* %20
  %22 = fadd float %19, %21
  %23 = getelementptr inbounds float, float* %a, i64 2
  store float %22, float* %23
  %24 = getelementptr inbounds float, float* %b, i64 3
  %25 = load float, float* %24
  %26 = getelementptr inbounds float, float* %c, i64 3
  %27 = load float, float* %26
  %28 = fadd float %25, %27
  %29 = getelementptr inbounds float, float* %d, i64 3
  %30 = load float, float* %29
  %31 = fadd float %28, %30
  %32 = getelementptr inbounds float, float* %a, i64 3
  store float %31, float* %32
  ret void
}
