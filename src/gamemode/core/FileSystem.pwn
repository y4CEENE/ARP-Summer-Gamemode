
Log(filename[], const text[], {Float,_}:...)
{
	static args;
	static str[192];
    static log_entry[256];
    static hour, minute, second;
    static year, month, day;
    static File:output_file;
    
    gettime(hour, minute, second);
    getdate(year, month, day);
    
    output_file = fopen(filename, io_append);
    if(!output_file)
    {
        return 1;
    }

	if((args = numargs()) <= 2)
	{
        format(log_entry, sizeof(log_entry), "[%i/%i/%i - %i:%i:%i] %s\r\n", year, month, day, hour, minute, second, text);
        fwrite(output_file, log_entry);
        fclose(output_file);
	}
	else
	{
		while(--args >= 2)
		{
			#emit LCTRL 	5
			#emit LOAD.alt 	args
			#emit SHL.C.alt 2
			#emit ADD.C 	12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S 		text
		#emit PUSH.C 		192
		#emit PUSH.C 		str
		#emit LOAD.S.pri 	8
		#emit ADD.C 		4
		#emit PUSH.pri
		#emit SYSREQ.C 		format
		#emit LCTRL 		5
		#emit SCTRL 		4

        format(log_entry, sizeof(log_entry), "[%i/%i/%i - %i:%i:%i] %s\r\n", year, month, day, hour, minute, second, str);
        fwrite(output_file, log_entry);
        fclose(output_file);

		#emit RETN
	}
	return 1;
}