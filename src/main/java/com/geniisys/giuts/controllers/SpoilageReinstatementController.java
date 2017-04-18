package com.geniisys.giuts.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
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

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISParameterService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.FormInputUtil;
import com.geniisys.framework.util.QueryParamGenerator;
import com.geniisys.giac.service.GIACModulesService;
import com.geniisys.giuts.service.SpoilageReinstatementService;
import com.seer.framework.util.ApplicationContextReader;

public class SpoilageReinstatementController extends BaseController {

	private static final long serialVersionUID = 1L;

	private static Logger log = Logger.getLogger(CopyUtilitiesController.class);

	@Override
	public void doProcessing(HttpServletRequest request, HttpServletResponse response, GIISUser USER, String ACTION, HttpSession SESSION) throws ServletException, IOException {
		
		log.info("Initializing: "+ this.getClass().getSimpleName());
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		SpoilageReinstatementService spoilageReinstatementService = (SpoilageReinstatementService) APPLICATION_CONTEXT.getBean("spoilageReinstatementService");
		GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");	// kenneth SR 4753/ CLIENT SR 17487 07062015

		try{
			request.setAttribute("allowSpoilageRecWrenewal", giisParameterService.getParamValueV2("ALLOW_SPOILAGE_REC_WRENEWAL"));	// kenneth SR 4753/ CLIENT SR 17487 07 062015
			request.setAttribute("allowReinstatementWcancelRenewPol", giisParameterService.getParamValueV2("ALLOW_REINSTATEMENT_WCANCEL_RENEW_POL")); //benjo 09.03.2015 UW-SPECS-2015-080
			request.setAttribute("restrictSpoilWacctEntDate", giisParameterService.getParamValueV2("RESTRICT_SPOIL_OF_REC_WACCT_ENT_DATE")); //benjo 09.03.2015 UCPBGEN-SR-19862
			request.setAttribute("allowReinstateWCancelledOrig", giisParameterService.getParamValueV2("ALLOW_REINSTATE_WCANCELLED_ORIG")); //Added by Jerome Bautista SR 21390 01.27.2016
			// GIUTS003 - Spoil Policy/Endorsement start
			if("showSpoilPostedPolicy".equals(ACTION)){
				PAGE = "/pages/underwriting/utilities/spoilageReinstatement/spoilPostedPolicy/spoilPostedPolicy.jsp";
			}else if("whenNewFormInstanceGiuts003".equals(ACTION)){
				message = spoilageReinstatementService.whenNewFormInstanceGiuts003(request).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("spoilPolicyGiuts003".equals(ACTION)){
				message = spoilageReinstatementService.spoilPolicyGiuts003(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if("unspoilPolicyGiuts003".equals(ACTION)){
				message = spoilageReinstatementService.unspoilPolicyGiuts003(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("postPolicyGiuts003".equals(ACTION)){
				message = spoilageReinstatementService.postPolicyGiuts003(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if("postPolicy2Giuts003".equals(ACTION)){
				message = spoilageReinstatementService.postPolicy2Giuts003(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			
			// GIUTS003A - Spoil Package Policy/Endorsement start
			}else if("showSpoilPostedPackagePolicy".equals(ACTION)){
				PAGE = "/pages/underwriting/utilities/spoilageReinstatement/spoilPostedPackagePolicy/spoilPostedPackagePolicy.jsp";
				
			}else if("whenNewFormInstanceGiuts003a".equals(ACTION)){				
				request.setAttribute("object", new JSONObject(spoilageReinstatementService.whenNewFormGiuts003a()));
				PAGE = "/pages/genericObject.jsp";				
				
			}else if("getPackPolicyDetailsGiuts003a".equals(ACTION)){
				message = spoilageReinstatementService.getPackPolicyDetailsGiuts003a(request, USER);
				PAGE = "/pages/genericMessage.jsp";
				
			}else if("chkPackPolicyForSpoilageGiuts003a".equals(ACTION)){
				message = spoilageReinstatementService.chkPackPolicyForSpoilageGiuts003a(request); //changed by kenneth 07132015 SR 4753
				//List<Map<String, Object>> result = spoilageReinstatementService.chkPackPolicyForSpoilageGiuts003a(request);
				//System.out.println("Result: "+result); 
				//request.setAttribute("object", new JSONArray(result));
				PAGE = "/pages/genericMessage.jsp";

			}else if("spoilPackGiuts003a".equals(ACTION)){				
				message = spoilageReinstatementService.spoilPackGiuts003a(request, USER);
				PAGE = "/pages/genericMessage.jsp";
				
			}else if("unspoilPackGiuts003a".equals(ACTION)){
				message = spoilageReinstatementService.unspoilPackGiuts003a(request, USER);
				PAGE = "/pages/genericMessage.jsp";
				
			}else if("chkPackPolicyPostGiuts003a".equals(ACTION)){
				message = spoilageReinstatementService.chkPackPolicyPostGiuts003a(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			
			// GIUTS028 - Policy Reinstatement jomsdiago 07.25.2013
			}else if("showGIUTS028".equals(ACTION)){
				PAGE = "/pages/underwriting/utilities/spoilageReinstatement/policyReinstatement/policyReinstatement.jsp";
			}else if("whenNewFormInstanceGIUTS028".equals(ACTION)){
				message = spoilageReinstatementService.whenNewFormInstanceGIUTS028(request).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateGIUTS028EndtRecord".equals(ACTION)){
				message = spoilageReinstatementService.validateGIUTS028EndtRecord(request).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateGIUTS028CheckPaid".equals(ACTION)){
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				spoilageReinstatementService.validateGIUTS028CheckPaid(params);
				message = QueryParamGenerator.generateQueryParams(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateGIUTS028CheckRIPayt".equals(ACTION)){
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				spoilageReinstatementService.validateGIUTS028CheckRIPayt(params);
				message = QueryParamGenerator.generateQueryParams(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateGIUTS028RenewPol".equals(ACTION)){
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				spoilageReinstatementService.validateGIUTS028RenewPol(params);
				message = QueryParamGenerator.generateQueryParams(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateGIUTS028CheckAcctEntDate".equals(ACTION)){
				//Map<String, Object> params = FormInputUtil.getFormInputs(request);
				DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("vRestrict", request.getParameter("vRestrict"));
				params.put("vAcctEntDate", request.getParameter("vAcctEntDate") == "" || request.getParameter("vAcctEntDate") == null ? null : df.parse(request.getParameter("vAcctEntDate")));
				System.out.println("validateGIUTS028CheckAcctEntDate parameters :::::::::::::::::::" + params);
				spoilageReinstatementService.validateGIUTS028CheckAcctEntDate(params);
				message = QueryParamGenerator.generateQueryParams(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkMrn".equals(ACTION)){
				message = spoilageReinstatementService.checkMrn(request).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkEndtOnProcess".equals(ACTION)){
				message = spoilageReinstatementService.checkEndtOnProcess(request).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("validateUserFunc".equals(ACTION)){
				GIACModulesService giacModulesService = (GIACModulesService) APPLICATION_CONTEXT.getBean("giacModulesService");
				
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("user", USER.getUserId());
				param.put("funcCode", request.getParameter("funcCode"));
				param.put("moduleName", request.getParameter("moduleName"));
				
				log.info("User Param: " + USER.getUserId());
				log.info("Function Code Param: " + request.getParameter("funcCode"));
				log.info("Module Name Param: " + request.getParameter("moduleName"));
				
				String userAccessFlag = giacModulesService.validateUserFunc(param);
				log.info("User Module Access Flag: " + userAccessFlag);
				
				PAGE = "/pages/genericMessage.jsp";
				message = userAccessFlag.toString();
			}else if("processGIUTS028Reinstate".equals(ACTION)){
				message = spoilageReinstatementService.processGIUTS028Reinstate(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkOrigRenewStatus".equals(ACTION)){ //benjo 09.03.2015 UW-SPECS-2015-080
				message = spoilageReinstatementService.checkOrigRenewStatus(request);
				PAGE = "/pages/genericMessage.jsp";
			}
			
			// GIUTS028A - Package Policy Reinstatement jomsdiago 07.25.2013
			else if("showGIUTS028A".equals(ACTION)){
				PAGE = "/pages/underwriting/utilities/spoilageReinstatement/packageReinstatement/packageReinstatement.jsp";
			}
			else if("whenNewFormInstanceGIUTS028A".equals(ACTION)){
				message = spoilageReinstatementService.whenNewFormInstanceGIUTS028A(request).toString();
				PAGE = "/pages/genericMessage.jsp";
			}
			else if("reinstatePackageGIUTS028A".equals(ACTION)){
				message = spoilageReinstatementService.reinstatePackageGIUTS028A(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}
			else if("postGIUTS028AReinstate".equals(ACTION)){
				message = spoilageReinstatementService.postGIUTS028AReinstate(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateSpoilCdGiuts003".equals(ACTION)){
				message = spoilageReinstatementService.validateSpoilCdGiuts003(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkPackOrigRenewStatus".equals(ACTION)){ //benjo 09.03.2015 UW-SPECS-2015-080
				message = spoilageReinstatementService.checkPackOrigRenewStatus(request);
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (SQLException e){
			System.out.println(e.getErrorCode());
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
}
