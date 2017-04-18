/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */

package com.geniisys.gipi.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.dao.GIPIQuoteItemPerilDAO;
import com.geniisys.gipi.entity.GIPIQuoteItemPeril;
import com.geniisys.gipi.entity.GIPIQuoteItemPerilSummary;
import com.seer.framework.db.GenericDAOiBatis;

/**
 * The Class GIPIQuoteItemPerilDAOImpl.
 */
public class GIPIQuoteItemPerilDAOImpl extends GenericDAOiBatis<GIPIQuoteItemPeril> implements GIPIQuoteItemPerilDAO {

	/**
	 * Instantiates a new gIPI quote item peril dao impl.
	 * 
	 * @param persistentClass the persistent class
	 */
	public GIPIQuoteItemPerilDAOImpl(Class<GIPIQuoteItemPeril> persistentClass) {
		super(persistentClass);
	}
	
	/**
	 * Instantiates a new gIPI quote item peril dao impl.
	 */
	public GIPIQuoteItemPerilDAOImpl(){
		super(GIPIQuoteItemPeril.class);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemPerilDAO#delGIPIQuoteItemPeril(int, int, int)
	 */
	@Override
	public void delGIPIQuoteItemPeril(int quoteId, int itemNo, int perilCd)	throws SQLException {
		log.info("DAO calling delGIPIQuoteItemPeril Params:("+quoteId+","+itemNo+","+perilCd+")");
		Map<String, Integer> param = new HashMap<String, Integer>();
		param.put("quoteId", quoteId);
		param.put("itemNo", itemNo);
		param.put("perilCd", perilCd);
		getSqlMapClient().delete("delGIPIQuoteItemPeril",param);

	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemPerilDAO#getGIPIQuoteItemPerilSummaryList(int)
	 */
	@Override
	@SuppressWarnings("unchecked")
	public List<GIPIQuoteItemPerilSummary> getGIPIQuoteItemPerilSummaryList(int quoteId) throws SQLException {
		log.info("DAO calling getGIPIQuoteItemPerilSummaryList Params:("+quoteId+")");
		return getSqlMapClient().queryForList("getGIPIQuoteItemPerilSummaryList", quoteId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemPerilDAO#setGIPIQuoteItemPeril(com.geniisys.gipi.entity.GIPIQuoteItemPeril)
	 */
	@Override
	public void setGIPIQuoteItemPeril(GIPIQuoteItemPeril quoteItemPeril)	throws SQLException {
		log.info("DAO calling setGIPIQuoteItemPeril Params:(quoteItemPeril)");
		getSqlMapClient().insert("setGIPIQuoteItemPeril", quoteItemPeril);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemPerilDAO#saveGIPIQuoteItemPeril(com.geniisys.gipi.entity.GIPIQuoteItemPeril)
	 */
	@Override // whofeih
	public void saveGIPIQuoteItemPeril(GIPIQuoteItemPeril quoteItemPeril)
			throws SQLException {
		log.info("DAO calling saveGIPIQuoteItemPeril Params: quoteItemPeril");
		this.getSqlMapClient().insert("saveGIPIQuoteItemPeril", quoteItemPeril);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemPerilDAO#deleteGIPIQuoteItemAllPerils(int, int)
	 */
	@Override
	public void deleteGIPIQuoteItemAllPerils(int quoteId, int itemNo)
			throws SQLException {
		Map<String, Integer> params = new HashMap<String, Integer>();
		params.put("quoteId", quoteId);
		params.put("itemNo", itemNo);
		this.getSqlMapClient().delete("deleteGIPIQuoteItemAllPerils", params);
	}
	
	
	/**
	 * Computes the premium amount through a PL/SQL Procedure.
	 * 
	 * @param prorateFlag the prorate flag
	 * @param inceptionDate the inception date
	 * @param expiryDate the expiry date
	 * @param premiumRate the premium rate
	 * @param tsiAmount the tsi amount
	 * @return the big decimal
	 * @throws SQLException the sQL exception
	 * @author royencela
	 */
	@Override
	public BigDecimal computePremiumAmount(String prorateFlag, Date inceptionDate,
			Date expiryDate, BigDecimal premiumRate, BigDecimal tsiAmount)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("prorateFlag", prorateFlag);
		params.put("inceptionDate", inceptionDate);
		params.put("expiryDate", expiryDate);
		params.put("premiumRate", premiumRate);
		params.put("tsiAmount", tsiAmount);
		
		return (BigDecimal)this.getSqlMapClient().queryForObject("computePremiumAmount", params);
	}

	@Override
	public void updateItemPerilPremAmt(int quoteId, int itemNo, int perilCd, BigDecimal premAmt) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("quoteId", quoteId);
		params.put("itemNo", itemNo);
		
		params.put("perilCd", perilCd);
		params.put("premAmt", premAmt);
		this.getSqlMapClient().queryForObject("updateItemPerilPremAmt", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIQuoteItemPerilSummary> getGIPIQuoteItemPerilSummaryListForPack(
			Integer packQuoteId) throws SQLException {
		log.info("Retrieving quote item perils for pack_quote_id("+packQuoteId+")");
		return getSqlMapClient().queryForList("getGipiQuoteItemPerilsForPack", packQuoteId);
	}
}