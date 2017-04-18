/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.GIISLostBid;


/**
 * The Interface GIISLostBidDAO.
 */
public interface GIISLostBidDAO {
	
	/**
	 * Gets the lost bid reason list.
	 * 
	 * @return the lost bid reason list
	 * @throws SQLException 
	 */
	public List<GIISLostBid> getLostBidReasonList(String userId) throws SQLException;
	
	/**
	 * Gets the lost bid reason list by line cd.
	 * 
	 * @param lineCd the line cd
	 * @return the lost bid reason list by line cd
	 */
	public List<GIISLostBid> getLostBidReasonListByLineCd(String lineCd);
	
	public Integer generateReasonCd() throws SQLException;
	
	public Integer generateReasonCd2() throws SQLException;
	
	//public boolean saveLostBidReason(GIISLostBid newLostBid) throws SQLException;
	public boolean saveLostBidReason(Map<String, Object> allParameters) throws Exception;
	
	public boolean deleteLostBidReason(Map<String, Object> params) throws SQLException;
	
	public void saveLostBidReason2(Map<String, Object> allParameters) throws Exception;
	
	public Map<String, Object> valUpdateRec(Map<String, Object>  params) throws SQLException;
	void saveGiiss204(Map<String, Object> params) throws SQLException;
	void valDeleteRec(Map<String, Object>  params) throws SQLException;
	void valAddRec(Map<String, Object>  params) throws SQLException;
}
