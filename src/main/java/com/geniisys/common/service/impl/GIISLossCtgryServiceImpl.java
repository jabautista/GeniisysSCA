package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;


import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISLossCtgryDAO;
import com.geniisys.common.entity.GIISCollateralType;
import com.geniisys.common.entity.GIISLossCtgry;
import com.geniisys.common.service.GIISLossCtgryService;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.StringFormatter;

public class GIISLossCtgryServiceImpl implements GIISLossCtgryService{
	
	private GIISLossCtgryDAO giisLossCtgryDAO;
	
	/**
	 * @return the giisLossCtgryDAO
	 */
	public GIISLossCtgryDAO getGiisLossCtgryDAO() {
		return giisLossCtgryDAO;
	}


	/**
	 * @param giisLossCtgryDAO the giisLossCtgryDAO to set
	 */
	public void setGiisLossCtgryDAO(GIISLossCtgryDAO giisLossCtgryDAO) {
		this.giisLossCtgryDAO = giisLossCtgryDAO;
	}


	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.service.GIISLossCtgryService#getLossDtls(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getLossDtls(Map<String, Object> params) throws SQLException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		System.out.println("startRow: " + grid.getStartRow() + " endRow: " + grid.getEndRow());
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		
		List<Map<String, Object>> catList = this.getGiisLossCtgryDAO().getLossDtls(params);
		
		params.put("rows", new JSONArray((List<Map<String, Object>>)StringFormatter.replaceQuotesInList(catList)));
		grid.setNoOfPages(catList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		System.out.println("Pages: " + grid.getNoOfPages());
		System.out.println("Total: " + grid.getNoOfRows());
		
		return params;
	}


	@Override
	public JSONObject fetchCorrespondingNatureOfLossBasedOnLineCd(
			HttpServletRequest request) throws SQLException,
			JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		Map<String, Object> lossCatDescDetails = this.giisLossCtgryDAO.fetchCorrespondingNatureOfLossBasedOnLineCd(params);
		JSONObject lossCatDescDetailsJSON = new JSONObject(lossCatDescDetails);
		return lossCatDescDetailsJSON;
	}
	
	@Override
	public JSONObject showGicls105(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGicls105RecList");	
		params.put("lineCd", request.getParameter("lineCd"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("lineCd") != null && request.getParameter("lossCatCd") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("lineCd", request.getParameter("lineCd"));
			params.put("lossCatCd", request.getParameter("lossCatCd"));
			this.giisLossCtgryDAO.valDeleteRec(params);
		}
	}

	@Override
	public void saveGicls105(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISLossCtgry.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISLossCtgry.class));
		params.put("appUser", userId);
		this.giisLossCtgryDAO.saveGicls105(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("lineCd") != null && request.getParameter("lossCatCd") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("lineCd", request.getParameter("lineCd"));
			params.put("lossCatCd", request.getParameter("lossCatCd"));
			this.giisLossCtgryDAO.valAddRec(params);
		}
	}
	
}
