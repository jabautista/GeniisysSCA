package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISRiTypeDocsDAO;
import com.geniisys.common.entity.GIISRiTypeDocs;
import com.geniisys.common.service.GIISRiTypeDocsService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIISRiTypeDocsServiceImpl implements GIISRiTypeDocsService {
	
	private GIISRiTypeDocsDAO giisRiTypeDocsDAO;

	@Override
	public JSONObject showGiiss074(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss074RecList");	
		params.put("riType", request.getParameter("riType"));		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}

	@Override
	public String valDeleteRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("riType", request.getParameter("riType"));
		params.put("docCd", request.getParameter("docCd"));	
		return this.giisRiTypeDocsDAO.valDeleteRec(params);
	}

	@Override
	public void saveGiiss074(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISRiTypeDocs.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISRiTypeDocs.class));
		params.put("appUser", userId);
		this.giisRiTypeDocsDAO.saveGiiss074(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("riType", request.getParameter("riType"));
		params.put("docCd", request.getParameter("docCd"));	
		this.giisRiTypeDocsDAO.valAddRec(params);
	}
	
	@Override
	public Map<String, Object> validateRiType(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("riType", request.getParameter("riType"));
		return this.giisRiTypeDocsDAO.validateRiType(params);
	}

	public GIISRiTypeDocsDAO getGiisRiTypeDocsDAO() {
		return giisRiTypeDocsDAO;
	}

	public void setGiisRiTypeDocsDAO(GIISRiTypeDocsDAO giisRiTypeDocsDAO) {
		this.giisRiTypeDocsDAO = giisRiTypeDocsDAO;
	}
}
