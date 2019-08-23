%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                                 %
% This file is part of HPIPM.                                                                     %
%                                                                                                 %
% HPIPM -- High-Performance Interior Point Method.                                                %
% Copyright (C) 2019 by Gianluca Frison.                                                          %
% Developed at IMTEK (University of Freiburg) under the supervision of Moritz Diehl.              %
% All rights reserved.                                                                            %
%                                                                                                 %
% The 2-Clause BSD License                                                                        %
%                                                                                                 %
% Redistribution and use in source and binary forms, with or without                              %
% modification, are permitted provided that the following conditions are met:                     %
%                                                                                                 %
% 1. Redistributions of source code must retain the above copyright notice, this                  %
%    list of conditions and the following disclaimer.                                             %
% 2. Redistributions in binary form must reproduce the above copyright notice,                    %
%    this list of conditions and the following disclaimer in the documentation                    %
%    and/or other materials provided with the distribution.                                       %
%                                                                                                 %
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND                 %
% ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED                   %
% WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE                          %
% DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR                 %
% ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES                  %
% (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;                    %
% LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND                     %
% ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT                      %
% (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS                   %
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.                                    %
%                                                                                                 %
% Author: Gianluca Frison, gianluca.frison (at) imtek.uni-freiburg.de                             %
%                                                                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
clc



fprintf('\nHPIPM matlab interface: example from qp_data.c\n');



% check that env.sh has been run
env_run = getenv('ENV_RUN');
if (~strcmp(env_run, 'true'))
	disp('ERROR: env.sh has not been sourced! Before executing this example, run:');
	disp('source env.sh');
	return;
end



%%% dim %%%
%dim = hpipm_ocp_qp_dim(5);
dim = hpipm_ocp_qp_dim('qp_data.c');

% print to shell
%dim.print_C_struct();

% extract dims
N = dim.get('N');
nx = dim.get('nx', 0);
nu = dim.get('nu', 0);



%%% qp %%%
qp = hpipm_ocp_qp(dim, 'qp_data.c');

% print to shell
%qp.print_C_struct();



%%% sol %%%
sol = hpipm_ocp_qp_sol(dim);



%%% solver arg %%%
arg = hpipm_ocp_qp_solver_arg(dim, 'qp_data.c');



%%% solver %%%
solver = hpipm_ocp_qp_solver(dim, arg);

% arg which are allowed to be changed
solver.set('iter_max', 30);
arg.set('tol_stat', 1e-8);
arg.set('tol_eq', 1e-8);
arg.set('tol_ineq', 1e-8);
arg.set('tol_comp', 1e-8);

% solve qp
nrep = 100;
tic
for rep=1:nrep
	solver.solve(qp, sol);
end
solve_time = toc;

% get solution statistics
fprintf('\nprint solver statistics\n');
status = solver.get('status')
fprintf('average solve time over %d runs: %e [s]\n', nrep, solve_time/nrep);
time_ext = solver.get('time_ext');
fprintf('solve time of last run (measured in mex interface): %e [s]\n', time_ext);
iter = solver.get('iter')
res_stat = solver.get('max_res_stat')
res_eq = solver.get('max_res_eq')
res_ineq = solver.get('max_res_ineq')
res_comp = solver.get('max_res_comp')
stat = solver.get('stat');
fprintf('iter\talpha_aff\tmu_aff\t\tsigma\t\talpha\t\tmu\t\tres_stat\tres_eq\t\tres_ineq\tres_comp\n');
for ii=1:iter+1
	fprintf('%d\t%e\t%e\t%e\t%e\t%e\t%e\t%e\t%e\t%e\n', stat(ii,1), stat(ii,2), stat(ii,3), stat(ii,4), stat(ii,5), stat(ii,6), stat(ii,7), stat(ii,8), stat(ii,9), stat(ii,10));
end



% get / print solution
% x
x = sol.get('x', 0, N);
x = reshape(x, nx, N+1);
% u
u = sol.get('u', 0, N-1);
u = reshape(u, nu, N);

%x
%u

% print to shell
%sol.print_C_struct();



% plot solution
figure()
subplot(2, 1, 1)
plot(0:N, x);
title('trajectory')
ylabel('x')
subplot(2, 1, 2)
plot(1:N, u);
ylabel('u')
xlabel('sample')



if status==0
	fprintf('\nsuccess!\n\n');
else
	fprintf('\nsolution failed!\n\n');
end



if is_octave()
	% directly call destructor for octave 4.2.2 (ubuntu 18.04) + others ???
	if strcmp(version(), '4.2.2')
		delete(dim);
		delete(qp);
		delete(sol);
		delete(arg);
		delete(solver);
	end
end



waitforbuttonpress;



return


