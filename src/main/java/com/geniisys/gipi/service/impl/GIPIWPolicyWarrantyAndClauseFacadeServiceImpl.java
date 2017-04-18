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

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.gipi.dao.GIPIWPolicyWarrantyAndClauseDAO;
import com.geniisys.gipi.entity.GIPIWPolicyWarrantyAndClause;
import com.geniisys.gipi.pack.entity.GIPIPackWarrantyAndClauses;
import com.geniisys.gipi.service.GIPIWPolicyWarrantyAndClauseFacadeService;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIWPolicyWarrantyAndClauseFacadeServiceImpl.
 */
public class GIPIWPolicyWarrantyAndClauseFacadeServiceImpl implements GIPIWPolicyWarrantyAndClauseFacadeService{

	/** The gipi w policy warranty and clause dao. */
	private GIPIWPolicyWarrantyAndClauseDAO gipiWPolicyWarrantyAndClauseDAO;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWPolicyWarrantyAndClauseFacadeServiceImpl.class);
	
	/**
	 * Gets the gipi w policy warranty and clause dao.
	 * 
	 * @return the gipi w policy warranty and clause dao
	 */
	public GIPIWPolicyWarrantyAndClauseDAO getGipiWPolicyWarrantyAndClauseDAO() {
		return gipiWPolicyWarrantyAndClauseDAO;
	}

	/**
	 * Sets the gipi w policy warranty and clause dao.
	 * 
	 * @param gipiWPolicyWarrantyAndClauseDAO the new gipi w policy warranty and clause dao
	 */
	public void setGipiWPolicyWarrantyAndClauseDAO(
			GIPIWPolicyWarrantyAndClauseDAO gipiWPolicyWarrantyAndClauseDAO) {
		this.gipiWPolicyWarrantyAndClauseDAO = gipiWPolicyWarrantyAndClauseDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolicyWarrantyAndClauseFacadeService#getGIPIWPolicyWarrantyAndClauses(java.lang.String, int)
	 */
	@Override
	public List<GIPIWPolicyWarrantyAndClause> getGIPIWPolicyWarrantyAndClauses(
			String lineCd, int parId) throws SQLException {
		
		log.info("Retrieving WPolicy - Warranty and Clause...");
		List<GIPIWPolicyWarrantyAndClause> list = gipiWPolicyWarrantyAndClauseDAO.getGIPIWPolicyWarrantyAndClauses(lineCd, parId);
		log.info("Warranty and Clause Size():"+list.size());
		
		return list;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolicyWarrantyAndClauseFacadeService#deleteWPolWC(java.lang.String, int, java.lang.String)
	 */
	@Override
	public boolean deleteWPolWC(String lineCd, int parId, String wcCd)
			throws SQLException {
		
		log.info("Deleting WPolicy - Warranty and Clause...");
		this.getGipiWPolicyWarrantyAndClauseDAO().deleteWPolWC(lineCd, parId, wcCd);
		log.info("WPolicy - Warranty and Clause deleted.");
		
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolicyWarrantyAndClauseFacadeService#saveWPolWC(java.util.Map)
	 */
	@Override
	public boolean saveWPolWC(Map<String, Object> parameters) throws Exception{
		
		log.info("Saving WPolicy Warranty and Clause...");
		this.getGipiWPolicyWarrantyAndClauseDAO().saveWPolWC(parameters);
		log.info("WPolicy Warranty and Clause saved.");
		
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolicyWarrantyAndClauseFacadeService#deleteAllWPolWC(java.lang.String, int)
	 */
	@Override
	public boolean deleteAllWPolWC(String lineCd, int parId)
			throws SQLException {
		
		log.info("Deleting all WPolicy - Warranty and Clause...");
		this.getGipiWPolicyWarrantyAndClauseDAO().deleteAllWPolWC(lineCd, parId);
		log.info("All WPolicy - Warranty and Clause deleted.");
		
		return true;
	}

	@Override
	public List<GIPIWPolicyWarrantyAndClause> getAllWPolicyWCs(String lineCd,
			int parId) throws Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("lineCd", lineCd);
		return this.getGipiWPolicyWarrantyAndClauseDAO().getAllWPolicyWCs(params);
	}

	@Override
	public List<GIPIWPolicyWarrantyAndClause> prepareGIPIWPolWCForInsert(JSONArray setRows)
			throws SQLException, JSONException {
		List<GIPIWPolicyWarrantyAndClause> wcs = new ArrayList<GIPIWPolicyWarrantyAndClause>();
		GIPIWPolicyWarrantyAndClause wc = null;
		JSONObject objWC = null;
		
		for(int i=0, length=setRows.length(); i < length; i++){
			wc = new GIPIWPolicyWarrantyAndClause();
			objWC = setRows.getJSONObject(i);
			
			wc.setParId(objWC.getInt("parId")); 
			wc.setLineCd(objWC.getString("lineCd"));
			wc.setWcCd(objWC.getString("wcCd"));
			wc.setPrintSeqNo(objWC.isNull("printSeqNo") ? null : objWC.getInt("printSeqNo"));
			wc.setWcTitle(objWC.isNull("wcTitle") ? null : StringFormatter.unescapeHTML2(objWC.getString("wcTitle")));
			wc.setWcTitle2(objWC.isNull("wcTitle2") ? null : StringFormatter.unescapeHTML2(objWC.getString("wcTitle2")));
			wc.setWcText1(objWC.isNull("wcText1") ? null : StringFormatter.unescapeHTML2(objWC.getString("wcText1")));
			wc.setWcText2(objWC.isNull("wcText2") ? null : StringFormatter.unescapeHTML2(objWC.getString("wcText2")));
			wc.setPrintSw(objWC.isNull("printSw") ? null : objWC.getString("printSw"));
			wc.setChangeTag(objWC.isNull("changeTag") ? null : objWC.getString("changeTag"));
			wc.setUserId(objWC.isNull("userId") ? null : objWC.getString("userId"));
			wcs.add(wc);
			wc = null;
		}
		
		return wcs;
	}

	@Override
	public List<GIPIPackWarrantyAndClauses> getPolicyListWC(Integer packParId)
			throws SQLException {
		return this.getGipiWPolicyWarrantyAndClauseDAO().getPolicyListWC(packParId);
	}
	
	public List<Map<String, Object>> prepareDefaultGIPIWPolWC (
			JSONArray setRows) throws SQLException, JSONException {
		List<Map<String, Object>> wcs = new ArrayList<Map<String, Object>>();
		Map<String, Object> wc = null;
		JSONObject objWC = null;

		for (int i = 0, length = setRows.length(); i < length; i++) {
			wc = new HashMap<String, Object>();
			objWC = setRows.getJSONObject(i);			
			wc.put("parId", objWC.getInt("parId"));
			wc.put("lineCd", objWC.getString("lineCd"));
			wc.put("perilCd", objWC.getString("perilCd"));
			
			wcs.add(wc);			
		}
		return wcs;
	}

	@Override
	public void saveGIPIWPolWC(JSONArray setRows, JSONArray delRows)
			throws SQLException, JSONException, Exception {
		List<GIPIWPolicyWarrantyAndClause> setWPolWCList = this.prepareWPolWCListForInsert(setRows);
		List<GIPIWPolicyWarrantyAndClause> delWPolWCList = this.prepareWPolWCListForDelete(delRows);
		
		this.getGipiWPolicyWarrantyAndClauseDAO().saveGIPIWPolWC(setWPolWCList, delWPolWCList);
		
	}
	
	private List<GIPIWPolicyWarrantyAndClause> prepareWPolWCListForInsert(JSONArray setRows) throws JSONException{
		List<GIPIWPolicyWarrantyAndClause> setWCRowList = new ArrayList<GIPIWPolicyWarrantyAndClause>();
		GIPIWPolicyWarrantyAndClause wc;
		
		for(int index=0; index<setRows.length(); index++){
			wc = new GIPIWPolicyWarrantyAndClause();
			
			wc.setPackParId(setRows.getJSONObject(index).isNull("packParId") ? null : setRows.getJSONObject(index).getInt("packParId"));
			wc.setParId(setRows.getJSONObject(index).isNull("parId") ? null : setRows.getJSONObject(index).getInt("parId"));
			wc.setLineCd(setRows.getJSONObject(index).isNull("lineCd") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("lineCd")));
			wc.setWcCd(setRows.getJSONObject(index).isNull("wcCd") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcCd")));
			wc.setSwcSeqNo(setRows.getJSONObject(index).isNull("swcSeqNo") ? 0 : setRows.getJSONObject(index).getInt("swcSeqNo"));
			wc.setPrintSeqNo(setRows.getJSONObject(index).isNull("printSeqNo") ? null : setRows.getJSONObject(index).getInt("printSeqNo"));
			wc.setWcTitle(setRows.getJSONObject(index).isNull("wcTitle") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcTitle")));
			wc.setWcTitle2(setRows.getJSONObject(index).isNull("wcTitle2") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcTitle2")));
			wc.setRecFlag(setRows.getJSONObject(index).isNull("recFlag") ? null : setRows.getJSONObject(index).getString("recFlag"));
			wc.setWcRemarks(setRows.getJSONObject(index).isNull("wcRemarks") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcRemarks")));
			wc.setPrintSw(setRows.getJSONObject(index).isNull("printSw") ? null : setRows.getJSONObject(index).getString("printSw"));
			wc.setChangeTag(setRows.getJSONObject(index).isNull("changeTag") ? null : setRows.getJSONObject(index).getString("changeTag"));
			
			if((wc.getChangeTag()).equals("Y")){
				wc.setWcText1(setRows.getJSONObject(index).isNull("wcText1") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcText1")));
				wc.setWcText2(setRows.getJSONObject(index).isNull("wcText2") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcText2")));
				wc.setWcText3(setRows.getJSONObject(index).isNull("wcText3") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcText3")));
				wc.setWcText4(setRows.getJSONObject(index).isNull("wcText4") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcText4")));
				wc.setWcText5(setRows.getJSONObject(index).isNull("wcText5") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcText5")));
				wc.setWcText6(setRows.getJSONObject(index).isNull("wcText6") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcText6")));
				wc.setWcText7(setRows.getJSONObject(index).isNull("wcText7") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcText7")));
				wc.setWcText8(setRows.getJSONObject(index).isNull("wcText8") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcText8")));
				wc.setWcText9(setRows.getJSONObject(index).isNull("wcText9") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcText9")));
			}
			
			setWCRowList.add(wc);
		}
		return setWCRowList;
	}
	
	private List<GIPIWPolicyWarrantyAndClause> prepareWPolWCListForDelete(JSONArray delRows) throws JSONException{
		List<GIPIWPolicyWarrantyAndClause> delWCRowList = new ArrayList<GIPIWPolicyWarrantyAndClause>();
		GIPIWPolicyWarrantyAndClause wc;
		for(int index=0; index<delRows.length(); index++){
			wc = new GIPIWPolicyWarrantyAndClause();
			
			wc.setPackParId(delRows.getJSONObject(index).isNull("packParId") ? null : delRows.getJSONObject(index).getInt("packParId"));
			wc.setParId(delRows.getJSONObject(index).isNull("parId") ? null : delRows.getJSONObject(index).getInt("parId"));
			wc.setLineCd(delRows.getJSONObject(index).isNull("lineCd") ? null : StringEscapeUtils.unescapeHtml(delRows.getJSONObject(index).getString("lineCd")));
			wc.setWcCd(delRows.getJSONObject(index).isNull("wcCd") ? null : StringEscapeUtils.unescapeHtml(delRows.getJSONObject(index).getString("wcCd")));
			
			delWCRowList.add(wc);
		}
		return delWCRowList;
	}

	@Override
	public boolean saveGIPIWPolWCTableGrid(Map<String, Object> parameters) //added by steven 4.30.201
			throws Exception {
		log.info("Saving GIPIWPolWC...");
		this.getGipiWPolicyWarrantyAndClauseDAO().saveGIPIWPolWCTableGrid(parameters);
		log.info("GIPIWPolWC Saved.");
		return true;
	}

	@Override
	public String validatePrintSeqNo(Map<String, Object> parameters)
			throws SQLException {
		return this.getGipiWPolicyWarrantyAndClauseDAO().validatePrintSeqNo(parameters);
	}

	@Override
	public String checkExistingRecord(Map<String, Object> parameters)
			throws SQLException {
		return this.getGipiWPolicyWarrantyAndClauseDAO().checkExistingRecord(parameters);
	}
}
