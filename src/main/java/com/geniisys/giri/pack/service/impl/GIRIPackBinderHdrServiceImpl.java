package com.geniisys.giri.pack.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giri.pack.dao.GIRIPackBinderHdrDAO;
import com.geniisys.giri.pack.entity.GIRIPackBinderHdr;
import com.geniisys.giri.pack.service.GIRIPackBinderHdrService;
import com.seer.framework.util.StringFormatter;

public class GIRIPackBinderHdrServiceImpl implements GIRIPackBinderHdrService{

	private GIRIPackBinderHdrDAO giriPackBinderHdrDAO;

	public GIRIPackBinderHdrDAO getGiriPackBinderHdrDAO() {
		return giriPackBinderHdrDAO;
	}

	public void setGiriPackBinderHdrDAO(GIRIPackBinderHdrDAO giriPackBinderHdrDAO) {
		this.giriPackBinderHdrDAO = giriPackBinderHdrDAO;
	}

	@Override
	public void getGiriPackbinderHdrGrid(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiriPackbinderHdrGrid");
		params.put("userId", USER.getUserId());
		params.put("packPolicyId", request.getParameter("packPolicyId"));
		params.put("pageSize", 8);
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("printPackageBinderTG", grid);
		request.setAttribute("object", grid);		
	}

	@Override
	public String savePackageBinderHdr(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		JSONObject objParams = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("USER", USER);
		params.put("userId", USER.getUserId());
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("setRows")), USER.getUserId(), GIRIPackBinderHdr.class));
		return this.giriPackBinderHdrDAO.savePackageBinderHdr(params);
	}
	
	
	
}
