/**
 * 
 */
package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;

/**
 * @author steven
 *
 */
public interface GICLBatchOSPrintingService{

	JSONObject showBatchOSPrinting(HttpServletRequest request, GIISUser USER) throws SQLException,JSONException;

	List<Map<String, Object>> getBatchOSRecord(HttpServletRequest request, GIISUser USER) throws SQLException, Exception;

	void extractOSDetail(HttpServletRequest request, GIISUser uSER)throws SQLException, Exception;
	
}
