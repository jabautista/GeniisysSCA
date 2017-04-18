/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.giac.service.impl
	File Name: GIACChkReleaseInfoServiceImpl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Jun 20, 2012
	Description: 
*/


package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACChkReleaseInfoDAO;
import com.geniisys.giac.entity.GIACChkReleaseInfo;
import com.geniisys.giac.service.GIACChkReleaseInfoService;

public class GIACChkReleaseInfoServiceImpl implements GIACChkReleaseInfoService{
	private GIACChkReleaseInfoDAO giacChkReleaseInfoDAO;
	private Logger log = Logger.getLogger(GIACChkReleaseInfoServiceImpl.class);
	
	@Override
	public GIACChkReleaseInfo getgiacs016ChkReleaseInfo(Integer gaccTranId, Integer itemNo)
			throws SQLException {
		return getGiacChkReleaseInfoDAO().getgiacs016ChkReleaseInfo(gaccTranId,itemNo);
	}
	public GIACChkReleaseInfoDAO getGiacChkReleaseInfoDAO() {
		return giacChkReleaseInfoDAO;
	}
	public void setGiacChkReleaseInfoDAO(GIACChkReleaseInfoDAO giacChkReleaseInfoDAO) {
		this.giacChkReleaseInfoDAO = giacChkReleaseInfoDAO;
	}
	@Override
	public String saveCheckReleaseInfo(HttpServletRequest request, String userId)
			throws SQLException {
		log.info("save check release info");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("gaccTranId", request.getParameter("gaccTranId"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("checkPrefSuf", request.getParameter("checkPrefSuf"));
		params.put("checkNo", request.getParameter("checkNo"));
		params.put("orNo", request.getParameter("orNo"));
		params.put("releaseBy", request.getParameter("releaseBy"));
		params.put("receiveBy", request.getParameter("receiveBy"));
		params.put("checkReleaseDate", request.getParameter("checkReleaseDate"));
		params.put("orDate", request.getParameter("orDate"));
		return getGiacChkReleaseInfoDAO().saveCheckReleaseInfo(params);
	}
	@Override
	public GIACChkReleaseInfo getGIACS002ChkReleaseInfo(Map<String, Object> params) throws SQLException {
		return this.getGiacChkReleaseInfoDAO().getGIACS002ChkReleaseInfo(params);
	}
	@Override
	public String saveGIACS002ChkReleaseInfo(Map<String, Object> params) throws SQLException, Exception {
		return this.getGiacChkReleaseInfoDAO().saveGIACS002ChkReleaseInfo(params);
	}
	
}
