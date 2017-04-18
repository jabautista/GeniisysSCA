/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.service;

import java.util.List;

import com.geniisys.common.entity.GIISLostBid;


/**
 * The Interface GIISLostBidFacadeService.
 */
public interface GIISLostBidFacadeService {

	/**
	 * Gets the lost bid reason list.
	 * 
	 * @return the lost bid reason list
	 */
	public List<GIISLostBid> getLostBidReasonList();
	
	/**
	 * Gets the lost bid reason list by line cd.
	 * 
	 * @param lineCd the line cd
	 * @return the lost bid reason list by line cd
	 */
	public List<GIISLostBid> getLostBidReasonListByLineCd(String lineCd);
}
