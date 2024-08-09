function p = parameters()

    p.m = 0.5;
    p.L = 0.225;
    p.k = 0.01;
    p.b = 0.001;
    p.D = diag([0.01,0.01,0.01]);
    p.I = diag([3e-6, 3e-6, 1e-5]);
    p.Euler = [0;0;0];
    p.pos = [0;0;0];
    p.ORIENTATION_linear = [p.Euler];
    p.POSITION_linear = [p.pos];
    p.POSITION_nonlinear  = [p.pos];
    p.ORIENTATION_nonlinear =  [p.Euler];
    p.dEuler = [0;0;0];
    p.dp = [0;0;0];
    p.g = [0;0;-9.81];
    p.w = [1, 0, -sin(p.Euler(2));
        0, cos(p.Euler(1)), cos(p.Euler(2))*sin(p.Euler(1));
        0, -sin(p.Euler(1)), cos(p.Euler(2))*cos(p.Euler(1))]*p.dEuler;


end
