/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISISSourceDAO;
import com.geniisys.common.entity.GIISISSource;
import com.geniisys.common.entity.GIISIssourcePlace;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISISSourceFacadeService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIISISSourceFacadeServiceImpl.
 */
public class GIISISSourceFacadeServiceImpl implements GIISISSourceFacadeService{
	
	/** The giis issource dao. */
	private GIISISSourceDAO giisIssourceDAO;

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISISSourceFacadeService#getIssueSourceAllList()
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISISSource> getIssueSourceAllList() throws SQLException{
		return (List<GIISISSource>) StringFormatter.escapeHTMLInList(giisIssourceDAO.getIssueSourceAllList());
	}

	/**
	 * Gets the giis issource dao.
	 * 
	 * @return the giis issource dao
	 */
	public GIISISSourceDAO getGiisIssourceDAO() {
		return giisIssourceDAO;
	}

	/**
	 * Sets the giis issource dao.
	 * 
	 * @param giisIssourceDAO the new giis issource dao
	 */
	public void setGiisIssourceDAO(GIISISSourceDAO giisIssourceDAO) {
		this.giisIssourceDAO = giisIssourceDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISISSourceFacadeService#getDefaultIssCd(java.lang.String, java.lang.String)
	 */
	@Override
	public String getDefaultIssCd(String riSwitch, String userId)
			throws SQLException {
		return this.getGiisIssourceDAO().getDefaultIssCd(riSwitch, userId);
	}
	
	@Override
	public Map<String, Object> validatePolIssCd(Map<String, Object> params)
			throws SQLException {
		return this.getGiisIssourceDAO().validatePolIssCd(params);
	}
	
	@Override
	public Map<String, Object> validateIssCd(Map<String, Object> params)
			throws SQLException {
		return this.getGiisIssourceDAO().validateIssCd(params);
	}

	@Override
	public List<GIISISSource> validateIssCdGiexs006(Map<String, Object> params)
			throws SQLException {
		return this.getGiisIssourceDAO().validateIssCdGiexs006(params);
	}

	@Override
	public List<GIISISSource> getIssueSourceListing(Map<String, Object> params) throws SQLException {
		return this.getGiisIssourceDAO().getIssueSourceListing(params);
	}

	@Override
	public List<GIISISSource> getAllIssueSourceListing(Map<String, Object> params) throws SQLException {
		return this.getGiisIssourceDAO().getAllIssueSourceListing(params);
	}

	@Override
	public List<GIISISSource> getIssueSourceListingLOV(Map<String, Object> params) throws SQLException {
		return this.getGiisIssourceDAO().getIssueSourceListingLOV(params);
	}

	@Override
	public String getIssNameGicls201(HttpServletRequest request, String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("userId", userId);
		
		params = this.giisIssourceDAO.getIssNameGicls201(params);
		
		return new JSONObject(params).toString();
	}

	@Override
	public String getIssCdForBatchPosting(GIISUser USER) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getIssCdForBatchPosting");
		params.put("userId", USER.getUserId());
		return this.giisIssourceDAO.getIssCdForBatchPosting(params);
	}

	
	public JSONObject showGiiss004(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss004RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("issCd", request.getParameter("issCd"));
		params.put("issGrp", request.getParameter("issGrp"));
		this.giisIssourceDAO.valDeleteRec(params);
	}

	@Override
	public void saveGiiss004(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISISSource.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISISSource.class));
		params.put("appUser", userId);
		this.giisIssourceDAO.saveGiiss004(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("issCd") != null && request.getParameter("acctIssCd") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("issCd", request.getParameter("issCd"));
			params.put("acctIssCd", request.getParameter("acctIssCd"));
			this.giisIssourceDAO.valAddRec(params);
		}
	}
	
	public JSONObject showGiiss004Place(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss004PlaceList");		
		params.put("issCd", request.getParameter("issCd"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	}

	@Override
	public void valDeletePlaceRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("issCd") != null && request.getParameter("placeCd") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("issCd", request.getParameter("issCd"));
			params.put("placeCd", request.getParameter("placeCd"));
			this.giisIssourceDAO.valDeletePlaceRec(params);
		}
	}

	@Override
	public void saveGiiss004Place(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISIssourcePlace.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISIssourcePlace.class));
		params.put("appUser", userId);
		this.giisIssourceDAO.saveGiiss004Place(params);
	}

	@Override
	public void valAddPlaceRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("issCd") != null && request.getParameter("placeCd") != null && request.getParameter("place") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("issCd", request.getParameter("issCd"));
			params.put("placeCd", request.getParameter("placeCd"));
			params.put("place", request.getParameter("place"));
			this.giisIssourceDAO.valAddPlaceRec(params);
		}
	}

	@Override
	public JSONObject getAllIssuePlaces(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getAllIssuePlaces");		
		params.put("issCd", request.getParameter("issCd"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	}

	@Override
	public String getAcctIssCdList() throws SQLException {
		return this.getGiisIssourceDAO().getAcctIssCdList();
	}
	
}
