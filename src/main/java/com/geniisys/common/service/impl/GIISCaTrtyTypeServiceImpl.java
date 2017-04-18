package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import com.geniisys.common.dao.GIISCaTrtyTypeDAO;
import com.geniisys.common.entity.GIISCaTrtyType;
import com.geniisys.common.service.GIISCaTrtyTypeService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIISCaTrtyTypeServiceImpl implements GIISCaTrtyTypeService{
	
	private GIISCaTrtyTypeDAO giisCaTrtyTypeDAO;
	
	@Override
	public JSONObject showGiiss094(HttpServletRequest request, String userId)	
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss094RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);		
		return new JSONObject(recList);
	}
	
	@Override
	public void saveGiiss094(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISCaTrtyType.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISCaTrtyType.class));
		params.put("appUser", userId);
		this.giisCaTrtyTypeDAO.saveGiiss094(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("caTrtyType") != null){
			Integer recId = Integer.parseInt(request.getParameter("caTrtyType"));
			this.giisCaTrtyTypeDAO.valAddRec(recId);
		}
	}

	public GIISCaTrtyTypeDAO getGiisCaTrtyTypeDAO() {
		return giisCaTrtyTypeDAO;
	}

	public void setGiisCaTrtyTypeDAO(GIISCaTrtyTypeDAO giisCaTrtyTypeDAO) {
		this.giisCaTrtyTypeDAO = giisCaTrtyTypeDAO;
	}
}
