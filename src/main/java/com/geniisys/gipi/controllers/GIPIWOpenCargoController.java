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
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.entity.GIPIWOpenCargo;
import com.geniisys.gipi.service.GIPIWOpenCargoService;
import com.seer.framework.util.ApplicationContextReader;

/**
 * The Class GIPIWOpenCargoController.
 */
public class GIPIWOpenCargoController extends BaseController {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -6291959978219216453L;
	private static Logger log = Logger.getLogger(GIPIWOpenCargoController.class);
	
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
		log.info("do processing");
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIPIWOpenCargoService openCargoService = (GIPIWOpenCargoService) APPLICATION_CONTEXT.getBean("gipiWOpenCargoService");

			int parId = Integer.parseInt((request.getParameter("globalParId") == null || request.getParameter("globalParId") == "") ? "0" : request.getParameter("globalParId"));
			int geogCd = Integer.parseInt((request.getParameter("geogCd") == null || request.getParameter("geogCd") == "") ? "0" : request.getParameter("geogCd"));

			if ("getCargoClass".equals(ACTION)) {
				PAGE = "/pages/underwriting/subPages/cargoClass.jsp";
				List<GIPIWOpenCargo> openCargos = openCargoService.getWOpenCargo(parId, geogCd);

				LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				List<LOV> classes = lovHelper.getList(LOVHelper.CARGO_CLASS_LISTING);

				request.setAttribute("openCargos", openCargos);
				request.setAttribute("classes", classes);
			} else if ("saveWOpenCargo".equals(ACTION)) {
				String[] insCargoClassCds = request.getParameterValues("insCargoClassCd");
				String[] delCargoClassCds = request.getParameterValues("delCargoClassCd");

				Map<String, Object> delParams = new HashMap<String, Object>();
				delParams.put("cargoClassCds", delCargoClassCds);
				delParams.put("parId", parId);
				delParams.put("geogCd", geogCd);

				openCargoService.deleteWOpenCargo(delParams);

				Map<String, Object> params = new HashMap<String, Object>();
				params.put("cargoClassCds", insCargoClassCds);
				params.put("parId", parId);
				params.put("geogCd", geogCd);
				params.put("userId", USER.getUserId());

				openCargoService.saveWOpenCargo(params);
				PAGE = "/pages/genericMessage.jsp";
				message = "SUCCESS";
			} else if ("getEndtWOpenCargo".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGIPIWOpenCargoTG");
				params.put("parId", parId);
				params.put("geogCd", geogCd);
				Map<String, Object> cargoClassTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(cargoClassTableGrid);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("cargoClassTableGrid", json);
					PAGE = "/pages/underwriting/endt/jsonMarineCargo/limitsOfLiability/endtCargoClass.jsp";
				}
			}
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			doDispatch(request, response, PAGE);
		}
	}

}
