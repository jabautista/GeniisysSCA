package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import com.geniisys.common.dao.GIISCargoClassDAO;
import com.geniisys.common.entity.GIISCargoClass;
import com.geniisys.common.service.GIISCargoClassService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIISCargoClassServiceImpl implements GIISCargoClassService{
	
	private GIISCargoClassDAO giisCargoClassDAO;
	
	@Override
	public JSONObject showGiiss051(HttpServletRequest request, String userId)	
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss051RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);		
		return new JSONObject(recList);
	}
	
	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("cargoClassCd") != null){
			Integer recId = Integer.parseInt(request.getParameter("cargoClassCd"));
			this.giisCargoClassDAO.valDeleteRec(recId);
		}
	}

	@Override
	public void saveGiiss051(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISCargoClass.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISCargoClass.class));
		params.put("appUser", userId);
		this.giisCargoClassDAO.saveGiiss051(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("cargoClassCd") != null){
			Integer recId = Integer.parseInt(request.getParameter("cargoClassCd"));
			this.giisCargoClassDAO.valAddRec(recId);
		}
	}

	public GIISCargoClassDAO getGiisCargoClassDAO() {
		return giisCargoClassDAO;
	}

	public void setGiisCargoClassDAO(GIISCargoClassDAO giisCargoClassDAO) {
		this.giisCargoClassDAO = giisCargoClassDAO;
	}
}
