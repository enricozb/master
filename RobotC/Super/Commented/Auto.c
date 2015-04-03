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

const tMUXSensor seeker = msensor_S4_2; //accessed by HTIRS2readACDir(seeker)
const tMUXSensor sonar = msensor_S4_1;  //accessed by USreadDist(sonar)

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

// The current autonomous mode choices.
char *opts[10] = { "floor", "ramp", "", "", "", "", "", "", "", "diagnostics"};

static int targetBaskHeight = 10;
static float currAngle = 0;
static float gyroOff = 0;
static long lastReadTime = 0;

// Used for the election algorithm during center goal position determination
static int vote = 0;
static int votes[4] = {0,0,0,0};


// Returns a variable 'val' constrained within the bounds of [min, max]
//
// params:
//  val     the value to be constrained
//  min     the minimum allowed output value
//  max     the maximum allowed output value
float constrain(float val, float min, float max) {
    if (min > max) {
        float tmin = min;
        min = max;
        max = tmin;
    }
    float u = val < max ? val : max;
    return u > min ? u : min;
}

// Calibrates the Gyroscopic sensor.
//
// It takes 400 readings from a stand-still to calculate any intrensic offset 
// the Gyro has. It then updates the 'gyroOff' global variable to this measured 
// value.
//
// Called prior to any initial movement of the Robot.
void calibrateGyro() {

    lastReadTime = nPgmTime;
    float sumReads = 0;
    for(int i = 0; i < 400; i++) {
        if(i % 50 == 0)
            PlayTone(440, 5);
        sumReads += SensorValue[gyro];
        wait1Msec(10);
    }
    gyroOff = sumReads/400;
}

// Aligns the robot to the center goal using the Infrared and sonic sensors.
void follow()
{
    while(USreadDist(sonar) > 24)
    {
        int speed = -10;
        int turn = 10 * (HTIRS2readACDir(seeker) - 7.5);
        motor[left] = speed + turn;
        motor[right] = speed - turn;
    }
    motor[right] = 0;
    motor[left] = 0;
}

// Raises the rear goal-grabbing gate.
void gateRaise()
{
    servo[grab] = GATE_OPEN;
}

// Lowers the rear goal-grabbing gate and waits 250 milliseconds.
//
// Has a wait in order to prevent any forward movement while the gate is being 
// lowered. Without this, the robot often begins to lower the gate, moves on to 
// it's next position too quickly, thus leaving the goal behind.
void gateLower()
{
    servo[grab] = GATE_SHUT;
    wait1Msec(250);
}

// Lowers the rear goal-grabbing gate without any wait time.
void gateLowerNoWait()
{
    servo[grab] = GATE_SHUT;
}

// Rotates the basket in order to score the balls into a rolling goal.
void rotateBasket()
{   
    // Waits for the lift to complete it's movement.
    while(motor[lift] != 0) {}
    motor[sweep] = 10;

    // Rotate basket upwards
    ServoChangeRate[bask] = 2;
    servo[bask] = BASKUP;
    wait1msec(4000);

    // Rotate basket downwards
    servo[bask]=BASKDOWN;
    motor[sweep] = 0;
}

// Asyncronously lifts the basket to a desired height. Having this as a task 
// allows for other motors and sensors to be used while raising the basket. 
// Setting 'targetBaskHeight' prior to starting this task indicates the desired 
// height.
//
// Preset constants for targetBaskHeight include:
//      BASKH_MAX, BASKH_HIGH, BASKH_MED, BASKH_MIN
task liftBasket {

    // Lift Basket
    motor[lift] = 100;
    motor[sweep] = 10;

    while(SensorValue[zero]) {}
    nMotorEncoder(lift) = 0;

    while (nMotorEncoder(lift) < targetBaskHeight) {}

    // End sequence
    motor[lift] = 0;
    motor[sweep] = 0;
}

