package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.giac.dao.GIACPaytRequestsDtlDAO;
import com.geniisys.giac.entity.GIACPaytRequestsDtl;
import com.geniisys.giac.service.GIACPaytRequestsDtlService;
import com.seer.framework.util.StringFormatter;

public class GIACPaytRequestsDtlServiceImpl implements GIACPaytRequestsDtlService{

	private GIACPaytRequestsDtlDAO giacPaytRequestsDtlDAO;

	public GIACPaytRequestsDtlDAO getGiacPaytRequestsDtlDAO() {
		return giacPaytRequestsDtlDAO;
	}

	public void setGiacPaytRequestsDtlDAO(GIACPaytRequestsDtlDAO giacPaytRequestsDtlDAO) {
		this.giacPaytRequestsDtlDAO = giacPaytRequestsDtlDAO;
	}

	@Override
	/*
	 * modified from void to JSONObject; shan 08.29.2013 for GIACS070
	 * 
	 */
	public JSONObject getGiacPaytRequestsDtl(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("refId", request.getParameter("refId"));
		Object row = this.giacPaytRequestsDtlDAO.getGiacPaytRequestsDtl(params);
		//request.setAttribute("giacPaytRequestsDtl", row == null ? new JSONObject(new GIACPaytRequestsDtl()) :new JSONObject(StringFormatter.escapeHTMLInObject(row)));		
		JSONObject info = row == null ? new JSONObject(new GIACPaytRequestsDtl()) :new JSONObject(StringFormatter.escapeHTMLInObject(row));
		request.setAttribute("giacPaytRequestsDtl", info);
		return info;
		
	}
	
	
	
}
