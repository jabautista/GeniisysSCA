package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import com.geniisys.common.dao.GIISReinsurerTypeDAO;
import com.geniisys.common.entity.GIISReinsurerType;
import com.geniisys.common.service.GIISReinsurerTypeService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIISReinsurerTypeServiceImpl implements GIISReinsurerTypeService{
	
	private GIISReinsurerTypeDAO giisReinsurerTypeDAO;
	
	@Override
	public JSONObject showGiiss025(HttpServletRequest request, String userId)	
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss025RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);		
		return new JSONObject(recList);
	}
	
	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("riType") != null){
			String recId = request.getParameter("riType");
			this.giisReinsurerTypeDAO.valDeleteRec(recId);
		}
	}

	@Override
	public void saveGiiss025(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISReinsurerType.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISReinsurerType.class));
		params.put("appUser", userId);
		this.giisReinsurerTypeDAO.saveGiiss025(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("riType") != null){
			String recId = request.getParameter("riType");
			this.giisReinsurerTypeDAO.valAddRec(recId);
		}
	}

	public GIISReinsurerTypeDAO getGiisReinsurerTypeDAO() {
		return giisReinsurerTypeDAO;
	}

	public void setGiisReinsurerTypeDAO(GIISReinsurerTypeDAO giisReinsurerTypeDAO) {
		this.giisReinsurerTypeDAO = giisReinsurerTypeDAO;
	}
}
