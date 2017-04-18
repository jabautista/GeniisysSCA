package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLFireDtlDAO;
import com.geniisys.gicl.dao.GICLItemPerilDAO;
import com.geniisys.gicl.entity.GICLFireDtl;
import com.geniisys.gicl.entity.GICLItemPeril;
import com.geniisys.gicl.service.GICLFireDtlService;
import com.seer.framework.util.StringFormatter;

public class GICLFireDtlServiceImpl implements GICLFireDtlService{

	private GICLFireDtlDAO giclFireDtlDAO;
	
	public GICLFireDtlDAO getGiclFireDtlDAO(){
		return giclFireDtlDAO;
	}
	
	public void setGiclFireDtlDAO(GICLFireDtlDAO giclFireDtlDAO){
		this.giclFireDtlDAO = giclFireDtlDAO;
	}

	private GICLItemPerilDAO giclItemPerilDAO;
	
	public void setGiclItemPerilDAO(GICLItemPerilDAO giclItemPerilDAO){
		this.giclItemPerilDAO = giclItemPerilDAO;
	}
	
	public GICLItemPerilDAO getGiclItemPerilDAO(){
		return this.giclItemPerilDAO;
	}
	
	@Override
	public void getGiclFireDtlGrid(HttpServletRequest request, GIISUser USER, ApplicationContext APPLICATION_CONTEXT)
			throws SQLException, JSONException {
		GIISParameterFacadeService paramService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiclFireDtlGrid");
		params.put("pageSize", 5);
		params.put("userId", USER.getUserId());
		params.put("claimId", request.getParameter("claimId"));
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("giclFireDtl", grid);
		request.setAttribute("object", grid);
		request.setAttribute("showClaimStat", "Y");
		request.setAttribute("ora2010Sw", paramService.getParamValueV2("ORA2010_SW"));
		request.setAttribute("vLocLoss", paramService.getParamValueV2("VALIDATE LOCATION OF LOSS"));
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
		params = this.giclFireDtlDAO.validateClmItemNo(params);
		params.put("row", params.get("row") != null ? StringFormatter.escapeHTMLInList((List<GICLFireDtl>) params.get("row")) :"[]");
		return new JSONObject(params).toString();
	}

	@Override
	public String saveClmItemFire(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException, ParseException {
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
		params.put("giclFireDtlSetRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("itemSetRows")), USER.getUserId(), GICLFireDtl.class));
		params.put("giclFireDtlDelRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("itemDelRows")), USER.getUserId(), GICLFireDtl.class));
		params.put("giclItemPerilSetRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("perilSetRows")), USER.getUserId(), GICLItemPeril.class));
		params.put("giclItemPerilDelRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("perilDelRows")), USER.getUserId(), GICLItemPeril.class));
		
		return new JSONObject((Map<String, Object>) StringFormatter.escapeHTMLInMap(this.giclFireDtlDAO.saveClmItemFire(params))).toString();
	}

	@Override
	public String getGiclFireDtlExist(String claimId) throws SQLException {
		return this.giclFireDtlDAO.getGiclFireDtlExist(claimId);
	}

}
