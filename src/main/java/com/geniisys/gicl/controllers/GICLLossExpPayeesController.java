package com.geniisys.gicl.controllers;

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

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISPayees;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISPayeesService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.service.GICLClmResHistService;
import com.geniisys.gicl.service.GICLItemPerilService;
import com.geniisys.gicl.service.GICLLossExpPayeesService;
import com.geniisys.gicl.service.GICLMortgageeService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GICLLossExpPayeesController", urlPatterns={"/GICLLossExpPayeesController"})
public class GICLLossExpPayeesController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 3984280606938527906L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GICLLossExpPayeesService giclLossExpPayeesService = (GICLLossExpPayeesService) APPLICATION_CONTEXT.getBean("giclLossExpPayeesService");
		
		try {
			if("getGiclLossExpPayeesList".equals(ACTION)){
				GICLItemPerilService giclItemPerilService = (GICLItemPerilService) APPLICATION_CONTEXT.getBean("giclItemPerilService");
				GICLClmResHistService giclClmResHistService = (GICLClmResHistService) APPLICATION_CONTEXT.getBean("giclClmResHistService");
				GICLMortgageeService giclMortgageeService = (GICLMortgageeService) APPLICATION_CONTEXT.getBean("giclMortgageeService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("claimId", request.getParameter("claimId"));
				params.put("itemNo", request.getParameter("itemNo"));
				params.put("perilCd", request.getParameter("perilCd"));
				params.put("groupedItemNo", request.getParameter("groupedItemNo"));
				params.put("polIssCd", request.getParameter("polIssCd"));
				
				Map<String, Object> giclLossExpPayees = TableGridUtil.getTableGrid(request, params);
				JSONObject jsonGiclLossExpPayees = new JSONObject(giclLossExpPayees);
				if("1".equals(request.getParameter("ajax"))){
					Map<String, Object> paramMap = giclClmResHistService.getLossExpenseReserve(request, USER);
					request.setAttribute("dfltPayeeType", giclItemPerilService.getGiclItemPerilDfltPayee(params));
					request.setAttribute("isMortgExist", giclMortgageeService.checkIfGiclMortgageeExist(params));
					request.setAttribute("lossReserve", paramMap.get("lossReserve"));
					request.setAttribute("expReserve", paramMap.get("expReserve"));
					request.setAttribute("jsonGiclLossExpPayees", jsonGiclLossExpPayees);
					PAGE = "/pages/claims/lossExpenseHistory/subPages/payeeDetailsTableGridListing.jsp";
				}else{
					message = jsonGiclLossExpPayees.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("getPayeeClmClmntNo".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("claimId", request.getParameter("claimId"));
				params.put("payeeClassCd", request.getParameter("payeeClassCd"));
				params.put("payeeCd", request.getParameter("payeeCd"));
				Integer clmClmntNo = giclLossExpPayeesService.getPayeeClmClmntNo(params);
				System.out.println("Next Clm_Claimant_no: " + clmClmntNo);
				message = clmClmntNo.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateAssdClassCd".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("claimId", request.getParameter("claimId"));
				params.put("payeeType", request.getParameter("payeeType"));
				params.put("itemNo", request.getParameter("itemNo"));
				params.put("perilCd", request.getParameter("perilCd"));
				params.put("payeeClassCd", request.getParameter("payeeClassCd"));
				params.put("assdNo", request.getParameter("assdNo"));
				message = giclLossExpPayeesService.validateAssdClassCd(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("getLossExpPayeeMortgagees".equals(ACTION)){
				GIISPayeesService payeesService = (GIISPayeesService) APPLICATION_CONTEXT.getBean("giisPayeesService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("claimId", request.getParameter("claimId"));
				params.put("itemNo", request.getParameter("itemNo"));
				params.put("perilCd", request.getParameter("perilCd"));
				params.put("payeeClassCd", request.getParameter("payeeClassCd"));
				params.put("payeeType", request.getParameter("payeeType"));
				List<GIISPayees> payeeList = payeesService.getPayeeMortgageeListing(params);
				StringFormatter.escapeHTMLInList(payeeList);
				request.setAttribute("object", new JSONArray(payeeList));
				PAGE = "/pages/genericObject.jsp";
			}
		}catch(SQLException e){
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
