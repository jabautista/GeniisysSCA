/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.giac.controllers
	File Name: GIACReplenishDvController.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Nov 6, 2012
	Description: 
*/


package com.geniisys.giac.controllers;

import java.io.IOException;
import java.math.BigDecimal;
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
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.service.GIACReplenishDvService;
import com.seer.framework.util.ApplicationContextReader;
@WebServlet (name="GIACReplenishDvController", urlPatterns="/GIACReplenishDvController")
public class GIACReplenishDvController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = -1707846234678341701L;
	private Logger log = Logger.getLogger(GIACReplenishDvController.class);
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("Initializing : "+this.getClass().getSimpleName());
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIACReplenishDvService giacReplenishDvService = (GIACReplenishDvService) APPLICATION_CONTEXT.getBean("giacReplenishDvService");
		try{
			if("showRfDetailTG".equals(ACTION)){ //GIACS016
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGiacs016RfDetailListTG");
				params.put("replenishId", request.getParameter("replenishId"));
				params.put("userId", USER.getUserId());
				Map<String, Object> rfDetailTG = TableGridUtil.getTableGrid(request, params);			
				JSONObject json = new JSONObject(rfDetailTG);
				
				if(request.getParameter("refresh") != null && "1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					JSONObject rfAmounts = new JSONObject(giacReplenishDvService.getRfDetailAmounts(params));
					request.setAttribute("rfDetailJSON", json);
					request.setAttribute("rfAmountsJSON", rfAmounts);
					PAGE = "/pages/accounting/generalDisbursements/mainDisbursement/subpages/rfDetail.jsp";
				}
			}else if("saveRfDetail".equals(ACTION)){
				giacReplenishDvService.saveRfDetail(request.getParameter("strParameters"), USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if ("getGIACS016SumAcctEntriesTableGrid".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGIACS016SumAcctEntriesTableGrid");
				params.put("replenishId", request.getParameter("replenishId"));
				
				params.put("userId", USER.getUserId());
				Map<String, Object> sumAcctEntriesTG = TableGridUtil.getTableGrid(request, params);			
				JSONObject json = new JSONObject(sumAcctEntriesTG);
				
				if(request.getParameter("refresh") != null && "1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					giacReplenishDvService.getGIACS016AcctEntPostQuery(params);
					request.setAttribute("replenishId", request.getParameter("replenishId"));
					request.setAttribute("sumAcctEntriesJSON", json);
					request.setAttribute("totalDebitAmt", params.get("totalDebitAmt"));
					request.setAttribute("totalCreditAmt", params.get("totalCreditAmt"));
					//request.setAttribute("rfAmountsJSON", rfAmounts);
					PAGE = "/pages/accounting/generalDisbursements/mainDisbursement/subpages/summarizedEntries.jsp";
				}
			}else if("showReplenishmentOfRevolvingFundListing".equals(ACTION)){
				JSONObject json = giacReplenishDvService.showReplenishmentListing(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/accounting/generalDisbursements/replenishmentOfRevolvingFund/replenishmentOfRevolvingFundListing.jsp";					
				}
			}else if("showReplenishmentOfRevolvingFund".equals(ACTION)){
				JSONObject json = giacReplenishDvService.showReplenishmentDetail(request, USER);
				Map<String, Object> par = new HashMap<String, Object>();
				par.put("replenishId", request.getParameter("replenishId"));
				request.setAttribute("editingAllowed", giacReplenishDvService.checkReplenishmentPaytReq(par));	// shan 10.10.2014
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/accounting/generalDisbursements/replenishmentOfRevolvingFund/subPages/replenishmentOfRevolvingFund.jsp";					
				}
			}else if("getReplenishmentListing".equals(ACTION)){
				JSONObject json = giacReplenishDvService.showReplenishmentDetailList(request, USER);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("showReplenishmentOfRevolvingFundAcctEnt".equals(ACTION)){
				JSONObject json = giacReplenishDvService.showReplenishmentAcctEntries(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/accounting/generalDisbursements/replenishmentOfRevolvingFund/subPages/accountingEntries.jsp";					
				}
			}else if("showReplenishmentOfRevolvingFundSumAcctEnt".equals(ACTION)){
				JSONObject json = giacReplenishDvService.showReplenishmentSumAcctEntries(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/accounting/generalDisbursements/replenishmentOfRevolvingFund/subPages/summarizedEntries.jsp";					
				}
			}else if("saveReplenishmentMasterRecord".equals(ACTION)){
				giacReplenishDvService.saveReplenishmentMasterRecord(request, USER);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveReplenishment".equals(ACTION)){
				giacReplenishDvService.saveReplenishment(request, USER);
				// added by shan 10.10.2014
				Map<String, Object> par = new HashMap<String, Object>();
				par.put("replenishId", request.getParameter("replenishId"));
				String editingAllowed = giacReplenishDvService.checkReplenishmentPaytReq(par);
				JSONObject json = new JSONObject();
				json.put("message", "SUCCESS");
				json.put("editingAllowed", editingAllowed);
				message = json.toString(); //"SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if ("getCurrReplenishmentId".equals(ACTION)) {
				message = (new JSONObject(giacReplenishDvService.getCurrReplenishmentId(request, USER))).toString(); 
				PAGE = "/pages/genericMessage.jsp";
			}else if ("checkReplenishmentPaytReq".equals(ACTION)){
				Map<String, Object> par = new HashMap<String, Object>();
				par.put("replenishId", request.getParameter("replenishId"));
				String editingAllowed = giacReplenishDvService.checkReplenishmentPaytReq(par);
				
				par.put("userId", USER.getUserId());
				BigDecimal origRevolvingFund = giacReplenishDvService.getRevolvingFund(par);
				JSONObject json = new JSONObject();
				json.put("editingAllowed", editingAllowed);
				json.put("origRevolvingFund", origRevolvingFund);
				
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}
		}catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}  finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	
		
	}

}
