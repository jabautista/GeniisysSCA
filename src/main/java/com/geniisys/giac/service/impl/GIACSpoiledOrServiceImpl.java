package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACSpoiledOrDAO;
import com.geniisys.giac.entity.GIACSpoiledOr;
import com.geniisys.giac.service.GIACSpoiledOrService;
import com.seer.framework.util.Debug;

public class GIACSpoiledOrServiceImpl implements GIACSpoiledOrService {

	private GIACSpoiledOrDAO giacSpoiledOrDAO;
	private static Logger logger = Logger.getLogger(GIACSpoiledOrServiceImpl.class);
	
	@Override
	public void getGIACSpoiledOrListing(Map<String, Object> params) throws SQLException, JSONException, ParseException {
		logger.info("Preparing GIAC Spoiled OR Table Grid...");
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		Debug.print("FILTERS: " + params.get("filter"));
		params.put("filter", this.prepareSpoiledOrFilter((String) params.get("filter")));
		List<GIACSpoiledOr> list = this.getGiacSpoiledOrDAO().getGIACSpoiledOrListing(params);
		params.put("rows", new JSONArray(list));
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		logger.info("GIAC Spoiled OR Table Grid preparation done.");
	}

	public void setGiacSpoiledOrDAO(GIACSpoiledOrDAO giacSpoiledOrDAO) {
		this.giacSpoiledOrDAO = giacSpoiledOrDAO;
	}

	public GIACSpoiledOrDAO getGiacSpoiledOrDAO() {
		return giacSpoiledOrDAO;
	}

	@Override
	public void saveSpoiledOrDtls(String params, String userId) throws SQLException, JSONException, ParseException {
		JSONObject objParameters = new JSONObject(params);
		Debug.print("JSON: " + objParameters);
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("addedSpoiledOr", this.prepareSpoiledOr(new JSONArray(objParameters.getString("addedSpoiledOr")), userId));
		allParams.put("modifiedSpoiledOr", this.prepareSpoiledOr(new JSONArray(objParameters.getString("modifiedSpoiledOr")), userId));
		Debug.print("Service PARAMETERS BEFORE DAO");
		this.giacSpoiledOrDAO.saveSpoiledOrDtls(allParams);
	}
	
	public List<Map<String, Object>> prepareSpoiledOr(JSONArray setRows, String userId) throws JSONException, ParseException{

		Map<String, Object> addModItem = null;
		List<Map<String, Object>> setaddedModifiedSpoiledOr = new ArrayList<Map<String, Object>>();
		for(int index=0; index<setRows.length(); index++) {
			addModItem  = new HashMap<String, Object>();
			DateFormat sdf = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
			DateFormat sdf2 = new SimpleDateFormat("MM-dd-yyyy");
			addModItem.put("orNo", setRows.getJSONObject(index).isNull("orNo") ? null : setRows.getJSONObject(index).getInt("orNo"));
			addModItem.put("orPref", setRows.getJSONObject(index).isNull("orPref") ? null : setRows.getJSONObject(index).getString("orPref"));
			addModItem.put("origOrNo", setRows.getJSONObject(index).isNull("origOrNo") ? null : setRows.getJSONObject(index).getInt("origOrNo"));
			addModItem.put("origOrPref", setRows.getJSONObject(index).isNull("origOrPref") ? null : setRows.getJSONObject(index).getString("origOrPref"));
			addModItem.put("fundCd", setRows.getJSONObject(index).isNull("fundCd") ? null : setRows.getJSONObject(index).getString("fundCd"));
			addModItem.put("branchCd", setRows.getJSONObject(index).isNull("branchCd") ? null : setRows.getJSONObject(index).getString("branchCd"));
			addModItem.put("spoilTag", setRows.getJSONObject(index).isNull("spoilTag") ? null : setRows.getJSONObject(index).getString("spoilTag"));
			addModItem.put("spoilDate", setRows.getJSONObject(index).isNull("spoilDate") ? null : sdf.parseObject(setRows.getJSONObject(index).getString("spoilDate")));
			addModItem.put("orDate", setRows.getJSONObject(index).get("orDate").equals("") ? null : sdf2.parse(setRows.getJSONObject(index).getString("orDate")));
			addModItem.put("userId", userId);
			Debug.print("PARAMETER PASSED: " + addModItem);
			setaddedModifiedSpoiledOr.add(addModItem);
		}
		return setaddedModifiedSpoiledOr;
	}
	
	private Map<String, Object> prepareSpoiledOrFilter(String filter) throws JSONException, ParseException{
		Map<String, Object> spoiledOr = new HashMap<String, Object>();
		JSONObject jsonSpoiledOrFilter = null;
		DateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		
		if(null == filter){
			jsonSpoiledOrFilter = new JSONObject();
		}else{
			jsonSpoiledOrFilter = new JSONObject(filter);
		}
		spoiledOr.put("orPref", jsonSpoiledOrFilter.isNull("orPref") ?  null : jsonSpoiledOrFilter.getString("orPref").toUpperCase());
		spoiledOr.put("orNo", jsonSpoiledOrFilter.isNull("orNo") ? null : jsonSpoiledOrFilter.getInt("orNo"));
		spoiledOr.put("orDate", jsonSpoiledOrFilter.isNull("orDate") ? null : sdf.parse(jsonSpoiledOrFilter.getString("orDate")));
		
		return spoiledOr;
	}

	@Override
	public String validateSpoiledOr(Map<String, Object> params)	throws SQLException {
		// TODO Auto-generated method stub
		return this.giacSpoiledOrDAO.validateSpoiledOr(params);
	}

}
