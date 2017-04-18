package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIACUpdateCheckStatusDAO {

	void saveChkDisbursement(Map<String, Object> params)throws SQLException,Exception;

}
