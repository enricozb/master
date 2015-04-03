#pragma config(Hubs,   S1, HTMotor,  HTMotor,  HTServo,  none)
#pragma config(Sensor, S2,              zero,      sensorTouch)
#pragma config(Sensor, S3,              gyro,      sensorI2CHiTechnicGyro)
#pragma config(Sensor, S4,              HTSMUX,    sensorI2CCustom)
#pragma config(Motor,  mtr_S1_C1_1,     sweep,     tmotorTetrix, openLoop, reversed, encoder)
#pragma config(Motor,  mtr_S1_C1_2,     right,     tmotorTetrix, openLoop, reversed)
#pragma config(Motor,  mtr_S1_C2_1,     lift,      tmotorTetrix, openLoop, reversed)
#pragma config(Motor,  mtr_S1_C2_2,     left,      tmotorTetrix, openLoop)
#pragma config(Servo,  srvo_S1_C3_1,    grab,      tServoStandard)
#pragma config(Servo,  srvo_S1_C3_2,    servo2,    tServoNone)
#pragma config(Servo,  srvo_S1_C3_3,    servo3,    tServoNone)
#pragma config(Servo,  srvo_S1_C3_4,    servo4,    tServoNone)
#pragma config(Servo,  srvo_S1_C3_5,    servo5,    tServoNone)
#pragma config(Servo,  srvo_S1_C3_6,    bask,      tServoStandard)

#include "JoystickDriver.c"
#include "drivers/hitechnic-sensormux.h"
#include "drivers/hitechnic-irseeker-v2.h"
#include "drivers/lego-ultrasound.h"
#include "drivers/hitechnic-colour-v2.h"

// The four possible encoder-value lift heights for the baskets.
const int BASKH_MAX = 13950;
const int BASKH_HIGH = 8000;
const int BASKH_MED = 2100;
const int BASKH_MIN = -450;

// The two gate servo positions for the rear goal grabber.
const int GATE_OPEN = 128;
const int GATE_SHUT = 77;

// The two possible servo positions for the rotating basket
const int BASKUP = 10;
const int BASKDOWN = 237;

const tMUXSensor color = msensor_S4_3; 	//accessed by HTCS2readColor(color)
const tMUXSensor seeker = msensor_S4_2; //accessed by HTIRS2readACDir(seeker)
const tMUXSensor sonar = msensor_S4_1;  //accessed by USreadDist(sonar)

int currentBasketHeight = 0;

int turbo = 0;
int joy2Enable = 0;

// Sets the robot's servos and motors to their initial state.
void initializeRobot()
{
	servoChangeRate[bask] = 1;
	servoChangeRate[grab] = 5;
 	servo[bask] = BASKDOWN;
 	servo[grab] = GATE_OPEN;

 	return;
}

// A convinient function that allows for multiple controller tophat control.
// 
// Any tophat movement on controller 1 will override that of controller 2.
int joytopHat()
{
	int joy1 = joystick.joy1_TopHat;
	if(joy1 < 0 && joy2Enable)
		joy1 = joystick.joy2_TopHat;
	return joy1;
}

// A convinient function that allows for multiple controller button control.
// 
// Any button pressed on controller 1 will override that of controller 2.
int joyBtn(int button)
{
	return joy1Btn(button) || joy2Btn(button);
}

// Using the color sensor, the sweeper can align to accomodate the movement of 
// the basket lift.
task alignSweeper() {
	motor[sweep] = 20;
	while(HTCS2readColor(color) == 2){}
	while(HTCS2readColor(color) != 2){}
	motor[sweep] = 0;
}

// The function controlling the current lift of the basket.
//
// The colored buttons control the automatic raising and lowering of the basket 
// for precise raising of the basket for the rolling goals.
void f_lift(){
	static int lastZero;

	if(SensorValue[zero] != lastZero)
	{
		nMotorEncoder[lift] = 0;
	}
	lastZero = SensorValue[zero];

	//Preset Basket Heights
	if(joyBtn(4))
	{
		currentBasketHeight = joyBtn(9) ? BASKH_MAX : BASKH_HIGH;
	}
	else if(joyBtn(1))
	{
		currentBasketHeight = BASKH_MED;
	}
	else if(joyBtn(2))
	{
		currentBasketHeight = BASKH_MIN;
	}

	int joyVal = joystick.joy1_y2*90/128;

	if (abs(joyVal) <= 10 && joy2Enable){
		joyVal = joystick.joy2_y2*90/128;
	}
	if(abs(joyVal) > 10)
	{
		currentBasketHeight = 0;
		motor[lift] = joyVal;
	}
	else if(currentBasketHeight == 0)
	{
		motor[lift] = 0;
	}
	else if(nMotorEncoder[lift] < currentBasketHeight)
	{
		motor[lift] = 90;
	}
	else if(nMotorEncoder[lift] > currentBasketHeight + 250)
	{
		motor[lift] = -90;
	}
	else
	{
		currentBasketHeight = 0;
		motor[lift] = 0;
	}
}

