package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACRecapDtlExtDAO;
import com.geniisys.giac.service.GIACRecapDtlExtService;

public class GIACRecapDtlExtServiceImpl implements GIACRecapDtlExtService{

	private GIACRecapDtlExtDAO giacRecapDtlExtDAO;

	public GIACRecapDtlExtDAO getGiacRecapDtlExtDAO() {
		return giacRecapDtlExtDAO;
	}

	public void setGiacRecapDtlExtDAO(GIACRecapDtlExtDAO giacRecapDtlExtDAO) {
		this.giacRecapDtlExtDAO = giacRecapDtlExtDAO;
	}

	@Override
	public Map<String, Object> getRecapVariables() throws SQLException {
		return this.getGiacRecapDtlExtDAO().getRecapVariables();
	}
	
	@Override
	public JSONObject getRecapDetailsTableGrid(HttpServletRequest request)
			throws SQLException, JSONException {
		String type = request.getParameter("type");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getRecap"+type+"Details");
		
		Map<String, Object> recapDetailsTableGrid = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recapDetailsTableGrid);
	}

	@Override
	public JSONObject getRecapLineDetailsTableGrid(HttpServletRequest request)
			throws SQLException, JSONException {
		String type = request.getParameter("type");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getRecap"+type+"LineDetails");
		params.put("line", request.getParameter("line"));
		
		Map<String, Object> recapLineDetailsTableGrid = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recapLineDetailsTableGrid);
	}

	@Override
	public void extractRecap(HttpServletRequest request, String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("userId", userId);
		this.getGiacRecapDtlExtDAO().extractRecap(params);
	}

	@Override
	public Integer checkDataFetched() throws SQLException {
		return this.getGiacRecapDtlExtDAO().checkDataFetched();
	}
	
}
