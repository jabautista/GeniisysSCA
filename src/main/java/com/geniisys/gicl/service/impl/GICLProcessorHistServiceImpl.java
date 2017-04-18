package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLProcessorHistDAO;
import com.geniisys.gicl.service.GICLProcessorHistService;
import com.seer.framework.util.StringFormatter;

public class GICLProcessorHistServiceImpl implements GICLProcessorHistService{

	GICLProcessorHistDAO giclProcessorHistDAO;
	
	/**
	 * @return the giclProcessorHistDAO
	 */
	public GICLProcessorHistDAO getGiclProcessorHistDAO() {
		return giclProcessorHistDAO;
	}


	/**
	 * @param giclProcessorHistDAO the giclProcessorHistDAO to set
	 */
	public void setGiclProcessorHistDAO(GICLProcessorHistDAO giclProcessorHistDAO) {
		this.giclProcessorHistDAO = giclProcessorHistDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLProcessorHistService#getProcessorHist(java.util.Map)
	 */
	@Override
	public Map<String, Object> getProcessorHist(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getProcessorHistTableGridListing");
		params.put("userId", USER.getUserId());
		params.put("claimId", request.getParameter("claimId"));
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("claimsListTableGrid", grid);
		request.setAttribute("object", grid);
		return params;
	}

}
