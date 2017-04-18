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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISDeductibleDesc;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.entity.GIPIQuote;
import com.geniisys.gipi.entity.GIPIQuoteDeductiblesSummary;
import com.geniisys.gipi.service.GIPIQuoteDeductiblesFacadeService;
import com.geniisys.gipi.service.GIPIQuoteFacadeService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

/**
 * The Class GIPIQuotationDeductiblesController.
 */
@WebServlet (name="GIPIQuotationDeductiblesController", urlPatterns={"/GIPIQuotationDeductiblesController"})

public class GIPIQuotationDeductiblesController extends BaseController {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID 		= -6748372676903552001L;
//private static boolean create_pass		= false;
	/** The log. */
	private Logger log = Logger.getLogger(GIPIQuotationDeductiblesController.class);

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
			
			/* Services needed */
			GIPIQuoteFacadeService serv = (GIPIQuoteFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteFacadeService"); // +env
			GIPIQuoteDeductiblesFacadeService deductibleService = (GIPIQuoteDeductiblesFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteDeductiblesFacadeService"); //  + env
			//GIPIQuoteInformationService quoteInfoService = new GIPIQuoteInformationService(APPLICATION_CONTEXT); //(GIPIQuoteInformationService) APPLICATION_CONTEXT.getBean("gipiQuoteInformationService"); // +env
			
			int quoteId = Integer.parseInt((request.getParameter("quoteId") == null) ? "0" : request.getParameter("quoteId"));
			GIPIQuote gipiQuote = null;
			if (quoteId != 0){
				gipiQuote = serv.getQuotationDetailsByQuoteId(quoteId);
				gipiQuote.setQuoteId(quoteId);
				request.setAttribute("gipiQuote", gipiQuote);
			}
			
			/*if ("showDeductiblesPage".equalsIgnoreCase(ACTION)){
				List<GIPIQuoteDeductiblesSummary> deductibles = deductibleService.getGIPIQuoteDeductiblesSummaryList(quoteId);
								
				request.setAttribute("deductibles", deductibles);
				
				List<GIPIQuoteItem> items = quoteInfoService.getQuoteItems(quoteId);
				request.setAttribute("items", items);
	
				List<Integer> itemNos = new ArrayList<Integer>();
				for (GIPIQuoteItem item: items)	{
					itemNos.add(item.getItemNo());
				}
				request.setAttribute("itemNos", itemNos);
				
				List<Object> perils = quoteInfoService.getQuoteItemPerils(quoteId, itemNos);
				request.setAttribute("perils", perils);
	
				List<GIISDeductibleDesc> deductibleList = deductibleService.getDeductibleList(gipiQuote.getLineCd(), gipiQuote.getSublineCd());
				
				request.setAttribute("deductibleList", deductibleList);
				PAGE = "/pages/marketing/quotation/pop-ups/deductibleInformation.jsp";
			} else if ("showDeductiblesPage".equalsIgnoreCase(ACTION)){
				List<GIPIQuoteDeductiblesSummary> deductibles = deductibleService.getGIPIQuoteDeductiblesSummaryList(quoteId);
				request.setAttribute("deductibles", deductibles);
				
				List<GIPIQuoteItem> items = quoteInfoService.getQuoteItems(quoteId);
				request.setAttribute("items", items); // RETRIEVE FROM ITEMLIST JSON INSTEAD
	
				List<Integer> itemNos = new ArrayList<Integer>();
				for (GIPIQuoteItem item: items)	{
					itemNos.add(item.getItemNo());
				}
				request.setAttribute("itemNos", itemNos); // RETRIEVE FROM ITEMLIST JSON INSTEAD
				
				List<Object> perils = quoteInfoService.getQuoteItemPerils(quoteId, itemNos);
				request.setAttribute("perils", perils);  //RETRIEVE FROM PERIL LIST JSON INSTEAD
	
				List<GIISDeductibleDesc> deductibleList = deductibleService.getDeductibleList(gipiQuote.getLineCd(), gipiQuote.getSublineCd());
				request.setAttribute("deductibleList", deductibleList);
				
				
				PAGE = "/pages/marketing/quotation/pop-ups/deductibleInformation.jsp";
			}else*/ if("getQuoteDeductibles".equals(ACTION)){
				System.out.println("------------------- getQuoteDeductibles row -------" + request.getParameter("quoteId").toString());
				Integer qId = Integer.parseInt((String)request.getParameter("quoteId"));
				List<GIPIQuoteDeductiblesSummary> deductibles = deductibleService.getGIPIQuoteDeductiblesSummaryList(qId);
				request.setAttribute("gipiQuoteDeductiblesList", new JSONArray((List<GIPIQuoteDeductiblesSummary>)StringFormatter.replaceQuotesInList(deductibles)));
				
				System.out.println("lineCd: " + gipiQuote.getLineCd() + "  sublineCd: " + gipiQuote.getSublineCd() + "   +++++++++++++++");
				
				List<GIISDeductibleDesc> deductibleList = deductibleService.getDeductibleList(gipiQuote.getLineCd(), gipiQuote.getSublineCd());
				System.out.println("deductibleList length: " + deductibleList.size());
				request.setAttribute("deductibleLov", new JSONArray((List<GIISDeductibleDesc>)StringFormatter.replaceQuotesInList(deductibleList)));
				
				PAGE = "/pages/marketing/quotation/subPages/quotationInformation/deductibleInformation.jsp";
			}else if("saveDeductibles".equalsIgnoreCase(ACTION))	{
				String[] itemNos = request.getParameterValues("deductItemNo");
				String[] perilCds = request.getParameterValues("deductPerilCd");
				String[] deductibleCds = request.getParameterValues("deductDeductibleCd");
				String[] deductibleAmts = request.getParameterValues("deductAmt");
				String[] deductibleRts = request.getParameterValues("deductRt");
				String[] deductibleTexts = request.getParameterValues("deductText");
				String saveTag = request.getParameter("saveDeductTag") == null ? "Y" : request.getParameter("saveDeductTag");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("itemNos", itemNos);
				params.put("perilCds", perilCds);
				params.put("deductibleCds",deductibleCds);
				params.put("deductibleAmts", deductibleAmts);
				params.put("deductibleRts",deductibleRts);
				params.put("deductibleTexts",deductibleTexts);
				params.put("quoteId", quoteId);
				params.put("gipiQuote", gipiQuote);
				params.put("userId", USER);
				params.put("saveTag", saveTag);
				deductibleService.saveGIPIQuoteDeductibles(params);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("getQuoteDeductiblesForPackQuotation".equals(ACTION)){
				Integer packQuoteId = request.getParameter("packQuoteId").equals("") ? null : Integer.parseInt(request.getParameter("packQuoteId"));
				log.info("Getting deductibles for pack_quote_id: " + packQuoteId);
				List<GIPIQuoteDeductiblesSummary> deductibles = deductibleService.getGIPIQuoteDeductiblesForPackList(packQuoteId);
				StringFormatter.escapeHTMLInList(deductibles);
				request.setAttribute("objPackQuoteDeductiblesList", new JSONArray(deductibles));
				PAGE = "/pages/marketing/quotation-pack/quotationInformation-pack/subPages/quotationDeductibleInformation.jsp";
			}else if("refreshQuoteDeductibleTable".equals(ACTION)){ //nieko 02162016 UW-SPECS-2015-086 Quotation Deductibles
				Map<String, Object> params = new HashMap<String, Object>();
				
				params.put("ACTION", "getAllGIPIQuoteDeduct");
				params.put("quoteId", request.getParameter("quoteId"));
				params = TableGridUtil.getTableGrid(request, params);
				
				message = (new JSONObject(params)).toString();
				PAGE = "/pages/genericMessage.jsp";
				
			}else if("refreshItemQuoteDeductibleTable".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				
				Integer quoteId1 = Integer.parseInt((String)request.getParameter("quoteId"));
				Integer itemNo1 = Integer.parseInt((String)request.getParameter("itemNo"));
				params.put("ACTION", "getItemGIPIQuoteDeduct");	
				params.put("quoteId", quoteId1);
				params.put("itemNo", itemNo1);

				params = TableGridUtil.getTableGrid(request, params);
				String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
				message = grid;
				
			}else if("refreshPerilItemQuoteDeductibleTable".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				
				Integer quoteId1 = Integer.parseInt((String)request.getParameter("quoteId"));
				Integer itemNo1 = Integer.parseInt((String)request.getParameter("itemNo"));
				Integer perilCd1 = Integer.parseInt((String)request.getParameter("perilCd"));
				params.put("ACTION", "getPerilItemGIPIQuoteDeduct");	
				params.put("quoteId", quoteId1);
				params.put("itemNo", itemNo1);
				params.put("perilCd", perilCd1);

				System.out.println("test nieko item controller 2 :");

				params = TableGridUtil.getTableGrid(request, params);
				String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
				message = grid;
				
			}else if("checkQuoteDeductibles".equals(ACTION)){
				int globalQuoteId = Integer.parseInt((request.getParameter("globalQuoteId") == null) ? "0" : request.getParameter("globalQuoteId"));
				int dedLevel = (request.getParameter("dedLevel") == null ? 0 : Integer.parseInt(request.getParameter("dedLevel")));	
				
				String deductibleType = request.getParameter("deductibleType");
				int	itemNo = Integer.parseInt(request.getParameter("itemNo"));
				
				System.out.println("checkQD " + " " +globalQuoteId + " " + deductibleType + " " + dedLevel + " " + itemNo);
				message = deductibleService.checkQuoteDeductible(globalQuoteId, deductibleType, dedLevel, itemNo);
				System.out.println(message);
				PAGE = "/pages/genericMessage.jsp";
			}//nieko 02162016 UW-SPECS-2015-086 Quotation Deductibles end
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

}
