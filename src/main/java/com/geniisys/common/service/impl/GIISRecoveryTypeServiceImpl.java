package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISRecoveryTypeDAO;
import com.geniisys.common.entity.GIISRecoveryType;
import com.geniisys.common.service.GIISRecoveryTypeService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIISRecoveryTypeServiceImpl implements GIISRecoveryTypeService{

	GIISRecoveryTypeDAO giisRecoveryTypeDAO;
	
	
	public GIISRecoveryTypeDAO getGiisRecoveryTypeDAO() {
		return giisRecoveryTypeDAO;
	}


	public void setGiisRecoveryTypeDAO(GIISRecoveryTypeDAO giisRecoveryTypeDAO) {
		this.giisRecoveryTypeDAO = giisRecoveryTypeDAO;
	}


	@Override
	public String getRecTypeDescGicls201(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("recTypeCd", request.getParameter("recTypeCd"));
		
		params = this.giisRecoveryTypeDAO.getRecTypeDescGicls201(params);
		
		return new JSONObject(params).toString();
	}

	@Override
	public JSONObject showMenuRecoveryType(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGicls101RecList");
		params.put("recTypeCd", request.getParameter("recTypeCd"));
		params.put("recTypeDesc", request.getParameter("recTypeDesc"));
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(map);
	}
	
	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("recTypeCd") != null){
			String recId = request.getParameter("recTypeCd");
			this.giisRecoveryTypeDAO.valDeleteRec(recId);
		}
	}

	@Override
	public void saveGicls101(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISRecoveryType.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISRecoveryType.class));
		params.put("appUser", userId);
		this.giisRecoveryTypeDAO.saveGicls101(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("recTypeCd") != null){
			String recId = request.getParameter("recTypeCd");
			this.giisRecoveryTypeDAO.valAddRec(recId);
		}
	}
}
