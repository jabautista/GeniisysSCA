package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.gipi.service.GIPIWCosignatoryService;
import com.seer.framework.util.ApplicationContextReader;

public class GIPIWCosignatoryController extends BaseController{

	private static Logger log = Logger.getLogger(GIPIWCosignatoryController.class);
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
			GIPIWCosignatoryService gipiWCosignatoryService = (GIPIWCosignatoryService) APPLICATION_CONTEXT.getBean("gipiWCosignatoryService");
			int parId = Integer.parseInt((request.getParameter("globalParId") == null) ? "0" : request.getParameter("globalParId"));
			if ("loadCosignorsListingTable".equals(ACTION)){
				log.info("Getting cosignors listing...");
				
				String assdNo = (request.getParameter("globalAssdNo") == null) ? "0" : request.getParameter("globalAssdNo");
				System.out.println("assdNo: "+assdNo);
				String[] args = {assdNo};
				request.setAttribute("cosignNames", lovHelper.getList(LOVHelper.COSIGNORS_LISTING, args));
				
				request.setAttribute("cosignorsListing", gipiWCosignatoryService.getGIPIWCosignatory(parId));
				PAGE = "/pages/underwriting/subPages/cosignorsListing.jsp";
			} else if ("saveCosignListingChanges".equals(ACTION)){
				log.info("Saving changes...");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", parId);
				
				String[] cosignIds = request.getParameterValues("cosignId");
				params.put("cosignIds", cosignIds);
				
				if (cosignIds != null){
					for (int i=0; i<cosignIds.length; i++){
						System.out.println("cosignId: "+cosignIds[i]);
					}
					for (int i=0; i<cosignIds.length; i++){
						Map<String, Object> cosignMap = new HashMap<String, Object>();
						
						Integer cosignId =Integer.parseInt(request.getParameter("cosignId"+cosignIds[i]));
						Integer assdNo =Integer.parseInt(request.getParameter("assdNo"+cosignIds[i]));
						String indemFlag = request.getParameter("indemFlag"+cosignIds[i]);
						String bondsFlag = request.getParameter("bondsFlag"+cosignIds[i]);
						String bondsRiFlag = request.getParameter("bondsRiFlag"+cosignIds[i]);
						
						System.out.println("i: "+i);
						System.out.println("CONTROLLER - parId: "+parId);
						System.out.println("CONTROLLER - cosignId: "+cosignId);
						System.out.println("CONTROLLER - assdNo: "+assdNo);
						System.out.println("CONTROLLER - indemFlag: "+indemFlag);
						System.out.println("CONTROLLER - bondsFlag: "+bondsFlag);
						System.out.println("CONTROLLER - bondsRiFlag: "+bondsRiFlag);
						
						cosignMap.put("parId", parId);
						cosignMap.put("cosignId", cosignId);
						cosignMap.put("assdNo", assdNo);
						cosignMap.put("indemFlag", indemFlag);
						cosignMap.put("bondsFlag", bondsFlag);
						cosignMap.put("bondsRiFlag", bondsRiFlag);
						
						params.put(cosignIds[i], cosignMap);
						
					}
				}
				gipiWCosignatoryService.saveGIPIWCosignatoryPageChanges(params);
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
