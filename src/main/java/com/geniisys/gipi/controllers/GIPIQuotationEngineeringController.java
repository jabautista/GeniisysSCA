/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISParameter;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.gipi.entity.GIPIQuote;
import com.geniisys.gipi.entity.GIPIQuoteItemEN;
import com.geniisys.gipi.entity.GIPIQuotePrincipal;
import com.geniisys.gipi.service.GIPIQuoteFacadeService;
import com.geniisys.gipi.service.GIPIQuoteItemENService;
import com.geniisys.gipi.service.GIPIQuotePrincipalService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIQuotationEngineeringController.
 */
public class GIPIQuotationEngineeringController extends BaseController {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -1619422095584522160L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIQuotationEngineeringController.class);
	
	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException { //, String env
		try {
			/*default attributes*/
			log.info("Initializing: "+ this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			/*end of default attributes*/
			
			/* Define Services needed */
			GIPIQuoteFacadeService serv = (GIPIQuoteFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteFacadeService"); // +env
			GIPIQuoteItemENService enService = (GIPIQuoteItemENService) APPLICATION_CONTEXT.getBean("gipiQuoteItemENService"); // +env
			
			int quoteId = Integer.parseInt((request.getParameter("quoteId") == null) ? "0" : request.getParameter("quoteId"));
			GIPIQuote gipiQuote = null;
			if (quoteId != 0)	{
				gipiQuote = serv.getQuotationDetailsByQuoteId(quoteId);
				gipiQuote.setQuoteId(quoteId);
				request.setAttribute("gipiQuote", gipiQuote);
			}
			
			if ("showEngineeringAdditionalInformation".equals(ACTION)) {
				request.setAttribute("aiItemNo", request.getParameter("itemNo"));
				request.setAttribute("inceptDate", request.getParameter("inceptDate"));
				request.setAttribute("expiryDate", request.getParameter("expiryDate"));
				GIPIQuoteItemEN en = enService.getGIPIQuoteItemENDetails(quoteId, Integer.parseInt(request.getParameter("itemNo").equals("") ? "0" : request.getParameter("itemNo")));
				
				if(en != null){
					en.setContractProjBussTitle(toHtmlSpecialCharacters(en.getContractProjBussTitle())); // prevents page from displaying values outside of the text field
					en.setSiteLocation(toHtmlSpecialCharacters(en.getSiteLocation()));
				}
				
				request.setAttribute("quoteItemEN", en);
				PAGE = "/pages/marketing/quotation/pop-ups/engineeringAdditionalInformation.jsp";
			} else if ("showEnAdditionalInfo".equals(ACTION)) {
				
				
				PAGE = "/pages/marketing/quotation/subPages/quotationInformation/engineeringAdditionalInformation.jsp";
			} else if ("showEngineeringBasicInfo".equals(ACTION)){
				GIPIQuote gipiQuoteById = serv.getQuotationDetailsByQuoteId(Integer.parseInt(request.getParameter("quoteId")));
				GIPIQuoteItemEN itemENdtls = enService.getGIPIQuoteItemENDetails(Integer.parseInt(request.getParameter("quoteId")), 1);
				GIISParameterFacadeService giisParameterService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				request.setAttribute("lineName", gipiQuote.getLineName());
				request.setAttribute("itemENDtls", StringFormatter.escapeHTMLInObject(itemENdtls)); //added escapeHTMLInObject christian 03/07/2013
				request.setAttribute("quoteDtls", StringFormatter.escapeHTMLInObject(gipiQuoteById)); //added escapeHTMLInObject christian 03/07/2013
				request.setAttribute("quoteId", request.getParameter("quoteId"));
				request.setAttribute("engParamSublineCd", giisParameterService.getEngineeringParameterizedSubline(gipiQuoteById.getSublineName()));
				request.setAttribute("varsSubline", new JSONObject(StringFormatter.escapeHTMLInMap(this.initializeSublineCd(APPLICATION_CONTEXT)))); //robert 9.20.2012
				PAGE = "/pages/marketing/quotation/engineeringBasicInformation.jsp";
			}else if ("saveENInformation".equals(ACTION)) {
				System.out.println("QUOTE_ID: " + request.getParameter("quoteId"));
				DateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
				GIPIQuoteItemEN gipiQuoteItemEN = new GIPIQuoteItemEN();
				gipiQuoteItemEN.setQuoteId(Integer.parseInt(request.getParameter("quoteId")));
				gipiQuoteItemEN.setEnggBasicInfoNum(Integer.parseInt(request.getParameter("enggBasicInfoNum")));
				gipiQuoteItemEN.setContractProjBussTitle(request.getParameter("contractProjBussTitle"));
				gipiQuoteItemEN.setSiteLocation(request.getParameter("siteLocation"));
				gipiQuoteItemEN.setConstructStartDate(request.getParameter("constructStartDate") == "" ? null : sdf.parse(request.getParameter("constructStartDate")));
				gipiQuoteItemEN.setConstructEndDate(request.getParameter("constructEndDate") == "" ? null : sdf.parse(request.getParameter("constructEndDate")));
				gipiQuoteItemEN.setMaintainStartDate(request.getParameter("maintainStartDate") == "" ? null : sdf.parse(request.getParameter("maintainStartDate")));
				gipiQuoteItemEN.setMaintainEndDate(request.getParameter("maintainEndDate") == "" ? null : sdf.parse(request.getParameter("maintainEndDate")));
				gipiQuoteItemEN.setWeeksTest(request.getParameter("weeksTest") == "" ? null : Integer.parseInt(request.getParameter("weeksTest")));
				gipiQuoteItemEN.setTimeExcess(request.getParameter("timeExcess") == "" ? null : Integer.parseInt(request.getParameter("timeExcess")));
				gipiQuoteItemEN.setMbiPolicyNo(request.getParameter("mbiPolicyNo"));
				gipiQuoteItemEN.setAppUser(USER.getUserId());
				
				enService.saveGIPIQuoteItemEN2(gipiQuoteItemEN, request.getParameter("parameters"));
				
				message =  "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if ("showPrincipalListing".equals(ACTION)){
				GIPIQuotePrincipalService principalService = (GIPIQuotePrincipalService) APPLICATION_CONTEXT.getBean("gipiQuotePrincipalService"); 
				LOVHelper helper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
				String[] param = {request.getParameter("pType"), gipiQuote.getSublineCd()}; //added subline cd for filter christian 09.28.2012
				
				List<LOV> principalList = helper.getList(LOVHelper.PRINCIPAL_LISTING, param);
				System.out.println("size" + principalList.size());
				StringFormatter.replaceQuotesInList(principalList);
				request.setAttribute("principalList", new JSONArray(principalList));
				request.setAttribute("pType", request.getParameter("pType"));
				
				System.out.println("QUOTEID: " + quoteId + " pTYPE: " + request.getParameter("pType"));
				List<GIPIQuotePrincipal> gipiQuotePrincipal = principalService.getPrincipalList(quoteId, request.getParameter("pType"));
				System.out.println("size2 " + gipiQuotePrincipal.size());
				StringFormatter.replaceQuotesInList(gipiQuotePrincipal);
				request.setAttribute("principalListingJSON", new JSONArray(gipiQuotePrincipal));
				
				PAGE = "/pages/marketing/quotation/pop-ups/enPopUps/enPrincipalList.jsp";
			}else if("showENInfoForPackQuote".equals(ACTION)){
				GIISParameterFacadeService giisParameterService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				Integer packQuoteId = request.getParameter("packQuoteId")== null ? 0 : Integer.parseInt(request.getParameter("packQuoteId"));
				List<GIPIQuote> packQuoteList = serv.getPackQuoteListForENInfo(packQuoteId);
				List<GIPIQuoteItemEN> packQuoteENDetailList = enService.getQuoteENDetailsForPackQuotation(packQuoteList);
				List<GIISParameter> enSublineParams = giisParameterService.getAllENParamSublineNames();
				StringFormatter.escapeHTMLInList(packQuoteList);
				StringFormatter.escapeHTMLInList(packQuoteENDetailList);
				request.setAttribute("objPackQuoteList", new JSONArray(packQuoteList));
				request.setAttribute("objQuoteENDetailList", new JSONArray(packQuoteENDetailList));
				request.setAttribute("objENSublineParams", new JSONArray(enSublineParams));
				request.setAttribute("packQuoteList", packQuoteList);
				PAGE = "/pages/marketing/quotation-pack/quotationEngineeringInformation-pack/packQuotationEngineeringInfoMain.jsp";
			}else if("saveENInfoForPackQuote".equals(ACTION)){
				Map<String,Object> params = new HashMap<String, Object>();
				JSONObject objParam = new JSONObject(request.getParameter("parameters"));
				JSONArray setENRows = new JSONArray(objParam.isNull("setENDetailsRows") ? null : objParam.getString("setENDetailsRows"));
				JSONArray delENRows = new JSONArray(objParam.isNull("delENDetailsRows") ? null : objParam.getString("delENDetailsRows"));
				JSONArray setPrincRows = new JSONArray(objParam.isNull("setPrincipalRows") ? null : objParam.getString("setPrincipalRows"));
				JSONArray delPrincRows = new JSONArray(objParam.isNull("delPrincipalRows") ? null : objParam.getString("delPrincipalRows"));
				List<GIPIQuoteItemEN> setENDetailsRows = (List<GIPIQuoteItemEN>) JSONUtil.prepareObjectListFromJSON(setENRows, USER.getUserId(), GIPIQuoteItemEN.class);
				List<GIPIQuoteItemEN> delENDetailsRows = (List<GIPIQuoteItemEN>) JSONUtil.prepareObjectListFromJSON(delENRows, USER.getUserId(), GIPIQuoteItemEN.class);
				List<GIPIQuotePrincipal> setPrincipalRows = (List<GIPIQuotePrincipal>) JSONUtil.prepareObjectListFromJSON(setPrincRows, USER.getUserId(), GIPIQuotePrincipal.class);
				List<GIPIQuotePrincipal> delPrincipalRows = (List<GIPIQuotePrincipal>) JSONUtil.prepareObjectListFromJSON(delPrincRows, USER.getUserId(), GIPIQuotePrincipal.class);
				params.put("setENRows", setENDetailsRows);
				params.put("delENRows", delENDetailsRows);
				params.put("setPrincipalRows", setPrincipalRows);
				params.put("delPrincipalRows", delPrincipalRows);
				enService.saveGIPIQuoteENDetailsForPackQuote(params);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("showPrincipalPageForPackQuote".equals(ACTION)){
				GIPIQuotePrincipalService principalService = (GIPIQuotePrincipalService) APPLICATION_CONTEXT.getBean("gipiQuotePrincipalService"); 
				LOVHelper helper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
				Integer packQuoteId = request.getParameter("packQuoteId")== null ? 0 : Integer.parseInt(request.getParameter("packQuoteId"));
				String principalType = request.getParameter("pType")== null ? "" : request.getParameter("pType");
				String[] param = {principalType};
				List<LOV> principalList = helper.getList(LOVHelper.PRINCIPAL_LISTING, param);
				List<GIPIQuotePrincipal> packQuotePrincipal =  principalService.getPrincipalListForPackQuote(packQuoteId, principalType);
				StringFormatter.escapeHTMLInList(packQuotePrincipal);
				StringFormatter.replaceQuotesInList(principalList);
				request.setAttribute("principalList", new JSONArray(principalList));
				request.setAttribute("objQuotePrincipalList", new JSONArray(packQuotePrincipal));
				request.setAttribute("pType", request.getParameter("pType"));
				PAGE = "/pages/marketing/quotation-pack/quotationEngineeringInformation-pack/quotationPrincipalList.jsp";
			}
			
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
	
	/**
	 * Prevents page from displaying values outside of the text field
	 * @param quoted
	 * @return 
	 */
	private String toHtmlSpecialCharacters(String quoted){
		StringBuilder builder = new StringBuilder();

		if(quoted == null){
			return null;
		}
		
		char[] chArray = quoted.toCharArray();

		for(char ch: chArray){
			switch (ch) {
			case '"':
				builder.append("&quot;");
				break;
			case '\'':
				builder.append("&#39;");
				break;
			default:
				builder.append(ch);
				break;
			}
		}
		
		return builder.toString();
	}
	
	//robert 9.20.2012
	private Map<String, Object> initializeSublineCd(ApplicationContext appContext) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		GIISParameterFacadeService giisParametersService = (GIISParameterFacadeService) appContext.getBean("giisParameterFacadeService");
		params.put("sublineCar", giisParametersService.getParamValueV2("CONTRACTOR_ALL_RISK"));
		params.put("sublineEar", giisParametersService.getParamValueV2("ERECTION_ALL_RISK"));
		params.put("sublineMbi", giisParametersService.getParamValueV2("MACHINERY_BREAKDOWN_INSURANCE"));
		params.put("sublineMlop", giisParametersService.getParamValueV2("MACHINERY_LOSS_OF_PROFIT"));
		params.put("sublineDos", giisParametersService.getParamValueV2("DETERIORATION_OF_STOCKS"));
		params.put("sublineBpv", giisParametersService.getParamValueV2("BOILER_AND_PRESSURE_VESSEL"));
		params.put("sublineEei", giisParametersService.getParamValueV2("ELECTRONIC_EQUIPMENT"));
		params.put("sublinePcp", giisParametersService.getParamValueV2("PRINCIPAL_CONTROL_POLICY"));
		params.put("sublineOp", giisParametersService.getParamValueV2("OPEN_POLICY"));
		return params;
	}
	
}
