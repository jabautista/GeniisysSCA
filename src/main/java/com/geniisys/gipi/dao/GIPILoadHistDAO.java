package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.entity.GIPILoadHist;

public interface GIPILoadHistDAO {

	List<GIPILoadHist> getGipiLoadHist() throws SQLException;
	String createToPar(String uploadNo, Integer parId, Integer itemNo,
			String polId, String lineCd, String issCd, String userId)  throws SQLException;
	List<Map<String, Object>> getUploadedEnrollees(Map<String, Object> params) throws SQLException;  //created by christian 04/29/2013
}
