/**
 * 
 */
package com.geniisys.giac.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.giac.entity.GIACBatchAcctEntry;

/**
 * @author steven
 * @date 04.11.2013
 */
public interface GIACBatchAcctEntryService {

	void showBatchAccountingEntry(HttpServletRequest request, GIISUser USER)throws SQLException;

	List<Map<String, Object>> validateProdDate(HttpServletRequest request)throws SQLException;

	List<GIACBatchAcctEntry> generateDataCheck(HttpServletRequest request, GIISUser USER)throws SQLException, Exception;

	void validateWhenExit()throws SQLException, Exception;

	List<GIACBatchAcctEntry> genAccountingEntry(HttpServletRequest request, GIISUser USER)throws SQLException, Exception;

	void prodSumRepAndPerilExt(HttpServletRequest request, GIISUser USER)throws SQLException, Exception;

}
