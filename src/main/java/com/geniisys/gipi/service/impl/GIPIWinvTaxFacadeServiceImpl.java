/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;


import com.geniisys.gipi.dao.GIPIWinvTaxDAO;
import com.geniisys.gipi.entity.GIPIWinvTax;
import com.geniisys.gipi.service.GIPIWinvTaxFacadeService;
import com.seer.framework.util.Debug;


/**
 * The Class GIPIWinvTaxFacadeServiceImpl.
 */
public class GIPIWinvTaxFacadeServiceImpl implements GIPIWinvTaxFacadeService {

/** The gipi winv tax dao. */
private GIPIWinvTaxDAO  gipiWinvTaxDao;
	
	/**
	 * Sets the gipi winv tax dao.
	 * 
	 * @param gipiWinvTaxDAO the new gipi winv tax dao
	 */
	public void setGipiWinvTaxDAO(GIPIWinvTaxDAO gipiWinvTaxDAO) {
		this.gipiWinvTaxDao = gipiWinvTaxDAO;
	}
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWinvTaxFacadeServiceImpl.class);
	
	/**
	 * Gets the gipi winv tax dao.
	 * 
	 * @return the gipi winv tax dao
	 */
	public GIPIWinvTaxDAO getGipiWinvTaxDAO() {
		return gipiWinvTaxDao;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWinvTaxFacadeService#getGIPIWinvTax(int, int)
	 */
	@Override
	public List<GIPIWinvTax> getGIPIWinvTax(int parId, int itemGrp) throws SQLException {
		log.info("Retrieving WInvTax...");
		List<GIPIWinvTax> gipiWinvTax = gipiWinvTaxDao.getGIPIWinvTax(parId, itemGrp);
		log.info("WinvTax Size():" + gipiWinvTax.size());
		return gipiWinvTax;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWinvTaxFacadeService#saveWinvTax(java.util.Map)
	 */
	@Override
	public boolean saveWinvTax(Map<String, Object> parameters)
			throws SQLException {
		String[] taxId = (String[]) parameters.get("taxId");
		String[] taxCd = (String[]) parameters.get("taxCd");
		//String[] taxDesc = (String[]) parameters.get("taxDesc");
		String[] titaxAmt = (String[]) parameters.get("taxAmt");
		Integer parId = (Integer) parameters.get("parId");
		String lineCd = (String) parameters.get("lineCd");
		String issCd = (String) parameters.get("issCd");
		Integer itemGrp = (Integer) parameters.get("itemGrp");
		
		String[] titakeupSeqNo = (String[]) parameters.get("takeupSeqNo");
		String[] rate = (String[]) parameters.get("rate");
		String[] taxAllocation = (String[]) parameters.get("taxAllocation");
	//	String[] primarySw = (String[]) parameters.get("primarySw");
		String[] fixedTaxAllocation = (String[]) parameters.get("fixedTaxAllocation");
		@SuppressWarnings("unused")
		BigDecimal sumTaxAmt = (BigDecimal) parameters.get("sumTaxAmt");
		GIPIWinvTax winvtax = null;
		
		
		for(int i=0; i<taxCd.length; i++){
			winvtax = new GIPIWinvTax();
	System.out.println("tax takeupseqno " + titakeupSeqNo[0]);
			winvtax.setTaxId(taxId[i] == "" ? 0 : Integer.parseInt(taxId[i]));
			winvtax.setTaxCd(taxCd[i] == "" ? 0 : Integer.parseInt(taxCd[i]));
			winvtax.setTaxAmt(new BigDecimal(titaxAmt[i].replaceAll(",", "")));
			winvtax.setTaxAllocation(taxAllocation[i]);
			//winvtax.setTakeupSeqNo(titakeupSeqNo[i] == "" ? null : Integer.parseInt(titakeupSeqNo[i] ));
			winvtax.setTakeupSeqNo(titakeupSeqNo[i] == "" ? null : Integer.parseInt(titakeupSeqNo[i] ));
			winvtax.setParId(parId == null ? null : (parId));
			winvtax.setLineCd(lineCd);
			winvtax.setIssCd(issCd);
			winvtax.setItemGrp(itemGrp);
			winvtax.setRate(new BigDecimal (rate[i]));
		//	winvtax.setPrimarySw(primarySw[i]);
			//winvtax.setSumTaxAmt(sumTaxAmt);
			winvtax.setFixedTaxAllocation(fixedTaxAllocation[i]);
			this.getGipiWinvTaxDAO().saveGIPIWinvTax(winvtax);
		}
		return true;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWinvTaxFacadeService#deleteAllGIPIWinvTax(int)
	 */
	public boolean deleteAllGIPIWinvTax(int parId)
	throws SQLException {

			log.info("Deleting all WinvTax...");
			this.getGipiWinvTaxDAO().deleteAllGIPIWinvTax(parId);
			log.info("All Winvtax deleted.");

			return true;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWinvTaxFacadeService#isExist(java.lang.Integer)
	 */
	@Override
	public Map<String, String> isExist(Integer parId) throws SQLException {
		return this.gipiWinvTaxDao.isExist(parId);
	}
	
	public List<GIPIWinvTax> getGIPIWinvTax2(int parId) throws SQLException {
		log.info("Retrieving WInvTax...");
		List<GIPIWinvTax> gipiWinvTax = gipiWinvTaxDao.getGIPIWinvTax2(parId);
		log.info("WinvTax Size():" + gipiWinvTax.size());
		return gipiWinvTax;
	}
	
	public List<GIPIWinvTax> prepareAddModifiedTaxInfo(JSONArray setRows) throws JSONException, ParseException{
		GIPIWinvTax taxInfo = null;
		JSONObject json = null;
		List<GIPIWinvTax> setTaxInfo = new ArrayList<GIPIWinvTax>();
		for(int index=0; index<setRows.length(); index++) {
			json =  setRows.getJSONObject(index);
			
			taxInfo = new GIPIWinvTax();						
			taxInfo.setTaxId(json.isNull("taxId") ? null : json.getInt("taxId"));
			taxInfo.setTaxCd(json.isNull("taxCd") ? null : json.getInt("taxCd"));
			taxInfo.setTaxAmt(json.isNull("taxAmt") ? null : new BigDecimal(json.getString("taxAmt")));
			taxInfo.setParId(json.isNull("parId") ? null : json.getInt("parId"));
			taxInfo.setTakeupSeqNo(json.isNull("takeupSeqNo") ? null : json.getInt("takeupSeqNo"));
			taxInfo.setLineCd(json.isNull("lineCd") ? null : json.getString("lineCd"));
			taxInfo.setIssCd(json.isNull("issCd") ? null : json.getString("issCd"));
			taxInfo.setItemGrp(json.isNull("itemGrp") ? null : json.getInt("itemGrp"));
			taxInfo.setRate(json.isNull("rate") ? null : new BigDecimal(json.getString("rate")));
			taxInfo.setTaxAllocation(json.isNull("taxAllocation") ? null : json.getString("taxAllocation"));
			taxInfo.setFixedTaxAllocation(json.isNull("fixedTaxAllocation") ? null : json.getString("fixedTaxAllocation"));
			
			setTaxInfo.add(taxInfo);
		}	
		
		return setTaxInfo;
	}
	
	public List<Map<String, Object>> prepareTaxInfoToDelete(JSONArray delRows) throws JSONException, ParseException{
		List<Map<String, Object>> delItems = new ArrayList<Map<String,Object>>();
		Map<String, Object> delItem = null;
		for(int index=0; index<delRows.length(); index++) {
			
			delItem = new HashMap<String, Object>();
			delItem.put("parId", delRows.getJSONObject(index).isNull("parId") ? null : delRows.getJSONObject(index).getInt("parId"));
			delItem.put("itemGrp", delRows.getJSONObject(index).isNull("itemGrp") ? null : delRows.getJSONObject(index).getInt("itemGrp"));
			delItem.put("takeupSeqNo", delRows.getJSONObject(index).isNull("takeupSeqNo") ? null : delRows.getJSONObject(index).getInt("takeupSeqNo"));
			delItem.put("taxCd", delRows.getJSONObject(index).isNull("taxCd") ? null : delRows.getJSONObject(index).getInt("taxCd"));
			delItem.put("issCd", delRows.getJSONObject(index).isNull("issCd") ? null : delRows.getJSONObject(index).getString("issCd"));
			delItem.put("lineCd", delRows.getJSONObject(index).isNull("lineCd") ? null : delRows.getJSONObject(index).getString("lineCd"));
			Debug.print("DELETED PARAMS:  "  + delItem);
			delItems.add(delItem);
		}
		
		return delItems;
	}
	
}

