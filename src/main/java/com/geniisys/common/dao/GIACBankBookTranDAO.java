package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIACBankBookTranDAO {
	void valAddRec(Map<String, Object> params) throws SQLException;
	void saveGiacs324(Map<String, Object> params) throws SQLException;
	void valBookTranCd(Map<String, Object> params) throws SQLException;
}
