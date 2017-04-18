package com.geniisys.common.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISTariffRatesHdr;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.common.service.GIISTariffRatesHdrService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.seer.framework.util.ApplicationContextReader;

public class GIISTariffRatesHdrController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIISTariffRatesHdrService giisTariffRatesHdrService = (GIISTariffRatesHdrService) APPLICATION_CONTEXT.getBean("giisTariffRatesHdrService");
			int parId = Integer.parseInt((request.getParameter("globalParId") == null) ? "0" : request.getParameter("globalParId"));
			GIISParameterFacadeService giisParameterFacadeService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
			
			if ("getTariffDetails".equals(ACTION)){
				GIISTariffRatesHdr tarf = new GIISTariffRatesHdr();
				String lineCd = request.getParameter("globalLineCd");
				String sublineCd = request.getParameter("globalSublineCd");
				Integer perilCd = Integer.parseInt(request.getParameter("perilCd"));
				Integer itemNo = Integer.parseInt(request.getParameter("itemNo"));
				String lineMotor = request.getParameter("lineMotor");
				String lineFire = request.getParameter("lineFire");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", lineCd);
				params.put("sublineCd", sublineCd);
				params.put("perilCd", perilCd);
				params.put("itemNo", itemNo);
				params.put("parId", parId);
				if (lineCd.equals(lineFire)) {
					tarf = giisTariffRatesHdrService.getTariffDetailsFI(params);
				} else if (lineCd.equals(lineMotor)){
					Integer coverageCd = Integer.parseInt(request.getParameter("coverageCd"));
					params.put("coverageCd", coverageCd);
					tarf = giisTariffRatesHdrService.getTariffDetailsMC(params);
				}
				message = tarf.getPremTag().toString() + "," + tarf.getTarfSw().toString() + "," + tarf.getTariffCd().toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("showGiiss106".equals(ACTION)){
				JSONObject json = giisTariffRatesHdrService.showGiiss106(request, USER.getUserId());
				String varMc = giisParameterFacadeService.getParamValueV2("LINE_CODE_MC");
				String varFi = giisParameterFacadeService.getParamValueV2("LINE_CODE_FI");
				
				if(request.getParameter("refresh") == null) {
					JSONObject jsonFixedSI = giisTariffRatesHdrService.showGiiss106FixedSIList(request, USER.getUserId());
					request.setAttribute("varMc", varMc);
					request.setAttribute("varFi", varFi);
					request.setAttribute("jsonDefaultPerilRate", json);
					request.setAttribute("jsonFixedSIList", jsonFixedSI);
					PAGE = "/pages/underwriting/fileMaintenance/general/defaultPerilRate/defaultPerilRate.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("getGiiss106FixedSIList".equals(ACTION)){ 
				JSONObject json = giisTariffRatesHdrService.showGiiss106FixedSIList(request, USER.getUserId());
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
//			}else if("getGiiss106WithCompDtl".equals(ACTION)){//remove by steven 07.04.2014
//				JSONObject json = giisTariffRatesHdrService.getGiiss106WithCompDtl(request.getParameter("tariffCd"));
//				message = json.toString();
//				PAGE = "/pages/genericMessage.jsp";
//			}else if("getGiiss106FixedPremDtl".equals(ACTION)){
//				JSONObject json = giisTariffRatesHdrService.getGiiss106FixedPremDtl(request.getParameter("tariffCd"));
//				message = json.toString();
//				PAGE = "/pages/genericMessage.jsp";
			}else if ("valAddHdrRec".equals(ACTION)){
				giisTariffRatesHdrService.valAddHdrRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			}else if ("valDeleteHdrRec".equals(ACTION)){
				giisTariffRatesHdrService.valDeleteHdrRec(request.getParameter("tariffCd"));
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if ("valTariffRatesFixedSIRec".equals(ACTION)){
				giisTariffRatesHdrService.valTariffRatesFixedSIRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
//			}else if("getGiiss106MinMaxAmt".equals(ACTION)){
//				message = giisTariffRatesHdrService.getGiiss106MinMaxAmt(Integer.parseInt(request.getParameter("tariffCd"))).toString();
//				PAGE = "/pages/genericMessage.jsp";	
			}else if ("valAddDtlRec".equals(ACTION)) {
				giisTariffRatesHdrService.valAddDtlRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if ("saveGiiss106".equals(ACTION)) {
				giisTariffRatesHdrService.saveGiiss106(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("getGiiss106AllRec".equals(ACTION)){
				JSONObject json = giisTariffRatesHdrService.getGiiss106AllRec(request, USER.getUserId());
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("getGiiss106AllFixedSIList".equals(ACTION)){
				JSONObject json = giisTariffRatesHdrService.getGiiss106AllFixedSIList(request, USER.getUserId());
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("highLowValidation".equals(ACTION)){
				BigDecimal high = request.getParameter("high").equals("") || request.getParameter("high").equals(null) ? null : new BigDecimal(request.getParameter("high"));  
				BigDecimal low =  request.getParameter("low").equals("") || request.getParameter("low").equals(null) ? null : new BigDecimal(request.getParameter("low"));
				BigDecimal fixedSI = request.getParameter("fixedSI").equals("") || request.getParameter("fixedSI").equals(null) ? null : new BigDecimal(request.getParameter("fixedSI"));
				String id = request.getParameter("id");
				String msg = "OK";
				if (fixedSI == null) {
					msg = "Please enter Fixed Sum Insured first.";
				}else{
					if (high != null && (high.compareTo(fixedSI) == 1)){
						msg = "Highest limit should never exceed the fixed sum insured.";
					}else if(low != null && (low.compareTo(fixedSI) == 1)){
						msg = "Lowest limit should never exceed the fixed sum insured.";
					}else if((high != null && low != null) && (high.compareTo(low) == -1 || high.compareTo(low) == 0)){
						msg = id.equals("txtHigherRange") ? "Highest limit should never exceed the fixed sum insured." : "Lowest limit must be lower than the highest limit.";
					}
				}
				message = msg;
				PAGE = "/pages/genericMessage.jsp";
			}else if("validPrevAmt".equals(ACTION)){
				BigDecimal high =  request.getParameter("high").equals("") || request.getParameter("high").equals(null) ? null : new BigDecimal(request.getParameter("high"));
				BigDecimal low =  request.getParameter("low").equals("") || request.getParameter("low").equals(null) ? null : new BigDecimal(request.getParameter("low"));
				BigDecimal maxAmt = new BigDecimal(request.getParameter("maxAmt"));
				String msg = "OK";
				if (high != null || low != null) {
					if (high != null && (high.compareTo(maxAmt) == -1 || high.compareTo(maxAmt) == 0)){
						msg = "h error";
					}else if(low != null && (low.compareTo(maxAmt) == -1 || low.compareTo(maxAmt) == 0)){
						msg = "l error";
					}
				}
				message = msg;
				PAGE = "/pages/genericMessage.jsp";
			}
			
		}  catch (SQLException e) {
			if(e.getErrorCode() > 20000){ 
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
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
