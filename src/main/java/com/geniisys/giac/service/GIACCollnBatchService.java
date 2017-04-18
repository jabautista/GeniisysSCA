/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.giac.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.framework.util.PaginatedList;
import com.geniisys.giac.entity.GIACCollnBatch;

/**
 * The Interface GIACBranchService.
 */
public interface GIACCollnBatchService {
	/**
	 * Get DCB Details.
	 * @param fund_cd, branch_cd
	 * @return the GIACCollnBatch
	 * @throws SQLException the sQL exception
	 */
	public GIACCollnBatch getDCBNo(String fundCd, String branchCd, Date tranDate) throws SQLException;
	
	public GIACCollnBatch getNewDCBNo(String fundCd, String branchCd, Date tranDate) throws SQLException;

	/**
	 * Gets the records of DCB_DATE LOV in GIACS035 (Close DCB)
	 * @param pageNo
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	PaginatedList getDCBDateLOV(Integer pageNo, Map<String, Object> params) throws SQLException;
	
	/**
	 * Gets the records of DCB_NO LOV in GIACS035 (Close DCB)
	 * @param pageNo
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	PaginatedList getDCBNoLOV(Integer pageNo, Map<String, Object> params) throws SQLException;
	
	HashMap<String, Object> getDCBMaintParams(HashMap<String, Object> params) throws SQLException, JSONException;
	
	void saveDCBNoMaintChanges(String param, String userId) throws SQLException, JSONException, ParseException;
	
	public Integer generateDCBNo() throws SQLException;
	
	String getClosedTag(HashMap<String, Object> params) throws SQLException;
}
