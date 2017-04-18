/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.gipi.dao.GIPIWCommInvoicePerilDAO;
import com.geniisys.gipi.entity.GIPIWCommInvoicePeril;
import com.geniisys.gipi.service.GIPIWCommInvoicePerilService;


/**
 * The Class GIPIWCommInvoicePerilServiceImpl.
 */
public class GIPIWCommInvoicePerilServiceImpl implements GIPIWCommInvoicePerilService {

	/** The gipi w comm invoice peril dao. */
	private GIPIWCommInvoicePerilDAO gipiWCommInvoicePerilDAO;
	
	/** The log. */
	private Logger log = Logger.getLogger(GIPIWCommInvoicePerilServiceImpl.class);

	/**
	 * Sets the gipi w comm invoice peril dao.
	 * 
	 * @param gipiWCommInvoicePerilDAO the new gipi w comm invoice peril dao
	 */
	public void setGipiWCommInvoicePerilDAO(GIPIWCommInvoicePerilDAO gipiWCommInvoicePerilDAO) {
		this.gipiWCommInvoicePerilDAO = gipiWCommInvoicePerilDAO;
	}

	/**
	 * Gets the gipi w comm invoice peril dao.
	 * 
	 * @return the gipi w comm invoice peril dao
	 */
	public GIPIWCommInvoicePerilDAO getGipiWCommInvoicePerilDAO() {
		return gipiWCommInvoicePerilDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWCommInvoicePerilService#getWCommInvoicePeril(int, int, int)
	 */
	@Override
	public List<GIPIWCommInvoicePeril> getWCommInvoicePeril(int parId,
			int itemGroup, int intermediaryIntmNo) throws SQLException {		
		log.info("Retrieving Commission Invoice Perils...");
		List<GIPIWCommInvoicePeril> wcommInvoicePerils = this.getGipiWCommInvoicePerilDAO().getWCommInvoicePeril(parId, itemGroup, intermediaryIntmNo);
		log.info(wcommInvoicePerils.size() + " Commission Invoice Peril(s) retrieved.");
		
		return wcommInvoicePerils;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWCommInvoicePerilService#getWCommInvoicePeril(int, int)
	 */
	@Override
	public List<GIPIWCommInvoicePeril> getWCommInvoicePeril(int parId) throws SQLException {
		List<GIPIWCommInvoicePeril> wcommInvoicePerils = this.getGipiWCommInvoicePerilDAO().getWCommInvoicePeril(parId);		
		return wcommInvoicePerils;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWCommInvoicePerilService#saveWCommInvoicePeril(int, int, int, int, int, java.math.BigDecimal, java.math.BigDecimal, java.math.BigDecimal, java.math.BigDecimal)
	 */
	@Override
	public boolean saveWCommInvoicePeril(List<GIPIWCommInvoicePeril> commInvoicePerils)
			throws SQLException {		
		log.info("Saving Commission Invoice Perils...");
		this.getGipiWCommInvoicePerilDAO().saveWCommInvoicePeril(commInvoicePerils);
		log.info("Commission Invoice Perils successfully saved.");
		
		return true;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWCommInvoicePerilService#deleteWCommInvoicePeril(int, int, int, int)
	 */
	@Override
	public boolean deleteWCommInvoicePeril(int parId, int itemGroup,
			int intermediaryIntmNo, int perilCd) throws SQLException {		
		log.info("Deleting Commission Invoice Perils...");
		this.getGipiWCommInvoicePerilDAO().deleteWCommInvoicePeril(parId, itemGroup, intermediaryIntmNo, perilCd);
		log.info("Commission Invoice Perils successfully deleted.");
		
		return false;
	}

	@Override
	public boolean deleteWCommInvoicePerilsByList(
			List<GIPIWCommInvoicePeril> commInvoicePerils) throws SQLException {
		this.getGipiWCommInvoicePerilDAO().deleteWCommInvoicePerilsByList(commInvoicePerils);		
		return true;
	}

	@Override
	public List<Map<String, Object>> prepareGIPIWCommInvoicePerilForDelete(
			JSONArray delRows) throws JSONException {
		List<Map<String, Object>> wcommInvPerils = new ArrayList<Map<String, Object>>();
		Map<String, Object> wcommInvPerilMap = null;
		JSONObject objWCommInvPeril = null;
		
		for(int i=0, length=delRows.length(); i < length; i++){
			wcommInvPerilMap = new HashMap<String, Object>();
			objWCommInvPeril = delRows.getJSONObject(i);
			
			wcommInvPerilMap.put("parId", objWCommInvPeril.isNull("parId") ? null : objWCommInvPeril.getInt("parId"));
			wcommInvPerilMap.put("itemGrp", objWCommInvPeril.isNull("itemGrp") ? null : objWCommInvPeril.getInt("itemGrp"));
			wcommInvPerilMap.put("takeupSeqNo", objWCommInvPeril.isNull("takeupSeqNo") ? null : objWCommInvPeril.getInt("takeupSeqNo"));
			wcommInvPerilMap.put("intrmdryIntmNo", objWCommInvPeril.isNull("intrmdryIntmNo") ? null : objWCommInvPeril.getInt("intrmdryIntmNo"));
			wcommInvPerilMap.put("perilCd", objWCommInvPeril.isNull("perilCd") ? null : objWCommInvPeril.get("perilCd"));
			
			wcommInvPerils.add(wcommInvPerilMap);
			wcommInvPerilMap = null;
		}
		return wcommInvPerils;
	}
}
