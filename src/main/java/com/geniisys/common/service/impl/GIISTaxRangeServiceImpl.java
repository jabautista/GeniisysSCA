package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISTaxRangeDAO;
import com.geniisys.common.entity.GIISTaxRange;
import com.geniisys.common.service.GIISTaxRangeService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.StringFormatter;

public class GIISTaxRangeServiceImpl implements GIISTaxRangeService{

	private GIISTaxRangeDAO giisTaxRangeDAO;
	
	public void setGiisTaxRangeDAO(GIISTaxRangeDAO giisTaxRangeDAO) {
		this.giisTaxRangeDAO = giisTaxRangeDAO;
	}

	public GIISTaxRangeDAO getGiisTaxRangeDAO() {
		return giisTaxRangeDAO;
	}
	
	
	@Override
	public JSONObject showTaxRange(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getTaxRangeList");		
		params.put("lineCd", request.getParameter("lineCd"));	
		params.put("issCd", request.getParameter("issCd"));	
		params.put("taxCd", request.getParameter("taxCd"));	
		params.put("taxId", request.getParameter("taxId"));	
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	}

	@Override
	public void saveGiiss028TaxRange(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISTaxRange.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISTaxRange.class));
		params.put("appUser", userId);
		this.giisTaxRangeDAO.saveGiiss028TaxRange(params);
	}

	
	

}
