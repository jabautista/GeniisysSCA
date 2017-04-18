package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.gicl.dao.GICLAdvsFlaDAO;
import com.geniisys.gicl.service.GICLAdvsFlaService;

public class GICLAdvsFlaServiceImpl implements GICLAdvsFlaService{
	private GICLAdvsFlaDAO giclAdvsFlaDAO;

	public void setGiclAdvsFlaDAO(GICLAdvsFlaDAO giclAdvsFlaDAO) {
		this.giclAdvsFlaDAO = giclAdvsFlaDAO;
	}

	public GICLAdvsFlaDAO getGiclAdvsFlaDAO() {
		return giclAdvsFlaDAO;
	}
	
	@Override
	public Map<String, Object> cancelFla(Map<String, Object> params)
			throws SQLException {
		return this.getGiclAdvsFlaDAO().cancelFla(params);
	}

	@Override
	public void updateFla(Map<String, Object> params)
			throws SQLException {
		this.getGiclAdvsFlaDAO().updateFla(params);
	}

	@Override
	public String generateFLA(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("USER", USER); 
		params.put("userId", USER.getUserId()); 
		params.put("claimId", request.getParameter("claimId"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("clmYy", request.getParameter("clmYy"));
		params.put("rows", JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("rows"))));
		return this.giclAdvsFlaDAO.generateFLA(params);
	}

	@Override
	public Integer getAdvFlaId() throws SQLException {
		return this.getGiclAdvsFlaDAO().getAdvFlaId();
	}

	@Override
	public String validatePdFla(Map<String, Object> params) throws SQLException {
		return this.getGiclAdvsFlaDAO().validatePdFla(params);
	}

	@Override
	public void updateFlaPrintSw(Map<String, Object> params)
			throws SQLException {
		this.getGiclAdvsFlaDAO().updateFlaPrintSw(params);
	}
}
