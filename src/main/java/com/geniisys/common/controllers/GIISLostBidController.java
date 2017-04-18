package com.geniisys.common.controllers;

import java.io.IOException;
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
import com.geniisys.common.entity.GIISLostBid;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.common.service.GIISLostBidService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.entity.GIPIQuote;
import com.geniisys.gipi.service.GIPIQuoteFacadeService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIISLostBidController extends BaseController {

	private static final long serialVersionUID = -1152832373352032577L;
	private static Logger log = Logger.getLogger(GIISLostBidController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException{
		log.info("doProcessing");
		try {
			ApplicationContext appContext = ApplicationContextReader.getServletContext(getServletContext());
			GIISLostBidService giisLostBid = (GIISLostBidService) appContext.getBean("giisLostBidService");
			GIPIQuoteFacadeService quoteService = (GIPIQuoteFacadeService) appContext.getBean("gipiQuoteFacadeService");

			if ("showReasonMaintenance".equals(ACTION)) {
				List<GIISLostBid> reasons = giisLostBid.getLostBidReasonList(USER.getUserId());
				LOVHelper lovHelper = (LOVHelper) appContext
						.getBean("lovHelper");

				String[] param = { "GIISS204", USER.getUserId() };
				List<LOV> lineList = lovHelper.getList(
						LOVHelper.REASON_LINELISTING, param);
				List<GIPIQuote> usedReasons = quoteService
						.getDistinctReasonCds();
				StringFormatter.replaceQuotesInList(reasons);

				request.setAttribute("reasons", reasons);
				request.setAttribute("lines", lineList);
				request.setAttribute("usedReasons", usedReasons);

				PAGE = "/pages/common/reason/reasonMaintenance.jsp";
				/*
				 * } else if("generateReasonCode".equals(ACTION)) { Integer rCd
				 * = giisLostBid.generateReasonCd();
				 * request.setAttribute("reasonCode", rCd); PAGE =
				 * "/pages/common/reason/subpages/newReasonCd.jsp";
				 */
			} else if ("showReasonMaintenanceTableGrid".equals(ACTION)) {														
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("userId", USER.getUserId());
				params.put("ACTION", "getLostBidReasonTableGrid");				
				Map<String, Object> reasons = TableGridUtil.getTableGrid(request, params);
				JSONObject objReason = new JSONObject(reasons);
				
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("giisReasonMaintListTableGrid", objReason);
					PAGE = "/pages/common/reason/reasonMaintenanceTableGrid.jsp";
				}else{
					message = objReason.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}
			else if("saveReasonInfoTableGrid".equals(ACTION)){
				JSONObject objParams = new JSONObject(request.getParameter("param"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("delParams", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("delReasons")), USER.getUserId(), GIISLostBid.class));
				params.put("insParams", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("setReasons")), USER.getUserId(), GIISLostBid.class));
				giisLostBid.saveLostBidReason(params);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}
			else if ("saveReasonInfo".equals(ACTION)) {
				String[] delReasonCds = request
						.getParameterValues("delReasonCd");
				Map<String, Object> delParams = new HashMap<String, Object>();

				delParams.put("reasonCds", delReasonCds);
				String[] reasonCds = request.getParameterValues("insReasonCd");
				String[] descriptions = request
						.getParameterValues("insReasonDesc");
				String[] remarks = request.getParameterValues("insRemarks");
				String[] lineCds = request.getParameterValues("insLineCd");
				// System.out.println("btn add: " +
				// request.getParameter("btnAdd"));
				if (reasonCds == null) {
					reasonCds = request.getParameterValues("reasonCd");
					descriptions = request.getParameterValues("reasonDesc");
					remarks = request.getParameterValues("remarks");
					lineCds = request.getParameterValues("lineCd");
				}

				for (int i = 0; i < reasonCds.length; i++) {
					System.out.println(descriptions[i]);
				}
				Map<String, Object> insParams = new HashMap<String, Object>();

				insParams.put("reasonCds", reasonCds);
				insParams.put("descriptions", descriptions);
				insParams.put("remarks", remarks);
				insParams.put("lineCds", lineCds);
				insParams.put("userId", USER.getUserId());

				Map<String, Object> allParameters = new HashMap<String, Object>();
				allParameters.put("delParams", delParams);
				allParameters.put("insParams", insParams);

				giisLostBid.saveLostBidReason(allParameters);

				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
				
				System.out.println("saving done");
			}else if ("valUpdateRec".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params = giisLostBid.valUpdateRec(request);	
				JSONObject result = new JSONObject(params);
				message = result.toString();		
				PAGE = "/pages/genericMessage.jsp";
			}else if ("valDeleteRec".equals(ACTION)){
				giisLostBid.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRec".equals(ACTION)){
				giisLostBid.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGiiss204".equals(ACTION)) {
				giisLostBid.saveGiiss204(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}
			/*
			 * else if("deleteReasonInfo".equals(ACTION)) { Integer lostBidCd =
			 * Integer.parseInt(request.getParameter("delLostBid"));
			 * giisLostBid.deleteLostBidReason(lostBidCd); //message =
			 * "Reason for Denial Deleted"; //PAGE =
			 * "/pages/genericMessage.jsp"; }
			 */
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);	
		}
	}
	
}
