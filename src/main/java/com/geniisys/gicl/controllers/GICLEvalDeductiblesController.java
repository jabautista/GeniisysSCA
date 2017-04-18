package com.geniisys.gicl.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.FormInputUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.service.GICLEvalDeductiblesService;
import com.geniisys.gicl.service.GICLEvalVatService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GICLEvalDeductiblesController", urlPatterns="/GICLEvalDeductiblesController")
public class GICLEvalDeductiblesController extends BaseController{

	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try{
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GICLEvalDeductiblesService giclEvalDeductiblesService = (GICLEvalDeductiblesService) APPLICATION_CONTEXT.getBean("giclEvalDeductiblesService");
			
			if("showEvalDeductibleDetails".equals(ACTION)){
				PAGE = "/pages/claims/mcEvaluationReport/overlay/deductibleDetails.jsp";
			}else if("getGiclEvalDeductibles".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("evalId", request.getParameter("evalId"));
				
				Map<String, Object> giclEvalDeductibles = TableGridUtil.getTableGrid(request, params);
				JSONObject jsonGiclEvalDeductibles = new JSONObject(giclEvalDeductibles);
				
				if("1".equals(request.getParameter("refresh"))){
					message = jsonGiclEvalDeductibles.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonGiclEvalDeductibles", jsonGiclEvalDeductibles);
					PAGE = "/pages/claims/mcEvaluationReport/overlay/deductibleDetailsTGListing.jsp";
				}
			}else if("saveGiclEvalDeductibles".equals(ACTION)){
				message = giclEvalDeductiblesService.saveGiclEvalDeductibles(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if("showApplyDedDialogBox".equals(ACTION)){
				GICLEvalVatService giclEvalVatService = (GICLEvalVatService) APPLICATION_CONTEXT.getBean("giclEvalVatService");
				request.setAttribute("vatExist", giclEvalVatService.checkGiclEvalVatExist(request, USER));
				request.setAttribute("canvas", request.getParameter("canvas"));
				PAGE = "/pages/claims/mcEvaluationReport/overlay/deductibleAlert.jsp";
			}else if("applyDeductiblesForMcEval".equals(ACTION)){
				DateFormat date = new SimpleDateFormat("MM-dd-yyyy");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				params.put("lossDate", request.getParameter("lossDate") == null || "".equals(request.getParameter("lossDate")) ? null :date.parse(request.getParameter("lossDate")));
				params.put("userId", USER.getUserId());
				giclEvalDeductiblesService.applyDeductiblesForMcEval(params);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (JSONException e) {
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
