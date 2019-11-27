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
     
     [returnCode,left_Motor]=vrep.simxGetObjectHandle(clientID,'wheel_left_joint',vrep.simx_opmode_blocking)
     [returnCode,right_Motor]=vrep.simxGetObjectHandle(clientID,'wheel_right_joint',vrep.simx_opmode_blocking)
     [returnCode,carro]= vrep.simxGetObjectHandle(clientID,'RobotBase',vrep.simx_opmode_blocking)
     %------------------------------------------Other Code----------------------------------------------------------------------------
     %Movimentacao
     [returnCode]=vrep.simxSetJointTargetVelocity(clientID,left_Motor,0,vrep.simx_opmode_blocking);
     [returnCode]=vrep.simxSetJointTargetVelocity(clientID,right_Motor,0,vrep.simx_opmode_blocking);
     lambda = 0;
     while true %tempo de movimentação
                     
         vrep.simxSetJointTargetVelocity(clientID,left_Motor,5,vrep.simx_opmode_blocking);
         vrep.simxSetJointTargetVelocity(clientID,right_Motor,5,vrep.simx_opmode_blocking);
          lambra = lambda + 1          
         if(lambda==20)
             break;
         end;
         
     end
     

     vrep.simxFinish(-1);
 end
 
 vrep.delete();