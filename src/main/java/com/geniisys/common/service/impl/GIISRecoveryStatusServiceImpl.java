package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISRecoveryStatusDAO;
import com.geniisys.common.entity.GIISRecoveryStatus;
import com.geniisys.common.service.GIISRecoveryStatusService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIISRecoveryStatusServiceImpl implements GIISRecoveryStatusService{

	private GIISRecoveryStatusDAO giisRecoveryStatusDAO;

	/**
	 * @return the giisRecoveryStatusDAO
	 */
	public GIISRecoveryStatusDAO getGiisRecoveryStatusDAO() {
		return giisRecoveryStatusDAO;
	}

	/**
	 * @param giisRecoveryStatusDAO the giisRecoveryStatusDAO to set
	 */
	public void setGiisRecoveryStatusDAO(GIISRecoveryStatusDAO giisRecoveryStatusDAO) {
		this.giisRecoveryStatusDAO = giisRecoveryStatusDAO;
	}
	
	@Override
	public JSONObject showGicls100(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGicls100RecList");
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(map);
	}
	
	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("recStatCd") != null){
			String recId = request.getParameter("recStatCd");
			this.giisRecoveryStatusDAO.valDeleteRec(recId);
		}
	}

	@Override
	public void saveGicls100(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISRecoveryStatus.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISRecoveryStatus.class));
		params.put("appUser", userId);
		this.giisRecoveryStatusDAO.saveGicls100(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("recStatCd", request.getParameter("recStatCd"));
		params.put("recStatDesc", request.getParameter("recStatDesc"));
		this.giisRecoveryStatusDAO.valAddRec(params);
	}
}
