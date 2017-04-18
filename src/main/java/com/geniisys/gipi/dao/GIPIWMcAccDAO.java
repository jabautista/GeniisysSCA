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

import com.geniisys.gipi.entity.GIPIWMcAcc;


/**
 * The Interface GIPIWMcAccDAO.
 */
public interface GIPIWMcAccDAO {

	/**
	 * Gets the gipi w mc acc.
	 * 
	 * @param parId the par id
	 * @param itemNo the item no
	 * @return the gipi w mc acc
	 * @throws SQLException the sQL exception
	 */
	List<GIPIWMcAcc> getGipiWMcAcc(int parId,int itemNo) throws SQLException;
	
	/**
	 * Gets the gipi w mc accby par id.
	 * 
	 * @param parId the par id
	 * @return the gipi w mc accby par id
	 * @throws SQLException the sQL exception
	 */
	List<GIPIWMcAcc> getGipiWMcAccbyParId(int parId) throws SQLException;
	
	/**
	 * Save gipi w mc acc.
	 * 
	 * @param gipiWMcAcc the gipi w mc acc
	 * @throws SQLException the sQL exception
	 */
	void saveGipiWMcAcc(GIPIWMcAcc gipiWMcAcc) throws SQLException;
	void saveGipiWMcAcc(List<GIPIWMcAcc> accItems) throws SQLException;

	
	/**
	 * Delete gipi w mc acc.
	 * 
	 * @param gipiWMcAcc the gipi w mc acc
	 * @throws SQLException the sQL exception
	 */
	void deleteGipiWMcAcc(GIPIWMcAcc gipiWMcAcc) throws SQLException;
	void deleteGipiWMcAcc(List<GIPIWMcAcc> gipiWMcAcc) throws SQLException;
	void deleteGipiWMcAcc(int parId, int itemNo) throws SQLException;
	void deleteGipiWMcAcc(int parId, int itemNo, int accCd) throws SQLException;
}
