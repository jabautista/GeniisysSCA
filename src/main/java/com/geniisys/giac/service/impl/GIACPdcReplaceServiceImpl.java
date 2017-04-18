package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACPdcReplaceDAO;
import com.geniisys.giac.entity.GIACPdcReplace;
import com.geniisys.giac.service.GIACPdcReplaceService;
import com.seer.framework.util.StringFormatter;

public class GIACPdcReplaceServiceImpl implements GIACPdcReplaceService{
	
	private GIACPdcReplaceDAO giacPdcReplaceDAO;
	
	private static Logger log = Logger.getLogger(GIACPdcReplaceServiceImpl.class);

	public GIACPdcReplaceDAO getGiacPdcReplaceDAO() {
		return giacPdcReplaceDAO;
	}

	public void setGiacPdcReplaceDAO(GIACPdcReplaceDAO giacPdcReplaceDAO) {
		this.giacPdcReplaceDAO = giacPdcReplaceDAO;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACPdcReplaceService#getPdcRepDtls(java.util.HashMap)
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getPdcRepDtls(Map<String, Object> params) 
		throws SQLException, JSONException {
		log.info("getPdcRepDtls");
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("filter", this.preparePdcReplaceFilter(params.get("filter") == null ? null : params.get("filter").toString()));
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<GIACPdcReplace>  list = this.giacPdcReplaceDAO.getPdcRepDtls(params);
		params.put("rows", new JSONArray((List<GIACPdcReplace>) StringFormatter.replaceQuotesInList(list)));
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}
	
	/**
	 * 
	 * @param filter
	 * @return
	 * @throws JSONException
	 */
	private Map<String, Object> preparePdcReplaceFilter(String filter) throws JSONException{
		Map<String, Object> pdcReplaceMap = new HashMap<String, Object>();
		JSONObject jsonFilter = null;
		
		if (filter == null){
			jsonFilter = new JSONObject();
		} else {
			jsonFilter = new JSONObject(filter);
		}
		pdcReplaceMap.put("payMode", jsonFilter.isNull("payMode") ? "%%" : '%'+jsonFilter.getString("payMode").toUpperCase()+'%');
		pdcReplaceMap.put("bankSname", jsonFilter.isNull("bankCd") ? "%%" : '%'+jsonFilter.getString("bankCd").toUpperCase()+'%');
		pdcReplaceMap.put("checkClass", jsonFilter.isNull("checkClass") ? "%%" : '%'+jsonFilter.getString("checkClass").toUpperCase()+'%');
		pdcReplaceMap.put("checkDate", jsonFilter.isNull("checkDate") ? "%%" : '%'+jsonFilter.getString("checkDate").toUpperCase()+'%');
		pdcReplaceMap.put("amount", jsonFilter.isNull("amount") ? "%%" : '%'+jsonFilter.getString("amount")+'%');
		pdcReplaceMap.put("currencyCd", jsonFilter.isNull("currencyCd") ? "%%" : '%'+jsonFilter.getString("currencyCd").toUpperCase()+'%');
		pdcReplaceMap.put("refNo", jsonFilter.isNull("refNo") ? "%%" : '%'+jsonFilter.getString("refNo")+'%');
		
		return pdcReplaceMap;
	}

	@Override
	public void saveGIACPdcReplace(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACPdcReplace.class));
		this.giacPdcReplaceDAO.saveGIACPdcReplace(params);
	}

}
