package com.geniisys.gicl.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.service.GICLAccidentDtlService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GICLAccidentDtlController", urlPatterns={"/GICLAccidentDtlController"})
public class GICLAccidentDtlController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Logger log = Logger.getLogger(GICLAccidentDtlController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GICLAccidentDtlService giclAccidentDtlService = (GICLAccidentDtlService) APPLICATION_CONTEXT.getBean("giclAccidentDtlService");
		log.info("INITIALIZING "+this.getClass().getSimpleName());
		PAGE = "/pages/genericMessage.jsp";
		try {
			if ("getAccidentItemDtl".equals(ACTION)){
				giclAccidentDtlService.getGICLAccidentDtlGrid(request, USER);
				PAGE = ("1".equals(request.getParameter("ajax")) ? "/pages/claims/claimItemInfo/accident/accidentItemInfo.jsp" : "/pages/genericObject.jsp");
			}else if ("validateClmItemNo".equals(ACTION)) {
				message = giclAccidentDtlService.validateClmItemNo(request, USER);
			}else if ("saveClmItemAccident".equals(ACTION)){
				message = giclAccidentDtlService.saveClmItemAccident(request, USER);
			}else if ("getItemBeneficiaryDtl".equals(ACTION)){
				giclAccidentDtlService.getBeneficiaryDtlGrid(request, USER);
				PAGE = "/pages/claims/claimItemInfo/accident/subPages/beneficiaryAddtlInfo.jsp";
			}else if ("getItemClaimAvailments".equals(ACTION)){
				giclAccidentDtlService.getClmAvailmentsGrid(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					PAGE = "/pages/genericObject.jsp";
				}else{
					PAGE = "/pages/claims/claimItemInfo/accident/subPages/availmentsTBListing.jsp";
				}
			}else if("showGICLS260AccidentItemInfo".equals(ACTION)){
				Map<String, Object>params = new HashMap<String, Object>();
				params.put("ACTION", "getAccidentItemDtlGicls260");
				params.put("pageSize", 5);
				params.put("userId", USER.getUserId());
				params.put("claimId", request.getParameter("claimId"));
				params = TableGridUtil.getTableGrid(request, params);
				String json = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("url", request.getParameter("url"));
					request.setAttribute("jsonClaimItem", json);
					PAGE = "/pages/claims/inquiry/claimInformation/itemInformation/accident/accidentItemMain.jsp";
				}else{
					message = json;
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("getAcBaseAmount".equals(ACTION)){
				//message = giclAccidentDtlService.getAcBaseAmount(Integer.parseInt(request.getParameter("policyId")));	//changed by kenneth SR20950 11.12.2015
				message = giclAccidentDtlService.getAcBaseAmount(request);
				PAGE= "/pages/genericMessage.jsp";
			}
		}catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
