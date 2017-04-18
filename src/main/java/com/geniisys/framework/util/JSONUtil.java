/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	
 * Created By	:	rencela
 * Create Date	:	May 10, 2011
 ***************************************************/
package com.geniisys.framework.util;

import java.lang.reflect.InvocationTargetException;
import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.lang.StringEscapeUtils;
import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.seer.framework.util.StringFormatter;

public class JSONUtil {
	private static Logger log = Logger.getLogger(JSONUtil.class);
	
	/**
	 * Prepare List of Object from JSON
	 * @author Nok
	 * @since 05.10.2011
	 * @param rows - JSONArray to prepare
	 * 		  userId - current user id
	 * 		  pojoClass - Class of entity to be used
	 * @return List of Object
	 */
	@SuppressWarnings("rawtypes")
	public static Object prepareObjectListFromJSON(JSONArray rows, String userId, Class pojoClass){
		log.info("prepareObjectListFromJSON");
		List<Object> objectList = new ArrayList<Object>();
		try {
			for(int index=0; index<rows.length(); index++) {
				Object pojo = pojoClass.newInstance();
				Map properties = PropertyUtils.describe(pojo);
				Iterator i = properties.keySet().iterator();
				while(i.hasNext()){
					String property = (String) i.next();
					if (properties.containsKey(property)) {
						Object cl = (Object) PropertyUtils.getPropertyType(pojo, property);
						if (cl == String.class) {
							String val = rows.getJSONObject(index).isNull(property) ? "" :rows.getJSONObject(index).getString(property);
							val = "userId".equals(property) || "appUser".equals(property) ? userId :val;
							if(PropertyUtils.isWriteable(pojo, property)) {
								PropertyUtils.setProperty(pojo, property, StringEscapeUtils.unescapeHtml(StringFormatter.unescapeBackslash(val)).replaceAll("u000a", "\\\n")); //Added by Joms Diago 04152013
							}
						}else if (cl == Integer.class || cl == int.class){							
							PropertyUtils.setProperty(pojo, property, rows.getJSONObject(index).isNull(property) || "".equals(rows.getJSONObject(index).getString(property)) ? null :Integer.parseInt(rows.getJSONObject(index).getString(property).replaceAll(",", "")));
						} else if(cl == Long.class){
							PropertyUtils.setProperty(pojo, property, rows.getJSONObject(index).isNull(property) || "".equals(rows.getJSONObject(index).getString(property)) ? null :Long.parseLong(rows.getJSONObject(index).getString(property).replaceAll(",", "")));
						}else if (cl == BigDecimal.class){
							PropertyUtils.setProperty(pojo, property, rows.getJSONObject(index).isNull(property) || "".equals(rows.getJSONObject(index).getString(property)) ? null :new BigDecimal(rows.getJSONObject(index).getString(property).replaceAll(",", "")));
						}else if (cl == Double.class){ //marco - 11.12.2012 - added condition for Double
							PropertyUtils.setProperty(pojo, property, rows.getJSONObject(index).isNull(property) || "".equals(rows.getJSONObject(index).getString(property)) ? null :Double.parseDouble(rows.getJSONObject(index).getString(property).replaceAll(",", "")));
						}else if (cl == Date.class){
							SimpleDateFormat sdf = new SimpleDateFormat("".equals(ApplicationWideParameters.DATE_FORMAT) ? ApplicationWideParameters.DEFAULT_DATE_FORMAT :ApplicationWideParameters.DATE_FORMAT);
							SimpleDateFormat dtf = new SimpleDateFormat("EEE MMM dd HH:mm:ss zzz yyyy");
							SimpleDateFormat dft = new SimpleDateFormat(ApplicationWideParameters.DEFAULT_DATE_FORMAT);
							try{
								PropertyUtils.setProperty(pojo, property, rows.getJSONObject(index).isNull(property) || "".equals(rows.getJSONObject(index).getString(property)) ? null :sdf.parse(StringEscapeUtils.unescapeHtml(rows.getJSONObject(index).getString(property))));
							}catch(ParseException e) {
								try{
									PropertyUtils.setProperty(pojo, property, rows.getJSONObject(index).isNull(property) || "".equals(rows.getJSONObject(index).getString(property)) ? null :dtf.parse(StringEscapeUtils.unescapeHtml(rows.getJSONObject(index).getString(property))));
								}catch(ParseException ee){
									PropertyUtils.setProperty(pojo, property, rows.getJSONObject(index).isNull(property) || "".equals(rows.getJSONObject(index).getString(property)) ? null :dft.parse(StringEscapeUtils.unescapeHtml(rows.getJSONObject(index).getString(property))));
								}
							}
						}
					}
				}
				objectList.add(pojo);
			}
		} catch (IllegalAccessException e) {
			ExceptionHandler.logException(e);
		} catch (InvocationTargetException e) {
			ExceptionHandler.logException(e);
		} catch (NoSuchMethodException e) {
			ExceptionHandler.logException(e);
		} catch (InstantiationException e) {
			ExceptionHandler.logException(e);
		} catch (ParseException e) {
			ExceptionHandler.logException(e);
		} catch (JSONException e) {
			ExceptionHandler.logException(e);
		}
		return objectList;
	}
	
