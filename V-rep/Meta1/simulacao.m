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
     [returnCode]=vrep.simxSetJointTargetVelocity(clientID,left_Motor,0,vrep.simx_opmode_blocking);
     [returnCode]=vrep.simxSetJointTargetVelocity(clientID,right_Motor,0,vrep.simx_opmode_blocking);
     %Leitura sensor
     [returnCode,detectionState,detectedPoint,~,~]=vrep.simxReadProximitySensor(clientID,front_Sensor,vrep.simx_opmode_streaming);
     [returnCode,position]=vrep.simxGetObjectPosition(clientID,carro,-1,vrep.simx_opmode_streaming)
     [returnCode,angulo]=vrep.simxGetObjectOrientation(clientID,carro,-1,vrep.simx_opmode_streaming)
     %Posições cartesianas
     vel = 0;
     xa = 0:0.01:2;
     ya = 0:0.01:2;
     za = 0.5;
     pin = [xa ya za];
     for i=1:250 %tempo de movimentação
         %Incremento da velocidade 
         [returnCode]=vrep.simxSetJointTargetVelocity(clientID,left_Motor,vel,vrep.simx_opmode_blocking);
         [returnCode]=vrep.simxSetJointTargetVelocity(clientID,right_Motor,vel,vrep.simx_opmode_blocking);
         vel = vel + 0.01;
         %Parametro para pegar a posicao
         [returnCode,position]=vrep.simxGetObjectPosition(clientID,carro,-1,vrep.simx_opmode_buffer) %(Retorna X,Y,Z)
         %Pega a distância pelo sensor
         [returnCode,detectionState,detectedPoint,~,~]=vrep.simxReadProximitySensor(clientID,front_Sensor,vrep.simx_opmode_buffer); %demais chamadas
         %disp(norm(position));
         %pega o angulo do robô 
         [returnCode,angulo]=vrep.simxGetObjectOrientation(clientID,carro,-1,vrep.simx_opmode_buffer)
         
         %Salvar valores de x,y,z e teta nas variaveis
         x(i) = position(1); 
         y(i) = position(2);
         z(i) = position(3);
         teta(i) = angulo(3);
         
         k = norm(detectedPoint);
         if k<0.1 
             k = 0.5;
         end
         if (k<0.3) 
             [returnCode]=vrep.simxSetJointTargetVelocity(clientID,right_Motor,0,vrep.simx_opmode_blocking);
             pause(0.4);
             [returnCode]=vrep.simxSetJointTargetVelocity(clientID,right_Motor,1,vrep.simx_opmode_blocking);
         end
         pause(0.1);
     end
     time = 0:0.1:150;
     plot(x,time,'rx');   

     [returnCode]=vrep.simxSetJointTargetVelocity(clientID,left_Motor,0,vrep.simx_opmode_blocking);
     [returnCode]=vrep.simxSetJointTargetVelocity(clientID,right_Motor,0,vrep.simx_opmode_blocking);

     vrep.simxFinish(-1);
 end
 
 vrep.delete();