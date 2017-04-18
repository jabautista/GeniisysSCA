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

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringEscapeUtils;
import org.jfree.util.Log;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.gipi.dao.GIPIQuoteWarrantyAndClauseDAO;
import com.geniisys.gipi.entity.GIPIQuoteWarrantyAndClause;
import com.geniisys.gipi.service.GIPIQuoteWarrantyAndClauseFacadeService;


/**
 * The Class GIPIQuoteWarrantyAndClauseFacadeServiceImpl.
 */
public class GIPIQuoteWarrantyAndClauseFacadeServiceImpl implements GIPIQuoteWarrantyAndClauseFacadeService {

	/** The Constant MAX_NO_OF_RECORD_PER_PAGE. */
	public static final int MAX_NO_OF_RECORD_PER_PAGE = 5;
	
	/** The gipi quote warranty and clause dao. */
	private GIPIQuoteWarrantyAndClauseDAO gipiQuoteWarrantyAndClauseDAO;

	/**
	 * Gets the gipi quote warranty and clause dao.
	 * 
	 * @return the gipi quote warranty and clause dao
	 */
	public GIPIQuoteWarrantyAndClauseDAO getGipiQuoteWarrantyAndClauseDAO() {
		return gipiQuoteWarrantyAndClauseDAO;
	}

