/**
 * 
 */
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
import com.geniisys.giac.dao.GIACAgingParametersDAO;
import com.geniisys.giac.entity.GIACAgingParameters;
import com.geniisys.giac.service.GIACAgingParametersService;

public class GIACAgingParametersServiceImpl implements GIACAgingParametersService {

	GIACAgingParametersDAO giacAgingParametersDAO;
	
	public GIACAgingParametersDAO getGiacAgingParametersDAO() {
		return giacAgingParametersDAO;
	}

	public void setGiacAgingParametersDAO(GIACAgingParametersDAO giacAgingParametersDAO) {
		this.giacAgingParametersDAO = giacAgingParametersDAO;
	}

	@Override
	public JSONObject showGiacs310(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs310RecList");
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("userId", userId);
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(map);
	}

	@Override
	public void saveGiacs310(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACAgingParameters.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIACAgingParameters.class));
		params.put("appUser", userId);
		this.giacAgingParametersDAO.saveGiacs310(params);
	}

	@Override
	public void copyRecords(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("appUser", userId);	// shan 07.17.2014
		params.put("fundCdFrom", request.getParameter("fundCdFrom"));
		params.put("branchCdFrom", request.getParameter("branchCdFrom"));
		params.put("fundCdTo", request.getParameter("fundCdTo"));
		params.put("branchCdTo", request.getParameter("branchCdTo"));
		params.put("userId", userId);
		this.giacAgingParametersDAO.copyRecords(params);
	}
}
