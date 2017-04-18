package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLLossExpSettlementDAO;
import com.geniisys.gicl.entity.GICLLeStat;
import com.geniisys.gicl.service.GICLLossExpSettlementService;

public class GICLLossExpSettlementServiceImpl implements GICLLossExpSettlementService {
	
	private GICLLossExpSettlementDAO giclLossExpSettlementDAO;

	@Override
	public JSONObject showGicls060(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGicls060RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}

	@Override
	public String valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("leStatCd") != null){
			String leStatCd = request.getParameter("leStatCd");
			return this.giclLossExpSettlementDAO.valDeleteRec(leStatCd);
		} else {
			return null;
		}
		
	}

	@Override
	public void saveGicls060(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GICLLeStat.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GICLLeStat.class));
		params.put("appUser", userId);
		this.giclLossExpSettlementDAO.saveGicls060(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("leStatCd") != null){
			String recId = request.getParameter("leStatCd");
			this.giclLossExpSettlementDAO.valAddRec(recId);
		}
	}

	public GICLLossExpSettlementDAO getGiclLossExpSettlementDAO() {
		return giclLossExpSettlementDAO;
	}

	public void setGiclLossExpSettlementDAO(GICLLossExpSettlementDAO giclLossExpSettlementDAO) {
		this.giclLossExpSettlementDAO = giclLossExpSettlementDAO;
	}

}
