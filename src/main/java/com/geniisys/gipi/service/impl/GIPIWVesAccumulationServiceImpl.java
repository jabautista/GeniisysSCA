package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.gipi.dao.GIPIWVesAccumulationDAO;
import com.geniisys.gipi.entity.GIPIWVesAccumulation;
import com.geniisys.gipi.service.GIPIWVesAccumulationService;

public class GIPIWVesAccumulationServiceImpl implements GIPIWVesAccumulationService {
	private GIPIWVesAccumulationDAO gipiWVesAccumulationDAO;	

	public GIPIWVesAccumulationDAO getGipiWVesAccumulationDAO() {
		return gipiWVesAccumulationDAO;
	}

	public void setGipiWVesAccumulationDAO(
			GIPIWVesAccumulationDAO gipiWVesAccumulationDAO) {
		this.gipiWVesAccumulationDAO = gipiWVesAccumulationDAO;
	}

	@Override
	public List<Map<String, Object>> prepareGIPIWVesAccumulationForDelete(
			JSONArray delRows) throws JSONException {
		List<Map<String, Object>> vesAccList = new ArrayList<Map<String, Object>>();
		Map<String, Object> delMap = null;
		JSONObject objVesAcc = null;
		
		for(int i=0, length=delRows.length(); i < length; i++){
			objVesAcc = delRows.getJSONObject(i);
			delMap = new HashMap<String, Object>();
			
			delMap.put("parId", objVesAcc.isNull("parId") ? null : objVesAcc.getInt("parId"));
			delMap.put("itemNo", objVesAcc.isNull("itemNo") ? null : objVesAcc.getInt("itemNo"));
			
			vesAccList.add(delMap);			
			delMap = null;
		}
		
		return vesAccList;
	}

	@Override
	public List<GIPIWVesAccumulation> getGIPIWVesAccumulation(Integer parId)
			throws SQLException {		
		return this.getGipiWVesAccumulationDAO().getGIPIWVesAccumulation(parId);
	}

}
