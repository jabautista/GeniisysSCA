package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.Map;


public interface GIACOucsDAO {

	void saveGiacs305(Map<String, Object> params) throws SQLException;
	void valDeleteOuc(Integer oucId) throws SQLException;
	void valAddOuc(Integer oucCd) throws SQLException;
		
}
