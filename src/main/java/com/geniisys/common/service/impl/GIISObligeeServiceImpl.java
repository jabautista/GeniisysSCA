package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISObligeeDAO;
import com.geniisys.common.entity.GIISObligee;
import com.geniisys.common.service.GIISObligeeService;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.StringFormatter;

public class GIISObligeeServiceImpl implements GIISObligeeService{
	
	private GIISObligeeDAO	giisObligeeDAO;

	public GIISObligeeDAO getGiisObligeeDAO() {
		return giisObligeeDAO;
	}

	/**
	 * Sets the giisObligeeDAO
	 * @param giisObligeeDAO
	 */
	public void setGiisObligeeDAO(GIISObligeeDAO giisObligeeDAO) {
		this.giisObligeeDAO = giisObligeeDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISObligeeService#getObligeeList(java.util.HashMap)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getObligeeList(HashMap<String, Object> params) throws SQLException {
		
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"),ApplicationWideParameters.PAGE_SIZE);//
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<GIISObligee> obligeeList = this.getGiisObligeeDAO().getObligeeList(params);
		params.put("rows", new JSONArray((List<GIISObligee>)StringFormatter.escapeHTMLInList(obligeeList)));
		grid.setNoOfPages(obligeeList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISObligeeService#getObligeeListMaintenance(java.util.HashMap)
	 */
	@Override
	public List<GIISObligee> getObligeeListMaintenance(HashMap<String, Object> params) throws SQLException {
		return this.getGiisObligeeDAO().getObligeeListMaintenance(params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISObligeeService#saveObligee(javax.servlet.http.HttpServletRequest, java.lang.String)
	 */
	@Override
	public String saveObligee(HttpServletRequest request, String userId) throws SQLException, JSONException {
		JSONObject objParameters = new JSONObject(request.getParameter("parameters"));
		
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), userId, GIISObligee.class));
		allParams.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("delRows")), userId, GIISObligee.class));
		allParams.put("userId", userId); //marco - 05.02.2013
		
		return this.getGiisObligeeDAO().saveObligee(allParams);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISObligeeService#validateObligeeNoOnDelete(java.lang.Integer)
	 */
	@Override
	public String validateObligeeNoOnDelete(Integer obligeeNoToValidate) throws SQLException {
		return this.getGiisObligeeDAO().validateObligeeNoOnDelete(obligeeNoToValidate);
	}
	
	
}
