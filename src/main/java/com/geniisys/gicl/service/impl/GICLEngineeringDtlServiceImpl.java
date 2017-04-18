package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLEngineeringDtlDAO;
import com.geniisys.gicl.entity.GICLEngineeringDtl;
import com.geniisys.gicl.entity.GICLItemPeril;
import com.geniisys.gicl.service.GICLEngineeringDtlService;
import com.seer.framework.util.StringFormatter;

public class GICLEngineeringDtlServiceImpl implements GICLEngineeringDtlService {
	
	/** The DAO **/
	private GICLEngineeringDtlDAO giclEngineeringDtlDAO;

	public void setGiclEngineeringDtlDAO(GICLEngineeringDtlDAO giclEngineeringDtlDAO) {
		this.giclEngineeringDtlDAO = giclEngineeringDtlDAO;
	}

	public GICLEngineeringDtlDAO getGiclEngineeringDtlDAO() {
		return giclEngineeringDtlDAO;
	}
	
	/** The Logger **/
	private Logger log = Logger.getLogger(GICLEngineeringDtlServiceImpl.class);

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLEngineeringDtlService#loadEngineeringItemInfoItems(java.util.Map)
	 */
	@Override
	public void loadEngineeringItemInfoItems(Map<String, Object> params)
			throws SQLException {
		log.info("loadEngineeringItemInfoItems");
		this.getGiclEngineeringDtlDAO().loadEngineeringItemInfoItems(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLEngineeringDtlService#getGiclEngineeringDtlGrid(javax.servlet.http.HttpServletRequest, com.geniisys.common.entity.GIISUser, org.springframework.context.ApplicationContext)
	 */
	@Override
	public void getGiclEngineeringDtlGrid(HttpServletRequest request,
			GIISUser USER, ApplicationContext APPLICATION_CONTEXT)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiclEngineeringDtlGrid");
		params.put("pageSize", 5);
		params.put("userId", USER.getUserId());
		params.put("claimId", request.getParameter("claimId"));
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.escapeHTMLInMap(params)).toString(); //edited by steven from:replaceQuotesInMap  to:escapeHTMLInMap
		request.setAttribute("giclEngineeringDtl", grid);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLEngineeringDtlService#saveClmItemEngineering(javax.servlet.http.HttpServletRequest, com.geniisys.common.entity.GIISUser)
	 */
	@Override
	public String saveClmItemEngineering(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		JSONObject objParams = new JSONObject(request.getParameter("parameters"));
		DateFormat date = new SimpleDateFormat("MM-dd-yyyy");
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("claimId", request.getParameter("claimId"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("polIssCd", request.getParameter("polIssCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("polEffDate", request.getParameter("polEffDate") == null || "".equals(request.getParameter("polEffDate")) ? null :date.parse(request.getParameter("polEffDate")));
		params.put("expiryDate", request.getParameter("expiryDate") == null || "".equals(request.getParameter("expiryDate")) ? null :date.parse(request.getParameter("expiryDate")));
		params.put("lossDate", request.getParameter("lossDate") == null || "".equals(request.getParameter("lossDate")) ? null :date.parse(request.getParameter("lossDate")));
		params.put("giclEngineeringDtlSetRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("itemSetRows")), USER.getUserId(), GICLEngineeringDtl.class));
		params.put("giclEngineeringDtlDelRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("itemDelRows")), USER.getUserId(), GICLEngineeringDtl.class));
		params.put("giclItemPerilSetRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("perilSetRows")), USER.getUserId(), GICLItemPeril.class));
		params.put("giclItemPerilDelRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("perilDelRows")), USER.getUserId(), GICLItemPeril.class));
		
		return new JSONObject((Map<String, Object>) StringFormatter.escapeHTMLInMap(this.giclEngineeringDtlDAO.saveClmItemEngineering(params))).toString();
	}

	@SuppressWarnings("unchecked")
	@Override
	public String validateClmItemNo(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException, ParseException {
		DateFormat date = new SimpleDateFormat("MM-dd-yyyy");
		Map<String, Object> params = new HashMap<String, Object>(); 
		params.put("userId", USER.getUserId());
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("polIssCd", request.getParameter("polIssCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("polEffDate", request.getParameter("polEffDate") == null || "".equals(request.getParameter("polEffDate")) ? null :date.parse(request.getParameter("polEffDate")));
		params.put("expiryDate", request.getParameter("expiryDate") == null || "".equals(request.getParameter("expiryDate")) ? null :date.parse(request.getParameter("expiryDate")));
		params.put("lossDate", request.getParameter("lossDate") == null || "".equals(request.getParameter("lossDate")) ? null :date.parse(request.getParameter("lossDate")));
		params.put("inceptDate", request.getParameter("inceptDate") == null || "".equals(request.getParameter("inceptDate")) ? null :date.parse(request.getParameter("inceptDate")));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("claimId", request.getParameter("claimId"));
		params.put("from", request.getParameter("from"));
		params.put("to", request.getParameter("to"));
		params = this.giclEngineeringDtlDAO.validateClmItemNo(params);
		params.put("row", params.get("row") != null ? StringFormatter.escapeHTMLInList((List<GICLEngineeringDtl>) params.get("row")) :"[]");
		return new JSONObject(params).toString();
	}
}
