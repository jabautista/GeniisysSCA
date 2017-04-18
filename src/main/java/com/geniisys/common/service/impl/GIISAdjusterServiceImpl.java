package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISAdjusterDAO;
import com.geniisys.common.entity.GIISAdjuster;
import com.geniisys.common.service.GIISAdjusterService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIISAdjusterServiceImpl implements GIISAdjusterService {
	
	private GIISAdjusterDAO giisAdjusterDAO;

	public GIISAdjusterDAO getGiisAdjusterDAO() {
		return giisAdjusterDAO;
	}

	public void setGiisAdjusterDAO(GIISAdjusterDAO giisAdjusterDAO) {
		this.giisAdjusterDAO = giisAdjusterDAO;
	}

	@Override
	public JSONObject showGicls210(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGicls210RecList");
		params.put("adjCompanyCd", (request.getParameter("adjCompanyCd") != null && !request.getParameter("adjCompanyCd").equals("")) ? Integer.parseInt(request.getParameter("adjCompanyCd")) : null );
		params.put("privAdjCd", (request.getParameter("privAdjCd") != null && !request.getParameter("privAdjCd").equals("")) ? Integer.parseInt(request.getParameter("privAdjCd")) : null);
		params.put("payeeName", request.getParameter("payeeName"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("adjCompanyCd") != null && !request.getParameter("adjCompanyCd").equals("")
				&& request.getParameter("privAdjCd") != null && !request.getParameter("privAdjCd").equals("")){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("adjCompanyCd", Integer.parseInt(request.getParameter("adjCompanyCd")));
			params.put("privAdjCd", Integer.parseInt(request.getParameter("privAdjCd")));
			this.giisAdjusterDAO.valDeleteRec(params);
		}
	}

	@Override
	public void saveGicls210(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISAdjuster.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISAdjuster.class));
		params.put("appUser", userId);
		this.giisAdjusterDAO.saveGicls210(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		//if(request.getParameter("adjCompanyCd") != null && request.getParameter("privAdjCd") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("adjCompanyCd", (request.getParameter("adjCompanyCd") != null && !request.getParameter("adjCompanyCd").equals("")) ? Integer.parseInt(request.getParameter("adjCompanyCd")) : null);
			params.put("privAdjCd", (request.getParameter("privAdjCd") != null && !request.getParameter("privAdjCd").equals("")) ? Integer.parseInt(request.getParameter("privAdjCd")) : null);
			this.giisAdjusterDAO.valAddRec(params);
		//}
	}

	@Override
	public Integer getLastPrivAdjNo(Integer adjCompanyCd) throws SQLException {
		return this.giisAdjusterDAO.getLastPrivAdjNo(adjCompanyCd);
	}

	
}
