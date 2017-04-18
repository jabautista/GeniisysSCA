package com.geniisys.common.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISCurrencyDAO;
import com.geniisys.common.entity.GIISCurrency;
import com.geniisys.common.service.GIISCurrencyService;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.TableGridUtil;

public class GIISCurrencyServiceImpl implements GIISCurrencyService {

	/** The GIIS Currency DAO **/
	private GIISCurrencyDAO giisCurrencyDAO;

	public void setGiisCurrencyDAO(GIISCurrencyDAO giisCurrencyDAO) {
		this.giisCurrencyDAO = giisCurrencyDAO;
	}

	public GIISCurrencyDAO getGiisCurrencyDAO() {
		return giisCurrencyDAO;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.service.GIISCurrencyService#getGiisCurrencyLOV(java.lang.Integer, java.lang.String)
	 */
	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getGiisCurrencyLOV(Integer pageNo, String keyword)
			throws SQLException {
		List<GIISCurrency> giisCurrency = this.getGiisCurrencyDAO().getGiisCurrencyLOV(keyword);
		PaginatedList paginatedList = new PaginatedList(giisCurrency, ApplicationWideParameters.PAGE_SIZE);
		paginatedList.gotoPage(pageNo);
		return paginatedList;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.service.GIISCurrencyService#getDCBCurrencyLOV(java.lang.Integer, java.util.Map)
	 */
	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getDCBCurrencyLOV(Integer pageNo,
			Map<String, Object> params) throws SQLException {
		List<GIISCurrency> currencyList = this.getGiisCurrencyDAO().getDCBCurrencyLOV(params);
		PaginatedList paginatedList = new PaginatedList(currencyList, ApplicationWideParameters.PAGE_SIZE);
		paginatedList.gotoPage(pageNo);
		return paginatedList;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.service.GIISCurrencyService#getCurrencyLOVByShortName(java.lang.String)
	 */
	@Override
	public List<GIISCurrency> getCurrencyLOVByShortName(String shortName)
			throws SQLException {
		return this.getGiisCurrencyDAO().getCurrencyLOVByShortName(shortName);
	}

	@Override
	public BigDecimal getCurrencyByShortname(String shortname)
			throws SQLException {
		return getGiisCurrencyDAO().getCurrencyByShortname(shortname);
	}

	@Override
	public JSONObject showCurrencyList(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "showCurrencyList");
		Map<String, Object> currencyTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonCurrencyMaintenance = new JSONObject(currencyTableGrid);
		request.setAttribute("jsonCurrencyMaintenance", jsonCurrencyMaintenance);
		return jsonCurrencyMaintenance;
	}

	@Override
	public String validateDeleteCurrency(HttpServletRequest request)
			throws SQLException {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("code", request.getParameter("code"));
		return this.getGiisCurrencyDAO().validateDeleteCurrency(params);
	}

	@Override
	public String validateMainCurrencyCd(HttpServletRequest request)
			throws SQLException {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("code", request.getParameter("code"));
		return this.getGiisCurrencyDAO().validateMainCurrencyCd(params);
	}

	@Override
	public String validateShortName(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("shortName", request.getParameter("shortName"));
		return this.getGiisCurrencyDAO().validateShortName(params);
	}

	@Override
	public String validateCurrencyDesc(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("currencyDesc", request.getParameter("currencyDesc"));
		return this.getGiisCurrencyDAO().validateCurrencyDesc(params);
	}

	@Override
	public String saveCurrency(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		JSONObject objParameters = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), userId, GIISCurrency.class));
		allParams.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("delRows")), userId, GIISCurrency.class));
		return this.getGiisCurrencyDAO().saveCurrency(allParams);
	}

	@Override
	public JSONObject getAllMainCurrencyCd(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getAllMainCurrencyCd");
		Map<String, Object> allMainCurrencyCd = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonMainCurrencyCdList = new JSONObject(allMainCurrencyCd);
		request.setAttribute("jsonMainCurrencyCdList", jsonMainCurrencyCdList);
		return jsonMainCurrencyCdList;
	}

	@Override
	public JSONObject getAllShortName(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getAllShortName");
		Map<String, Object> allShortName = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonShortNameList = new JSONObject(allShortName);
		request.setAttribute("jsonShortNameList", jsonShortNameList);
		return jsonShortNameList;
	}

	@Override
	public JSONObject getAllCurrencyDesc(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getAllCurrencyDesc");
		Map<String, Object> allCurrencyDesc = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonCurrencyDescList = new JSONObject(allCurrencyDesc);
		request.setAttribute("jsonCurrencyDescList", jsonCurrencyDescList);
		return jsonCurrencyDescList;
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("code") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("mainCurrencyCd", request.getParameter("code"));
			this.giisCurrencyDAO.valDeleteRec(params);
		}
	}

	@Override
	public void saveGiiss009(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISCurrency.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISCurrency.class));
		params.put("appUser", userId);
		this.giisCurrencyDAO.saveGiiss009(params);
	}

}
