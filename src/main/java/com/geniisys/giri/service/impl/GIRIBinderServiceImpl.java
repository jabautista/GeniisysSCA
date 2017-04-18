package com.geniisys.giri.service.impl;

import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giri.dao.GIRIBinderDAO;
import com.geniisys.giri.entity.GIRIBinder;
import com.geniisys.giri.service.GIRIBinderService;
import com.seer.framework.util.StringFormatter;

public class GIRIBinderServiceImpl implements GIRIBinderService{
	
	private GIRIBinderDAO giriBinderDAO;
	
	/**
	 * @return the giriBinderDAO
	 */
	public GIRIBinderDAO getGiriBinderDAO() {
		return giriBinderDAO;
	}


	/**
	 * @param giriBinderDAO the giriBinderDAO to set
	 */
	public void setGiriBinderDAO(GIRIBinderDAO giriBinderDAO) {
		this.giriBinderDAO = giriBinderDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giri.service.GIRIBinderService#getPostedDtls(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getPostedDtls(Map<String, Object> params) throws SQLException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<Map<String, Object>> giriBinderList = giriBinderDAO.getPostedDtls(params);
		
		params.put("rows", new JSONArray((List<Map<String, Object>>)StringFormatter.replaceQuotesInList(giriBinderList)));
		grid.setNoOfPages(giriBinderList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		System.out.println("Pages: " + grid.getNoOfPages());
		System.out.println("Total: " + grid.getNoOfRows());
		
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giri.service.GIRIBinderService#updateGiriBinderGiris026(java.lang.String)
	 */
	@Override
	public void updateGiriBinderGiris026(String params, String userId) throws SQLException, JSONException, ParseException {
		JSONObject objParameters = new JSONObject(params);
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("modifiedBinderDtls", "");
		allParams.put("modifiedBinderDtls", this.prepareGIRIBinderDtlsForUpdate(new JSONArray(objParameters.getString("modifiedBinderDtls"))));
		allParams.put("appUser", userId);
		giriBinderDAO.updateGiriBinderGiris026(allParams);
	}
	
	/**
	 * 
	 * @param updateRows
	 * @return
	 * @throws JSONException
	 * @throws ParseException
	 */
	public List<Map<String, Object>> prepareGIRIBinderDtlsForUpdate(JSONArray updateRows) throws JSONException, ParseException {
		List<Map<String, Object>> binders = new ArrayList<Map<String, Object>>();
		Map<String, Object> binderMap = null;
		JSONObject objBinder = null;
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		
		for(int i=0, length=updateRows.length(); i < length; i++){
			binderMap = new HashMap<String, Object>();
			objBinder = updateRows.getJSONObject(i);
			
			binderMap.put("fnlBinderId", objBinder.isNull("fnlBinderId") ? null : objBinder.getInt("fnlBinderId"));
			binderMap.put("binderDate", objBinder.isNull("binderDate") ? null : df.parse(objBinder.getString("binderDate")));
			binderMap.put("refBinderNo", objBinder.isNull("refBinderNo") ? null : objBinder.getString("refBinderNo"));
						
			binders.add(binderMap);
			binderMap = null;
		}
		
		return binders;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giri.service.GIRIBinderService#checkIfBinderExists(java.lang.String)
	 */
	@Override
	public String checkIfBinderExists(String parId) throws SQLException {
		return this.getGiriBinderDAO().checkIfBinderExists(parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giri.service.GIRIBinderService#updateRevSwRevDate(java.lang.String)
	 */
	@Override
	public void updateRevSwRevDate(String parId) throws SQLException, Exception {
		giriBinderDAO.updateRevSwRevDate(parId);
		
	}

	@Override
	public List<GIRIBinder> getBinderDetails(Map<String, Object> params)
			throws SQLException {
		return this.giriBinderDAO.getBinderDetails(params);
	}

	@Override
	public void updateBinderPrintDateCnt(Integer fnlBinderId)
			throws SQLException {
		giriBinderDAO.updateBinderPrintDateCnt(fnlBinderId);
		
	}


	@Override
	public List<Integer> getFnlBinderId(Map<String, Object> params)
			throws SQLException {
		return this.giriBinderDAO.getFnlBinderId(params);
	}


	@Override
	public void updateAcceptanceInfo(Map<String, Object> params)
			throws SQLException, JSONException, ParseException {
		giriBinderDAO.updateAcceptanceInfo(params);
	}


	@Override
	public List<Map<String, Object>> getBinders(Integer policyId) throws SQLException {
		return this.getGiriBinderDAO().getBinders(policyId);
	}


	@Override
	public String updateBinderStatusGIUTS012(HttpServletRequest request,
			String userId) throws SQLException, ParseException {
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("confirmNo", request.getParameter("confirmNo"));
		params.put("confirmDate", request.getParameter("confirmDate"));
		params.put("releaseBy", request.getParameter("releaseBy"));
		params.put("releaseDate", request.getParameter("releaseDate"));
		params.put("fnlBinderId", request.getParameter("fnlBinderId"));
		params.put("status", request.getParameter("status"));
		JSONObject result = new JSONObject(this.getGiriBinderDAO().updateBinderStatusGIUTS012(params));
		return result.toString();
	}


	@Override
	public JSONObject getRIPlacements(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getRIPlacements");
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("frpsYy", request.getParameter("frpsYy"));
		params.put("frpsSeqNo", request.getParameter("frpsSeqNo"));
		Map<String, Object> riPlacementsTG = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(riPlacementsTG);
	}


	@Override
	public JSONObject getBinderPerils(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getBinderPerils");
		params.put("fnlBinderId", request.getParameter("fnlBinderId"));
		Map<String, Object> binderPerilsTG = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(binderPerilsTG);
	}


	@Override
	public Map<String, Object> getBinder(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("binderYy", request.getParameter("binderYy"));
		params.put("binderSeqNo", request.getParameter("binderSeqNo"));
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("userId", userId);
		return this.getGiriBinderDAO().getBinder(params);
	}


	@Override
	public Map<String, Object> getPolicyFrps(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("frpsYy", request.getParameter("frpsYy"));
		params.put("frpsSeqNo", request.getParameter("frpsSeqNo"));
		params.put("userId", userId);
		params.put("distNo", request.getParameter("distNo")); //benjo 07.20.2015 UCPBGEN-SR-19626
		params.put("distSeqNo", request.getParameter("distSeqNo")); //benjo 07.20.2015 UCPBGEN-SR-19626
		
		return this.getGiriBinderDAO().getPolicyFrps(params);
	}


	@Override
	public JSONObject getOutwardRiList(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getOutwardRiList");
		params.put("riCd", (request.getParameter("riCd") != null && !request.getParameter("riCd").equals("")) ? Integer.parseInt(request.getParameter("riCd")) : null);
		params.put("userId", userId);
		Map<String, Object> outwardRiList = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(outwardRiList);
	}


	@Override
	public JSONObject showPolWithPremPayments(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "showPolWithPremPayments");
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("asOfDate", request.getParameter("asOfDate"));
		params.put("searchBy", request.getParameter("searchBy"));
		params.put("userId", USER.getUserId());
		Map<String, Object> tbgPolWithPremPayments = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonTbgPolWithPremPayments = new JSONObject(tbgPolWithPremPayments);
		request.setAttribute("jsonTbgPolWithPremPayments", jsonTbgPolWithPremPayments);
		return jsonTbgPolWithPremPayments;
	}


	@Override
	public JSONObject showGiris055(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiris055Dtls");
		params.put("userId", userId);
		
		Map<String, Object> giris055DtlsList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(giris055DtlsList);
	}


	@Override
	public JSONObject getDistPerilOverlayDtls(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getDistPerilOverlayDtls");
		params.put("userId", userId);
		params.put("fnlBinderId", request.getParameter("fnlBinderId"));
		
		Map<String, Object> binderDistPerilDtls = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(binderDistPerilDtls);
	}


	@Override
	public JSONObject showInwardRIMenu(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiris019RiList");
		params.put("riCd", request.getParameter("riCd"));
		params.put("userId", userId);
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(map);
	}


	@Override
	public String checkBinderAccess(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("binderYy", request.getParameter("binderYy"));
		params.put("binderSeqNo", request.getParameter("binderSeqNo"));
		params.put("userId", userId);
		
		return this.getGiriBinderDAO().checkBinderAccess(params);
	}

	//benjo 07.20.2015 UCPBGEN-SR-19626
	@Override
	public void checkRIPlacementAccess(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("userId", userId);
		
		this.getGiriBinderDAO().checkRIPlacementAccess(params);
	}
}
