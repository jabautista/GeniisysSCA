package com.geniisys.gicl.controllers;

import java.io.IOException;
import java.sql.SQLException;
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
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.entity.GICLNoClaim;
import com.geniisys.gicl.entity.GICLNoClaimMultiYy;
import com.geniisys.gicl.service.GICLNoClaimMultiYyService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GICLNoClaimMultiYyController",urlPatterns={"/GICLNoClaimMultiYyController"})
public class GICLNoClaimMultiYyController extends BaseController{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private static Logger log = Logger.getLogger(GICLNoClaimMultiYyController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("doProcessing");
		try{
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";

			GICLNoClaimMultiYyService giclNoClaimsService = (GICLNoClaimMultiYyService) APPLICATION_CONTEXT.getBean("giclNoClaimMultiYyService");
			//Integer claimId = Integer.parseInt(request.getParameter("claimId") == null || "".equals(request.getParameter("claimId"))? "0" : request.getParameter("claimId"));
			if("showNoClaimMutiYyList".equals(ACTION)){				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getNoClaimMultiYyList");
				params.put("userId", USER.getUserId());
				params.put("filter",request.getParameter("objFilter"));
				Map<String, Object> noClaimMultiYy = TableGridUtil.getTableGrid(request,params);
				JSONObject json = new JSONObject(noClaimMultiYy);
				
				
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";					
				}
				else{
					request.setAttribute("noClaimMultiYyList", json);
					PAGE = "/pages/claims/noClaimMultiYy/noClaimMultiYyListing.jsp";
				}	
			}else if("showNoClaimMutiYyPolicyList".equals(ACTION)){
				Integer noClaimId = Integer.parseInt(request.getParameter("noClaimId"));
				GICLNoClaimMultiYy noClaimMultiYyDetails = (GICLNoClaimMultiYy) StringFormatter.escapeHTMLInObject(giclNoClaimsService.getNoClaimMultiYyDetails(noClaimId)); // added by steven 04.06.2013
				
				String remarks = StringFormatter.unescapeBackslash(noClaimMultiYyDetails.getRemarks()); //added by Lara - 10/16/2013
				noClaimMultiYyDetails.setRemarks(remarks);
				
				JSONObject json = new JSONObject(noClaimMultiYyDetails);
				GICLNoClaim basic = noClaimId == 0 ? null :giclNoClaimsService.getNoClaimCertDtls(noClaimId);
				request.setAttribute("noClaimDtls", new JSONObject(basic != null ? StringFormatter.escapeHTMLInObject(basic) :new GICLNoClaim()));
				request.setAttribute("noClaimMultiYyDetails", json);
				PAGE = "/pages/claims/noClaimMultiYy/subNoClaimMultiYy/noClaimMultiYyMain.jsp";
			}else if("getNoClaimPolicyList".equals(ACTION)){
				String plateNo = request.getParameter("plateNo");
				String serialNo = request.getParameter("serialNo");
				String motorNo = request.getParameter("motorNo");
				//Integer noClaimId = Integer.parseInt(request.getParameter("noClaimId") == "" ? "0" : request.getParameter("noClaimId"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION","getNoClaimMultiYyPolicyList");  //getPolListByPlateNo -- christian 12/07/2012
				params.put("plateNo", plateNo);
				params.put("serialNo", serialNo);
				params.put("motorNo", motorNo);
				params.put("userId", USER.getUserId());
				//params.put("noClaimId",noClaimId);
				System.out.println("getNoClaimPolicyList params: " + params);
				Map<String, Object> noClaimPolicyList = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(StringFormatter.replaceQuotesInMap(noClaimPolicyList));
				
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("plateNo", StringFormatter.replaceQuotes(plateNo));
					request.setAttribute("serialNo", StringFormatter.replaceQuotes(serialNo));
					request.setAttribute("motorNo", StringFormatter.replaceQuotes(motorNo));
					request.setAttribute("noClaimPolicyList", json);
					PAGE = "/pages/claims/noClaimMultiYy/subNoClaimMultiYy/noClaimPolicyTableGrid.jsp";
				}
			/*}else if("getNoClaimPolicyListBySerialNo".equals(ACTION)){
				
				String serialNo = request.getParameter("serialNo");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getNoClaimMultiYyPolicyList2");
				params.put("serialNo", serialNo);
				Map<String, Object> noClaimPolicyList2 = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(noClaimPolicyList2);
				
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("serialNo", serialNo);
					request.setAttribute("noClaimPolicyList2", json);
					PAGE = "/pages/claims/noClaimMultiYy/subNoClaimMultiYy/noClaimPolicyTableGrid2.jsp";
				}
				
			}else if("getNoClaimPolicyListByMotorNo".equals(ACTION)){
				
				String motorNo = request.getParameter("motorNo");
				Map<String, Object> params= new HashMap<String, Object>();
				params.put("ACTION", "getNoClaimMultiYyPolicyList3");
				params.put("motorNo", motorNo);
				Map<String, Object> noClaimPolicyList3 = TableGridUtil.getTableGrid(request,params);
				JSONObject json = new JSONObject(noClaimPolicyList3);
				//GICLNoClaim basic = noClaimId == 0 ? null :giclNoClaimService.getNoClaimCertDtls(motorNo);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("motorNo", motorNo);
					request.setAttribute("noClaimPolicyList3", json);
					
					PAGE = "/pages/claims/noClaimMultiYy/subNoClaimMultiYy/noClaimMultiYyMain.jsp";
				}
				*/
			}else if("addNoClaimMutiYyPolicyList".equals(ACTION)){
				request.setAttribute("noClaimMultiYyDetails", new JSONObject());
				request.setAttribute("noClaimDtls",new JSONObject());
				PAGE = "/pages/claims/noClaimMultiYy/subNoClaimMultiYy/noClaimMultiYyMain.jsp";
			}else if("getNoClaimMultiYyNo".equals(ACTION)){
				Integer noClaimNo = giclNoClaimsService.getNoClaimMultiYyNumber();
				System.out.println("GET CLAIM NUMBER:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"+noClaimNo);
				message = noClaimNo.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("populateNoClmMultiYyDtls".equals(ACTION)){
				String plateNo = request.getParameter("plateNo");
				Integer assdNo = Integer.parseInt(request.getParameter("assdNo"));
				String motorNo = request.getParameter("motorNo");
				String serialNo = request.getParameter("serialNo");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("plateNo",plateNo);
				params.put("assdNo",assdNo);
				params.put("motorNo",motorNo);
				params.put("serialNo",serialNo);
				GICLNoClaimMultiYy returnDetails = giclNoClaimsService.populateDetails((HashMap<String, Object>) params);
				JSONObject details = new JSONObject(returnDetails);
				message = details.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateSaving".equals(ACTION)){
				String plateNo = request.getParameter("plateNo");
				Integer assdNo = Integer.parseInt(request.getParameter("assdNo"));
				String motorNo = request.getParameter("motorNo");
				String serialNo = request.getParameter("serialNo");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("plateNo",plateNo);
				params.put("assdNo",assdNo);
				params.put("motorNo",motorNo);
				params.put("serialNo",serialNo);
				String existingResult = giclNoClaimsService.validateExisting(params);
				message = existingResult;
				PAGE = "/pages/genericMessage.jsp";
			}else if("additionalDtls".equals(ACTION)){
				GICLNoClaimMultiYy additionalDtls = giclNoClaimsService.additionalDtls();
				JSONObject details = new JSONObject(additionalDtls);
				message = details.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("updateDtls".equals(ACTION)){
				Integer noClaimId = Integer.parseInt(request.getParameter("noClaimId"));
				System.out.println(""+noClaimId);
				GICLNoClaimMultiYy updateDtls = giclNoClaimsService.updateDtls(noClaimId);
				JSONObject details = new JSONObject(updateDtls);
				message = details.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveNoClmMultiYy".equals(ACTION)){
				message = giclNoClaimsService.saveNoClmMultiYy(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if("getPolicyDetails".equals(ACTION)){
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/viewPolicyInformation.jsp";
			}else if("checkVersionGICLS062".equals(ACTION)){
				log.info("checkVersionGICLS062...");
				GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
				String reportVersion = reportsService.getReportVersion("GICLR062");
				String reportVersionB = reportsService.getReportVersion("GICLR062B");
				message= reportVersion + "," + reportVersionB;
				PAGE = "/pages/genericMessage.jsp";
			}
		}catch(SQLException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch(NullPointerException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
