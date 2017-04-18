package com.geniisys.giis.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISIndustry;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giis.dao.GIISIndustryDAO;
import com.geniisys.giis.service.GIISIndustryService;

public class GIISIndustryServiceImpl implements GIISIndustryService{

	private GIISIndustryDAO giisIndustryDAO;
	
	public GIISIndustryDAO getGissIndustryDAO() {
		return giisIndustryDAO;
	}

	public void setGiisIndustryDAO(GIISIndustryDAO giisIndustryDAO) {
		this.giisIndustryDAO = giisIndustryDAO;
	}

	@Override
	public JSONObject getGIISS014IndustryList(HttpServletRequest request)
			throws SQLException, JSONException, ParseException {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIISS014IndustryList");
		params.put("indGrpCd", request.getParameter("indGrpCd"));
		
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(map);		
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("industryCd") != null){
			String industryCd = request.getParameter("industryCd");
			this.giisIndustryDAO.valDeleteRec(industryCd);
		}		
	}

	@Override
	public void saveGiiss014(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		System.out.println("Service - saveGiiss014");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISIndustry.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISIndustry.class));
		params.put("appUser", userId);
		this.giisIndustryDAO.saveGiiss014(params);
		
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("industryNm") != null){
			String industryNm = request.getParameter("industryNm");
			this.giisIndustryDAO.valAddRec(industryNm);
		}
	}

	@Override
	public void valUpdateRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("industryCd", request.getParameter("industryCd"));
		params.put("industryNm", request.getParameter("industryNm"));
		this.giisIndustryDAO.valUpdateRec(params);
	}
	
}
