/// @file      Calculator.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-03-29 12:23:11 +0100
/// @copyright Copyright (c) 2022


CMD:cal(playerid, params[])
{
    callcmd::calculate(playerid, params);
}

CMD:calc(playerid, params[])
{
    callcmd::calculate(playerid, params);
}

CMD:calculate(playerid, params[])
{
    new option, Float:value1, Float:value2;

    if (sscanf(params, "fcf", value1, option, value2))
    {
        SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /calculate [value 1] [option] [value 2]");
        SendClientMessage(playerid, COLOR_SYNTAX, "List of options: (+) Add (-) Subtract (*) Multiply (/) Divide");
        return 1;
    }
    if (option == '/' && value2 == 0)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You can't divide by zero.");
    }

    if (option == '+')
    {
        SendClientMessageEx(playerid, COLOR_GREEN, "* Result: %.2f + %.2f = %.2f", value1, value2, value1 + value2);
    }
    else if (option == '-')
    {
        SendClientMessageEx(playerid, COLOR_GREEN, "* Result: %.2f - %.2f = %.2f", value1, value2, value1 - value2);
    }
    else if (option == '*' || option == 'x')
    {
        SendClientMessageEx(playerid, COLOR_GREEN, "* Result: %.2f * %.2f = %.2f", value1, value2, value1 * value2);
    }
    else if (option == '/')
    {
        SendClientMessageEx(playerid, COLOR_GREEN, "* Result: %.2f / %.2f = %.2f", value1, value2, value1 / value2);
    }

    return 1;
}
