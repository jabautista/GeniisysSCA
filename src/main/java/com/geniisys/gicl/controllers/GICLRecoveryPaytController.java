package com.geniisys.gicl.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.print.PrintService;
import javax.print.PrintServiceLookup;
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
import com.geniisys.gicl.service.GICLRecoveryPaytService;
import com.seer.framework.util.ApplicationContextReader;

public class GICLRecoveryPaytController extends BaseController{

	private static final long serialVersionUID = 3146781105889021036L;
	private Logger log = Logger.getLogger(GICLRecoveryPaytController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			log.info("Initializing :"+this.getClass().getSimpleName());
			ApplicationContext appContext = ApplicationContextReader.getServletContext(getServletContext());
			GICLRecoveryPaytService recoveryPaytService = (GICLRecoveryPaytService) appContext.getBean("giclRecoveryPaytService");
			
			if("showGenerateRecoveryAcct".equals(ACTION)) {
				log.info("showGenerateRecoveryAcct");
				recoveryPaytService.gicl055NewFormInstance(request, USER, appContext);
				PAGE = "/pages/claims/generateRecoveryAcctgEntries/generateRecoveryAcctgEntries.jsp";
			} else if("getRecoveryPaytListing".equals(ACTION)) {
				recoveryPaytService.getRecoveryPaytListing(request, null, USER.getUserId());
				PAGE=request.getParameter("refresh").equals("1") ? "/pages/genericObject.jsp" : "/pages/claims/generateRecoveryAcctgEntries/generateRecoveryAcctgEntries.jsp";
			} else if("showDistDetailsModal".equals(ACTION)) {
				if("DS".equals(request.getParameter("loadTG"))) {
					System.out.println("showDistDetailsModal - refresh DS");
					recoveryPaytService.getGiclDistributions(request, USER.getUserId());
				} else if("riDS".equals(request.getParameter("loadTG"))) {
					System.out.println("showDistDetailsModal - refresh rids");
					recoveryPaytService.getGiclRiDistributions(request, USER.getUserId());
				} else {
					System.out.println("showDistDetailsModal - load overlay");
					recoveryPaytService.getGiclDistributions(request, USER.getUserId());
					recoveryPaytService.getGiclRiDistributions(request, USER.getUserId());
					request.setAttribute("recoveryId", request.getParameter("recoveryId"));
					request.setAttribute("recPaytId", request.getParameter("recoveryPaytId"));
				}
				PAGE = "0".equals(request.getParameter("loadTG")) ? "/pages/claims/generateRecoveryAcctgEntries/popUps/recoveryDistDetails.jsp" : "/pages/genericObject.jsp";
			} else if("cancelRecoveryPayt".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("recoveryAcctId", request.getParameter("recoveryAcctId").equals("") ? 0 : Integer.parseInt(request.getParameter("recoveryAcctId")));
				params.put("acctTranId", request.getParameter("acctTranId"));
				//params.put("tranDate", request.getParameter("tranDate"));
				params.put("userId", USER.getUserId());
				params = recoveryPaytService.cancelRecoveryPayt(params);
				System.out.println("cancelRecoveryPayt: "+params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			} else if("showPostRecovery".equals(ACTION)) {
				PAGE = "/pages/claims/generateRecoveryAcctgEntries/popUps/postRecovery.jsp";
			} else if("showRecAcctEntries".equals(ACTION)) {
				recoveryPaytService.getRecAcctEntries(request, USER.getUserId(), appContext);
				PAGE=request.getParameter("refresh").equals("1") ? "/pages/genericObject.jsp" : "/pages/claims/generateRecoveryAcctgEntries/popUps/recoveryAcctEntries.jsp";
			} else if("saveRecAE".equals(ACTION)) {
				String param = request.getParameter("parameters");
				System.out.println("saveGICLAcctEntries - "+param);
				recoveryPaytService.saveGICLAcctEntries(new JSONObject(param), USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("generateRecAcctInfo".equals(ACTION)) {
				System.out.println("generateRecAcctInfo...");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("issCd", request.getParameter("issCd"));
				message = (new JSONObject(recoveryPaytService.generateRecAcctInfo(params))).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("generateRecovery".equals(ACTION)) {
				String param = request.getParameter("parameters");
				System.out.println("Generating recovery account: "+param);
				message = recoveryPaytService.generateRecovery(new JSONObject(param), USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			} else if("setRecoveryAcct".equals(ACTION)) {
				String param = request.getParameter("parameters");
				System.out.println("Saving recovery accts - "+param);
				recoveryPaytService.setRecoveryAcct(new JSONObject(param), USER.getUserId());
			} else if("showPrintRecAEDialog".equals(ACTION)) {
				System.out.println("show Print Recovery Acctg. Entry...");
				LOVHelper helper = (LOVHelper) appContext.getBean("lovHelper");
				List<LOV> printerList = helper.getList(LOVHelper.PRINTER_LISTING);
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				String printerNames = "";
				for(int i=0; i<printers.length; i++) {
					printerNames = printerNames + printers[i].getName();
					if(i != (printers.length-1)) {
						printerNames = printerNames+",";
					}
				}
				
				request.setAttribute("printerNames", printerNames);
				request.setAttribute("printers", printerList);
				
				PAGE = "/pages/claims/generateRecoveryAcctgEntries/popUps/printRecAE.jsp";
			}else if("checkRecoveryValidPayt".equals(ACTION)){
				message =  recoveryPaytService.checkRecoveryValidPayt(request, USER);
				PAGE = "/pages/genericObject.jsp";
			}else if("getGiclRecoveryPaytGrid".equals(ACTION)){
				log.info("Getting Recovery distribution details...");
				recoveryPaytService.getGiclRecoveryPaytGrid(request, USER);
				PAGE = "1".equals(request.getParameter("refresh")) ? "/pages/genericObject.jsp" :"/pages/claims/lossRecovery/recoveryInformation/subPages/recoveryDistribution.jsp";
			}else if("getGiclDistributionsGrid".equals(ACTION)){
				log.info("Getting Recovery DS details...");
				recoveryPaytService.getGiclDistributions(request, USER.getUserId());
				PAGE = "1".equals(request.getParameter("refresh")) ? "/pages/genericObject.jsp" :"/pages/claims/lossRecovery/recoveryInformation/subPages/recoveryDistDS.jsp";
			}else if("getGiclRecoveryRidsGrid".equals(ACTION)){
				log.info("Getting Recovery Rids details...");
				recoveryPaytService.getGiclRecoveryRidsGrid(request, USER);
				PAGE = "1".equals(request.getParameter("refresh")) ? "/pages/genericObject.jsp" :"/pages/claims/lossRecovery/recoveryInformation/subPages/recoveryDistRids.jsp";
			}else if("showGICLS260RecoveryPayt".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGiclRecoveryPaytGrid2");
				params.put("claimId", request.getParameter("claimId"));
				params.put("recoveryId", request.getParameter("recoveryId"));
				params.put("userId", USER.getUserId());
				
				params = TableGridUtil.getTableGrid(request, params);
				
				JSONObject json = new JSONObject(params);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("jsonRecoveryPayt", json);
					request.setAttribute("recoveryId", request.getParameter("recoveryId"));
					PAGE = "/pages/claims/inquiry/claimInformation/lossRecovery/overlay/paymentDetails.jsp";
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("showGICLS260RecoveryDist".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGICLRecoveryDSTGListing");
				params.put("claimId", request.getParameter("claimId"));
				params.put("recoveryId", request.getParameter("recoveryId"));
				params.put("recoveryPaytId", request.getParameter("recoveryPaytId"));
				params.put("userId", USER.getUserId());
				
				params = TableGridUtil.getTableGrid(request, params);
				
				JSONObject json = new JSONObject(params);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("jsonRecoveryDS", json);
					request.setAttribute("recoveryId", request.getParameter("recoveryId"));
					request.setAttribute("recoveryPaytId", request.getParameter("recoveryPaytId"));
					PAGE = "/pages/claims/inquiry/claimInformation/lossRecovery/overlay/recoveryDistribution.jsp";
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("getGICLS260RecoveryRids".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGiclRecoveryRidsGrid");
				params.put("claimId", request.getParameter("claimId"));
				params.put("recoveryId", request.getParameter("recoveryId"));
				params.put("recoveryPaytId", request.getParameter("recoveryPaytId"));
				params.put("recDistNo", request.getParameter("recDistNo"));
				params.put("grpSeqNo", request.getParameter("grpSeqNo"));
				params.put("userId", USER.getUserId());
				
				params = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(params);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("showRecovAmtOverlay".equals(ACTION)){ 
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("claimId", request.getParameter("claimId"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("recoveryId", request.getParameter("recoveryId"));
				params.put("ACTION", "getRecoverableDetailsLOV");
				Map<String, Object> recoveryAmountTG = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(recoveryAmountTG);
                if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
                	message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
                } else {
                	request.setAttribute("recoveryAmountTG", json);
                	PAGE = "/pages/claims/lossRecovery/recoveryInformation/subPages/recoveryAmountOverlay.jsp";
                }
                request.setAttribute("claimId", request.getParameter("claimId"));
                request.setAttribute("recoveryId", request.getParameter("recoveryId"));
                request.setAttribute("lineCd", request.getParameter("lineCd"));
			}else if("getRecAEAmountSum".equals(ACTION)) { //benjo 08.27.2015 UCPBGEN-SR-19654
				System.out.println("getRecAEAmountSum...");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("recoveryAcctId", request.getParameter("recoveryAcctId"));
				message = (new JSONObject(recoveryPaytService.getRecAEAmountSum(params))).toString();
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch(SQLException e){
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		} catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
