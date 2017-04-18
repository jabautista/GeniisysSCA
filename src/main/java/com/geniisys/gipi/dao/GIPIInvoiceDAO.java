package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import com.geniisys.gipi.entity.GIPIInvoice;

public interface GIPIInvoiceDAO {
	
	/**
	 * Returns invoice for a given policy
	 * @param   policyId
	 * @returns policyId,itemGrp,issCd,premSeqNo,premCollMode
	 * @throws  SQLException
	 */
	List<HashMap<String, Object>> getPolicyInvoice(HashMap<String,Object> params) throws SQLException;
	
	/**
	 * Gets monthly booking year and monthly booking date based on specified policy id and dist no.
	 * @param policyId
	 * @param distNo
	 * @return
	 * @throws SQLException
	 */
	String getMultiBookingDateByPolicy(Integer policyId, Integer distNo) throws SQLException;
	
	List<GIPIInvoice> populateBasicDetails(HashMap<String, Object> params) throws SQLException;

}
