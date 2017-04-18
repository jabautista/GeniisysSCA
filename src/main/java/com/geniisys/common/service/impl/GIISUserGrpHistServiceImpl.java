package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISUserGrpHistDAO;
import com.geniisys.common.entity.GIISUserGrpHist;
import com.geniisys.common.service.GIISUserGrpHistService;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.StringFormatter;

public class GIISUserGrpHistServiceImpl implements GIISUserGrpHistService{

	private Logger log = Logger.getLogger(GIISUserGrpHistServiceImpl.class);
	
	GIISUserGrpHistDAO giisUserGrpHistDao;

	public GIISUserGrpHistDAO getGiisUserGrpHistDao() {
		return giisUserGrpHistDao;
	}

	public void setGiisUserGrpHistDao(GIISUserGrpHistDAO giisUserGrpHistDao) {
		this.giisUserGrpHistDao = giisUserGrpHistDao;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getUserHistory(Map<String, Object> params)
			throws SQLException, JSONException {
		//return this.getGiisUserGrpHistDao().getUserHistory(userId);
		log.info("getUserHistory");
		Map<String, Object> filterMap = new HashMap<String, Object>();
		Integer page = (Integer) params.get("currentPage") == null ? 1 : (Integer) params.get("currentPage");
		Integer pageSize = ApplicationWideParameters.PAGE_SIZE;
		TableGridUtil grid = new TableGridUtil(page, pageSize);
		JSONObject jsonFilter = null;
		
		jsonFilter = new JSONObject(params.get("filter") == "" ? "{}" : (String) params.get("filter"));
		
		filterMap = this.prepareFilterString(jsonFilter);
		filterMap.put("userId", params.get("userId"));
		
		List<GIISUserGrpHist> giisUserGrpHistList = this.giisUserGrpHistDao.getUserHistory(filterMap);
		List<GIISUserGrpHist> returnedList = new ArrayList<GIISUserGrpHist>();
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		int startRec = (page-1) * pageSize;
		int endRec = (pageSize * page - 1) < giisUserGrpHistList.size()-1 ? pageSize * page - 1 : giisUserGrpHistList.size()-1; 
		for (int i=startRec; i<=endRec; i++){
			returnedList.add(giisUserGrpHistList.get(i));
		}
		double total = (float) giisUserGrpHistList.size() / (float) pageSize;
		int finalTotal = (int) Math.ceil(total);
		params.put("rows", new JSONArray((List<GIISUserGrpHist>) StringFormatter.replaceQuotesInList(returnedList)));
		params.put("pages", finalTotal);
		params.put("total", giisUserGrpHistList.size());
		System.out.println(params.toString());
		return params;
	}
	
	private Map<String, Object> prepareFilterString(JSONObject jsonFilter) throws JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
	
		String histIdFilter = jsonFilter.isNull("histId") ? "%%" : "%" + jsonFilter.getString("histId").toUpperCase() + "%";
		String oldUserGrpFilter = jsonFilter.isNull("oldUserDesc") ? "%%" : "%" + jsonFilter.getString("oldUserDesc").toUpperCase() + "%";
		String newUserGrpFilter = jsonFilter.isNull("newUserDesc") ? "%%" : "%" + jsonFilter.getString("newUserDesc").toUpperCase() + "%";
		String lastUpdateFilter = jsonFilter.isNull("lastUpdate") ? "%%" : "%" + jsonFilter.getString("lastUpdate").toUpperCase() + "%";
		
		params.put("histId", histIdFilter);
		params.put("oldUserGrp", oldUserGrpFilter);
		params.put("newUserGrp", newUserGrpFilter);
		params.put("lastUpdate", lastUpdateFilter);
				
		return params;
	}
}
