package com.geniisys.giis.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISISSource;
import com.geniisys.common.entity.GIISLine;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.GIISUserIssCd;
import com.geniisys.common.entity.GIISUserLine;
import com.geniisys.common.entity.GIISUserModules;
import com.geniisys.common.entity.GIISUserTran;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giis.dao.GIISUserDAO;
import com.geniisys.giis.service.GIISUserService;

public class GIISUserServiceImpl implements GIISUserService {
	
	private GIISUserDAO giisUserDAO;
	
	@Override
	public JSONObject showGiiss040(HttpServletRequest request, String lastUserId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss040RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		if(request.getParameter("refresh") == null) {
			Map<String, Object> parameters = giisUserDAO.whenNewFormInstance();
			request.setAttribute("params", new JSONObject(parameters));
		}
		
		return new JSONObject(recList);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("maintainUserId") != null){
			String recId = request.getParameter("maintainUserId");
			this.giisUserDAO.valDeleteRec(recId);
		}
	}

	@Override
	public void saveGiiss040(HttpServletRequest request, String lastUserId)
			throws Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), lastUserId, GIISUser.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), lastUserId, GIISUser.class));
		params.put("appUser", lastUserId);
		this.giisUserDAO.saveGiiss040(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("maintainUserId") != null){
			String recId = request.getParameter("maintainUserId");
			this.giisUserDAO.valAddRec(recId);
		}
	}

	public GIISUserDAO getGiisUserDAO() {
		return giisUserDAO;
	}

	public void setGiisUserDAO(GIISUserDAO giisUserDAO) {
		this.giisUserDAO = giisUserDAO;
	}

	@Override
	public void saveGiiss040Tran(HttpServletRequest request, String lastUserId)
			throws Exception {
		String gutUserId = request.getParameter("gutUserId");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setTranRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setTranRows")), gutUserId, GIISUserTran.class));
		params.put("delTranRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delTranRows")), gutUserId, GIISUserTran.class));
		//params.put("setIssRows", JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("setIssRows"))));
		params.put("setIssRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setIssRows")), gutUserId, GIISUserIssCd.class));
		params.put("delIssRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delIssRows")), gutUserId, GIISUserIssCd.class));
		//params.put("setLineRows", JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("setLineRows"))));
		params.put("setLineRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setLineRows")), gutUserId, GIISUserLine.class));
		params.put("delLineRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delLineRows")), gutUserId, GIISUserLine.class));
		params.put("appUser", lastUserId);
		params.put("gutUserId", gutUserId);
		this.giisUserDAO.saveGiiss040Tran(params);
	}

	@Override
	public void saveGiiss040UserModules(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		//params.put("setRows", JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("setRows"))));
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISUserModules.class));
		params.put("appUser", userId);
		this.giisUserDAO.saveGiiss040UserModules(params);
	}

	@Override
	public void checkAllUserModule(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tranCd", request.getParameter("tranCd"));
		params.put("umUserId", request.getParameter("umUserId"));
		params.put("appUser", userId);
		this.giisUserDAO.checkAllUserModule(params);
	}

	@Override
	public void uncheckAllUserModule(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tranCd", request.getParameter("tranCd"));
		params.put("umUserId", request.getParameter("umUserId"));
		params.put("appUser", userId);
		this.giisUserDAO.uncheckAllUserModule(params);
	}

	@Override
	public JSONArray includeAllIssCodes(HttpServletRequest request,
			String userId) throws SQLException, JSONException {		
		List<GIISISSource> list = this.giisUserDAO.includeAllIssCodes();
		
		return new JSONArray(list);
	}

	@Override
	public JSONArray includeAllLineCodes(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		List<GIISLine> list = this.giisUserDAO.includeAllLineCodes();
		
		return new JSONArray(list);
	}

	@Override
	public void valDeleteRecTran1(HttpServletRequest request)
			throws SQLException {
		if(request.getParameter("issCd") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("issCd", request.getParameter("issCd"));
			this.giisUserDAO.valDeleteRecTran1(params);
		}
	}

	@Override
	public void valDeleteRecTran1Line(HttpServletRequest request)
			throws SQLException {
		if(request.getParameter("issCd") != null && request.getParameter("lineCd") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("issCd", request.getParameter("issCd"));
			params.put("lineCd", request.getParameter("lineCd"));
			this.giisUserDAO.valDeleteRecTran1Line(params);
		}
	}

	@Override
	public GIISUser getUserDetails(String userId) throws SQLException {
		GIISUser user = this.getGiisUserDAO().getUserDetails(userId);
		return user;
	}

}
