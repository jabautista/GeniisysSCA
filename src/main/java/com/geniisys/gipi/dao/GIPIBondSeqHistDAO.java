package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface GIPIBondSeqHistDAO {

	List<Integer> getBondSeqNoList(Map<String, Object> param) throws SQLException;
	void updBondSeqHist(Map<String, Object> param) throws SQLException;
	Integer validateBondSeq(Map<String, Object> param) throws SQLException;
}
