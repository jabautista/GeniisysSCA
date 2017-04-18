/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.List;

import org.apache.log4j.Logger;

import com.geniisys.framework.util.Debug;
import com.geniisys.gipi.dao.GIPIQuoteItemPerilDiscountDAO;
import com.geniisys.gipi.entity.GIPIQuoteItemPerilDiscount;
import com.geniisys.gipi.service.GIPIQuoteItemPerilDiscountFacadeService;


/**
 * The Class GIPIQuoteItemPerilDiscountFacadeServiceImpl.
 */
public class GIPIQuoteItemPerilDiscountFacadeServiceImpl implements
		GIPIQuoteItemPerilDiscountFacadeService {

	/** The log. */
	private static Logger log = Logger.getLogger(GIPIQuoteItemPerilDiscountFacadeServiceImpl.class);
	
	/** The gipi quote item peril discount dao. */
	private GIPIQuoteItemPerilDiscountDAO gipiQuoteItemPerilDiscountDAO;
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemPerilDiscountFacadeService#deleteItemPerilDiscount(java.util.List)
	 */
	@Override
	public boolean deleteItemPerilDiscount(List<GIPIQuoteItemPerilDiscount> list) throws SQLException {
		log.info("Deleting Itme Peril Discount...");
		boolean result = true;
		if (list.size()>0){
			for(GIPIQuoteItemPerilDiscount itemPerilDiscount: list){
				result = result && this.gipiQuoteItemPerilDiscountDAO.deleteItemPerilDiscount(itemPerilDiscount);			
			}
		}
		log.info("Deleting Result:"+result);
		return result;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemPerilDiscountFacadeService#retrieveItemPerilDiscountList(int, int, int)
	 */
	@Override
	public List<GIPIQuoteItemPerilDiscount> retrieveItemPerilDiscountList(int quoteId) throws SQLException {
		log.info("Retrieving Item Peril Discount...");
		List<GIPIQuoteItemPerilDiscount> list = this.gipiQuoteItemPerilDiscountDAO.getItemPerilDiscountList(quoteId);
		log.info("Item Peril Discount Size():"+list.size());
		return list;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemPerilDiscountFacadeService#saveItemPerilDiscount(java.util.List)
	 */
	@Override
	public boolean saveItemPerilDiscount(List<GIPIQuoteItemPerilDiscount> list)	throws SQLException {
		log.info("Saving Item Peril Discount...");
		boolean result = true;
		if (list.size()>0){
			log.info("List Size to Save:"+list.size());
			for(GIPIQuoteItemPerilDiscount itemPerilDiscount: list){
				Debug.print(itemPerilDiscount);
				result = result && this.gipiQuoteItemPerilDiscountDAO.insertItemPerilDiscount(itemPerilDiscount);			
			}
		}
		log.info("Saving Result:"+result);
		return result;
	}

	/**
	 * Gets the gipi quote item peril discount dao.
	 * 
	 * @return the gipi quote item peril discount dao
	 */
	public GIPIQuoteItemPerilDiscountDAO getGipiQuoteItemPerilDiscountDAO() {
		return gipiQuoteItemPerilDiscountDAO;
	}

	/**
	 * Sets the gipi quote item peril discount dao.
	 * 
	 * @param gipiQuoteItemPerilDiscountDAO the new gipi quote item peril discount dao
	 */
	public void setGipiQuoteItemPerilDiscountDAO(
			GIPIQuoteItemPerilDiscountDAO gipiQuoteItemPerilDiscountDAO) {
		this.gipiQuoteItemPerilDiscountDAO = gipiQuoteItemPerilDiscountDAO;
	}

}
