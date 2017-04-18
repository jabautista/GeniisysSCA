package com.geniisys.gicl.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.geniisys.gicl.service.GICLClaimLossExpenseService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet (name="GICLClaimLossExpenseController", urlPatterns="/GICLClaimLossExpenseController")
public class GICLClaimLossExpenseController extends BaseController {

	private static final long serialVersionUID = 1L;
	private Logger log = Logger.getLogger(GICLClaimLossExpenseController.class);
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			log.info("Initializing : "+this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GICLClaimLossExpenseService giclClmLossExpServ = (GICLClaimLossExpenseService) APPLICATION_CONTEXT.getBean("giclClaimLossExpenseService");
			if("getClmHistInfo".equals(ACTION)){
				message = giclClmLossExpServ.getClmHistInfo(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getSettlementHistInfo".equals(ACTION)) {
				Map<String, Object>  giclLossExpense = giclClmLossExpServ.getSettlementHist(request, USER);
				request.setAttribute("objSettlementHist", new JSONObject(giclLossExpense));
				PAGE = "/pages/claims/claimReportsPrintDocs/subPages/settlementHist.jsp";
			} else if("getGICLClmLossExpList".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("claimId", request.getParameter("claimId"));
				params.put("adviceId", request.getParameter("adviceId"));
				params.put("lineCd", request.getParameter("lineCd"));
				JSONObject json = new JSONObject(TableGridUtil.getTableGrid(request, params));
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("getClmLossExpList".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("claimId", request.getParameter("claimId"));
				params.put("payeeType", request.getParameter("payeeType"));
				params.put("payeeClassCd", request.getParameter("payeeClassCd"));
				params.put("payeeCd", request.getParameter("payeeCd"));
				params.put("itemNo", request.getParameter("itemNo"));
				params.put("perilCd", request.getParameter("perilCd"));
				params.put("clmClmntNo", request.getParameter("clmClmntNo"));
				params.put("groupedItemNo", request.getParameter("groupedItemNo"));
				JSONObject json = new JSONObject(TableGridUtil.getTableGrid(request, params));
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("jsonGiclClmLossExpense", json);
					PAGE = "/pages/claims/lossExpenseHistory/subPages/clmLossExpTableGridListing.jsp";
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("saveLossExpenseHistory".equals(ACTION)){
				giclClmLossExpServ.saveLossExpenseHistory(request, USER);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateHistSeqNo".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("claimId", request.getParameter("claimId"));
				params.put("itemNo", request.getParameter("itemNo"));
				params.put("perilCd", request.getParameter("perilCd"));
				message = giclClmLossExpServ.validateHistSeqNo(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("getViewHistoryListing".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("claimId", request.getParameter("claimId"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("payeeType", request.getParameter("payeeType"));
				params.put("payeeClassCd", request.getParameter("payeeClassCd"));
				params.put("payeeCd", request.getParameter("payeeCd"));
				params.put("itemNo", request.getParameter("itemNo"));
				params.put("perilCd", request.getParameter("perilCd"));
				JSONObject json = new JSONObject(TableGridUtil.getTableGrid(request, params));
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("jsonViewHistory", json);
					request.setAttribute("copySw", request.getParameter("copySw"));
					PAGE = "/pages/claims/lossExpenseHistory/pop-ups/viewHistoryTableGridListing.jsp";
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("cancelHistory".equals(ACTION)){
				giclClmLossExpServ.cancelHistory(request, USER);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("clearHistory".equals(ACTION)){
				giclClmLossExpServ.clearHistory(request, USER);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("copyHistory".equals(ACTION)){
				message = giclClmLossExpServ.copyHistory(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if("showLossExpLOAPage".equals(ACTION)){
				GIACParameterFacadeService giacParamService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
				request.setAttribute("overrideLoa", giacParamService.getParamValueV2("OVERRIDE_LOA_WITH_UNPAID_PREMIUM"));
				PAGE = "/pages/claims/lossExpenseHistory/pop-ups/loa.jsp";
			}else if("getLOATableGridList".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("claimId", request.getParameter("claimId"));
				
				Map<String, Object> loa = TableGridUtil.getTableGrid(request, params);
				JSONObject jsonLoa = new JSONObject(loa);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("jsonLoa", jsonLoa);
					PAGE = "/pages/claims/lossExpenseHistory/pop-ups/loaTableGridListing.jsp";
				}else{
					message = jsonLoa.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("showLossExpCSLPage".equals(ACTION)){
				GIACParameterFacadeService giacParamService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
				request.setAttribute("overrideCsl", giacParamService.getParamValueV2("OVERRIDE_LOA_WITH_UNPAID_PREMIUM"));
				PAGE = "/pages/claims/lossExpenseHistory/pop-ups/csl.jsp";
			}else if("getCSLTableGridList".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("claimId", request.getParameter("claimId"));
				
				Map<String, Object> csl = TableGridUtil.getTableGrid(request, params);
				JSONObject jsonCsl = new JSONObject(csl);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("jsonCsl", jsonCsl);
					PAGE = "/pages/claims/lossExpenseHistory/pop-ups/cslTableGridListing.jsp";
				}else{
					message = jsonCsl.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("showGICLS260LossExpenseHistory".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGiclItemPerilGrid3");
				params.put("claimId", request.getParameter("claimId"));
				params = TableGridUtil.getTableGrid(request, params);
				String json = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
				
				if("1".equals(request.getParameter("ajax"))){
					GIISParameterFacadeService giisParametersService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
					request.setAttribute("implemSw", giisParametersService.getParamValueV2("IMPLEMENTATION_SW"));
					request.setAttribute("jsonGiclItemPeril", json);
					PAGE = "/pages/claims/inquiry/claimInformation/lossExpenseHistory/lossExpHistMain.jsp";
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("showGICLS260LossExpViewHist".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("ACTION", "getViewHistoryListing");
					params.put("claimId", request.getParameter("claimId"));
					params.put("lineCd", request.getParameter("lineCd"));
					params.put("payeeType", request.getParameter("payeeType"));
					params.put("payeeClassCd", request.getParameter("payeeClassCd"));
					params.put("payeeCd", request.getParameter("payeeCd"));
					params.put("itemNo", request.getParameter("itemNo"));
					params.put("perilCd", request.getParameter("perilCd"));
					JSONObject json = new JSONObject(TableGridUtil.getTableGrid(request, params));
				
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("jsonViewHist", json);
					request.setAttribute("itemNo", request.getParameter("itemNo"));
					request.setAttribute("perilCd", request.getParameter("perilCd"));
					request.setAttribute("payeeType", request.getParameter("payeeType"));
					request.setAttribute("payeeClassCd", request.getParameter("payeeClassCd"));
					request.setAttribute("payeeCd", request.getParameter("payeeCd"));
					request.setAttribute("clmLossId", request.getParameter("clmLossId"));
					PAGE = "/pages/claims/inquiry/claimInformation/lossExpenseHistory/overlay/viewHistoryListing.jsp";
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("checkHistoryNumber".equals(ACTION)){ //Kenneth 06162015 SR3616
				giclClmLossExpServ.checkHistoryNumber(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}
		}catch(SQLException e){
			if(e.getErrorCode() > 20000){ 
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		} catch (JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch(NullPointerException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally{
			System.out.println("ACTION : " + ACTION);
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}