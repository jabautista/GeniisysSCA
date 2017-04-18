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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.gipi.dao.GIPIQuoteMortgageeDAO;
import com.geniisys.gipi.entity.GIPIQuote;
import com.geniisys.gipi.entity.GIPIQuoteMortgagee;
import com.geniisys.gipi.service.GIPIQuoteMortgageeFacadeService;


/**
 * The Class GIPIQuoteMortgageeFacadeServiceImpl.
 */
public class GIPIQuoteMortgageeFacadeServiceImpl implements GIPIQuoteMortgageeFacadeService{

	private static Logger log = Logger.getLogger(GIPIQuoteMortgageeFacadeServiceImpl.class);
	/** The gipi quote mortgagee dao. */
	private GIPIQuoteMortgageeDAO gipiQuoteMortgageeDao;

	/**
	 * Gets the gipi quote mortgagee dao.
	 * 
	 * @return the gipi quote mortgagee dao
	 */
	public GIPIQuoteMortgageeDAO getGipiQuoteMortgageeDao() {
		return gipiQuoteMortgageeDao;
	}

	/**
	 * Sets the gipi quote mortgagee dao.
	 * 
	 * @param gipiQuoteMortgageeDao the new gipi quote mortgagee dao
	 */
	public void setGipiQuoteMortgageeDao(GIPIQuoteMortgageeDAO gipiQuoteMortgageeDao) {
		this.gipiQuoteMortgageeDao = gipiQuoteMortgageeDao;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteMortgageeFacadeService#getGIPIQuoteMortgagee(Integer)
	 */
	@Override
	public List<GIPIQuoteMortgagee> getGIPIQuoteMortgagee(Integer quoteId)
			throws SQLException {
		return this.getGipiQuoteMortgageeDao().getGIPIQuoteMortgagee(quoteId);
	}
	
	public List<GIPIQuoteMortgagee> getGIPIQuoteLevelMortgagee(Integer quoteId)
	throws SQLException {
		return this.getGipiQuoteMortgageeDao().getGIPIQuoteLevelMortgagee(quoteId);
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteMortgageeFacadeService#saveGIPIQuoteMortgagee(java.util.Map)
	 */
	@Override
	public void saveGIPIQuoteMortgagee(Map<String, Object> params)
			throws SQLException {
		log.info("saveGIPIQuoteMortgagee");	
		String[] itemNos = (String[]) params.get("itemNos");
		String[] mortgCds = (String[]) params.get("mortgCds");
		String[] amounts = (String[]) params.get("amounts");
		GIPIQuote gipiQuote = (GIPIQuote) params.get("gipiQuote");
		int quoteId = Integer.parseInt(params.get("quoteId").toString());
		String qLevel = params.get("qLevel").equals(null) ? "" :(String) params.get("qLevel");
		
		// delete quote level mortgagee
		if(qLevel.equals("Y")){
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("issCd", gipiQuote.getIssCd());
			map.put("itemNo", 0);
			this.deleteGIPIQuoteMortgagee(quoteId, map);
		}
		
		// save all the mortgagees
		if(itemNos != null && itemNos.length != 0){
			
			if(qLevel.equals("Y")){ // added for quotation level mortgagee. To handle the null amount of mortagee. It will use saveGIPIQuoteMortgagee that accepts MAP parameter. -irwin
				Map<String, Object>mortParam = new HashMap<String, Object>();
				for (int i=0; i<itemNos.length; i++)	{	
					mortParam.put("quoteId", quoteId);
					mortParam.put("issCd", gipiQuote.getIssCd());
					mortParam.put("itemNo",itemNos[i]);
					mortParam.put("mortgCd", mortgCds[i]);
					mortParam.put("amount", amounts[i].replaceAll(",", ""));
					mortParam.put("userId", params.get("userId").toString());
					this.getGipiQuoteMortgageeDao().saveGIPIQuoteMortgagee(mortParam);
				}
			}else{
				for (int i=0; i<itemNos.length; i++)	{			
					this.getGipiQuoteMortgageeDao().saveGIPIQuoteMortgagee(
						new GIPIQuoteMortgagee(quoteId, 
							gipiQuote.getIssCd(), 
							Integer.parseInt(itemNos[i]), 
							mortgCds[i], 
							new BigDecimal(amounts[i].replaceAll(",", "")), 
							params.get("userId").toString()));
				}
			}	
		}
	
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteMortgageeFacadeService#saveGIPIQuoteMortgagee(com.geniisys.gipi.entity.GIPIQuoteMortgagee)
	 */
	public void saveGIPIQuoteMortgagee(GIPIQuoteMortgagee mortgagee) throws SQLException{
		this.gipiQuoteMortgageeDao.saveGIPIQuoteMortgagee(mortgagee);
	}

	/** UNUSED
	 * Prepare mortgagees for saving
	 * - the remarks property contains insert/delete
	 * @param request
	 * @param gipiQuote
	 * @return List of Mortgagee actions/objects
	 */
	public Map<String, Object> prepareMortgageesForUpdate(HttpServletRequest request, GIPIQuote gipiQuote){
		Map<String, Object> params = new HashMap<String, Object>();
		
		List<GIPIQuoteMortgagee> insertMortgageeList = new ArrayList<GIPIQuoteMortgagee>();
		List<GIPIQuoteMortgagee> deleteMortageeList  = new ArrayList<GIPIQuoteMortgagee>();
		String[] mortgageeCds 		= request.getParameterValues("dbMortgageeCodes");
		String[] mortgageeAmounts	= request.getParameterValues("dbMortgageeAmounts");
		String[] mortgageeItemNos	= request.getParameterValues("dbMortgageeItemNumbers");
		String[] mortgageeAction 	= request.getParameterValues("dbMortgageeAction");

		if(mortgageeCds != null){
			GIPIQuoteMortgagee mortgagee = null;
			for(int i = 0; i < mortgageeCds.length; i++){
				mortgagee = new GIPIQuoteMortgagee(
						gipiQuote.getQuoteId(),
						gipiQuote.getIssCd(),
						Integer.parseInt(mortgageeItemNos[i]),
						mortgageeCds[i],
						new BigDecimal(mortgageeAmounts[i]),
						gipiQuote.getUserId());

				// store the action in remarks property: insert/delete
				if(mortgageeAction[i].equals("insert")){
					insertMortgageeList.add(mortgagee);
				}else if(mortgageeAction[i].equals("delete")){
					deleteMortageeList.add(mortgagee);
				}
			}
		}
		params.put("insertMortgageeParams", insertMortgageeList);
		params.put("deleteMortgageeParams", deleteMortageeList);
		
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteMortgageeFacadeService#prepareMortgageeInformationJSON(org.json.JSONArray)
	 */
	@Override
	public List<GIPIQuoteMortgagee> prepareMortgageeInformationJSON(JSONArray rows, GIISUser USER) throws JSONException {
		List<GIPIQuoteMortgagee> mortList = new ArrayList<GIPIQuoteMortgagee>();
		GIPIQuoteMortgagee mortgagee = null;
		for(int index=0; index<rows.length(); index++){
			mortgagee = new GIPIQuoteMortgagee();
			
			mortgagee.setQuoteId(JSONUtil.getInteger(rows, index, "quoteId"));
			mortgagee.setIssCd(StringEscapeUtils.unescapeHtml(JSONUtil.getString(rows, index, "issCd")));
			mortgagee.setItemNo(JSONUtil.getInteger(rows, index, "itemNo"));
			mortgagee.setMortgCd(StringEscapeUtils.unescapeHtml(JSONUtil.getString(rows, index, "mortgCd")));
			mortgagee.setAmount(JSONUtil.getBigDecimal(rows, index, "amount"));
			
			mortgagee.setUserId(USER.getUserId());
			mortList.add(mortgagee);
		}
		return mortList;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteMortgageeFacadeService#getPackQuotationsMortgagee(java.lang.Integer)
	 */
	@Override
	public List<GIPIQuoteMortgagee> getPackQuotationsMortgagee(
			Integer packQuoteId) throws SQLException {
		return this.gipiQuoteMortgageeDao.getPackQuotationsMortgagee(packQuoteId);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteMortgageeFacadeService#savePackQuotationMortgagee(java.util.Map)
	 */
	public void savePackQuotationMortgagee(Map<String, Object> params) throws SQLException{
		this.gipiQuoteMortgageeDao.savePackQuotationMortgagee(params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteMortgageeFacadeService#deleteAllGIPIQuoteMortgagees(java.lang.Integer, java.lang.String)
	 */
	@Override
	public void deleteAllGIPIQuoteMortgagees(Integer quoteId, String issCd)
			throws SQLException {
		this.gipiQuoteMortgageeDao.deleteAllGIPIQuoteMortgagee(quoteId, issCd);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteMortgageeFacadeService#deleteGIPIQuoteMortgagee(Integer, Integer)
	 */
	@Override
	public void deleteGIPIQuoteMortgagee(Integer quoteId, Integer itemNo, String issCd, String mortgCd)
			throws SQLException {
		this.getGipiQuoteMortgageeDao().deleteGIPIQuoteMortgagee(quoteId, itemNo, issCd, mortgCd);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteMortgageeFacadeService#deleteGIPIQuoteMortgagee(java.lang.Integer, java.util.Map)
	 */
	@Override
	public void deleteGIPIQuoteMortgagee(Integer quoteId, Map<String, Object> params) 
			throws SQLException {
		this.getGipiQuoteMortgageeDao().deleteGIPIQuoteMortgagee(quoteId, params);
	}
}