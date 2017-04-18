package com.geniisys.common.controllers;

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
import com.geniisys.common.service.GIISTaxChargesService;
import com.geniisys.common.service.GIISTaxIssuePlaceService;
import com.geniisys.common.service.GIISTaxPerilService;
import com.geniisys.common.service.GIISTaxRangeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIISTaxChargesController", urlPatterns={"/GIISTaxChargesController"})
public class GIISTaxChargesController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 2049523732024084499L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISTaxChargesService giisTaxChargesService = (GIISTaxChargesService) APPLICATION_CONTEXT.getBean("giisTaxChargesService");
		GIISTaxPerilService giisTaxPerilService = (GIISTaxPerilService) APPLICATION_CONTEXT.getBean("giisTaxPerilService");
		GIISTaxIssuePlaceService giisTaxIssuePlaceService = (GIISTaxIssuePlaceService) APPLICATION_CONTEXT.getBean("giisTaxIssuePlaceService");
		GIISTaxRangeService giisTaxRangeService = (GIISTaxRangeService) APPLICATION_CONTEXT.getBean("giisTaxRangeService");
		
		try {
			if("showGiiss028".equals(ACTION)){
				JSONObject json = giisTaxChargesService.showGiiss028(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonTaxChargesList", json);
					PAGE = "/pages/underwriting/fileMaintenance/general/taxCharge/taxCharge.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if("getTaxPeril".equals(ACTION)){
				JSONObject json = giisTaxPerilService.showTaxPeril(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonTaxPerilList", json);
					PAGE = "/pages/underwriting/fileMaintenance/general/taxCharge/subPages/taxPeril.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if("getTaxPlaceList".equals(ACTION)){
				JSONObject json = giisTaxIssuePlaceService.showTaxPlace(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonTaxPlaceList", json);
					PAGE = "/pages/underwriting/fileMaintenance/general/taxCharge/subPages/taxPlace.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if("getTaxRangeList".equals(ACTION)){
				JSONObject json = giisTaxRangeService.showTaxRange(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonTaxRangeList", json);
					PAGE = "/pages/underwriting/fileMaintenance/general/taxCharge/subPages/taxRange.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if("getTaxExpiryOverlay".equals(ACTION)){
				PAGE = "/pages/underwriting/fileMaintenance/general/taxCharge/subPages/expiryOverlay.jsp";
			}else if ("valDeleteRec".equals(ACTION)){
				giisTaxChargesService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("saveGiiss028Dtl".equals(ACTION)) {
				giisTaxPerilService.saveGiiss028TaxPeril(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("saveGiiss028TaxPlace".equals(ACTION)) {
				giisTaxIssuePlaceService.saveGiiss028TaxPlace(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("saveGiiss028".equals(ACTION)) {
				giisTaxChargesService.saveGiiss028(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}  else if ("saveGiiss028TaxRange".equals(ACTION)) {
				giisTaxRangeService.saveGiiss028TaxRange(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valDeleteTaxPlaceRec".equals(ACTION)){
				giisTaxIssuePlaceService.valDeleteTaxPlaceRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRec".equals(ACTION)){
				message = giisTaxChargesService.valAddRec(request);
				PAGE = "/pages/genericMessage.jsp";
			}  else if ("valDateOnAdd".equals(ACTION)){
				message = giisTaxChargesService.valDateOnAdd(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valSeqOnAdd".equals(ACTION)){
				giisTaxChargesService.valSeqOnAdd(request);
				message = "SUCCESS";
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