	/**
	 * Prepare Object from JSON
	 * @author Nok
	 * @since 05.16.2011
	 * @param rows - JSONArray to prepare
	 * 		  userId - current user id
	 * 		  pojoClass - Class of entity to be used
	 * @return Object
	 */
	@SuppressWarnings({ "rawtypes" })
	public static Object prepareObjectFromJSON(JSONObject row, String userId, Class pojoClass){
		log.info("prepareObjectFromJSON");
		Object object = new Object();
		try {
			Object pojo = pojoClass.newInstance();
			Map properties = PropertyUtils.describe(pojo);
			Iterator i = properties.keySet().iterator();
			while(i.hasNext()){
				String property = (String) i.next();
				if (properties.containsKey(property)) {
					Object cl = (Object) PropertyUtils.getPropertyType(pojo, property);
					if (cl == String.class) {
						String val = row.isNull(property) ? "" :row.getString(property);
						val = "userId".equals(property) || "appUser".equals(property) ? userId :val;
						PropertyUtils.setProperty(pojo, property, StringEscapeUtils.unescapeHtml(val).replaceAll("u000a", "\\\n"));
					}else if (cl == Integer.class || cl == int.class || cl == Long.class){
						PropertyUtils.setProperty(pojo, property, row.isNull(property) || "".equals(row.getString(property)) ? null :Integer.parseInt(row.getString(property).replaceAll(",", "")));
					}else if (cl == BigDecimal.class){
						PropertyUtils.setProperty(pojo, property, row.isNull(property) || "".equals(row.getString(property)) ? null :new BigDecimal(row.getString(property).replaceAll(",", "")));
					}else if (cl == Date.class){
						SimpleDateFormat sdf = new SimpleDateFormat("".equals(ApplicationWideParameters.DATE_FORMAT) ? ApplicationWideParameters.DEFAULT_DATE_FORMAT :ApplicationWideParameters.DATE_FORMAT);
						SimpleDateFormat dtf = new SimpleDateFormat("EEE MMM dd HH:mm:ss zzz yyyy");
						SimpleDateFormat dft = new SimpleDateFormat(ApplicationWideParameters.DEFAULT_DATE_FORMAT);
						try{
							PropertyUtils.setProperty(pojo, property, row.isNull(property) || "".equals(row.getString(property)) ? null :sdf.parse(StringEscapeUtils.unescapeHtml(row.getString(property))));
						} catch (ParseException e) {
							try{
								PropertyUtils.setProperty(pojo, property, row.isNull(property) || "".equals(row.getString(property)) ? null :dtf.parse(StringEscapeUtils.unescapeHtml(row.getString(property))));
							}catch (ParseException ee) {
								PropertyUtils.setProperty(pojo, property, row.isNull(property) || "".equals(row.getString(property)) ? null :dft.parse(StringEscapeUtils.unescapeHtml(row.getString(property))));
							}
						}
					}
				}
			}
			object = pojo;
		} catch (IllegalAccessException e) {
			ExceptionHandler.logException(e);
		} catch (InvocationTargetException e) {
			ExceptionHandler.logException(e);
		} catch (NoSuchMethodException e) {
			ExceptionHandler.logException(e);
		} catch (InstantiationException e) {
			ExceptionHandler.logException(e);
		} catch (ParseException e) {
			ExceptionHandler.logException(e);
		} catch (JSONException e) {
			ExceptionHandler.logException(e);
		}
		return object;
	}
	
