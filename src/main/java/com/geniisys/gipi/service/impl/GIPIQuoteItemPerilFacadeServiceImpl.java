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
import java.util.Date;
import java.util.List;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.gipi.dao.GIPIQuoteItemPerilDAO;
import com.geniisys.gipi.entity.GIPIQuoteItemPeril;
import com.geniisys.gipi.entity.GIPIQuoteItemPerilSummary;
import com.geniisys.gipi.service.GIPIQuoteItemPerilFacadeService;


/**
 * The Class GIPIQuoteItemPerilFacadeServiceImpl.
 */
public class GIPIQuoteItemPerilFacadeServiceImpl implements GIPIQuoteItemPerilFacadeService {

	/** The gipi quote item peril dao. */
	private GIPIQuoteItemPerilDAO gipiQuoteItemPerilDAO;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIQuoteItemPerilFacadeServiceImpl.class);
	
	/** The MA x_ coun t_ pe r_ page. */
	private final int MAX_COUNT_PER_PAGE = 5;
	
	/**
	 * Instantiates a new gIPI quote item peril facade service impl.
	 */
	public GIPIQuoteItemPerilFacadeServiceImpl(){
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemPerilFacadeService#deleteQuoteItemPeril(int, int, int)
	 */
	@Override
	public boolean deleteQuoteItemPeril(int quoteId, int itemNo, int perilCd) {
		log.info("Service deleting Quote Item Peril Params:("+quoteId+","+itemNo+","+perilCd+")");
		try {
			gipiQuoteItemPerilDAO.delGIPIQuoteItemPeril(quoteId, itemNo, perilCd);
			return true;
		} catch (SQLException e) {
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			log.debug(Arrays.toString(e.getStackTrace()));
			return false;
		}
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemPerilFacadeService#getQuoteItemPerilSummaryList(int)
	 */
	@Override
	public List<GIPIQuoteItemPerilSummary> getQuoteItemPerilSummaryList(int quoteId) {
		log.info("Service getting Quote Item Peril Summary List Params:("+quoteId+")");
		List<GIPIQuoteItemPerilSummary> list = null;
		try {
			list = gipiQuoteItemPerilDAO.getGIPIQuoteItemPerilSummaryList(quoteId);
		} catch (SQLException e) {
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			log.debug(Arrays.toString(e.getStackTrace()));
		}
		return list;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemPerilFacadeService#saveQuoteItemPeril(com.geniisys.gipi.entity.GIPIQuoteItemPeril)
	 */
	@Override
	public boolean saveQuoteItemPeril(GIPIQuoteItemPeril quoteItemPeril) {
		log.info("Service saving Quote Item Peril Params:(quoteItemPeril)");
		try {
			gipiQuoteItemPerilDAO.setGIPIQuoteItemPeril(quoteItemPeril);
			return true;
		} catch (SQLException e) {
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			log.debug(Arrays.toString(e.getStackTrace()));
			return false;
		}
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemPerilFacadeService#getPaginatedQuoteItemPerilSummaryList(java.lang.Integer, int)
	 */
	@Override
	@SuppressWarnings("deprecation")
	public PaginatedList getPaginatedQuoteItemPerilSummaryList(Integer pageNo,	int quoteId) {
		log.info("Service getting Page "+ pageNo.intValue()+" Quote Item List Params:("+quoteId+")");
		PaginatedList paginatedList = null;
		try {
			List<GIPIQuoteItemPerilSummary> list = gipiQuoteItemPerilDAO.getGIPIQuoteItemPerilSummaryList(quoteId);
			paginatedList = new PaginatedList(list,MAX_COUNT_PER_PAGE);
			paginatedList.gotoPage(pageNo);
		} catch (SQLException e) {
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			log.debug(Arrays.toString(e.getStackTrace()));
		}		
		return paginatedList;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemPerilFacadeService#getPaginatedQuoteItemPerilSummaryList(java.lang.Integer, java.util.List)
	 */
	@Override
	@SuppressWarnings("deprecation")
	public PaginatedList getPaginatedQuoteItemPerilSummaryList(Integer pageNo, List<GIPIQuoteItemPerilSummary> list) {
		log.info("Service getting Page "+ pageNo.intValue()+" from Quote Item Peril List...");
		PaginatedList paginatedList = new PaginatedList(list,5);
		paginatedList.gotoPage(pageNo);				
		return paginatedList;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemPerilFacadeService#getLastPage(java.util.List)
	 */
	@Override
	public int getLastPage(List<GIPIQuoteItemPerilSummary> list) {
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
	 * Gets the gipi quote item peril dao.
	 * 
	 * @return the gipi quote item peril dao
	 */
	public GIPIQuoteItemPerilDAO getGipiQuoteItemPerilDAO() {
		return gipiQuoteItemPerilDAO;
	}

	/**
	 * Sets the gipi quote item peril dao.
	 * 
	 * @param gipiQuoteItemPerilDAO the new gipi quote item peril dao
	 */
	public void setGipiQuoteItemPerilDAO(GIPIQuoteItemPerilDAO gipiQuoteItemPerilDAO) {
		this.gipiQuoteItemPerilDAO = gipiQuoteItemPerilDAO;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemPerilFacadeService#saveGIPIQuoteItemPeril(com.geniisys.gipi.entity.GIPIQuoteItemPeril)
	 */
	@Override // whofeih
	public void saveGIPIQuoteItemPeril(GIPIQuoteItemPeril quoteItemPeril)
			throws SQLException {
		this.getGipiQuoteItemPerilDAO().saveGIPIQuoteItemPeril(quoteItemPeril);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemPerilFacadeService#deleteGIPIQuoteItemAllPerils(int, int)
	 */
	@Override
	public void deleteGIPIQuoteItemAllPerils(int quoteId, int itemNo)
			throws SQLException {
		this.gipiQuoteItemPerilDAO.deleteGIPIQuoteItemAllPerils(quoteId, itemNo);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemPerilFacadeService#computePremiumAmount(java.lang.String, java.util.Date, java.util.Date, java.math.BigDecimal, java.math.BigDecimal)
	 */
	@Override 
	public BigDecimal computePremiumAmount(String prorateFlag, Date inceptionDate,
			Date expiryDate, BigDecimal premiumRate, BigDecimal tsiAmount)
			throws SQLException {		
		return this.getGipiQuoteItemPerilDAO().computePremiumAmount(prorateFlag, inceptionDate, expiryDate, premiumRate, tsiAmount);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIItemPerilService#prepareItemPerilSummaryJSON(org.json.JSONArray, java.util.Map)
	 */
	public List<GIPIQuoteItemPerilSummary> prepareItemPerilSummaryJSON(JSONArray rows, GIISUser USER)throws JSONException{
		List<GIPIQuoteItemPerilSummary> perilSummaries = new ArrayList<GIPIQuoteItemPerilSummary>();
		GIPIQuoteItemPerilSummary peril = null;
		for(int index=0; index<rows.length(); index++){
			peril = new GIPIQuoteItemPerilSummary();
			peril.setQuoteId(rows.getJSONObject(index).isNull("quoteId") ? 0 : rows.getJSONObject(index).getInt("quoteId"));
			peril.setAnnPremAmt(rows.getJSONObject(index).isNull("annPremAmt") ? null : new BigDecimal(rows.getJSONObject(index).getDouble("annPremAmt")));
			peril.setBasicPerilCd(rows.getJSONObject(index).isNull("basicPerilCd")? null: rows.getJSONObject(index).getInt("basicPerilCd"));
			peril.setCompRem(rows.getJSONObject(index).isNull("compRem")? "": StringEscapeUtils.unescapeHtml(rows.getJSONObject(index).getString("compRem")));
			//peril.setCoverageCd(rows.getJSONObject(index).isNull("converageCd")? 0: rows.getJSONObject(index).getInt("coverageCd"));
			if(!rows.getJSONObject(index).isNull("coverageCd")){
				if(!rows.getJSONObject(index).getString("coverageCd").isEmpty()){ //rde
					peril.setCoverageCd(rows.getJSONObject(index).getInt("coverageCd"));
				}
			}
			peril.setCoverageDesc(rows.getJSONObject(index).isNull("coverageDesc")? "": StringEscapeUtils.unescapeHtml(rows.getJSONObject(index).getString("coverageDesc")));
			peril.setCreateDate(USER.getCreateDate()); 
			peril.setCreateUser(StringEscapeUtils.unescapeHtml(USER.getCreateUser()));
			peril.setCurrencyCd(rows.getJSONObject(index).isNull("currencyCd")? null: rows.getJSONObject(index).getInt("currencyCd"));
			peril.setCurrencyDesc(rows.getJSONObject(index).isNull("currencyDesc")? null: StringEscapeUtils.unescapeHtml(rows.getJSONObject(index).getString("currencyDesc")));
			peril.setCurrencyRate(rows.getJSONObject(index).isNull("currencyRate")? null: new BigDecimal(rows.getJSONObject(index).getDouble("currencyRate")));
			peril.setItemDesc(rows.getJSONObject(index).isNull("itemDesc")? null: StringEscapeUtils.unescapeHtml(rows.getJSONObject(index).getString("itemDesc")));
			peril.setItemNo(rows.getJSONObject(index).isNull("itemNo")? null: rows.getJSONObject(index).getInt("itemNo"));
			peril.setItemTitle(rows.getJSONObject(index).isNull("itemTitle")? null: StringEscapeUtils.unescapeHtml(rows.getJSONObject(index).getString("itemTitle")));
			peril.setPerilCd(rows.getJSONObject(index).isNull("perilCd")? null: rows.getJSONObject(index).getInt("perilCd"));
			peril.setPerilName(rows.getJSONObject(index).isNull("perilName")? null: StringEscapeUtils.unescapeHtml(rows.getJSONObject(index).getString("perilName")));
			peril.setPerilType(rows.getJSONObject(index).isNull("perilType")? null: StringEscapeUtils.unescapeHtml(rows.getJSONObject(index).getString("perilType")));
			
			//peril.setPerilRate(rows.getJSONObject(index).isNull("perilRate")? null: new BigDecimal(rows.getJSONObject(index).getDouble("perilRate")));
			peril.setPerilRate(JSONUtil.getBigDecimal(rows, index, "perilRate"));
			peril.setPremiumAmount(rows.getJSONObject(index).isNull("premiumAmount")? null: new BigDecimal(rows.getJSONObject(index).getDouble("premiumAmount")));
			peril.setTsiAmount(rows.getJSONObject(index).isNull("tsiAmount")? null: new BigDecimal(rows.getJSONObject(index).getDouble("tsiAmount")));
			peril.setLineCd(rows.getJSONObject(index).isNull("lineCd")? null: StringEscapeUtils.unescapeHtml(rows.getJSONObject(index).getString("lineCd")));
			peril.setUserId(USER.getUserId());
			peril.setWarrantiesAndClausesSwitch(rows.getJSONObject(index).isNull("wcSw")? null: StringEscapeUtils.unescapeHtml(rows.getJSONObject(index).getString("wcSw")));
			perilSummaries.add(peril);
		}
		return perilSummaries;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemPerilFacadeService#updateItemPerilPremAmt(int, int, int, java.math.BigDecimal)
	 */
	@Override
	public void updateItemPerilPremAmt(int quoteId, int itemNo, int perilCd, BigDecimal premAmt) throws SQLException {
		this.gipiQuoteItemPerilDAO.updateItemPerilPremAmt(quoteId, itemNo, perilCd, premAmt);	
	}

	@Override
	public List<GIPIQuoteItemPerilSummary> getGIPIQuoteItemPerilSummaryListForPack(
			Integer packQuoteId) throws SQLException {
		List<GIPIQuoteItemPerilSummary> list = null;
		try {
			list = gipiQuoteItemPerilDAO.getGIPIQuoteItemPerilSummaryListForPack(packQuoteId);
		} catch (SQLException e) {
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			log.debug(Arrays.toString(e.getStackTrace()));
		}
		return list;
	}
}