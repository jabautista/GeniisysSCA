/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.entity.GIACAgingSoaDetail;

/**
 * The Interface GIACAginSoaDetailDAO.
 */
public interface GIACAgingSoaDetailDAO {
	
	/**
	 * Gets the giac aging soa intno details.
	 * 
	 * @return the List<GIACAgingSoaDetail>
	 * @throws SQLException the sQL exception
	 */
	List<GIACAgingSoaDetail> getInstnoDetails(String issCd, Integer premSeqNo)throws SQLException;
	
	/**
	 * Gets the policy details.
	 * 
	 * @return Map<String, Object> policy details
	 * @throws SQLException the sQL exception
	 */
	List<Map<String, Object>> getPolicyDetails(Map<String, Object> params) throws SQLException;

	/**
	 * Gets GIAC_AGING_SOA_DETAILS records
	 * @param keyword
	 * @param issCd
	 * @return
	 * @throws SQLException
	 */
	List<GIACAgingSoaDetail> getAgingSoaDetails(String keyword, String issCd) throws SQLException;
	Map<String, Object> getBillInfo(Map<String, Object> params) throws SQLException;
	GIACAgingSoaDetail getInstInfo(Map<String, Object> params) throws SQLException;
	Map<String, Object> getPolicyDtlsGIACS007(Map<String, Object> params) throws SQLException;
	GIACAgingSoaDetail getInvoiceSoaDetails(Map<String, Object> params) throws SQLException;
}
