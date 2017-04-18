package com.geniisys.giri.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
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
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giri.service.GIRIIntreatyService;
import com.seer.framework.util.ApplicationContextReader;

public class GIRIIntreatyController extends BaseController{

	private static final long serialVersionUID = 1L;
	
	private Logger log = Logger.getLogger(GIRIIntreatyController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIRIIntreatyService giriIntreatyService = (GIRIIntreatyService) APPLICATION_CONTEXT.getBean("giriIntreatyService");
		try{
			if("showIntreatyListing".equals(ACTION)){
				log.info("Show inward treaty listing page...");
				request.setAttribute("userId", USER.getUserId());
				JSONObject json = giriIntreatyService.showIntreatyListing(request, USER.getUserId());
				if ("1".equals(request.getParameter("refresh"))) {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					if(!request.getParameter("lineCd").equals("")){
						giriIntreatyService.getIntreatyListing(request);
					}
					request.setAttribute("giriIntreatyTableGrid", json);
					PAGE = "/pages/underwriting/reInsurance/inwardTreaty/intreatyListing.jsp";
				}
			}else if("copyIntreaty".equals(ACTION)){
				int intreatyId = Integer.parseInt(request.getParameter("intreatyId"));
				String origIntrtyNo = request.getParameter("intrtyNo");
				log.info("Copying Intrty No. "+origIntrtyNo+"...");
				String IntrtyNo = giriIntreatyService.copyIntreaty(intreatyId, USER.getUserId());
				message = "Intrty No. " + origIntrtyNo + " has been copied to Intrty No. " + IntrtyNo + ".";
				PAGE = "/pages/genericMessage.jsp";
			}else if("approveIntreaty".equals(ACTION)){
				log.info("Approving Inward Treaty...");
				giriIntreatyService.approveIntreaty(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("cancelIntreaty".equals(ACTION)){
				log.info("Cancelling Inward Treaty...");
				giriIntreatyService.cancelIntreaty(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("showCreateIntreaty".equals(ACTION)){
				log.info("Show create inward treaty page...");
				giriIntreatyService.showCreateIntreaty(request, APPLICATION_CONTEXT, USER.getUserId());
				PAGE = "/pages/underwriting/reInsurance/inwardTreaty/createIntreaty.jsp";
			}else if("getIntreatyChargesTG".equals(ACTION)){
				log.info("Getting inward treaty charges...");
				JSONObject json = giriIntreatyService.getIntreatyChargesTG(request);
				if ("1".equals(request.getParameter("refresh"))) {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("giriIntreatyChargesTG", json);
					PAGE = "/pages/underwriting/reInsurance/inwardTreaty/chargesInformation.jsp";
				}
			}else if("saveIntreaty".equals(ACTION)){
				Map<String, Object> intreatyMap = new HashMap<String, Object>();
				intreatyMap.put("intreatyId", giriIntreatyService.saveIntreaty(request.getParameter("parameters"), USER.getUserId()));
				intreatyMap.put("message", "SUCCESS");
				request.setAttribute("object", new JSONObject(intreatyMap));
				PAGE = "/pages/genericObject.jsp";
			}else if("showInchargesTax".equals(ACTION)){
				log.info("Show incharges tax page...");
				giriIntreatyService.showInchargesTax(request, APPLICATION_CONTEXT, USER.getUserId());
				PAGE = "/pages/underwriting/reInsurance/inwardTreaty/inchargesTax.jsp";
			}else if("getInchargesTaxTG".equals(ACTION)){
				log.info("Getting incharges tax...");
				JSONObject json = giriIntreatyService.getInchargesTaxTG(request);
				if ("1".equals(request.getParameter("refresh"))) {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("giriInchargesTaxTG", json);
					PAGE = "/pages/underwriting/reInsurance/inwardTreaty/inchargesTax.jsp";
				}
			}else if("saveInchargesTax".equals(ACTION)){
				log.info("Saving incharges tax...");
				giriIntreatyService.saveInchargesTax(request.getParameter("parameters"), USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("showViewIntreaty".equals(ACTION)){
				log.info("Show view inward treaty page...");
				giriIntreatyService.showViewIntreaty(request, APPLICATION_CONTEXT, USER.getUserId());
				PAGE = "/pages/underwriting/riInquiries/viewInwardTreaty/viewIntreaty.jsp";
			}
		}catch(SQLException e){
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
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
