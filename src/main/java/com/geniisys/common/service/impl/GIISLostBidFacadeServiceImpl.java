/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.service.impl;

import java.util.List;

import com.geniisys.common.dao.GIISLostBidDAO;
import com.geniisys.common.entity.GIISLostBid;
import com.geniisys.common.service.GIISLostBidFacadeService;


/**
 * The Class GIISLostBidFacadeServiceImpl.
 */
public class GIISLostBidFacadeServiceImpl implements GIISLostBidFacadeService{
	
	/** The gii s lost bid dao. */
	private GIISLostBidDAO giisLostBidDAO;

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISLostBidFacadeService#getLostBidReasonList()
	 */
	@Override
	public List<GIISLostBid> getLostBidReasonList() {		
		return null;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISLostBidFacadeService#getLostBidReasonListByLineCd(java.lang.String)
	 */
	@Override
	public List<GIISLostBid> getLostBidReasonListByLineCd(String lineCd) {		
		return giisLostBidDAO.getLostBidReasonListByLineCd(lineCd);
	}

	/**
	 * Gets the gii s lost bid dao.
	 * 
	 * @return the gii s lost bid dao
	 */
	public GIISLostBidDAO getGiisLostBidDAO() {
		return  giisLostBidDAO;
	}

	/**
	 * Sets the gii s lost bid dao.
	 * 
	 * @param giisLostBidDAO the new gii s lost bid dao
	 */
	public void setGiisLostBidDAO(GIISLostBidDAO giisLostBidDAO) {
		this.giisLostBidDAO = giisLostBidDAO;
	}

}
