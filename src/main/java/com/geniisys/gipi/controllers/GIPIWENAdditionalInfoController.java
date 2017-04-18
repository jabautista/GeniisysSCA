package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISSubline;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.common.service.GIISSublineFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.entity.GIPIWEngBasic;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.gipi.entity.GIPIWPrincipal;
import com.geniisys.gipi.service.GIPIPARListService;
import com.geniisys.gipi.service.GIPIWEngBasicService;
import com.geniisys.gipi.service.GIPIWPolbasService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIPIWENAdditionalInfoController extends BaseController{

	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIPIWEngineeringItemController.class);

	@SuppressWarnings("unchecked")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("");
		try {
			ApplicationContext appContext = ApplicationContextReader.getServletContext(getServletContext());
			int parId = Integer.parseInt("".equals(request.getParameter("globalParId")) || request.getParameter("globalParId") == null ? "0" : request.getParameter("globalParId"));
			DateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
			
			 if ("showPackAdditionalENInfoPage".equals(ACTION)){
					GIPIPARListService gipiParListService = (GIPIPARListService) appContext.getBean("gipiPARListService");
					Integer packParId = Integer.parseInt(request.getParameter("packParId") == null ? "0" : request.getParameter("packParId"));				
					String packLineCd = request.getParameter("packLineCd");

					request.setAttribute("assdNo", request.getParameter("globalAssdNo"));
					request.setAttribute("assdName", request.getParameter("globalAssdName"));
					request.setAttribute("parNo", request.getParameter("globalPackParNo"));
					request.setAttribute("packLineCd", packLineCd);
					request.setAttribute("isPack", "Y");
					request.setAttribute("packParList", new JSONArray((List<GIPIPARList>) StringFormatter.escapeHTMLInList(gipiParListService.getPackItemParList(packParId, packLineCd)))); //added escapeHTMLInList christian 04/19/2013
					PAGE = "/pages/underwriting/packPar/packAdditionalEngineeringInfo/packAdditionalEngineeringInfoMain.jsp";
			} else if(parId == 0) {
				message = "PAR No. is empty";
				PAGE = "/pages/genericMessage.jsp";
			} else {
				GIPIWEngBasicService gipiWEngBasicService = (GIPIWEngBasicService) appContext.getBean("gipiWEngBasicService");
				
				GIPIWPolbasService gipiwPolbasService = (GIPIWPolbasService) appContext.getBean("gipiWPolbasService");
				GIPIWPolbas par = gipiwPolbasService.getGipiWPolbas(parId);
				
				LOVHelper helper = (LOVHelper)appContext.getBean("lovHelper");
				
				if("showAdditionalInfo".equals(ACTION)) {
					int curParId = Integer.parseInt(request.getParameter("globalParId"));
					GIPIWEngBasic enItem = gipiWEngBasicService.getWEngBasicInfo(curParId);
					GIISSublineFacadeService giisSubline = (GIISSublineFacadeService) appContext.getBean("giisSublineFacadeService");
					GIPIWPolbasService polbasService = (GIPIWPolbasService) appContext.getBean("gipiWPolbasService");
					GIISParameterFacadeService giisParameterService = (GIISParameterFacadeService) appContext.getBean("giisParameterFacadeService");
					
					String curSublineCd = par.getSublineCd();
					GIISSubline subline = giisSubline.getSublineDetails("EN", curSublineCd);
					
					request.setAttribute("parNo", request.getParameter("globalParNo"));
					request.setAttribute("assdName", StringFormatter.escapeHTML(request.getParameter("globalAssdName")));
					request.setAttribute("enSubline", curSublineCd);
					request.setAttribute("enSublineName", curSublineCd + " - " + subline.getSublineName());
					String policyNo = polbasService.getPolicyNoForEndt(parId);
					request.setAttribute("policyNo", policyNo);
					request.setAttribute("parType", (request.getParameter("globalParType") == null ? "" : request.getParameter("globalParType")));
									
					request.setAttribute("enInceptDate", sdf.format(par.getInceptDate()));
					request.setAttribute("enExpiryDate", sdf.format(par.getExpiryDate()));
					//Added by tonio Jan 20, 2011 for endt Additional info
					request.setAttribute("enEffectivityDate", sdf.format(par.getEffDate()));
					request.setAttribute("enIssueDate", sdf.format(par.getIssueDate()));
					
					request.setAttribute("enParId", curParId);
					//request.setAttribute("enInfo", StringFormatter.replaceQuotesInObject(enItem)); removed by reymon 03052013
					request.setAttribute("enInfo", enItem);
					//Added by tonio Jan 20, 2011 for endt Additional info
					request.setAttribute("parType", request.getParameter("globalParType"));
					request.setAttribute("policyNo", request.getParameter("globalEndtPolicyNo"));
					request.setAttribute("isPack", request.getParameter("isPack")); // added by andrew - 03.28.2011
					
					//request.setAttribute("engParamSublineCd", giisParameterService.getEngineeringParameterizedSubline(subline.getSublineName()));
					request.setAttribute("engParamSublineCd", giisParameterService.getENParamSublineNames(curSublineCd));
					
					PAGE="/pages/underwriting/additionalEngineeringInfo.jsp";
				} else if("setENBasicInfo".equals(ACTION)) {
					//String sublineCd = request.getParameter("enSubline");
					String sublineName = request.getParameter("sublineName");
					gipiWEngBasicService.setWEngBasicInfo(request.getParameter("enParam"), sublineName);
					//if(sublineCd.equals("CAR") || sublineCd.equals("EAR")) {
					System.out.println("Check additional - "+sublineName+"; "+request.getParameter("additionalParam"));
				    if(sublineName.equals("CONTRACTOR_ALL_RISK") || sublineName.equals("ERECTION_ALL_RISK") || sublineName.equals("CONTRACTORS_ALL_RISK")) { // added by steve "sublineName.equals("CONTRACTORS_ALL_RISK")" for RSIC with "S" kasi yong sublineName nila
						if(request.getParameter("additionalParam") != null && !(request.getParameter("additionalParam").equals(""))) {
							gipiWEngBasicService.saveENPrincipals(request.getParameter("additionalParam"), parId);
						}
					}
					
					message = "SUCCESS";
					PAGE = "/pages/genericMessage.jsp";
				} else if("showPrincipalInfo".equals(ACTION)) {
					String pType = request.getParameter("pType");
					String[] param= {pType};
					
					List<LOV> principalListing = helper.getList(LOVHelper.EN_PRINCIPAL_LISTING, param);
					//StringFormatter.replaceQuotesInList(principalListing);
					StringFormatter.escapeHTMLInList4(principalListing);
					request.setAttribute("principals", new JSONArray(principalListing));
					request.setAttribute("pType", pType);
					List<GIPIWPrincipal> enPrincipal = gipiWEngBasicService.getENPrincipals(parId, pType);
					StringFormatter.replaceQuotesInList(enPrincipal);
					request.setAttribute("enPrincipals", new JSONArray(enPrincipal));
					PAGE = "/pages/underwriting/pop-ups/enPrincipalList.jsp";
				} else if("showEndtAdditionalInfo".equals(ACTION)) {
					
					request.setAttribute("parId", parId);
					request.setAttribute("parNo", request.getParameter("globalParNo"));
					request.setAttribute("assdName", request.getParameter("globalAssdName"));
					request.setAttribute("parType", request.getParameter("globalParType"));
					request.setAttribute("policyNo", request.getParameter("globalEndtPolicyNo"));
					
					PAGE = "/pages/underwriting/endt/engineering/endtEngineeringAdditionalInformationMain.jsp";
				}
			}
/*		} catch(SQLException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";*/
		} catch(NullPointerException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);			
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
