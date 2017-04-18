<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="contentsDiv" >
	<div class="sectionDiv" align="center" style="width: 100%; margin-top: 1px;">
		<table align="center" style="padding: 5px 0 15px 0;">
			<tr>
				<td class="rightAligned">Location</td>
				<td class="leftAligned" style="padding: 0 0 0 5px;" colspan="4">
					<input type="text" id="txtLocationCd" readonly="readonly" style="width: 100px;"/>
					<input type="text" id="txtLocationName" readonly="readonly" style="width: 582px;"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">From</td>
				<td class="leftAligned" style="padding: 0 0 0 5px;" colspan="2"><input type="text" id="txtFromDate" readonly="readonly" style="width: 220px;"/></td>
				<td class="rightAligned" style="padding-left: 150px;">Retention Limit</td>
				<td class="leftAligned" style="padding: 0 0 0 5px;"><input type="text" id="txtRetLimit" readonly="readonly" style="width: 220px; text-align: right;"/></td>
			</tr>
			<tr>
				<td class="rightAligned">To</td>
				<td class="leftAligned" style="padding: 0 0 0 5px;" colspan="2"><input type="text" id="txtToDate" readonly="readonly" style="width: 220px;"/></td>
				<td class="rightAligned">Treaty Limit</td>
				<td class="leftAligned" style="padding: 0 0 0 5px;"><input type="text" id="txtTreatyLimit" readonly="readonly" style="width: 220px; text-align: right;"/></td>
			</tr>
		</table>
	</div>
	<div id="casualtyAccumulationDtlDiv">
		<div class="sectionDiv" style="width: 100%;">
			<div id="exposuresTableDiv" style="padding: 10px 0 0 5px;">
				<div id="exposuresLeftDiv" style="width:18.6%; float: left;">
					<table align="right" style="margin:25px 0 0 0; border-collapse:collapse;">
						<tr>
							<td><input type="button" id="btnNetRetention" class="button2" value="Net Retention" style="width: 150px;"/></td>
						</tr>
						<tr>
							<td><input type="button" id="btnTreaty" class="button2" value="Treaty" style="width: 150px;"/></td>
						</tr>
						<tr>
							<td><input type="button" id="btnFacultative" class="button2" value="Facultative" style="width: 150px;"/></td>
						</tr>
						<tr align="right">
							<td height="22px" align="right">Totals</td>
						</tr>
					</table>
				</div>
				<div id="exposuresRightDiv" style="height: 180px; width:70%; float: left;">
					<div id="exposuresTable" style="height: 102px;"></div>
					<div id="exposuresInnerRightDiv">
						<table align="left" style="border-collapse:collapse;">
							<tr>
								<td><input type="text" id="txtManualSum" style="width: 163.5px; text-align: right;" readonly="readonly"/></td>
								<td><input type="text" id="txtActualSum" style="width: 163.5px; text-align: right;" readonly="readonly"/></td>
								<td><input type="text" id="txtTempSum" style="width: 163.5px; text-align: right;" readonly="readonly"/></td>
								<td><input type="text" id="txtSumTotal" style="width: 163.5px; text-align: right;" readonly="readonly"/></td>
							</tr>
							<tr>
								<td colspan="2" align="right"><input type="button" id="btnActualList" class="button2" value="List" style="width: 171px;"/></td>
								<td><input type="button" id="btnTempList" class="button2" value="List" style="width: 171px;"/></td>
							</tr>
						</table>
					</div>
				</div>
			</div>
		</div>
		<div class="buttonDiv"align="center" style="padding: 330px 0 10px 0;">
			<input type="button" id="btnPrint" class="button" value="Print" style="width: 100px;"/>
			<input type="button" id="btnReturn" class="button" value="Return" style="width: 100px;"/>
		</div>
	</div>
