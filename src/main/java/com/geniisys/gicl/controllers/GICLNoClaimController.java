package com.geniisys.gicl.controllers;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.FormInputUtil;
import com.geniisys.framework.util.QueryParamGenerator;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.entity.GICLNoClaim;
import com.geniisys.gicl.service.GICLNoClaimService;
import com.geniisys.gipi.entity.GIPIVehicle;
import com.geniisys.gipi.service.GIPIPolbasicService;
import com.geniisys.gipi.service.GIPIVehicleService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GICLNoClaimController", urlPatterns={"/GICLNoClaimController"})
public class GICLNoClaimController extends BaseController{
	
	private static final long serialVersionUID = 1L;
	private Logger log = Logger.getLogger(GICLNoClaimController.class);

	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			log.info("Initializing :"+this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GICLNoClaimService giclNoClaimService = (GICLNoClaimService) APPLICATION_CONTEXT.getBean("giclNoClaimService");
			
			if ("getNoClaimList".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("userId", USER.getUserId()); //added by steven 11/16/2012
				Map<String, Object> noClaimGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(noClaimGrid);
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("noClaimGrid", json);
					PAGE = "/pages/claims/noClaim/noClaimListing.jsp";
				}
			}else if("showNoClaimCertificate".equals(ACTION)){
				Integer noClaimId = Integer.parseInt(request.getParameter("noClaimId") == null || "".equals(request.getParameter("noClaimId"))? "0" : request.getParameter("noClaimId"));
				GICLNoClaim basic = noClaimId == 0 ? null :giclNoClaimService.getNoClaimCertDtls(noClaimId);
				request.setAttribute("noClaimDtls", new JSONObject(basic != null ? StringFormatter.escapeHTMLInObject(basic) :new GICLNoClaim()));
				PAGE = "/pages/claims/noClaim/noClaimCertificate.jsp";
			}else if("checkPolicyGICLS026".equals(ACTION)){
				GIPIPolbasicService gipiPolbasicService = (GIPIPolbasicService) APPLICATION_CONTEXT.getBean("gipiPolbasicService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				params = gipiPolbasicService.checkPolicyGICLS026(params);
				message = QueryParamGenerator.generateQueryParams(params);
				log.info(message);
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkPolicyGICLS062".equals(ACTION)){
				GIPIPolbasicService gipiPolbasicService = (GIPIPolbasicService) APPLICATION_CONTEXT.getBean("gipiPolbasicService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				params = gipiPolbasicService.checkPolicyGICLS026(params);
				message = QueryParamGenerator.generateQueryParams(params);
				log.info(message);
				PAGE = "/pages/genericMessage.jsp";
			}else if("getDetailsGICLS026".equals(ACTION)){
				DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				Date ncLossDate = request.getParameter("ncLossDate").equals("") ? null : df.parse(request.getParameter("ncLossDate"));
				params.put("ncLossDate", ncLossDate);
				params = giclNoClaimService.getDetailsGICLS026(params);
				message = (new JSONObject(StringFormatter.escapeHTMLInMap(params))).toString(); //QueryParamGenerator.generateQueryParams(params); replace by steven 12/12/2012 nagkakaroon ng issue kapag ung value na pinapasa ay may "&"
				log.info(message);
				PAGE = "/pages/genericMessage.jsp";
			}else if("getSignatoryGICLS026".equals(ACTION)){
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				params = giclNoClaimService.getSignatoryGICLS026(params);
				message = QueryParamGenerator.generateQueryParams(params);
				log.info(message);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("insertNewRecordGICLS026".equals(ACTION)){
				log.info("insertNewRecordGICLS026...");
				DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm aa");
				Map<String, Object> params =  FormInputUtil.getFormInputs(request);
				Date effDate = df.parse(request.getParameter("effDate"));
				Date expiryDate = df.parse(request.getParameter("expiryDate"));
				//Date ncLossDate =df.parse(request.getParameter("ncLossDate"));
				params.put("appUser", USER.getUserId());
				params.put("userId", USER.getUserId());
				params.put("effDate", effDate);
				params.put("expiryDate", expiryDate);
				//params.put("ncLossDate", ncLossDate);
				params.put("ncLossDate", request.getParameter("ncLossDate"));
				params = giclNoClaimService.insertNewRecordGICLS026(params);
				System.out.println(params);
				message = (new JSONObject(StringFormatter.escapeHTMLInMap(params))).toString(); //QueryParamGenerator.generateQueryParams(params); replace by steven 12/12/2012 nagkakaroon ng issue kapag ung value na pinapasa ay may "&"
				log.info(message);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("updateRecordGICLS026".equals(ACTION)){
				log.info("updateRecordGICLS026...");
				DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm aa");
				Map<String, Object> params =  FormInputUtil.getFormInputs(request);
				Date ncLossDate =df.parse(request.getParameter("ncLossDate"));
				params.put("userId", USER.getUserId());
				params.put("ncLossDate", ncLossDate);
				params = giclNoClaimService.updateRecordGICLS026(params);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if ("checkVersionGICLS026".equals(ACTION)){
				log.info("checkVersionGICLS026...");
				GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
				String reportVersion = reportsService.getReportVersion("GICLR026");
				String reportVersionB = reportsService.getReportVersion("GICLR026B");
				message= reportVersion + "," + reportVersionB;
				PAGE = "/pages/genericMessage.jsp";
			}else if ("getGICLR026Desname".equals(ACTION)){
				log.info("getGICLR026Desname...");
				GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
				String reportId = request.getParameter("reportId");
				String desname = reportsService.getReportDesname2(reportId);
				message= desname;
				PAGE = "/pages/genericMessage.jsp";
			}else if ("getGICLR062Desname".equals(ACTION)){
				log.info("getGICLR062Desname...");
				GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
				String reportId = request.getParameter("reportId");
				String desname = reportsService.getReportDesname2(reportId);
				message= desname;
				PAGE = "/pages/genericMessage.jsp";
			}else if("getMotcarItemDtls".equals(ACTION)){
				Map<String, Object> params  = FormInputUtil.getFormInputs(request);
				GIPIVehicleService gipiVehicleService = (GIPIVehicleService) APPLICATION_CONTEXT.getBean("gipiVehicleService");
				GIPIVehicle mcDtls = gipiVehicleService.getMotcarItemDtls(params);
				Map<String, Object> dtls = new HashMap<String, Object>();
				if(mcDtls != null){
					dtls.put("itemNo", mcDtls.getItemNo());
					dtls.put("itemTitle", mcDtls.getItemTitle());
					dtls.put("modelYear", mcDtls.getModelYear());
					dtls.put("carCompanyCd", mcDtls.getCarCompanyCd());
					dtls.put("carCompany", mcDtls.getCarCompany());
					dtls.put("makeCd", mcDtls.getMakeCd());
					dtls.put("make", mcDtls.getMake());
					dtls.put("motorNo", mcDtls.getMotorNo());
					dtls.put("serialNo", mcDtls.getSerialNo());
					dtls.put("plateNo", mcDtls.getPlateNo());
					dtls.put("basicColorCd", mcDtls.getBasicColorCd());
					dtls.put("basicColor", mcDtls.getBasicColor());
					dtls.put("colorCd", mcDtls.getColorCd());
					dtls.put("color", mcDtls.getColor());
				}
				message = QueryParamGenerator.generateQueryParams(dtls);
				PAGE = "/pages/genericMessage.jsp"; 
			}else if ("checkVersionGICLS062".equals(ACTION)){
				log.info("checkVersionGICLS062...");
				GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
				String reportVersion = reportsService.getReportVersion("GICLR062");				
				message= reportVersion;
				PAGE = "/pages/genericMessage.jsp";
			}
		}catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
