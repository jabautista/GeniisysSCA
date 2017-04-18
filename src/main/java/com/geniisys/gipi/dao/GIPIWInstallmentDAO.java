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

import com.geniisys.gipi.entity.GIPIWInstallment;


/**
 * The Interface GIPIWInstallmentDAO.
 */
public interface GIPIWInstallmentDAO {
	
	/**
	 * Gets the gIPIW installment.
	 * 
	 * @param parId the par id
	 * @param itemGrp the item grp
	 * @param takeupSeqNo the takeup seq no
	 * @return the gIPIW installment
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIWInstallment> getGIPIWInstallment(int parId, int itemGrp, int takeupSeqNo) throws SQLException;
	
	/**
	 * Delete gipi winstallment.
	 * 
	 * @param parId the par id
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	public boolean deleteGIPIWinstallment(int parId) throws SQLException; 
	
	/**
	 * Save gipiw installment.
	 * 
	 * @param winstallment the winstallment
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	public boolean saveGIPIWInstallment(GIPIWInstallment winstallment) throws SQLException;
	
	/**
	 * Do payterm computation.
	 * 
	 * @param version the version
	 * @param dueDate the due date
	 * @param parId the par id
	 * @param lineCd the line cd
	 * @return the map
	 * @throws SQLException the sQL exception
	 */
	Map<String, Object> doPaytermComputation(Map<String, Object> params) throws SQLException;
	
	/**
	 * Gets the gIPIW installment.
	 * 
	 * @param parId the par id
	 * @return the gIPIW installment
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIWInstallment> getAllGIPIWInstallment(int parId) throws SQLException;
	
}