// Asyncronously lowers the basket
task lowerBasket {
    /*Lower Basket*/
    motor[lift]=-50;
    while(!SensorValue[zero]){
        motor[sweep]=-10;
    }

    /*End Sequence*/
    motor[lift]=0;
    motor[sweep]=0;
}

// Allows for specific directional motion of the robot.
//
// params:
//  degree      the angle at which the robot is to be moved toward
//  distance    the distance the robot should move for (in centimeters)
//  power       the power to be used for the motors (negative when in reverse)
//  distUntil   the min distance the sonar must read in order to continue moving
void moveCm(float degree, long distance, int power, int distUntil = 0){
  nMotorEncoder[right] = 0;
    wait1Msec(10);
    ClearTimer(T4);
  while (abs(nMotorEncoder[right]) < distance*5000/150) 
    {
        if(time1[T4] > 10000)
            break;
        if(USreadDist(sonar) < distUntil)
            break;
        float off = currAngle - degree;
          motor[right] = constrain(power + off * 2, 0, power);
       motor[left] = constrain(power - off * 2, 0, power);
  }
  motor[right] = 0;
  motor[left] = 0;
}

// Allows for specific turning of the robot.
//
// params:
//  degree      the angle the robot is to be moved by.
//  lpower      the power to be applied to the left motor 
//                  (negative when in reverse)
//  rpower      the power to be applied to the right motor 
//                  (negative when in reverse)
void turn(int degree, int lpower, int rpower) {
    int prevAngle = currAngle;
    ClearTimer(T4);
    while(abs(currAngle - prevAngle) < degree) {
        if(time1[T4] > 10000)
            break;
        motor[right] = rpower;
        motor[left] = lpower;
    }
    motor[right] = motor[left] = 0;
}

// Asyncronously updates the gyro.
//
// Updates the 'currAngle' variable to accurately determine the current position
// of the robot.
task gyroUpdate() {
    int lastReadTime = nPgmTime;
    while(true) {
        int now = nPgmTime;
        currAngle += (SensorValue[gyro] - gyroOff) * (now - lastReadTime)/1000.0;
        lastReadTime = now;
    }
}

// Sets the current Angle of the robot.
//
// Used to correct any known gyroscopic errors. Stops the gyroUpdate task, and 
// restarts it once 'currAngle' has been reset
//
// params:
//  heading     the desired angle
void setHeading(float heading) {
    StopTask(gyroUpdate);
    currAngle = heading;
    StartTask(gyroUpdate);
}

// Grabs the user-inputted autonomous sequence.
//
// Using the NXT brick controls, drivers can choose which autonomous mode to use
// ("floor" or "ramp")
int getSeq()
{
    static int nxtLastButton = -1;
    int buttonCounter = 0;
    while (true)
    {
       int button = nNxtButtonPressed;
        nxtDisplayBigTextLine(0, "%i", buttonCounter);
        nxtDisplayBigTextLine(2, "%s", opts[buttonCounter]);
        if (button == 3) break;
       if (button == nxtLastButton) continue;
       if (button == 1) buttonCounter++;
       if (button == 2) buttonCounter--;
         buttonCounter = constrain(buttonCounter, 0, 9);
        nxtLastButton = button;
    }
    return buttonCounter;
}

// Sets the robot's servos and motors to their initial state.
void initializeRobot()
{
    servo[bask] = BASKDOWN;
    servo[grab] = GATE_OPEN;
    servoChangeRate[bask] = 2;
    servoChangeRate[grab] = 5;
    StartTask(lowerBasket);
    return;
}

