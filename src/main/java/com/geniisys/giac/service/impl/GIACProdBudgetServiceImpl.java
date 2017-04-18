package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACProdBudgetDAO;
import com.geniisys.giac.entity.GIACProdBudget;
import com.geniisys.giac.service.GIACProdBudgetService;

public class GIACProdBudgetServiceImpl implements GIACProdBudgetService {
	
	private GIACProdBudgetDAO giacProdBudgetDAO;

	@Override
	public JSONObject getGiacs360YearMonth(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs360YearMonthRecList");
		params.put("userId", userId);
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}
	
	@Override
	public JSONObject showGiacs360(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs360RecList");		
		params.put("year", request.getParameter("year"));
		params.put("month", request.getParameter("month"));
		params.put("userId", userId);
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("clauseType") != null){
			String recId = request.getParameter("clauseType");
			this.giacProdBudgetDAO.valDeleteRec(recId);
		}
	}

	@Override
	public void saveGiacs360(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACProdBudget.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIACProdBudget.class));
		params.put("appUser", userId);
		this.giacProdBudgetDAO.saveGiacs360(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("year") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("year", request.getParameter("year").equals("")?null:Integer.parseInt(request.getParameter("year")));
			params.put("month", request.getParameter("month"));
			params.put("issCd", request.getParameter("issCd"));
			params.put("lineCd", request.getParameter("lineCd"));
			this.giacProdBudgetDAO.valAddRec(params);
		}
	}

	@Override
	public void valAddYearRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("year") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("year", request.getParameter("year").equals("")?null:Integer.parseInt(request.getParameter("year")));
			params.put("month", request.getParameter("month"));
			this.giacProdBudgetDAO.valAddYearRec(params);
		}
	}

	public GIACProdBudgetDAO getGiacProdBudgetDAO() {
		return giacProdBudgetDAO;
	}

	public void setGiacProdBudgetDAO(GIACProdBudgetDAO giacProdBudgetDAO) {
		this.giacProdBudgetDAO = giacProdBudgetDAO;
	}
	
	

}
