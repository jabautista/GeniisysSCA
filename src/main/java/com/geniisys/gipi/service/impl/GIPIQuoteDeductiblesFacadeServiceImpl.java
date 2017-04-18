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
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringEscapeUtils;
import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.common.entity.GIISDeductibleDesc;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.gipi.dao.GIPIQuoteDeductiblesDAO;
import com.geniisys.gipi.entity.GIPIQuoteDeductibles;
import com.geniisys.gipi.entity.GIPIQuoteDeductiblesSummary;
import com.geniisys.gipi.service.GIPIQuoteDeductiblesFacadeService;


/**
 * The Class GIPIQuoteDeductiblesFacadeServiceImpl.
 */
public class GIPIQuoteDeductiblesFacadeServiceImpl implements GIPIQuoteDeductiblesFacadeService{

	/** The gipi quote deductibles dao. */
	private GIPIQuoteDeductiblesDAO gipiQuoteDeductiblesDAO;
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteDeductiblesFacadeService#getGIPIQuoteDeductiblesSummaryList(int)
	 */
	public List<GIPIQuoteDeductiblesSummary> getGIPIQuoteDeductiblesSummaryList(
			int quoteId) throws SQLException {
		return gipiQuoteDeductiblesDAO.getGIPIQuoteDeductiblesSummaryList(quoteId);
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteDeductiblesFacadeService#deleteGIPIQuoteDeductibles(int)
	 */
	public void deleteGIPIQuoteDeductibles(int quoteId) throws SQLException {
		this.gipiQuoteDeductiblesDAO.deleteGIPIQuoteDeductibles(quoteId);		
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteDeductiblesFacadeService#saveGIPIQuoteDeductibles(java.util.Map)
	 */
	@Override
	public void saveGIPIQuoteDeductibles(Map<String, Object> params)
			throws SQLException {
		String[] itemNos		= (String[]) params.get("itemNos");
		String[] perilCds		= (String[]) params.get("perilCds");
		String[] deductibleCds	= (String[]) params.get("deductibleCds");
		String[] deductibleAmts	= (String[]) params.get("deductibleAmts");
		String[] deductibleRts	= (String[]) params.get("deductibleRts");
		String[] deductibleTexts	= (String[]) params.get("deductibleTexts");
		int quoteId = Integer.parseInt(params.get("quoteId").toString());
		GIISUser user = (GIISUser) params.get("userId");

		// delete all deductibles first before insert
		gipiQuoteDeductiblesDAO.deleteGIPIQuoteDeductibles(quoteId);
		
		if(params.get("saveTag").toString().equals("Y")){
			for(int i=0; i<itemNos.length; i++){
				this.gipiQuoteDeductiblesDAO.saveGIPIQuoteDeductibles(
					new GIPIQuoteDeductibles(
						quoteId,
						itemNos[i] == null ? 0 : Integer.parseInt(itemNos[i]),
						perilCds[i] == null ? 0 : Integer.parseInt(perilCds[i]),
						deductibleCds[i],
						(deductibleAmts[i] == null) ? new BigDecimal("0") : new BigDecimal(deductibleAmts[i].replaceAll(",", "")),
						(deductibleRts[i] == null) ? new BigDecimal("0") : new BigDecimal(deductibleRts[i].replaceAll(",", "")),
						deductibleTexts[i],
						user.getUserId(),
						new Date())
				);
			}
		}
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteDeductiblesFacadeService#saveGIPIQuoteDeductibles(com.geniisys.gipi.entity.GIPIQuoteDeductibles)
	 */
	public void saveGIPIQuoteDeductibles(GIPIQuoteDeductibles gipiQuoteDeductibles) throws SQLException	{
		this.gipiQuoteDeductiblesDAO.saveGIPIQuoteDeductibles(gipiQuoteDeductibles);
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteDeductiblesFacadeService#getDeductibleList(java.lang.String, java.lang.String)
	 */
	@Override
	public List<GIISDeductibleDesc> getDeductibleList(String lineCd,String sublineCd) throws SQLException {
		return gipiQuoteDeductiblesDAO.getDeductibleList(lineCd, sublineCd);
	}

	//getter and setter for gipiQuoteDeductiblesDAO
	/**
	 * Gets the gipi quote deductibles dao.
	 * @return the gipi quote deductibles dao
	 */
	public GIPIQuoteDeductiblesDAO getGipiQuoteDeductiblesDAO() {
		return gipiQuoteDeductiblesDAO;
	}

	/**
	 * Sets the gipi quote deductibles dao.
	 * @param gipiQuoteDeductiblesDAO the new gipi quote deductibles dao
	 */
	public void setGipiQuoteDeductiblesDAO(
			GIPIQuoteDeductiblesDAO gipiQuoteDeductiblesDAO) {
		this.gipiQuoteDeductiblesDAO = gipiQuoteDeductiblesDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteDeductiblesFacadeService#getDeductibleSum(int)
	 */
	@Override
	public GIPIQuoteDeductibles getDeductibleSum(int quoteId) throws SQLException {
		return this.getGipiQuoteDeductiblesDAO().getDeductibleSum(quoteId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteDeductiblesFacadeService#getItemDeductibles(int)
	 */
	@Override
	public List<GIPIQuoteDeductibles> getItemDeductibles(int quoteId)
			throws SQLException {
		return this.getGipiQuoteDeductiblesDAO().getItemDeductibles(quoteId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteDeductiblesFacadeService#prepareGIPIQuoteDeductiblesSummaryJSON(org.json.JSONArray, java.util.Map)
	 */
	@Override
	public List<GIPIQuoteDeductiblesSummary> prepareGIPIQuoteDeductiblesSummaryJSON(
			JSONArray rows, GIISUser USER)
			throws JSONException {
		List<GIPIQuoteDeductiblesSummary> deductiblesSummaries = new ArrayList<GIPIQuoteDeductiblesSummary>();
		GIPIQuoteDeductiblesSummary deductiblesSummary = null;
		
		
		for(int index = 0; index < rows.length(); index++){
			deductiblesSummary = new GIPIQuoteDeductiblesSummary();
			deductiblesSummary.setUserId(USER.getUserId());
			deductiblesSummary.setQuoteId(rows.getJSONObject(index).isNull("quoteId")? 0 :rows.getJSONObject(index).getInt("quoteId"));
			deductiblesSummary.setItemNo(rows.getJSONObject(index).isNull("itemNo")? 0 :rows.getJSONObject(index).getInt("itemNo"));
			deductiblesSummary.setPerilCd(rows.getJSONObject(index).isNull("perilCd")? 0 :rows.getJSONObject(index).getInt("perilCd"));
			deductiblesSummary.setDedDeductibleCd(rows.getJSONObject(index).isNull("dedDeductibleCd")? "" : StringEscapeUtils.unescapeHtml(rows.getJSONObject(index).getString("dedDeductibleCd")).replaceAll("slash", "/"));
			//deductiblesSummary.setDeductibleAmt(rows.getJSONObject(index).isNull("deductibleAmt")? new BigDecimal(0) : new BigDecimal(rows.getJSONObject(index).getDouble("deductibleAmt")));
			deductiblesSummary.setDeductibleAmt(JSONUtil.getBigDecimal(rows, index, "deductibleAmt"));
			deductiblesSummary.setDeductibleRate(rows.getJSONObject(index).isNull("deductibleRate")? null : new BigDecimal(rows.getJSONObject(index).getDouble("deductibleRate")));
			deductiblesSummary.setDeductibleText(rows.getJSONObject(index).isNull("deductibleText")? "" : StringEscapeUtils.unescapeHtml(rows.getJSONObject(index).getString("deductibleText")));
			deductiblesSummary.setLastUpdate(new Date());
			deductiblesSummaries.add(deductiblesSummary);
		}
		return deductiblesSummaries;
	}

	@Override
	public List<GIPIQuoteDeductiblesSummary> getGIPIQuoteDeductiblesForPackList(
			Integer packQuoteId) throws SQLException {
		return this.gipiQuoteDeductiblesDAO.getGIPIQuoteDeductiblesForPackList(packQuoteId);
	}
	
	//nieko 02162016 UW-SPECS-2015-086 Quotation Deductibles
	@Override
	public void saveGIPIQuoteDeductibles2(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		System.out.println("TEST:::::: s" + new JSONArray(request.getParameter("setRows")));
		System.out.println("TEST:::::: d" + new JSONArray(request.getParameter("delRows")));
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIPIQuoteDeductibles.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIPIQuoteDeductibles.class));
		params.put("appUser", userId);
		System.out.println("DAOOOO" + params);
		this.gipiQuoteDeductiblesDAO.saveGIPIQuoteDeductibles2(params);
	}

	@Override
	public String checkQuoteDeductible(int globalQuoteId, String deductibleType, int deductibleLevel, int itemNo)
			throws SQLException {
		
		String result;
		
		result = this.gipiQuoteDeductiblesDAO.checkQuoteDeductible(globalQuoteId, deductibleType, deductibleLevel, itemNo);
		
		return result;
	}

	@Override
	public List<LOV> getQuotePerilList(int quoteId) throws SQLException {

		List<LOV> result = null;
		
		result = this.gipiQuoteDeductiblesDAO.getQuotePerilList(quoteId);
		
		return result;
	}
	//nieko 02162016 UW-SPECS-2015-086 Quotation Deductibles end
}