/**
 * 
 */
package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACCreditAndCollectionUtilitiesDAO;
import com.geniisys.giac.service.GIACCreditAndCollectionUtilitiesService;
import com.seer.framework.util.StringFormatter;

/**
 * @author steven
 *
 */
public class GIACCreditAndCollectionUtilitiesServiceImpl implements GIACCreditAndCollectionUtilitiesService{
	
	private GIACCreditAndCollectionUtilitiesDAO giacCreditAndCollectionUtilitiesDAO;

	/**
	 * @return the giacCreditAndCollectionUtilitiesDAO
	 */
	public GIACCreditAndCollectionUtilitiesDAO getGiacCreditAndCollectionUtilitiesDAO() {
		return giacCreditAndCollectionUtilitiesDAO;
	}

	/**
	 * @param giacCreditAndCollectionUtilitiesDAO the giacCreditAndCollectionUtilitiesDAO to set
	 */
	public void setGiacCreditAndCollectionUtilitiesDAO(
			GIACCreditAndCollectionUtilitiesDAO giacCreditAndCollectionUtilitiesDAO) {
		this.giacCreditAndCollectionUtilitiesDAO = giacCreditAndCollectionUtilitiesDAO;
	}
	
	@Override
	public JSONObject showCancelledPolicies(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIACS412Record");
		params.put("userId", USER.getUserId());
		Map<String, Object> cancelledPolMap = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonCancelledPol = new JSONObject(cancelledPolMap);
		return jsonCancelledPol;
	}

	@Override
	public JSONObject showEndorsement(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIACS412EndorsementRecord");
		params.put("userId", USER.getUserId());
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		Map<String, Object> endorsementMap = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonEndorsement = new JSONObject(endorsementMap);
		return jsonEndorsement;
	}

	@Override
	public List<Map<String, Object>> getAllCancelledPol(
			HttpServletRequest request, GIISUser USER) throws SQLException,
			Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		return getGiacCreditAndCollectionUtilitiesDAO().getAllCancelledPol(params);
	}
	
	@Override
	public void processCancelledPol(HttpServletRequest request, GIISUser USER)
			throws SQLException, Exception {
		JSONObject objParameters = new JSONObject(request.getParameter("param"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("cancelledPol", prepareCancelledPol(new JSONArray(objParameters.getString("cancelledPol")), USER.getUserId()));
		getGiacCreditAndCollectionUtilitiesDAO().processCancelledPol(params);
	}
	
	private List<Map<String, Object>> prepareCancelledPol(JSONArray setRows, String userId) throws JSONException, ParseException, SQLException {
		JSONObject json = null;
		List<Map<String, Object>> setCancelledPol = new ArrayList<Map<String, Object>>();
		for(int i = 0; i < setRows.length(); i++){
			json = setRows.getJSONObject(i);
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("cancellationTag", json.get("cancellationTag"));
			params.put("lineCd", json.get("lineCd"));
			params.put("sublineCd", json.get("sublineCd"));
			params.put("issCd", json.get("issCd"));
			params.put("issueYy", json.get("issueYy"));
			params.put("polSeqNo", json.get("polSeqNo"));
			params.put("renewNo", json.get("renewNo"));
			params.put("userId", userId);
			params.put("tranId", null);
			setCancelledPol.add(params);
		}
		return setCancelledPol;
	}

	@Override
	public void ageBills(HttpServletRequest request, String userId) throws SQLException, Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("cutOffDate", request.getParameter("cutOffDate"));
		params.put("direct", request.getParameter("direct"));
		params.put("reinsurance", request.getParameter("reinsurance"));
		params.put("userId", userId);
		getGiacCreditAndCollectionUtilitiesDAO().ageBills(params);
	}
	
	@SuppressWarnings("unchecked")	// start FGIC SR-4266 : shan 05.21.2015
	public JSONArray getPoliciesForReverseByParam(HttpServletRequest request, String userId) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		
		JSONObject filterByJson = new JSONObject(request.getParameter("filterBy"));
		Iterator<String> iter = filterByJson.keys();
		
		while(iter.hasNext()){
			String key = iter.next().toString();
			params.put(key, filterByJson.get(key));
		}

		
		System.out.println("PARAMS: == " + params.toString());
		List<Map<String, Object>> polForReverse = (List<Map<String, Object>>) StringFormatter.escapeHTMLInList(this.giacCreditAndCollectionUtilitiesDAO.getPoliciesForReverseByParam(params));		
		
		return new JSONArray(polForReverse);
	}
	
	public void reverseProcessedPolicies(HttpServletRequest request, String userId) throws SQLException, Exception{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("taggedRecords", JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("taggedRecords"))));
		
		this.giacCreditAndCollectionUtilitiesDAO.reverseProcessedPolicies(params);
	}	// end FGIC SR-4266 : shan 05.21.2015
}
