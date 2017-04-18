package com.geniisys.gicl.dao;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

public interface GICLBrdrxClmsRegisterDAO {
	
	Map<String, Object> whenNewFormInstanceGicls202() throws SQLException;
	Map<String, Object> whenNewBlockE010Gicls202(String userId) throws SQLException;
	Map<String, Object> getPolicyNumberGicls202(String userId) throws SQLException;
	Integer extractGicls202(HashMap<String, Object> params) throws SQLException;
	String validateLineCd2GIcls202(HashMap<String, Object> params) throws SQLException;
	String validateSublineCd2Gicls202(HashMap<String, Object> params) throws SQLException;
	String validateIssCd2Gicls202(HashMap<String, Object> params) throws SQLException;
	String validateLineCdGicls202(String lineCd)  throws SQLException;
	String validateSublineCdGicls202(HashMap<String, Object> params) throws SQLException;
	String validateIssCdGicls202(String issCd) throws SQLException;
	String validateLossCatCdGicls202(HashMap<String, Object> params) throws SQLException;
	String validatePerilCdGicls202(HashMap<String, Object> params) throws SQLException;
	String validateIntmNoGicls202(BigDecimal intmNo) throws SQLException;
	String validateControlTypeCdGicls202(Integer controlTypeCd) throws SQLException;
	Map<String, Object> printGicls202(Integer repName, String userId) throws SQLException;

}
