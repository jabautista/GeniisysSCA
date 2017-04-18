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
import com.geniisys.gipi.dao.GIPIQuotePolicyBasicDiscountDAO;
import com.geniisys.gipi.entity.GIPIQuotePolicyBasicDiscount;
import com.geniisys.gipi.service.GIPIQuotePolicyBasicDiscountFacadeService;


/**
 * The Class GIPIQuotePolicyBasicDiscountFacadeServiceImpl.
 */
public class GIPIQuotePolicyBasicDiscountFacadeServiceImpl implements 
	GIPIQuotePolicyBasicDiscountFacadeService{

	/** The log. */
	private static Logger log = Logger.getLogger(GIPIQuotePolicyBasicDiscountFacadeServiceImpl.class);
	
	/** The gipi quote policy basic discount dao. */
	private GIPIQuotePolicyBasicDiscountDAO gipiQuotePolicyBasicDiscountDAO;
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuotePolicyBasicDiscountFacadeService#deletePolicyDiscount(java.util.List)
	 */
	@Override
	public boolean deletePolicyDiscount(List<GIPIQuotePolicyBasicDiscount> list, int sequenceNo) throws SQLException {
		log.info("Deleting Basic Policy Discount...");
		boolean result = true;
		if (list.size()>0){
			for(GIPIQuotePolicyBasicDiscount polDiscount: list){
				if(sequenceNo == polDiscount.getSequenceNo()){
					result = result && this.gipiQuotePolicyBasicDiscountDAO.deletePolicyDiscount(polDiscount);	
				}
			}
		}
		log.info("Deleting Result:"+result);
		return result;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuotePolicyBasicDiscountFacadeService#retrievePolicyDiscountList(int)
	 */
	@Override
	public List<GIPIQuotePolicyBasicDiscount> retrievePolicyDiscountList(int quoteId) throws SQLException {
		log.info("Retrieving Basic Policy Discount...");
		List<GIPIQuotePolicyBasicDiscount> list = this.gipiQuotePolicyBasicDiscountDAO.getPolicyDiscountList(quoteId);
		log.info("Basic Policy Discount Size():"+list.size());
		return list;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuotePolicyBasicDiscountFacadeService#savePolicyDiscount(java.util.List)
	 */
	@Override
	public boolean savePolicyDiscount(List<GIPIQuotePolicyBasicDiscount> list) throws SQLException {
		log.info("Saving Basic Policy Discount...");
		boolean result = true;
		if (list.size()>0){
			log.info("List Size to Save:"+list.size());
			for(GIPIQuotePolicyBasicDiscount polDiscount: list){
				Debug.print(polDiscount);
				result = result && this.gipiQuotePolicyBasicDiscountDAO.insertPolicyDiscount(polDiscount);			
			}
		}
		log.info("Saving Result:"+result);
		return result;
	}

	/**
	 * Gets the gipi quote policy basic discount dao.
	 * 
	 * @return the gipi quote policy basic discount dao
	 */
	public GIPIQuotePolicyBasicDiscountDAO getGipiQuotePolicyBasicDiscountDAO() {
		return gipiQuotePolicyBasicDiscountDAO;
	}

	/**
	 * Sets the gipi quote policy basic discount dao.
	 * 
	 * @param gipiQuotePolicyBasicDiscountDAO the new gipi quote policy basic discount dao
	 */
	public void setGipiQuotePolicyBasicDiscountDAO(
			GIPIQuotePolicyBasicDiscountDAO gipiQuotePolicyBasicDiscountDAO) {
		this.gipiQuotePolicyBasicDiscountDAO = gipiQuotePolicyBasicDiscountDAO;
	}

}
