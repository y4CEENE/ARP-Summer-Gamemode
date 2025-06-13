
enum Point3D
{
    Float:P3_PosX,
    Float:P3_PosY,
    Float:P3_PosZ
};

enum Point4D
{
    Float:P4_PosX,
    Float:P4_PosY,
    Float:P4_PosZ,
    Float:P4_Angle
};

enum Point6D
{
    Float:P6_PosX,
    Float:P6_PosY,
    Float:P6_PosZ,
    Float:P6_Angle,
    P6_Interior,
    P6_World
};

enum Coords6D
{
    Float:C6_PosX,
    Float:C6_PosY,
    Float:C6_PosZ,
    Float:C6_RotX,
    Float:C6_RotY,
    Float:C6_RotZ
};

enum Coords8D
{
    Float:C8_PosX,
    Float:C8_PosY,
    Float:C8_PosZ,
    Float:C8_RotX,
    Float:C8_RotY,
    Float:C8_RotZ,
    C8_Interior,
    C8_World
};

enum ObjectInfo
{
    OI_Id,
    Float:OI_PosX,
    Float:OI_PosY,
    Float:OI_PosZ,
    Float:OI_RotX,
    Float:OI_RotY,
    Float:OI_RotZ,
    OI_Interior,
    OI_World
}
