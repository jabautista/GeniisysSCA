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

import com.geniisys.gipi.dao.GIPIQuoteItemDiscountDAO;
import com.geniisys.gipi.entity.GIPIQuoteItemDiscount;
import com.seer.framework.db.GenericDAOiBatis;


/**
 * The Class GIPIQuoteItemDiscountDAOImpl.
 */
public class GIPIQuoteItemDiscountDAOImpl 
	extends GenericDAOiBatis<GIPIQuoteItemDiscount>
	implements GIPIQuoteItemDiscountDAO{

	/** The log. */
	private Logger log = Logger.getLogger(GIPIQuoteItemDiscountDAOImpl.class);
	
	/**
	 * Instantiates a new gIPI quote item discount dao impl.
	 */
	public GIPIQuoteItemDiscountDAOImpl() {
		super(GIPIQuoteItemDiscount.class);		
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemDiscountDAO#deleteItemDiscount(com.geniisys.gipi.entity.GIPIQuoteItemDiscount)
	 */
	@Override
	public boolean deleteItemDiscount(GIPIQuoteItemDiscount itemDiscount) throws SQLException {
		log.info("DAO - Deleting Item Discount...");
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("quoteId", itemDiscount.getQuoteId());
		param.put("itemNo", itemDiscount.getItemNo());		
		this.getSqlMapClient().delete("deleteGIPIQuoteItemDiscount", param);
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemDiscountDAO#getItemDiscountList(int, int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIQuoteItemDiscount> getItemDiscountList(int quoteId) throws SQLException {
		log.info("DAO - Retrieving Item Discount List...");
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("quoteId", quoteId);
		//param.put("itemNo", itemNo);
		return getSqlMapClient().queryForList("getGIPIQuoteItemDiscount", param);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemDiscountDAO#insertItemDiscount(com.geniisys.gipi.entity.GIPIQuoteItemDiscount)
	 */
	@Override
	public boolean insertItemDiscount(GIPIQuoteItemDiscount itemDiscount)throws SQLException {
		log.info("DAO - Inserting Item Discount...");
		this.getSqlMapClient().insert("setGIPIQuoteItemDiscount", itemDiscount);
		return true;
	}
	
}
