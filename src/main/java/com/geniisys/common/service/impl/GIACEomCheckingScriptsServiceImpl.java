package com.geniisys.common.service.impl;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIACEomCheckingScriptsDAO;
import com.geniisys.common.entity.GIACEomCheckingScripts;
import com.geniisys.common.service.GIACEomCheckingScriptsService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIACEomCheckingScriptsServiceImpl implements GIACEomCheckingScriptsService{
	
	private GIACEomCheckingScriptsDAO giacEomCheckingScriptsDAO;
	
	public GIACEomCheckingScriptsDAO getGiacEomCheckingScriptsDAO() {
		return giacEomCheckingScriptsDAO;
	}

	public void setGiacEomCheckingScriptsDAO(GIACEomCheckingScriptsDAO giacEomCheckingScriptsDAO) {
		this.giacEomCheckingScriptsDAO = giacEomCheckingScriptsDAO;
	}
	
	@Override
	public JSONObject showGiacs352(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs352RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void saveGiacs352(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACEomCheckingScripts.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIACEomCheckingScripts.class));
		params.put("appUser", userId);
		System.out.println("Policy type save parameters : " + params);
		this.giacEomCheckingScriptsDAO.saveGiacs352(params);
	}

}
