%	Example 1.3-1 Paper Airplane Flight Path
%	Copyright 2005 by Robert Stengel
%	August 23, 2005

	global CL CD S m g rho	
	S		=	0.017;			% Reference Area, m^2
	AR		=	0.86;			% Wing Aspect Ratio
	e		=	0.9;			% Oswald Efficiency Factor;
	m		=	0.003;			% Mass, kg
	g		=	9.8;			% Gravitational acceleration, m/s^2
	rho		=	1.225;			% Air density at Sea Level, kg/m^3	
	CLa		=	3.141592 * AR/(1 + sqrt(1 + (AR / 2)^2));
							% Lift-Coefficient Slope, per rad
	CDo		=	0.02;			% Zero-Lift Drag Coefficient
	epsilon	=	1 / (3.141592 * e * AR);% Induced Drag Factor	
	CL		=	sqrt(CDo / epsilon);	% CL for Maximum Lift/Drag Ratio
	CD		=	CDo + epsilon * CL^2;	% Corresponding CD
	LDmax	=	CL / CD;			% Maximum Lift/Drag Ratio
	Gam		=	-atan(1 / LDmax);	% Corresponding Flight Path Angle, rad
	V		=	sqrt(2 * m * g /(rho * S * (CL * cos(Gam) - CD * sin(Gam))));
							% Corresponding Velocity, m/s
	Alpha	=	CL / CLa;			% Corresponding Angle of Attack, rad
	
%	a) Equilibrium Glide at Maximum Lift/Drag Ratio
	H		=	2;			% Initial Height, m
	R		=	0;			% Initial Range, m
	to		=	0;			% Initial Time, sec
	tf		=	6;			% Final Time, sec
	tspan	=	[to tf];
	xo		=	[V;Gam;H;R];
	[ta,xa]	=	ode23('EqMotion',tspan,xo);
	
%	b) Oscillating Glide due to Zero Initial Flight Path Angle
	xo		=	[V;0;H;R];
	[tb,xb]	=	ode23('EqMotion',tspan,xo);

%	c) Effect of Increased Initial Velocity
	xo		=	[1.5*V;0;H;R];
	[tc,xc]	=	ode23('EqMotion',tspan,xo);

%	d) Effect of Further Increase in Initial Velocity
	xo  	=   [3*V;0;H;R];
	[td,xd]	=	ode23('EqMotion',tspan,xo);

% 2
    xo = [2;Gam;H;R];
    [te,xe] = ode23('EqMotion',tspan,xo);
    xo = [7.5;Gam;H;R];
    [tf,xf] = ode23('EqMotion',tspan,xo);
    xo = [3.55;Gam;H;R];
    [tg,xg] = ode23('EqMotion',tspan,xo);
    
    xo = [V;-0.5;H;R];
    [th,xh] = ode23('EqMotion',tspan,xo);
    xo = [V;0.4;H;R];
    [ti,xi] = ode23('EqMotion',tspan,xo);
    xo = [V;-0.18;H;R];
    [tj,xj] = ode23('EqMotion',tspan,xo);
    

% 3 and 4
    step = transpose(0:0.05:6);
    time = [];
    Range = [];
    Height = [];
    
    for i = 1:100
        V_r = 2.5+(7.5-2.5)*rand(1);
        Gam_r = -0.5+(0.4+0.5)*rand(1);
        xo = [V_r;Gam_r;H;R];
        [tr, xr] = ode23('EqMotion',step,xo);
        Range = [Range, transpose(xr(:,4))];
        Height = [Height, transpose(xr(:,3))];
        time = [time, transpose(step)];
        plot(xr(:,4),xr(:,3), 'r')
        hold on
        xlabel('Range, m'), ylabel('Height, m'), grid
    end
    
    Range = Range';
    Height = Height';
    time = time';

% 5 
    p1 = polyfit(time, Height, 6);
    p2 = polyfit(time, Range, 6);
    time_array = 0:0.05:6;
    height_fit = polyval(p1, time_array);
    range_fit = polyval(p2, time_array);
    plot(range_fit, height_fit, 'k')


    % figure
    % subplot(2,1,1)
    % plot(xe(:,4),xe(:,3), 'r')
    % hold on
    % plot(xf(:,4),xf(:,3), 'g')
    % plot(xg(:,4),xg(:,3), 'k')
    % xlabel('Range, m'), ylabel('Height, m'), grid
    % subplot(2,1,2)
    % plot(xh(:,4),xh(:,3), 'r')
    % hold on
    % plot(xi(:,4),xi(:,3), 'g')
    % plot(xj(:,4),xj(:,3), 'k')
	% xlabel('Range, m'), ylabel('Height, m'), grid
    % 
	% figure
	% plot(xa(:,4),xa(:,3),xb(:,4),xb(:,3),xc(:,4),xc(:,3),xd(:,4),xd(:,3))
	% xlabel('Range, m'), ylabel('Height, m'), grid
    % 
	% figure
	% subplot(2,2,1)
	% plot(ta,xa(:,1),tb,xb(:,1),tc,xc(:,1),td,xd(:,1))
	% xlabel('Time, s'), ylabel('Velocity, m/s'), grid
	% subplot(2,2,2)
	% plot(ta,xa(:,2),tb,xb(:,2),tc,xc(:,2),td,xd(:,2))
	% xlabel('Time, s'), ylabel('Flight Path Angle, rad'), grid
	% subplot(2,2,3)
	% plot(ta,xa(:,3),tb,xb(:,3),tc,xc(:,3),td,xd(:,3))
	% xlabel('Time, s'), ylabel('Altitude, m'), grid
	% subplot(2,2,4)
	% plot(ta,xa(:,4),tb,xb(:,4),tc,xc(:,4),td,xd(:,4))
	% xlabel('Time, s'), ylabel('Range, m'), grid
