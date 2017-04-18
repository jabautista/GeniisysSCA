package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISBlockDAO;
import com.geniisys.common.entity.GIISBlock;
import com.geniisys.common.entity.GIISRisks;
import com.geniisys.common.service.GIISBlockService;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.StringFormatter;

public class GIISBlockServiceImpl implements GIISBlockService{
	
	private GIISBlockDAO giisBlockDAO;

	
	/**
	 * @return the giisBlockDAO
	 */
	public GIISBlockDAO getGiisBlockDAO() {
		return giisBlockDAO;
	}


	/**
	 * @param giisBlockDAO the giisBlockDAO to set
	 */
	public void setGiisBlockDAO(GIISBlockDAO giisBlockDAO) {
		this.giisBlockDAO = giisBlockDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISBlockService#getDistrictLovGICLS010(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getDistrictLovGICLS010(Map<String, Object> params)
			throws SQLException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		System.out.println("startRow: " + grid.getStartRow() + " endRow: " + grid.getEndRow());
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		
		List<Map<String, Object>> districtList = this.getGiisBlockDAO().getDistrictLovGICLS010(params);
		
		params.put("rows", new JSONArray((List<Map<String, Object>>)StringFormatter.replaceQuotesInList(districtList)));
		grid.setNoOfPages(districtList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		System.out.println("Pages: " + grid.getNoOfPages());
		System.out.println("Total: " + grid.getNoOfRows());
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISBlockService#getBlockLovGICLS010(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getBlockLovGICLS010(Map<String, Object> params)
			throws SQLException {
		
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		System.out.println("startRow: " + grid.getStartRow() + " endRow: " + grid.getEndRow());
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		
		List<Map<String, Object>> blockList = this.getGiisBlockDAO().getBlockLovGICLS010(params);
		
		params.put("rows", new JSONArray((List<Map<String, Object>>)StringFormatter.replaceQuotesInList(blockList)));
		grid.setNoOfPages(blockList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		System.out.println("Pages: " + grid.getNoOfPages());
		System.out.println("Total: " + grid.getNoOfRows());
		return params;
	}
	
	@Override
	public JSONObject getGiiss007Province(HttpServletRequest request, String userId)	
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss007Province");	
		params.put("userId", userId);		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);		
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	}
	
	@Override
	public JSONObject getGiiss007City(HttpServletRequest request, String userId)	
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss007City");	
		params.put("provinceCd", StringFormatter.unescapeBackslash3(StringFormatter.unescapeHTML2(request.getParameter("provinceCd")).toString())); // edited by gab ramos 07.28.2015
		params.put("userId", userId);		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);		
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	}
	
	@Override
	public JSONObject getGiiss007District(HttpServletRequest request, String userId)	
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss007District");
		params.put("provinceCd", StringFormatter.unescapeHTML2(request.getParameter("provinceCd")).toString()); 
		params.put("cityCd", StringFormatter.unescapeHTML2(request.getParameter("cityCd")).toString());
		// edited by gab ramos 07.28.2015
		params.put("userId", userId);		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);		
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	}
	
	@Override
	public JSONObject getGiiss007Block(HttpServletRequest request, String userId)	
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss007Block");	
		params.put("provinceCd", StringFormatter.unescapeHTML2(request.getParameter("provinceCd")).toString());
		params.put("cityCd", StringFormatter.unescapeHTML2(request.getParameter("cityCd")).toString());
		params.put("districtNo", StringFormatter.unescapeHTML2(request.getParameter("districtNo")).toString());
		// edited by gab ramos 07.28.2015
		params.put("userId", userId);		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);		
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	}
	
	@Override
	public JSONObject getGiiss007RisksDetails(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("ACTION", "getGiiss007RisksDetails");		
		params.put("blockId", request.getParameter("blockId"));	
		Map<String, Object> risksDetailsTbg = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonRisksDetails = new JSONObject(StringFormatter.escapeHTMLInMap(risksDetailsTbg));	
		return jsonRisksDetails;
	}
	
	@Override
	public JSONObject getGiiss007AllRisksDetails(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("ACTION", "getGiiss007AllRisksDetails");		
		params.put("blockId", request.getParameter("blockId"));	
		Map<String, Object> risksDetailsTbg = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonRisksDetails = new JSONObject(StringFormatter.escapeHTMLInMap(risksDetailsTbg));	
		return jsonRisksDetails;
	}
	
	@Override
	public void valDeleteRecRisk(HttpServletRequest request) throws SQLException {	
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("blockId", request.getParameter("blockId"));
		params.put("riskCd", request.getParameter("riskCd"));
		this.giisBlockDAO.valDeleteRecRisk(params);
	}
	
	@Override
	public void valAddRecRisk(HttpServletRequest request) throws SQLException {	
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("blockId", request.getParameter("blockId"));
		params.put("riskCd", request.getParameter("riskCd"));
		params.put("riskDesc", request.getParameter("riskDesc"));			
		this.giisBlockDAO.valAddRecRisk(params);		
	}
	
	@Override
	public void saveRiskDetails(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISRisks.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISRisks.class));
		params.put("appUser", userId);
		this.giisBlockDAO.saveRiskDetails(params);
	}

	@Override
	public void valAddRecBlock(HttpServletRequest request) throws SQLException {	
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("provinceCd", request.getParameter("provinceCd"));
		params.put("cityCd", request.getParameter("cityCd"));
		params.put("districtNo", request.getParameter("districtNo"));	
		params.put("blockNo", request.getParameter("blockNo"));	
		this.giisBlockDAO.valAddRecBlock(params);		
	}
	
	@Override
	public void valDeleteRecBlock(HttpServletRequest request) throws SQLException {	
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("blockId", request.getParameter("blockId"));
		this.giisBlockDAO.valDeleteRecBlock(params);
	}
	
	@Override
	public void saveGiiss007(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("setRowsBlock", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRowsBlock")), userId, GIISBlock.class));
		params.put("updateRowsDistrict", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("updateRowsDistrict")), userId, GIISBlock.class));
		params.put("delRowsBlock", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRowsBlock")), userId, GIISBlock.class));
		params.put("delRowsProvince", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRowsProvince")), userId, GIISBlock.class));
		params.put("delRowsCity", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRowsCity")), userId, GIISBlock.class));
		params.put("delRowsDistrict", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRowsDistrict")), userId, GIISBlock.class));
		params.put("appUser", userId);
		this.giisBlockDAO.saveGiiss007(params);
	}
	
	@Override
	public void valDeleteRecProvince(HttpServletRequest request) throws SQLException {	
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("provinceCd", request.getParameter("provinceCd"));
		this.giisBlockDAO.valDeleteRecProvince(params);
	}
	
	@Override
	public void valDeleteRecCity(HttpServletRequest request) throws SQLException {	
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("provinceCd", request.getParameter("provinceCd"));
		params.put("cityCd", request.getParameter("cityCd"));
		this.giisBlockDAO.valDeleteRecCity(params);
	}
	
	@Override
	public void valDeleteRecDistrict(HttpServletRequest request) throws SQLException {	
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("provinceCd", request.getParameter("provinceCd"));
		params.put("cityCd", request.getParameter("cityCd"));
		params.put("districtNo", request.getParameter("districtNo"));
		this.giisBlockDAO.valDeleteRecDistrict(params);
	}


	@Override
	public void valAddRecDistrict(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("provinceCd", request.getParameter("provinceCd"));
		params.put("cityCd", request.getParameter("cityCd"));
		params.put("districtNo", request.getParameter("districtNo"));
		this.giisBlockDAO.valAddRecDistrict(params);
	}
}
