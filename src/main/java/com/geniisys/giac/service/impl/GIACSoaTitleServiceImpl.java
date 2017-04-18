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
import com.geniisys.giac.dao.GIACSoaTitleDAO;
import com.geniisys.giac.entity.GIACSoaTitle;
import com.geniisys.giac.service.GIACSoaTitleService;

public class GIACSoaTitleServiceImpl implements GIACSoaTitleService {
	
	private GIACSoaTitleDAO giacSoaTitleDAO;
	
	@Override
	public JSONObject showGiacs335(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs335RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}

	@Override
	public String valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("repCd") != null){
			String repCd = request.getParameter("repCd");
			return this.giacSoaTitleDAO.valDeleteRec(repCd);
		} else {
			return null;
		}
		
	}

	@Override
	public void saveGiacs335(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACSoaTitle.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIACSoaTitle.class));
		params.put("appUser", userId);
		this.giacSoaTitleDAO.saveGiacs335(params);
	}

	@Override
	public String valAddRec(HttpServletRequest request) throws SQLException {
		/*if(request.getParameter("repCd") != null){
			String repCd = request.getParameter("repCd");
			this.giacSoaTitleDAO.valAddRec(repCd);
		}*/
		if(request.getParameter("repCd") != null && request.getParameter("colNo") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("repCd", request.getParameter("repCd"));
			params.put("colNo", request.getParameter("colNo"));
			//this.giacSoaTitleDAO.valAddRec(params);
			return this.giacSoaTitleDAO.valAddRec(params);
		} else {
			return null;
		}
	}

	public GIACSoaTitleDAO getGiacSoaTitleDAO() {
		return giacSoaTitleDAO;
	}

	public void setGiacSoaTitleDAO(GIACSoaTitleDAO giacSoaTitleDAO) {
		this.giacSoaTitleDAO = giacSoaTitleDAO;
	}

	@Override
	public Map<String, Object> validateRepCd(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("repCd", request.getParameter("repCd"));
		return this.giacSoaTitleDAO.validateRepCd(params);
	}

}
