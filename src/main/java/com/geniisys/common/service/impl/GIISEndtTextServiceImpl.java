package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISEndtTextDAO;
import com.geniisys.common.entity.GIISEndtText;
import com.geniisys.common.service.GIISEndtTextService;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.entity.GIPIWEndtText;
import com.seer.framework.util.StringFormatter;

public class GIISEndtTextServiceImpl implements GIISEndtTextService{

	public GIISEndtTextDAO giisEndtTextDAO;

	public GIISEndtTextDAO getGiisGeninInfoDAO() {
		return giisEndtTextDAO;
	}
	public void setGiisEndtTextDAO(GIISEndtTextDAO giisEndtTextDAO) {
		this.giisEndtTextDAO = giisEndtTextDAO;
	}
	
	@SuppressWarnings({ "deprecation", "unchecked" })
	@Override
	public PaginatedList getEndtTextList(HashMap<String, Object> params,
			Integer pageNo) throws SQLException {
		List<GIPIWEndtText> list = (List<GIPIWEndtText>) StringFormatter.escapeHTMLInList(this.giisEndtTextDAO.getEndtTextList(params));
		PaginatedList paginatedList = new PaginatedList(list , ApplicationWideParameters.PAGE_SIZE);
		paginatedList.gotoPage(pageNo);
		return paginatedList;
	}
	
	@Override
	public JSONObject showGiiss104(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss104RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}
	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("endtCd") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			System.out.println(request.getParameter("endtCd"));
			params.put("endtCd", request.getParameter("endtCd"));
			this.giisEndtTextDAO.valAddRec(params);
		}
	}
	@Override
	public void saveGiiss104(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISEndtText.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISEndtText.class));
		params.put("appUser", userId);
		System.out.println("Endt text save parameters : " + params);
		this.giisEndtTextDAO.saveGiiss104(params);
	}

	//Gzelle 02062015
	@Override
	public void valDelRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("endtCd") != null){
			String recId = request.getParameter("endtCd");
			this.giisEndtTextDAO.valDelRec(recId);
		}
	}
}
