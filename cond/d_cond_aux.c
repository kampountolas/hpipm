/**************************************************************************************************
*                                                                                                 *
* This file is part of HPIPM.                                                                     *
*                                                                                                 *
* HPIPM -- High-Performance Interior Point Method.                                                *
* Copyright (C) 2017-2018 by Gianluca Frison.                                                     *
* Developed at IMTEK (University of Freiburg) under the supervision of Moritz Diehl.              *
* All rights reserved.                                                                            *
*                                                                                                 *
* This program is free software: you can redistribute it and/or modify                            *
* it under the terms of the GNU General Public License as published by                            *
* the Free Software Foundation, either version 3 of the License, or                               *
* (at your option) any later version                                                              *.
*                                                                                                 *
* This program is distributed in the hope that it will be useful,                                 *
* but WITHOUT ANY WARRANTY; without even the implied warranty of                                  *
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                                   *
* GNU General Public License for more details.                                                    *
*                                                                                                 *
* You should have received a copy of the GNU General Public License                               *
* along with this program.  If not, see <https://www.gnu.org/licenses/>.                          *
*                                                                                                 *
* The authors designate this particular file as subject to the "Classpath" exception              *
* as provided by the authors in the LICENSE file that accompained this code.                      *
*                                                                                                 *
* Author: Gianluca Frison, gianluca.frison (at) imtek.uni-freiburg.de                             *
*                                                                                                 *
**************************************************************************************************/

#include <math.h>
#include <stdlib.h>
#include <stdio.h>

#include <blasfeo_target.h>
#include <blasfeo_common.h>
#include <blasfeo_d_blas.h>
#include <blasfeo_d_aux.h>

#include "../include/hpipm_d_ocp_qp.h"
#include "../include/hpipm_d_ocp_qp_sol.h"
#include "../include/hpipm_d_dense_qp.h"
#include "../include/hpipm_d_dense_qp_sol.h"
#include "../include/hpipm_d_cond.h"



#define AXPY blasfeo_daxpy
#define COND_QP_OCP2DENSE_ARG d_cond_qp_ocp2dense_arg
#define COND_QP_OCP2DENSE_WORKSPACE d_cond_qp_ocp2dense_workspace
#define DENSE_QP_SOL d_dense_qp_sol
#define GEAD blasfeo_dgead
#define GECP blasfeo_dgecp
#define GEEX1 blasfeo_dgeex1
#define GESE blasfeo_dgese
#define GEMM_NN blasfeo_dgemm_nn
#define GEMV_T blasfeo_dgemv_t
#define GEMV_N blasfeo_dgemv_n
#define OCP_QP d_ocp_qp
#define OCP_QP_SOL d_ocp_qp_sol
#define POTRF_L_MN blasfeo_dpotrf_l_mn
#define REAL double
#define ROWAD blasfeo_drowad
#define ROWEX blasfeo_drowex
#define ROWIN blasfeo_drowin
#define STRMAT blasfeo_dmat
#define STRVEC blasfeo_dvec
#define SYMV_L blasfeo_dsymv_l
#define SYRK_LN_MN blasfeo_dsyrk_ln_mn
#define TRCP_L blasfeo_dtrcp_l
#define TRMM_RLNN blasfeo_dtrmm_rlnn
#define VECCP blasfeo_dveccp

#define COND_BABT d_cond_BAbt
#define COND_B d_cond_b
#define COND_RSQRQ_N2NX3 d_cond_RSQrq_N2nx3
#define COND_RQ_N2NX3 d_cond_rq_N2nx3
#define COND_DCTD d_cond_DCtd
#define COND_D d_cond_d
#define EXPAND_SOL d_expand_sol
#define EXPAND_PRIMAL_SOL d_expand_primal_sol
#define UPDATE_COND_BABT d_update_cond_BAbt
#define UPDATE_COND_RSQRQ_N2NX3 d_update_cond_RSQrq_N2nx3
#define UPDATE_COND_DCTD d_update_cond_DCtd



#include "x_cond_aux.c"
