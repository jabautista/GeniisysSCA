package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GICLEvalDeductiblesDAO {
	String saveGiclEvalDeductibles(Map<String, Object> params) throws SQLException, Exception;
	void applyDeductiblesForMcEval(Map<String, Object> params) throws SQLException, Exception;
}
