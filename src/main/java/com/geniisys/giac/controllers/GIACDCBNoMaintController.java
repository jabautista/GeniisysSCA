package com.geniisys.giac.controllers;

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

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.entity.GIACBranch;
import com.geniisys.giac.entity.GIACCollnBatch;
import com.geniisys.giac.service.GIACBranchService;
import com.geniisys.giac.service.GIACCollnBatchService;
import com.geniisys.giac.service.GIACOrderOfPaymentService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIACDCBNoMaintController extends BaseController{

	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIACDCBNoMaintController.class);

	@SuppressWarnings("unchecked")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			log.info("Initializing..."+this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			
			if("showDCBNoMaint".equals(ACTION)) {
				log.info("Display show dcb no. maintenance page...");
				GIACBranchService branchService = (GIACBranchService) APPLICATION_CONTEXT.getBean("giacBranchService");
				GIACCollnBatchService dcbService = (GIACCollnBatchService) APPLICATION_CONTEXT.getBean("giacCollnService");
				
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("user", USER.getUserId());
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				String filtered = request.getParameter("filtered");
				/* separated setting value for DCB Number by MAC 01/11/2013
				Integer dcbNo = dcbService.generateDCBNo();
				request.setAttribute("dcbNo", dcbNo);*/
				if("Yes".equals(filtered)) {
					String dcbFlag = request.getParameter("dcbFlag");
					String fundCd = request.getParameter("fundCd");
					String branchCd = request.getParameter("branchCd");
					params.put("fundCd", fundCd);
					params.put("branchCd", branchCd);
					params.put("dcbFlag", dcbFlag);
					
					request.setAttribute("fundCd", fundCd);
					request.setAttribute("branchCd", branchCd);
					request.setAttribute("curDCBFlag", dcbFlag);
					request.setAttribute("txtCompany", request.getParameter("txtCompany"));
					request.setAttribute("txtBranch", request.getParameter("txtBranch"));
				} else {
					List<GIACBranch> branches = branchService.getBranchesGIACS333(USER.getUserId());
					GIACBranch branch = null;
					
					if(branches.size() > 0) branch = branches.get(0);

					params.put("fundCd", branch == null ? "" : branch.getGfunFundCd());
					params.put("branchCd", branch == null ? "" : branch.getBranchCd());
					params.put("dcbFlag", "O");
					
					request.setAttribute("fundCd", branch == null ? "" : branch.getGfunFundCd());
					request.setAttribute("branchCd", branch == null ? "" : branch.getBranchCd());
					request.setAttribute("curDCBFlag", "O");
					request.setAttribute("txtCompany", branch == null ? "" : branch.getGfunFundCd() + " - " + branch.getFundDesc());
					request.setAttribute("txtBranch", branch == null ? "" : branch.getBranchCd() + " - " + branch.getBranchName());
				}
				System.out.println(params);
				params = dcbService.getDCBMaintParams(params);
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				
				request.setAttribute("dcbNoTableGrid", new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)));
				
				PAGE = "/pages/accounting/cashReceipts/utilities/dcbNumberMaintenance.jsp";
			}  else if("refreshDCBNos".equals(ACTION)) {
				log.info("Refreshing DCB No. Maintenance TableGrid...");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("filter", "".equals(request.getParameter("objFilter")) || "{}".equals(request.getParameter("objFilter")) ? null :request.getParameter("objFilter"));
				params.put("ACTION", "getDCBNoForMaint");
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("branchCd", request.getParameter("branchCd"));
				
				if (params.get("filter")!=null){
					params.put("dcbFlag", "%");
				}else{
					params.put("dcbFlag", request.getParameter("dcbFlag"));
				}
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlag", request.getParameter("ascDescFlg"));
				Map<String, Object> giacDCBMaintTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject objgiacDCBMaintTableGrid = new JSONObject(giacDCBMaintTableGrid);
				
				message = objgiacDCBMaintTableGrid.toString();
				PAGE =  "/pages/genericMessage.jsp";
			} else if("showBranchList".equals(ACTION)) {
				GIACBranchService branchService = (GIACBranchService) APPLICATION_CONTEXT.getBean("giacBranchService");
				List<GIACBranch> branches = branchService.getBranchesGIACS333(USER.getUserId());
				JSONArray json = new JSONArray((List<GIACBranch>) StringFormatter.replaceQuotesInList(branches));
				request.setAttribute("branchList", json);
				PAGE = "/pages/accounting/cashReceipts/utilities/pop-ups/branchOverlay.jsp";
			} else if("checkIfORAttached".equals(ACTION)) {
				GIACOrderOfPaymentService orderOfPayts = (GIACOrderOfPaymentService) APPLICATION_CONTEXT.getBean("giacOrderOfPaymentService");
				
				DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
				String dcbNo = request.getParameter("dcbNo");
				System.out.println("TEST --- " + request.getParameter("tranDate") + " / " + dcbNo);
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("dcbNo", Integer.parseInt(dcbNo));
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("tranDate", df.parse(request.getParameter("tranDate")));
				if(orderOfPayts.checkAttachedOR(params).toUpperCase().equals("Y")) { //added by steve 4.25.2012
					message = "Delete not allowed. DCB No. "+dcbNo+" has an O.R. attached to it.";
				} else {
					message = "SUCCESS";
				}
				log.info("Confirm OR Delete - "+message);
				PAGE = "/pages/genericMessage.jsp";
			} else if("saveDCBNoMaint".equals(ACTION)) {
				GIACCollnBatchService dcbService = (GIACCollnBatchService) APPLICATION_CONTEXT.getBean("giacCollnService");
				dcbService.saveDCBNoMaintChanges(request.getParameter("parameters"), USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("getClosedTag".equals(ACTION)) { //added by steve 4.26.2012
				GIACCollnBatchService dcbService = (GIACCollnBatchService) APPLICATION_CONTEXT.getBean("giacCollnService");
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("tranDate",  request.getParameter("tranDate"));
				params.put("branchCd", request.getParameter("branchCd"));
				if (dcbService.getClosedTag(params).toUpperCase().equals("T")){
					message = "You are no longer allowed to a create a transaction for " + request.getParameter("month")+ " " +request.getParameter("year") +". This transaction month is Temporarily closed.";
				} else if (dcbService.getClosedTag(params).toUpperCase().equals("Y")){
					message = "You are no longer allowed to a create a transaction for " + request.getParameter("month")+ " " +request.getParameter("year") +". This transaction month is already closed.";
				} else {
					message = "SUCCESS";
				}
				log.info("Confirm Month and Year - "+ message);
				PAGE = "/pages/genericMessage.jsp";
			}else if("getMaxDcbNumber".equals(ACTION)) { //added to get Maximum DCB Number by MAC 01/11/2013.
				GIACCollnBatchService dcbService = (GIACCollnBatchService) APPLICATION_CONTEXT.getBean("giacCollnService");
				DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
				Integer dcbNo = 0;
				GIACCollnBatch dcb = dcbService.getNewDCBNo(
						request.getParameter("fundCd"),
						request.getParameter("branchCd"),
						df.parse(request.getParameter("dcbDate")));
				if (dcb.getDcbNo() != null){
					dcbNo = dcb.getDcbNo();
				}
				message = dcbNo.toString();
				log.info("Maximum DCB Number retrieved is " + dcbNo);
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (NullPointerException e) {
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
	
}
