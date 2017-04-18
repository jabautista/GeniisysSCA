package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONObject;

import com.geniisys.gipi.entity.GIPILoadHist;

public interface GIPILoadHistService {

	List<GIPILoadHist> getGipiLoadHist() throws SQLException;
	String createToPar(String uploadNo,Integer parId, Integer itemNo, String polId, String lineCd, String issCd, String userId) throws SQLException;
	List<Map<String, Object>> getUploadedEnrollees(HttpServletRequest request) throws SQLException; //created by christian 04/29/2013
}
