package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.entity.GIPIWItem;
import com.geniisys.gipi.service.GIPIPARListService;
import com.geniisys.gipi.service.GIPIParBillGroupingService;
import com.geniisys.gipi.service.GIPIWInvoiceFacadeService;
import com.geniisys.gipi.service.GIPIWItemService;
import com.seer.framework.util.ApplicationContextReader;

/**
 *  The GIPIParBillGroupingController
 */
public class GIPIParBillGroupingController extends BaseController {
	
	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 1L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIParBillGroupingController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			/*default attributes*/
			log.info("Initializing: "+ this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIPIWItemService gipiWItemService = (GIPIWItemService) APPLICATION_CONTEXT.getBean("gipiWItemService");
			GIPIPARListService gipiParService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");
			GIPIWInvoiceFacadeService gipiWInvoiceService = (GIPIWInvoiceFacadeService) APPLICATION_CONTEXT.getBean("gipiWInvoiceFacadeService");
			/*end of default attributes*/
			
			if("showBillGrouping".equals(ACTION)){
				int parId = Integer.parseInt("".equals(request.getParameter("parId")) ? "0" : request.getParameter("parId"));
				String lineCd = request.getParameter("lineCd");
				String issCd = request.getParameter("issCd");
				String parType = request.getParameter("parType");
				String policyNo = request.getParameter("policyNo");
				System.out.println("Bill Grouping: " + parId);
				List<GIPIWItem> gipiWItems = gipiWItemService.getGIPIWItem(parId);
				GIPIPARList par = gipiParService.getGIPIPARDetails(parId);
				request.setAttribute("parId", parId);
				request.setAttribute("lineCd", lineCd);
				request.setAttribute("issCd", issCd);
				request.setAttribute("parNo", par.getParNo());
				request.setAttribute("assdName", par.getAssdName());
				request.setAttribute("items", gipiWItems);
				request.setAttribute("parType", parType);
				request.setAttribute("policyNo", policyNo);
				request.setAttribute("isPack", request.getParameter("isPack")); // andrew 10.04.2011
				
				message ="SUCCESS";
				PAGE = "/pages/underwriting/billGrouping.jsp";
			}else if("saveBillGrouping".equals(ACTION)){
				GIPIParBillGroupingService gipiParBillGroupingService = (GIPIParBillGroupingService) APPLICATION_CONTEXT.getBean("gipiParBillGroupingService");
				int parId = Integer.parseInt(request.getParameter("parId"));
				String lineCd = request.getParameter("lineCd");
				String issCd = request.getParameter("issCd");
				System.out.println("Line Cd: " + lineCd + " Issue Code: " + issCd);	
				String[] itemGrps = request.getParameterValues("itemGrp");
				String[] itemNos = request.getParameterValues("itemNo");
				
				if(itemGrps != null && itemNos != null){
					for(int i=0; i<itemNos.length; i++){
						System.out.println("Par Id: " + parId + " Item Groups: " + itemGrps[i] +" Item Nos: " + itemNos[i]);
						Integer itemGrp = Integer.parseInt(itemGrps[i]);
						Integer itemNo = Integer.parseInt(itemNos[i]);
						gipiWItemService.updateItemGroup(parId, itemGrp, itemNo);
					}
				}
				gipiParBillGroupingService.deleteDistWorkTables(parId);
				gipiWInvoiceService.createWInvoice(parId, lineCd, issCd);
				message ="SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("joinGroup".equals(ACTION)){
				int parId = Integer.parseInt("".equals(request.getParameter("parId")) ? "0" : request.getParameter("parId"));
				List<GIPIWItem> gipiWItems = gipiWItemService.getGIPIWItem(parId);
				request.setAttribute("items", gipiWItems);
				System.out.println("par ID: " + parId);
				message ="SUCCESS";
				PAGE = "/pages/underwriting/overlay/existingItemGroups.jsp";
			}else if("showExistingGroupsOverlay".equals(ACTION)){
				int parId = Integer.parseInt("".equals(request.getParameter("parId")) ? "0" : request.getParameter("parId"));
				request.setAttribute("parId", parId);
				System.out.println("par ID: " + parId);
				message ="SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("showPackBillGrouping".equals(ACTION)){
				GIPIPARListService gipiParListService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");
				Integer packParId = Integer.parseInt(request.getParameter("packParId") == null ? "0" : request.getParameter("packParId"));				
				request.setAttribute("assdNo", request.getParameter("globalAssdNo"));
				request.setAttribute("assdName", request.getParameter("globalAssdName"));
				request.setAttribute("parNo", request.getParameter("globalPackParNo"));
				request.setAttribute("isPack", "Y");
				request.setAttribute("packParList", new JSONArray(gipiParListService.getPackPolicyList(packParId)));
				PAGE = "/pages/underwriting/packPar/packBillGrouping/packBillGrouping.jsp";
			}
			
		}catch (SQLException e) {
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
