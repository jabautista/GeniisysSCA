package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.giac.entity.GIACAdvancedPayt;

public interface GIACAdvancedPaytDAO {

	void setGIACAdvancedPayt(GIACAdvancedPayt giacAdvancedPaytDtls) throws SQLException;
	
	void deleteGIACAdvancedPayt(GIACAdvancedPayt giacAdvancedPayt) throws SQLException;
	
	void deleteGIACAdvancedPayt(Map<String, Object> params) throws SQLException;
	
}
