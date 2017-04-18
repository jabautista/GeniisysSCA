package com.geniisys.giuw.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.giuw.entity.GIUWDistBatch;
import com.geniisys.giuw.entity.GIUWPolDist;
import com.geniisys.giuw.entity.GIUWPolDistPolbasicV;

public interface GIUWDistBatchService {
	
	GIUWDistBatch getGIUWDistBatch(Map<String, Object> params) throws SQLException;
	String saveBatchDistribution(String parameters, GIISUser USER) throws SQLException, JSONException, Exception;
	void saveBatchDistributionShare(String parameters, GIISUser USER, Integer batchId) throws SQLException, JSONException, Exception;
	
	List<GIUWPolDistPolbasicV> getPoliciesByBatchId(HttpServletRequest request, String userId) throws SQLException;
	JSONObject updatePolicyDistShare(List<GIUWPolDist> polDistList, String params) throws SQLException, JSONException, ParseException;
	JSONArray getPoliciesByParam(HttpServletRequest request, String userId) throws SQLException, JSONException;
}
