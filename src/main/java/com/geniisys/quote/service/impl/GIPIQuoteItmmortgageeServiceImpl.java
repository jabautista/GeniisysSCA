package com.geniisys.quote.service.impl;

import com.geniisys.quote.dao.GIPIQuoteItmmortgageeDAO;
import com.geniisys.quote.service.GIPIQuoteItmmortgageeService;

public class GIPIQuoteItmmortgageeServiceImpl implements GIPIQuoteItmmortgageeService{

	private GIPIQuoteItmmortgageeDAO gipiQuoteItmmortgageeDAO;

	public GIPIQuoteItmmortgageeDAO getGipiQuoteItmmortgageeDAO() {
		return gipiQuoteItmmortgageeDAO;
	}

	public void setGipiQuoteItmmortgageeDAO(GIPIQuoteItmmortgageeDAO gipiQuoteItmmortgageeDAO) {
		this.gipiQuoteItmmortgageeDAO = gipiQuoteItmmortgageeDAO;
	}
	
	//@Override
	/*public String savePerilInfo(String rowParams, Map<String, Object> params)
			throws JSONException, SQLException {
		JSONObject objParameters = new JSONObject(rowParams);
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), (String)params.get("userId"), GIPIQuoteItmperil.class));
		allParams.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("delRows")), (String)params.get("userId"), GIPIQuoteItmperil.class));
		return this.getGipiQuoteItmperilDAO().savePerilInfo(allParams, params);
	}

	@Override
	public List<GIPIQuoteItmperil> getItmperils(Map<String, Object> params)
			throws SQLException {
		return this.getGipiQuoteItmperilDAO().getItmperils(params);
	}*/
	
}
