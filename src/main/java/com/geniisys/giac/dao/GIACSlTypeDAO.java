package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.Map;


public interface GIACSlTypeDAO {

	void valDeleteSlType(String slTypeCd) throws SQLException;
	void saveGiacs308(Map<String, Object> params) throws SQLException;
	void valAddSlType(String parameter) throws SQLException;
	
}
