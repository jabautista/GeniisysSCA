/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.service.impl
	File Name: GICLReqdDocsServiceImpl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Aug 11, 2011
	Description: 
*/


package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import atg.taglib.json.util.JSONException;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.gicl.dao.GICLReqdDocsDAO;
import com.geniisys.gicl.service.GICLReqdDocsService;

public class GICLReqdDocsServiceImpl implements GICLReqdDocsService{
	
	Logger log = Logger.getLogger(GICLReqdDocsServiceImpl.class);
	private GICLReqdDocsDAO giclReqdDocsDAO;
	
	@Override
	public void saveClaimDocs(Map<String, Object> params) throws SQLException, JSONException, Exception {
		this.getGiclReqdDocsDAO().saveClaimDocs(params);
	}

	/**
	 * @param giclReqdDocsDAO the giclReqdDocsDAO to set
	 */
	public void setGiclReqdDocsDAO(GICLReqdDocsDAO giclReqdDocsDAO) {
		this.giclReqdDocsDAO = giclReqdDocsDAO;
	}

	/**
	 * @return the giclReqdDocsDAO
	 */
	public GICLReqdDocsDAO getGiclReqdDocsDAO() {
		return giclReqdDocsDAO;
	}

	@Override
	public Map<String, Object> getPrePrintDetails(Map<String, Object> params)
			throws SQLException {
		return this.giclReqdDocsDAO.getPrePrintDetails(params);
	}

	@Override
	public String validateClmReqDocs(HttpServletRequest request, GIISUser USER)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("claimId", request.getParameter("claimId"));
		log.info("Validating claim required docs : "+params);
		return this.giclReqdDocsDAO.validateClmReqDocs(params);
	}

}
