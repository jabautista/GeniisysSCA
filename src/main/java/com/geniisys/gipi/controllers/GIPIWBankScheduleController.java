package com.geniisys.gipi.controllers;
import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.gipi.service.GIPIPARListService;
import com.geniisys.gipi.service.GIPIWBankScheduleService;
import com.geniisys.gipi.service.GIPIWPolbasService;
import com.geniisys.gipi.util.GIPIPARUtil;
import com.seer.framework.util.ApplicationContextReader;

public class GIPIWBankScheduleController extends BaseController {

	private static final long serialVersionUID = 1L;
	
	private static Logger log = Logger.getLogger(GIPIWBankScheduleController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			//LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
			GIPIPARListService gipiParService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");
			GIPIWPolbasService gipiWPolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService");
			GIPIWBankScheduleService gipiWBankScheduleService = (GIPIWBankScheduleService) APPLICATION_CONTEXT.getBean("gipiWBankScheduleService");
			int parId = Integer.parseInt((request.getParameter("globalParId") == null) ? "0" : request.getParameter("globalParId"));
			//parId = 37592;
			GIPIPARList gipiPAR = null;
			if (parId != 0)	{
				gipiPAR = gipiParService.getGIPIPARDetails(parId);//, packParId);
				gipiPAR.setParId(parId);
				//request.setAttribute("parDetails", gipiPAR);
				request = GIPIPARUtil.setPARInfoFromSavedPAR(request, gipiPAR);
			}
			if ("showBankCollectionPage".equals(ACTION)){
				log.info("Getting bank schedule page...");
				GIPIWPolbas pol = gipiWPolbasService.getGipiWPolbas(parId);
				request.setAttribute("acctOfCd", pol.getAcctOfCd());
				request.setAttribute("acctOfName", pol.getAcctOfName());
				System.out.println(1);
				request.setAttribute("bankSched", new JSONArray (gipiWBankScheduleService.getGIPIWBankScheduleList(parId)));
				System.out.println(2);
				PAGE = "/pages/underwriting/bankCollection.jsp";
			} else if ("saveBankPageChanges".equals(ACTION)){
				/*log.info("Saving changes...");
				Map<String, Object> params = new HashMap<String, Object>();

				JSONArray setRows = new JSONArray(request.getParameter("setRows"));
				JSONArray delRows = new JSONArray(request.getParameter("delRows"));
				
				params.put("parId", parId);
				params.put("setRows", setRows);
				params.put("delRows", delRows);*/
				
				gipiWBankScheduleService.saveGIPIWBankScheduleChanges(request.getParameter("parameter"));
				message = "SAVING SUCCESSFUL.";
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (SQLException e) {
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
