package com.geniisys.csv;

import java.io.FileWriter;
import java.io.IOException;
import java.sql.Connection;

public class CreateCSV {
	
	public static String main(String[] args, Connection connection) throws IOException, Exception {
		StringBuilder stringBuilder = new StringBuilder();
		String temp;
		try {

			if (args.length > 6){
				for (int i = 5; i < args.length; i++) {
					if (args[i].contains(",") && args[i].toUpperCase().contains("FROM")){
						stringBuilder.append((args[i].substring(0, args[i].indexOf(" ")) + "\"," + 
								  args[i].substring(args[i].indexOf(" "), args[i].length())).toUpperCase().replace(", F", " F"));
					}else if(args[i].toUpperCase().contains("FROM")){
						stringBuilder.append(args[i].substring(0, args[i].indexOf(" ")) + "\"" + 
								  args[i].substring(args[i].indexOf(" "), args[i].length()));
					}else if(args[i].toUpperCase().contains("SELECT")){
						stringBuilder.append(args[i].substring(0, args[i].lastIndexOf(" ") + 1) + "\"" +
								args[i].substring(args[i].lastIndexOf(" ") + 1, args[i].length()) + " ");
					}else if(!args[i].contains(" ")){
						stringBuilder.append(args[i] + " ");
					}else{
						stringBuilder.append(args[i].substring(0, args[i].lastIndexOf(" ")).replaceFirst(",", "\",") + 
								   args[i].substring(args[i].lastIndexOf(" "), args[i].length()).replace(" ", " \""));
						stringBuilder.append(" ");
					}
				}
				temp = RunnerCS.main(args[0], args[1],args[2],args[3],args[4],stringBuilder.toString(), connection);
			}else{
				temp = RunnerCS.main(args[0], args[1],args[2],args[3],args[4],args[5], connection);
			}
		}  catch (OutOfMemoryError e) {
			FileWriter fileWriter = new FileWriter(args[4]);
			fileWriter.write("Error: Unable to generate rows of data in this file. Kindly increase the value of JRE_MIN_HEAP_SPACE and JRE_MAX_HEAP_SPACE parameter. Contact the administrator for assistance.");
			temp = "Unable to generate rows of data in this file. Kindly increase the value of JRE_MIN_HEAP_SPACE and JRE_MAX_HEAP_SPACE parameter. Contact the administrator for assistance.";
			fileWriter.close();
		}
		
		return temp;
	}

}
