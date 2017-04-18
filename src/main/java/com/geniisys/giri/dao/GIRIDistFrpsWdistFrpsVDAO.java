package com.geniisys.giri.dao;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.giri.entity.GIRIDistFrpsWdistFrpsV;

public interface GIRIDistFrpsWdistFrpsVDAO {
	GIRIDistFrpsWdistFrpsV getWdistFrpsVDtls (Map<String, Object> params) throws SQLException;
}
