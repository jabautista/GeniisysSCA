package com.geniisys.gipi.pack.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.pack.entity.GIPIPackPolbasic;

public interface GIPIPackPolbasicDAO {

	/**
	 * Gets list of policy for pack endt
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	List<GIPIPackPolbasic> getPolicyForPackEndt(Map<String, Object> params) throws SQLException;
	GIPIPackPolbasic getPackageBinders(Map<String, Object> params) throws SQLException;
	List<GIPIPackPolbasic> checkPackPolicyGiexs006(Map<String, Object> params) throws SQLException;
	Map<String, Object> copyPackPolbasicGiuts008a(Map<String, Object> params) throws SQLException;
	String checkIfPackGIACS007(Map<String, Object> params) throws SQLException;
	String checkIfBillsSettledGIACS007(Map<String, Object> params) throws SQLException;
	String checkIfWithMc(Integer packParId) throws SQLException;
	
}
