package com.geniisys.gipi.service.impl;

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
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIItemPerilDAO;
import com.geniisys.gipi.entity.GIPIItemPeril;
import com.geniisys.gipi.entity.GIPIVehicle;
import com.geniisys.gipi.service.GIPIItemPerilService;
import com.seer.framework.util.StringFormatter;

public class GIPIItemPerilServiceImpl implements GIPIItemPerilService{

	private GIPIItemPerilDAO gipiItemPerilDAO;
	private Logger log = Logger.getLogger(GIPIItemPerilServiceImpl.class);
	
	public void setGipiItemPerilDAO(GIPIItemPerilDAO gipiItemPerilDAO) {
		this.gipiItemPerilDAO = gipiItemPerilDAO;
	}

	public GIPIItemPerilDAO getGipiItemPerilDAO() {
		return gipiItemPerilDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIItemPerilService#getGIPIItemPerils(java.lang.Integer)
	 */
	@Override
	public List<GIPIItemPeril> getGIPIItemPerils (Integer parId) throws SQLException {
/*		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", lineCd);		params.put("sublineCd", sublineCd);		params.put("issCd", issCd);
		params.put("issueYy", issueYy);		params.put("polSeqNo", polSeqNo);		params.put("renewNo", renewNo);
		params.put("effDate", effDate);
*/
		log.info("Retrieving Item Peril/s...");
		List<GIPIItemPeril> perils = this.getGipiItemPerilDAO().getGIPIItemPerils(parId);
		log.info(perils.size() + " Item Peril/s retrieved.");
		
		return perils;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIItemPerilService#checkCompulsoryDeath(java.lang.Integer)
	 */
	@Override
 	public String checkCompulsoryDeath(Integer policyId) throws SQLException {
		return this.getGipiItemPerilDAO().checkCompulsoryDeath(policyId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIItemPerilService#getItemPerilCount(java.lang.Integer)
	 */
	@Override
	public Integer getItemPerilCount(Integer policyId) throws SQLException {
		return this.getGipiItemPerilDAO().getItemPerilCount(policyId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getItemPerils(HashMap<String, Object> params) throws SQLException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"),ApplicationWideParameters.PAGE_SIZE);//
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<GIPIItemPeril> perilList = this.getGipiItemPerilDAO().getItemPerils(params);
		params.put("rows", new JSONArray((List<GIPIVehicle>)StringFormatter.escapeHTMLInList(perilList)));
		grid.setNoOfPages(perilList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}

	@Override
	public JSONObject getGIPIS175Perils(HttpServletRequest request)
			throws JSONException, SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIPIS175Perils");
		params.put("policyId", request.getParameter("policyId"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("pageSize", 5);
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);
		JSONObject json = new JSONObject(map);
		return json;
	}
	
}