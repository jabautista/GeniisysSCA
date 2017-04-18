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
import com.geniisys.giac.dao.GIACModuleEntryDAO;
import com.geniisys.giac.entity.GIACModuleEntry;
import com.geniisys.giac.service.GIACModuleEntryService;

public class GIACModuleEntryServiceImpl implements GIACModuleEntryService {

	GIACModuleEntryDAO giacModuleEntryDAO;
	
	public GIACModuleEntryDAO getGiacModuleEntryDAO() {
		return giacModuleEntryDAO;
	}

	public void setGiacModuleEntryDAO(GIACModuleEntryDAO giacModuleEntryDAO) {
		this.giacModuleEntryDAO = giacModuleEntryDAO;
	}

	@Override
	public JSONObject showGiacs321(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs321RecList");
		params.put("moduleId", request.getParameter("moduleId"));
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(map);
	}
	
	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("giacUserId") != null){
			String recId = request.getParameter("giacUserId");
			this.giacModuleEntryDAO.valDeleteRec(recId);
		}
	}

	@Override
	public void saveGiacs313(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACModuleEntry.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIACModuleEntry.class));
		params.put("appUser", userId);
		this.giacModuleEntryDAO.saveGiacs321(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("itemNo", request.getParameter("itemNo"));
		this.giacModuleEntryDAO.valAddRec(params);
	}
}
