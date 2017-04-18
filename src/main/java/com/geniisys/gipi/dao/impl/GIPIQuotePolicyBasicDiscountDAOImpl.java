/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIQuotePolicyBasicDiscountDAO;
import com.geniisys.gipi.entity.GIPIQuotePolicyBasicDiscount;
import com.seer.framework.db.GenericDAOiBatis;



/**
 * The Class GIPIQuotePolicyBasicDiscountDAOImpl.
 */
public class GIPIQuotePolicyBasicDiscountDAOImpl 
        extends GenericDAOiBatis<GIPIQuotePolicyBasicDiscount>
		implements GIPIQuotePolicyBasicDiscountDAO {

	/** The log. */
	private Logger log = Logger.getLogger(GIPIQuotePolicyBasicDiscountDAOImpl.class);
	
	/**
	 * Instantiates a new gIPI quote policy basic discount dao impl.
	 */
	public GIPIQuotePolicyBasicDiscountDAOImpl() {
		super(GIPIQuotePolicyBasicDiscount.class);		
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuotePolicyBasicDiscountDAO#deletePolicyDiscount(com.geniisys.gipi.entity.GIPIQuotePolicyBasicDiscount)
	 */
	@Override
	public boolean deletePolicyDiscount(GIPIQuotePolicyBasicDiscount polDiscount) throws SQLException{
		log.info("DAO - Deleting Policy Discount...");
		Map<String, Integer> data = new HashMap<String, Integer>();
		data.put("quoteId", polDiscount.getQuoteId());
		data.put("sequenceNo", polDiscount.getSequenceNo());
		this.getSqlMapClient().delete("deleteGIPIQuotePolicyBasicDiscount", data);
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuotePolicyBasicDiscountDAO#getPolicyDiscountList(int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIQuotePolicyBasicDiscount> getPolicyDiscountList(int quoteId) throws SQLException{
		log.info("DAO - Retrieving Policy Discount List...");
		return getSqlMapClient().queryForList("getGIPIQuotePolicyBasicDiscount", quoteId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuotePolicyBasicDiscountDAO#insertPolicyDiscount(com.geniisys.gipi.entity.GIPIQuotePolicyBasicDiscount)
	 */
	@Override
	public boolean insertPolicyDiscount(GIPIQuotePolicyBasicDiscount polDiscount) throws SQLException{
		log.info("DAO - Inserting Policy Discount...");
		this.getSqlMapClient().insert("setGIPIQuotePolicyBasicDiscount", polDiscount);
		return true;
	}
	
}