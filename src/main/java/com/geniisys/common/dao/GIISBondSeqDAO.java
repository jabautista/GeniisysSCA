package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISBondSeqDAO {
	
	Integer generateBondSeq(Map<String, Object> params, Integer noOfSequence) throws SQLException;
}
