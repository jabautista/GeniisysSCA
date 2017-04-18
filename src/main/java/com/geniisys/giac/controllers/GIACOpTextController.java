package com.geniisys.giac.controllers;

import java.io.IOException;
import java.sql.SQLException;
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
import com.geniisys.giac.entity.GIACOpText;
import com.geniisys.giac.entity.GIACOrderOfPayment;
import com.geniisys.giac.service.GIACOpTextService;
import com.geniisys.giac.service.GIACOrderOfPaymentService;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.Debug;
import com.seer.framework.util.StringFormatter;

public class GIACOpTextController extends BaseController{

	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIACOpTextController.class);
	
	@SuppressWarnings("unchecked")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			/*default attributes*/
			log.info("Initializing..."+this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			/*end of default attributes*/
			
			String strGaccTranId = request.getParameter("globalGaccTranId") == null ? "0" : request.getParameter("globalGaccTranId");
			Integer gaccTranId= strGaccTranId.trim().equals("") ? 0 : Integer.parseInt(strGaccTranId);
			String gaccBranchCd = request.getParameter("globalGaccBranchCd") == null ? "" :request.getParameter("globalGaccBranchCd");
			String gaccFundCd = request.getParameter("globalGaccFundCd") == null ? "" :request.getParameter("globalGaccFundCd");
			GIACParameterFacadeService giacParamService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");

			System.out.println("Tran ID   : " + gaccTranId);
			System.out.println("Branch Cd : " + gaccBranchCd);
			System.out.println("Fund Cd   : " + gaccFundCd);
			System.out.println("USER ID   : " + USER.getUserId());
			
			if ("showORPreview".equals(ACTION)){
				log.info("Getting OR Preview for "+gaccTranId+" - "+USER.getUserId()+"...");
				GIACOpTextService giacOpTextService = (GIACOpTextService) APPLICATION_CONTEXT.getBean("giacOpTextService");
				GIACOrderOfPaymentService giacOrderOfPayts = (GIACOrderOfPaymentService) APPLICATION_CONTEXT.getBean("giacOrderOfPaymentService");
				
				request.setAttribute("orDocStampsAdj",giacParamService.getParamValueN2("OR_DOC_STAMPS_ADJ"));
				
				HashMap<String, Object> insertTax = new HashMap<String, Object>();
				insertTax.put("gaccTranId", gaccTranId);
				insertTax = giacOpTextService.checkInsertTaxCollnsGIACS025(insertTax);
				
				HashMap<String, Object> vars = giacOpTextService.whenNewFormsInsGIACS025(gaccTranId);
				Debug.print(vars);
				vars.put("insertTaxMessage", insertTax.get("vMsgAlert"));
				request.setAttribute("variables", new JSONObject((HashMap<String, Object>) StringFormatter.escapeHTMLInMap(vars)));
				
				Integer page= request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
				HashMap<String, Object> grid = new HashMap<String, Object>();
				grid.put("gaccTranId", gaccTranId);
				grid.put("currentPage", page);
				grid = giacOpTextService.getGIACOpTextTableGrid(grid);
				request.setAttribute("giacOpTextTableGrid", new JSONObject((HashMap<String, Object>) StringFormatter.escapeHTMLInMap(grid)));
				
				GIACOrderOfPayment order = giacOrderOfPayts.getGIACOrderOfPaymentDtl(gaccTranId);
				request.setAttribute("payorName", order == null ? null : order.getPayor());
				
				List<Integer> printSeqNoList = giacOpTextService.getPrintSeqNoList(gaccTranId);
				List<Integer> itemSeqNoList = giacOpTextService.getItemSeqNoList(gaccTranId);
				request.setAttribute("printSeqNoList", printSeqNoList);
				request.setAttribute("itemSeqNoList", itemSeqNoList);
				
				//added john dolon 7.3.2015 - SR#19543
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", request.getParameter("gaccTranId"));
				params.put("appUser", USER.getUserId());
				giacOpTextService.recomputeOpText(params);
				
				PAGE = "/pages/accounting/officialReceipt/orPreview/orPreview.jsp";
			}else if ("refreshORPreview".equals(ACTION)){
				log.info("Refreshing OR Preview...");
				GIACOpTextService giacOpTextService = (GIACOpTextService) APPLICATION_CONTEXT.getBean("giacOpTextService");
				
				Integer page= request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));
				HashMap<String, Object> grid = new HashMap<String, Object>();
				grid.put("gaccTranId", gaccTranId);
				grid.put("filter", request.getParameter("objFilter"));
				grid.put("currentPage", page);
				grid = giacOpTextService.getGIACOpTextTableGrid(grid);
				JSONObject json = new JSONObject((HashMap<String, Object>) StringFormatter.escapeHTMLInMap(grid));
				
				List<Integer> printSeqNoList = giacOpTextService.getPrintSeqNoList(gaccTranId);
				List<Integer> itemSeqNoList = giacOpTextService.getItemSeqNoList(gaccTranId);
				request.setAttribute("printSeqNoList", printSeqNoList);
				request.setAttribute("itemSeqNoList", itemSeqNoList);
				
				//added john dolon 7.3.2015 - SR#19543
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", request.getParameter("gaccTranId"));
				params.put("appUser", USER.getUserId());
				giacOpTextService.recomputeOpText(params);
				
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("saveORPreview".equals(ACTION)){
				GIACOpTextService giacOpTextService = (GIACOpTextService) APPLICATION_CONTEXT.getBean("giacOpTextService");
				message = giacOpTextService.saveORPreview(request.getParameter("parameters"), USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if ("generateParticulars".equals(ACTION)){
				log.info("Generate particulars - OR Preview...");
				GIACOpTextService giacOpTextService = (GIACOpTextService) APPLICATION_CONTEXT.getBean("giacOpTextService");
				List<GIACOpText> giacOpTexts = giacOpTextService.generateParticulars(gaccTranId);
				HashMap<String, Object> map = new HashMap<String, Object>();
				map.put("rows", new JSONArray((List<GIACOpText>) StringFormatter.replaceQuotesInList(giacOpTexts)));
				JSONObject json = new JSONObject(map);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("genSeqNos".equals(ACTION)){
				log.info("Generate sequence - OR Preview...");
				GIACOpTextService giacOpTextService = (GIACOpTextService) APPLICATION_CONTEXT.getBean("giacOpTextService");
				HashMap<String, Object> map = new HashMap<String, Object>();
				map.put("gaccTranId", gaccTranId);
				map.put("itemGenType", request.getParameter("itemGenType"));
				map.put("startRow", request.getParameter("startRow"));
				map.put("endRow", request.getParameter("endRow"));
				map = giacOpTextService.genSeqNos(map);
				map.put("message", "SUCCESS");
				JSONObject json = new JSONObject(map);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("validatePrintSeqNo".equals(ACTION)){
				log.info("Validate print sequence number - OR Preview...");
				GIACOpTextService giacOpTextService = (GIACOpTextService) APPLICATION_CONTEXT.getBean("giacOpTextService");
				HashMap<String, Object> map = new HashMap<String, Object>();
				map.put("gaccTranId", gaccTranId);
				map.put("printSeqNo", request.getParameter("printSeqNo"));
				map.put("startRow", request.getParameter("startRow"));
				map.put("endRow", request.getParameter("endRow"));
				message = giacOpTextService.checkPrintSeqNoORPreview(map);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("validatePrintOP".equals(ACTION)){
				log.info("Validate before printing OR - OR Preview...");
				GIACOpTextService giacOpTextService = (GIACOpTextService) APPLICATION_CONTEXT.getBean("giacOpTextService");
				HashMap<String, Object> map = new HashMap<String, Object>();
				map.put("gaccTranId", gaccTranId);
				map.put("currCd", request.getParameter("currCd"));
				map.put("currSname", request.getParameter("currSname"));
				map = giacOpTextService.validatePrintOP(map);
				JSONObject json = new JSONObject(map);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("adjustOpText".equals(ACTION)) {
				log.info("Adjusting GIAC OP TEXT due to 0.01 difference...");
				GIACOpTextService giacOpTextService = (GIACOpTextService) APPLICATION_CONTEXT.getBean("giacOpTextService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", gaccTranId);
				params.put("appUser", USER.getUserId());
				giacOpTextService.adjustOpTextOndDiscrep(params);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if ("validateORAcctgEntries".equals(ACTION)) { //added by steven 1/8/2013 base on SR 0011812
				GIACOpTextService giacOpTextService = (GIACOpTextService) APPLICATION_CONTEXT.getBean("giacOpTextService");
				message = giacOpTextService.validateORAcctgEntries(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("validateBalanceAcctgEntrs".equals(ACTION)) {
				GIACOpTextService giacOpTextService = (GIACOpTextService) APPLICATION_CONTEXT.getBean("giacOpTextService");
				message = giacOpTextService.validateBalanceAcctgEntrs(new Integer(request.getParameter("gaccTranId")));
				PAGE = "/pages/genericMessage.jsp";
			}else if ("adjDocStampsGiacs025".equals(ACTION)) { //added john 10.24.2014
				GIACOpTextService giacOpTextService = (GIACOpTextService) APPLICATION_CONTEXT.getBean("giacOpTextService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", request.getParameter("gaccTranId"));
				params.put("appUser", USER.getUserId());
				giacOpTextService.adjDocStampsGiacs025(params);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("recomputeOpText".equals(ACTION)) { //added john 7.1.2015
				GIACOpTextService giacOpTextService = (GIACOpTextService) APPLICATION_CONTEXT.getBean("giacOpTextService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", request.getParameter("gaccTranId"));
				params.put("appUser", USER.getUserId());
				giacOpTextService.recomputeOpText(params);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}
			
		}catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (NullPointerException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		//} catch (ParseException e) {
		//	message = "Date Parse Exception occured...<br />"+e.getCause();
		//	PAGE = "/pages/genericMessage.jsp";
		//	e.printStackTrace();
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}	
	}

}
