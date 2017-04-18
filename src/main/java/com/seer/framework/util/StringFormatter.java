/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.seer.framework.util;

import java.lang.reflect.InvocationTargetException;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.lang.StringEscapeUtils;
import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.ExceptionHandler;


/**
 * The Class StringFormatter.
 */
public class StringFormatter {
	
	private static Logger log = Logger.getLogger(StringFormatter.class);
	/**
	 * Instantiates a new string formatter.
	 */
	private StringFormatter(){		
	}
	
	/**
	 * Zero pad.
	 * 
	 * @param n the n
	 * @param maxLength the max length
	 * 
	 * @return the string
	 */
	public static String zeroPad(int n, int maxLength) {
		return zeroPad(n+"", maxLength).toUpperCase();
	}

	/**
	 * Zero pad.
	 * 
	 * @param s the s
	 * @param maxLength the max length
	 * 
	 * @return the string
	 */
	public static String zeroPad(String s, int maxLength) {		
		if (s.startsWith("*")) {
			return asteriskPad(maxLength).toUpperCase();
		} else if ("00000000".equalsIgnoreCase(s)){
			return asteriskPad(maxLength).toUpperCase();
		}		
		return leftPad(s, '0', maxLength).toUpperCase();
	}

	/**
	 * Asterisk pad.
	 * @param maxLength the max length
	 * @return the string
	 */
	public static String asteriskPad(int maxLength) {
		String tmp = "*";
		return rightSpacePad(tmp, maxLength).toUpperCase();
	}
	
	/**
	 * Right space pad.
	 * 
	 * @param s the s
	 * @param maxLength the max length
	 * 
	 * @return the string
	 */
	public static String rightSpacePad(String s, int maxLength) {
		return rightPad(s, ' ', maxLength).toUpperCase();
	}
	
	/**
	 * Right pad.
	 * @param s the s
	 * @param padChar the pad char
	 * @param maxLength the max length
	 * 
	 * @return the string
	 */
	public static String rightPad(String s, char padChar, int maxLength) {
		log.info("rightpad");
		if (s==null) {
			s = "";
		}
		int padCount = maxLength - s.length();
		StringBuffer sb = new StringBuffer(s);
		for (int i = 0; i < padCount; i++) {
			sb.append(padChar);
		}
		return sb.toString().toUpperCase();
	}

	/**
	 * Left space pad.
	 * @param s the s
	 * @param maxLength the max length
	 * @return the string
	 */
	public static String leftSpacePad(String s, int maxLength) {
		return leftPad(s, ' ', maxLength).toUpperCase();
	}

