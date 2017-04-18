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
import com.geniisys.giac.dao.GIACUsersDAO;
import com.geniisys.giac.entity.GIACUsers;
import com.geniisys.giac.service.GIACUsersService;


/**
 * @author steven
 *
 */
public class GIACUsersServiceImpl implements GIACUsersService{

	GIACUsersDAO giacUsersDAO;
	
	
	/**
	 * @return the giacUsersDAO
	 */
	public GIACUsersDAO getGiacUsersDAO() {
		return giacUsersDAO;
	}

	/**
	 * @param giacUsersDAO the giacUsersDAO to set
	 */
	public void setGiacUsersDAO(GIACUsersDAO giacUsersDAO) {
		this.giacUsersDAO = giacUsersDAO;
	}

	@Override
	public JSONObject showGiacs313(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs313RecList");
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(map);
	}
	
	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("giacUserId") != null){
			String recId = request.getParameter("giacUserId");
			this.giacUsersDAO.valDeleteRec(recId);
		}
	}

	@Override
	public void saveGiacs313(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACUsers.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIACUsers.class));
		params.put("appUser", userId);
		this.giacUsersDAO.saveGiacs313(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("giacUserId") != null){
			String recId = request.getParameter("giacUserId");
			this.giacUsersDAO.valAddRec(recId);
		}
	}
}
