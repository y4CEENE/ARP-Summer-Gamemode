/// @file      RandomMsg.pwn
/// @author    BOURAOUI Al-Moez L.A
/// @date      Created at 2021-03-29 12:23:11 +0100
/// @copyright Copyright (c) 2022

new randomMessages[][] =  //here, we're creating the array with the name "randomMessages"
{
    "[Tip]{FFFFFF} Want to join a faction/gang? Roleplay with their leaders!.", //this is the text of your first message
    "[Tip]{FFFFFF} Want to become a helper? help around on /newb and the Head Helper will notice you.", //this is the text of your second message
    "[Tip]{FFFFFF} We have helpers waiting for you to ask! Use /newb to ask for a question!", //this is the text of your third message
    "[Tip]{FFFFFF} Seen a hacker/rulebreaker/Dmer? (/report)(/reportdm) him!", //this is the text of your fourth message
    "[Tip]{FFFFFF} It is not allowed to use hacks or else ban if you get caught.", //this is the text of your fifth message
    "[Tip]{FFFFFF} Admins will never help any hacked or stolen accounts.", //this is the text of your six message
    "[Tip]{FFFFFF} Did you know, you can win awesome prizes such as donator status from events!",
    "[Tip]{FFFFFF} Please note that if you are having account issues to make an administrative request on our forums!",
    "[Tip]{FFFFFF} Use /information to view our current information about our server."
};

task RandomMessages[300000]() // each 5 minutes
{
    new randomMsg = random(sizeof(randomMessages));

    foreach(new i : Player)
    {
        if (PlayerData[i][pLevel] < 7)
        {
            SendClientMessage(i, COLOR_GREEN, randomMessages[randomMsg]);
        }
    }
}
