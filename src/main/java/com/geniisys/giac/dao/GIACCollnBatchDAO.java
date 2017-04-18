/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.entity.GIACCollnBatch;

/**
 * The Interface GIACBranchDAO.
 */
public interface GIACCollnBatchDAO {

	/**
	 * Gets the DCB Details.
	 * 
	 * @return the GIACCollnBatch
	 * @throws SQLException the sQL exception
	 */
	
	GIACCollnBatch getDCBNo(String fundCd, String branchCd, Date tranDate) throws SQLException;
	
	GIACCollnBatch getNewDCBNo(String fundCd, String branchCd, Date tranDate) throws SQLException;
	
	/**
	 * Gets the records of DCB_DATE LOV in GIACS035 (Close DCB)
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	List<Map<String, Object>> getDCBDateLOV(Map<String, Object> params) throws SQLException;
	
	/**
	 * Gets the records of DCB_NO LOV in GIACS035 (Close DCB)
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	List<Map<String, Object>> getDCBNoLOV(Map<String, Object> params) throws SQLException;
	
	List<GIACCollnBatch> getDCBNosList(HashMap<String, Object> params) throws SQLException;
	
	void saveCollnBatch(Map<String, Object> params) throws SQLException;
	
	public Integer generateDCBNo() throws SQLException;
	
	String getClosedTag(HashMap<String, Object> params) throws SQLException;
	
}
