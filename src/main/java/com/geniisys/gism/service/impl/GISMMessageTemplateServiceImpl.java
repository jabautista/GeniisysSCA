package com.geniisys.gism.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gism.dao.GISMMessageTemplateDAO;
import com.geniisys.gism.entity.GISMMessageTemplate;
import com.geniisys.gism.service.GISMMessageTemplateService;

public class GISMMessageTemplateServiceImpl implements GISMMessageTemplateService {
	
	private GISMMessageTemplateDAO gismMessageTemplateDAO;

	@Override
	public JSONObject showGisms002(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGisms002RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}
	
	@Override
	public JSONObject showGisms002ReserveWord(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGisms002ReserveWordRecList");		
		params.put("messageCd", request.getParameter("messageCd"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("messageCd") != null){
			String recId = request.getParameter("messageCd");
			this.gismMessageTemplateDAO.valDeleteRec(recId);
		}
	}

	@Override
	public void saveGisms002(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GISMMessageTemplate.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GISMMessageTemplate.class));
		params.put("appUser", userId);
		this.gismMessageTemplateDAO.saveGisms002(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("messageCd") != null){
			String recId = request.getParameter("messageCd");
			this.gismMessageTemplateDAO.valAddRec(recId);
		}
	}

	public GISMMessageTemplateDAO getGismMessageTemplateDAO() {
		return gismMessageTemplateDAO;
	}

	public void setGismMessageTemplateDAO(
			GISMMessageTemplateDAO gismMessageTemplateDAO) {
		this.gismMessageTemplateDAO = gismMessageTemplateDAO;
	}

}
