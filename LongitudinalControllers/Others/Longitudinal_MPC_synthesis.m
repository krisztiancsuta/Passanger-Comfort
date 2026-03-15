function [Kmpc, Ky, H, Phi_F, Phi_R, A_e, B_e, C_e, Ad, Bd, Cd] = ...
	Longitudinal_MPC_synthesis(Ts, Nc, Np, rw, mass, b_lin)
%LONGITUDINAL_MPC_SYNTHESIS  Build longitudinal MPC gains and matrices.
%
%  [Kmpc, Ky, H, Phi_F, Phi_R, A_e, B_e, C_e, Ad, Bd, Cd] = ...
%      Longitudinal_MPC_synthesis(Ts, Nc, Np, rw, mass, b_lin)
%
%  Plant model (continuous-time):
%      v_dot = -(b_lin/mass) * v + (1/mass) * u
%
%  Inputs:
%    Ts    - sample time [s]
%    Nc    - control horizon
%    Np    - prediction horizon
%    rw    - control increment penalty
%    mass  - equivalent vehicle mass [kg]
%    b_lin - linearized drag coefficient [N/(m/s)]
%
%  Outputs:
%    Kmpc  - unconstrained MPC state feedback gain (first move)
%    Ky    - unconstrained MPC reference gain (first move)
%    H     - QP Hessian (Phi_Phi + rw*I)
%    Phi_F, Phi_R, A_e, B_e, C_e - MPC prediction/augmented matrices
%    Ad, Bd, Cd - discrete plant matrices

	% Continuous-time scalar plant.
	A = -b_lin / mass;
	B = 1 / mass;
	C = 1;

	c_ss = ss(A, B, C, 0);
	d_ss = c2d(c_ss, Ts);

	Ad = d_ss.A;
	Bd = d_ss.B;
	Cd = d_ss.C;

	[Phi_Phi, Phi_F, Phi_R, A_e, B_e, C_e, ~, ~] = mpcgain(Ad, Bd, Cd, Nc, Np);
	[~, n_in] = size(Bd);

	H = Phi_Phi + rw * eye(Nc * n_in);

	Kmpc = H \ Phi_F;
	Ky   = H \ Phi_R;

	Kmpc = Kmpc(1:n_in, :);
	Ky   = Ky(1:n_in, :);
end