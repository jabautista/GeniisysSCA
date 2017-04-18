package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIACBankBookTranDAO;
import com.geniisys.common.entity.GIACBankBookTran;
import com.geniisys.common.service.GIACBankBookTranService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIACBankBookTranServiceImpl implements GIACBankBookTranService{
	private GIACBankBookTranDAO giacBankBookTranDAO;

	public GIACBankBookTranDAO getGiacBankBookTranDAO() {
		return giacBankBookTranDAO;
	}

	public void setGiacBankBookTranDAO(GIACBankBookTranDAO giacBankBookTranDAO) {
		this.giacBankBookTranDAO = giacBankBookTranDAO;
	}

	@Override
	public JSONObject showGiacs324(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs324RecList");
		params.put("bankCd", request.getParameter("bankCd"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("bankCd") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("bankCd", request.getParameter("bankCd"));
			params.put("bankTranCd", request.getParameter("bankTranCd"));
			params.put("bookTranCd", request.getParameter("bookTranCd"));
			System.out.println("VALIDATING RECORD TO BE ADDED ::::::::::::::::::::: " + params);
			this.giacBankBookTranDAO.valAddRec(params);
		}
	}

	@Override
	public void saveGiacs324(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACBankBookTran.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIACBankBookTran.class));
		params.put("appUser", userId);
		this.giacBankBookTranDAO.saveGiacs324(params);
	}

	@Override
	public void valBookTranCd(HttpServletRequest request) throws SQLException {
		if(request.getParameter("bookTranCd") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("bookTranCd", request.getParameter("bookTranCd"));
			this.giacBankBookTranDAO.valBookTranCd(params);
		}
	}
}