	/**
	 * Prepare Java Map from JSON
	 * @author Nok
	 * @since 05.31.2011
	 * @param row - JSONObject to prepare
	 * @return Map
	 */
	@SuppressWarnings("rawtypes")
	public static HashMap<String, Object> prepareMapFromJSON(JSONObject row){
		log.info("prepareMapForJSON");
		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			Iterator i = row.keys();
			while(i.hasNext()){
				String key = (String) i.next();
				Object val = row.get(key);
				map.put(key, val);
			}
		} catch (JSONException e) {
			ExceptionHandler.logException(e);
		}
		return map;
	}	
	
	/**
	 * Prepare Java Map List from JSONArray
	 * @author andrew robes
	 * @since 08.18.2011
	 * @param rows - JSONArray to prepare
	 * @return List of Map
	 */
	@SuppressWarnings("rawtypes")
	public static List<Map<String, Object> >prepareMapListFromJSON(JSONArray rows){
		log.info("prepareMapListForJSON");
		List<Map<String, Object>> mapList = new ArrayList<Map<String, Object>>();
		Map<String, Object> map = null;
		try {
			for(int index=0; index<rows.length(); index++) {
				map = new HashMap<String, Object>();
				Iterator i = rows.getJSONObject(index).keys();
				while(i.hasNext()){
					String key = (String) i.next();
					Object val = rows.getJSONObject(index).isNull(key) || "".equals(rows.getJSONObject(index).getString(key)) ? null : rows.getJSONObject(index).get(key);
					map.put(key, val);
				}
				mapList.add(map);
			}			
		} catch (JSONException e) {
			ExceptionHandler.logException(e);
		}
		return mapList;
	}
	
// FOR JSONArrays -------------	
	
	/**
	 * Retrieves a BigDecimal object from :rows having <i>index</i> and <i>key</i>. This generic method performs basic checking for the specified object.
	 * - checks for null keys
	 * - checks for blank keys
	 * - this method also logs the errors encountered in the process
	 * @param JSONArray rows
	 * @param index of JSONArray
	 * @param key String
	 * @author rencela
	 * @return the value of the target bigdecimal
	 * @return 0 if it does not pass the validation
	 */
	public static BigDecimal getBigDecimal(JSONArray rows, Integer index, String key){
		log.info("getBigDecimal for Array");
		BigDecimal value = new BigDecimal(0);
		try{
			if(!rows.getJSONObject(index).isNull(key)){
				String strValue = rows.getJSONObject(index).getString(key);
				if(!strValue.isEmpty()){
					if(StringFormatter.isNumber(strValue)){
						value = new BigDecimal(strValue);
					}else{
						log.info("JSONArray key:" + key + " in index " + index + " is NaN");
					}
				}else{
					log.info("JSONArray key:" + key + " in index " + index + " is BLANK");
				}
			}else{
				log.info("JSONArray key:" + key + " in index " + index + " is NULL");
			}
		}catch(JSONException e){
			ExceptionHandler.logException(e);
		}catch(NumberFormatException e){
			ExceptionHandler.logException(e);
		}catch(Exception e){
			ExceptionHandler.logException(e);
		}
		return value;
	}
	
	/**
	 * Retrieves a Date object from :rows having <i>index</i> and <i>key</i>. This generic method performs basic checking for the specified object.
	 * - checks for null keys
	 * - checks for blank keys
	 * - this method also logs the errors encountered in the process
	 * @param JSONArray rows
	 * @param index of JSONArray
	 * @param key String
	 * @author rencela
	 * @return the value of the target date
	 * @return <b>current date</b> 
	 */
	public static Date getDate(JSONArray rows, Integer index, String key){	
		Date d = new Date();
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		try{
			if(!rows.getJSONObject(index).isNull(key)){
				if(!rows.getJSONObject(index).getString(key).isEmpty()){
					d = df.parse(rows.getJSONObject(index).getString(key));
				}else{
					log.info("JSONArray key:" + key + " in index " + index + " is empty string");
				}
			}else{
				log.info("JSONArray key:" + key + " in index " + index + " is NULL");
			}
		}catch(JSONException e){
			ExceptionHandler.logException(e);
		}catch(ParseException e){
			ExceptionHandler.logException(e);
		}catch(Exception e){
			ExceptionHandler.logException(e);
		}
		return d;
	}
	
	
	/**
	 * Retrieves a String from :rows having <i>index</i> and <i>key</i>. This generic method performs basic checking for the specified object.
	 * - checks for null keys
	 * - checks for blank keys
	 * @param JSONArray rows
	 * @param index of JSONArray
	 * @param key String
	 * @author rencela
	 * @return the value of the target String
	 * @return empty (blank) string if it does not pass the validation
	 */
	public static String getString(JSONArray rows, Integer index, String key){
		String value = "";
		try{
			if(!rows.getJSONObject(index).isNull(key)){
				value = rows.getJSONObject(index).getString(key);
			}else{
				log.info("JSONArray key:" + key + " in index " + index + " is NULL");
			}
		}catch(JSONException e){
			ExceptionHandler.logException(e);
		}catch(Exception e){
			ExceptionHandler.logException(e);
		}
		return value;
	}
	
	/**
	 * Retrieves json array from the specified <i>rows</i> using <i>index</i> and <i>key</i>
	 * @param json array rows
	 * @param index of json array
	 * @param string key of json objects
	 * @author rencela
	 * @return JSONArray 
	 */
	public static JSONArray getJSONArray(JSONArray rows, Integer index, String key){
		JSONArray listWithinAList = new JSONArray();
		try{
			if(!rows.getJSONObject(index).isNull(key)){
				return rows.getJSONObject(index).getJSONArray(key);
			}else{
				log.info("JSONArray key:" + key + " in index " + index + " is NULL");
			}
		}catch(JSONException e){
			ExceptionHandler.logException(e);
		}catch(Exception e){
			ExceptionHandler.logException(e);
		}
		return listWithinAList;
	}
	
	/**
	 * Retrieves a Integer object from :rows having <i>index</i> and <i>key</i>. This generic method performs basic checking for the specified object.
	 * - checks for null keys
	 * - checks for blank keys
	 * - this method also logs the errors encountered in the process
	 * @param JSONArray rows
	 * @param index of JSONArray
	 * @param key String
	 * @author rencela
	 * @return the value of the target date
	 * @return <b>current date</b> 
	 */
	public static Integer getInteger(JSONArray rows, Integer index, String key){
		//Integer intValue = 0; // andrew - 05.18.2011 - null Integer values must be inserted in the database tables as null, 0 values inserted to tables are causing errors specifically to those with reference tables  
		Integer intValue = null; 
		try{
			if(!rows.getJSONObject(index).isNull(key)){
				String str = rows.getJSONObject(index).getString(key);
				if(StringFormatter.isNumber(str)){
					intValue = Integer.parseInt(str);
				}else{
					log.info("JSONArray key:" + key + " in index " + index + " is NaN");
				}
			}else{
				log.info("JSONArray key:" + key + " in index " + index + " is NULL");
			}
		}catch(JSONException e){
			ExceptionHandler.logException(e);
		}catch(NumberFormatException e){
			ExceptionHandler.logException(e);
		}catch(Exception e){
			ExceptionHandler.logException(e);
		}
		return intValue;
	}
	
