package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.entity.GIACPdcReplace;

public interface GIACPdcReplaceDAO {

	List<GIACPdcReplace> getPdcRepDtls(Map<String, Object> params) throws SQLException;
	void saveGIACPdcReplace(Map<String, Object> params) throws SQLException;
	
}
