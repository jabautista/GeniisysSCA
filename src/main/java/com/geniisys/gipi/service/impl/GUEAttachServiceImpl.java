package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.gipi.dao.GUEAttachDAO;
import com.geniisys.gipi.entity.GUEAttach;
import com.geniisys.gipi.service.GUEAttachService;

public class GUEAttachServiceImpl implements GUEAttachService {

	private GUEAttachDAO gueAttachDAO;
	
	@Override	
	public void saveGUEAttachments(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tranId", Integer.parseInt(request.getParameter("tranId")));
		params.put("setAttachRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setAttachRows")), userId, GUEAttach.class));
		params.put("delAttachRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delAttachRows")), userId, GUEAttach.class));
		this.gueAttachDAO.saveGUEAttachments(params);
	}

	public void setGueAttachDAO(GUEAttachDAO gueAttachDAO) {
		this.gueAttachDAO = gueAttachDAO;
	}

	public GUEAttachDAO getGueAttachDAO() {
		return gueAttachDAO;
	}

}