// Displays several sensor and global variable values to the NXT 
// display indefinitely.
//
// Used mainly for debugging during autonomous/teleop sequences.
void diagnostics()
{
    while(true)
    {
        nxtDisplayTextLine(0,"Zero:   %i", SensorValue[zero]);
        nxtDisplayTextLine(1,"Gyro:   %i", SensorValue[gyro]);
        nxtDisplayTextLine(2,"Seeker: %i", HTIRS2readACDir(seeker));
        nxtDisplayTextLine(3,"Sonar:  %i", USreadDist(sonar));
        nxtDisplayTextLine(4,"Angle:    %f", currAngle);
        nxtDisplayTextLine(5,"Vote: %i %i %i %i", vote, votes[1], votes[2], votes[3]);
        nxtDisplayTextLine(6,"Gyroff  %i", gyroOff);
        wait1Msec(10);
    }
}

// Determines the center goal position (1, 2, 3) using an election algorithm.
//
// Takes simultaneous readings from the Infrared sensor and the sonic sensor to 
// determine the center goal position. Preferential 'votes' are also given to
// sonic sensor readings that are more definitive.
int getVote() {
    while(true) {
        for(int i = 1; i <= 3; i++) {
            if(votes[i] >= 20)
                return i;
        }
        switch(HTIRS2readACDir(seeker)) {
            case 0: votes[1]++; break;
            case 7: votes[2]++; break;
            case 8:
            case 9: votes[3]++; break;
        }
        int sonarVal = USreadDist(sonar);
        if(sonarVal == 255)
            votes[2]++;
        else if(sonarVal < 142 && sonarVal > 122)
            votes[1] += 2;
        else if(sonarVal < 122 && sonarVal > 102)
            votes[3] += 2;
    }
}

// Ramp Sequences
//
// Sequences have a standardized naming convention. 
//  r   starting from ramp
//  gX  grab goal X (3=small, 6=medium, 9=tall)
//  bX  score ball in goal X (3=small, 6=medium, 9=tall)
//  pX  go to parking zone (1=close to ramp, 2=middle, 3=far from ramp)
void seq_r();
void seq_r_g6();
void seq_r_b6_p1();
void seq_r_b6_p1_g9();
void seq_r_b6_p1_g9_p1();

// Moves the robot off the ramp
void seq_r()
{
  StartTask(liftBasket);
  //wait1Msec(900);
  currAngle = 0;
    moveCm(0, 140, -10);
}

// Moves the robot off the ramp then grabs the medium (6) goal
void seq_r_g6()
{
    seq_r();
    gateRaise();
    moveCm(0, 80, -20);
    gateLowerNoWait();            //Lower gate while pushing. Resolves issue with knocking goal away while trying to grab it.
    moveCm(0,10,-20);
}

// Moves the robot off the ramp and scores in the medium goal (6)
void seq_r_b6()
{
    targetBaskHeight = BASKH_MED;
    seq_r_g6();
    wait1Msec(20);
    moveCm(0, 5, 15);
    rotateBasket();
}

// Moves the robot off the ramp, scores in the medium goal (6), then goes to the
// parking zone area closest to the ramp
void seq_r_b6_p1() {
    seq_r_b6();
    currAngle = 0;
    moveCm(34, 220, 50);
    turn(135, -30, 30);
    gateRaise();
    turn(155, -30, 30);
}

// Moves the robot off the ramp, scores in the medium goal (6), then goes to the
// parking zone area closest to the ramp and leaves the medium goal there. Then,
// the robot goes and scores in the high (9) goal.
void seq_r_b6_p1_g9() {
    seq_r_b6_p1();
    motor[left] = -25;
    motor[right] = -25;
    wait1Msec(1800);
    motor[left] = 0;
    motor[right] = 0;
    wait1Msec(100);
    setHeading(90);
    turn(83, 0, 50);
    moveCm(0, 100, -70);
    moveCm(34, 200, -70);
    gateLower();
}

// Executes seq_r_b6_p1_g9(), and then returns the high goal to the parking zone
// area closest to the ramp.
void seq_r_b6_p1_g9_p1() {
    seq_r_b6_p1_g9();
    moveCm(23, 285, 70);
    turn(180, 50, -50);
}

