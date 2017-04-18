package com.geniisys.giis.controllers;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giis.service.GIISDefaultOneRiskService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIISDefaultOneRiskController", urlPatterns={"/GIISDefaultOneRiskController"})
public class GIISDefaultOneRiskController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISDefaultOneRiskService giisDefaultOneRiskService = (GIISDefaultOneRiskService) APPLICATION_CONTEXT.getBean("giisDefaultOneRiskService");
		
		try {
			if("showGiiss065".equals(ACTION)){
				JSONObject jsonGiisDefaultDist = giisDefaultOneRiskService.showGiiss065(request, USER.getUserId());
				JSONObject jsonGiisDefaultDistAll = giisDefaultOneRiskService.showGiiss065AllRec(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					JSONObject jsonGiisDefaultDistDtl = giisDefaultOneRiskService.queryGiisDefaultDistDtl(request, USER.getUserId()); //Added by Jerome SR 5552
					JSONObject jsonGiisDefaultDistGroup = giisDefaultOneRiskService.queryGiisDefaultDistGroup(request, USER.getUserId());
					request.setAttribute("jsonGiisDefaultDistAll", jsonGiisDefaultDistAll);
					request.setAttribute("jsonGiisDefaultDist", jsonGiisDefaultDist);
					request.setAttribute("jsonGiisDefaultDistGroup", jsonGiisDefaultDistGroup);
					request.setAttribute("jsonGiisDefaultDistDtl", jsonGiisDefaultDistDtl);
					PAGE = "/pages/underwriting/fileMaintenance/general/defaultOneRiskDist/defaultOneRiskDist.jsp";
				} else {
					message = jsonGiisDefaultDist.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("valAddDefaultDistRec".equals(ACTION)){
				giisDefaultOneRiskService.valAddDefaultDistRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("valDelDefaultDistRec".equals(ACTION)){
				giisDefaultOneRiskService.valDelDefaultDistRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGiiss065".equals(ACTION)) {
				giisDefaultOneRiskService.saveGiiss065(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("queryGiisDefaultDistGroup".equals(ACTION)) {
				JSONObject jsonGiisDefaultDistGroup = giisDefaultOneRiskService.queryGiisDefaultDistGroup(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonGiisDefaultDistGroup", jsonGiisDefaultDistGroup);
					PAGE = "/pages/underwriting/fileMaintenance/general/defaultOneRiskDist/defaultOneRiskDist.jsp";
				} else {
					message = jsonGiisDefaultDistGroup.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
				
			} else if ("queryAllGiisDefaultDistGroup".equals(ACTION)) {
				JSONObject json = giisDefaultOneRiskService.queryAllGiisDefaultDistGroup(request, USER.getUserId());
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valExistingDistPerilRecord".equals(ACTION)){
				giisDefaultOneRiskService.valExistingDistPerilRecord(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("valAddDefaultDistGroupRec".equals(ACTION)){
				giisDefaultOneRiskService.valAddDefaultDistGroupRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if("showGiiss065Range".equals(ACTION)){
				JSONObject jsonGiisDefaultDistDtl = giisDefaultOneRiskService.queryGiisDefaultDistDtl(request, USER.getUserId());
				request.setAttribute("defaultNo", request.getParameter("defaultNo"));
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonGiisDefaultDistDtl", jsonGiisDefaultDistDtl);
					PAGE = "/pages/underwriting/fileMaintenance/general/defaultOneRiskDist/defaultOneRiskDist.jsp"; //Modified by Jerome 08.05.2016 SR 5552
				} else {
					message = jsonGiisDefaultDistDtl.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("validateSaveExist".equals(ACTION)){
				message = giisDefaultOneRiskService.validateSaveExist(request).toString();
				PAGE = "/pages/genericMessage.jsp";		
			}  else if ("queryGiisDefaultDistGroup2".equals(ACTION)) { //Added by Jerome SR 5552
				JSONObject jsonGiisDefaultDistGroup = giisDefaultOneRiskService.queryGiisDefaultDistGroup2(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonGiisDefaultDistGroup", jsonGiisDefaultDistGroup);
					PAGE = "/pages/underwriting/fileMaintenance/general/defaultOneRiskDist/defaultOneRiskDist.jsp";
				} else {
					message = jsonGiisDefaultDistGroup.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("getMaxSequenceNo".equals(ACTION)){
				message = giisDefaultOneRiskService.getMaxSequenceNo(request.getParameter("defaultNo") == "" ? Integer.parseInt("0") : Integer.parseInt(request.getParameter("defaultNo"))).toString();
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (SQLException e) {
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