// FOR JSONObject -----------
	
	/**
	 * Retrieve BigDecimal from object
	 * @param json object
	 * @param key
	 * @return extracted bigDecimal
	 */
	public static BigDecimal getBigDecimal(JSONObject object, String key){
		log.info("getBigDecimal for object");
		BigDecimal value = new BigDecimal(0);
		try{
			value = new BigDecimal(object.getDouble(key));
		}catch(JSONException e){
			ExceptionHandler.logException(e);
		}catch(NumberFormatException e){
			ExceptionHandler.logException(e);
		}catch(Exception e){
			ExceptionHandler.logException(e);
		}
		return value;
	}
	
	/**
	 * Retrieve date from json object 
	 * @param object
	 * @param key
	 * @return extracted date
	 */
	public static Date getDate(JSONObject object, String key){
		Date value = new Date();
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		try{
			value = df.parse(object.getString(key));
		}catch(JSONException e){
			ExceptionHandler.logException(e);
		}catch(ParseException e){
			ExceptionHandler.logException(e);
		}catch(Exception e){
			ExceptionHandler.logException(e);
		}
		return value;
	}
	
	/**
	 * Retrieve integer object from json object
	 * @param object
	 * @param key
	 * @return extract integer
	 */
	public static Integer getInteger(JSONObject object, String key){
		Integer value = null; 
		try{
			value = object.getInt(key);
		}catch(JSONException e){
			ExceptionHandler.logException(e);
		}catch(NumberFormatException e){
			ExceptionHandler.logException(e);
		}catch(Exception e){
			ExceptionHandler.logException(e);
		}
		return value;
	}
	
	/**
	 * Retrieve String from json object
	 * @param json object
	 * @param key
	 * @return extracted string
	 */
	public static String getString(JSONObject object, String key){
		String value = "";
		try{
			value = object.getString(key);
		}catch(JSONException e){
			ExceptionHandler.logException(e);
		}catch(Exception e){
			ExceptionHandler.logException(e);
		}
		return value;
	}
}