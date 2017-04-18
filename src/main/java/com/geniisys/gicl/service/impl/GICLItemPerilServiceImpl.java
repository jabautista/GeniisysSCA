package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLItemPerilDAO;
import com.geniisys.gicl.entity.GICLItemPeril;
import com.geniisys.gicl.service.GICLItemPerilService;
import com.seer.framework.util.StringFormatter;

public class GICLItemPerilServiceImpl implements GICLItemPerilService{

	private GICLItemPerilDAO giclItemPerilDAO;
	
	public void setGiclItemPerilDAO(GICLItemPerilDAO giclItemPerilDAO){
		this.giclItemPerilDAO = giclItemPerilDAO;
	}
	
	public GICLItemPerilDAO getGiclItemPerilDAO(){
		return this.giclItemPerilDAO;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLItemPerilService#getGiclItemPerilGrid(javax.servlet.http.HttpServletRequest, com.geniisys.common.entity.GIISUser)
	 */
	@Override
	public void getGiclItemPerilGrid(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiclItemPerilGrid");
		params.put("userId", USER.getUserId());
		params.put("claimId", request.getParameter("claimId"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("lineCd", request.getParameter("lineCd"));
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("giclItemPeril", grid);
		request.setAttribute("object", grid);
	}

	@Override
	//public void getGiclItemPerilGrid2(HttpServletRequest request, GIISUser USER)
	public JSONObject getGiclItemPerilGrid2(HttpServletRequest request, GIISUser USER) // bonok :: 04.14.2014 :: fix for Item Information tablegrid sort
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiclItemPerilGrid2");
		params.put("claimId", request.getParameter("claimId"));
		params.put("lineCd", request.getParameter("lineCd"));
		params = TableGridUtil.getTableGrid(request, params);
		//String grid2 = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		//request.setAttribute("giclItemPeril2", grid2);
		
		// bonok :: 04.14.2014 :: fix for Item Information tablegrid sort
		JSONObject jsonItemList = new JSONObject(params);	
		return jsonItemList;
	}

	@Override
	public void setGiclItemPeril(Map<String, Object> params)
			throws SQLException {
		this.giclItemPerilDAO.setGiclItemPeril(params);
	}
	
	@Override
	public void delGiclItemPeril(Map<String, Object> params)
			throws SQLException {
		this.giclItemPerilDAO.delGiclItemPeril(params);
	}

	@Override
	public String checkAggPeril(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException, ParseException {
		DateFormat date = new SimpleDateFormat("MM-dd-yyyy");
		Map<String, Object> params = new HashMap<String, Object> ();
		params.put("userId", USER.getUserId());
		params.put("aggregateSw", request.getParameter("aggregateSw"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("polIssCd", request.getParameter("polIssCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("polEffDate", request.getParameter("polEffDate") == null || "".equals(request.getParameter("polEffDate")) ? null :date.parse(request.getParameter("polEffDate")));
		params.put("expiryDate", request.getParameter("expiryDate") == null || "".equals(request.getParameter("expiryDate")) ? null :date.parse(request.getParameter("expiryDate")));
		params.put("lossDate", request.getParameter("lossDate") == null || "".equals(request.getParameter("lossDate")) ? null :date.parse(request.getParameter("lossDate")));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("groupedItemNo", request.getParameter("groupedItemNo"));
		params.put("perilCd", request.getParameter("perilCd"));
		params.put("noOfDays", request.getParameter("noOfDays"));
		params.put("annTsiAmt", request.getParameter("annTsiAmt"));
		params = this.getGiclItemPerilDAO().checkAggPeril(params);
		return new JSONObject(params).toString();
	}

	@Override
	public String getGiclItemPerilDfltPayee(Map<String, Object> params)
			throws SQLException {
		return this.getGiclItemPerilDAO().getGiclItemPerilDfltPayee(params);
	}

	@Override
	public String checkPerilStatus(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", Integer.parseInt(request.getParameter("claimId")));
		params.put("perilCd", Integer.parseInt(request.getParameter("perilCd")));
		params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
		params.put("groupedItemNo", Integer.parseInt(request.getParameter("groupedItemNo")));
		params = this.getGiclItemPerilDAO().checkPerilStatus(params);
		return new JSONObject(params).toString();
	}

	@Override
	public GICLItemPeril getGICLS024ItemPeril(Integer claimId)
			throws SQLException {
		return this.getGiclItemPerilDAO().getGICLS024ItemPeril(claimId);
	}

	@Override
	public Integer checkIfGroupGICLS024(Integer claimId) throws SQLException {
		return this.getGiclItemPerilDAO().checkIfGroupGICLS024(claimId);
	}
}
