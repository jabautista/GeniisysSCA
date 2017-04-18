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
import com.geniisys.giac.dao.GIACBankDAO;
import com.geniisys.giac.entity.GIACBank;
import com.geniisys.giac.service.GIACBankService;

public class GIACBankServiceImpl implements GIACBankService {
	
	private GIACBankDAO giacBankDAO;

	public GIACBankDAO getGiacBankDAO() {
		return giacBankDAO;
	}

	public void setGiacBankDAO(GIACBankDAO giacBankDAO) {
		this.giacBankDAO = giacBankDAO;
	}

	@Override
	public JSONObject showGiacs307(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs307RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("bankCd") != null){
			String recId = request.getParameter("bankCd");
			this.giacBankDAO.valDeleteRec(recId);
		}
	}

	@Override
	public void saveGiacs307(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACBank.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIACBank.class));
		params.put("appUser", userId);
		this.giacBankDAO.saveGiacs307(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("bankCd") != null){
			String recId = request.getParameter("bankCd");
			this.giacBankDAO.valAddRec(recId);
		}
	}
}
