/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.jfree.util.Log;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.gipi.dao.GIPIWRequiredDocumentsDAO;
import com.geniisys.gipi.entity.GIPIQuoteWarrantyAndClause;
import com.geniisys.gipi.entity.GIPIWRequiredDocuments;
import com.geniisys.gipi.service.GIPIWRequiredDocumentsService;


/**
 * The Class GIPIWRequiredDocumentsServiceImpl.
 */
public class GIPIWRequiredDocumentsServiceImpl implements GIPIWRequiredDocumentsService {

	/** The gipi w required documents dao. */
	private GIPIWRequiredDocumentsDAO gipiWRequiredDocumentsDAO;
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWRequiredDocumentsService#getReqDocsList(java.lang.Integer)
	 */
	@Override
	public List<GIPIWRequiredDocuments> getReqDocsList(Integer parId)
			throws SQLException {
		return this.getGipiWRequiredDocumentsDAO().getReqDocsList(parId);
	}

	/**
	 * Sets the gipi w required documents dao.
	 * 
	 * @param gipiWRequiredDocumentsDAO the new gipi w required documents dao
	 */
	public void setGipiWRequiredDocumentsDAO(GIPIWRequiredDocumentsDAO gipiWRequiredDocumentsDAO) {
		this.gipiWRequiredDocumentsDAO = gipiWRequiredDocumentsDAO;
	}

	/**
	 * Gets the gipi w required documents dao.
	 * 
	 * @return the gipi w required documents dao
	 */
	public GIPIWRequiredDocumentsDAO getGipiWRequiredDocumentsDAO() {
		return gipiWRequiredDocumentsDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWRequiredDocumentsService#saveGIPIWReqDocs(java.util.Map)
	 */
	@Override
	public void saveGIPIWReqDocs(Map<String, Object> params) throws SQLException {
		this.getGipiWRequiredDocumentsDAO().saveGIPIWReqDocs(params);
	}
	@SuppressWarnings("unchecked")
	@Override
	//created by agazarraga 5/11/2012 for tablegrid conversion [saving]
	public void saveGIPISReqDocs(HttpServletRequest request,String userId)
			throws SQLException, JSONException {
		JSONObject paramsObj = new JSONObject(request.getParameter("parameters"));
		Map<String, List<GIPIWRequiredDocuments>> params = new HashMap<String, List<GIPIWRequiredDocuments>>();
		Log.info("Preparing records for saving...");
		params.put("setReqDoc", (List<GIPIWRequiredDocuments>) JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("setRD")), userId, GIPIWRequiredDocuments.class));
		params.put("delReqDoc", (List<GIPIWRequiredDocuments>) JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("delRD")), userId, GIPIWRequiredDocuments.class));
		Log.info("Finished preparing records.");
		this.gipiWRequiredDocumentsDAO.saveGIPISReqDocs(params);
		
	
	}
}
	


