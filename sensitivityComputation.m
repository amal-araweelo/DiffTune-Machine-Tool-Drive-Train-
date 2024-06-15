% This function defines how the sensitivity propgation runs at each sample
% time

% Inputs
% dxdtheta_current: dxdtheta (sensitivity)
% X: actual state, [omega_m; omega_l; theta_m; theta_l]
% Xref: desired/reference state, [omega_m; omega_l; theta_m; theta_r]
% u: torque command (output of controller, input to system)
% J_m: moment of inertia (from motor mechanical parameters)
% theta: controller gains, k_vec = [k1; k2; k_pos]
% dt: sample time (taken from simulation parameter)

% Outputs
% dXdphi: calculated sensitivity
% dudphi: calculated sensitivity

function [dXdphi,dudphi] = sensitivityComputation(dxdtheta_current, X, Xref, theta_r_dot, theta_r_2dot, u, param, k_vec, dt, v)

% Evaluate the Jacobians
dfdX = grad_f_X_fcn(X, dt, u, param(1), param(2), param(3), param(4), param(5), param(6), param(7), param(8), param(9));
dfdX = full(dfdX);    % full() converts sparse matrix to full matrix

% fprintf('dfdX = \n');
% disp(dfdX);

dfdu = grad_f_u_fcn(X, dt, u, param(1), param(2), param(3), param(4), param(5), param(6), param(7), param(8), param(9));
dfdu = full(dfdu);

% fprintf('dfdu = \n');
% disp(dfdu);

dhdX = grad_h_X_fcn(X, Xref, k_vec, theta_r_dot, theta_r_2dot, param(1), param(2), dt, v);
dhdX = full(dhdX);

% fprintf('dhdX = \n');
% disp(dhdX);

dhdtheta = grad_h_theta_fcn(X, Xref, k_vec, theta_r_dot, theta_r_2dot, param(1), param(2), dt, v);
dhdtheta = full(dhdtheta);

% fprintf('dhdtheta = \n');
% disp(dhdtheta);

% Assemble the Jacobians to compute the sensitivity
dXdphi = (dfdX + dfdu * dhdX) * dxdtheta_current + dfdu * dhdtheta;
dudphi = dhdX * dxdtheta_current + dhdtheta;

end
