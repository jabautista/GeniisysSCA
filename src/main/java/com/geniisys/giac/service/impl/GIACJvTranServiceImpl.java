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
import com.geniisys.giac.dao.GIACJvTranDAO;
import com.geniisys.giac.entity.GIACJvTran;
import com.geniisys.giac.service.GIACJvTranService;

public class GIACJvTranServiceImpl implements GIACJvTranService {
	
	private GIACJvTranDAO giacJvTranDAO;

	@Override
	public JSONObject showGiacs323(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs323RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("jvTranCd") != null){
			String recId = request.getParameter("jvTranCd");
			this.giacJvTranDAO.valDeleteRec(recId);
		}
	}

	@Override
	public void saveGiacs323(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACJvTran.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIACJvTran.class));
		params.put("appUser", userId);
		this.giacJvTranDAO.saveGiacs323(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("jvTranCd") != null){
			String recId = request.getParameter("jvTranCd");
			this.giacJvTranDAO.valAddRec(recId);
		}
	}

	public GIACJvTranDAO getGiacJvTranDAO() {
		return giacJvTranDAO;
	}

	public void setGiacJvTranDAO(GIACJvTranDAO giacJvTranDAO) {
		this.giacJvTranDAO = giacJvTranDAO;
	}
}
