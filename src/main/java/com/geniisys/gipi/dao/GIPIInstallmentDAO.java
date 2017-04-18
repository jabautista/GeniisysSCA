/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */

package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIInstallment;

/**
 * The Interface GIPIPolbasicDAO.
 */
public interface GIPIInstallmentDAO {

	/**
	 * 
	 * @param premSeqno, issCd
	 * @return no. of records
	 * @throws SQLException the sQL exception
	 */
	Map<String, Object> checkInstNo(Map<String, Object> params) throws SQLException;
	
	/**
	 * 
	 * @param instNo, premSeqno, issCd
	 * @return date due
	 * @throws SQLException the sQL exception
	 */
	Integer getDaysOverdue (Map<String, Object> param) throws SQLException;
	
	List<GIPIInstallment> getInstNoList(Map<String, Object> params) throws SQLException;
	
	Map<String, Object> getUnpaidPremiumDtls(Map<String, Object> params) throws SQLException;
	
	Integer checkInstNoGIACS007 (Map<String, Object> param) throws SQLException;
}
