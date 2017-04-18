/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.service.impl
	File Name: GICLMotorCarDtlServiceImpl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Aug 24, 2011
	Description: 
*/


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
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLMotorCarDtlDAO;
import com.geniisys.gicl.entity.GICLItemPeril;
import com.geniisys.gicl.entity.GICLMcTpDtl;
import com.geniisys.gicl.entity.GICLMotorCarDtl;
import com.geniisys.gicl.service.GICLMotorCarDtlService;
import com.seer.framework.util.StringFormatter;
import com.geniisys.common.service.GIISParameterFacadeService;

public class GICLMotorCarDtlServiceImpl implements GICLMotorCarDtlService{

	private GICLMotorCarDtlDAO giclMotorCarDtlDAO;
	@Override
	public void getGICLMotorCarDtlGrid(HttpServletRequest request, GIISUser USER, ApplicationContext APPLICATION_CONTEXT)
			throws SQLException, JSONException {
		// Added paramService by J. Diago 10.11.2013 for ORA2010_SW
		GIISParameterFacadeService paramService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
		Map<String, Object>params = new HashMap<String, Object>();
		params.put("ACTION", "getMotorCarItemDtl");
		params.put("pageSize", 5);
		params.put("userId", USER.getUserId());
		params.put("claimId", request.getParameter("claimId"));
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("giclMotorCarDtlGrid", grid);
		request.setAttribute("giclMotorCarDtl", grid);
		request.setAttribute("ora2010Sw", paramService.getParamValueV2("ORA2010_SW"));
		request.setAttribute("showClaimStat", "Y");
	}
	/**
	 * @param giclMotorCarDtlDAO the giclMotorCarDtlDAO to set
	 */
	public void setGiclMotorCarDtlDAO(GICLMotorCarDtlDAO giclMotorCarDtlDAO) {
		this.giclMotorCarDtlDAO = giclMotorCarDtlDAO;
	}
	/**
	 * @return the giclMotorCarDtlDAO
	 */
	public GICLMotorCarDtlDAO getGiclMotorCarDtlDAO() {
		return giclMotorCarDtlDAO;
	}
	@Override
	public void getGiclMcTpDtl(HttpServletRequest request, GIISUser user)
			throws SQLException, JSONException {
		Map<String, Object>params = new HashMap<String, Object>();
		params.put("ACTION", "getGiclMcTpDtl");
		params.put("pageSize", 5);
		params.put("userId", user.getUserId());
		params.put("claimId", request.getParameter("claimId"));
		params.put("itemNo", request.getParameter("itemNo"));
		//params.put("payeeClassCd", request.getParameter("payeeClassCd"));
		//params.put("payeeNo", request.getParameter("payeeNo"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("giclMcTpDtlGrid", grid);
		request.setAttribute("object", grid);
		
	}
	@SuppressWarnings("unchecked")
	@Override
	public void saveMcTpDtl(String strParameters, String userId) throws SQLException,
			JSONException {
		JSONObject obj = new JSONObject(strParameters);
		List<GICLMcTpDtl> setRows = (List<GICLMcTpDtl>)JSONUtil.prepareObjectListFromJSON(new JSONArray(obj.getString("setRows")), userId, GICLMcTpDtl.class);
		List<GICLMcTpDtl> delRows = (List<GICLMcTpDtl>) JSONUtil.prepareObjectListFromJSON(new JSONArray(obj.getString("delRows")), userId, GICLMcTpDtl.class);
		List<GICLMcTpDtl> modRows = (List<GICLMcTpDtl>) JSONUtil.prepareObjectListFromJSON(new JSONArray(obj.getString("modRows")), userId, GICLMcTpDtl.class);
		Map<String, Object>params =  new HashMap<String, Object>();
		params.put("setRows", setRows);
		params.put("delRows", delRows);
		params.put("modRows", modRows);
		params.put("userId", userId);
		params.put("itemNo", obj.getString("itemNo"));
		params.put("claimId", obj.getString("claimId"));
		
		this.getGiclMotorCarDtlDAO().saveMcTpDtl(params);
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
		params = this.getGiclMotorCarDtlDAO().validateClmItemNo(params);
		params.put("row", params.get("row") != null ? StringFormatter.escapeHTMLInList((List<GICLMotorCarDtl>) params.get("row")) :"[]");
		return new JSONObject(params).toString();
	}
	@Override
	public String saveClmItemMotorCar(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException, ParseException {
		JSONObject objParams = new JSONObject(request.getParameter("parameters"));
		DateFormat date = new SimpleDateFormat("MM-dd-yyyy");
		System.out.println("String parameters: "+request.getParameter("parameters"));
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
		params.put("giclMotorCarDtlSetRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("itemSetRows")), USER.getUserId(), GICLMotorCarDtl.class));
		params.put("giclMotorCarDtlDelRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("itemDelRows")), USER.getUserId(), GICLMotorCarDtl.class));
		params.put("giclItemPerilSetRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("perilSetRows")), USER.getUserId(), GICLItemPeril.class));
		params.put("giclItemPerilDelRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("perilDelRows")), USER.getUserId(), GICLItemPeril.class));
		
		 return new JSONObject((Map<String, Object>) StringFormatter.escapeHTMLInMap(this.getGiclMotorCarDtlDAO().saveClmItemMotorCar(params))).toString();
	}
	@Override
	public String getTowAmount(Map<String, Object> params)
			throws SQLException {
		return this.getGiclMotorCarDtlDAO().getTowAmount(params);
	}
	@Override
	public void getGICLS268MotorCarDetail(HttpServletRequest request) throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("claimId", request.getParameter("claimId"));
		params.put("vehicleType", request.getParameter("vehicleType"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		
		System.out.println("PARAMS IN SERVICE : " + params);
		
		request.setAttribute("vehicleInfo", giclMotorCarDtlDAO.getGICLS268MotorCarDetail(params));
	}
	@Override
	public GICLMcTpDtl getGICLS260McTpOtherDtls(Map<String, Object> params)
			throws SQLException {
		GICLMcTpDtl mcTpDtl = this.getGiclMotorCarDtlDAO().getGICLS260McTpOtherDtls(params);
		if(mcTpDtl == null){
			return new GICLMcTpDtl();
		}else{
			return this.getGiclMotorCarDtlDAO().getGICLS260McTpOtherDtls(params);
		}
	}

}
