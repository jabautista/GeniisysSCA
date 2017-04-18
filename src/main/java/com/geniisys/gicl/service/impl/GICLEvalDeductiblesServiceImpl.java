package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.gicl.dao.GICLEvalDeductiblesDAO;
import com.geniisys.gicl.entity.GICLEvalDeductibles;
import com.geniisys.gicl.service.GICLEvalDeductiblesService;

public class GICLEvalDeductiblesServiceImpl implements GICLEvalDeductiblesService{
	
	private GICLEvalDeductiblesDAO giclEvalDeductiblesDAO;

	public void setGiclEvalDeductiblesDAO(GICLEvalDeductiblesDAO giclEvalDeductiblesDAO) {
		this.giclEvalDeductiblesDAO = giclEvalDeductiblesDAO;
	}

	public GICLEvalDeductiblesDAO getGiclEvalDeductiblesDAO() {
		return giclEvalDeductiblesDAO;
	}

	@Override
	public String saveGiclEvalDeductibles(HttpServletRequest request,
			GIISUser USER) throws SQLException, Exception {
		JSONObject objParams = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("evalId", objParams.getString("evalId"));
		params.put("userId", USER.getUserId());
		params.put("delGiclEvalDeductibles", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("delGiclEvalDeductibles")), USER.getUserId(), GICLEvalDeductibles.class));
		params.put("setGiclEvalDeductibles", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("setGiclEvalDeductibles")), USER.getUserId(), GICLEvalDeductibles.class));
		params.put("replaceGiclEvalDeductibles", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("replaceGiclEvalDeductibles")), USER.getUserId(), GICLEvalDeductibles.class));
		return this.getGiclEvalDeductiblesDAO().saveGiclEvalDeductibles(params);
	}

	@Override
	public void applyDeductiblesForMcEval(Map<String, Object> params)
			throws SQLException, Exception {
		this.getGiclEvalDeductiblesDAO().applyDeductiblesForMcEval(params);
	}
}
