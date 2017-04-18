package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import com.geniisys.common.dao.GIISLineSublineCoveragesDAO;
import com.geniisys.common.entity.GIISLineSublineCoverages;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISLineSublineCoveragesService;
import com.geniisys.framework.util.JSONUtil;

public class GIISLineSublineCoveragesServiceImpl implements GIISLineSublineCoveragesService{

	private GIISLineSublineCoveragesDAO giisLineSublineCoveragesDAO;
	
	/**
	 * @return the giisLineSublineCoveragesDAO
	 */
	public GIISLineSublineCoveragesDAO getGiisLineSublineCoveragesDAO() {
		return giisLineSublineCoveragesDAO;
	}

	/**
	 * @param giisLineSublineCoveragesDAO the giisLineSublineCoveragesDAO to set
	 */
	public void setGiisLineSublineCoveragesDAO(GIISLineSublineCoveragesDAO giisLineSublineCoveragesDAO) {
		this.giisLineSublineCoveragesDAO = giisLineSublineCoveragesDAO;
	}
		
	@Override
	public JSONObject showPackageLineCoverage(HttpServletRequest request,  String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("ACTION", "showPackageLineCoverage");		
		params.put("userId", userId);
		return this.giisLineSublineCoveragesDAO.showPackageLineCoverage(request, params); 
	}
	
	@Override
	public JSONObject showPackageLineSublineCoverage(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("ACTION", "showPackageLineSublineCoverage");	
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("userId", userId);
		return this.giisLineSublineCoveragesDAO.showPackageLineSublineCoverage(request, params); 
	}

	@Override
	public Map<String, Object> saveGiiss096(String parameter,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		JSONObject objParameters = new JSONObject(parameter);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), USER.getUserId(), GIISLineSublineCoverages.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("delRows")), USER.getUserId(), GIISLineSublineCoverages.class));
		return this.giisLineSublineCoveragesDAO.saveGiiss096(params);
	}		
	
	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();				
		params.put("lineCd", request.getParameter("lineCd"));		
		params.put("packLineCd", request.getParameter("packLineCd"));		
		params.put("packSublineCd", request.getParameter("packSublineCd"));				
		this.giisLineSublineCoveragesDAO.valDeleteRec(params);
	}
	
	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();				
		params.put("lineCd", request.getParameter("lineCd"));		
		params.put("packLineCd", request.getParameter("packLineCd"));		
		params.put("packSublineCd", request.getParameter("packSublineCd"));				
		this.giisLineSublineCoveragesDAO.valAddRec(params);
	}	
}
