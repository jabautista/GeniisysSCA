<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="batchOSPrintingMainDiv" name="batchOSPrintingMainDiv"
	style="float: left; margin-bottom: 50px; width: 100%">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Batch OS Printing</label>
		</div>
	</div>
	<div class="sectionDiv">
		<div id="batchOSTableDiv" style="padding: 10px 0 0 10px;">
			<div id="batchOSTable" style="height: 340px; padding: 10px 0 0 110px;"></div>
		</div>
		<div class="buttonDiv" id="buttonDiv" align="center" style="float: left; width: 100%; margin-top: 10px; margin-bottom: 10px;">
			<table style=" margin-bottom: 10px;">
				<tr>
					<td>Check / Uncheck ALL</td>
					<td style="padding-left: 20px"><input type="checkbox" name="sortBy" id="chkOS" title="OS" style="float: left; margin-right: 7px; margin-top: 3px;"/><label for="chkOS" style="float: left; height: 20px; padding-top: 3px;">OS</label></td>
					<td style="padding-left: 20px"><input type="checkbox" name="sortBy" id="chkLoss" title="Loss" style="float: left; margin-right: 7px; margin-top: 3px;"/><label for="chkLoss" style="float: left; height: 20px; padding-top: 3px;">Loss</label></td>
					<td style="padding-left: 20px"><input type="checkbox" name="sortBy" id="chkExp" title="Expense" style="float: left; margin-right: 7px; margin-top: 3px;"/><label for="chkExp" style="float: left; height: 20px; padding-top: 3px;">Expense</label></td>
				</tr>
			</table>
			<input type="button" class="button" id="btnPrint" name="btnPrint" value="Print" style="width: 90px;"/>
		</div>
	</div>
</div>