// Floor Sequences
// 
// The floor sequences follow the same naming convention as the ramp sequences.
//  f   starting from floor
//  gX  grab goal X (3=small, 6=medium, 9=tall)
//  bX  score ball in goal X (3=small, 6=medium, 9=tall)
//  pX  go to parking zone (1=close to ramp, 2=middle, 3=far from ramp)
//  kX  knocks the kickstand down in certain center goal position (1, 2, 3)
//  cX  scores in the center goal in a certain center goal position (1, 2, 3)
void seq_f_k1();
void seq_f_k1_b9();
void seq_f_k1_b9_p1();
void seq_f_c2();
void seq_f_c3();
void seq_f_c2_k2();
void seq_f_c3_k3();

// Determines which floor sequence to execute, depending on the current position
// of the center goal.
void seq_f() {
    vote = getVote();
    switch(vote)
    {
        case 1: seq_f_k1_b9_p1(); break;
        case 2: seq_f_c2_k2(); break;
        case 3: seq_f_c3_k3();
    }
}

// Knocks down the kickstand when the center goal is in position 1
void seq_f_k1() {
    moveCm(45, 160, -30);
    moveCm(100, 23, 20);
    turn(30, 0, 25);
}

// Knocks down the kickstand when the center goal is in position 1 and then
// scores in the tall goal.
void seq_f_k1_b9() {
    seq_f_k1();
    moveCm(90, 50, -30);
    turn(80, -30, 0);

    moveCm(0, 100, -30); // Moving toward goal

    targetBaskHeight = BASKH_HIGH;
    StartTask(liftBasket);

    moveCm(50, 95, -30);
    moveCm(50, 15, -10);
    gateLowerNoWait();
    moveCm(50, 10, -10);
    moveCm(50, 10, 20);
    rotateBasket();
}

// Executes seq_f_k1_b9() and then brings the tall goal back to the parking zone
void seq_f_k1_b9_p1() {\
    seq_f_k1_b9();
    motor[sweep] = -10;
    moveCm(70, 60, 30);
    moveCm(0, 150, 30);
    moveCm(50, 155, 30);
}

// Starting from the parking zone, the robot scores in the center goal while it 
// is in position 2
void seq_f_c2() {
    turn(90,-50,0);
    moveCm(-90, 40, -50);
    turn(120, 25, -25);
    follow();
    targetBaskHeight = BASKH_MAX;
    StartTask(liftBasket);
    rotateBasket();
}

// Starting from the parking zone, the robot scores in the center goal while it 
// is in position 3
void seq_f_c3() {
    follow();
    targetBaskHeight = BASKH_MAX;
    StartTask(liftBasket);
    rotateBasket();
}

// Executes f_c2() and then knocks the kickstand down while the center goal 
// is in position 2
void seq_f_c2_k2() {
    seq_f_c2();
    StartTask(lowerBasket);
    wait1Msec(1500);
    turn(195, 0, 50);
    moveCm(currAngle, 10, 30);
    turn(30, 50, 0);
}

// Executes f_c3() and then knocks the kickstand down while the center goal 
// is in position 3
void seq_f_c3_k3() {
    seq_f_c3();
    turn(200, 0, 50);
    moveCm(currAngle, 10, 30);
    turn(30, 50, 0);
    //moveCm(-190, 140, 30);
}

// The main task of the robot's autonomous execution.
//
// The robot is reset to it's initial state, the desired autonomous mode is then
// chosen by the drivers. The gyro is then calibrated, and then the robot waits
// for the 'start' given by the field controllers. Once the autonomous mode has
// begun, the robot executes the specified sequence. The diagnostics are also
// displayed at the end of the operation, for any debugging requirements.
task main() {
    initializeRobot();
    int mode = getSeq();
    wait1Msec(2000);
    calibrateGyro();
    waitForStart();
    StartTask(gyroUpdate);
    switch(mode)
    {
        case 0: seq_f(); break;
        case 1: seq_r_b6_p1_g9_p1(); break;
    }
    motor[sweep] = 0;
    diagnostics();
}
