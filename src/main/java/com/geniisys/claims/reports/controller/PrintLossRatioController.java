package com.geniisys.claims.reports.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.context.ApplicationContext;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ConnectionUtil;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="PrintLossRatioController", urlPatterns={"/PrintLossRatioController"})
public class PrintLossRatioController extends BaseController{

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
     * 
     */
    @Override
    public void doProcessing(HttpServletRequest request,
            HttpServletResponse response, GIISUser USER, String ACTION,
            HttpSession SESSION) throws ServletException, IOException {
        
        ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
        DataSourceTransactionManager client = null;
        client = (DataSourceTransactionManager) APPLICATION_CONTEXT.getBean("transactionManager");
        GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
        
        try{
            if("printReportGicls204".equals(ACTION)){
                String reportId = request.getParameter("reportId");
                String reportVersion = reportsService.getReportVersion(reportId);
                String reportDir = getServletContext().getRealPath("WEB-INF/classes/com/geniisys/claims/reports/lossratio")+"/";
                String reportName = reportVersion == null ? reportId : reportId+"_"+reportVersion;
                DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
                
                Map<String, Object> params = new HashMap<String, Object>();
                params.put("P_SESSION_ID", request.getParameter("sessionId"));
                params.put("P_PRNT_DATE", request.getParameter("prntDate"));
                if("GICLR204A".equals(reportId) || "GICLR204B".equals(reportId) || "GICLR204C".equals(reportId) || "GICLR204D".equals(reportId)
                   || "GICLR204E".equals(reportId) || "GICLR204F".equals(reportId)){
                    params.put("P_AS_OF_DATE", request.getParameter("date") == null || request.getParameter("date") == "" ? null : df.parse(request.getParameter("date")));
                    params.put("P_DATE", request.getParameter("date"));
                    params.put("P_LINE_CD", request.getParameter("lineCd"));
                    params.put("P_SUBLINE_CD", request.getParameter("sublineCd"));
                    params.put("P_INTM_NO", request.getParameter("intmNo"));
                    params.put("P_ISS_CD", request.getParameter("issCd"));
                    params.put("P_ASSD_NO", request.getParameter("assdNo"));
                    params.put("packageName", "CSV_LOSS_RATIO"); // added by carlo de guzman 3.15.2016 SR 5394
					params.put("functionName", "csv_"+reportId);    // added by carlo de guzman 3.15.2016 SR 5394
					params.put("csvAction", "print"+reportId+"CSV");   // added by carlo de guzman 3.15.2016 SR 5394
                    if("GICLR204B".equals(reportId)){
                        params.put("P_SESSION_ID", Integer.parseInt(request.getParameter("sessionId")));
                        params.put("P_INTM_NO", request.getParameter("intmNo") == null || request.getParameter("intmNo") == "" ? null : Integer.parseInt(request.getParameter("intmNo")));
                        params.put("P_ASSD_NO", request.getParameter("assdNo") == null || request.getParameter("assdNo") == "" ? null : Integer.parseInt(request.getParameter("assdNo")));
                        //Start by John Michael Mabini 03/22/2016 SR-5386
						params.put("csvAction", "printGICLR204BCSV");
						params.put("packageName", "csv_loss_ratio");
						params.put("functionName", "csv_giclr204B");
						//End by John Michael Mabini 03/22/2016 SR-5386
                    }else if("GICLR204E".equals(reportId)){ // removed || "GICLR204F".equals(reportId) by carlo rubenecia SR5394 05.25.2016
                        params.put("P_SESSION_ID", new BigDecimal(request.getParameter("sessionId")));
                        params.put("P_ASSD_NO", request.getParameter("assdNo") == null || request.getParameter("assdNo") == "" ? null : new BigDecimal(request.getParameter("assdNo")));
                        params.put("P_INTM_NO", request.getParameter("intmNo") == null || request.getParameter("intmNo") == "" ? null : new BigDecimal(request.getParameter("intmNo")));
                        params.put("P_DATE", request.getParameter("date"));
                        //Mark SR-5391 ADDED CSV for GICLS204E 03/22/2016
                        params.put("csvAction", "printGICLR204E");
                        params.put("packageName", "CSV_LOSS_RATIO");
                        params.put("functionName", "csv_giclr204E");
                        //Mark SR-5391 ADDED CSV for GICLS204E 03/22/2016 END 
                    }else if("GICLR204F".equals(reportId)){ //seperate from GICLR204E to avoid conflict when printing csv, carlo rubenecia SR 5394 05.25.2016
                        params.put("P_SESSION_ID", new BigDecimal(request.getParameter("sessionId")));
                        params.put("P_ASSD_NO", request.getParameter("assdNo") == null || request.getParameter("assdNo") == "" ? null : new BigDecimal(request.getParameter("assdNo")));
                        params.put("P_INTM_NO", request.getParameter("intmNo") == null || request.getParameter("intmNo") == "" ? null : new BigDecimal(request.getParameter("intmNo")));
                        params.put("P_DATE", request.getParameter("date"));
                    }else if("GICLR204C".equals(reportId)){
                        params.put("P_SESSION_ID", new BigDecimal(request.getParameter("sessionId")));
                        params.put("P_ASSD_NO", request.getParameter("assdNo") == null || request.getParameter("assdNo") == "" ? null : new BigDecimal(request.getParameter("assdNo")));
                        params.put("P_INTM_NO", request.getParameter("intmNo") == null || request.getParameter("intmNo") == "" ? null : new BigDecimal(request.getParameter("intmNo")));
                        params.put("csvAction", "printGICLR204C");
                        params.put("packageName", "CSV_LOSS_RATIO");
                        params.put("functionName", "GICLR204C");
                    }else if("GICLR204D".equals(reportId)){
                        params.put("P_SESSION_ID", new BigDecimal(request.getParameter("sessionId")));
                        params.put("P_ASSD_NO", request.getParameter("assdNo") == null || request.getParameter("assdNo") == "" ? null : new BigDecimal(request.getParameter("assdNo")));
                        params.put("P_INTM_NO", request.getParameter("intmNo") == null || request.getParameter("intmNo") == "" ? null : new BigDecimal(request.getParameter("intmNo")));
                        params.put("csvAction", "printGICLR204D");
                        params.put("packageName", "CSV_LOSS_RATIO");
                        params.put("functionName", "GICLR204D");
                    }
                }else if("GICLR204A2".equals(reportId) || "GICLR204A3".equals(reportId) || "GICLR204B2".equals(reportId) || "GICLR204B3".equals(reportId)
                         || "GICLR204C2".equals(reportId) || "GICLR204C3".equals(reportId) || "GICLR204D2".equals(reportId) || "GICLR204D3".equals(reportId) 
                         || "GICLR204E2".equals(reportId) || "GICLR204E3".equals(reportId) || "GICLR204F2".equals(reportId) || "GICLR204F3".equals(reportId)
                         || "GICLR204A2_PREM_WRIT_CY".equals(reportId) || "GICLR204A2_PREM_WRIT_PY".equals(reportId) || "GICLR204A2_OS_LOSS_CY".equals(reportId) || "GICLR204A2_OS_LOSS_PY".equals(reportId) // added by carlo de guzman 3.21.2016 SR-5384
                         || "GICLR204A2_LOSSES_PAID".equals(reportId) || "GICLR204A2_LOSS_RECO_CY".equals(reportId) || "GICLR204A2_LOSS_RECO_PY".equals(reportId)
                         || "GICLR204F2_PW_CY".equals(reportId) || "GICLR204F2_PW_PY".equals(reportId) || "GICLR204F2_OS_LOSS_CY".equals(reportId) || "GICLR204F2_OS_LOSS_PY".equals(reportId) // added by carlo de guzman 3.23.2016 for SR-5395
                         || "GICLR204F2_LOSSES_PAID".equals(reportId) || "GICLR204F2_LOSS_RECO_CY".equals(reportId) || "GICLR204F2_LOSS_RECO_PY".equals(reportId)// end
                         || "GICLR204E2_PW_CY".equals(reportId) || "GICLR204E2_PW_PY".equals(reportId) || "GICLR204E2_OS_CY".equals(reportId) //start: added by Mary Cris Invento 3/23/2016 SR 5392
                         || "GICLR204E2_OS_PY".equals(reportId) || "GICLR204E2_LP".equals(reportId) || "GICLR204E2_LR_CY".equals(reportId) || "GICLR204E2_LR_PY".equals(reportId) //end Mary Cris Invento 3/23/2016 SR-5392    
                         || "GICLR204B2_Loss_Recovery_CY_CSV".equals(reportId) || "GICLR204B2_Loss_Recovery_PY_CSV".equals(reportId) || "GICLR204B2_Losses_Paid_CSV".equals(reportId) || "GICLR204B2_Premiums_Written_PY_CSV".equals(reportId) // start Kevin SR-5387
                         || "GICLR204B2_Outstanding_Loss_CY_CSV".equals(reportId) || "GICLR204B2_Outstanding_Loss_PY_CSV".equals(reportId) || "GICLR204B2_Premiums_Written_CY_CSV".equals(reportId)  // end Kevin SR-5387
                         || "GICLR204B3_PREV_RECOVERY_CSV".equals(reportId) || "GICLR204B3_PREV_PREM_CSV".equals(reportId)//SR-5388
                         || "GICLR204B3_LOSSES_PAID_CSV".equals(reportId) || "GICLR204B3_CURR_RECOVERY_CSV".equals(reportId) || "GICLR204B3_CURR_LOSS_CSV".equals(reportId) || "GICLR204B3_CURR_PREM_CSV".equals(reportId)
                         || "GICLR204B3_PREV_LOSS_CSV".equals(reportId)){
                    params.put("P_CURR_PREM", request.getParameter("currPrem"));
                    params.put("P_PREV_PREM", request.getParameter("prevPrem"));
                    params.put("P_CURR_OS", request.getParameter("currOs"));
                    params.put("P_PREV_OS", request.getParameter("prevOs"));
                    params.put("P_LOSS_PAID", request.getParameter("lossPaid"));
                    params.put("P_CURR_REC", request.getParameter("currRec"));
                    params.put("P_PREV_REC", request.getParameter("prevRec"));
                    params.put("P_PREV_YEAR", request.getParameter("prevYear"));
                    params.put("P_CURR_YEAR", request.getParameter("currYear"));
                    params.put("P_CURR_START_DATE", request.getParameter("currStartDate"));
                    params.put("P_CURR_END_DATE", request.getParameter("currEndDate"));
                    params.put("P_PREV_END_DATE", request.getParameter("prevEndDate"));
                    params.put("P_PREV_END_DT", request.getParameter("prevEndDate"));
                    if("GICLR204A2_PREM_WRIT_CY".equals(reportId) || "GICLR204A2_PREM_WRIT_PY".equals(reportId)){
                        String pDate = request.getParameter("prntDate");
                        params.put("packageName", "CSV_LOSS_RATIO");
                        if(pDate.equals("2")){
                            params.put("functionName", "csv_"+reportId);
                            params.put("csvAction", "print"+reportId+"CSV");
                        }else{
                            params.put("functionName", "csv_"+reportId+pDate);
                            params.put("csvAction", "print"+reportId+pDate+"CSV");
                            
                        }
                    }else{
                        params.put("functionName", "csv_"+reportId);    // added by carlo de guzman 3.16.2016 SR-5384
                        params.put("csvAction", "print"+reportId+"CSV");  // added by carlo de guzman 3.16.2016 SR-5384
                    }
                    
                    params.put("packageName", "CSV_LOSS_RATIO"); // added by carlo de guzman 3.16.2016 sr 5395
                    //start: added by Mary Cris Invento 3/31/2016 SR-5392
                    if ("GICLR204E2_PW_CY".equals(reportId)) {
                        reportName = reportId.split("_")[0]+"_prem_written_cy";
                        params.put("packageName", "CSV_LOSS_RATIO");
                        if(request.getParameter("prntDate").equals("1"))  {
                            params.put("functionName", "CSV_"+reportId+"_ISSUE");
                            params.put("csvAction", "print"+reportId+"CSV_ISSUE");
                        } else if(request.getParameter("prntDate").equals("3"))  {
                            params.put("functionName", "CSV_"+reportId+"_ACCTG");
                            params.put("csvAction", "print"+reportId+"CSV_ACCTG");
                        } else if(request.getParameter("prntDate").equals("4"))  {
                            params.put("functionName", "CSV_"+reportId+"_BKING");
                            params.put("csvAction", "print"+reportId+"CSV_BKING");
                        }
                    } else if ("GICLR204E2_PW_PY".equals(reportId)) {
                        reportName = reportId.split("_")[0]+"_prem_written_py";
                        params.put("packageName", "CSV_LOSS_RATIO");
                        if(request.getParameter("prntDate").equals("1"))  {
                            params.put("functionName", "CSV_"+reportId+"_ISSUE");
                            params.put("csvAction", "print"+reportId+"CSV_ISSUE");
                        } else if(request.getParameter("prntDate").equals("3"))  {
                            params.put("functionName", "CSV_"+reportId+"_ACCTG");
                            params.put("csvAction", "print"+reportId+"CSV_ACCTG");
                        } else if(request.getParameter("prntDate").equals("4"))  {
                            params.put("functionName", "CSV_"+reportId+"_BKING");
                            params.put("csvAction", "print"+reportId+"CSV_BKING");
                        }
                    } else if ("GICLR204E2_OS_CY".equals(reportId)) {
                        reportName = reportId.split("_")[0]+"_os_loss_cy";
                        params.put("packageName", "CSV_LOSS_RATIO");
                        params.put("functionName", "CSV_"+reportId);
                        params.put("csvAction", "print"+reportId+"CSV");
                    } else if ("GICLR204E2_OS_PY".equals(reportId)) {
                        reportName = reportId.split("_")[0]+"_os_loss_py";
                        params.put("packageName", "CSV_LOSS_RATIO");
                        params.put("functionName", "CSV_"+reportId);
                        params.put("csvAction", "print"+reportId+"CSV");
                    } else if ("GICLR204E2_LP".equals(reportId)) {
                        reportName = reportId.split("_")[0]+"_losses_paid";
                        params.put("packageName", "CSV_LOSS_RATIO");
                        params.put("functionName", "CSV_"+reportId);
                        params.put("csvAction", "print"+reportId+"CSV");    
                    } else if ("GICLR204E2_LR_CY".equals(reportId)) {
                        reportName = reportId.split("_")[0]+"_loss_reco_cy";
                        params.put("packageName", "CSV_LOSS_RATIO");
                        params.put("functionName", "CSV_"+reportId);
                        params.put("csvAction", "print"+reportId+"CSV");
                    } else if ("GICLR204E2_LR_PY".equals(reportId)) {
                        reportName = reportId.split("_")[0]+"_loss_reco_py";
                        params.put("packageName", "CSV_LOSS_RATIO");
                        params.put("functionName", "CSV_"+reportId);
                        params.put("csvAction", "print"+reportId+"CSV");
                    }
                    //end Mary Cris Invento 3/31/2016 SR 5392

                    if("GICLR204B2".equals(reportId) || "GICLR204B2_Loss_Recovery_CY_CSV".equals(reportId) || "GICLR204B2_Loss_Recovery_PY_CSV".equals(reportId) || "GICLR204B2_Losses_Paid_CSV".equals(reportId) || "GICLR204B2_Premiums_Written_PY_CSV".equals(reportId)
                        || "GICLR204B2_Outstanding_Loss_CY_CSV".equals(reportId) || "GICLR204B2_Outstanding_Loss_PY_CSV".equals(reportId) || "GICLR204B2_Premiums_Written_CY_CSV".equals(reportId)){ // Kevin SR-5387
                        params.put("P_SESSION_ID", new BigDecimal(request.getParameter("sessionId")));
                        params.put("P_PRNT_DATE", request.getParameter("prntDate"));
                    }else if("GICLR204A2".equals(reportId)  || "GICLR204C3".equals(reportId)){
                        params.put("P_SESSION_ID", Integer.parseInt(request.getParameter("sessionId")));
                        params.put("P_PRINT_DATE", Integer.parseInt(request.getParameter("prntDate")));  // change P_PRNT_DATE to P_PRINT_DATE Kevin 4-11-2016 SR-5384
                    }else if("GICLR204C2".equals(reportId)){
                        params.put("P_SESSION_ID", new BigDecimal(request.getParameter("sessionId")));
                        params.put("P_PRNT_DATE", new BigDecimal(request.getParameter("prntDate")));
                    }else if("GICLR204E2".equals(reportId) || "GICLR204F2".equals(reportId) || "GICLR204F3".equals(reportId)
                             || "GICLR204F2_PW_CY".equals(reportId) || "GICLR204F2_PW_PY".equals(reportId) || "GICLR204F2_OS_LOSS_CY".equals(reportId) // added by carlo de guzman 3.23.2016 for SR5395
                             || "GICLR204F2_OS_LOSS_PY".equals(reportId) || "GICLR204F2_LOSSES_PAID".equals(reportId) 
                             || "GICLR204F2_LOSS_RECO_CY".equals(reportId) || "GICLR204F2_LOSS_RECO_PY".equals(reportId)){ // end
                        params.put("P_PRINT_DATE", request.getParameter("prntDate"));
                        params.put("P_SESSION_ID", new BigDecimal(request.getParameter("sessionId"))); //added by Mary Cris Invento 3/22/2016 SR 5392
                        if("GICLR204F2_PW_CY".equals(reportId)){ // added by carlo rubenecia 04.15.2016 SR 5395 --START
                            if(request.getParameter("prntDate").equals("1")){
                                params.put("functionName", "csv_giclr204F2_pw_cy1");    
                                params.put("csvAction", "printGICLR204F2_PREM_WRITTEN_CYCSV1");  
                            }else if(request.getParameter("prntDate").equals("3")){
                                params.put("functionName", "csv_giclr204F2_pw_cy2");   
                                params.put("csvAction", "printGICLR204F2_PREM_WRITTEN_CYCSV2");  
                            }else if(request.getParameter("prntDate").equals("4")){
                                params.put("functionName", "csv_giclr204F2_pw_cy3");    
                                params.put("csvAction", "printGICLR204F2_PREM_WRITTEN_CYCSV3");  
                            }
                        }else if("GICLR204F2_PW_PY".equals(reportId)){
                            if(request.getParameter("prntDate").equals("1")){
                                params.put("functionName", "csv_giclr204F2_pw_py1");    
                                params.put("csvAction", "printGICLR204F2_PREM_WRITTEN_PYCSV1"); 
                            }else if(request.getParameter("prntDate").equals("3")){
                                params.put("functionName", "csv_giclr204F2_pw_py2");    
                                params.put("csvAction", "printGICLR204F2_PREM_WRITTEN_PYCSV2");  
                            }else if(request.getParameter("prntDate").equals("4")){
                                params.put("functionName", "csv_giclr204F2_pw_py3");    
                                params.put("csvAction", "printGICLR204F2_PREM_WRITTEN_PYCSV3");   
                            }// added by carlo rubenecia 04.15.2016 SR 5395 --END
                        }else if("GICLR204F2_OS_LOSS_CY".equals(reportId) || "GICLR204F2_OS_LOSS_PY".equals(reportId)
                                 || "GICLR204F2_LOSSES_PAID".equals(reportId) || "GICLR204F2_LOSS_RECO_CY".equals(reportId) || "GICLR204F2_LOSS_RECO_PY".equals(reportId)){
                                params.put("functionName", "csv_"+reportId);    // added by carlo de guzman 3.16.2016
                                params.put("csvAction", "print"+reportId+"CSV");  // added by carlo de guzman 3.16.2016
                        }
                    }else if("GICLR204E3".equals(reportId)){
                        params.put("P_CURR_START_DT", request.getParameter("currStartDate"));
                        params.put("P_CURR_END_DT", request.getParameter("currEndDate"));
                        params.put("P_PREV_END_DT", request.getParameter("prevEndDate"));
                    }
                    if("GICLR204A3".equals(reportId) || "GICLR204B3".equals(reportId) || "GICLR204C3".equals(reportId)
                       || "GICLR204E3".equals(reportId) || "GICLR204F3".equals(reportId)
                       || "GICLR204B3_PREV_RECOVERY_CSV".equals(reportId) || "GICLR204B3_CURR_RECOVERY_CSV".equals(reportId)//SR-5388
                       || "GICLR204B3_LOSSES_PAID_CSV".equals(reportId) || "GICLR204B3_PREV_PREM_CSV".equals(reportId)
                       || "GICLR204B3_CURR_PREM_CSV".equals(reportId) || "GICLR204B3_PREV_LOSS_CSV".equals(reportId)
                       || "GICLR204B3_CURR_LOSS_CSV".equals(reportId)){
                        params.put("P_PRNT_DATE", request.getParameter("prntDate"));
                        params.put("P_CURR1_24", request.getParameter("curr124"));
                        params.put("P_CURR_24", request.getParameter("curr24"));
                        params.put("P_PREV1_24", request.getParameter("prev124"));
                        params.put("P_PREV_24", request.getParameter("prev24"));
                        if("GICLR204A3".equals(reportId) || "GICLR204C3".equals(reportId)) {
                            //params.put("P_SESSION_ID", Integer.parseInt(request.getParameter("sessionId")));
                            params.put("P_SESSION_ID", new BigDecimal(request.getParameter("sessionId").toString())); // apollo cruz 09.14.2015 to match datatype in the report
                        }
                    }
                }else if("GICLR204C2_Premiums_Written_CY".equals(reportId) || "GICLR204C2_Premiums_Written_PY".equals(reportId)|| "GICLR204C2_Outstanding_Loss_CY".equals(reportId)|| // added by elar 3/23/2016 for CSV GICLR204C2 SR-5389
                        "GICLR204C2_Outstanding_Loss_PY".equals(reportId) || "GICLR204C2_Losses_Paid".equals(reportId) || "GICLR204C2_Loss_Recovery_CY".equals(reportId)||
                        "GICLR204C2_Loss_Recovery_PY".equals(reportId)){
                    params.put("P_CURR_END_DATE", request.getParameter("currEndDate"));
                    params.put("P_CURR_OS", request.getParameter("currOs"));
                    params.put("P_CURR_PREM", request.getParameter("currPrem"));
                    params.put("P_CURR_REC", request.getParameter("currRec"));
                    params.put("P_CURR_START_DATE", request.getParameter("currStartDate"));
                    params.put("P_CURR_YEAR", request.getParameter("currYear"));
                    params.put("P_LOSS_PAID", request.getParameter("lossPaid"));
                    params.put("P_PREV_END_DATE", request.getParameter("prevEndDate"));
                    params.put("P_PREV_OS", request.getParameter("prevOs"));
                    params.put("P_PREV_PREM", request.getParameter("prevPrem"));
                    params.put("P_PREV_REC", request.getParameter("prevRec"));
                    params.put("P_PREV_YEAR", request.getParameter("prevYear"));
                    params.put("P_LINE_CD", request.getParameter("lineCd"));
                    params.put("packageName", "CSV_LOSS_RATIO");
                    if("GICLR204C2_Premiums_Written_CY".equals(reportId)){
                        String prntDate = request.getParameter("prntDate");
                        if(prntDate.equals("2")){
                            params.put("functionName", "csv_giclr204c2_records");
                            params.put("csvAction", "printGICLR204C2CSV_PWCY");
                        }else{
                            params.put("functionName", "csv_giclr204c2_records"+prntDate);
                            params.put("csvAction", "printGICLR204C2CSV_PWCY"+prntDate);
                        }
                    }else if("GICLR204C2_Premiums_Written_PY".equals(reportId)){
                        String prntDate = request.getParameter("prntDate");
                        if(prntDate.equals("2")){
                            params.put("csvAction", "printGICLR204C2CSV_PWPY"); 
                            params.put("functionName", "csv_giclr204c2g7_records");
                        }else{
                            params.put("csvAction", "printGICLR204C2CSV_PWPY"+prntDate); 
                            params.put("functionName", "csv_giclr204c2g7_records"+prntDate);
                        }
                    }else if("GICLR204C2_Outstanding_Loss_CY".equals(reportId)){
                        params.put("csvAction", "printGICLR204C2CSV_OSCY"); 
                        params.put("functionName", "csv_giclr204c2_claim");
                    }else if("GICLR204C2_Outstanding_Loss_PY".equals(reportId)){
                        params.put("csvAction", "printGICLR204C2CSV_OSPY");
                        params.put("functionName", "csv_giclr204c2_claimg5");
                    }else if("GICLR204C2_Losses_Paid".equals(reportId)){
                        params.put("csvAction", "printGICLR204C2CSV_LP");
                        params.put("functionName", "csv_giclr204c2_claimg9"); 
                    }else if("GICLR204C2_Loss_Recovery_CY".equals(reportId)){
                        params.put("csvAction", "printGICLR204C2CSV_LRCY");
                        params.put("functionName", "csv_giclr204c2_recoveryg11"); 
                    }else if("GICLR204C2_Loss_Recovery_PY".equals(reportId)){
                        params.put("csvAction", "printGICLR204C2CSV_LRPY");
                        params.put("functionName", "csv_giclr204c2_recoveryg13"); 
                    }  //end elar GICLR204C2 SR-5389
                }else if("GICLR204A3_PREM_WRITTEN_CY".equals(reportId) || "GICLR204A3_PREM_WRITTEN_PY".equals(reportId) || "GICLR204A3_LOSSES_PAID".equals(reportId) // added by carlo 3.18.2016 SR-5385
                         || "GICLR204A3_OS_LOSS_CY".equals(reportId) || "GICLR204A3_OS_LOSS_PY".equals(reportId) || "GICLR204A3_LOSS_RECO_CY".equals(reportId) 
                         || "GICLR204A3_LOSS_RECO_PY".equals(reportId)){
                    params.put("P_CURR_PREM", request.getParameter("currPrem"));
                    params.put("P_PREV_PREM", request.getParameter("prevPrem"));
                    params.put("P_CURR_OS", request.getParameter("currOs"));
                    params.put("P_PREV_OS", request.getParameter("prevOs"));
                    params.put("P_LOSS_PAID", request.getParameter("lossPaid"));
                    params.put("P_CURR_REC", request.getParameter("currRec"));
                    params.put("P_PREV_REC", request.getParameter("prevRec"));
                    params.put("P_PREV_YEAR", request.getParameter("prevYear"));
                    params.put("P_CURR_YEAR", request.getParameter("currYear"));
                    params.put("P_CURR_START_DATE", request.getParameter("currStartDate"));
                    params.put("P_CURR_END_DATE", request.getParameter("currEndDate"));
                    params.put("P_PREV_END_DATE", request.getParameter("prevEndDate"));
                    params.put("P_PREV_END_DT", request.getParameter("prevEndDate"));
                    params.put("packageName", "CSV_LOSS_RATIO"); 
                    params.put("functionName", "csv_"+reportId);    
                    params.put("csvAction", "print"+reportId+"CSV"); 
                    params.put("P_PRNT_DATE", request.getParameter("prntDate"));
                    params.put("P_CURR1_24", request.getParameter("curr124"));
                    params.put("P_CURR_24", request.getParameter("curr24"));
                    params.put("P_PREV1_24", request.getParameter("prev124"));
                    params.put("P_PREV_24", request.getParameter("prev24"));
                    params.put("P_SESSION_ID", new BigDecimal(request.getParameter("sessionId").toString())); // end SR-5385
                //start: John Daniel SR-5390 03/21/2016
                }else if("GICLR204D2_PW_CY".equals(reportId) || "GICLR204D2_PW_PY".equals(reportId)|| "GICLR204D2_OS_CY".equals(reportId)||
                        "GICLR204D2_OS_PY".equals(reportId) || "GICLR204D2_LP".equals(reportId) || "GICLR204D2_LR_CY".equals(reportId)||
                        "GICLR204D2_LR_PY".equals(reportId)){
                    params.put("P_CURR_PREM", request.getParameter("currPrem"));
                    params.put("P_PREV_PREM", request.getParameter("prevPrem"));
                    params.put("P_CURR_OS", request.getParameter("currOs"));
                    params.put("P_PREV_OS", request.getParameter("prevOs"));
                    params.put("P_LOSS_PAID", request.getParameter("lossPaid"));
                    params.put("P_CURR_REC", request.getParameter("currRec"));
                    params.put("P_PREV_REC", request.getParameter("prevRec"));
                    params.put("P_PREV_YEAR", request.getParameter("prevYear"));
                    params.put("P_CURR_YEAR", request.getParameter("currYear"));
                    params.put("P_CURR_START_DATE", request.getParameter("currStartDate"));
                    params.put("P_CURR_END_DATE", request.getParameter("currEndDate"));
                    params.put("P_PREV_END_DATE", request.getParameter("prevEndDate"));
                    params.put("P_PREV_END_DT", request.getParameter("prevEndDate"));
                    params.put("P_PRNT_DATE", request.getParameter("prntDate"));
                    if ("GICLR204D2_PW_CY".equals(reportId)) {
                        reportName = reportId.split("_")[0]+"_"+"prem_written_cy";
                        params.put("packageName", "CSV_LOSS_RATIO");
                        if (request.getParameter("prntDate").equals("1") ) {
                            params.put("functionName", "csv_giclr204D2_pwcy_a");
                            params.put("csvAction", "printGICLR204D2pwcy_a");
                        } else if (request.getParameter("prntDate").equals("3")) {
                            params.put("functionName", "csv_giclr204D2_pwcy_b");
                            params.put("csvAction", "printGICLR204D2pwcy_b");
                        } else if (request.getParameter("prntDate").equals("4")) {
                            params.put("functionName", "csv_giclr204D2_pwcy_c");
                            params.put("csvAction", "printGICLR204D2pwcy_c");
                        }   
                    } else if ("GICLR204D2_PW_PY".equals(reportId)) {
                        reportName = reportId.split("_")[0]+"_"+"prem_written_py";
                        params.put("packageName", "CSV_LOSS_RATIO");
                        if (request.getParameter("prntDate").equals("1") ) {
                            params.put("functionName", "csv_giclr204D2_pwpy_a");
                            params.put("csvAction", "printGICLR204D2pwpy_a");
                        } else if (request.getParameter("prntDate").equals("3")) {
                            params.put("functionName", "csv_giclr204D2_pwpy_b");
                            params.put("csvAction", "printGICLR204D2pwpy_b");
                        } else if (request.getParameter("prntDate").equals("4")) {
                            params.put("functionName", "csv_giclr204D2_pwpy_c");
                            params.put("csvAction", "printGICLR204D2pwpy_c");
                        }
                    } else if ("GICLR204D2_OS_CY".equals(reportId)) {
                        reportName = reportId.split("_")[0]+"_"+"os_loss_cy";
                        params.put("packageName", "CSV_LOSS_RATIO");
                        params.put("functionName", "csv_giclr204D2_olcy");
                        params.put("csvAction", "printGICLR204D2olcy");
                    } else if ("GICLR204D2_OS_PY".equals(reportId)) {
                        reportName = reportId.split("_")[0]+"_"+"os_loss_py";
                        params.put("packageName", "CSV_LOSS_RATIO");
                        params.put("functionName", "csv_giclr204D2_olpy");
                        params.put("csvAction", "printGICLR204D2olpy");
                    } else if ("GICLR204D2_LP".equals(reportId)) {
                        reportName = reportId.split("_")[0]+"_"+"losses_paid";
                        params.put("packageName", "CSV_LOSS_RATIO");
                        params.put("functionName", "csv_giclr204D2_lp");
                        params.put("csvAction", "printGICLR204D2lp");
                    } else if ("GICLR204D2_LR_CY".equals(reportId)) {
                        reportName = reportId.split("_")[0]+"_"+"loss_reco_cy";
                        params.put("packageName", "CSV_LOSS_RATIO");
                        params.put("functionName", "csv_giclr204D2_lrcy");
                        params.put("csvAction", "printGICLR204D2lrcy");
                    } else if ("GICLR204D2_LR_PY".equals(reportId)) {
                        reportName = reportId.split("_")[0]+"_"+"loss_reco_py";
                        params.put("packageName", "CSV_LOSS_RATIO");
                        params.put("functionName", "csv_giclr204D2_lrpy");
                        params.put("csvAction", "printGICLR204D2lrpy");
                    }
                    //end: John Daniel SR-5390 03/21/2016
                }else if("GICLR204C3_PW_CY".equals(reportId) || "GICLR204C3_PW_PY".equals(reportId)|| "GICLR204C3_OS_CY".equals(reportId)||
                        "GICLR204C3_OS_PY".equals(reportId) || "GICLR204C3_LP".equals(reportId) || "GICLR204C3_LR_CY".equals(reportId)||
                        "GICLR204C3_LR_PY".equals(reportId) ||
                        "GICLR204F3_PW_CY".equals(reportId) || "GICLR204F3_PW_PY".equals(reportId) || "GICLR204F3_OS_LOSS_CY".equals(reportId) || "GICLR204F3_OS_LOSS_PY".equals(reportId)||// added by carlo de guzman 3.28.2016 for SR5396 
						"GICLR204F3_LOSSES_PAID".equals(reportId) || "GICLR204F3_LOSS_RECO_CY".equals(reportId) || "GICLR204F3_LOSS_RECO_PY".equals(reportId)){ // end
                    params.put("P_SESSION_ID", Integer.parseInt(request.getParameter("sessionId")));                    
                    params.put("P_PRNT_DATE", request.getParameter("prntDate"));
                    params.put("P_CURR1_24", request.getParameter("curr124"));
                    params.put("P_CURR_24", request.getParameter("curr24"));
                    params.put("P_PREV1_24", request.getParameter("prev124"));
                    params.put("P_PREV_24", request.getParameter("prev24"));
                    params.put("P_CURR_PREM", request.getParameter("currPrem"));
                    params.put("P_PREV_PREM", request.getParameter("prevPrem"));
                    params.put("P_CURR_OS", request.getParameter("currOs"));
                    params.put("P_PREV_OS", request.getParameter("prevOs"));
                    params.put("P_LOSS_PAID", request.getParameter("lossPaid"));
                    params.put("P_CURR_REC", request.getParameter("currRec"));
                    params.put("P_PREV_REC", request.getParameter("prevRec"));
                    params.put("P_PREV_YEAR", request.getParameter("prevYear"));
                    params.put("P_CURR_YEAR", request.getParameter("currYear"));
                    params.put("P_CURR_START_DATE", request.getParameter("currStartDate"));
                    params.put("P_CURR_END_DATE", request.getParameter("currEndDate"));
                    params.put("P_PREV_END_DATE", request.getParameter("prevEndDate"));
                    params.put("P_PREV_END_DT", request.getParameter("prevEndDate"));
                    params.put("packageName", "CSV_LOSS_RATIO"); //added by carlo de guzman SR 5396 3.28.2016
                    if("GICLR204C3_PW_CY".equals(reportId)){
                        params.put("P_DATE", "CURR");
                        params.put("csvAction", "printGICLR204C3pw");
                        params.put("packageName", "CSV_LOSS_RATIO");
                        params.put("functionName", "GICLR204C3_PW");
                    }else if("GICLR204C3_PW_PY".equals(reportId)){
                        params.put("P_DATE", "PREV");
                        params.put("csvAction", "printGICLR204C3pw");
                        params.put("packageName", "CSV_LOSS_RATIO");
                        params.put("functionName", "GICLR204C3_PW");
                    }else if("GICLR204C3_OS_CY".equals(reportId)){
                        params.put("P_DATE", "CURR");
                        params.put("csvAction", "printGICLR204C3os");
                        params.put("packageName", "CSV_LOSS_RATIO");
                        params.put("functionName", "GICLR204C3_OS");
                    }else if("GICLR204C3_OS_PY".equals(reportId)){
                        params.put("P_DATE", "PREV");
                        params.put("csvAction", "printGICLR204C3os");
                        params.put("packageName", "CSV_LOSS_RATIO");
                        params.put("functionName", "GICLR204C3_OS");
                    }else if("GICLR204C3_LP".equals(reportId)){
                        params.put("csvAction", "printGICLR204C3lp");
                        params.put("packageName", "CSV_LOSS_RATIO");
                        params.put("functionName", "GICLR204C3_LP");
                    }else if("GICLR204C3_LR_CY".equals(reportId)){
                        params.put("P_DATE", "CURR");
                        params.put("csvAction", "printGICLR204C3lr");
                        params.put("packageName", "CSV_LOSS_RATIO");
                        params.put("functionName", "GICLR204C3_LR");
                    }else if("GICLR204C3_LR_PY".equals(reportId)){
                        params.put("P_DATE", "PREV");
                        params.put("csvAction", "printGICLR204C3lr");
                        params.put("packageName", "CSV_LOSS_RATIO");
                        params.put("functionName", "GICLR204C3_LR");
                    }else if("GICLR204F3_PW_CY".equals(reportId)){ //added by carlo rubenecia 04.18.2016 for SR5396 --start
						if(request.getParameter("prntDate").equals("1")){
							params.put("functionName", "csv_giclr204F3_pw_cy1");    
						    params.put("csvAction", "printGICLR204F3_PW_CYCSV1");
						}else if(request.getParameter("prntDate").equals("3")){
							params.put("functionName", "csv_giclr204F3_pw_cy2");    
						    params.put("csvAction", "printGICLR204F3_PW_CYCSV2"); 
						}else{
							params.put("functionName", "csv_giclr204F3_pw_cy3");    
						    params.put("csvAction", "printGICLR204F3_PW_CYCSV3"); 
						}
					}else if("GICLR204F3_PW_PY".equals(reportId)){
						if(request.getParameter("prntDate").equals("1")){
							params.put("functionName", "csv_giclr204F3_pw_py1");    
						    params.put("csvAction", "printGICLR204F3_PW_PYCSV1"); 
						}else if(request.getParameter("prntDate").equals("3")){
							params.put("functionName", "csv_giclr204F3_pw_py2");    
						    params.put("csvAction", "printGICLR204F3_PW_PYCSV2"); 
						}else{
							params.put("functionName", "csv_giclr204F3_pw_py3");    
						    params.put("csvAction", "printGICLR204F3_PW_PYCSV3"); 
						}
					}else if("GICLR204F3_OS_LOSS_CY".equals(reportId) || "GICLR204F3_OS_LOSS_PY".equals(reportId)
							 ||"GICLR204F3_LOSSES_PAID".equals(reportId) || "GICLR204F3_LOSS_RECO_CY".equals(reportId) 
							 || "GICLR204F3_LOSS_RECO_PY".equals(reportId)){
							params.put("functionName", "csv_"+reportId);    
						    params.put("csvAction", "print"+reportId+"CSV"); 
					}//added by carlo rubenecia 04.18.2016 for SR5396 --end
                }else if("GICLR204D3_PW_CY".equals(reportId) || "GICLR204D3_PW_PY".equals(reportId)|| "GICLR204D3_OS_CY".equals(reportId)||
                        "GICLR204D3_OS_PY".equals(reportId) || "GICLR204D3_LP".equals(reportId) || "GICLR204D3_LR_CY".equals(reportId)||
                        "GICLR204D3_LR_PY".equals(reportId)){
                    params.put("P_SESSION_ID", Integer.parseInt(request.getParameter("sessionId")));                    
                    params.put("P_PRNT_DATE", request.getParameter("prntDate"));
                    params.put("P_CURR1_24", request.getParameter("curr124"));
                    params.put("P_CURR_24", request.getParameter("curr24"));
                    params.put("P_PREV1_24", request.getParameter("prev124"));
                    params.put("P_PREV_24", request.getParameter("prev24"));
                    params.put("P_CURR_PREM", request.getParameter("currPrem"));
                    params.put("P_PREV_PREM", request.getParameter("prevPrem"));
                    params.put("P_CURR_OS", request.getParameter("currOs"));
                    params.put("P_PREV_OS", request.getParameter("prevOs"));
                    params.put("P_LOSS_PAID", request.getParameter("lossPaid"));
                    params.put("P_CURR_REC", request.getParameter("currRec"));
                    params.put("P_PREV_REC", request.getParameter("prevRec"));
                    params.put("P_PREV_YEAR", request.getParameter("prevYear"));
                    params.put("P_CURR_YEAR", request.getParameter("currYear"));
                    params.put("P_CURR_START_DATE", request.getParameter("currStartDate"));
                    params.put("P_CURR_END_DATE", request.getParameter("currEndDate"));
                    params.put("P_PREV_END_DATE", request.getParameter("prevEndDate"));
                    params.put("P_PREV_END_DT", request.getParameter("prevEndDate"));
                    if("GICLR204D3_PW_CY".equals(reportId)){
                        params.put("P_DATE", "CURR");
                        params.put("csvAction", "printGICLR204D3pw");
                        params.put("packageName", "CSV_LOSS_RATIO");
                        params.put("functionName", "GICLR204D3_PW");
                    }else if("GICLR204D3_PW_PY".equals(reportId)){
                        params.put("P_DATE", "PREV");
                        params.put("csvAction", "printGICLR204D3pw");
                        params.put("packageName", "CSV_LOSS_RATIO");
                        params.put("functionName", "GICLR204D3_PW");
                    }else if("GICLR204D3_OS_CY".equals(reportId)){
                        params.put("P_DATE", "CURR");
                        params.put("csvAction", "printGICLR204D3os");
                        params.put("packageName", "CSV_LOSS_RATIO");
                        params.put("functionName", "GICLR204D3_OS");
                    }else if("GICLR204D3_OS_PY".equals(reportId)){
                        params.put("P_DATE", "PREV");
                        params.put("csvAction", "printGICLR204D3os");
                        params.put("packageName", "CSV_LOSS_RATIO");
                        params.put("functionName", "GICLR204D3_OS");
                    }else if("GICLR204D3_LP".equals(reportId)){
                        params.put("csvAction", "printGICLR204D3lp");
                        params.put("packageName", "CSV_LOSS_RATIO");
                        params.put("functionName", "GICLR204D3_LP");
                    }else if("GICLR204D3_LR_CY".equals(reportId)){
                        params.put("P_DATE", "CURR");
                        params.put("csvAction", "printGICLR204D3lr");
                        params.put("packageName", "CSV_LOSS_RATIO");
                        params.put("functionName", "GICLR204D3_LR");
                    }else if("GICLR204D3_LR_PY".equals(reportId)){
                        params.put("P_DATE", "PREV");
                        params.put("csvAction", "printGICLR204D3lr");
                        params.put("packageName", "CSV_LOSS_RATIO");
                        params.put("functionName", "GICLR204D3_LR");
                    }
                }else if("GICLR204E3_LP".equals(reportId)|| "GICLR204E3_PW_CY".equals(reportId)|| "GICLR204E3_PW_PY".equals(reportId) //Added by Carlo Rubenecia 5393 05.31.2016 Start
                  		 || "GICLR204E3_OS_CY".equals(reportId) || "GICLR204E3_OS_PY".equals(reportId) || "GICLR204E3_LR_CY".equals(reportId)
                   		 || "GICLR204E3_LR_PY".equals(reportId)){
                	params.put("P_CURR_PREM", request.getParameter("currPrem"));
                    params.put("P_PREV_PREM", request.getParameter("prevPrem"));
                    params.put("P_CURR_OS", request.getParameter("currOs"));
                    params.put("P_PREV_OS", request.getParameter("prevOs"));
                    params.put("P_LOSS_PAID", request.getParameter("lossPaid"));
                    params.put("P_CURR_REC", request.getParameter("currRec"));
                    params.put("P_PREV_REC", request.getParameter("prevRec"));
                    params.put("P_PREV_YEAR", request.getParameter("prevYear"));
                    params.put("P_CURR_YEAR", request.getParameter("currYear"));
                    params.put("P_CURR_START_DATE", request.getParameter("currStartDate"));
                    params.put("P_CURR_END_DATE", request.getParameter("currEndDate"));
                    params.put("P_PREV_END_DATE", request.getParameter("prevEndDate"));
                    params.put("P_PREV_END_DT", request.getParameter("prevEndDate"));
                    params.put("P_SESSION_ID", Integer.parseInt(request.getParameter("sessionId")));                    
                    params.put("P_PRNT_DATE", request.getParameter("prntDate"));
                    params.put("packageName", "CSV_LOSS_RATIO");
                    if("GICLR204E3_PW_CY".equals(reportId)){
                       if (request.getParameter("prntDate").equals("1")){
                    	   params.put("csvAction", "printGICLR204E3_PW_CY_CSV1");
                    	   params.put("functionName", "populate_prem_writn_priod1");  
                       }else if(request.getParameter("prntDate").equals("3")){
                    	   params.put("csvAction", "printGICLR204E3_PW_CY_CSV2");
                    	   params.put("functionName", "populate_prem_writn_priod2");
                       }else if(request.getParameter("prntDate").equals("4")){
                    	   params.put("csvAction", "printGICLR204E3_PW_CY_CSV3");
                    	   params.put("functionName", "populate_prem_writn_priod3");
                       }
                    }else if("GICLR204E3_PW_PY".equals(reportId)){
                       if (request.getParameter("prntDate").equals("1")){
                       	   params.put("csvAction", "printGICLR204E3_PW_PY_CSV1");
                       	   params.put("functionName", "populate_prem_writn_year1");  
                       }else if(request.getParameter("prntDate").equals("3")){
                       	   params.put("csvAction", "printGICLR204E3_PW_PY_CSV2");
                       	   params.put("functionName", "populate_prem_writn_year2");
                       }else if(request.getParameter("prntDate").equals("4")){
                       	   params.put("csvAction", "printGICLR204E3_PW_PY_CSV3");
                       	   params.put("functionName", "populate_prem_writn_year3");
                          }
                    }else if("GICLR204E3_OS_CY".equals(reportId)){
                            params.put("csvAction", "printGICLR204E3_OS_CY_CSV");
                            params.put("functionName", "populate_outstndng_loss_as_of");
                    }else if("GICLR204E3_OS_PY".equals(reportId)){
                            params.put("csvAction", "printGICLR204E3_OS_PY_CSV");
                            params.put("functionName", "populate_outstndng_loss_prev");
                    }else if("GICLR204E3_LP".equals(reportId)){
                            params.put("csvAction", "printGICLR204E3_LP_CSV");
                            params.put("functionName", "populate_losses_pd_curr_year");
                    }else if("GICLR204E3_LR_CY".equals(reportId)){
                            params.put("csvAction", "printGICLR204E3_LR_CY_CSV");
                            params.put("functionName", "populate_loss_recovery_period");
                    }else if("GICLR204E3_LR_PY".equals(reportId)){
                            params.put("csvAction", "printGICLR204E3_LR_PY_CSV");
                            params.put("functionName", "populate_loss_recovery_year");   	
                    }
                }//Added by Carlo Rubenecia 5393 05.31.2016 End
                System.out.println(reportId + " params: " + params);
                params.put("P_USER_ID", USER.getUserId());
                params.put("MAIN_REPORT", reportName+".jasper");
                params.put("OUTPUT_REPORT_FILENAME", reportName);
                params.put("reportTitle", request.getParameter("reportTitle"));
                params.put("reportName", reportName);
                
                this.doPrintReport(request, response, params, reportDir);
            }
        } /*catch (SQLException e) {
            this.setPrintErrorMessage(request, USER, e);
            this.doDispatch(request, response, PAGE);
        }*/ catch (Exception e) {
            this.setPrintErrorMessage(request, USER, e);
            this.doDispatch(request, response, PAGE);
        } finally {
            ConnectionUtil.releaseConnection(client);
        }
    }
}
