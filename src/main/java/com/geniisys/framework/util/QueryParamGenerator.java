package com.geniisys.framework.util;

import java.util.Iterator;
import java.util.Map;

public class QueryParamGenerator {

	/**
	 * Generates string query param to be passed to the page, based on a parameter map
	 * @param params
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public static String generateQueryParams(Map<String, Object> params) {
		String query = new String("");
		Iterator iter;
		
		if (params != null) {
			iter = params.entrySet().iterator();
			
			while(iter.hasNext()) {
				Map.Entry<String, Object> entry = (Map.Entry<String, Object>)iter.next();
				query = query + entry.getKey() + "=" + ((entry.getValue() == null) ? "" : entry.getValue().toString().replaceAll("&", "&amp;").replaceAll("\u0025", "")) + "&"; //"\u0025" Added by Jerome 11.07.2016 SR 5747
			}
		}
		
		return query;
	}
}
