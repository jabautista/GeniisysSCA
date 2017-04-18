package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.giac.dao.GIACIntmPcommRtDAO;
import com.geniisys.giac.entity.GIACIntmPcommRt;
import com.geniisys.giac.service.GIACIntmPcommRtService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIACIntmPcommRtServiceImpl implements GIACIntmPcommRtService{
	private GIACIntmPcommRtDAO giacIntmPcommRtDAO;

	public GIACIntmPcommRtDAO getGiacIntmPcommRtDAO() {
		return giacIntmPcommRtDAO;
	}

	public void setGiacIntmPcommRtDAO(GIACIntmPcommRtDAO giacIntmPcommRtDAO) {
		this.giacIntmPcommRtDAO = giacIntmPcommRtDAO;
	}

	@Override
	public JSONObject showGiacs334(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs334RecList");
		params.put("intmNo", request.getParameter("intmNo"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("intmNo") != null && request.getParameter("lineCd") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("intmNo", request.getParameter("intmNo"));
			params.put("lineCd", request.getParameter("lineCd"));
			this.giacIntmPcommRtDAO.valAddRec(params);
		}
	}

	@Override
	public void saveGiacs334(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACIntmPcommRt.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIACIntmPcommRt.class));
		params.put("appUser", userId);
		this.giacIntmPcommRtDAO.saveGiacs334(params);
	}
}