// The main function for the movement of the sweeper.
//
// The sweeper is active during the raising and lowering of the basket in order
// to reduce any unwanted harm to the basket. Once the sweeper has been moved,
// the sweeper realigns itself using the color sensor to be away from the basket
void f_sweep(){
static bool sweepMoved = false;

	if (joyBtn(5)) {
		motor[sweep] = 15;
		sweepMoved = true;
	}
	else if (joyBtn(7)) {
		motor[sweep] = -20;
		sweepMoved = true;
	}
	else if(sweepMoved) {
		sweepMoved = false;
		startTask(alignSweeper);
	}
}

// The main function for the movement of the robot.
//
// Joysticks take precedence over nearly any other motor control. Opening of the
// rear gate causes the robot to move backwards to align the goal properly.
// Tophad control is also available for precise directional movement (usually
// used for ramp movement)
// 
// Includes the Auto::follow() algorithm for center goal positioning.
void f_drive(){
	static int speed[] = {40,60,25};
	if(!joyBtn(8) && (time1[T4] < 500)) {
		motor[left] = motor[right] = -15;
		return;
	}
	int leftpower = 0;
	int rightpower = 0;
	leftpower = (joystick.joy1_y1 + joystick.joy1_x1*.75) * speed[turbo] / 128;
	rightpower = (joystick.joy1_y1 - joystick.joy1_x1*.75) * speed[turbo] / 128;
	if (abs(leftpower)<6)
		leftpower = 0;
	if (abs(rightpower)<6)
		rightpower = 0;
	if (leftpower == 0 && rightpower == 0 && joy2Enable){
		leftpower = (joystick.joy2_y1 + joystick.joy2_x1*.75) * speed[turbo] / 128;
		rightpower = (joystick.joy2_y1 - joystick.joy2_x1*.75) * speed[turbo] / 128;
		if (abs(leftpower)<6)
			leftpower = 0;
		if (abs(rightpower)<6)
			rightpower = 0;
	}
	if (leftpower == 0 && rightpower == 0) {
		switch (joytopHat()){
			case 0: leftpower = rightpower = 25; break;
			case 2: leftpower = 15; rightpower = -15; break;
			case 4: leftpower = rightpower = -25; break;
			case 6: rightpower = 15; leftpower = -15; break;
			default:
			if( joyBtn(9) && USreadDist(sonar) > 25)
			{
				int speed = -10;
				int turn = 10 * (HTIRS2readACDir(seeker) - 7.5);
				leftpower = speed + turn;
				rightpower = speed - turn;
			}
			else if(joyBtn(8))
			{
				ClearTimer(T4);
				leftpower = -15;
				rightpower = -15;
			}
		}
	}
	if (joyBtn(3) && leftpower == 0 && rightpower == 0 && time1[T3] < 500)
	{
		leftpower = rightpower = 10;
	}

	motor[left] = leftpower;
	motor[right] = rightpower;
}

// Used to speed up all motors of the robot. Should only be used in emergencies.
void f_turbo(){
	static int last = 0;
	int x = joyBtn(10);
	if (last == 0 && x)
		turbo = (turbo+1)%3;
	last = x;
}

// Used to grab the rolling goals. The right trigger is equivalent to a dead
// man's switch. Pressing the top right button toggles the gate, while pressing
// the right trigger raises it and releasing it lowers it.
void f_grab(){
	static bool last_grab = false;
	if(joyBtn(8))
	{
		last_grab = true;
		servo[grab] = GATE_OPEN;
	}
	else if(last_grab)
	{
		last_grab = false;
		servo[grab] = GATE_SHUT;
	}
	if (joyBtn(6))
		servo[grab] = GATE_OPEN;
}

// Rotates the basket when pressing the 'B' button.
void f_bask(){
	static bool press = false;
	servoChangeRate[bask] = 2;
	if (joyBtn(3))
	{
		if (!press)
		{
			ClearTimer(T3);
		}
		press = true;
		servoChangeRate[bask] = time1[T3]<700 ? 3 : 1;
		servo[bask]=BASKUP;
	}
	else
	{
		press = false;
		servoChangeRate[bask] = 4;
		servo[bask]=BASKDOWN;
	}
}

// The main task of the robot's teleop execution.
//
// The robot is reset to it's initial state, and the robot indefinitely cycles 
// through all of the movement functions.
//
// If there is any lossy connection, the robot's motors turn off in order to
// prevent any harm to the robot.
task main(){
	initializeRobot();
	waitForStart();
	int lastmsg = 0;

	while(true)
	{
		getJoystickSettings(joystick);
		if (joystick.joy2_Buttons) joy2Enable = 1;
		if(lastmsg < ntotalMessageCount){
			ClearTimer(T2);
			lastmsg = ntotalMessageCount;
			f_turbo();
			f_lift();
			f_sweep();
			f_drive();
			f_grab();
			f_bask();
		}
		else if (time1[T2] > 300){
			motor[lift]=0;
			motor[left]=0;
			motor[right]=0;
			motor[sweep]=0;
			PlayImmediateTone(440,1);
		}
	}
}
