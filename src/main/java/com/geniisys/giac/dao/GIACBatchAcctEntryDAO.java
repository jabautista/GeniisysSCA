/**
 * 
 */
package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.entity.GIACBatchAcctEntry;

/**
 * @author steven
 * @date 04.11.2013
 */
public interface GIACBatchAcctEntryDAO {

	String getGIACParamValue(String paramName)throws SQLException;

	List<Map<String, Object>> validateProdDate(String prodDate)throws SQLException;

	List<GIACBatchAcctEntry> generateDataCheck(
			Map<String, Object> params)throws SQLException, Exception;

	void validateWhenExit()throws SQLException, Exception;
	
	void prodSumRepAndPerilExt(List<GIACBatchAcctEntry> dateCheckParams)throws SQLException, Exception;
	
	List<GIACBatchAcctEntry> giacb001Proc(List<GIACBatchAcctEntry> paramList)throws SQLException, Exception;
	
	List<GIACBatchAcctEntry> giacb002Proc(List<GIACBatchAcctEntry> paramList)throws SQLException, Exception;
	
	List<GIACBatchAcctEntry> giacb003Proc(List<GIACBatchAcctEntry> paramList)throws SQLException, Exception;
	
	List<GIACBatchAcctEntry> giacb004Proc(List<GIACBatchAcctEntry> paramList)throws SQLException, Exception;
	
	List<GIACBatchAcctEntry> giacb005Proc(List<GIACBatchAcctEntry> paramList)throws SQLException, Exception;
	
	List<GIACBatchAcctEntry> giacb006Proc(List<GIACBatchAcctEntry> paramList)throws SQLException, Exception;
	
	List<GIACBatchAcctEntry> giacb007Proc(List<GIACBatchAcctEntry> paramList)throws SQLException, Exception; //benjo 10.13.2016 SR-5512
}
