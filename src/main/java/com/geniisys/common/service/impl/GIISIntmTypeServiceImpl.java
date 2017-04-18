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
import com.geniisys.common.dao.GIISIntmTypeDAO;
import com.geniisys.common.entity.GIISIntmType;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISIntmTypeService;
import com.geniisys.framework.util.JSONUtil;

public class GIISIntmTypeServiceImpl implements GIISIntmTypeService{

	private GIISIntmTypeDAO giisIntmTypeDAO;
	
	/**
	 * @return the giisIntmTypeDAO
	 */
	public GIISIntmTypeDAO getGiisIntmTypeDAO() {
		return giisIntmTypeDAO;
	}

	/**
	 * @param giisIntmTypeDAO the giisIntmTypeDAO to set
	 */
	public void setGiisIntmTypeDAO(GIISIntmTypeDAO giisIntmTypeDAO) {
		this.giisIntmTypeDAO = giisIntmTypeDAO;
	}
	@Override
	public JSONObject showIntmType(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("ACTION", "showIntmType");	
		return this.giisIntmTypeDAO.showIntmType(request, params); 
	}
	
	@Override
	public Map<String, Object> saveIntmType(String parameter,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		JSONObject objParameters = new JSONObject(parameter);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), USER.getUserId(), GIISIntmType.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("delRows")), USER.getUserId(), GIISIntmType.class));
		return this.giisIntmTypeDAO.saveIntmType(params);
	}	
	
	public List<GIISIntmType> getIntmTypeGiiss203() throws SQLException{
		return this.giisIntmTypeDAO.getIntmTypeGiiss203();
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("intmType") != null){
			String recId = request.getParameter("intmType");
			this.giisIntmTypeDAO.valAddRec(recId);
		}		
	}
	
	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("intmType") != null){
			String recId = request.getParameter("intmType");
			this.giisIntmTypeDAO.valDeleteRec(recId);
		}
	}

	@Override
	public String valUpdateIntmType(Map<String, Object> params) throws JSONException, SQLException { //Added by Jerome 08.11.2016 SR 5583
		return this.giisIntmTypeDAO.valUpdateIntmType(params);
	}
	
}