	/**
	 * Left pad.
	 * @param s the s
	 * @param padChar the pad char
	 * @param maxLength the max length
	 * 
	 * @return the string
	 */
	public static String leftPad(String s, char padChar, int maxLength) {
		if (s==null) {
			s = "";
		}
		int padCount = maxLength - s.length();
		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < padCount; i++) {
			sb.append(padChar);
		}
		sb.append(s);
		return sb.toString().toUpperCase();
	}
	
	/**
	 * Replaces quote characters with empty character/String "" or ''.
	 * 
	 * @param str the str
	 * @return str without ' and "
	 */
	public static String replaceQuotes(String str) {
		return str != null ? (str.replaceAll("\"", "&#34;")).replaceAll("'", "&#039;") : "";
	}
	
	/**
	 * Replaces quote tags(&#34; or &#039;) with string " or '.
	 * @author Jerome Orio
	 * @param str the str
	 * @return str without &#34; and &#039;
	 */
	public static String replaceQuoteTagIntoQuotes(String str) {
		return str != null ? (str.replaceAll("&#34;", "\"")).replaceAll("&#039;", "'") : "";
	}
	
	/**
	 * 
	 * @param list
	 * @return 
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public static Object replaceQuotesInList(Object list){
		List<Object> objectList = (List<Object>) list;
		for(Object o: objectList){
			try {
				Map properties = BeanUtils.describe(o);
				Iterator i = properties.keySet().iterator();
				while(i.hasNext()){
					String property = (String) i.next();
					if (properties.containsKey(property)){
						Object j = properties.get(property);
						if (j instanceof String && j != null && (j.toString().contains("\"") || j.toString().contains("'"))) {
							BeanUtils.setProperty(o, property, StringFormatter.replaceQuotes(j.toString()));
						}
					}
				}
			}catch (NullPointerException e) {
				ExceptionHandler.logException(e);
			}catch (IllegalAccessException e) {
				ExceptionHandler.logException(e);
			} catch (InvocationTargetException e) {
				ExceptionHandler.logException(e);
			} catch (NoSuchMethodException e) {
				ExceptionHandler.logException(e);
			}
		}
		return objectList;
	}
	
	/**
	 * Replace all " or ' in an object with the string &#34; or &#039; tags 
	 * @author Jerome Orio
	 * @param object
	 * @return object without the " or '
	 */
	@SuppressWarnings("unchecked")
	public static Object replaceQuotesInObject(Object object){
		Object obj = object;
			try {
				Map<String, Object> properties = BeanUtils.describe(obj);
				Iterator<String> i = properties.keySet().iterator();
				while (i.hasNext()) {
					String property = (String) i.next();
					if (properties.containsKey(property)) {
						Object j = properties.get(property);
						if (j instanceof String && (j != null || !"".equals(j)) && (j.toString().contains("\"") || j.toString().contains("'"))) {
							BeanUtils.setProperty(obj, property, StringFormatter.replaceQuotes(j.toString()));
						}
					}
				}
			} catch (IllegalAccessException e) {
				ExceptionHandler.logException(e);
			} catch (InvocationTargetException e) {
				ExceptionHandler.logException(e);
			} catch (NoSuchMethodException e) {
				ExceptionHandler.logException(e);
			}
		return obj;
	}
	
	/**
	 * Replace all &#34; or &#039; tags in an object with the string " or '
	 * @author Jerome Orio
	 * @param object
	 * @return object without the &#34; or &#039; tags
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public static Object replaceQuoteTagIntoQuotesInObject(Object object){
		Object obj = object;
			try {
				Map properties = BeanUtils.describe(obj);
				Iterator<String> i = properties.keySet().iterator();
				while (i.hasNext()) {
					String property = (String) i.next();
					if (properties.containsKey(property)) {
						Object j = properties.get(property);
						if (j instanceof String && j != null && (j.toString().contains("&#34;") || j.toString().contains("&#039;"))) {
							BeanUtils.setProperty(obj, property, StringFormatter.escapeBackslash(StringFormatter.replaceQuoteTagIntoQuotes(j.toString())));
						}
					}
				}
			} catch (IllegalAccessException e) {
				ExceptionHandler.logException(e);
			} catch (InvocationTargetException e) {
				ExceptionHandler.logException(e);
			} catch (NoSuchMethodException e) {
				ExceptionHandler.logException(e);
			}
		return obj;
	}
	
	/**
	 * Replace all " or ' in List<Map<String, Object>> with the string &#34; or &#039; tags 
	 * @author Jerome Orio 10.06.2010
	 * @param list of map
	 * @return list of map without the " or '
	 */
	@SuppressWarnings("unchecked")
	public static Object replaceQuotesInListOfMap(Object list) {
		List<Map<String, Object>> l = (List<Map<String, Object>>) list;
		int ctr = 0;
			for (Map<String, Object> o: l) {
				Iterator<String> a = o.keySet().iterator();
				while (a.hasNext()){
					String key = a.next().toString();
					Object value = o.get(key);
					if (value instanceof String && value != null && (value.toString().contains("\"") || value.toString().contains("'"))){
						l.get(ctr).put(key, StringFormatter.replaceQuotes((String) value));
					}
				}
				ctr++;
			}
		return l;
	}
	
	/**
	 * Replace all " or ' in Map<String, Object> with the string &#34; or &#039; tags 
	 * @author Jerome Orio 10.11.2010
	 * @param map
	 * @return map without the " or '
	 */
	public static Map<String, Object> replaceQuotesInMap(Map<String, Object> param){
		Map<String, Object> map = param;
		Iterator<String> a = map.keySet().iterator();
		while (a.hasNext()){
			String key = a.next().toString();
			Object value = map.get(key);
			if (value instanceof String && value != null && (value.toString().contains("\"") || value.toString().contains("'"))){
				//map.remove(key); //comment by Nok to avoid java.util.ConcurrentModificationException 
				map.put(key, StringFormatter.replaceQuotes((String) value));
			}
		}
		return map;
	}
	
	/**
	 * Replace tildes.
	 * @param str the str
	 * @return the string
	 */
	public static String replaceTildes(String str) {
		return str != null ? (str.replaceAll("\u00f1", "&#241;").replaceAll("\u00D1", "&#209;")) : "";
	}
	
	/**
	 * Replaces html entity (<, >, &) in a string to its corresponding entity number (&#60;, &#62;, &#38;)
	 * @author andrew robes
	 * @param str - string to be escaped
	 * @return escaped string
	 */
	public static String escapeHTML(String str) {
		return str != null ? (str.replaceAll("&", "&#38;").replaceAll("<", "&#60;").replaceAll(">", "&#62;").replaceAll("\t", "&#09;")) : "";
	}

	//added by kenneth L. to handle \u000e PHILFIRE SR 0014299 
	public static String escapeHTML2(String str) {
		return str != null ? (str.replaceAll("&", "&#38;").replaceAll("<", "&#60;").replaceAll(">", "&#62;").replaceAll("\t", "&#09;").replaceAll("\u000e", "")) : "";
	}
	
	/**
	 * Replaces html entity number (&#60;, &#62;, &#38;) in a string to its corresponding html entity character (<, >, &)
	 * @author andrew robes
	 * @param str - string to be unescaped
	 * @return unescaped string
	 */
	public static String unescapeHTML(String str) {
		return str != null ? (str.replaceAll("&#60;", "<").replaceAll("&#62;", ">").replaceAll("&#38;", "&")) : "";
	}
	
	/**
	 * Replaces html entity number (&#38;, &#34;, &#039;, &#62;, &#60;, &#241;, &#209;) in a string to its corresponding html entity character (&, ", ', >, <, \u00f1, \u00D1) //Dren 02.19.2016 SR-21366
	 * @author Halley
	 * @param str - string to be unescaped
	 * @return unescaped string
	 */
	public static String unescapeHTML2(String str) {
		return str != null ? (str.replaceAll("&#38;", "&").replaceAll("&#34;", "\"").replaceAll("&#039;", "'").replaceAll("&#62;", ">").replaceAll("&#60;", "<").replaceAll("&#039;", "'").replaceAll("&#241;", "\u00f1").replaceAll("&#209;", "\u00D1")) : ""; //Dren 02.19.2016 SR-21366
	}
	
	/**
	 * Replaces backslashes in a string including \n to its corresponding html entity
	 * @author andrew robes
	 * @date 02.09.2012
	 * @param str
	 * @return escaped string
	 */
	public static String escapeBackslash(String str){
		return str != null ? (str.replaceAll("\\\\", "\\\\\\\\").replaceAll("(\r\n|\n)", "&#8629;").replaceAll("\t", "&#09;")) : "";
	}
		
	// andrew - 07162015 - 19741,19712,19806,19819,19452,19298
	public static String escapeBackslash3(String str){
		return str != null ? (str.replaceAll("\\\\", "&#92;").replaceAll("(\r\n|\n)", "&#8629;").replaceAll("\t", "&#09;")) : "";
	}
	
	public static String escapeBackslash4(String str){
		return str != null ? (str.replaceAll("(\r\n|\n)", "")) : "";
	}	//Dren 02.16.2016 SR-21366

	public static String unescapeBackslash(String str){
		return str != null ? (str.replaceAll("\\\\\\\\", "\\\\").replaceAll("&#8629;", "\n").replaceAll("&#09;", "\t")) : "";
	}
	
	// andrew - 07162015 - 19741,19712,19806,19819,19452,19298
	public static String unescapeBackslash3(String str){
		return str != null ? (str.replaceAll("&#92;", "\\\\").replaceAll("&#8629;", "\n").replaceAll("&#09;", "\t")) : "";
	}
	
	/**
	 * Replaces html entity (<, >, &, ", ', \u00f1, \u00D1, ~, \, \n) in a string to its corresponding html entity number (&#60;, &#62;, &#38;, &#34;, &#039;, &#241;, &#209;) //Dren 02.19.2016 SR-21366 
	 * @author andrew robes 
	 * @param str - string to be unescaped
	 * @return unescaped string
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public static Object escapeHTMLInList(Object list) {
		List<Object> l = (List<Object>) list;
		for (Object o: l) {
			try {
				// to handle list of maps (emman 07.29.2011)
				if (o instanceof Map && o != null) {
					Map<String, Object> objMap = (Map<String, Object>) o;
					Iterator i = objMap.entrySet().iterator();
					
					while (i.hasNext()) {
						Map.Entry entry = (Map.Entry) i.next();
						String property = (String) entry.getKey();
						Object j = objMap.get(property);
						
						if (j instanceof String && j != null && (j.toString().contains("\"") || j.toString().contains("'") || j.toString().contains(">") || j.toString().contains("<") || j.toString().contains("&") || j.toString().contains("\u00f1") || j.toString().contains("\u00D1") || j.toString().contains("\\") || j.toString().contains("\r\n") || j.toString().contains("\n") || j.toString().contains("\t"))) {
							BeanUtils.setProperty(o, property, StringFormatter.escapeBackslash(StringFormatter.replaceTildes(StringFormatter.replaceQuotes(StringFormatter.escapeHTML(j.toString())))));							
						}
					}
				} else {
					Map properties = BeanUtils.describe(o);					
					Iterator i = properties.keySet().iterator();
					while (i.hasNext()) {
						String property = (String) i.next();																		
						if (properties.containsKey(property)) {
							Object j = properties.get(property);							
							Class type = PropertyUtils.getPropertyType(o, property); // andrew 04.14.2012 - added validation to avoid exception encountered when property is of type List
							if(type.getName().equals("java.lang.String")){
								if (j instanceof String && j != null && (j.toString().contains("\"") || j.toString().contains("'") || j.toString().contains(">") || j.toString().contains("<") || j.toString().contains("&") || j.toString().contains("\u00f1") || j.toString().contains("\u00D1") || j.toString().contains("\\") || j.toString().contains("\r\n") || j.toString().contains("\n") || j.toString().contains("\t"))) {									
									BeanUtils.setProperty(o, property, StringFormatter.escapeBackslash(StringFormatter.replaceTildes(StringFormatter.replaceQuotes(StringFormatter.escapeHTML(j.toString())))));								
								}
							}
						}
					}
				}
			} catch (IllegalAccessException e) {
				ExceptionHandler.logException(e);
			} catch (InvocationTargetException e) {
				ExceptionHandler.logException(e);
			} catch (NoSuchMethodException e) {
				ExceptionHandler.logException(e);
			}
		}
		
		return l;
	}
	
	/**
	 * Replaces html entity (<, >, &, ", ', \u00f1, \u00D1, ~) in a string to its corresponding html entity number (&#60;, &#62;, &#38;, &#34;, &#039;) //Dren 02.19.2016 SR-21366
	 * @author andrew robes 
	 * @param str - string to be unescaped
	 * @return unescaped string
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public static Object escapeHTMLInList2(Object list) {
		List<Object> l = (List<Object>) list;
		for (Object o: l) {
			try {
				if (o instanceof Map && o != null) {
					Map<String, Object> objMap = (Map<String, Object>) o;
					Iterator i = objMap.entrySet().iterator();
					
					while (i.hasNext()) {
						Map.Entry entry = (Map.Entry) i.next();
						String property = (String) entry.getKey();
						Object j = objMap.get(property);
						
						if (j instanceof String && j != null && (j.toString().contains("\"") || j.toString().contains("'") || j.toString().contains(">") || j.toString().contains("<") || j.toString().contains("&") || j.toString().contains("\u00f1") || j.toString().contains("\u00D1") || j.toString().contains("\\") || j.toString().contains("\r\n") || j.toString().contains("\n"))) {
							BeanUtils.setProperty(o, property, StringFormatter.replaceTildes(StringFormatter.replaceQuotes(StringFormatter.escapeHTML(j.toString()))));							
						}
					}
				} else {
					Map properties = BeanUtils.describe(o);					
					Iterator i = properties.keySet().iterator();
					while (i.hasNext()) {
						String property = (String) i.next();																		
						if (properties.containsKey(property)) {
							Object j = properties.get(property);							
							Class type = PropertyUtils.getPropertyType(o, property);
							if(type.getName().equals("java.lang.String")){
								if (j instanceof String && j != null && (j.toString().contains("\"") || j.toString().contains("'") || j.toString().contains(">") || j.toString().contains("<") || j.toString().contains("&") || j.toString().contains("\u00f1") || j.toString().contains("\u00D1") || j.toString().contains("\\") || j.toString().contains("\r\n") || j.toString().contains("\n"))) {									
									BeanUtils.setProperty(o, property, StringFormatter.replaceTildes(StringFormatter.replaceQuotes(StringFormatter.escapeHTML(j.toString()))));								
								}
							}
						}
					}
				}
			} catch (IllegalAccessException e) {
				ExceptionHandler.logException(e);
			} catch (InvocationTargetException e) {
				ExceptionHandler.logException(e);
			} catch (NoSuchMethodException e) {
				ExceptionHandler.logException(e);
			}
		}
		
		return l;
	}
	
	/**
	 * 
	 * @param object
	 * @return
	 */
	@SuppressWarnings({ "rawtypes" })
	public static Object escapeHTMLInObject(Object object){
		Object obj = object;
			try {
				Map properties = BeanUtils.describe(obj);
				Iterator i = properties.keySet().iterator();
				while (i.hasNext()) {
					String property = (String) i.next();
					if (properties.containsKey(property)) {						
						Object j = properties.get(property);
						if (j instanceof String && j != null && (j.toString().contains("\"") || j.toString().contains("'") || j.toString().contains(">") || j.toString().contains("<") || j.toString().contains("&") || j.toString().contains("\u00f1") || j.toString().contains("\u00D1") || j.toString().contains("\\") || j.toString().contains("\r\n") || j.toString().contains("\n") || j.toString().contains("\t"))) {
							BeanUtils.setProperty(obj, property, StringFormatter.escapeBackslash(StringFormatter.replaceTildes(StringFormatter.replaceQuotes(StringFormatter.escapeHTML(j.toString())))));							
						}						
					}
				}
			} catch (IllegalAccessException e) {
				ExceptionHandler.logException(e);
			} catch (InvocationTargetException e) {
				ExceptionHandler.logException(e);
			} catch (NoSuchMethodException e) {
				ExceptionHandler.logException(e);
			}
		return obj;
	}
	
	/**
	 * @author steven ramirez
	 * @param object for expression language 
	 * @return
	 */
	@SuppressWarnings({ "rawtypes" })
	public static Object escapeHTMLForELInObject(Object object){
		Object obj = object;
			try {
				Map properties = BeanUtils.describe(obj);
				Iterator i = properties.keySet().iterator();
				while (i.hasNext()) {
					String property = (String) i.next();
					if (properties.containsKey(property)) {						
						Object j = properties.get(property);
						if (j instanceof String && j != null && (j.toString().contains("'") || j.toString().contains(">") || j.toString().contains("<") || j.toString().contains("&") || j.toString().contains("\u00f1") || j.toString().contains("\u00D1") || j.toString().contains("\\") || j.toString().contains("\r\n") || j.toString().contains("\n"))) {
							BeanUtils.setProperty(obj, property, StringFormatter.replaceTildes(StringFormatter.replaceQuotes(StringFormatter.escapeHTML(j.toString()))));							
						}						
					}
				}
			} catch (IllegalAccessException e) {
				ExceptionHandler.logException(e);
			} catch (InvocationTargetException e) {
				ExceptionHandler.logException(e);
			} catch (NoSuchMethodException e) {
				ExceptionHandler.logException(e);
			}
		return obj;
	}
	
	/**
	 * 
	 * @param list
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public static Object escapeHTMLInListOfMap(Object list) {
		List<Map<String, Object>> l = (List<Map<String, Object>>) list;
		int ctr = 0;
			for (Map<String, Object> o: l) {
				Iterator a = o.keySet().iterator();
				while (a.hasNext()){
					String key = a.next().toString();
					Object value = o.get(key);
					if (value instanceof String && value != null && (value.toString().contains("\"") || value.toString().contains("'") || value.toString().contains(">") || value.toString().contains("<") || value.toString().contains("&") || value.toString().contains("\u00f1") || value.toString().contains("\u00D1") || value.toString().contains("\\") || value.toString().contains("\r\n") || value.toString().contains("\n") || value.toString().contains("\t"))) {
						l.get(ctr).put(key, StringFormatter.escapeBackslash(StringFormatter.replaceTildes(StringFormatter.replaceQuotes(StringFormatter.escapeHTML(value.toString())))));		
					}
				}
				ctr++;
			}
		return l;
	}
	
	/**
	 * 
	 * @param param
	 * @return
	 */
	public static Map<String, Object> escapeHTMLInMap(Map<String, Object> param){
		Map<String, Object> map = param;
		Iterator<String> a = map.keySet().iterator();
		while (a.hasNext()){
			String key = a.next().toString();
			Object value = map.get(key);
			if (value instanceof String && value != null && (value.toString().contains("\"") || value.toString().contains("'") || value.toString().contains(">") || value.toString().contains("<") || value.toString().contains("&") || value.toString().contains("\u00f1") || value.toString().contains("\u00D1") || value.toString().contains("\\") || value.toString().contains("\r\n") || value.toString().contains("\n") || value.toString().contains("\t"))) {
				//map.remove(key); //map.remove(key); //comment by Nok to avoid java.util.ConcurrentModificationException 
				map.put(key, StringFormatter.escapeBackslash(StringFormatter.replaceTildes(StringFormatter.replaceQuotes(StringFormatter.escapeHTML(value.toString())))));
			}
		}
		return map;
	}

	/**
	 * Checks if a string is a number
	 * - this method disregards commas.
	 * @author rencela
	 * @param possibleNumberString
	 * @return 
	 */
	public static Boolean isNumber(String possibleNumberString){
		try{
			Double.parseDouble(possibleNumberString.replace(",", ""));
			return true;
		}catch (NumberFormatException e) {
			return false;
		}catch (Exception e) {
			return false;
		}
	}
	
	/**Gzelle 02022015 : add (&,\u00D1,\u00f1) //Dren 02.19.2016 SR-21366
	 */
	public static String unescapeHtmlJava(String str){
		return (StringEscapeUtils.unescapeHtml(StringEscapeUtils.unescapeJava(str.replaceAll("&#8629;", "\n"))).replaceAll("&#34;", "\"").replaceAll("&#039;", "\'").replaceAll("&#38;", "&").replaceAll("&#241;", "\u00f1").replaceAll("&#209;", "\u00D1")); // andrew - 07162015 - 19741,19712,19806,19819,19452,19298 //Dren 02.19.2016 SR-21366		
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public static Object escapeHTMLJavascriptInList(Object list) {
		List<Object> l = (List<Object>) list;
		for (Object o: l) {
			try {				
				if (o instanceof Map && o != null) {
					Map<String, Object> objMap = (Map<String, Object>) o;
					Iterator i = objMap.entrySet().iterator();
					
					while (i.hasNext()) {
						Map.Entry entry = (Map.Entry) i.next();
						String property = (String) entry.getKey();
						Object j = objMap.get(property);
						
						if (j instanceof String && j != null && (j.toString().contains("\"") || j.toString().contains("'") || j.toString().contains(">") || j.toString().contains("<") || j.toString().contains("&") || j.toString().contains("\u00f1") || j.toString().contains("\u00D1") || j.toString().contains("\\")  || j.toString().contains("\r\n") || j.toString().contains("\n") || j.toString().contains("\t"))) {
							BeanUtils.setProperty(o, property, StringFormatter.escapeBackslash(StringFormatter.replaceTildes(StringEscapeUtils.escapeJavaScript(StringFormatter.replaceQuotes(StringFormatter.escapeHTML(j.toString()))))));							
						}
					}
				} else {
					Map properties = BeanUtils.describe(o);
					Iterator i = properties.keySet().iterator();
					while (i.hasNext()) {
						String property = (String) i.next();
						if (properties.containsKey(property)) {
							Object j = properties.get(property);
							if (j instanceof String && j != null && (j.toString().contains("\"") || j.toString().contains("'") || j.toString().contains(">") || j.toString().contains("<") || j.toString().contains("&") || j.toString().contains("\u00f1") || j.toString().contains("\u00D1") || j.toString().contains("\\")  || j.toString().contains("\r\n") || j.toString().contains("\n") || j.toString().contains("\t"))) {
								BeanUtils.setProperty(o, property, StringFormatter.escapeBackslash(StringFormatter.replaceTildes(StringEscapeUtils.escapeJavaScript(StringFormatter.replaceQuotes(StringFormatter.escapeHTML(j.toString()))))));
							}
						}
					}
				}
			} catch (IllegalAccessException e) {
				ExceptionHandler.logException(e);
			} catch (InvocationTargetException e) {
				ExceptionHandler.logException(e);
			} catch (NoSuchMethodException e) {
				ExceptionHandler.logException(e);
			}
		}
		return l;
	}
	
	//same as escapeHTMLInList.  Added handling of \t - temporary solution to error encountered in RSIC :: bonok :: 11.22.2012
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public static Object escapeHTMLInList3(Object list) {
		List<Object> l = (List<Object>) list;
		for (Object o: l) {
			try {
				// to handle list of maps (emman 07.29.2011)
				if (o instanceof Map && o != null) {
					Map<String, Object> objMap = (Map<String, Object>) o;
					Iterator i = objMap.entrySet().iterator();
					
					while (i.hasNext()) {
						Map.Entry entry = (Map.Entry) i.next();
						String property = (String) entry.getKey();
						Object j = objMap.get(property);
						
						if (j instanceof String && j != null && (j.toString().contains("\"") || j.toString().contains("'") || j.toString().contains(">") || j.toString().contains("<") || j.toString().contains("&") || j.toString().contains("\u00f1") || j.toString().contains("\u00D1") || j.toString().contains("\\") || j.toString().contains("\r\n") || j.toString().contains("\n") || j.toString().contains("\t"))) {
							BeanUtils.setProperty(o, property, StringFormatter.escapeBackslash2(StringFormatter.replaceTildes(StringFormatter.replaceQuotes(StringFormatter.escapeHTML(j.toString())))));							
						}
					}
				} else {
					Map properties = BeanUtils.describe(o);					
					Iterator i = properties.keySet().iterator();
					while (i.hasNext()) {
						String property = (String) i.next();																		
						if (properties.containsKey(property)) {
							Object j = properties.get(property);							
							Class type = PropertyUtils.getPropertyType(o, property); // andrew 04.14.2012 - added validation to avoid exception encountered when property is of type List
							if(type.getName().equals("java.lang.String")){
								if (j instanceof String && j != null && (j.toString().contains("\"") || j.toString().contains("'") || j.toString().contains(">") || j.toString().contains("<") || j.toString().contains("&") || j.toString().contains("\u00f1") || j.toString().contains("\u00D1") || j.toString().contains("\\") || j.toString().contains("\r\n") || j.toString().contains("\n") || j.toString().contains("\t"))) {
									BeanUtils.setProperty(o, property, StringFormatter.escapeBackslash2(StringFormatter.replaceTildes(StringFormatter.replaceQuotes(StringFormatter.escapeHTML(j.toString())))));								
								}
							}
						}
					}
				}
			} catch (IllegalAccessException e) {
				ExceptionHandler.logException(e);
			} catch (InvocationTargetException e) {
				ExceptionHandler.logException(e);
			} catch (NoSuchMethodException e) {
				ExceptionHandler.logException(e);
			}
		}
		
		return l;
	}
	
	//same as escapeBackslash.  Added handling of \t - temporary solution to error encountered in RSIC :: bonok :: 11.22.2012
	public static String escapeBackslash2(String str){
		return str != null ? (str.replaceAll("\\\\", "\\\\\\\\").replaceAll("(\r\n|\n)", "&#8629;").replaceAll("\t","")) : "";
	}
	
	//same as escapeHTMLInObject.  Added handling of \t - temporary solution to error encountered in UCPB :: bonok :: 01.11.2013
	@SuppressWarnings({ "rawtypes" })
	public static Object escapeHTMLInObject2(Object object){
		Object obj = object;
			try {
				Map properties = BeanUtils.describe(obj);
				Iterator i = properties.keySet().iterator();
				while (i.hasNext()) {
					String property = (String) i.next();
					if (properties.containsKey(property)) {						
						Object j = properties.get(property);
						if (j instanceof String && j != null && (j.toString().contains("\"") || j.toString().contains("'") || j.toString().contains(">") || j.toString().contains("<") || j.toString().contains("&") || j.toString().contains("\u00f1") || j.toString().contains("\u00D1") || j.toString().contains("\\") || j.toString().contains("\r\n") || j.toString().contains("\n") || j.toString().contains("\t"))) {
							BeanUtils.setProperty(obj, property, StringFormatter.escapeBackslash(StringFormatter.replaceTildes(StringFormatter.replaceQuotes(StringFormatter.escapeHTML2(j.toString())))));							
						}						
					}
				}
			} catch (IllegalAccessException e) {
				ExceptionHandler.logException(e);
			} catch (InvocationTargetException e) {
				ExceptionHandler.logException(e);
			} catch (NoSuchMethodException e) {
				ExceptionHandler.logException(e);
			}
		return obj;
	}
	
	//same as escapeHTMLInList. added by kenneth L. to handle \u000e PHILFIRE SR 0014299 
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public static Object escapeHTMLInList4(Object list) {
		List<Object> l = (List<Object>) list;
		for (Object o: l) {
			try {
				if (o instanceof Map && o != null) {
					Map<String, Object> objMap = (Map<String, Object>) o;
					Iterator i = objMap.entrySet().iterator();
					
					while (i.hasNext()) {
						Map.Entry entry = (Map.Entry) i.next();
						String property = (String) entry.getKey();
						Object j = objMap.get(property);
						
						if (j instanceof String && j != null && (j.toString().contains("\"") || j.toString().contains("'") || j.toString().contains(">") || j.toString().contains("<") || j.toString().contains("&") || j.toString().contains("\u00f1") || j.toString().contains("\u00D1") || j.toString().contains("\\") || j.toString().contains("\r\n") || j.toString().contains("\n")  || j.toString().contains("\t"))) { //added condition for \t kenneth @ FGIC 10.28.2014
							BeanUtils.setProperty(o, property, StringFormatter.escapeBackslash(StringFormatter.replaceTildes(StringFormatter.replaceQuotes(StringFormatter.escapeHTML2(j.toString())))));							
						}
					}
				} else {
					Map properties = BeanUtils.describe(o);					
					Iterator i = properties.keySet().iterator();
					while (i.hasNext()) {
						String property = (String) i.next();																		
						if (properties.containsKey(property)) {
							Object j = properties.get(property);							
							Class type = PropertyUtils.getPropertyType(o, property);
							if(type.getName().equals("java.lang.String")){
								if (j instanceof String && j != null && (j.toString().contains("\"") || j.toString().contains("'") || j.toString().contains(">") || j.toString().contains("<") || j.toString().contains("&") || j.toString().contains("\u00f1") || j.toString().contains("\u00D1") || j.toString().contains("\\") || j.toString().contains("\r\n") || j.toString().contains("\n") || j.toString().contains("\t"))) { //added condition for \t kenneth @ FGIC 10.28.2014								
									BeanUtils.setProperty(o, property, StringFormatter.escapeBackslash(StringFormatter.replaceTildes(StringFormatter.replaceQuotes(StringFormatter.escapeHTML2(j.toString())))));								
								}
							}
						}
					}
				}
			} catch (IllegalAccessException e) {
				ExceptionHandler.logException(e);
			} catch (InvocationTargetException e) {
				ExceptionHandler.logException(e);
			} catch (NoSuchMethodException e) {
				ExceptionHandler.logException(e);
			}
		}
		
		return l;
	}
	
	@SuppressWarnings("unchecked")
	public static JSONObject escapeHTMLInJSONObject(JSONObject jsonObject) throws JSONException {		
		Iterator<String> iterator = jsonObject.keys();		
		JSONObject updateJsonObject = new JSONObject();
		
		while(iterator.hasNext()) {
			String key = iterator.next();
			Object val = jsonObject.get(key);
			
			if (val instanceof String && val != null && (val.toString().contains("\"") || val.toString().contains("'") || val.toString().contains(">") || val.toString().contains("<") || val.toString().contains("&") || val.toString().contains("\u00f1") || val.toString().contains("\u00D1") || val.toString().contains("\\") || val.toString().contains("\r\n") || val.toString().contains("\n") || val.toString().contains("\t"))) {				
				val = StringFormatter.escapeBackslash3(StringFormatter.replaceTildes(StringFormatter.replaceQuotes(StringFormatter.escapeHTML2(val.toString()))));  // andrew - 07162015 - 19741,19712,19806,19819,19452,19298
			} else if (jsonObject.get(key) != null && jsonObject.get(key) instanceof JSONArray){ // andrew - 07102015 - 18164 
				val = StringFormatter.escapeHTMLInJSONArray((JSONArray) val);
			} else if (val instanceof JSONObject && val != null) {
				val = StringFormatter.escapeHTMLInJSONObject((JSONObject) val);
			}
			
			updateJsonObject.put(key, val);
		}
		
		return updateJsonObject;
	}
	
	public static JSONArray escapeHTMLInJSONArray(JSONArray jsonArray) throws JSONException {
		JSONArray updatedJsonArray = new JSONArray();		
		
		for(int index = 0; index < jsonArray.length(); index++) {			
			JSONObject jsonObject = jsonArray.getJSONObject(index);			
			jsonObject = escapeHTMLInJSONObject(jsonObject);			
			updatedJsonArray.put(index, jsonObject);
		}
		
		return updatedJsonArray;
	}
}