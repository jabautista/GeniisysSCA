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
import com.geniisys.common.service.GIISPayeesService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.service.impl.GIACParameterFacadeServiceImpl;
import com.geniisys.gicl.service.GICLLossExpDtlService;
import com.geniisys.gicl.service.GICLLossExpTaxService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="GICLLossExpTaxController", urlPatterns={"/GICLLossExpTaxController"})
public class GICLLossExpTaxController extends BaseController{

	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GICLLossExpTaxService giclLossExpTaxService = (GICLLossExpTaxService) APPLICATION_CONTEXT.getBean("giclLossExpTaxService");
		
		try{
			if("showLossExpTax".equals(ACTION)){
				GICLLossExpDtlService giclLossExpDtlService = (GICLLossExpDtlService) APPLICATION_CONTEXT.getBean("giclLossExpDtlService");
				GIISPayeesService giisPayeesService = (GIISPayeesService) APPLICATION_CONTEXT.getBean("giisPayeesService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("claimId", request.getParameter("claimId"));
				params.put("clmLossId", request.getParameter("clmLossId"));
				params.put("payeeClassCd", request.getParameter("payeeClassCd"));
				request.setAttribute("nextTaxId", giclLossExpTaxService.getNextTaxId(params));
				request.setAttribute("allWTax", giclLossExpDtlService.checkExistLossDtlAllWTax(params));
				request.setAttribute("payeeSlTypeCd", giisPayeesService.getPayeeClassSlTypeCd(request.getParameter("payeeClassCd")));
				
				GIACParameterFacadeServiceImpl giacParameterFacadeServiceImpl = (GIACParameterFacadeServiceImpl) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
				request.setAttribute("disableClmTaxFields", giacParameterFacadeServiceImpl.getParamValueV2("DISABLE_CLM_TAX_FIELDS"));
				
				PAGE = "/pages/claims/lossExpenseHistory/subPages/lossExpTax.jsp";
			}else if("getGiclLossExpTaxList".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("claimId", request.getParameter("claimId"));
				params.put("clmLossId", request.getParameter("clmLossId"));
				params.put("issCd", request.getParameter("issCd"));
				
				Map<String, Object> giclLossExpTax = TableGridUtil.getTableGrid(request, params);
				JSONObject jsonGiclLossExpTax = new JSONObject(giclLossExpTax);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("jsonGiclLossExpTax", jsonGiclLossExpTax);
					PAGE = "/pages/claims/lossExpenseHistory/subPages/lossExpTaxTableGridListing.jsp";
				}else{
					message = jsonGiclLossExpTax.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("saveLossExpTax".equals(ACTION)){
				giclLossExpTaxService.saveLossExpTax(request, USER);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("showGICLS260LossExpTax".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGiclLossExpTaxList");
				params.put("claimId", request.getParameter("claimId"));
				params.put("clmLossId", request.getParameter("clmLossId"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("userId", USER.getUserId());
				
				params = TableGridUtil.getTableGrid(request, params);
				params.remove("from");
				params.remove("to");
				params.remove("pages");
				
				JSONObject jsonGiclLossExpTax = new JSONObject(params);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("jsonGiclLossExpTax", jsonGiclLossExpTax);
					request.setAttribute("clmLossId", request.getParameter("clmLossId"));
					PAGE = "/pages/claims/inquiry/claimInformation/lossExpenseHistory/overlay/lossExpTaxListing.jsp";
				}else{
					message = jsonGiclLossExpTax.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("checkLossExpTaxType".equals(ACTION)){
				message = giclLossExpTaxService.checkLossExpTaxType(request).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkLossExpTaxExist".equals(ACTION)){ //benjo 03.08.2017 SR-5945
				message = giclLossExpTaxService.checkLossExpTaxExist(request).toString();
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
