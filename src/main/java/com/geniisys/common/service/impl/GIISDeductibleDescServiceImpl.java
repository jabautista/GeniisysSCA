package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;


import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISDeductibleDescDAO;
import com.geniisys.common.dao.GIISDeductibleDescDAO;
import com.geniisys.common.entity.GIISCollateralType;
import com.geniisys.common.entity.GIISDeductibleDesc;
import com.geniisys.common.service.GIISDeductibleDescService;
import com.geniisys.common.service.GIISDeductibleDescService;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.StringFormatter;

public class GIISDeductibleDescServiceImpl implements GIISDeductibleDescService{
	
	private GIISDeductibleDescDAO giisDeductibleDescDAO;
	
	public GIISDeductibleDescDAO getGiisDeductibleDescDAO() {
		return giisDeductibleDescDAO;
	}

	public void setGiisDeductibleDescDAO(GIISDeductibleDescDAO giisDeductibleDescDAO) {
		this.giisDeductibleDescDAO = giisDeductibleDescDAO;
	}

	@Override
	public JSONObject showGiiss010(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss010RecList");	
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("deductibleCd", request.getParameter("deductibleCd"));
		params.put("deductibleType", request.getParameter("deductibleType"));
		params.put("deductibleTitle", request.getParameter("deductibleTitle"));
		params.put("userId", userId);
		Map<String, Object> recList = StringFormatter.escapeHTMLInMap(TableGridUtil.getTableGrid(request, params));
		
		return new JSONObject(recList);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("lineCd") != null && request.getParameter("sublineCd") != null && request.getParameter("deductibleCd") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("checkBoth", request.getParameter("checkBoth"));
			params.put("lineCd", request.getParameter("lineCd"));
			params.put("sublineCd", request.getParameter("sublineCd"));
			params.put("deductibleCd", request.getParameter("deductibleCd"));
			this.giisDeductibleDescDAO.valDeleteRec(params);
		}
	}

	@Override
	public void saveGiiss010(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISDeductibleDesc.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISDeductibleDesc.class));
		params.put("appUser", userId);
		this.giisDeductibleDescDAO.saveGiiss010(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("deductibleCd", request.getParameter("deductibleCd"));
		params.put("deductibleTitle", request.getParameter("deductibleTitle"));
		this.giisDeductibleDescDAO.valAddRec(params);
	}

	/* start - Gzelle 08272015 SR4851 */
	@Override
	public Map<String, Object> getAllTDedType(HttpServletRequest request) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("deductibleType", request.getParameter("deductibleType"));
		params = this.giisDeductibleDescDAO.getAllTDedType(params);
		List<?> list = (List<?>) params.get("list");
		params.put("maintainedDed", StringFormatter.escapeHTMLInJSONArray(new JSONArray(list)));
		return params;
	}
	/* end - Gzelle 08272015 SR4851 */
}
