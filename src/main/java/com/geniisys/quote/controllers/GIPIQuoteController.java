package com.geniisys.quote.controllers;

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

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.service.GIPIQuoteVesAirService;
import com.geniisys.quote.entity.GIPIQuote;
import com.geniisys.quote.entity.GIPIQuotePictures;
import com.geniisys.quote.service.GIPIQuoteItemService;
import com.geniisys.quote.service.GIPIQuotePicturesService;
import com.geniisys.quote.service.GIPIQuoteService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name = "GIPIQuoteController", urlPatterns = { "/GIPIQuoteController" })
public class GIPIQuoteController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Logger log = Logger.getLogger(GIPIQuoteController.class);

	@SuppressWarnings("unchecked")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			log.info("Initializing :" + this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader
					.getServletContext(getServletContext());
			LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT
					.getBean("lovHelper");
			GIPIQuoteService gipiQuoteService = (GIPIQuoteService) APPLICATION_CONTEXT
					.getBean("gipiQuoteService");
			GIPIQuoteItemService gipiQuoteItemService = (GIPIQuoteItemService) APPLICATION_CONTEXT
					.getBean("gipiQuoteItemService");
			GIPIQuoteVesAirService gipiQuoteVesAirService = (GIPIQuoteVesAirService) APPLICATION_CONTEXT
					.getBean("gipiQuoteVesAirService");
			GIISParameterFacadeService giisParametersService = (GIISParameterFacadeService) APPLICATION_CONTEXT
					.getBean("giisParameterFacadeService");

			if ("showQuoteInformationPage".equals(ACTION)) {
				Integer quoteId = Integer.parseInt((request
						.getParameter("quoteId") == null) ? "0" : request
						.getParameter("quoteId"));
				String lineCd = request.getParameter("lineCd");
				String requireMcCompany = giisParametersService
						.getParamValueV2("REQUIRE_MC_COMPANY");
				Integer maxQuoteItemNo = gipiQuoteItemService
						.getMaxQuoteItemNo(quoteId);
				Integer vesAirQuoteId = null;
				if (lineCd.equals("MH") || lineCd.equals("MN")) {
					vesAirQuoteId = gipiQuoteVesAirService
							.checkIfGIPIQuoteVesAirExist2(quoteId);
				}
				request.setAttribute("lineCd", lineCd);
				GIPIQuote gipiQuote = null;
				if (quoteId != 0) {
					gipiQuote = gipiQuoteService
							.getQuotationDetailsByQuoteId(quoteId);
					gipiQuote.setQuoteId(quoteId);
					GIPIQuotePicturesService quotePicturesService = (GIPIQuotePicturesService) APPLICATION_CONTEXT.getBean("gipiQuotePicturesService2");
					List<GIPIQuotePictures> attachedMedia = gipiQuote.getAttachedMedia(); //Halley 10.11.2013
					//gipiQuote.setAttachedMedia((List<GIPIQuotePictures>) StringFormatter.escapeHTMLInList(quotePicturesService.getMediaSizes(attachedMedia)));  //Halley 10.11.2013
					gipiQuote.setAttachedMedia((List<GIPIQuotePictures>) StringFormatter.escapeHTMLInList(attachedMedia));
					// request.setAttribute("gipiQuoteObj", new
					// JSONObject((GIPIQuote)StringFormatter.replaceQuotesInObject(gipiQuote)));
					request.setAttribute(
							"gipiQuoteObj",
							new JSONObject((GIPIQuote) StringFormatter
									.escapeHTMLInObject(gipiQuote))); // belle
																		// 09212012
				}
				String[] coverageParams = { gipiQuote.getLineCd(),
						gipiQuote.getSublineCd() };
				request.setAttribute(
						"currencyLovJSON",
						new JSONArray(lovHelper
								.getList(LOVHelper.CURRENCY_CODES)));
				request.setAttribute("coverageLovJSON",new JSONArray((List<?>)StringFormatter.escapeHTMLInList4(lovHelper.getList(LOVHelper.COVERAGE_CODES, coverageParams))));	//Gzelle 05222015 SR4112
				request.setAttribute("defaultCurrencyCd", (lovHelper
						.getList(LOVHelper.DEFAULT_CURRENCY)).get(0).getCode());
				request.setAttribute("vesAirQuoteId", vesAirQuoteId);
				request.setAttribute("maxQuoteItemNo", maxQuoteItemNo);
				request.setAttribute("requireMcCompany", requireMcCompany);
				Map<String, Object> params = new HashMap<String, Object>();
				String action = this.getQuoteItemLineAction(lineCd);
				params.put("ACTION", action);
				params.put("quoteId", request.getParameter("quoteId"));
				// params.put("pageSize", 5);
				Map<String, Object> itemInfoGrid = TableGridUtil.getTableGrid(
						request, params);
				JSONObject json = new JSONObject(itemInfoGrid);
				request.setAttribute("itemInfoGrid", json);

				Map<String, Object> mortgageeParams = new HashMap<String, Object>();
				mortgageeParams.put("ACTION", "getDetailMortgageeList");
				/*
				 * mortgageeParams.put("quoteId",request.getParameter("quoteId"))
				 * ; mortgageeParams.put("itemNo",
				 * request.getParameter("itemNo")); mortgageeParams.put("issCd",
				 * request.getParameter("issCd"));
				 */
				Map<String, Object> mortgageeItems = StringFormatter
						.escapeHTMLInMap(TableGridUtil.getTableGrid(request,
								mortgageeParams));
				JSONObject mortJson = new JSONObject(mortgageeItems);
				request.setAttribute("mortgageeList", mortJson);

				PAGE = "/pages/marketing/quote/quotationInformationMain.jsp";
			} else if ("refreshQuotationListing".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				String lineCd = request.getParameter("lineCd");
				String action = this.getQuoteItemLineAction(lineCd);
				params.put("ACTION", action);
				params.put("quoteId", request.getParameter("quoteId"));
				// params.put("pageSize", 5);
				params = TableGridUtil.getTableGrid(request, params);
				message = (new JSONObject(params)).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showViewQuotationStatusPage".equals(ACTION)) {
				Integer quoteId = Integer.parseInt((request
						.getParameter("quoteId") == null) ? "0" : request
						.getParameter("quoteId"));
				String lineCd = request.getParameter("lineCd");
				String requireMcCompany = giisParametersService
						.getParamValueV2("REQUIRE_MC_COMPANY");
				Integer vesAirQuoteId = null;
				if (lineCd.equals("MH") || lineCd.equals("MN")) {
					vesAirQuoteId = gipiQuoteVesAirService
							.checkIfGIPIQuoteVesAirExist2(quoteId);
				}
				request.setAttribute("lineCd", lineCd);
				GIPIQuote gipiQuote = null;
				if (quoteId != 0) {
					gipiQuote = gipiQuoteService
							.getQuotationDetailsByQuoteId(quoteId);
					gipiQuote.setQuoteId(quoteId);
					gipiQuote.setAttachedMedia(null); // SR-21674 JET JAN-18-2016
					request.setAttribute(
							"gipiQuoteObj",
							new JSONObject((GIPIQuote) StringFormatter
									.escapeHTMLInObject(gipiQuote))); // belle
																		// 09212012
				}
				String[] coverageParams = { gipiQuote.getLineCd(),
						gipiQuote.getSublineCd() };
				request.setAttribute(
						"currencyLovJSON",
						new JSONArray(lovHelper
								.getList(LOVHelper.CURRENCY_CODES)));
				request.setAttribute(
						"coverageLovJSON",
						new JSONArray(lovHelper.getList(
								LOVHelper.COVERAGE_CODES, coverageParams)));
				request.setAttribute("vesAirQuoteId", vesAirQuoteId);
				request.setAttribute("requireMcCompany", requireMcCompany);
				Map<String, Object> params = new HashMap<String, Object>();
				String action = this.getQuoteItemLineAction(lineCd);
				params.put("ACTION", action);
				params.put("quoteId", request.getParameter("quoteId"));
				Map<String, Object> itemInfoGrid = TableGridUtil.getTableGrid(
						request, params);
				JSONObject json = new JSONObject(itemInfoGrid);
				request.setAttribute("itemInfoGrid", json);

				Map<String, Object> mortgageeParams = new HashMap<String, Object>();
				mortgageeParams.put("ACTION", "getDetailMortgageeList");
				Map<String, Object> mortgageeItems = StringFormatter
						.escapeHTMLInMap(TableGridUtil.getTableGrid(request,
								mortgageeParams));
				JSONObject mortJson = new JSONObject(mortgageeItems);
				request.setAttribute("mortgageeList", mortJson);

				PAGE = "/pages/marketing/quotation/inquiry/quotationStatus/viewQuotationStatusMain.jsp";
			} else if ("viewQuotationInformation".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getQuotationNoInfo");
				Map<String, Object> quotationNoTableGrid = TableGridUtil
						.getTableGrid(request, params);
				JSONObject jsonQuotationNo = new JSONObject(quotationNoTableGrid);
				request.setAttribute("jsonQuotationNo", jsonQuotationNo);
				PAGE = "/pages/marketing/quotation/inquiry/quotationInformation/viewQuotationInformation.jsp";
			} else if ("viewQuotationNo".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getQuotationNoInfo");				
				params.put("packQuoteId", request.getParameter("packQuoteId"));
				Map<String, Object> quotationNoTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject jsonQuotationNo = new JSONObject(quotationNoTableGrid);
				message = jsonQuotationNo.toString();
				PAGE = "/pages/genericMessage.jsp";

			}
		} catch (SQLException e) {
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: "
					+ e.getCause());
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (NullPointerException e) {
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: "
					+ e.getCause());
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e) {
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: "
					+ e.getCause());
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

	private String getQuoteItemLineAction(String lineCd) {
		String action = null;
		if (lineCd.equals("FI")) {
			action = "getQuoteFIItemInfoList";
		} else if ("AC".equals(lineCd) || "PA".equals(lineCd)) {
			action = "getQuoteACItemInfoList";
		} else if (lineCd.equals("CA")) {
			action = "getQuoteCAItemInfoList";
		} else if (lineCd.equals("MH")) {
			action = "getQuoteMHItemInfoList";
		} else if (lineCd.equals("AV")) {
			action = "getQuoteAVItemInfoList";
		} else if (lineCd.equals("EN")) {
			action = "getQuoteENItemInfoList";
		} else if (lineCd.equals("MN")) {
			action = "getQuoteMNItemInfoList";
		} else if (lineCd.equals("MC")) {
			action = "getQuoteMCItemInfoList";
		} else {
			action = "getQuoteItemInfoList";
		}
		return action;
	}

}
