package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACChartOfAcctsDAO;
import com.geniisys.giac.entity.GIACChartOfAccts;
import com.geniisys.giac.service.GIACChartOfAcctsService;
import com.seer.framework.util.StringFormatter;

public class GIACChartOfAcctsServiceImpl implements GIACChartOfAcctsService{

	private GIACChartOfAcctsDAO giacChartOfAcctsDAO;
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACChartOfAcctsService#getAccountCodeDtls(java.util.Map, java.lang.Integer)
	 */
	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getAccountCodeDtls(Map<String, Object> params, Integer pageNo)	throws SQLException {
		// TODO Auto-generated method stub
		List<GIACChartOfAccts> acctCodeList = this.giacChartOfAcctsDAO.getAccountCodeDtls(params);
		
		PaginatedList paginatedList = new PaginatedList(acctCodeList, ApplicationWideParameters.PAGE_SIZE);
		paginatedList.gotoPage(pageNo);
		return paginatedList;
	}
	
	/**
	 * @return the giacChartOfAcctsDAO
	 */
	public GIACChartOfAcctsDAO getGiacChartOfAcctsDAO() {
		return giacChartOfAcctsDAO;
	}
	
	/**
	 * @param giacChartOfAcctsDAO the giacChartOfAcctsDAO to set
	 */
	public void setGiacChartOfAcctsDAO(GIACChartOfAcctsDAO giacChartOfAcctsDAO) {
		this.giacChartOfAcctsDAO = giacChartOfAcctsDAO;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACChartOfAcctsService#getAccountCodeDtls2(java.lang.String, java.lang.Integer)
	 */
	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getAccountCodeDtls2(String keyword, Integer pageNo) throws SQLException {
		List<GIACChartOfAccts> acctCodeList = this.giacChartOfAcctsDAO.getAccountCodeDtls2(keyword);
		PaginatedList paginatedList = new PaginatedList(acctCodeList, ApplicationWideParameters.PAGE_SIZE);
		paginatedList.gotoPage(pageNo);
		return paginatedList;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACChartOfAcctsService#getAllChartOfAccts()
	 */
	@Override
	public List<GIACChartOfAccts> getAllChartOfAccts() throws SQLException {
		return this.getGiacChartOfAcctsDAO().getAllChartOfAccts();
	}

	@Override
	public List<GIACChartOfAccts> getAccountCodes(Map<String, Object> params)
			throws SQLException {
		return this.getGiacChartOfAcctsDAO().getAccountCodes(params);
	}

	
	@Override
	public JSONObject showGiacs311(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs311RecList");		
		params.put("queryLevel", request.getParameter("queryLevel"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}
	
	@Override
	public String checkGiacs311UserFunction(HttpServletRequest request, String userId) throws SQLException {
		return this.giacChartOfAcctsDAO.checkGiacs311UserFunction(userId);
	}

	@Override
	public String getGlMotherAcct(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("glAcctId", request.getParameter("glAcctId"));
		params.put("level", request.getParameter("level"));
		return this.giacChartOfAcctsDAO.getGlMotherAcct(params);
	}

	@Override
	public String getIncrementedLevel(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("glAcctId", request.getParameter("glAcctId"));
		params.put("level", request.getParameter("level"));
		return this.giacChartOfAcctsDAO.getIncrementedLevel(params);
	}

	@Override
	public JSONObject getChildRecList(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getChildRec");	
		params.put("glAcctId", request.getParameter("glAcctId"));
		params.put("motherGlAcctId", request.getParameter("motherGlAcctId"));
		params.put("level", request.getParameter("level"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public Map<String, Object> getChildChartOfAccts(HttpServletRequest request, String userId) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getChildRecList");
		params.put("glAcctId", request.getParameter("glAcctId"));
		params.put("motherGlAcctId", request.getParameter("motherGlAcctId"));
		params.put("level", request.getParameter("level"));
		params =  this.giacChartOfAcctsDAO.getChildChartOfAccts(params);
		List<?> list =  (List<?>) StringFormatter.escapeHTMLInList(params.get("list"));
		params.put("list", new JSONArray(list));
		return params;
	}

	@Override
	public void valUpdateRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("glAcctId") != null){
			String recId = request.getParameter("glAcctId");
			this.giacChartOfAcctsDAO.valUpdateRec(recId);
		}
	}

	@Override
	public void saveGiacs311(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACChartOfAccts.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIACChartOfAccts.class));
		params.put("appUser", userId);
		this.giacChartOfAcctsDAO.saveGiacs311(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tran", request.getParameter("tran"));
		params.put("glAcctCategory", request.getParameter("glAcctCategory"));
		params.put("glControlAcct", request.getParameter("glControlAcct"));
		params.put("glSubAcct1", request.getParameter("glSubAcct1"));
		params.put("glSubAcct2", request.getParameter("glSubAcct2"));
		params.put("glSubAcct3", request.getParameter("glSubAcct3"));
		params.put("glSubAcct4", request.getParameter("glSubAcct4"));
		params.put("glSubAcct5", request.getParameter("glSubAcct5"));
		params.put("glSubAcct6", request.getParameter("glSubAcct6"));
		params.put("glSubAcct7", request.getParameter("glSubAcct7"));
		params.put("glAcctId", request.getParameter("glAcctId"));
		this.giacChartOfAcctsDAO.valAddRec(params);
	}
	
	@Override
	public void valDelRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("glAcctId") != null){
			String recId = request.getParameter("glAcctId");
			this.giacChartOfAcctsDAO.valDelRec(recId);
		}
	}
}