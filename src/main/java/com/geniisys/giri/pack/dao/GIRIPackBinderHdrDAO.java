package com.geniisys.giri.pack.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIRIPackBinderHdrDAO {

	String savePackageBinderHdr(Map<String, Object> params) throws SQLException;

}
