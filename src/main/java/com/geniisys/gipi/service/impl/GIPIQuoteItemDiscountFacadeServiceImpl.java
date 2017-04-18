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
import java.util.List;

import org.apache.log4j.Logger;

import com.geniisys.framework.util.Debug;
import com.geniisys.gipi.dao.GIPIQuoteItemDAO;
import com.geniisys.gipi.dao.GIPIQuoteItemDiscountDAO;
import com.geniisys.gipi.entity.GIPIQuoteItem;
import com.geniisys.gipi.entity.GIPIQuoteItemDiscount;
import com.geniisys.gipi.service.GIPIQuoteItemDiscountFacadeService;


/**
 * The Class GIPIQuoteItemDiscountFacadeServiceImpl.
 */
public class GIPIQuoteItemDiscountFacadeServiceImpl implements
		GIPIQuoteItemDiscountFacadeService {

	/** The log. */
	private static Logger log = Logger.getLogger(GIPIQuoteItemDiscountFacadeServiceImpl.class);
	
	/** The gipi quote item discount dao. */
	private GIPIQuoteItemDiscountDAO gipiQuoteItemDiscountDAO;
	
	/** The gipi quote item dao. */
	private GIPIQuoteItemDAO gipiQuoteItemDAO;
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemDiscountFacadeService#deleteItemDiscount(java.util.List)
	 */
	@Override
	public boolean deleteItemDiscount(List<GIPIQuoteItemDiscount> list) throws SQLException {
		log.info("Deleting Item Discount...");
		boolean result = true;
		if(list.size()>0){
			for(GIPIQuoteItemDiscount itemDiscount: list){				
				result = result && this.gipiQuoteItemDiscountDAO.deleteItemDiscount(itemDiscount);			
			}
		}
		log.info("Deleting Result:"+result);
		return result;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemDiscountFacadeService#retrieveItemDiscountList(int, int)
	 */
	@Override
	public List<GIPIQuoteItemDiscount> retrieveItemDiscountList(int quoteId) throws SQLException {
		log.info("Retrieving Item Discount...");
		List<GIPIQuoteItemDiscount> finalList = new ArrayList<GIPIQuoteItemDiscount>();
		List<GIPIQuoteItemDiscount> list = this.gipiQuoteItemDiscountDAO.getItemDiscountList(quoteId);
		List<GIPIQuoteItem> items = this.gipiQuoteItemDAO.getGIPIQuoteItemList(quoteId); 
		for(GIPIQuoteItemDiscount discount: list){
			for (GIPIQuoteItem item: items){
				if(discount.getItemNo()==item.getItemNo()){
					discount.setItemTitle(item.getItemTitle());
					finalList.add(discount);
				}
			}
		}
		log.info("Item Discount Size():"+finalList.size());
		return finalList;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuoteItemDiscountFacadeService#saveItemDiscount(java.util.List)
	 */
	@Override
	public boolean saveItemDiscount(List<GIPIQuoteItemDiscount> list) throws SQLException {
		log.info("Saving Item Discount...");
		boolean result = true;
		if(list.size()>0){
			log.info("List Size to Save:"+list.size());
			for(GIPIQuoteItemDiscount itemDiscount: list){
				Debug.print(itemDiscount);
				result = result && this.gipiQuoteItemDiscountDAO.insertItemDiscount(itemDiscount);			
			}
		}
		log.info("Saving Result:"+result);
		return result;
	}

	/**
	 * Gets the gipi quote item discount dao.
	 * 
	 * @return the gipi quote item discount dao
	 */
	public GIPIQuoteItemDiscountDAO getGipiQuoteItemDiscountDAO() {
		return gipiQuoteItemDiscountDAO;
	}

	/**
	 * Sets the gipi quote item discount dao.
	 * 
	 * @param gipiQuoteItemDiscountDAO the new gipi quote item discount dao
	 */
	public void setGipiQuoteItemDiscountDAO(
			GIPIQuoteItemDiscountDAO gipiQuoteItemDiscountDAO) {
		this.gipiQuoteItemDiscountDAO = gipiQuoteItemDiscountDAO;
	}

	/**
	 * Gets the gipi quote item dao.
	 * 
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

}
