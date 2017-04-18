/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.common.service.impl
	File Name: GIISCosignorResServiceImpl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: May 25, 2011
	Description: 
*/


package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISCosignorResDAO;
import com.geniisys.common.service.GIISCosignorResService;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.StringFormatter;

public class GIISCosignorResServiceImpl implements GIISCosignorResService{
	
	private GIISCosignorResDAO giisCosignorResDAO;
	
	@Override
	public JSONObject getCosignorRes(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Integer assdNo = ("".equals(request.getParameter("assdNo")) || request.getParameter("assdNo") == null)? null : Integer.parseInt((request.getParameter("assdNo")));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getCosignorRes");
		if (!"GIIMM011".equalsIgnoreCase(request.getParameter("callingForm")) && !"GIPIS017".equalsIgnoreCase(request.getParameter("callingForm"))) {
			params.put("assdNo", assdNo);
		}
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(StringFormatter.escapeHTMLInMap(map));
	}
	/**
	 * @param giisCosignorResDAOl the giisCosignorResDAOl to set
	 */
	public void setGiisCosignorResDAO(GIISCosignorResDAO giisCosignorResDAO) {
		this.giisCosignorResDAO = giisCosignorResDAO;
	}
	/**
	 * @return the giisCosignorResDAOl
	 */
	public GIISCosignorResDAO getGiisCosignorResDAO() {
		return giisCosignorResDAO;
	}
	@Override
	public List<Integer> getCoSignatoryIDList(Integer assdNo)throws SQLException {
		return this.giisCosignorResDAO.getCoSignatoryIDList(assdNo);
	}

}
