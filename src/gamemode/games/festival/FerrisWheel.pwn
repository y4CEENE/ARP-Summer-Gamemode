/// @file      FerrisWheel.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2023-04-15
/// @copyright Copyright (c) 2023

// Based on SAMP Ferris Wheel <Kye> 2011

#include <YSI\y_hooks>

static const cFerrisWheelId         = 18877;
static const cFerrisBaseId          = 18878;
static const cFerrisCageId          = 19316; // Original: 18879
static const Float:cFerrisSpeed     = 0.01;
static const Float:cFerrisDrawDistance  = 300.0;
static const Float:cFerrisOrigin[4] = { 1449.5245, -35.6684, 40.5702, 220.0 };
// Cage offsets for attaching to the main wheel
static const Float:cFerrisCageOffsets[][3] = {
    {  0.0699,  0.0600, -11.7500 },
    { -6.9100, -0.0899,  -9.5000 },
    { 11.1600,  0.0000,  -3.6300 },
    {-11.1600, -0.0399,   3.6499 },
    { -6.9100, -0.0899,   9.4799 },
    {  0.0699,  0.0600,  11.7500 },
    {  6.9599,  0.0100,  -9.5000 },
    {-11.1600, -0.0399,  -3.6300 },
    { 11.1600,  0.0000,   3.6499 },
    {  7.0399, -0.0200,   9.3600 }
};

// SA-MP objects
static gFerrisWheel;
static gFerrisBase;
static gFerrisCages[sizeof(cFerrisCageOffsets)];

//-------------------------------------------------
new Float:gCurrentTargetYAngle = 0.0; // Angle of the Y axis of the wheel to rotate to.
new gWheelTransAlternate = 0; // Since MoveObject requires some translation target to intepolate
						      // rotation, the world pos target is alternated by a small amount.

hook OnGameModeInit()
{
    gFerrisWheel = CreateDynamicObjectEx(cFerrisWheelId, cFerrisOrigin[0], cFerrisOrigin[1], cFerrisOrigin[2],
                                         0.0, 0.0, cFerrisOrigin[3], cFerrisDrawDistance);
    gFerrisBase = CreateDynamicObjectEx(cFerrisBaseId, cFerrisOrigin[0], cFerrisOrigin[1], cFerrisOrigin[2],
                                        0.0, 0.0, cFerrisOrigin[3], cFerrisDrawDistance);

    for (new x; x < sizeof(gFerrisCages); x++)
    {
        gFerrisCages[x] = CreateDynamicObjectEx(cFerrisCageId, cFerrisOrigin[0], cFerrisOrigin[1], cFerrisOrigin[2],
                                                0.0, 0.0, cFerrisOrigin[3], cFerrisDrawDistance);
        AttachDynamicObjectToObject(gFerrisCages[x], gFerrisWheel, cFerrisCageOffsets[x][0], cFerrisCageOffsets[x][1],
                                    cFerrisCageOffsets[x][2], 0.0, 0.0, cFerrisOrigin[3], 0);
    }
    SetTimer("RotateWheel",3 * 1000,0);
}

hook OnGameModeExit()
{
    DestroyDynamicObject(gFerrisWheel);
    DestroyDynamicObject(gFerrisBase);
    for (new x; x < sizeof(gFerrisCages); x++)
        DestroyDynamicObject(gFerrisCages[x]);

    return 1;
}

hook OnDynamicObjectMoved(objectid)
{
    if (objectid == gFerrisWheel)
    {
        SetTimer("RotateWheel", 3 * 1000,0);
    }
}

publish RotateWheel()
{
    UpdateWheelTarget();
    new Float:fModifyWheelZPos = 0.0;
    if (gWheelTransAlternate)
    {
        fModifyWheelZPos = 0.05;
    }
    MoveDynamicObject(gFerrisWheel, cFerrisOrigin[0], cFerrisOrigin[1], cFerrisOrigin[2] + fModifyWheelZPos,
                      cFerrisSpeed, 0.0, gCurrentTargetYAngle, cFerrisOrigin[3]);
}

stock UpdateWheelTarget()
{
    gCurrentTargetYAngle += 36.0; // There are 10 carts, so 360 / 10
    if(gCurrentTargetYAngle >= 360.0)
    {
        gCurrentTargetYAngle = 0.0;
    }
    gWheelTransAlternate = gWheelTransAlternate ? 0 : 1;
}
