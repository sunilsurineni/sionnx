/*
 * Copyright (C) 2017-2019 Alibaba Group Holding Limited
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

include "onnx_instr.td"

def ReshapeOp : Instruction<[op_reshape],
                        [],
                        [IOType<0, [f32, f16, f64, i8, i16, i32, i64, ui8, ui16, ui32, ui64, i1, str, complex64, complex128]>,
                         IOType<1, [i64]>],
                        [IOType<0, [f32, f16, f64, i8, i16, i32, i64, ui8, ui16, ui32, ui64, i1, str, complex64, complex128]>]>;


