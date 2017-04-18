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
import com.geniisys.giac.dao.GIACPaytReqDocDAO;
import com.geniisys.giac.entity.GIACPaytReqDocs;
import com.geniisys.giac.service.GIACPaytReqDocService;
import com.seer.framework.util.StringFormatter;

public class GIACPaytReqDocServiceImpl implements GIACPaytReqDocService {
	
	private GIACPaytReqDocDAO giacPaytReqDocDAO;

	@Override
	public JSONObject showGiacs306(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("ACTION", "getGiacs306RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("fundCd") != null && request.getParameter("branchCd") != null && request.getParameter("documentCd") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("fundCd", request.getParameter("fundCd"));
			params.put("branchCd", request.getParameter("branchCd"));
			params.put("documentCd", request.getParameter("documentCd"));
			this.giacPaytReqDocDAO.valDeleteRec(params);
		}
	}

	@Override
	public void saveGiacs306(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACPaytReqDocs.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIACPaytReqDocs.class));
		params.put("appUser", userId);
		this.giacPaytReqDocDAO.saveGiacs306(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("fundCd") != null && request.getParameter("branchCd") != null && request.getParameter("documentCd") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("fundCd", request.getParameter("fundCd"));
			params.put("branchCd", request.getParameter("branchCd"));
			params.put("documentCd", request.getParameter("documentCd"));
			this.giacPaytReqDocDAO.valAddRec(params);
		}
	}

	public GIACPaytReqDocDAO getGiacPaytReqDocDAO() {
		return giacPaytReqDocDAO;
	}

	public void setGiacPaytReqDocDAO(GIACPaytReqDocDAO giacPaytReqDocDAO) {
		this.giacPaytReqDocDAO = giacPaytReqDocDAO;
	}
}
