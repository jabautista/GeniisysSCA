package com.geniisys.gixx.controller;

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
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GIXXItemPerilController", urlPatterns="/GIXXItemPerilController")
public class GIXXItemPerilController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIXXItemPerilController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {

		try {
			log.info("Initializing " + this.getClass().getSimpleName());
			//ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";
			
			//GIXXItemPerilService gixxItemPerilService = (GIXXItemPerilService) APPLICATION_CONTEXT.getBean("gixxItemPerilService");
			
			if("getGIXXItemPeril".equals(ACTION)){
				String perilViewType = request.getParameter("perilViewType");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("ACTION", ACTION);
				params.put("extractId", Integer.parseInt(request.getParameter("extractId")));
				//params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				params.put("packPolFlag", request.getParameter("packPolFlag"));
				params.put("packLineCd", request.getParameter("packLineCd"));
				params.put("lineCd", request.getParameter("lineCd"));
				System.out.println("perilViewType: " + perilViewType + "\nparams: " + params);
				
				//Map<String, Object> itemPerilList = gixxItemPerilService.getGIXXItemPeril(request, params);
				//params = gixxItemPerilService.getGIXXItemPeril(request, params);
				params = TableGridUtil.getTableGrid(request, params);
				
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					JSONObject json = new JSONObject(params);
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("itemPerilList", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params)));
					
					if("riPeril".equals(perilViewType)){
						PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/itemPerilRiTableGrid.jsp";
						System.out.println("ri peril");
					} else if("fiPeril".equals(perilViewType)){
						PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/itemPerilFiTableGrid.jsp";
						System.out.println("fi peril");
					} else if("mnPeril".equals(perilViewType)){
						PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/itemPerilMnTableGrid.jsp";
						System.out.println("mn peril");
					} else {
						System.out.println("other peril");
						PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/itemPerilOtherTableGrid.jsp";
					}
				}
			}
			
		} catch (SQLException e){
			message = ExceptionHandler.handleException(e, USER);
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
