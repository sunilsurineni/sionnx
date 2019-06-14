; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basicaa -slp-vectorizer -dce -S -mtriple=x86_64-apple-macosx10.8.0 -mcpu=corei7 | FileCheck %s

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.8.0"

%struct._exon_t.12.103.220.363.480.649.740.857.1039.1065.1078.1091.1117.1130.1156.1169.1195.1221.1234.1286.1299.1312.1338.1429.1455.1468.1494.1520.1884.1897.1975.2066.2105.2170.2171 = type { i32, i32, i32, i32, i32, i32, [8 x i8] }

define void @SIM4() {
; CHECK-LABEL: @SIM4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 undef, label [[RETURN:%.*]], label [[LOR_LHS_FALSE:%.*]]
; CHECK:       lor.lhs.false:
; CHECK-NEXT:    br i1 undef, label [[RETURN]], label [[IF_END:%.*]]
; CHECK:       if.end:
; CHECK-NEXT:    br i1 undef, label [[FOR_END605:%.*]], label [[FOR_BODY_LR_PH:%.*]]
; CHECK:       for.body.lr.ph:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    br i1 undef, label [[FOR_INC603:%.*]], label [[IF_END12:%.*]]
; CHECK:       if.end12:
; CHECK-NEXT:    br i1 undef, label [[LAND_LHS_TRUE:%.*]], label [[LAND_LHS_TRUE167:%.*]]
; CHECK:       land.lhs.true:
; CHECK-NEXT:    br i1 undef, label [[IF_THEN17:%.*]], label [[LAND_LHS_TRUE167]]
; CHECK:       if.then17:
; CHECK-NEXT:    br i1 undef, label [[IF_END98:%.*]], label [[LAND_RHS_LR_PH:%.*]]
; CHECK:       land.rhs.lr.ph:
; CHECK-NEXT:    unreachable
; CHECK:       if.end98:
; CHECK-NEXT:    br i1 undef, label [[LAND_LHS_TRUE167]], label [[IF_THEN103:%.*]]
; CHECK:       if.then103:
; CHECK-NEXT:    [[DOTSUB100:%.*]] = select i1 undef, i32 250, i32 undef
; CHECK-NEXT:    [[MUL114:%.*]] = shl nsw i32 [[DOTSUB100]], 2
; CHECK-NEXT:    [[FROM1115:%.*]] = getelementptr inbounds [[STRUCT__EXON_T_12_103_220_363_480_649_740_857_1039_1065_1078_1091_1117_1130_1156_1169_1195_1221_1234_1286_1299_1312_1338_1429_1455_1468_1494_1520_1884_1897_1975_2066_2105_2170_2171:%.*]], %struct._exon_t.12.103.220.363.480.649.740.857.1039.1065.1078.1091.1117.1130.1156.1169.1195.1221.1234.1286.1299.1312.1338.1429.1455.1468.1494.1520.1884.1897.1975.2066.2105.2170.2171* undef, i64 0, i32 0
; CHECK-NEXT:    [[COND125:%.*]] = select i1 undef, i32 undef, i32 [[MUL114]]
; CHECK-NEXT:    [[TMP0:%.*]] = insertelement <2 x i32> undef, i32 [[COND125]], i32 0
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <2 x i32> [[TMP0]], i32 [[DOTSUB100]], i32 1
; CHECK-NEXT:    br label [[FOR_COND_I:%.*]]
; CHECK:       for.cond.i:
; CHECK-NEXT:    [[TMP2:%.*]] = phi <2 x i32> [ undef, [[LAND_RHS_I874:%.*]] ], [ [[TMP1]], [[IF_THEN103]] ]
; CHECK-NEXT:    br i1 undef, label [[LAND_RHS_I874]], label [[FOR_END_I:%.*]]
; CHECK:       land.rhs.i874:
; CHECK-NEXT:    br i1 undef, label [[FOR_COND_I]], label [[FOR_END_I]]
; CHECK:       for.end.i:
; CHECK-NEXT:    br i1 undef, label [[IF_THEN_I:%.*]], label [[IF_END_I:%.*]]
; CHECK:       if.then.i:
; CHECK-NEXT:    [[TMP3:%.*]] = add nsw <2 x i32> undef, [[TMP2]]
; CHECK-NEXT:    br label [[EXTEND_BW_EXIT:%.*]]
; CHECK:       if.end.i:
; CHECK-NEXT:    [[ADD16_I:%.*]] = add i32 [[COND125]], [[DOTSUB100]]
; CHECK-NEXT:    [[CMP26514_I:%.*]] = icmp slt i32 [[ADD16_I]], 0
; CHECK-NEXT:    br i1 [[CMP26514_I]], label [[FOR_END33_I:%.*]], label [[FOR_BODY28_LR_PH_I:%.*]]
; CHECK:       for.body28.lr.ph.i:
; CHECK-NEXT:    br label [[FOR_END33_I]]
; CHECK:       for.end33.i:
; CHECK-NEXT:    br i1 undef, label [[FOR_END58_I:%.*]], label [[FOR_BODY52_LR_PH_I:%.*]]
; CHECK:       for.body52.lr.ph.i:
; CHECK-NEXT:    br label [[FOR_END58_I]]
; CHECK:       for.end58.i:
; CHECK-NEXT:    br label [[WHILE_COND260_I:%.*]]
; CHECK:       while.cond260.i:
; CHECK-NEXT:    br i1 undef, label [[LAND_RHS263_I:%.*]], label [[WHILE_END275_I:%.*]]
; CHECK:       land.rhs263.i:
; CHECK-NEXT:    br i1 undef, label [[WHILE_COND260_I]], label [[WHILE_END275_I]]
; CHECK:       while.end275.i:
; CHECK-NEXT:    br label [[EXTEND_BW_EXIT]]
; CHECK:       extend_bw.exit:
; CHECK-NEXT:    [[TMP4:%.*]] = phi <2 x i32> [ [[TMP3]], [[IF_THEN_I]] ], [ undef, [[WHILE_END275_I]] ]
; CHECK-NEXT:    br i1 false, label [[IF_THEN157:%.*]], label [[LAND_LHS_TRUE167]]
; CHECK:       if.then157:
; CHECK-NEXT:    [[TMP5:%.*]] = add nsw <2 x i32> <i32 1, i32 1>, [[TMP4]]
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast i32* [[FROM1115]] to <2 x i32>*
; CHECK-NEXT:    store <2 x i32> [[TMP5]], <2 x i32>* [[TMP6]], align 4
; CHECK-NEXT:    br label [[LAND_LHS_TRUE167]]
; CHECK:       land.lhs.true167:
; CHECK-NEXT:    unreachable
; CHECK:       for.inc603:
; CHECK-NEXT:    br i1 undef, label [[FOR_BODY]], label [[FOR_END605]]
; CHECK:       for.end605:
; CHECK-NEXT:    unreachable
; CHECK:       return:
; CHECK-NEXT:    ret void
;
entry:
  br i1 undef, label %return, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %entry
  br i1 undef, label %return, label %if.end

if.end:                                           ; preds = %lor.lhs.false
  br i1 undef, label %for.end605, label %for.body.lr.ph

for.body.lr.ph:                                   ; preds = %if.end
  br label %for.body

for.body:                                         ; preds = %for.inc603, %for.body.lr.ph
  br i1 undef, label %for.inc603, label %if.end12

if.end12:                                         ; preds = %for.body
  br i1 undef, label %land.lhs.true, label %land.lhs.true167

land.lhs.true:                                    ; preds = %if.end12
  br i1 undef, label %if.then17, label %land.lhs.true167

if.then17:                                        ; preds = %land.lhs.true
  br i1 undef, label %if.end98, label %land.rhs.lr.ph

land.rhs.lr.ph:                                   ; preds = %if.then17
  unreachable

if.end98:                                         ; preds = %if.then17
  %from299 = getelementptr inbounds %struct._exon_t.12.103.220.363.480.649.740.857.1039.1065.1078.1091.1117.1130.1156.1169.1195.1221.1234.1286.1299.1312.1338.1429.1455.1468.1494.1520.1884.1897.1975.2066.2105.2170.2171, %struct._exon_t.12.103.220.363.480.649.740.857.1039.1065.1078.1091.1117.1130.1156.1169.1195.1221.1234.1286.1299.1312.1338.1429.1455.1468.1494.1520.1884.1897.1975.2066.2105.2170.2171* undef, i64 0, i32 1
  br i1 undef, label %land.lhs.true167, label %if.then103

if.then103:                                       ; preds = %if.end98
  %.sub100 = select i1 undef, i32 250, i32 undef
  %mul114 = shl nsw i32 %.sub100, 2
  %from1115 = getelementptr inbounds %struct._exon_t.12.103.220.363.480.649.740.857.1039.1065.1078.1091.1117.1130.1156.1169.1195.1221.1234.1286.1299.1312.1338.1429.1455.1468.1494.1520.1884.1897.1975.2066.2105.2170.2171, %struct._exon_t.12.103.220.363.480.649.740.857.1039.1065.1078.1091.1117.1130.1156.1169.1195.1221.1234.1286.1299.1312.1338.1429.1455.1468.1494.1520.1884.1897.1975.2066.2105.2170.2171* undef, i64 0, i32 0
  %cond125 = select i1 undef, i32 undef, i32 %mul114
  br label %for.cond.i

for.cond.i:                                       ; preds = %land.rhs.i874, %if.then103
  %row.0.i = phi i32 [ undef, %land.rhs.i874 ], [ %.sub100, %if.then103 ]
  %col.0.i = phi i32 [ undef, %land.rhs.i874 ], [ %cond125, %if.then103 ]
  br i1 undef, label %land.rhs.i874, label %for.end.i

land.rhs.i874:                                    ; preds = %for.cond.i
  br i1 undef, label %for.cond.i, label %for.end.i

for.end.i:                                        ; preds = %land.rhs.i874, %for.cond.i
  br i1 undef, label %if.then.i, label %if.end.i

if.then.i:                                        ; preds = %for.end.i
  %add14.i = add nsw i32 %row.0.i, undef
  %add15.i = add nsw i32 %col.0.i, undef
  br label %extend_bw.exit

if.end.i:                                         ; preds = %for.end.i
  %add16.i = add i32 %cond125, %.sub100
  %cmp26514.i = icmp slt i32 %add16.i, 0
  br i1 %cmp26514.i, label %for.end33.i, label %for.body28.lr.ph.i

for.body28.lr.ph.i:                               ; preds = %if.end.i
  br label %for.end33.i

for.end33.i:                                      ; preds = %for.body28.lr.ph.i, %if.end.i
  br i1 undef, label %for.end58.i, label %for.body52.lr.ph.i

for.body52.lr.ph.i:                               ; preds = %for.end33.i
  br label %for.end58.i

for.end58.i:                                      ; preds = %for.body52.lr.ph.i, %for.end33.i
  br label %while.cond260.i

while.cond260.i:                                  ; preds = %land.rhs263.i, %for.end58.i
  br i1 undef, label %land.rhs263.i, label %while.end275.i

land.rhs263.i:                                    ; preds = %while.cond260.i
  br i1 undef, label %while.cond260.i, label %while.end275.i

while.end275.i:                                   ; preds = %land.rhs263.i, %while.cond260.i
  br label %extend_bw.exit

extend_bw.exit:                                   ; preds = %while.end275.i, %if.then.i
  %add14.i1262 = phi i32 [ %add14.i, %if.then.i ], [ undef, %while.end275.i ]
  %add15.i1261 = phi i32 [ %add15.i, %if.then.i ], [ undef, %while.end275.i ]
  br i1 false, label %if.then157, label %land.lhs.true167

if.then157:                                       ; preds = %extend_bw.exit
  %add158 = add nsw i32 %add14.i1262, 1
  store i32 %add158, i32* %from299, align 4
  %add160 = add nsw i32 %add15.i1261, 1
  store i32 %add160, i32* %from1115, align 4
  br label %land.lhs.true167

land.lhs.true167:                                 ; preds = %if.then157, %extend_bw.exit, %if.end98, %land.lhs.true, %if.end12
  unreachable

for.inc603:                                       ; preds = %for.body
  br i1 undef, label %for.body, label %for.end605

for.end605:                                       ; preds = %for.inc603, %if.end
  unreachable

return:                                           ; preds = %lor.lhs.false, %entry
  ret void
}

