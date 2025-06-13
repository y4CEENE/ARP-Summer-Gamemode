
stock INIGetKey(line[])
{
    new keyRes[64];
    keyRes[0] = 0;
    if (strfind(line , "=" , true) == -1) return keyRes;
    strmid(keyRes , line , 0 , strfind(line , "=" , true) , sizeof(keyRes));
    return keyRes;
}

stock INIGetValue(line[])
{
    new valRes[156];
    valRes[0]=0;
    if (strfind(line , "=" , true) == -1) return valRes;
    strmid(valRes , line , strfind(line , "=" , true)+1 , strlen(line) , sizeof(valRes));
    //new ln = strlen(valRes)-1;
    //if (ln>0)
    //{
    //    if (valRes[ln-1] == 10)
    //    {
    //        valRes[ln-1] = 0;
    //    }
    //}
    return valRes;
}
