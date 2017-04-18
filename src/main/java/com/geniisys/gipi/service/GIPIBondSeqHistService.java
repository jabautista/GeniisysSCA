package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface GIPIBondSeqHistService {

	List<Integer> getBondSeqNoList(Map<String, Object> param) throws SQLException;
	void updBondSeqHist(Map<String, Object> param) throws SQLException;
	boolean isValidBondSeq(Map<String, Object> param) throws SQLException; 
}
