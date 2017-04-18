package com.geniisys.giuw.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.giuw.dao.GIUWPolDistFinalDAO;
import com.geniisys.giuw.entity.GIUWWPerilds;
import com.geniisys.giuw.service.GIUWPolDistFinalService;

public class GIUWPolDistFinalServiceImpl implements GIUWPolDistFinalService {

	private GIUWPolDistFinalDAO giuwPolDistFinalDAO;
	
	
	public void setGiuwPolDistFinalDAO(GIUWPolDistFinalDAO giuwPolDistFinalDAO) {
		this.giuwPolDistFinalDAO = giuwPolDistFinalDAO;
	}


	public GIUWPolDistFinalDAO getGiuwPolDistFinalDAO() {
		return giuwPolDistFinalDAO;
	}

	@Override
	public Map<String, Object> compareGIPIItemItmperil(
			Map<String, Object> params) throws SQLException {
		return this.getGiuwPolDistFinalDAO().compareGIPIItemItmperil(params);
	}


	@Override
	public void createItemsGiuws010(Map<String, Object> params)
			throws SQLException, Exception {
		this.getGiuwPolDistFinalDAO().createItemsGiuws010(params);
	}


	@Override
	public void saveSetUpGroupsForDistrFinalItem(Map<String, Object> allParams)
			throws SQLException, Exception {
		this.getGiuwPolDistFinalDAO().saveSetUpGroupsForDistrFinalItem(allParams);
	}


	@Override
	public Map<String, Object> compareGIPIItemItmperilGiuws018(
			Map<String, Object> params) throws SQLException {
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		
		params.put("policyId", request.getParameter("policyId") == null ? null : Integer.parseInt(request.getParameter("policyId")));
		params.put("packPolFlag", request.getParameter("packPolFlag"));
		params.put("lineCd", request.getParameter("lineCd"));
		Debug.print(params);
		return this.getGiuwPolDistFinalDAO().compareGIPIItemItmperilGiuws018(params);
	}

	@Override
	public void createItemsGiuws018(Map<String, Object> params)
			throws SQLException, Exception {
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		GIISUser USER = (GIISUser) params.get("USER");
		params.put("distNo", request.getParameter("distNo") == null ? null : Integer.parseInt(request.getParameter("distNo")) );
		params.put("policyId", request.getParameter("policyId") == null ? null : Integer.parseInt(request.getParameter("policyId")) );
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd",request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("packPolFlag", request.getParameter("packPolFlag"));
		params.put("delDistTable", request.getParameter("delDistTable")); 
		params.put("userId", USER.getUserId());
		Debug.print(params);
		this.getGiuwPolDistFinalDAO().createItemsGiuws018(params);
		
	}


	@SuppressWarnings("unchecked")
	@Override
	public void saveSetUpPerilGrpDistFinal(Map<String, Object> allParams)
			throws SQLException, Exception {
		HttpServletRequest request = (HttpServletRequest) allParams.get("request");
		GIISUser USER = (GIISUser) allParams.get("USER");
		
		Map<String, Object> params = new HashMap<String, Object>();
		Integer distNo = request.getParameter("distNo")== null ? null : Integer.parseInt(request.getParameter("distNo"));
		Integer policyId = request.getParameter("policyId")== null ? null : Integer.parseInt(request.getParameter("policyId"));
		String lineCd = request.getParameter("lineCd");
		String sublineCd = request.getParameter("sublineCd");
		String issCd = request.getParameter("issCd");
		String packPolFlag = request.getParameter("packPolFlag");
		Debug.print(params);
		JSONArray setRows = new JSONArray(request.getParameter("setRows"));
		List<GIUWWPerilds> giuwwPerildsList =  (List<GIUWWPerilds>) JSONUtil.prepareObjectListFromJSON(setRows, USER.getUserId(), GIUWWPerilds.class);
		
		params.put("distNo", distNo);
		params.put("policyId", policyId);
		params.put("lineCd", lineCd);
		params.put("sublineCd", sublineCd);
		params.put("issCd", issCd);
		params.put("packPolFlag", packPolFlag);
		params.put("userId", USER.getUserId());
		params.put("setRows", giuwwPerildsList);
		this.getGiuwPolDistFinalDAO().saveSetUpPerilGrpDistFinal(params);
	}

	//edgar 09/11/2014
	@Override
	public Map<String, Object> checkPostedBinder(Map<String, Object> params)
			throws SQLException {
		return this.getGiuwPolDistFinalDAO().checkPostedBinder(params);
	}
	
	//added by jhing 12.05.2014  
	@Override
	public void validateSetupDistPerAction (Map<String, Object> params) throws SQLException , Exception{		
		this.getGiuwPolDistFinalDAO().validateSetupDistPerAction(params);
	}

}
