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

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISSublineDAO;
import com.geniisys.common.entity.GIISSubline;
import com.geniisys.common.entity.GIISSublineMain;
import com.geniisys.common.service.GIISSublineFacadeService;
import com.geniisys.framework.util.JSONUtil;
import com.ibm.disthub2.impl.matching.selector.ParseException;


/**
 * The Class GIISSublineFacadeServiceImpl.
 */
public class GIISSublineFacadeServiceImpl implements GIISSublineFacadeService{
	
	private static Logger log = Logger.getLogger(GIISSublineFacadeServiceImpl.class);
	
	/** The giis subline dao. */
	private GIISSublineDAO giisSublineDAO;
	
	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISSublineFacadeService#getSublineListing(java.lang.String)
	 */
	@Override
	public List<GIISSubline> getSublineListing(String sublineCd) {
		return giisSublineDAO.getGIISSublineListing(sublineCd);
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISSublineFacadeService#getSublineListingByLineCd(java.lang.String)
	 */
	public List<GIISSubline> getSublineListingByLineCd(String lineCd) {
		return giisSublineDAO.getGIISSublineListingByLineCd(lineCd);
	}

	/**
	 * Gets the giis subline dao.
	 * 
	 * @return the giis subline dao
	 */
	public GIISSublineDAO getGiisSublineDAO() {
		return giisSublineDAO;
	}
	/**
	 * Sets the giis subline dao.
	 * 
	 * @param giisSublineDAO the new giis subline dao
	 */
	public void setGiisSublineDAO(GIISSublineDAO giisSublineDAO) {
		this.giisSublineDAO = giisSublineDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISSublineFacadeService#getSublineDetails(java.lang.String, java.lang.String)
	 */
	@Override
	public GIISSubline getSublineDetails(String lineCd, String sublineCd)
			throws SQLException {
		return giisSublineDAO.getSublineDetails(lineCd, sublineCd);
	}
	
	@Override
	public Map<String, Object> validateSublineCd(Map<String, Object> params)
			throws SQLException {
		return this.getGiisSublineDAO().validateSublineCd(params);
	}

	@Override
	public Map<String, Object> validatePurgeSublineCd(Map<String, Object> params)
			throws SQLException {
		return this.getGiisSublineDAO().validatePurgeSublineCd(params);
	}

	@Override
	public List<GIISSubline> validateSublineCdGiexs006(Map<String, Object> params)
			throws SQLException {
		return this.getGiisSublineDAO().validateSublineCdGiexs006(params);
	}

	@Override
	public String getOpFlagGiuts008a(Map<String, Object> params)
			throws SQLException {
		return this.getGiisSublineDAO().getOpFlagGiuts008a(params);
	}

	@Override
	public GIISSubline getSublineDetails2(String lineCd, String sublineCd)
			throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("lineCd", lineCd);
		params.put("sublineCd", sublineCd);
		return this.giisSublineDAO.getSublineDetails2(params);
	}
	
	public String validateDeleteSubline(Map<String, Object> params)throws JSONException, SQLException, ParseException {
		log.info("SERVICE param "+params);
		return this.getGiisSublineDAO().validateDeleteSubline(params);
	}
	
	public String validateAddSubline(Map<String, Object> params) throws JSONException,SQLException, ParseException {
		System.out.println("SERVICE param "+params);
		return this.getGiisSublineDAO().validateAddSubline(params);
	}
	
	public String saveSubline(String parameters,  Map<String, Object> params) throws JSONException, SQLException, ParseException {
		JSONObject objParameters = new JSONObject(parameters);
		Map<String, Object> allParams = new HashMap<String, Object>();
		System.out.println("parameters " +parameters);
		System.out.println("objParameters "+ objParameters.getString("addRows"));
		allParams.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("addRows")), (String)params.get("appUser"), GIISSublineMain.class));
		allParams.put("updateRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("updateRows")), (String)params.get("appUser"), GIISSublineMain.class));
		allParams.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("delRows")), (String)params.get("appUser"), GIISSublineMain.class));
		allParams.put("lineCd", (String)params.get("lineCd"));
		allParams.put("sublineTime", (String)params.get("sublineTime"));
		allParams.put("appUser", (String)params.get("appUser"));
		return this.giisSublineDAO.saveInvoice(allParams);
	}

	@Override
	public String validateAcctSublineCd(Map<String, Object> allParams) throws SQLException {
		return this.getGiisSublineDAO().validateAcctSublineCd(allParams);
	}

	@Override
	public String validateOpenSw(Map<String, Object> allParams) throws SQLException {
		return this.getGiisSublineDAO().validateOpenSw(allParams);
	}

	@Override
	public String validateOpenFlag(Map<String, Object> allParams) throws SQLException {
		return this.getGiisSublineDAO().validateOpenFlag(allParams);
	}
	

}
