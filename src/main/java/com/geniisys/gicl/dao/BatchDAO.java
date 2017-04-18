/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.dao
	File Name: BatchDAO.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Dec 20, 2011
	Description: 
*/


package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gicl.exceptions.BatchException;

public interface BatchDAO {
	public String generateAE(Map<String, Object>params)throws SQLException, BatchException;
	public String approveBatchCsr(Map<String, Object> params) throws SQLException, BatchException;
	public String postRecovery(Map<String, Object> params) throws SQLException, BatchException; 
}
