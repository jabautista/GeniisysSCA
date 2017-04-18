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
import com.geniisys.common.entity.LOV;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.FormInputUtil;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.QueryParamGenerator;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.entity.GIACTaxesWheld;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.geniisys.giac.service.GIACTaxesWheldService;
import com.geniisys.giac.service.GIACWholdingTaxesService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIACTaxesWheldController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	/** The logger */
	private static Logger log = Logger.getLogger(GIACTaxesWheldController.class);

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		PAGE = "/pages/genericMessage.jsp";
		
		Integer gaccTranId = (request.getParameter("gaccTranId") == null || request.getParameter("gaccTranId").equals("") || request.getParameter("gaccTranId").equals("null")) ? 0 : Integer.parseInt(request.getParameter("gaccTranId"));
		
		log.info("Gacc Tran Id: " + gaccTranId);
		
		try {
			if ("showOtherTransWithholdingTax".equals(ACTION)) {
				GIACTaxesWheldService giacTaxesWheldService = (GIACTaxesWheldService) APPLICATION_CONTEXT.getBean("giacTaxesWheldService");
				LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				GIACParameterFacadeService giacParameterService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
				String[] whtaxCodeArgs = {request.getParameter("gaccBranchCd") == null ? null : request.getParameter("gaccBranchCd").toString()};
				
				List<GIACTaxesWheld> giacTaxesWheldList = giacTaxesWheldService.getGiacTaxesWheld(gaccTranId);
				String allowUpdateWholdingTax = giacParameterService.getParamValueV2("ALLOW_UPDATE_WHOLD_TAX");
				
				request.setAttribute("giacTaxesWheldList", new JSONArray((List<GIACTaxesWheld>) StringFormatter.escapeHTMLInList(giacTaxesWheldList)));
				request.setAttribute("payeeClassCdListing", lovHelper.getList(LOVHelper.PAYEE_CLASS_LISTING));
				request.setAttribute("whtaxCodeListing", lovHelper.getList(LOVHelper.WHOLDING_TAXES_CODE_LISTING_BY_BRANCH, whtaxCodeArgs));
				
				request.setAttribute("allowUpdateWholdingTax", allowUpdateWholdingTax);
				
				PAGE = "/pages/accounting/officialReceipt/otherTrans/withholdingTax.jsp";
			}else if ("showOtherTransWithholdingTaxTableGrid".equals(ACTION)) { //added by steven 6.6.2012
				LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				GIACParameterFacadeService giacParameterService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
				String[] whtaxCodeArgs = {request.getParameter("gaccBranchCd") == null ? null : request.getParameter("gaccBranchCd").toString()};
				
				String allowUpdateWholdingTax = giacParameterService.getParamValueV2("ALLOW_UPDATE_WHOLD_TAX");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", request.getParameter("gaccTranId"));
				params.put("ACTION", "getGIACTaxesWheld2");
				
				Map<String, Object> giacTaxesWheld = TableGridUtil.getTableGrid(request, params);
				JSONObject objGiacTaxesWheld = new JSONObject(giacTaxesWheld);
				
				request.setAttribute("payeeClassCdListing", lovHelper.getList(LOVHelper.PAYEE_CLASS_LISTING));
				request.setAttribute("whtaxCodeListing", lovHelper.getList(LOVHelper.WHOLDING_TAXES_CODE_LISTING_BY_BRANCH, whtaxCodeArgs));
				request.setAttribute("allowUpdateWholdingTax", allowUpdateWholdingTax);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("objGiacTaxesWheld", objGiacTaxesWheld);
					PAGE = "/pages/accounting/officialReceipt/otherTrans/withholdingTaxTableGrid.jsp";
				}else{
					message = objGiacTaxesWheld.toString();
					PAGE =  "/pages/genericMessage.jsp";
				}
				
			} else if ("getPayeeCdListingByClassCd".equals(ACTION)) {
				LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				String[] args = {request.getParameter("payeeClassCd") == null ? "" : request.getParameter("payeeClassCd")};
				List<LOV> payeeListing = lovHelper.getList(LOVHelper.PAYEES_LISTING_BY_CLASS_CD, args);
				
				StringFormatter.replaceQuotesInList(payeeListing);
				
				System.out.println("LOV Size for " + request.getParameter("payeeClassCd") + " : " + payeeListing.size());
				
				request.setAttribute("object", new JSONArray(payeeListing));
				
				PAGE = "/pages/genericObject.jsp";
			} else if ("validateWhtaxCode".equals(ACTION)) {
				GIACWholdingTaxesService giacWholdingTaxesService = (GIACWholdingTaxesService) APPLICATION_CONTEXT.getBean("giacWholdingTaxesService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				
				giacWholdingTaxesService.validateGiacs022WhtaxCode(params);
				
				message = QueryParamGenerator.generateQueryParams(params);
			}else if ("validateItemNo".equals(ACTION)) {
				GIACWholdingTaxesService giacWholdingTaxesService = (GIACWholdingTaxesService) APPLICATION_CONTEXT.getBean("giacWholdingTaxesService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("itemNo", request.getParameter("itemNo"));
				params.put("gaccTranId", request.getParameter("gaccTranId"));
				
				message = giacWholdingTaxesService.validateItemNo(params);
			} else if ("saveTaxesWheld".equals(ACTION)) {
				GIACTaxesWheldService giacTaxesWheldService = (GIACTaxesWheldService) APPLICATION_CONTEXT.getBean("giacTaxesWheldService");
				JSONObject objParams = new JSONObject(request.getParameter("param"));
				Map<String, Object> params = new HashMap<String, Object>();
				
				JSONArray setRows = new JSONArray(objParams.getString("setWHoldingTax"));
				JSONArray delRows = new JSONArray(objParams.getString("delWHoldingTax"));
				
				params.put("gaccTranId", request.getParameter("gaccTranId"));
				params.put("gaccBranchCd", request.getParameter("gaccBranchCd"));
				params.put("gaccFundCd", request.getParameter("gaccFundCd"));
				params.put("varModuleName", request.getParameter("varModuleName"));
				params.put("tranSource", request.getParameter("tranSource"));
				params.put("orFlag", request.getParameter("orFlag"));
				params.put("appUser", USER.getUserId());
				
				giacTaxesWheldService.saveGIACTaxesWheld(setRows, delRows, params);
				
				message = QueryParamGenerator.generateQueryParams(params);
			}else if ("saveBir2307History".equals(ACTION)) {//Added by pjsantos 12/22/2016, GENQA 5898
				GIACTaxesWheldService giacTaxesWheldService = (GIACTaxesWheldService) APPLICATION_CONTEXT.getBean("giacTaxesWheldService");
                Map<String, Object> params = new HashMap<String, Object>();				
				params.put("gaccTranId", request.getParameter("gaccTranId"));	
				params.put("saveItems", request.getParameter("saveItems"));
				params.put("appUser", USER.getUserId());
				message = giacTaxesWheldService.saveBir2307History(params); 
				PAGE = "/pages/genericMessage.jsp";
			}
			
		}
		//Added by pjsantos 01/09/2017, to show user defined error message, GENQA 5898
		catch(SQLException e) {
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		}//pjsantos end
		catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
