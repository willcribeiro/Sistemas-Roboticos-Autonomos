clc
clear
%Configura��o inicial de comunicacao
vrep=remApi('remoteApi')
vrep.simxFinish(-1);

clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5);
 if (clientID>-1)
     disp('Conectado')
     %-------------------------------------------Handle-----------------------------------------------------------------------------
     
     [returnCode,left_Motor]=vrep.simxGetObjectHandle(clientID,'LeftMotor',vrep.simx_opmode_blocking)
     [returnCode,right_Motor]=vrep.simxGetObjectHandle(clientID,'RigthMotor',vrep.simx_opmode_blocking)
     [returnCode,front_Sensor]=vrep.simxGetObjectHandle(clientID,'FrontUS',vrep.simx_opmode_blocking) %Primeira chamada
     [returnCode,carro]= vrep.simxGetObjectHandle(clientID,'RobotBase',vrep.simx_opmode_blocking)
     %------------------------------------------Other Code----------------------------------------------------------------------------
     %Movimentacao
     [returnCode]=vrep.simxSetJointTargetVelocity(clientID,left_Motor,0,vrep.simx_opmode_blocking);
     [returnCode]=vrep.simxSetJointTargetVelocity(clientID,right_Motor,0,vrep.simx_opmode_blocking);
     %Leitura sensor Ultra
     %[returnCode,detectionState,detectedPoint,~,~]=vrep.simxReadProximitySensor(clientID,front_Sensor,vrep.simx_opmode_streaming);
     
     %Posicao e orientacao do robo
     [returnCode,position]=vrep.simxGetObjectPosition(clientID,carro,-1,vrep.simx_opmode_streaming)
     [returnCode,angulo_robo]=vrep.simxGetObjectOrientation(clientID,carro,-1,vrep.simx_opmode_streaming)
      
     %Polinomio interpolador
     [X, Y, Theta, a, b, Mat] = poli_cubic([-2,-2,0],[2,2,45],0.01);
     
     k_theta = 6;
     k_l = 6;
     v = 0.5;
     rd =0.06;
     re = 0.06;
     B = 0.13;
     while true %tempo de movimenta��o
         
         %Parametro para pegar a posicao e orientacao
         [returnCode,position]=vrep.simxGetObjectPosition(clientID,carro,-1,vrep.simx_opmode_buffer); %(Retorna X,Y,Z)
         [~,angulo_robo]=vrep.simxGetObjectOrientation(clientID,carro,-1,vrep.simx_opmode_buffer)

         %Pega a dist�ncia pelo sensor
         %[returnCode,detectionState,detectedPoint,~,~]=vrep.simxReadProximitySensor(clientID,front_Sensor,vrep.simx_opmode_buffer); 
                          
         %calculo da menor dist�ncia do rob� a curva
         [ponto_curva, Delta_l, lambda] = distance2curve(Mat(:,1:2),[position(1),position(2)],'linear');
         
         Theta_robo = angulo_robo(3) + pi/2;

         %raio de giro
         dx = a(2) +2*a(3)*lambda + 3*a(4)*(lambda^2);
         dy = b(2) + 2*b(3)*lambda + 3*b(4)*(lambda^2);
         d2x = 2*a(3) + 6*a(4)*lambda;
         d2y = 2*b(3) + 6*b(4)*lambda;
         r = (((dx^2)+(dy^2))^1.5)/((d2y*dx)-(d2x*dy));
         k = (1/r);
         
         %delta theta
         theta_SF = atan((b(2) + 2*b(3)*(lambda) + 3*b(4)*(lambda^2))/(a(2) + 2*a(3)*(lambda) + 3*a(4)*(lambda^2)));
         Delta_theta = Theta_robo - theta_SF;
         
         %Controle
         u = -(k_theta*Delta_theta + (k_l*Delta_l*v*sin(Delta_theta)/Delta_theta));
         
         %Velocidade Angular
         var = ((k*v*cos(Delta_theta))/(1-(k*Delta_l)));
         w = u + var;
 
         %Velocidade das juntas
         wd = (v/rd) + (B/(2*rd))*w;
         we = (v/re) - (B/(2*re))*w;
         
         vrep.simxSetJointTargetVelocity(clientID,left_Motor,we,vrep.simx_opmode_blocking);
         vrep.simxSetJointTargetVelocity(clientID,right_Motor,wd,vrep.simx_opmode_blocking);
         
         if(lambda==1)
             break;
         end;
         
     end
     
     [returnCode]=vrep.simxSetJointTargetVelocity(clientID,left_Motor,0,vrep.simx_opmode_blocking);
     [returnCode]=vrep.simxSetJointTargetVelocity(clientID,right_Motor,0,vrep.simx_opmode_blocking);

     vrep.simxFinish(-1);
 end
 
 vrep.delete();