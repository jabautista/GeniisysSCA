package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACSlTypeDAO;
import com.geniisys.giac.entity.GIACSlType;
import com.geniisys.giac.service.GIACSlTypeService;

public class GIACSlTypeServiceImpl implements GIACSlTypeService {

	private GIACSlTypeDAO giacSlTypeDAO;
	
	@Override
	public JSONObject showGiacs308(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getSlTypeList");
		
		Map<String, Object> giacSlTypeList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(giacSlTypeList);
	}

	public GIACSlTypeDAO getGiacSlTypeDAO() {
		return giacSlTypeDAO;
	}

	public void setGiacSlTypeDAO(GIACSlTypeDAO giacSlTypeDAO) {
		this.giacSlTypeDAO = giacSlTypeDAO;
	}

	@Override
	public void valDeleteSlType(HttpServletRequest request) throws SQLException {
		if(request.getParameter("slTypeCd") != null){
			this.giacSlTypeDAO.valDeleteSlType(request.getParameter("slTypeCd"));
		}
	}

	@Override
	public void saveGiacs308(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACSlType.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIACSlType.class));
		params.put("appUser", userId);		
		this.giacSlTypeDAO.saveGiacs308(params);
	}

	@Override
	public void valAddSlType(HttpServletRequest request) throws SQLException {
		if(request.getParameter("slTypeCd") != null){
			this.giacSlTypeDAO.valAddSlType(request.getParameter("slTypeCd"));
		}
	}

}
