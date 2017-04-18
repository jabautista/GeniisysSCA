package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLClmStatHistDAO;
import com.geniisys.gicl.service.GICLClmStatHistService;
import com.seer.framework.util.StringFormatter;

public class GICLClmStatHistServiceImpl implements GICLClmStatHistService{
	GICLClmStatHistDAO giclClmStatHistDAO;
	
	/**
	 * @return the giclClmStatHistDAO
	 */
	public GICLClmStatHistDAO getGiclClmStatHistDAO() {
		return giclClmStatHistDAO;
	}

	/**
	 * @param giclClmStatHistDAO the giclClmStatHistDAO to set
	 */
	public void setGiclClmStatHistDAO(GICLClmStatHistDAO giclClmStatHistDAO) {
		this.giclClmStatHistDAO = giclClmStatHistDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClmStatHistService#getClmStatHistory(java.util.Map)
	 */
	@Override
	public Map<String, Object> getClmStatHistory(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getStatHistTableGridListing");
		params.put("userId", USER.getUserId());
		params.put("claimId", request.getParameter("claimId"));
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("claimsListTableGrid", grid);
		request.setAttribute("object", grid);
		return params;
	}

}
