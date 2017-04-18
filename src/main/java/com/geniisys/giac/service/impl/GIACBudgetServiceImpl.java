package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACBudgetDAO;
import com.geniisys.giac.entity.GIACBudget;
import com.geniisys.giac.service.GIACBudgetService;

public class GIACBudgetServiceImpl implements GIACBudgetService{
	
	private GIACBudgetDAO giacBudgetDAO;

	public GIACBudgetDAO getGiacBudgetDAO() {
		return giacBudgetDAO;
	}

	public void setGiacBudgetDAO(GIACBudgetDAO giacBudgetDAO) {
		this.giacBudgetDAO = giacBudgetDAO;
	}

	@Override
	public JSONObject showGIACS510(HttpServletRequest request)
			throws SQLException, JSONException {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacBudgetYear");
		
		Map<String, Object> giacBudgetYearList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(giacBudgetYearList);
		
	}

	@Override
	public JSONObject showBudgetPerYear(HttpServletRequest request)
			throws SQLException, JSONException {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacBudgetPerYear");
		params.put("year", request.getParameter("year"));
		
		Map<String, Object> giacBudgetPerYearList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(giacBudgetPerYearList);
		
	}

	@Override
	public void valAddBudgetYear(HttpServletRequest request)
			throws SQLException {
		if(request.getParameter("year") != null){
			this.giacBudgetDAO.valAddBudgetYear(request.getParameter("year"));
		}
	}

	@Override
	public void copyBudget(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("copiedYear", request.getParameter("copiedYear"));
		params.put("year", request.getParameter("year"));
		this.giacBudgetDAO.copyBudget(params);
	}

	@Override
	public JSONObject showGLAcctLOV(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGLAcctLOV");
		params.put("table", request.getParameter("table"));
		params.put("year", request.getParameter("year"));
		params.put("glAcctCat", request.getParameter("glAcctCat"));
		params.put("glAcctControlAcct", request.getParameter("glAcctControlAcct"));
		params.put("glSubAcct1", request.getParameter("glSubAcct1"));
		params.put("glSubAcct2", request.getParameter("glSubAcct2"));
		params.put("glSubAcct3", request.getParameter("glSubAcct3"));
		params.put("glSubAcct4", request.getParameter("glSubAcct4"));
		params.put("glSubAcct5", request.getParameter("glSubAcct5"));
		params.put("glSubAcct6", request.getParameter("glSubAcct6"));
		params.put("glSubAcct7", request.getParameter("glSubAcct7"));
		params.put("glDtlAcctCat", request.getParameter("glDtlAcctCat"));
		params.put("glDtlAcctControlAcct", request.getParameter("glDtlAcctControlAcct"));
		params.put("glDtlSubAcct1", request.getParameter("glDtlSubAcct1"));
		
		Map<String, Object> giacBudgetGLAcctLOVList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(giacBudgetGLAcctLOVList);
	}

	@Override
	public void saveGiacs510(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACBudget.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIACBudget.class));
		params.put("appUser", userId);		
		this.giacBudgetDAO.saveGiacs510(params);
	}

	@Override
	public void valDeleteBudgetPerYear(HttpServletRequest request)
			throws SQLException {
		if(request.getParameter("glAcctId") != null){
			this.giacBudgetDAO.valDeleteBudgetPerYear(request.getParameter("glAcctId"), request.getParameter("year"));
		}
	}

	@Override
	public String validateGLAcctNo(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("year", request.getParameter("year"));
		params.put("table", request.getParameter("table"));
		params.put("glAcctCat", request.getParameter("glAcctCat"));
		params.put("glAcctControlAcct", request.getParameter("glAcctControlAcct"));
		params.put("glSubAcct1", request.getParameter("glSubAcct1"));
		params.put("glSubAcct2", request.getParameter("glSubAcct2"));
		params.put("glSubAcct3", request.getParameter("glSubAcct3"));
		params.put("glSubAcct4", request.getParameter("glSubAcct4"));
		params.put("glSubAcct5", request.getParameter("glSubAcct5"));
		params.put("glSubAcct6", request.getParameter("glSubAcct6"));
		params.put("glSubAcct7", request.getParameter("glSubAcct7"));
		JSONObject result = new JSONObject(this.getGiacBudgetDAO().validateGLAcctNo(params));
		return result.toString();
	}

	@Override
	public JSONObject showBudgetDtlOverlay(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "giacBudgetPerYearDtl");
		params.put("year", request.getParameter("year"));
		params.put("glAcctId", request.getParameter("glAcctId"));
		
		Map<String, Object> giacBudgetDtlOverlayDtls = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(giacBudgetDtlOverlayDtls);
	}

	@Override
	public void saveGIACS510Dtl(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACBudget.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIACBudget.class));
		params.put("appUser", userId);		
		this.giacBudgetDAO.saveGIACS510Dtl(params);
	}

	@Override
	public String checkExistBeforeExtractGiacs510(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("year", request.getParameter("year"));
		JSONObject result = new JSONObject(this.getGiacBudgetDAO().checkExistBeforeExtractGiacs510(params));
		return result.toString();
	}

	@Override
	public String extractGiacs510(HttpServletRequest request, String userId)
			throws SQLException, ParseException {
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("year", request.getParameter("year"));
		params.put("dateBasis", request.getParameter("dateBasis"));
		params.put("tranFlag", request.getParameter("tranFlag"));
		JSONObject result = new JSONObject(this.getGiacBudgetDAO().extractGiacs510(params)); 
		return result.toString();
	}

	@Override
	public JSONObject viewNoDtl(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "viewNoDtl");
		params.put("year", request.getParameter("year"));
		
		Map<String, Object> glAcctNoDtl = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(glAcctNoDtl);
	}
	
}
