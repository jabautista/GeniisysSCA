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
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.gipi.dao.GIPIQuoteItemDAO;
import com.geniisys.gipi.entity.GIPIQuoteItem;
import com.geniisys.gipi.service.GIPIQuoteItemFacadeService;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIQuoteItemFacadeServiceImpl.
 */
public class GIPIQuoteItemFacadeServiceImpl implements GIPIQuoteItemFacadeService {

	/** The gipi quote item dao. */
	private GIPIQuoteItemDAO gipiQuoteItemDAO;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIQuoteItemFacadeServiceImpl.class);
	
	/** The MA x_ coun t_ pe r_ page. */
	private final int MAX_COUNT_PER_PAGE = 5;
	
	/**
	 * Instantiates a new gIPI quote item facade service impl.
	 */
	public GIPIQuoteItemFacadeServiceImpl(){
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemFacadeService#deleteQuoteItem(int, int)
	 */
	@Override
	public boolean deleteQuoteItem(int quoteId, int itemNo) {
		log.info("Service deleting Quote Item Params:("+quoteId+","+itemNo+")");
		try {
			gipiQuoteItemDAO.delGIPIQuoteItem(quoteId, itemNo);
			return true;
		} catch (SQLException e) {
			log.error("Exception caught. " + e.getMessage());
			log.debug(Arrays.toString(e.getStackTrace()));
			return false;
		}
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemFacadeService#getQuoteItemList(int)
	 */
	@Override
	public List<GIPIQuoteItem> getQuoteItemList(int quoteId, String lineCd) {
		log.info("Service getting Quote Item List Params:("+quoteId+")");
		List<GIPIQuoteItem> list = null;
		try {
			list = gipiQuoteItemDAO.getGIPIQuoteItemList(quoteId, lineCd);
		} catch (SQLException e) {
			log.error("Exception caught. " + e.getMessage());
			log.debug(Arrays.toString(e.getStackTrace()));
		}
		return list;
	}
	
	@SuppressWarnings("unchecked")
	public List<GIPIQuoteItem> getQuoteItemList(int quoteId) {
		log.info("Service getting Quote Item List Params:("+quoteId+")");
		List<GIPIQuoteItem> list = null;
		try {
			list = (List<GIPIQuoteItem>) StringFormatter.replaceQuotesInList(gipiQuoteItemDAO.getGIPIQuoteItemList(quoteId));
		} catch (SQLException e) {
			log.error("Exception caught. " + e.getMessage());
			log.debug(Arrays.toString(e.getStackTrace()));
		}
		return list;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemFacadeService#saveQuoteItem(com.geniisys.gipi.entity.GIPIQuoteItem)
	 */
	@Override
	public boolean saveQuoteItem(GIPIQuoteItem quoteItem) {
		log.info("Service saving Quote Item Params:(quoteItem)");
		try {
			gipiQuoteItemDAO.setGIPIQuoteItem(quoteItem);
			return true;
		} catch (SQLException e) {
			log.error("Exception caught. " + e.getMessage());
			log.debug(Arrays.toString(e.getStackTrace()));
			return false;
		}
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemFacadeService#getPaginatedQuoteItemList(java.lang.Integer, int)
	 */
	@Override
	@SuppressWarnings("deprecation")
	public PaginatedList getPaginatedQuoteItemList(Integer pageNo, int quoteId) {
		log.info("Service getting Page "+ pageNo.intValue()+" Quote Item List Params:("+quoteId+")");
		PaginatedList paginatedList = null;
		try {
			List<GIPIQuoteItem> list = gipiQuoteItemDAO.getGIPIQuoteItemList(quoteId);
			paginatedList = new PaginatedList(list,MAX_COUNT_PER_PAGE);
			paginatedList.gotoPage(pageNo);
		} catch (SQLException e) {
			log.error("Exception caught. " + e.getMessage());
			log.debug(Arrays.toString(e.getStackTrace()));
		}		
		return paginatedList;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemFacadeService#getPaginatedQuoteItemList(java.lang.Integer, java.util.List)
	 */
	@Override
	@SuppressWarnings("deprecation")
	public PaginatedList getPaginatedQuoteItemList(Integer pageNo, List<GIPIQuoteItem> list) {
		log.info("Service getting Page "+ pageNo.intValue()+" from Quote Item List...");
		PaginatedList paginatedList = new PaginatedList(list,MAX_COUNT_PER_PAGE);
		paginatedList.gotoPage(pageNo);				
		return paginatedList;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemFacadeService#getLastPage(java.util.List)
	 */
	@Override
	public int getLastPage(List<GIPIQuoteItem> list) {
		if (null!=list){
			double div = list.size()/MAX_COUNT_PER_PAGE;
			int page = Integer.valueOf(String.valueOf(div));
			double diff = div - page;
			if (0 == diff){
				return page;
			} else {
				return page +1;
			}			
		} else {
			return 0;
		}		
	}
	
	/**
	 * Gets the gipi quote item dao.
	 * @return the gipi quote item dao
	 */
	public GIPIQuoteItemDAO getGipiQuoteItemDAO() {
		return gipiQuoteItemDAO;
	}

	/**
	 * Sets the gipi quote item dao.
	 * 
	 * @param gipiQuoteItemDAO the new gipi quote item dao
	 */
	public void setGipiQuoteItemDAO(GIPIQuoteItemDAO gipiQuoteItemDAO) {
		this.gipiQuoteItemDAO = gipiQuoteItemDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemFacadeService#saveGIPIQuoteItem(com.geniisys.gipi.entity.GIPIQuoteItem)
	 */
	@Override // whofeih
	public void saveGIPIQuoteItem(GIPIQuoteItem quoteItem) throws SQLException {
		//this.gipiQuoteItemDAO.saveGIPIQuoteItem(quoteItem);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemFacadeService#deleteGIPIQuoteAllItems(int)
	 */
	@Override
	public void deleteGIPIQuoteAllItems(int quoteId) throws SQLException {
		this.gipiQuoteItemDAO.deleteGIPIQuoteAllItems(quoteId);
	}

	/**
	 * Updates the premium amt.
	 * 
	 * @param updates the premium amt
	 * @return none
	 */
	public void updateQuoteItemPremAmt(int quoteId, int itemNo, BigDecimal premAmt) throws SQLException {
		this.gipiQuoteItemDAO.updateQuoteItemPremAmt(quoteId, itemNo, premAmt);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemFacadeService#saveGIPIQuoteItem(java.util.Map)
	 */
	@Override
	public void saveGIPIQuoteItem(Map<String, Object> preparedParams)
			throws Exception {
		this.gipiQuoteItemDAO.saveGIPIQuoteItem(preparedParams);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemFacadeService#prepareGipiQuoteItemJSON(org.json.JSONArray, java.util.Map)
	 */
	@Override
	public List<GIPIQuoteItem> prepareGipiQuoteItemJSON(JSONArray rows,	GIISUser USER) 
			throws JSONException {
		List<GIPIQuoteItem> itemList = new ArrayList<GIPIQuoteItem>();
		GIPIQuoteItem quoteItem = null;
		for(int index=0; index<rows.length(); index++){
			quoteItem = new GIPIQuoteItem();
			quoteItem.setQuoteId(rows.getJSONObject(index).isNull("quoteId") ? 0 : rows.getJSONObject(index).getInt("quoteId"));
			quoteItem.setItemNo(rows.getJSONObject(index).isNull("itemNo") ? 0 : rows.getJSONObject(index).getInt("itemNo"));
			quoteItem.setItemTitle(rows.getJSONObject(index).isNull("itemTitle") ? "" : StringEscapeUtils.unescapeHtml(rows.getJSONObject(index).getString("itemTitle")));
			quoteItem.setItemDesc(rows.getJSONObject(index).isNull("itemDesc") ? "" : StringEscapeUtils.unescapeHtml(rows.getJSONObject(index).getString("itemDesc")));
			quoteItem.setItemDesc2(rows.getJSONObject(index).isNull("itemDesc2") ? "" : StringEscapeUtils.unescapeHtml(rows.getJSONObject(index).getString("itemDesc2")));
			quoteItem.setCurrencyCd(rows.getJSONObject(index).isNull("currencyCd") ? 0 : rows.getJSONObject(index).getInt("currencyCd"));
			quoteItem.setCurrencyDesc(rows.getJSONObject(index).isNull("currencyDesc") ? "" : StringEscapeUtils.unescapeHtml(rows.getJSONObject(index).getString("currencyDesc")));
			quoteItem.setCurrencyRate(rows.getJSONObject(index).isNull("currencyRate") ? null  : new BigDecimal(rows.getJSONObject(index).getDouble("currencyRate")));
			quoteItem.setCoverageCd(JSONUtil.getInteger(rows, index, "coverageCd"));
//			if(!rows.getJSONObject(index).isNull("coverageCd")) quoteItem.setCoverageCd(rows.getJSONObject(index).getInt("coverageCd"));
			
			quoteItem.setUserId(StringEscapeUtils.unescapeHtml(USER.getUserId()));
			itemList.add(quoteItem);
		}
		return itemList;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemFacadeService#saveQuotationInformation(java.util.Map)
	 */
	@Override
	public void saveQuotationInformation(
			Map<String, Object> quotationInformation) throws Exception {
		gipiQuoteItemDAO.saveGIPIQuoteItemJSON(quotationInformation);
	}

	@Override
	public List<GIPIQuoteItem> getGIPIQuoteItemListForPack(Integer packQuoteId)
			throws SQLException {
		return this.getGipiQuoteItemDAO().getGIPIQuoteItemListForPack(packQuoteId);
	}

	@Override
	public void saveGIPIQuoteItemForPackQuotation(Map<String, Object> listParams)
			throws SQLException, Exception {
		this.getGipiQuoteItemDAO().saveGIPIQuoteItemForPackQuotation(listParams);
	}
}