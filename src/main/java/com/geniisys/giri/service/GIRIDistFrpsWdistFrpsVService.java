package com.geniisys.giri.service;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.giri.entity.GIRIDistFrpsWdistFrpsV;

public interface GIRIDistFrpsWdistFrpsVService {
	GIRIDistFrpsWdistFrpsV getWdistFrpsVDtls (Map<String, Object> params) throws SQLException;
}
