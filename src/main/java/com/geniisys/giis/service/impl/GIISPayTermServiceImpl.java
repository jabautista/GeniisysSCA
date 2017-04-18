package com.geniisys.giis.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.giis.dao.GIISPayTermDAO;
import com.geniisys.giis.entity.GIISPayTerm;
import com.geniisys.giis.service.GIISPayTermService;
import com.ibm.disthub2.impl.matching.selector.ParseException;

public class GIISPayTermServiceImpl implements GIISPayTermService {
	private GIISPayTermDAO giisPayTermDAO;

	public GIISPayTermDAO getGiisPayTermDAO() {
		return giisPayTermDAO;
	}

	public void setGiisPayTermDAO(GIISPayTermDAO giisPayTermDAO) {
		this.giisPayTermDAO = giisPayTermDAO;
	}

	@Override
	public List<GIISPayTerm> getPaymentTerm() throws SQLException, JSONException {
		return giisPayTermDAO.getPaymentTerm();
	}

	@Override
	public String savePaymentTerm(HttpServletRequest request, String userId)
			throws JSONException, SQLException, ParseException {
		JSONObject objParameters = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), userId, GIISPayTerm.class));
		allParams.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("delRows")), userId, GIISPayTerm.class));
		return this.getGiisPayTermDAO().savePayTerm(allParams);
	}

	@Override
	public String validateDeletePaytTerm(String paytTerms) throws JSONException, SQLException, ParseException {
		return this.getGiisPayTermDAO().validateDeletePaytTerm(paytTerms);
	}

	@Override
	public String validateAddPaytTerm(String paytTerms) throws JSONException, SQLException, ParseException {
		return this.giisPayTermDAO.validateAddPaytTerm(paytTerms);
	}

	@Override
	public String validateAddPaytTermDesc(HttpServletRequest request)
			throws JSONException, SQLException, ParseException {
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("paytTerm", request.getParameter("paytTerm"));
		allParams.put("paytTermDescToAdd", request.getParameter("paytTermDescToAdd"));
		return this.giisPayTermDAO.validateAddPaytTermDesc(allParams);
	}




}
