package com.geniisys.gicl.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLAdvLineAmtDAO;
import com.geniisys.gicl.entity.GICLAdvLineAmt;
import com.geniisys.gicl.service.GICLAdvLineAmtService;
import com.seer.framework.util.StringFormatter;

public class GICLAdvLineAmtServiceImpl implements GICLAdvLineAmtService {

	private GICLAdvLineAmtDAO giclAdvLineAmtDAO;
	
	@Override
	public BigDecimal getRangeTo(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", request.getParameter("userId"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("issCd", request.getParameter("issCd"));
		
		return this.giclAdvLineAmtDAO.getRangeTo(params);
	}

	public GICLAdvLineAmtDAO getGiclAdvLineAmtDAO() {
		return giclAdvLineAmtDAO;
	}

	public void setGiclAdvLineAmtDAO(GICLAdvLineAmtDAO giclAdvLineAmtDAO) {
		this.giclAdvLineAmtDAO = giclAdvLineAmtDAO;
	}
	
	@Override
	public JSONObject showGicls182(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGicls182RecList");	
		params.put("advUser", request.getParameter("advUser"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("appUser", userId);
		Map<String, Object> recList = StringFormatter.escapeHTMLInMap(TableGridUtil.getTableGrid(request, params));
		
		return new JSONObject(recList);
	}

	@Override
	public void saveGicls182(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GICLAdvLineAmt.class));
		//params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISLossCtgry.class));
		params.put("appUser", userId);
		this.giclAdvLineAmtDAO.saveGicls182(params);
	}
	
}
