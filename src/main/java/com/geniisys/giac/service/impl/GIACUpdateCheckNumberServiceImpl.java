package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.giac.dao.GIACUpdateCheckNumberDAO;
import com.geniisys.giac.service.GIACUpdateCheckNumberService;

public class GIACUpdateCheckNumberServiceImpl implements GIACUpdateCheckNumberService{

	private GIACUpdateCheckNumberDAO giacUpdateCheckNumberDAO;

	public GIACUpdateCheckNumberDAO getGiacUpdateCheckNumberDAO() {
		return giacUpdateCheckNumberDAO;
	}

	public void setGiacUpdateCheckNumberDAO(
			GIACUpdateCheckNumberDAO giacUpdateCheckNumberDAO) {
		this.giacUpdateCheckNumberDAO = giacUpdateCheckNumberDAO;
	}

	@Override
	public void validateCheckPrefSuf(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("gibrGfunFundCd", request.getParameter("gibrGfunFundCd"));
		params.put("gibrBranchCd", request.getParameter("gibrBranchCd"));
		params.put("checkPrefSuf", request.getParameter("checkPrefSuf").toUpperCase());
		params.put("checkNo", request.getParameter("checkNo"));
		params.put("appUser", userId);
		params.put("checkNos", JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("dummySave"))));
		this.giacUpdateCheckNumberDAO.validateCheckPrefSuf(params);
	}
	
	@Override
	public JSONObject validateCheckNo(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("gibrGfunFundCd", request.getParameter("gibrGfunFundCd"));
		params.put("gibrBranchCd", request.getParameter("gibrBranchCd"));
		params.put("checkPrefSuf", request.getParameter("checkPrefSuf").toUpperCase());
		params.put("checkNo", request.getParameter("checkNo"));
		params.put("chkNo", request.getParameter("chkNo"));
		
		return new JSONObject(this.giacUpdateCheckNumberDAO.validateCheckNo(params));
	}

	@Override
	public String updateCheckNumber(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("appUser", userId);
		params.put("checkNos", JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("checkNos"))));
		
		return this.getGiacUpdateCheckNumberDAO().updateCheckNumber(params);
	}
}
