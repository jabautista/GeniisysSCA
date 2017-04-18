package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.gicl.dao.GICLGeneratePLAFLADAO;
import com.geniisys.gicl.service.GICLGeneratePLAFLAService;

public class GICLGeneratePLAFLAServiceImpl implements GICLGeneratePLAFLAService {
	
	private GICLGeneratePLAFLADAO giclGeneratePLAFLADAO;
	
	public GICLGeneratePLAFLADAO getGiclGeneratePLAFLADAO() {
		return giclGeneratePLAFLADAO;
	}

	public void setGiclGeneratePLAFLADAO(GICLGeneratePLAFLADAO giclGeneratePLAFLADAO) {
		this.giclGeneratePLAFLADAO = giclGeneratePLAFLADAO;
	}


	@Override
	public Map<String, Object> queryCountUngenerated(HttpServletRequest request, String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("allUserSw", request.getParameter("allUserSw"));
		params.put("validTag", request.getParameter("validTag"));
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("currentView", request.getParameter("currentView"));
		params.put("userId", userId);
		return this.getGiclGeneratePLAFLADAO().queryCountUngenerated(params);
	}

}
