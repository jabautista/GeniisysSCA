package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import com.geniisys.common.dao.GIISCoIntrmdryTypesDAO;
import com.geniisys.common.entity.GIISCoIntrmdryTypes;
import com.geniisys.common.service.GIISCoIntrmdryTypesService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIISCoIntrmdryTypesServiceImpl implements GIISCoIntrmdryTypesService{
	
	private GIISCoIntrmdryTypesDAO giisCoIntrmdryTypesDAO;
	
	@Override
	public JSONObject showGiiss075(HttpServletRequest request, String userId)	
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss075RecList");	
		params.put("userId", userId);		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);		
		return new JSONObject(recList);
	}
	
	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("coIntmType", request.getParameter("coIntmType"));
		params.put("issCd", request.getParameter("issCd"));			
		this.giisCoIntrmdryTypesDAO.valDeleteRec(params);
	}

	@Override
	public void saveGiiss075(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISCoIntrmdryTypes.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISCoIntrmdryTypes.class));
		params.put("appUser", userId);
		this.giisCoIntrmdryTypesDAO.saveGiiss075(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {	
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("coIntmType", request.getParameter("coIntmType"));
		params.put("issCd", request.getParameter("issCd"));			
		this.giisCoIntrmdryTypesDAO.valAddRec(params);		
	}

	public GIISCoIntrmdryTypesDAO getGiisCoIntrmdryTypesDAO() {
		return giisCoIntrmdryTypesDAO;
	}

	public void setGiisCoIntrmdryTypesDAO(GIISCoIntrmdryTypesDAO giisCoIntrmdryTypesDAO) {
		this.giisCoIntrmdryTypesDAO = giisCoIntrmdryTypesDAO;
	}
}