</div>
<script>
	initializeAll();
 	try {
		var jsonExposures = JSON.parse('${jsonExposures}');
		var reports = [];
		exposuresTableModel = {
			url : contextPath+ "/GIPIPolbasicController?action=showCasualtyAccumulationDtl&refresh=1",
	  		id : "GIPIS111Exposures",																							  
			options : {
				width : '694px',
				height : '106px',
				columnResizable : false,
				onCellFocus : function(element, value, x, y, id) {
					tbgExposures.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					tbgExposures.keys.releaseKeys();
				}
			},
			columnModel : [ 
				{
				    id: 'recordStatus',
				    title: '',
				    width: '0',
				    visible: false
				},
				{
					id: 'divCtrId',
					width: '0',
					visible: false 
				},  
				{
			    	id:'dspBegBal',
			    	title: 'Manual Beginning',
			    	width: '170px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	sortable: false,	
			    	geniisysClass: 'money'
			    },
			    {
			    	id:'dspActual',
			    	title: 'Actual Exposure',
			    	width: '170px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	sortable: false,	
			    	geniisysClass: 'money'
			    },
			    {
			    	id:'dspTemp',
			    	title: 'Temporary Exposure',
			    	width: '170px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	sortable: false,	
			    	geniisysClass: 'money'
			    },
			    {
			    	id:'dspSum',
			    	title: 'Total Exposure',
			    	width: '170px',
			    	align: 'right',
			    	titleAlign: 'right',
			    	sortable: false,	
			    	geniisysClass: 'money'
			    }
			],
			rows : jsonExposures.rows
		};
		tbgExposures = new MyTableGrid(exposuresTableModel);
		tbgExposures.pager = false;
		tbgExposures.render('exposuresTable');
		tbgExposures.afterRender = function(){
					populateExposuresTotal();
				};
	} catch (e) {
		showErrorMessage("exposuresTableModel", e);
	} 
	
	function populateExposuresTotal() {
		var manualTotal = 0;
		var actualTotal = 0;
		var tempTotal = 0;
		var sumTotal = 0;
		var msgFlag1 = 'YY';
		var msgFlag2 = 'YY';
		disableButton2("btnNetRetention");
		disableButton2("btnTreaty");
		disableButton2("btnFacultative");
		for ( var i = 0; i < tbgExposures.geniisysRows.length; i++) {
			manualTotal = manualTotal + parseFloat(nvl(tbgExposures.geniisysRows[i].dspBegBal,0));
			actualTotal = actualTotal + parseFloat(nvl(tbgExposures.geniisysRows[i].dspActual,0));
			tempTotal = tempTotal + parseFloat(nvl(tbgExposures.geniisysRows[i].dspTemp,0));
			sumTotal = sumTotal + parseFloat(nvl(tbgExposures.geniisysRows[i].dspSum,0));
			if(tbgExposures.geniisysRows[i].dspSum > 0){
				if (i == 0) {
					enableButton2("btnNetRetention");
				     if (parseFloat(nvl(tbgExposures.geniisysRows[i].dspSum, 0)) > parseFloat(nvl(objUWGlobal.hidGIPIS111Obj.selectedObj.retLimit, 0))) {
						$("mtgICGIPIS111Exposures_5,0").style.color = 'red';
						msgFlag1 = 'OO';
					} else {
						msgFlag1 = 'YY';
					}
				} else if(i == 1) {
					enableButton2("btnTreaty");
					 if (parseFloat(nvl(tbgExposures.geniisysRows[i].dspSum, 0)) > parseFloat(nvl(objUWGlobal.hidGIPIS111Obj.selectedObj.treatyLimit, 0))) {
						$("mtgICGIPIS111Exposures_5,1").style.color = 'red';
						msgFlag2 = 'OO';
					} else {
						msgFlag2 = 'YY';
					}
				}else if (i ==2){
					enableButton2("btnFacultative");
				}
			}
		}
		$("txtManualSum").value = formatCurrency(manualTotal);
		$("txtActualSum").value = formatCurrency(actualTotal);
		$("txtTempSum").value = formatCurrency(tempTotal);
		$("txtSumTotal").value = formatCurrency(sumTotal);
		
		$("txtLocationCd").value = unescapeHTML2(nvl(objUWGlobal.hidGIPIS111Obj.selectedObj.locationCd,""));
		$("txtLocationName").value = unescapeHTML2(nvl(objUWGlobal.hidGIPIS111Obj.selectedObj.locationDesc,""));
		$("txtFromDate").value = objUWGlobal.hidGIPIS111Obj.selectedObj.dspFromDate2;
		$("txtToDate").value = objUWGlobal.hidGIPIS111Obj.selectedObj.dspToDate2;
		$("txtRetLimit").value = formatCurrency(nvl(objUWGlobal.hidGIPIS111Obj.selectedObj.retLimit,"0"));
		$("txtTreatyLimit").value = formatCurrency(nvl(objUWGlobal.hidGIPIS111Obj.selectedObj.treatyLimit,"0"));
	    
	    if (nvl(objUWGlobal.hidGIPIS111Obj.selectedObj.retLimit,"") == "" && nvl(objUWGlobal.hidGIPIS111Obj.selectedObj.treatyLimit,"") == "") {
	    	showMessageBox("Retention limit and Treaty limit not specified for this location.","I");
	    	return;
		} else if(nvl(objUWGlobal.hidGIPIS111Obj.selectedObj.treatyLimit,"") == "") {
			showMessageBox("Treaty limit not specified for this location.","I");
			return;
		}else if (nvl(objUWGlobal.hidGIPIS111Obj.selectedObj.retLimit,"") == "" ){
			showMessageBox("Retention limit not specified for this location.","I");
			return;
		}
	    
		if (msgFlag1 == "OO" && msgFlag2 == "OO") {
			showMessageBox("Retention Limit and Treaty limit have been exceeded for this location.","I");
		} else if(msgFlag1 == "OO" && msgFlag2 == "YY") {
			showMessageBox("Retention Limit has been exceeded for this location.","I");
		} else if(msgFlag1 == "YY" && msgFlag2 == "OO") {
			showMessageBox("Treaty Limit has been exceeded for this location.","I");
		}
	}
	
	function showGipis111ActualExposures() {
 		try{
 			new Ajax.Request(contextPath+"/GIPIPolbasicController",{
 				method: "POST",
 				parameters : { action : "showGipis111ActualExposures",
			 				   excludeExpired : objUWGlobal.hidGIPIS111Obj.excludeExpired,
			                   excludeNotEff : objUWGlobal.hidGIPIS111Obj.excludeNotEff,
			                   locationCd : objUWGlobal.hidGIPIS111Obj.selectedObj.locationCd,
			                   mode : "ITEM"
			                  },
 				asynchronous: false,
 				evalScripts: true,
 				onCreate: function (){
 					showNotice("Loading, please wait...");
 				},
 				onComplete: function(response){
 					hideNotice();
 					if (checkErrorOnResponse(response)){
 						$("casualtyAccumulationBodyDiv").hide();
 						$("casualtyAccumulationBodyDiv2").hide();
 						$("casualtyAccumulationBodyDiv4").hide();
 						$("casualtyAccumulationBodyDiv3").update(response.responseText);
 						$("casualtyAccumulationBodyDiv3").show();
 						
 					}
 				}
 			});
 		} catch(e){
 			showErrorMessage("showGipis111ActualExposures", e);
 		}
 	}
	
	function showGipis111TemporaryExposures() {
 		try{
 			new Ajax.Request(contextPath+"/GIPIPolbasicController",{
 				method: "POST",
 				parameters : { action : "showGipis111TemporaryExposures",
 					 		   excludeExpired : objUWGlobal.hidGIPIS111Obj.excludeExpired,
	                    	   excludeNotEff : objUWGlobal.hidGIPIS111Obj.excludeNotEff,
	                    	   locationCd : objUWGlobal.hidGIPIS111Obj.selectedObj.locationCd,
	                    	   mode : "ITEM"
	                    },
 				asynchronous: false,
 				evalScripts: true,
 				onCreate: function (){
 					showNotice("Loading, please wait...");
 				},
 				onComplete: function(response){
 					hideNotice();
 					if (checkErrorOnResponse(response)){
 						$("casualtyAccumulationBodyDiv").hide();
 						$("casualtyAccumulationBodyDiv2").hide();
 						$("casualtyAccumulationBodyDiv3").hide();
 						$("casualtyAccumulationBodyDiv4").update(response.responseText);
 						$("casualtyAccumulationBodyDiv4").show();
 						
 					}
 				}
 			});
 		} catch(e){
 			showErrorMessage("showGipis111TemporaryExposures", e);
 		}
 	}
	
	function addCheckbox(){
		var htmlCode = "<table cellspacing='10px' style='margin: 10px;'><tr><td><input type='checkbox' id='chkCaAccumRep' class='required' /></td><td><label for='chkCaAccumRep'>Casualty Accumulation Report</label></td></tr><tr><td><input type='checkbox' id='chkCaAccumRepClaim' /></td><td><label for='chkCaAccumRepClaim'>Casualty Accumulation Report (w/ Claims)</label></td></tr></table>"; 
		
		$("printDialogFormDiv2").update(htmlCode); 
		$("printDialogFormDiv2").show();
		$("printDialogMainDiv").up("div",1).style.height = "248px";
		$($("printDialogMainDiv").up("div",1).id).up("div",0).style.height = "280px";
	}
	
	function printGIPIR111() {
		try {
			if(!$("chkCaAccumRep").checked  && !$("chkCaAccumRepClaim").checked){
				showMessageBox("Please select a report type first.","I");
				return;
			}
			
			var reportArray = [];

			if($("chkCaAccumRep").checked  && $("chkCaAccumRepClaim").checked ){
				reportArray = ["GIPIR111A","GIPIR111B"];
				for ( var i = 0; i < reportArray.length; i++) {
					setPrintReportArray(reportArray[i]);
				}
			}else if ($("chkCaAccumRep").checked || $("chkCaAccumRepClaim").checked ) {
				var reportId = $("chkCaAccumRep").checked ? "GIPIR111A" : "GIPIR111B";
				reportArray = [reportId];
				for ( var i = 0; i < reportArray.length; i++) {
					setPrintReportArray(reportArray[i]);
				}
			} 
			if("screen" == $F("selDestination")){
				showMultiPdfReport(reports);
				reports = [];
			}

			overlayGenericPrintDialog.close();
		} catch (e) {
			showErrorMessage("printGIPIR111",e);
		}
	}
	
	function setPrintReportArray(reportId) {
		try {
			var fileType = $("rdoPdf").checked ? "PDF" : "XLS";
			var content = contextPath+"/PolicyInquiryPrintController?action=printGIPIR111"
			+"&noOfCopies="+$F("txtNoOfCopies")
			+"&printerName="+$F("selPrinter")
			+"&destination="+$F("selDestination")
			+"&reportId="+reportId
			+"&excludeExpired="+objUWGlobal.hidGIPIS111Obj.excludeExpired	
			+"&excludeNotEff="+objUWGlobal.hidGIPIS111Obj.excludeNotEff	
			+"&locationCd="+objUWGlobal.hidGIPIS111Obj.selectedObj.locationCd	
			+"&fileType="+fileType;	
			printReport(content, "CASUALTY ACCUMULATION REPORT");			
		} catch (e) {
			showErrorMessage("printReport",e);
		}
	}
	
	function printReport(content, reportTitle){
		try{
			if("screen" == $F("selDestination")){
				reports.push({reportUrl : content, reportTitle : reportTitle});		
			}else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					parameters : {printerName : $F("selPrinter"),
								  noOfCopies : $F("txtNoOfCopies")},
					onCreate : showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if(checkErrorOnResponse(response)){
							showMessageBox("Printing complete.", "S");
						}
					}
				});
			}else if("file" == $F("selDestination")){
				new Ajax.Request(content, {
					parameters : {destination : "FILE"},
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							if($("geniisysAppletUtil") == null || $("geniisysAppletUtil").copyFileToLocal == undefined){
								showMessageBox("Local printer applet is not configured properly. Please verify if you have accepted to run the Geniisys Utility Applet and if the java plugin in your browser is enabled.", imgMessage.ERROR);
							} else {
								var message = $("geniisysAppletUtil").copyFileToLocal(response.responseText, "reports");
								if(message.include("SUCCESS")){
									showMessageBox("Report file generated to " + message.substring(9), "I");	
								} else {
									showMessageBox(message, "E");
								}
							}
						}
					}
				});
			}else if("local" == $F("selDestination")){
				new Ajax.Request(content, {
					parameters : {destination : "LOCAL"},
					onCreate : showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							var message = printToLocalPrinter(response.responseText);
							if(message != "SUCCESS"){
								showMessageBox(message, imgMessage.ERROR);
							}
						}
					}
				});
			}
		}catch(e){
			showErrorMessage("printGenericReport", e);
		}	
	}
	
	$("btnReturn").observe("click",function(){
		$("casualtyAccumulationBodyDiv").show();
		$("casualtyAccumulationBodyDiv2").hide();
		$("casualtyAccumulationBodyDiv3").hide();
		$("casualtyAccumulationBodyDiv4").hide();
	});
	
	$("btnPrint").observe("click", function(){
		objUWGlobal.callingForm = "GIPIS111";
		showGenericPrintDialog("Print Casualty Accumulation", printGIPIR111, addCheckbox, true);
	});
	
	//for breakdown...
	$("btnActualList").observe("click",function(){
		showGipis111ActualExposures();
	});
	$("btnTempList").observe("click",function(){
		showGipis111TemporaryExposures();
	});
	
</script>