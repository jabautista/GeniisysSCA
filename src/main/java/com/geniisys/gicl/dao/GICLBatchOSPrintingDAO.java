/**
 * 
 */
package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

/**
 * @author steven
 *
 */
public interface GICLBatchOSPrintingDAO {

	List<Map<String, Object>> getBatchOSRecord(Map<String, Object> params)throws SQLException, Exception;

	void extractOSDetail(String tranId)throws SQLException, Exception;

}
