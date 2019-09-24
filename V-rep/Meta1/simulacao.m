clc
clear
%Configuração inicial de comunicacao
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
     [returnCode]=vrep.simxSetJointTargetVelocity(clientID,left_Motor,3,vrep.simx_opmode_blocking);
     [returnCode]=vrep.simxSetJointTargetVelocity(clientID,right_Motor,3,vrep.simx_opmode_blocking);
     %Leitura sensor Ultra
     %[returnCode,detectionState,detectedPoint,~,~]=vrep.simxReadProximitySensor(clientID,front_Sensor,vrep.simx_opmode_streaming);
     
     %Posicao e orientacao do robo
     [returnCode,position]=vrep.simxGetObjectPosition(clientID,carro,-1,vrep.simx_opmode_streaming)
     [returnCode,angulo_robo]=vrep.simxGetObjectOrientation(clientID,carro,-1,vrep.simx_opmode_streaming)
      
     %Polinomio interpolador
     [X, Y, Theta, a, b] = poli_cubic([-2,-2,0],[2,2,45],0.01);
     
     for i=1:250 %tempo de movimentação
         
         %Parametro para pegar a posicao e orientacao
         [returnCode,position]=vrep.simxGetObjectPosition(clientID,carro,-1,vrep.simx_opmode_buffer); %(Retorna X,Y,Z)
         [returnCode,angulo_robo]=vrep.simxGetObjectOrientation(clientID,carro,-1,vrep.simx_opmode_buffer)

         %Pega a distância pelo sensor
         %[returnCode,detectionState,detectedPoint,~,~]=vrep.simxReadProximitySensor(clientID,front_Sensor,vrep.simx_opmode_buffer); 
         
         
         %Salvar valores de x,y,z e teta nas variaveis
         x(i) = position(1); 
         y(i) = position(2);
         z(i) = position(3);
         Theta_robo(i) = angulo_robo(3);
         
         %raio de giro
         dx = a(1) +2*a(2)*lambda + 3*a(3)*(lambda^2);
         dy = b(1) + 2*b(2)*lambda + 3*b(3)*(lambda^2);
         d2x = 2*a(2) + 6*a(3)*lambda;
         d2y = 2*b(2) + 6*b(2)*lambda;
         r = (((dx^2)+(dy^2))^1.5)/((d2y*dx)-(d2x*dy));
         k = (1/r);
         
         %delta theta
         theta_SF = Theta;
         Delta_theta = angulo_robo - theta_SF;
         
         %Controle
         u = -(k_theta*Delta_theta + (k_l*Delta_l*v*sin(Delta_theta)/Delta_theta));
         
         
     end
     
     [returnCode]=vrep.simxSetJointTargetVelocity(clientID,left_Motor,0,vrep.simx_opmode_blocking);
     [returnCode]=vrep.simxSetJointTargetVelocity(clientID,right_Motor,0,vrep.simx_opmode_blocking);

     vrep.simxFinish(-1);
 end
 
 vrep.delete();