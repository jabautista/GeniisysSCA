package com.geniisys.lov.util;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.seer.framework.util.StringFormatter;

public class LOVUtil {

	private static SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(LOVUtil.class);
	
	public static void getLOV(Map<String, Object> params) throws SQLException, JSONException {
		String action = (String) params.get("ACTION");
		if ((String) params.get("filter") != null ){
			params.putAll((HashMap<String, Object>) JSONUtil.prepareMapFromJSON(new JSONObject((String) params.get("filter"))));
		}
		String lovEntity = (action.lastIndexOf('L') > 0 ? action.substring(3, action.lastIndexOf('L')) : action);
		log.info("Retrieving "+lovEntity+" lov...");
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		System.out.println("LOV params : " + params);
		List<?> list = getSqlMapClient().queryForList(action, params);
		//params.put("rows", new JSONArray((List<?>) StringFormatter.escapeHTMLInList(list)));
		params.put("rows", new JSONArray());
		for (Object o: list) { //added Niknokkk to handle escaping map
			if (o instanceof Map && o != null) {
				params.put("rows", new JSONArray((List<?>) StringFormatter.escapeHTMLInListOfMap(list)));
			}else{
				params.put("rows", new JSONArray((List<?>) StringFormatter.escapeHTMLInList(list)));
			}
			break;
		}
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		params.remove("filter"); // Kenneth L. - workaround to handle issue in filtering double quote " 10.08.2013
		log.info(list.size() + " " + lovEntity + " lov retrieved.");
		System.out.println(params);
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		LOVUtil.sqlMapClient = sqlMapClient;
	}

	public static SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}	
}