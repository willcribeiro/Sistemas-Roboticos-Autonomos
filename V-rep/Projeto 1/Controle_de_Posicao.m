clc
clear

format short; % 4 casas decimais em um número flutuante

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
     [returnCode]=vrep.simxSetJointTargetVelocity(clientID,left_Motor,0,vrep.simx_opmode_blocking);
     [returnCode]=vrep.simxSetJointTargetVelocity(clientID,right_Motor,0,vrep.simx_opmode_blocking);
    
     %Posicao e orientacao do robo
     [returnCode,position]=vrep.simxGetObjectPosition(clientID,carro,-1,vrep.simx_opmode_streaming)
     [returnCode,angulo_robo]=vrep.simxGetObjectOrientation(clientID,carro,-1,vrep.simx_opmode_streaming)
      
     %PONTOS FINAIS
     xf = -1.8;
     yf = -1.7;
     
     %Ganhos do controlador
     k_theta = 0.6;
     k_l = 0.1;
     
     %Dados do robô
     rd = 0.06;
     re = 0.06;
     B = 0.13;
     
     cont = 0 % contador para testes
     
     while true %tempo de movimentação
     %Get position of Robot
     [returnCode,position]=vrep.simxGetObjectPosition(clientID,carro,-1,vrep.simx_opmode_buffer); %(Retorna X,Y,Z)
     [returnCode,angulo_robo]=vrep.simxGetObjectOrientation(clientID,carro,-1,vrep.simx_opmode_buffer);
     
     [returnCode,~,~,angulo_robo_euler,~]=vrep.simxGetObjectGroupData(clientID,carro,5,vrep.simx_opmode_buffer);
     Theta_Robo = angulo_robo(3) + pi/2;
     
%      if(Theta_Robo < 0)
%          Theta_Robo = Theta_Robo + pi/2;
%      end
          
     %Calculo dos Delta x e y 
     delta_x = xf - position(1);
     delta_y = yf - position(2);
         
     %Calculo do Theta estrela/Referencial
     Theta_ref = atan2(delta_y,delta_x);     
     
%      if(Theta_ref < 0)
%         Theta_ref = Theta_ref + pi/2;
%      end
     
     %Calculo do delta l do referencial e  delta Theta
     delta_l_ref = sqrt((delta_x)^2 + (delta_y)^2);     
     delta_theta = Theta_ref - Theta_Robo;
     
     %Caluclo do delta L
     delta_l = delta_l_ref*cos(delta_theta);%cos(abs(delta_theta));%
     
     %Calculo da velocidade linear e angular
     v = k_l*delta_l;
     w = k_theta * delta_theta;
    
     %velocidades das juntas
     wd = (v/rd) + (B/(2*rd))*w;
     we = (v/re) - (B/(2*re))*w;
         
     vrep.simxSetJointTargetVelocity(clientID,left_Motor,we,vrep.simx_opmode_blocking);
     vrep.simxSetJointTargetVelocity(clientID,right_Motor,wd,vrep.simx_opmode_blocking);
                    
     if(delta_l_ref <= 0.05)
        break;
     end;
         

     end
     [returnCode]=vrep.simxSetJointTargetVelocity(clientID,left_Motor,0,vrep.simx_opmode_blocking);
     [returnCode]=vrep.simxSetJointTargetVelocity(clientID,right_Motor,0,vrep.simx_opmode_blocking);

     vrep.simxFinish(-1);
 end
 
 vrep.delete();