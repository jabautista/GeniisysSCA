package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.gipi.dao.GIPIMainCoInsDAO;
import com.geniisys.gipi.entity.GIPIMainCoIns;
import com.geniisys.gipi.service.GIPIMainCoInsService;

public class GIPIMainCoInsServiceImpl implements GIPIMainCoInsService{
	
	private GIPIMainCoInsDAO gipiMainCoInsDAO;

	public GIPIMainCoInsDAO getGipiMainCoInsDAO() {
		return gipiMainCoInsDAO;
	}

	public void setGipiMainCoInsDAO(GIPIMainCoInsDAO gipiMainCoInsDAO) {
		this.gipiMainCoInsDAO = gipiMainCoInsDAO;
	}

	@Override
	public GIPIMainCoIns getPolicyMainCoIns(Integer policyId) throws SQLException {
		return this.gipiMainCoInsDAO.getPolicyMainCoIns(policyId);
	}
	
	public String limitEntryGIPIS154(HttpServletRequest request) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("globalPackParId", request.getParameter("globalPackParId") == "" ? null : Integer.parseInt(request.getParameter("globalPackParId")));
		params.put("parId", request.getParameter("packParId") == "" ? null : Integer.parseInt(request.getParameter("parId")));
		
		return this.gipiMainCoInsDAO.limitEntryGIPIS154(params);
	}
	
}