<script>
	initializeAll();
	$("btnToolbarEnterQuery").hide();
	$("btnToolbarExecuteQuery").hide();
	//$("btnToolbarEnterSep").hide(); //napalitan ung ID sa toolbar.jsp 
	$("btnToolbarEnterQuerySep").hide(); //change by steven 08.04.2014
	$("btnToolbarPrint").hide();
	$("btnToolbarPrintSep").hide();
	setModuleId("GICLS207");
	setDocumentTitle("Batch OS Printing");
	try {
		var jsonBatchOS = JSON.parse('${jsonBatchOS}');
		var selectedObj = new Object();
		var report = [];
		batchOSTableModel = {
			url : contextPath+ "/GICLBatchOSPrintingController?action=showBatchOSPrinting&refresh=1",
			id: "BatchOS",
			options : {
				width : '680px',
				height : '340px',
				pager : {},
				validateChangesOnPrePager : false,
				onCellFocus : function(element, value, x, y, id) {
					selectedObj = tbgBatchOS.geniisysRows[y];
				},
				postPager : function() {
					tbgBatchOS.keys.removeFocus(tbgBatchOS.keys._nCurrentFocus, true);
					tbgBatchOS.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					tbgBatchOS.keys.removeFocus(tbgBatchOS.keys._nCurrentFocus, true);
					tbgBatchOS.keys.releaseKeys();
				},
				onSort : function() {
					tbgBatchOS.keys.removeFocus(tbgBatchOS.keys._nCurrentFocus, true);
					tbgBatchOS.keys.releaseKeys();
				},
				beforeSort: function(){
					resetobjBatchOS();
					disableButton("btnPrint");
					tbgBatchOS.keys.removeFocus(tbgBatchOS.keys._nCurrentFocus, true);
					tbgBatchOS.keys.releaseKeys();
				},
				toolbar : {
					elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
					onFilter : function() {
						disableButton("btnPrint");
						tbgBatchOS.keys.removeFocus(tbgBatchOS.keys._nCurrentFocus, true);
						tbgBatchOS.keys.releaseKeys();
					},
					onRefresh : function() {
						disableButton("btnPrint");
						tbgBatchOS.keys.removeFocus(tbgBatchOS.keys._nCurrentFocus, true);
						tbgBatchOS.keys.releaseKeys();
					},
				}
			},
			columnModel : [
					{
						id : 'recordStatus',
						title : '',
						width : '0',
						visible : false
					},
					{
						id : 'divCtrId',
						width : '0',
						visible : false
					},
					{	id : 'osTag',
				    	title: 'OS',
				    	align: 'center',
				    	titleAlign: 'center',
				    	width: '60px',
				    	maxlength: 1, 
				    	sortable: false,
				    	editable: true,
				    	visible: true,
				    	editor: new MyTableGrid.CellCheckbox({ 
				    		getValueOf: function(value){
				    			if (value){
				    				return "Y";
				    			}else{
				    				return "N";	
				    			}	
				    		},
				    		onClick: function(value, checked) {
								for ( var i = 0; i < objBatchOS.length; i++) {
									if (objBatchOS[i].tranId == selectedObj.tranId) {
										objBatchOS[i].osTag = value;
									}
								}
								setPrintButtons();
								tbgBatchOS.modifiedRows = []; 
		 			    	}
				    	}),	
				    },
				    {	id : 'lossTag',
				    	title: 'Loss',
				    	align: 'center',
				    	titleAlign: 'center',
				    	width: '60px',
				    	maxlength: 1, 
				    	sortable: false,
				    	editable: true,
				    	visible: true,
				    	editor: new MyTableGrid.CellCheckbox({ 
				    		getValueOf: function(value){
				    			if (value){
				    				return "Y";
				    			}else{
				    				return "N";	
				    			}	
				    		},
				    		onClick: function(value, checked) {
				    			var tag = 'N';
			            		if (checked) {
			            			if (selectedObj.tranClass == "OLR") {
			            				showMessageBox("This option not allowed for reversing entries.", "I");
									} else {
										var msgArray = [];
										var lossArray = getBatchOSRecord("getBatchOSLossExpRecord",selectedObj.tranId);
										for ( var i = 0; i < objBatchOS.length; i++) {
											for ( var j = 0; j < lossArray.length; j++) { 
												if (objBatchOS[i].tranId == selectedObj.tranId) {
													objBatchOS[i].lossTag = lossArray[j].tag;
													tag = lossArray[j].tag;
												}
											}
										}
										for ( var j = 0; j < lossArray.length; j++) {
											if (lossArray[j].msg != null && lossArray[j].msg != '') {
												msgArray.push(lossArray[j]);
											}
										}
										loopConfirmBox(msgArray,0,"loss");
									}
			            			setSpecCheckboxOnTBG('loss',tag);
								}else{
									for ( var i = 0; i < objBatchOS.length; i++) {
										if (objBatchOS[i].tranId == selectedObj.tranId) {
											objBatchOS[i].lossTag = value;
										}
									}
								}
			            		setPrintButtons();
			            		tbgBatchOS.modifiedRows = []; 
		 			    	}
				    	})
				    },
				    {	id : 'expTag',
				    	title: 'Exp',
				    	align: 'center',
				    	titleAlign: 'center',
				    	width: '60px',
				    	maxlength: 1, 
				    	sortable: false,
				    	editable: true,
				    	visible: true,
				    	editor: new MyTableGrid.CellCheckbox({ 
				    		getValueOf: function(value){
				    			if (value){
				    				return "Y";
				    			}else{
				    				return "N";	
				    			}	
				    		},
				    		onClick: function(value, checked) {
				    			var tag = 'N';
			            		if (checked) {
			            			if (selectedObj.tranClass == "OLR") {
			            				showMessageBox("This option not allowed for reversing entries.", "I");
									} else {
										var msgArray = [];
										var expArray = getBatchOSRecord("getBatchOSLossExpRecord",selectedObj.tranId);
										for ( var i = 0; i < objBatchOS.length; i++) {
											for ( var j = 0; j < expArray.length; j++) { 
												if (objBatchOS[i].tranId == selectedObj.tranId) {
													objBatchOS[i].expTag = expArray[j].tag;
													tag = expArray[j].tag;
												}
											}
										}
										for ( var j = 0; j < expArray.length; j++) {
											if (expArray[j].msg != null && expArray[j].msg != '') {
												msgArray.push(expArray[j]);
											}
										}
										loopConfirmBox(msgArray,0,"exp");
									}
			            			setSpecCheckboxOnTBG('exp',tag);
								}else{
									for ( var i = 0; i < objBatchOS.length; i++) {
										if (objBatchOS[i].tranId == selectedObj.tranId) {
											objBatchOS[i].expTag = value;
										}
									}
								}
			            		setPrintButtons();
			            		tbgBatchOS.modifiedRows = []; 
		 			    	}
				    	}),	
				    },
					{
						id : "tranDate",
						title : "Acct Date",
						width : '150px',
						titleAlign : 'center',
						align : 'center',
						filterOption: true,
						filterOptionType : 'formattedDate'//,
						/* renderer: function(value){ //Commented out by Jerome 09.21.2016 SR 5657
							return dateFormat(value, "mm-dd-yyyy");
						} */
					},
					{
						id : "tranId",
						title : "Tran ID",
						width : '100px',
						titleAlign : 'right',
						align : 'right',
						filterOption: true,
						filterOptionType : 'numberNoNegative'
					},
					{
						id : "branchCd",
						title : "Iss CD",
						width : '100px',
						titleAlign : 'left',
						align : 'left',
						filterOption: true
					},
					{
						id : "tranClass",
						title : "Tran Class",
						width : '100px',
						titleAlign : 'left',
						align : 'left',
						filterOption: true
					}
				],
			rows : jsonBatchOS.rows
		};
		tbgBatchOS = new MyTableGrid(batchOSTableModel);
		tbgBatchOS.pager = jsonBatchOS;
		tbgBatchOS.render('batchOSTable');
		tbgBatchOS.afterRender = function(){
												setCheckboxOnTBG();
											};
	} catch (e) {
		showErrorMessage("batchOSTableModel", e);
	}
	
	function resetobjBatchOS() {
		for ( var i = 0; i < objBatchOS.length; i++) {
			objBatchOS[i].osTag = 'N';
			objBatchOS[i].lossTag = 'N';
			objBatchOS[i].expTag = 'N';
		}
	}
	
	function setCheckboxOnTBG() {
		try {
			for ( var i = 0; i < objBatchOS.length; i++) {
				for ( var j = 0; j < tbgBatchOS.geniisysRows.length; j++) {
					if(objBatchOS[i].tranId == tbgBatchOS.geniisysRows[j].tranId){
						tbgBatchOS.setValueAt(objBatchOS[i].osTag, tbgBatchOS.getColumnIndex('osTag'), j, true);
						tbgBatchOS.setValueAt(objBatchOS[i].lossTag, tbgBatchOS.getColumnIndex('lossTag'), j, true);
						tbgBatchOS.setValueAt(objBatchOS[i].expTag, tbgBatchOS.getColumnIndex('expTag'), j, true);
					}	
				}
			}
			tbgBatchOS.modifiedRows = []; 
			$$("div.modifiedCell").each(function (a) {
				$(a).removeClassName('modifiedCell');
			});
		} catch (e) {
			showErrorMessage("setCheckboxOnTBG", e); 
		}
	}
	
	function setSpecCheckboxOnTBG(type,tag) {
		try {
			for ( var j = 0; j < tbgBatchOS.geniisysRows.length; j++) {
				if(selectedObj.tranId == tbgBatchOS.geniisysRows[j].tranId){
					if (type == 'loss') {
						tbgBatchOS.setValueAt(tag, tbgBatchOS.getColumnIndex('lossTag'), j, true);
					} else if(type == 'exp') {
						tbgBatchOS.setValueAt(tag, tbgBatchOS.getColumnIndex('expTag'), j, true);
					}
				}	
			}
			tbgBatchOS.modifiedRows = []; 
		} catch (e) {
			showErrorMessage("setSpecCheckboxOnTBG", e); 
		}
	}
	
	function getBatchOSRecord(action,tranId) {
		try{
			var result = [];
			new Ajax.Request(contextPath + "/GICLBatchOSPrintingController", {
			    parameters : {action : action,
			    	          tranId : tranId},
			    asynchronous: false,
				evalScripts: true,
				onComplete : function(response){
					if(checkErrorOnResponse(response)){
						result = eval(response.responseText);
					}
				} 
			});
			return result;
		}catch(e){
			showErrorMessage("getBatchOSRecord", e); 
		}	
		
	}
	
	function extractOSDetail(tranId,type) {
		try {
			new Ajax.Request(contextPath + "/GICLBatchOSPrintingController", {
			    parameters : {action : "extractOSDetail",
			    			  tranId : tranId},
			    asynchronous: false,
				evalScripts: true,
				onCreate : showNotice("Extrating, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						if(response.responseText == "SUCCESS"){
							for ( var i = 0; i < objBatchOS.length; i++) {
								if (objBatchOS[i].tranId == tranId) {
									if (type == "loss") {
										objBatchOS[i].lossTag = "Y";
									}else{
										objBatchOS[i].expTag = "Y";
									}
								}
							}
							setCheckboxOnTBG();
						}
					}
				} 
			});
		} catch (e) {
			showErrorMessage("extractOSDetail",e);
		}
	}
	
	function loopConfirmBox(msgArray,index,type) {
		try {
			for ( var i = index; i < msgArray.length; i++) {
				showConfirmBox("Confirmation", msgArray[i].msg, "Yes", "No",
						function() {
							extractOSDetail(msgArray[i].extractTranId,type);
							loopConfirmBox(msgArray,index+1,type);
							setPrintButtons();
						}, 
						function() {
							loopConfirmBox(msgArray,index+1,type);
							setPrintButtons();
						});
				break;
			}
		} catch (e) {
			showErrorMessage("loopConfirmBox",e);
		}
	}
	
	function setPrintButtons(){
		disableButton("btnPrint");
// 		disableToolbarButton("btnToolbarPrint");
		for ( var i = 0; i < objBatchOS.length; i++) {
			if (objBatchOS[i].osTag == "Y" || objBatchOS[i].lossTag == "Y" || objBatchOS[i].expTag == "Y") {
				enableButton("btnPrint");
// 				enableToolbarButton("btnToolbarPrint");
				break;
			} 
		}
	}
	
	function loopPrintReport() {
		try {
			var tranDate = 0;
			for ( var i = 0; i < objBatchOS.length; i++) {
				if (objBatchOS[i].osTag == "Y" || objBatchOS[i].lossTag == "Y" || objBatchOS[i].expTag == "Y") {
					if (objBatchOS[i].osTag == "Y") {
						if (objBatchOS[i].tranClass == "OL") {
							setPrintReportArray('GICLR207',objBatchOS[i]);
						} else if(objBatchOS[i].tranClass == "OLR") {
							setPrintReportArray('GICLR207R',objBatchOS[i]);
						}
						
						if ($("chkOSLossSummRep").checked) {
							if (tranDate != objBatchOS[i].tranDate) {
								setPrintReportArray('GICLR207C',objBatchOS[i]);
							}
							tranDate = objBatchOS[i].tranDate;
						}
					}
					
					if (objBatchOS[i].lossTag == "Y") {
						setPrintReportArray('GICLR207D',objBatchOS[i]);
					}
					
					if (objBatchOS[i].expTag == "Y") {
						setPrintReportArray('GICLR207L',objBatchOS[i]);
					}
				} 
			}
			if("screen" == $F("selDestination")){
				showMultiPdfReport(reports);
				reports = [];
			}
		} catch (e) {
			showErrorMessage("loopPrintReport",e);
		}
	}
	
	function setPrintReportArray(reportId,obj) {
		try {
			var fileType = $("rdoPdf").checked ? "PDF" : "CSV"; //edit by carlo rubenecia from *XLS to CSV 04.25.2016 SR 5419
			var content = contextPath+"/PrintBatchOsDetail?action=printReport"
						+"&noOfCopies="+$F("txtNoOfCopies")
						+"&printerName="+$F("selPrinter")
						+"&destination="+$F("selDestination")
						+"&reportId="+reportId
						+"&fileType="+fileType
						+"&moduleId="+"GICLS207"
						+"&tranClass="+obj.tranClass	
						+"&tranDate="+obj.tranDate
						+"&tranId="+obj.tranId
						+"&branchCd="+obj.branchCd; 
			printReport(content, '');
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

				var fileType = "PDF"; //added by carlo rubenecia 04.07.2016 SR 5419
				if($("rdoPdf").checked){//added by carlo rubenecia 04.07.2016 SR 5419
					fileType = "PDF";
				}else if ($("rdoCsv").checked){//added by carlo rubenecia 04.07.2016 SR 5419
					fileType = "CSV"; 
				}
				new Ajax.Request(content, {
					parameters : {destination : "FILE",
							      fileType    : fileType}, //added by carlo rubenecia 04.07.2016 SR 5419
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							var repType = fileType == "CSV" ? "csv" : "reports"; //added by carlo rubenecia 04.26.2016 SR 5418
							if($("geniisysAppletUtil") == null || $("geniisysAppletUtil").copyFileToLocal == undefined){
								showMessageBox("Local printer applet is not configured properly. Please verify if you have accepted to run the Geniisys Utility Applet and if the java plugin in your browser is enabled.", imgMessage.ERROR);
							} else {
								//var message = $("geniisysAppletUtil").copyFileToLocal(response.responseText, "reports"); removed by carlo rubenecia 04.25.2016 SR 5419
								var message = $("geniisysAppletUtil").copyFileToLocal(response.responseText, repType); //added by carlo rubenecia 04.25.2016 SR 5419 --START
								if(fileType == "CSV"){
									deleteCSVFileFromServer(response.responseText);
								}//added by carlo rubenecia 04.25.2016 SR 5419 --END
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
	
	function addCheckbox(){
		var htmlCode = "<table cellspacing='10px' style='margin: 10px;'><tr><td><input type='checkbox' id='chkOSLossSummRep' /></td><td><label for='chkOSLossSummRep'>Include O/S Loss Summary Report</label></td></tr></table>"; 
		
		$("printDialogFormDiv2").update(htmlCode); 
		$("printDialogFormDiv2").show();
		$("printDialogMainDiv").up("div",1).style.height = "248px";
		$($("printDialogMainDiv").up("div",1).id).up("div",0).style.height = "280px";
	}
	
	/* observe */
	$("btnToolbarExit").observe("click", function() {
		if(nvl(objAC.fromACMenu, 'N') == 'N'){ // added condition by robert SR 4953 10.28.15
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
		}else{
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}
	});
	$("chkOS").observe("change", function() {
		if ($("chkOS").checked) {
			for ( var i = 0; i < objBatchOS.length; i++) {
				objBatchOS[i].osTag = 'Y';
			}
		}else{
			for ( var i = 0; i < objBatchOS.length; i++) {
				objBatchOS[i].osTag = 'N';
			}
		}
		setCheckboxOnTBG();
		setPrintButtons();
	});
	$("chkLoss").observe("change", function() {
		var lossArray = [];
		var msgArray = [];
		if ($("chkLoss").checked) {
			lossArray = getBatchOSRecord("getBatchOSLossExpRecord",'');
			for ( var i = 0; i < objBatchOS.length; i++) {
				for ( var j = 0; j < lossArray.length; j++) { 
					if (objBatchOS[i].tranId == lossArray[j].tranId) {
						objBatchOS[i].lossTag = lossArray[j].tag;
					}
				}
			}
			for ( var j = 0; j < lossArray.length; j++) { 
				if (lossArray[j].msg != null && lossArray[j].msg != '') {
					msgArray.push(lossArray[j]);
				}
			}
			loopConfirmBox(msgArray,0,"loss");
		}else{
			for ( var i = 0; i < objBatchOS.length; i++) {
				objBatchOS[i].lossTag = 'N';
			}
		}
		setCheckboxOnTBG();
		setPrintButtons();
	});
	$("chkExp").observe("change", function() {
		var expArray = [];
		var msgArray = [];
		if ($("chkExp").checked) {
			expArray = getBatchOSRecord("getBatchOSLossExpRecord",'');
			for ( var i = 0; i < objBatchOS.length; i++) {
				for ( var j = 0; j < expArray.length; j++) { 
					if (objBatchOS[i].tranId == expArray[j].tranId) {
						objBatchOS[i].expTag = expArray[j].tag;
					}
				}
			}
			for ( var j = 0; j < expArray.length; j++) { 
				if (expArray[j].msg != null && expArray[j].msg != '') {
					msgArray.push(expArray[j]);
				}
			}
			loopConfirmBox(msgArray,0,"exp");
		}else{
			for ( var i = 0; i < objBatchOS.length; i++) {
				objBatchOS[i].expTag = 'N';
			}
		}
		setCheckboxOnTBG();
		setPrintButtons();
	});
	
// 	$("btnToolbarPrint").observe("click", function(){
// 		showGenericPrintDialog("Print OS Detail Report",loopPrintReport,addCheckbox,true);
// 	});
	
	$("btnPrint").observe("click", function(){
		showGenericPrintDialog("Print OS Detail Report",loopPrintReport,addCheckbox,true);
		$(csvOptionDiv).show(); // added by carlo rubenecia 04/25/2016 SR-5419
	});
	
	$("mtgRefreshBtnBatchOS").observe("mousedown",function(){ //added by steven 08.04.2014
		resetobjBatchOS();
	});
	
	$("mtgBtnOkFilterBatchOS").observe("click",function(){ //added by steven 08.04.2014
		resetobjBatchOS();
	});
	
	var objBatchOS = getBatchOSRecord("getBatchOSRecord",'');
	setPrintButtons();
</script>


