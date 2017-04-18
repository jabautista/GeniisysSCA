package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISDistShareMaintDAO;
import com.geniisys.common.entity.GIISDistShare;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISDistShareMaintService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIISDistShareMaintServiceImpl implements GIISDistShareMaintService {

	private GIISDistShareMaintDAO giisDistShareMaintDAO;
	
	public GIISDistShareMaintDAO getGiisDistShareMaintDAO() {
		return giisDistShareMaintDAO;
	}
	public void setGiisDistShareMaintDAO(GIISDistShareMaintDAO giisDistShareMaintDAO) {
		this.giisDistShareMaintDAO = giisDistShareMaintDAO;
	}
	
	public String saveDistShare(String strParams, Map<String, Object> params) throws JSONException, SQLException {
		
		JSONObject objParameters = new JSONObject(strParams);
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("delRows")),(String)params.get("appUser"), GIISDistShare.class));
		allParams.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")),(String)params.get("appUser"), GIISDistShare.class));
		allParams.put("lineCd", (String)params.get("lineCd"));
		allParams.put("shareType", (String)params.get("shareType"));
		allParams.put("userId", (String)params.get("appUser"));
		return this.getGiisDistShareMaintDAO().saveDistShare(allParams);
	}
	
	public String valDeleteDistShare(Map<String, Object> params) throws JSONException, SQLException {
		return this.getGiisDistShareMaintDAO().valDeleteDistShare(params);
	}
	
	public Map<String, Object> valAddDistShare(Map<String, Object> params) throws SQLException {
		return this.getGiisDistShareMaintDAO().valAddDistShare(params);
	}
	
	public Map<String, Object> validateUpdateDistShare(Map<String, Object> params) throws SQLException {
		return this.getGiisDistShareMaintDAO().validateUpdateDistShare(params);
	}
	
	public Map<String, Object> showProportionalTreatyInfo(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("shareCd", request.getParameter("shareCd"));
		return this.getGiisDistShareMaintDAO().showProportionalTreatyInfo(params);
	}

	public void giiss031UpdateTreaty(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException, Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("shareCd", request.getParameter("shareCd"));
		params.put("trtyLimit", request.getParameter("trtyLimit"));
		params.put("trtyName", request.getParameter("trtyName"));
		params.put("effDate", request.getParameter("effDate"));
		params.put("expiryDate", request.getParameter("expiryDate"));
		params.put("fundsHeldPct", request.getParameter("fundsHeldPct"));
		params.put("lossPrtfolioPct", request.getParameter("lossPrtfolioPct"));
		params.put("premPrtfolioPct", request.getParameter("premPrtfolioPct"));
		params.put("prtfolioSw", request.getParameter("prtfolioSw"));
		params.put("acctTrtyType", request.getParameter("acctTrtyType"));
		params.put("profcompType", request.getParameter("profcompType"));
		params.put("oldTrtySeqNo", request.getParameter("oldTrtySeqNo"));
		params.put("userId", USER.getUserId());
		giisDistShareMaintDAO.giiss031UpdateTreaty(params);
		
	}
	
	public Map<String, Object> validateAcctTrtyType(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("trtyName", request.getParameter("trtyName"));
		params.put("trtyType", request.getParameter("trtyType"));
		return giisDistShareMaintDAO.validateAcctTrtyType(params);
	}
	
	public Map<String, Object> validateProfComm(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lcfDesc", request.getParameter("lcfDesc"));
		params.put("lcfTag", request.getParameter("lcfTag"));
		return giisDistShareMaintDAO.validateProfComm(params);
	}
	
	@Override
	public JSONObject showGiiss031(HttpServletRequest request, String userId,  Map<String, Object> param)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss031RecList");
		params.put("lineCd", param.get("lineCd"));		
		params.put("trtyYy", param.get("trtyYy"));
		params.put("shareCd", param.get("shareCd"));	
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}
	
	public Map<String, Object> showNonProportionalTreatyInfo(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("xolId", request.getParameter("xolId"));
		return this.getGiisDistShareMaintDAO().showNonProportionalTreatyInfo(params);
	}
	
	public JSONObject showNonProTrtyInfo(HttpServletRequest request, String userId,  Map<String, Object> param)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "showNonProportionalTrtyInfo");
		params.put("lineCd", param.get("lineCd"));		
		params.put("trtyYy", param.get("xolYy"));
		params.put("xolId", param.get("xolId"));	
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}
	
	@Override
	public void saveGiiss031(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISDistShare.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISDistShare.class));
		params.put("appUser", userId);
		this.getGiisDistShareMaintDAO().saveGiiss031(params);
	}
	
	public void validateGiiss031TrtyName(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("trtyName", request.getParameter("trtyName"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("shareType", request.getParameter("shareType"));
		giisDistShareMaintDAO.validateGiiss031TrtyName(params);
	}
	
	public void validateGiiss031OldTrtySeq(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("oldTrtySeqNo", request.getParameter("oldTrtySeqNo"));
		params.put("shareCd", request.getParameter("shareCd"));
		params.put("shareType", request.getParameter("shareType"));
		params.put("acctTrtyType", request.getParameter("acctTrtyType"));
		giisDistShareMaintDAO.validateGiiss031OldTrtySeq(params);
	}
	
	public JSONObject showGiiss031AllRec(HttpServletRequest request, String userId, Map<String, Object> param)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss031AllRecList");
		params.put("lineCd", param.get("lineCd"));		
		params.put("trtyYy", param.get("trtyYy"));
		params.put("shareCd", param.get("shareCd"));	
		
		params.put("pageSize", 100);
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}
	
	public void valDeleteParentRec(HttpServletRequest request) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		if(request.getParameter("shareCd") != null){
			params.put("lineCd", request.getParameter("lineCd"));
			params.put("shareCd", request.getParameter("shareCd"));
			giisDistShareMaintDAO.valDeleteParentRec(params);
		}
	}
}
