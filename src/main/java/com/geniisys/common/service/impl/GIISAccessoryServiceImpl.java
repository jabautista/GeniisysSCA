package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import com.geniisys.common.dao.GIISAccessoryDAO;
import com.geniisys.common.entity.GIISAccessory;
import com.geniisys.common.service.GIISAccessoryService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIISAccessoryServiceImpl implements GIISAccessoryService{
	
	private GIISAccessoryDAO giisAccessoryDAO;
	
	@Override
	public JSONObject showGiiss107(HttpServletRequest request, String userId)	
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss107RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);		
		return new JSONObject(recList);
	}
	
	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("accessoryCd") != null){
			Integer recId = Integer.parseInt(request.getParameter("accessoryCd"));
			this.giisAccessoryDAO.valDeleteRec(recId);
		}
	}

	@Override
	public void saveGiiss107(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISAccessory.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISAccessory.class));
		params.put("appUser", userId);
		this.giisAccessoryDAO.saveGiiss107(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {	
		if(request.getParameter("accessoryDesc") != null){
			String recId = request.getParameter("accessoryDesc");
			this.giisAccessoryDAO.valAddRec(recId);
		}
	}

	public GIISAccessoryDAO getGiisAccessoryDAO() {
		return giisAccessoryDAO;
	}

	public void setGiisAccessoryDAO(GIISAccessoryDAO giisAccessoryDAO) {
		this.giisAccessoryDAO = giisAccessoryDAO;
	}
}
