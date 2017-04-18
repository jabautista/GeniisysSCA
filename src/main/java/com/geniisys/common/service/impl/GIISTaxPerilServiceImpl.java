/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISTaxPerilDAO;
import com.geniisys.common.entity.GIISTaxPeril;
import com.geniisys.common.service.GIISTaxPerilService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.StringFormatter;

public class GIISTaxPerilServiceImpl implements GIISTaxPerilService{

	private GIISTaxPerilDAO giisTaxPerilDAO;
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.service.GIISTaxPerilService#getRequiredTaxPerils(java.lang.String, java.lang.String)
	 */
	@Override
	public List<GIISTaxPeril> getRequiredTaxPerils(String issCd, String lineCd)
			throws SQLException {
		return this.getGiisTaxPerilDAO().getRequiredTaxPerils(issCd, lineCd);
	}

	/**
	 * @param giisTaxPerilDAO the giisTaxPerilDAO to set
	 */
	public void setGiisTaxPerilDAO(GIISTaxPerilDAO giisTaxPerilDAO) {
		this.giisTaxPerilDAO = giisTaxPerilDAO;
	}

	/**
	 * @return the giisTaxPerilDAO
	 */
	public GIISTaxPerilDAO getGiisTaxPerilDAO() {
		return giisTaxPerilDAO;
	}

	@Override
	public JSONObject showTaxPeril(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getTaxPerilList");		
		params.put("lineCd", request.getParameter("lineCd"));	
		params.put("issCd", request.getParameter("issCd"));	
		params.put("taxCd", request.getParameter("taxCd"));	
		params.put("taxId", request.getParameter("taxId"));	
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	}

	@Override
	public void saveGiiss028TaxPeril(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISTaxPeril.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISTaxPeril.class));
		params.put("appUser", userId);
		this.giisTaxPerilDAO.saveGiiss028TaxPeril(params);
	}

}