	/**
	 * Sets the gipi quote warranty and clause dao.
	 * 
	 * @param gipiQuoteWarrantyAndClauseDAO the new gipi quote warranty and clause dao
	 */
	public void setGipiQuoteWarrantyAndClauseDAO(
			GIPIQuoteWarrantyAndClauseDAO gipiQuoteWarrantyAndClauseDAO) {
		this.gipiQuoteWarrantyAndClauseDAO = gipiQuoteWarrantyAndClauseDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteWarrantyAndClauseFacadeService#getGIPIQuoteWarrantyAndClauses(int)
	 */
	@Override
	public List<GIPIQuoteWarrantyAndClause> getGIPIQuoteWarrantyAndClauses(int quoteId) throws SQLException {
		//List<GIPIQuoteWarrantyAndClause> wcList = this.getGipiQuoteWarrantyAndClauseDAO().getGIPIQuoteWarrantyAndClauses(quoteId);  
		//PaginatedList list = new PaginatedList(wcList, MAX_NO_OF_RECORD_PER_PAGE);
		return this.getGipiQuoteWarrantyAndClauseDAO().getGIPIQuoteWarrantyAndClauses(quoteId);//list;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteWarrantyAndClauseFacadeService#saveWC(java.util.Map)
	 */
	@Override
	public void saveWC(Map<String, Object> parameters) throws SQLException {
		String[] wcCds = (String[]) parameters.get("wcCds");
		String[] printSeqNos = (String[]) parameters.get("printSeqNos");
		String[] wcTitles = (String[]) parameters.get("wcTitles");
		String[] wcTexts = (String[]) parameters.get("wcTexts");
		String[] printSws = (String[]) parameters.get("printSws");
		String[] changeTags = (String[]) parameters.get("changeTags");
		String[] wcTitles2 = (String[]) parameters.get("wcTitles2");
		@SuppressWarnings("unused")
		String[] swcSeqNos = (String[]) parameters.get("swcSeqNos");
		Integer quoteId = (Integer) parameters.get("quoteId");
		String lineCd = (String) parameters.get("lineCd");
		String userId = (String) parameters.get("userId");
		GIPIQuoteWarrantyAndClause wc = null;
		for (int i = 0; i < wcTexts.length; i++) {
			System.out.println("by Steven: "+ wcTexts[i]);
		}
		for (int i=0; i<wcCds.length; i++)	{
			 wc = new GIPIQuoteWarrantyAndClause(
					quoteId,
					lineCd,
					wcCds[i],
					printSeqNos[i] == "" ? 0 : Integer.parseInt(printSeqNos[i]),
					wcTitles[i],
					wcTexts[i].replaceAll("\"", "&quot;"),
					printSws[i],
					changeTags[i],
					userId,
					wcTitles2[i].replaceAll("\"", "&quot;"),
			 		//swcSeqNos[i] == null ? 0 : Integer.parseInt(swcSeqNos[i]));
					0);
			this.getGipiQuoteWarrantyAndClauseDAO().saveWC(wc);
		}
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteWarrantyAndClauseFacadeService#deleteWC(int)
	 */
	@Override
	public void deleteWC(int quoteId) throws SQLException {
		this.getGipiQuoteWarrantyAndClauseDAO().deleteWC(quoteId);
	}

	@Override
	public void attachWarranty(int quoteId, String lineCd, int perilCd)
			throws SQLException {
		this.getGipiQuoteWarrantyAndClauseDAO().attachWarranty(quoteId, lineCd, perilCd);
	}

	@Override
	public String checkQuotePerilDefaultWarranty(Integer quoteId,
			String lineCd, Integer perilCd) throws SQLException {
		return this.getGipiQuoteWarrantyAndClauseDAO().checkQuotePerilDefaultWarranty(quoteId, lineCd, perilCd);
	}

	@Override
	public List<GIPIQuoteWarrantyAndClause> getPackQuotationWarrantiesAndClauses(
			Integer packQuoteId) throws SQLException {
		return this.getGipiQuoteWarrantyAndClauseDAO().getPackQuotationWarrantiesAndClauses(packQuoteId);
	}

	@Override
	public void savePackQuotationWarrantiesAndClauses(JSONArray setRows,
			JSONArray delRows, String userId) throws SQLException, JSONException {
		List<GIPIQuoteWarrantyAndClause> setQuoteWCList = this.prepareQuoteWarrAndClauseForInsert(setRows);
		List<GIPIQuoteWarrantyAndClause> delQuoteWCList = this.prepareQuoteWarrAndClauseForDelete(delRows);
		this.getGipiQuoteWarrantyAndClauseDAO().savePackQuotationWarrantiesAndClauses(setQuoteWCList, delQuoteWCList, userId);
	}
	
	private List<GIPIQuoteWarrantyAndClause> prepareQuoteWarrAndClauseForInsert(JSONArray setRows) throws JSONException{
		List<GIPIQuoteWarrantyAndClause> setQuoteWCList = new ArrayList<GIPIQuoteWarrantyAndClause>();
		GIPIQuoteWarrantyAndClause quoteWC;
		for(int index=0; index<setRows.length(); index++){
			quoteWC = new GIPIQuoteWarrantyAndClause();
			quoteWC.setQuoteId(setRows.getJSONObject(index).isNull("quoteId") ? null : setRows.getJSONObject(index).getInt("quoteId"));
			quoteWC.setLineCd(setRows.getJSONObject(index).isNull("lineCd") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("lineCd")));
			quoteWC.setWcCd(setRows.getJSONObject(index).isNull("wcCd") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcCd")));
			quoteWC.setSwcSeqNo(setRows.getJSONObject(index).isNull("swcSeqNo") ? 0 : setRows.getJSONObject(index).getInt("swcSeqNo"));
			quoteWC.setPrintSeqNo(setRows.getJSONObject(index).isNull("printSeqNo") ? null : setRows.getJSONObject(index).getInt("printSeqNo"));
			quoteWC.setWcTitle(setRows.getJSONObject(index).isNull("wcTitle") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcTitle")));
			quoteWC.setWcTitle2(setRows.getJSONObject(index).isNull("wcTitle2") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcTitle2")));
			quoteWC.setWcRemarks(setRows.getJSONObject(index).isNull("wcRemarks") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcRemarks")));
			quoteWC.setPrintSw(setRows.getJSONObject(index).isNull("printSw") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("printSw")));
			quoteWC.setChangeTag(setRows.getJSONObject(index).isNull("changeTag") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("changeTag")));
			
			if((quoteWC.getChangeTag()).equals("Y")){
				quoteWC.setWcText(setRows.getJSONObject(index).isNull("wcText") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcText")));
				quoteWC.setWcText1(setRows.getJSONObject(index).isNull("wcText1") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcText1")));
				quoteWC.setWcText2(setRows.getJSONObject(index).isNull("wcText2") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcText2")));
				quoteWC.setWcText3(setRows.getJSONObject(index).isNull("wcText3") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcText3")));
				quoteWC.setWcText4(setRows.getJSONObject(index).isNull("wcText4") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcText4")));
				quoteWC.setWcText5(setRows.getJSONObject(index).isNull("wcText5") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcText5")));
				quoteWC.setWcText6(setRows.getJSONObject(index).isNull("wcText6") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcText6")));
				quoteWC.setWcText7(setRows.getJSONObject(index).isNull("wcText7") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcText7")));
				quoteWC.setWcText8(setRows.getJSONObject(index).isNull("wcText8") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcText8")));
				quoteWC.setWcText9(setRows.getJSONObject(index).isNull("wcText9") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcText9")));
				quoteWC.setWcText10(setRows.getJSONObject(index).isNull("wcText10") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcText10")));
				quoteWC.setWcText11(setRows.getJSONObject(index).isNull("wcText11") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcText11")));
				quoteWC.setWcText12(setRows.getJSONObject(index).isNull("wcText12") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcText12")));
				quoteWC.setWcText13(setRows.getJSONObject(index).isNull("wcText13") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcText13")));
				quoteWC.setWcText14(setRows.getJSONObject(index).isNull("wcText14") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcText14")));
				quoteWC.setWcText15(setRows.getJSONObject(index).isNull("wcText15") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcText15")));
				quoteWC.setWcText16(setRows.getJSONObject(index).isNull("wcText16") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcText16")));
				quoteWC.setWcText17(setRows.getJSONObject(index).isNull("wcText17") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcText17")));
			}
			
			setQuoteWCList.add(quoteWC);
		}
		return setQuoteWCList;
	}
	
	private List<GIPIQuoteWarrantyAndClause> prepareQuoteWarrAndClauseForDelete(JSONArray delRows) throws JSONException{
		List<GIPIQuoteWarrantyAndClause> delQuoteWCList = new ArrayList<GIPIQuoteWarrantyAndClause>();
		GIPIQuoteWarrantyAndClause quoteWC;
		
		for(int index=0; index<delRows.length(); index++){
			quoteWC = new GIPIQuoteWarrantyAndClause();
			quoteWC.setQuoteId(delRows.getJSONObject(index).isNull("quoteId") ? null : delRows.getJSONObject(index).getInt("quoteId"));
			quoteWC.setLineCd(delRows.getJSONObject(index).isNull("lineCd") ? null : delRows.getJSONObject(index).getString("lineCd"));
			quoteWC.setWcCd(delRows.getJSONObject(index).isNull("wcCd") ? null : delRows.getJSONObject(index).getString("wcCd"));
			delQuoteWCList.add(quoteWC);
		}
		return delQuoteWCList;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveGIPIQuoteWc(HttpServletRequest request, String userId)
			throws SQLException, JSONException { // Udel - 03262012 - Added new method for saving (implemented with JSON and tableGrid)
		JSONObject paramsObj = new JSONObject(request.getParameter("parameters"));
		Map<String, List<GIPIQuoteWarrantyAndClause>> params = new HashMap<String, List<GIPIQuoteWarrantyAndClause>>();
		Log.info("Preparing records for saving...");
		params.put("setQuoteWarrCla", (List<GIPIQuoteWarrantyAndClause>) JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("setObjQuoteWarrCla")), userId, GIPIQuoteWarrantyAndClause.class));
		params.put("delQuoteWarrCla", (List<GIPIQuoteWarrantyAndClause>) JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("delObjQuoteWarrCla")), userId, GIPIQuoteWarrantyAndClause.class));
		Log.info("Finished preparing records.");
		this.gipiQuoteWarrantyAndClauseDAO.saveGIPIQuoteWc(params);
	}

	@Override
	public String validatePrintSeqNo(Map<String, Object> parameters)
			throws SQLException {
		return this.getGipiQuoteWarrantyAndClauseDAO().validatePrintSeqNo(parameters);
	}
}
