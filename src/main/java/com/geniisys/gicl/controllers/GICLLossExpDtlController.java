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

import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.service.GIACFunctionService;
import com.geniisys.gicl.service.GICLLossExpDtlService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.Debug;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GICLLossExpDtlController", urlPatterns={"/GICLLossExpDtlController"})
public class GICLLossExpDtlController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GICLLossExpDtlService giclLossExpDtlService = (GICLLossExpDtlService) APPLICATION_CONTEXT.getBean("giclLossExpDtlService");
		
		try {
			if("getGiclLossExpDtlList".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("claimId", request.getParameter("claimId"));
				params.put("clmLossId", request.getParameter("clmLossId"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("payeeType", request.getParameter("payeeType"));
				
				Map<String, Object> giclLossExpDtl = TableGridUtil.getTableGrid(request, params);
				JSONObject jsonGiclLossExpDtl = new JSONObject(giclLossExpDtl);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("jsonGiclLossExpDtl", jsonGiclLossExpDtl);
					PAGE = "/pages/claims/lossExpenseHistory/subPages/giclLossExpDtlTableGridListing.jsp";
				}else{
					message = jsonGiclLossExpDtl.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("validateLossExpDtlDelete".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("claimId", request.getParameter("claimId"));
				params.put("clmLossId", request.getParameter("clmLossId"));
				params.put("lossExpCd", request.getParameter("lossExpCd"));
				Debug.print("Params: " + params);
				message = giclLossExpDtlService.validateLossExpDtlDelete(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateLossExpDtlUpdate".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("claimId", request.getParameter("claimId"));
				params.put("clmLossId", request.getParameter("clmLossId"));
				params.put("lossExpCd", request.getParameter("lossExpCd"));
				Debug.print("Params: " + params);
				message = giclLossExpDtlService.validateLossExpDtlUpdate(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateLossExpDtlAdd".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("claimId", request.getParameter("claimId"));
				params.put("clmLossId", request.getParameter("clmLossId"));
				params.put("lossExpCd", request.getParameter("lossExpCd"));
				Debug.print("Params: " + params);
				message = giclLossExpDtlService.validateLossExpDtlAdd(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("showLossExpDeductibles".equals(ACTION)){
				PAGE = "/pages/claims/lossExpenseHistory/subPages/lossExpDeductibles.jsp";
			}else if("getLossExpDeductiblesTableGrid".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("claimId", request.getParameter("claimId"));
				params.put("clmLossId", request.getParameter("clmLossId"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("payeeType", request.getParameter("payeeType"));
				
				Map<String, Object> lossExpDeductibles = TableGridUtil.getTableGrid(request, params);
				JSONObject jsonLossExpDeductibles = new JSONObject(lossExpDeductibles);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("jsonLossExpDeductibles", jsonLossExpDeductibles);
					PAGE = "/pages/claims/lossExpenseHistory/subPages/lossExpDeductiblesTableGridListing.jsp";
				}else{
					message = jsonLossExpDeductibles.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("computeDepreciation".equals(ACTION)){
				message = giclLossExpDtlService.computeDepreciation(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if("clearLossExpenseDeductibles".equals(ACTION)){
				message = giclLossExpDtlService.clearLossExpenseDeductibles(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateSelectedLEDeductible".equals(ACTION)){
				Map<String, Object> params = giclLossExpDtlService.validateSelectedLEDeductible(request, USER);
				StringFormatter.escapeHTMLInMap(params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("getLossExpDeductibleAmts".equals(ACTION)){
				Map<String, Object> params = giclLossExpDtlService.getLossExpDeductibleAmts(request, USER);
				StringFormatter.escapeHTMLInMap(params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("getDtlLoaList".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("claimId", request.getParameter("claimId"));
				params.put("clmLossId", request.getParameter("clmLossId"));
				params.put("lineCd", request.getParameter("lineCd"));
				
				Map<String, Object> dtlLoa = TableGridUtil.getTableGrid(request, params);
				JSONObject jsonDtlLoa = new JSONObject(dtlLoa);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("jsonDtlLoa", jsonDtlLoa);
					PAGE = "/pages/claims/lossExpenseHistory/pop-ups/dtlLoaTableGridListing.jsp";
				}else{
					message = jsonDtlLoa.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("getDtlCslList".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("claimId", request.getParameter("claimId"));
				params.put("clmLossId", request.getParameter("clmLossId"));
				params.put("lineCd", request.getParameter("lineCd"));
				
				Map<String, Object> dtlCsl = TableGridUtil.getTableGrid(request, params);
				JSONObject jsonDtlCsl = new JSONObject(dtlCsl);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("jsonDtlCsl", jsonDtlCsl);
					PAGE = "/pages/claims/lossExpenseHistory/pop-ups/dtlCslTableGridListing.jsp";
				}else{
					message = jsonDtlCsl.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("validateLossExpDeductibleDelete".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("claimId", request.getParameter("claimId"));
				params.put("clmLossId", request.getParameter("clmLossId"));
				params.put("dedLossExpCd", request.getParameter("dedLossExpCd"));
				Debug.print("Params: " + params);
				message = giclLossExpDtlService.validateLossExpDeductibleDelete(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateLossExpDeductibleUpdate".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("claimId", request.getParameter("claimId"));
				params.put("clmLossId", request.getParameter("clmLossId"));
				params.put("lossExpCd", request.getParameter("lossExpCd"));
				params.put("dedLossExpCd", request.getParameter("dedLossExpCd"));
				Debug.print("Params: " + params);
				message = giclLossExpDtlService.validateLossExpDeductibleUpdate(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveLossExpDeductibles".equals(ACTION)){
				giclLossExpDtlService.saveLossExpDeductibles(request, USER);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("showOverrideRequest".equals(ACTION)){
				GIACFunctionService giacFunctionService = (GIACFunctionService) APPLICATION_CONTEXT.getBean("giacFunctionService");
				giacFunctionService.getFunctionName(request, USER.getUserId());
				request.setAttribute("reqExists", request.getParameter("reqExists"));
				request.setAttribute("canvas", request.getParameter("canvas"));
				PAGE = "/pages/claims/lossExpenseHistory/pop-ups/overrideRequest.jsp";
			}else if("checkLOAOverrideRequestExist".equals(ACTION)){
				Map<String, Object> params = giclLossExpDtlService.checkLOAOverrideRequestExist(request, USER);
				StringFormatter.escapeHTMLInMap(params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("createLOAOverrideRequest".equals(ACTION)){
				giclLossExpDtlService.createLOAOverrideRequest(request, USER);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("showGICLS260LossExpDtls".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				String action1 = request.getParameter("action1");
				params.put("ACTION", action1);
				params.put("claimId", request.getParameter("claimId"));
				params.put("clmLossId", request.getParameter("clmLossId"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("payeeType", request.getParameter("payeeType"));
				params.put("userId", USER.getUserId());
				
				params = TableGridUtil.getTableGrid(request, params);
				params.remove("from");
				params.remove("to");
				params.remove("pages");
				
				JSONObject json = new JSONObject(params);
				
				if("1".equals(request.getParameter("ajax"))){
					if(action1.equals("getGiclLossExpDtlList")){
						request.setAttribute("jsonGiclLossExpDtl", json);
						request.setAttribute("payeeType", request.getParameter("payeeType"));
						request.setAttribute("clmLossId", request.getParameter("clmLossId"));
						PAGE = "/pages/claims/inquiry/claimInformation/lossExpenseHistory/overlay/lossExpDtlListing.jsp";
					}else if(action1.equals("getAllGiclLossExpDtlList")){
						request.setAttribute("jsonGiclLossExpDtl", json);
						request.setAttribute("payeeType", request.getParameter("payeeType"));
						request.setAttribute("clmLossId", request.getParameter("clmLossId"));
						PAGE = "/pages/claims/inquiry/claimInformation/lossExpenseHistory/overlay/lossExpDtlListing2.jsp";
					}
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("showGICLS260LossExpDeductibles".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getLossExpDeductiblesTableGrid");
				params.put("claimId", request.getParameter("claimId"));
				params.put("clmLossId", request.getParameter("clmLossId"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("payeeType", request.getParameter("payeeType"));
				params.put("userId", USER.getUserId());
				
				params = TableGridUtil.getTableGrid(request, params);
				params.remove("from");
				params.remove("to");
				params.remove("pages");
				
				JSONObject json = new JSONObject(params);
				
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("jsonLossExpDeductible", json);
					request.setAttribute("payeeType", request.getParameter("payeeType"));
					request.setAttribute("clmLossId", request.getParameter("clmLossId"));
					PAGE = "/pages/claims/inquiry/claimInformation/lossExpenseHistory/overlay/deductibleListing.jsp";
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			e.printStackTrace();
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
