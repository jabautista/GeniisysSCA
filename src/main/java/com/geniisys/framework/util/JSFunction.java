/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.framework.util;

import java.util.ArrayList;
import java.util.List;

/**
 * The Class JSFunction.
 */
public class JSFunction {
	
	/**
	 * Parses the.
	 * 
	 * @param function the function
	 * @param params the params
	 * @param withTag the with tag
	 * 
	 * @return the string
	 */
	public static String parse(String function, List<String> params, boolean withTag){
		String parsedString = new String();
		parsedString += function+"(";
		int c = 0;
		for(String param:params){
			parsedString += "\""+param+"\"";
			if(c!=params.size()-1){
				parsedString += ",";
			}
			c++;
		}
		parsedString += ");";
		if(withTag){
			parsedString = "<script>"+parsedString+"</script>";
			
		}
		Debug.print(parsedString);
		return parsedString;
		
	}
	
	/**
	 * The main method.
	 * @param args the arguments
	 */
	public static void main(String[] args) {
		List<String> params = new ArrayList<String>();
		params.add("1");
		params.add("2");
		params.add("3");
		parse("sample", params, true);
		Debug.print(parse("sample", params, false));
	}

}
