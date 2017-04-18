package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLMortgageeDAO;
import com.geniisys.gicl.service.GICLMortgageeService;
import com.seer.framework.util.StringFormatter;

public class GICLMortgageeServiceImpl implements GICLMortgageeService{

	private GICLMortgageeDAO giclMortgageeDAO;
	
	public void setGiclMortgageeDAO(GICLMortgageeDAO giclMortgageeDAO){
		this.giclMortgageeDAO = giclMortgageeDAO;
	}
	
	public GICLMortgageeDAO getGiclMortgageeDAO(){
		return this.giclMortgageeDAO;
	}
	
	@Override
	public void getGiclMortgageeGrid(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiclMortgageeGrid");
		params.put("userId", USER.getUserId());
		params.put("claimId", request.getParameter("claimId"));
		params.put("itemNo", request.getParameter("itemNo"));
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("giclMortgagee", grid);
		request.setAttribute("object", grid);
	}

	@Override
	public void setClmItemMortgagee(Map<String, Object> params)
			throws SQLException {
		this.giclMortgageeDAO.setClmItemMortgagee(params);
	}

	@Override
	public String checkIfGiclMortgageeExist(Map<String, Object> params)
			throws SQLException {
		return this.getGiclMortgageeDAO().checkIfGiclMortgageeExist(params);
	}

}
