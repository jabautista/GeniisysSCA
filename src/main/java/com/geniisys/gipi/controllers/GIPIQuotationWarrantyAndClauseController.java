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
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.entity.GIPIQuote;
import com.geniisys.gipi.entity.GIPIQuoteWarrantyAndClause;
import com.geniisys.gipi.service.GIPIQuoteFacadeService;
import com.geniisys.gipi.service.GIPIQuoteWarrantyAndClauseFacadeService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

/**
 * The Class GIPIQuotationWarrantyAndClauseController.
 */
public class GIPIQuotationWarrantyAndClauseController extends BaseController {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 1648900170783895119L;
	private static Logger log = Logger.getLogger(GIPIQuotationWarrantyAndClauseController.class);
	
	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, 
			GIISUser USER, String ACTION, HttpSession SESSION) throws ServletException, IOException { //, String env
		
		try	{
			/*default attributes*/
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			/*end of default attributes*/
			log.info("INITIALIZING: "+GIPIQuotationWarrantyAndClauseController.class.getSimpleName());
			/* Definition services needed */
			GIPIQuoteFacadeService serv = (GIPIQuoteFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteFacadeService"); // +env
			GIPIQuoteWarrantyAndClauseFacadeService gipiWcService = (GIPIQuoteWarrantyAndClauseFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteWarrantyAndClausesFacadeService"); // +env
			
			int quoteId = Integer.parseInt((request.getParameter("quoteId") == null) ? "0" : request.getParameter("quoteId"));
			GIPIQuote gipiQuote = null;
			if (quoteId != 0)	{
				gipiQuote = (GIPIQuote) StringFormatter.escapeHTMLInObject(serv.getQuotationDetailsByQuoteId(quoteId)); // added StringFormatter - christian 04/06/2013
				gipiQuote.setQuoteId(quoteId);
				request.setAttribute("gipiQuote", gipiQuote);
			}
			
			if("showWCPage".equals(ACTION)){
				PAGE = "/pages/marketing/quotation/warrantyAndClauses.jsp";
				String[] args = {gipiQuote.getLineCd()};
				LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // +env
				List<LOV> wcTitles = lovHelper.getList(LOVHelper.WARRANTY_LISTING, args);
				request.setAttribute("wcTitles", (List<LOV>)StringFormatter.replaceQuotesInList(wcTitles));
			}else if ("goToPage".equals(ACTION)){
				int pageNo = Integer.parseInt(request.getParameter("pageNo"));
				PAGE = "/pages/marketing/quotation/subPages/warrantyAndClausesTable.jsp";
				request = this.getWarrantiesAndClauses(request, gipiWcService, quoteId, pageNo);
			}else if ("saveWC".equals(ACTION)){
				String[] wcCds = request.getParameterValues("wcCd");
				String[] printSeqNos = request.getParameterValues("printSeqNo");
				String[] wcTitles = request.getParameterValues("wcTitle");
				String[] wcTexts = request.getParameterValues("wcText");
				String[] printSws = request.getParameterValues("printSw");
				String[] changeTags = request.getParameterValues("changeTag");
				String[] wcTitles2 = request.getParameterValues("wcTitle2");
				String[] swcSeqNos = request.getParameterValues("swcSeqNo");
				
				Map<String, Object> parameters = new HashMap<String, Object>();
				
				parameters.put("wcCds", wcCds);
				parameters.put("printSeqNos", printSeqNos);
				parameters.put("wcTitles", wcTitles);
				parameters.put("wcTexts", wcTexts);
				parameters.put("printSws", printSws);
				parameters.put("changeTags", changeTags);
				parameters.put("wcTitles2", wcTitles2);
				parameters.put("swcSeqNos", swcSeqNos);
				
				parameters.put("quoteId", quoteId);
				parameters.put("lineCd", gipiQuote.getLineCd());
				parameters.put("userId", USER.getUserId());
				
				gipiWcService.deleteWC(quoteId);
				if (wcCds != null ) {
					gipiWcService.saveWC(parameters);
				}
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("deleteWC".equals(ACTION)){
				gipiWcService.deleteWC(quoteId);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
				
			} else if ("showWarrClaPage".equals(ACTION)){ // Udel - 03262012 - Added action to dispatch JSON-enabled page.
				String[] args = {gipiQuote.getLineCd()};
				LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				List<LOV> wcTitles = lovHelper.getList(LOVHelper.WARRANTY_LISTING, args);
				request.setAttribute("wcTitles", (List<LOV>)StringFormatter.replaceQuotesInList(wcTitles));
				System.out.println(gipiQuote.getQuoteId());
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getQuotationWarrCla");
				params.put("moduleId", request.getParameter("moduleId") == null ? "GIIMM008" : request.getParameter("moduleId"));
				params.put("appUser", USER.getUserId());
				params.put("quoteId", gipiQuote.getQuoteId());
				
				Map<String, Object> quoteWarrClaTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject jsonQuoteWarrClaTableGrid = new JSONObject(quoteWarrClaTableGrid);
				System.out.println(jsonQuoteWarrClaTableGrid.getJSONArray("rows").toString());
				JSONArray rows = jsonQuoteWarrClaTableGrid.getJSONArray("rows");
				for (int i = 0; i < rows.length(); i++) {
					rows.getJSONObject(i).put("tbgPrintSw", rows.getJSONObject(i).getString("printSw").equals("Y") ? true : false);
					rows.getJSONObject(i).put("tbgChangeTag", (rows.getJSONObject(i).getString("changeTag").equals("Y") ? true : false));
				}
				jsonQuoteWarrClaTableGrid.remove("rows");
				jsonQuoteWarrClaTableGrid.put("rows", rows);
				if ("1".equals(request.getParameter("refresh"))){
					message = jsonQuoteWarrClaTableGrid.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("jsonQuoteWarrClaTableGrid", jsonQuoteWarrClaTableGrid);
					PAGE = "/pages/marketing/quotation/quotationWarrCla.jsp";
				}
			
			} else if ("saveGIPIQuotationWarrCla".equals(ACTION)){ // Udel - 03262012 - Added action to handle saving of records from JSON-enabled page.
				System.out.println(USER.getUserId());
				gipiWcService.saveGIPIQuoteWc(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			
			}else if("checkQuotePerilDefaultWarranty".equals(ACTION)){
				String lineCd = request.getParameter("lineCd");
				Integer perilCd = request.getParameter("perilCd").equals("") ? null : Integer.parseInt(request.getParameter("perilCd"));
				message = gipiWcService.checkQuotePerilDefaultWarranty(quoteId, lineCd, perilCd);
				log.info("Default warranty existence = "+ message + " for perilCd: " + perilCd + " for line: " + lineCd );
				PAGE = "/pages/genericMessage.jsp";
			}else if("showPackQuotationWCPage".equals(ACTION)){
				Integer packQuoteId = request.getParameter("packQuoteId")== null ? 0 : Integer.parseInt(request.getParameter("packQuoteId"));
				List<GIPIQuote> packQuoteList = serv.getGipiPackQuoteList(packQuoteId);
				List<GIPIQuoteWarrantyAndClause> packQuoteWCList = gipiWcService.getPackQuotationWarrantiesAndClauses(packQuoteId);
				StringFormatter.escapeHTMLInList(packQuoteList);
				StringFormatter.escapeHTMLInList(packQuoteWCList);
				request.setAttribute("objPackQuoteList", new JSONArray(packQuoteList));
				request.setAttribute("objPackQuoteWCList", new JSONArray(packQuoteWCList));
				request.setAttribute("packQuoteList", packQuoteList);
				PAGE = "/pages/marketing/quotation-pack/quotationWarrantiesAndClauses-pack/packQuotationWarrantiesAndClauseMain.jsp";
			}else if("getQuotationWarrantyListing".equals(ACTION)){
				String lineCd = request.getParameter("lineCd");
				String[] args = {lineCd}; 
				LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); 
				List<LOV> wcTitles = lovHelper.getList(LOVHelper.WARRANTY_LISTING, args);
				StringFormatter.replaceQuotesInList(wcTitles);
				JSONArray wcList = new JSONArray(wcTitles);
				message = wcList.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveWarrAndClausesForPackQuotation".equals(ACTION)){
				JSONArray setRows = new JSONArray(request.getParameter("setRows"));
				JSONArray delRows = new JSONArray(request.getParameter("delRows"));
				System.out.println("USER ID: " + USER.getUserId());
				gipiWcService.savePackQuotationWarrantiesAndClauses(setRows, delRows, USER.getUserId()); //added userId parameter - christian 01/30/2013
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if ("validatePrintSeqNo".equals(ACTION)) { //added by steven 5.25.201
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("moduleId", request.getParameter("moduleId") == null ? "GIIMM008" : request.getParameter("moduleId"));
				params.put("appUser", USER.getUserId());
				params.put("quoteId", request.getParameter("quoteId"));
				params.put("printSeqNo", request.getParameter("printSeqNo"));
				
				message = gipiWcService.validatePrintSeqNo(params);
				PAGE = "/pages/genericMessage.jsp";
			}
			request.setAttribute("quoteId", request.getParameter("quoteId"));
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e) {
			message = "Unhandled exception occured...<br />" + e.getCause();
			PAGE = "/pages/genericMessage.jsp";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
	
	/**
	 * Gets the warranties and clauses.
	 * 
	 * @param request the request
	 * @param gipiWcService the gipi wc service
	 * @param quoteId the quote id
	 * @param pageNo the page no
	 * @return the warranties and clauses
	 * @throws SQLException the sQL exception
	 */
	private HttpServletRequest getWarrantiesAndClauses(HttpServletRequest request, 
			GIPIQuoteWarrantyAndClauseFacadeService gipiWcService, 
			int quoteId, int pageNo)	throws SQLException {
		List<GIPIQuoteWarrantyAndClause> gipiQuoteWCs = gipiWcService.getGIPIQuoteWarrantyAndClauses(quoteId);
		request.setAttribute("gipiQuoteWCs", gipiQuoteWCs);
		return request;
	}

}