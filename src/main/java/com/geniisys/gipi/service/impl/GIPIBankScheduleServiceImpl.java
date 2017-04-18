package com.geniisys.gipi.service.impl;

import java.sql.SQLException;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIBankScheduleDAO;
import com.geniisys.gipi.service.GIPIBankScheduleService;

public class GIPIBankScheduleServiceImpl implements GIPIBankScheduleService{
	
	private GIPIBankScheduleDAO gipiBankScheduleDAO;

	public GIPIBankScheduleDAO getGipiBankScheduleDAO() {
		return gipiBankScheduleDAO;
	}

	public void setGipiBankScheduleDAO(GIPIBankScheduleDAO gipiBankScheduleDAO) {
		this.gipiBankScheduleDAO = gipiBankScheduleDAO;
	}

	@Override
	public JSONObject getBankCollection(HttpServletRequest request) throws SQLException, JSONException {		
		Map<String, Object> params = new HashMap<String, Object>();				
		params.put("ACTION", "getBankCollections");				
		params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);
		JSONObject json = new JSONObject(map);
		return json;
	}
	
	
}
