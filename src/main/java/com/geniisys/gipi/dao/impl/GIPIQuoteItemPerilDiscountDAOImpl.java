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

import com.geniisys.gipi.dao.GIPIQuoteItemPerilDiscountDAO;
import com.geniisys.gipi.entity.GIPIQuoteItemPerilDiscount;
import com.seer.framework.db.GenericDAOiBatis;


/**
 * The Class GIPIQuoteItemPerilDiscountDAOImpl.
 */
public class GIPIQuoteItemPerilDiscountDAOImpl 
	extends GenericDAOiBatis<GIPIQuoteItemPerilDiscount>
	implements GIPIQuoteItemPerilDiscountDAO{

	/** The log. */
	private Logger log = Logger.getLogger(GIPIQuoteItemPerilDiscountDAOImpl.class);
	
	/**
	 * Instantiates a new gIPI quote item peril discount dao impl.
	 */
	public GIPIQuoteItemPerilDiscountDAOImpl() {
		super(GIPIQuoteItemPerilDiscount.class);		
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemPerilDiscountDAO#deleteItemPerilDiscount(com.geniisys.gipi.entity.GIPIQuoteItemPerilDiscount)
	 */
	@Override
	public boolean deleteItemPerilDiscount(GIPIQuoteItemPerilDiscount perilDiscount) throws SQLException {
		log.info("DAO - Deleting Item Peril Discount...");
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("quoteId", perilDiscount.getQuoteId());
		param.put("itemNo", perilDiscount.getItemNo());
		param.put("perilCd", perilDiscount.getPerilCd());
		this.getSqlMapClient().delete("deleteGIPIQuoteItemPerilDiscount", param);
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemPerilDiscountDAO#getItemPerilDiscountList(int, int, int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIQuoteItemPerilDiscount> getItemPerilDiscountList(int quoteId) throws SQLException {
		log.info("DAO - Retrieving Item Peril Discount List...");
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("quoteId", quoteId);
		return getSqlMapClient().queryForList("getGIPIQuoteItemPerilDiscount", param);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemPerilDiscountDAO#insertItemPerilDiscount(com.geniisys.gipi.entity.GIPIQuoteItemPerilDiscount)
	 */
	@Override
	public boolean insertItemPerilDiscount(GIPIQuoteItemPerilDiscount perilDiscount) throws SQLException {
		log.info("DAO - Inserting Item Peril Discount...");
		this.getSqlMapClient().insert("setGIPIQuoteItemPerilDiscount", perilDiscount);
		return true;
	}
	
}
