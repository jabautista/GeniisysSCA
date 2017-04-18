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
import com.geniisys.giac.dao.GIACCheckNoDAO;
import com.geniisys.giac.entity.GIACCheckNo;
import com.geniisys.giac.service.GIACCheckNoService;
import com.seer.framework.util.StringFormatter;

public class GIACCheckNoServiceImpl implements GIACCheckNoService{

	private GIACCheckNoDAO giacCheckNoDAO;

	public GIACCheckNoDAO getGiacCheckNoDAO() {
		return giacCheckNoDAO;
	}

	public void setGiacCheckNoDAO(GIACCheckNoDAO giacCheckNoDAO) {
		this.giacCheckNoDAO = giacCheckNoDAO;
	}

	@Override
	public void checkBranchForCheck(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		this.getGiacCheckNoDAO().checkBranchForCheck(params);
	}

	@Override
	public JSONObject getCheckNoList(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIACS326RecList");
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("bankCd", request.getParameter("bankCd"));
		params.put("bankAcctCd", request.getParameter("bankAcctCd"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("bankCd", request.getParameter("bankCd"));
		params.put("bankAcctCd", request.getParameter("bankAcctCd"));
		params.put("chkPrefix", request.getParameter("chkPrefix"));
		
		this.getGiacCheckNoDAO().valAddRec(params);
	}

	@Override
	public void valDelRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("bankCd", request.getParameter("bankCd"));
		params.put("bankAcctCd", request.getParameter("bankAcctCd"));
		params.put("chkPrefix", request.getParameter("chkPrefix"));
		
		this.getGiacCheckNoDAO().valDelRec(params);
	}

	@Override
	public void saveGIACS326(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACCheckNo.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIACCheckNo.class));
		params.put("appUser", userId);
		
		this.getGiacCheckNoDAO().saveGIACS326(params);
	}
	
}
