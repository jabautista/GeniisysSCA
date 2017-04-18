package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISTaxIssuePlaceDAO;
import com.geniisys.common.entity.GIISTaxIssuePlace;
import com.geniisys.common.service.GIISTaxIssuePlaceService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.StringFormatter;

public class GIISTaxIssuePlaceServiceImpl implements GIISTaxIssuePlaceService{

	private GIISTaxIssuePlaceDAO giisTaxIssuePlaceDAO;
	
	public void setGiisTaxIssuePlaceDAO(GIISTaxIssuePlaceDAO giisTaxIssuePlaceDAO) {
		this.giisTaxIssuePlaceDAO = giisTaxIssuePlaceDAO;
	}

	public GIISTaxIssuePlaceDAO getGiisTaxIssuePlaceDAO() {
		return giisTaxIssuePlaceDAO;
	}
	
	@Override
	public void saveGiiss028TaxPlace(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISTaxIssuePlace.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISTaxIssuePlace.class));
		params.put("appUser", userId);
		this.giisTaxIssuePlaceDAO.saveGiiss028TaxPlace(params);
	}

	@Override
	public JSONObject showTaxPlace(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getTaxPlaceList");		
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("issCd", request.getParameter("issCd"));	
		params.put("taxCd", request.getParameter("taxCd"));	
		params.put("taxId", request.getParameter("taxId"));	
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	}

	@Override
	public void valDeleteTaxPlaceRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("issCd", request.getParameter("issCd"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("placeCd", request.getParameter("placeCd"));
		this.giisTaxIssuePlaceDAO.valDeleteTaxPlaceRec(params);
	}
}
