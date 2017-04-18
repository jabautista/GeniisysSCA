/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.entity.GIPIWMcAcc;
import com.geniisys.gipi.service.GIPIWMcAccService;
import com.seer.framework.util.ApplicationContextReader;

/**
 * The Class GIPIWMcAccController.
 */
public class GIPIWMcAccController extends BaseController {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 1L;

	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWMcAccController.class);

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * com.geniisys.framework.util.BaseController#doProcessing(javax.servlet
	 * .http.HttpServletRequest, javax.servlet.http.HttpServletResponse,
	 * com.geniisys.common.entity.GIISUser, java.lang.String,
	 * javax.servlet.http.HttpSession)
	 */	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {

		try {
			// System.out.println(env);
			/* default attributes */
			log.info("Initializing: " + this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader
					.getServletContext(getServletContext());
			/* end of default attributes */

			LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT
					.getBean("lovHelper"); // +env
			GIPIWMcAccService gipiWMcAccService = (GIPIWMcAccService) APPLICATION_CONTEXT
					.getBean("gipiWMcAccService");
			int parId = Integer.parseInt((request.getParameter("globalParId") == null) ? "0"
							: request.getParameter("globalParId"));
			int itemNo = Integer.parseInt((request.getParameter("itemNo") == null) ? "0"
							: request.getParameter("itemNo"));			

			if ("showAccessory".equals(ACTION)) {
				List<LOV> accessoryList = lovHelper.getList(LOVHelper.ACCESSORY_LISTING);
				request.setAttribute("accessoryListing", accessoryList);

				// List<GIPIWMcAcc> gipiWMcAcc =
				// gipiWMcAccService.getGipiWMcAcc(parId,itemNo);
				List<GIPIWMcAcc> gipiWMcAcc = gipiWMcAccService.getGipiWMcAccbyParId(parId);
				request.setAttribute("gipiWMcAcc", gipiWMcAcc);
				request.setAttribute("objGIPIWMcAccs", new JSONArray(gipiWMcAcc));
				request.setAttribute("parId", parId);
				request.setAttribute("itemNo", itemNo);
				PAGE = "/pages/underwriting/pop-ups/accessoryInformation.jsp";
			} else if ("saveAccessory".equalsIgnoreCase(ACTION)) {
				String[] accParIds = request.getParameterValues("accParIds");
				String[] accItemNos = request.getParameterValues("accItemNos");
				String[] accCds = request.getParameterValues("accCds");
				String[] accAmts = request.getParameterValues("accAmts");

				String[] delAccItemNos = request
						.getParameterValues("delAccItemNos");
				String[] delAccAccCds = request
						.getParameterValues("delAccAccCds");

				if (delAccItemNos != null) {
					System.out.println("Del Item Nos: " + delAccItemNos[0]);
					System.out.println("Del Acc Cds: " + delAccAccCds[0]);
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("delAccItemNos", delAccItemNos);
					params.put("delAccAccCds", delAccAccCds);
					params.put("parId", parId);
					params.put("userId", USER.getUserId());
					gipiWMcAccService.deleteGipiWMcAcc(params);
				}

				/*
				 * GIPIWMcAcc gipiWMcAcc = new GIPIWMcAcc();
				 * gipiWMcAcc.setParId(parId); gipiWMcAcc.setItemNo(itemNo);
				 * gipiWMcAccService.deleteGipiWMcAcc(gipiWMcAcc);
				 */

				if (accCds != null) {
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("accParIds", accParIds);
					params.put("accItemNos", accItemNos);
					params.put("accCds", accCds);
					params.put("accAmts", accAmts);
					// params.put("parId", parId);
					// params.put("itemNo", itemNo);
					params.put("userId", USER.getUserId());
					gipiWMcAccService.saveGipiWMcAcc(params);
				}
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("getGIPIWMcAccTableGrid".equals(ACTION)){
				Map<String, Object> tgParams = new HashMap<String, Object>();
				
				tgParams.put("ACTION", "getGIPIWMcAccTableGrid");
				tgParams.put("parId", Integer.parseInt(request.getParameter("parId")));
				tgParams.put("itemNo", itemNo);
				
				Map<String, Object> tgAccessories = TableGridUtil.getTableGrid(request, tgParams);
				
				request.setAttribute("tgAccessories", new JSONObject(tgAccessories));
				//request.setAttribute("allRecords", (List<GIPIWMcAcc>) StringFormatter.escapeHTMLInList(gipiWMcAccService.getGipiWMcAccbyParId(parId)));				
				
				PAGE = "/pages/underwriting/common/accessories/accessoryTableGridListing.jsp";
			} else if("refreshAccessoryTable".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				
				params.put("ACTION", "getGIPIWMcAccTableGrid");
				params.put("parId", Integer.parseInt(request.getParameter("parId")));
				params.put("itemNo", itemNo);
				
				params = TableGridUtil.getTableGrid(request, params);
				
				message = (new JSONObject(params)).toString();				
				PAGE = "/pages/genericMessage.jsp";
			}

		} catch (SQLException e) {
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
