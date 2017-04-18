package com.geniisys.giuts.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giuts.service.GIUTS023BeneficiaryInfoService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIUTS023BeneficiaryInfoController", urlPatterns="/GIUTS023BeneficiaryInfoController")
public class GIUTS023BeneficiaryInfoController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIUTS023BeneficiaryInfoService giuts023BeneficiaryInfoService = (GIUTS023BeneficiaryInfoService)APPLICATION_CONTEXT.getBean("giuts023BeneficiaryInfoService");
			
			if("showGIUTS023BeneficiaryInfo".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("APPLICATION_CONTEXT", APPLICATION_CONTEXT);
				params.put("request", request);
				giuts023BeneficiaryInfoService.populateDropDownLists(params);
				PAGE = "/pages/underwriting/reportsPrinting/enrolleeCertificate/enrolleeCertificate.jsp";
			} else if ("populateGIUTS023ItemInfoTableGrid".equals(ACTION)) {
				Map<String, Object> itemInfoTableGrid = giuts023BeneficiaryInfoService.populateGIUTS023ItemInfoTableGrid(request);
				JSONObject jsonItemInfoTableGrid = new JSONObject(itemInfoTableGrid);
				
				if("1".equals(request.getParameter("refresh"))){
					message = jsonItemInfoTableGrid.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonItemInfoTableGrid", jsonItemInfoTableGrid);
					PAGE = "/pages/underwriting/reportsPrinting/enrolleeCertificate/enrolleeCertificate.jsp";					
				}
			} else if ("populateGIUTS023GroupedItemsInfoTableGrid".equals(ACTION)) {
				Map<String, Object> groupedItemsInfoTableGrid = giuts023BeneficiaryInfoService.populateGIUTS023GroupedItemsInfoTableGrid(request);
				JSONObject jsonGroupedItemsInfoTableGrid = new JSONObject(groupedItemsInfoTableGrid);
				
				if("1".equals(request.getParameter("refresh"))){
					message = jsonGroupedItemsInfoTableGrid.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonGroupedItemsInfoTableGrid", jsonGroupedItemsInfoTableGrid);
					PAGE = "/pages/underwriting/reportsPrinting/enrolleeCertificate/enrolleeCertificate.jsp";					
				}
			} else if ("validateBeneficiary".equals(ACTION)) {
				JSONArray beneficiaryNos = new JSONArray(giuts023BeneficiaryInfoService.getGIUTS023BeneficiaryNos(request));
				request.setAttribute("object", beneficiaryNos);
				PAGE = "/pages/genericObject.jsp";
			} else if ("validateGroupedItem".equals(ACTION)) {
				JSONArray groupedItems = new JSONArray(giuts023BeneficiaryInfoService.getGIUTS023GroupedItems(request));
				request.setAttribute("object", groupedItems);
				PAGE = "/pages/genericObject.jsp";
			} else if ("validateBeneficiaryNo".equals(ACTION)) {
				request.setAttribute("object", giuts023BeneficiaryInfoService.validateBeneficiaryNo(request));
				PAGE = "/pages/genericObject.jsp";
			} else if ("populateGIUTS023beneficiaryInfoTableGrid".equals(ACTION)){
				Map<String, Object> beneficiaryInfoTableGrid = giuts023BeneficiaryInfoService.populateGIUTS023beneficiaryInfoTableGrid(request);
				JSONObject jsonBeneficiaryInfoTableGrid = new JSONObject(beneficiaryInfoTableGrid);
				
				if("1".equals(request.getParameter("refresh"))){
					message = jsonBeneficiaryInfoTableGrid.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonBeneficiaryInfoTableGrid", jsonBeneficiaryInfoTableGrid);
					PAGE = "/pages/underwriting/reportsPrinting/enrolleeCertificate/enrolleeCertificate.jsp";					
				}
			} else if ("saveGIUTS023".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("userId", USER.getUserId());
				message = giuts023BeneficiaryInfoService.saveGIUTS023(request.getParameter("parameters"), params);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showOtherCert".equals(ACTION)) {
				System.out.println("showOtherCert");
				String lineCd = request.getParameter("lineCd");
				message = giuts023BeneficiaryInfoService.showOtherCert(lineCd);
				PAGE = "/pages/genericMessage.jsp";
			}
				
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
