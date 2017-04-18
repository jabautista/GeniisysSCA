<div id="processDataPerBill" name="processDataPerBill">
	<div id="toolbarGiacs604">
		<div id="toolbarDiv" name="toolbarDiv">	
			<div class="toolButton" style="float: right;">
				<span style="background: url(${pageContext.request.contextPath}/images/toolbar/exit.png) left center no-repeat;" id="uploadingExit">Exit</span>
				<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/exitDisabled.png) left center no-repeat;" id="btnToolbarExitDisabled">Exit</span>
			</div>
	 	</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Process Data per Bill</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	<div class="sectionDiv" align="center" id="giacs604Header" style="padding-top: 10px; padding-bottom: 10px;">
		<table style="margin-top: 5px;">
			<tr>
				<td class="rightAligned">Batch No</td>
				<td class="leftAligned">
					<input id="txtFileNoGiacs604" type="text" class="" style="width: 200px;" tabindex="101" readonly="readonly">
				</td>
				<td class="rightAligned">File Name</td>
				<td class="leftAligned">
					<input id="txtFileNameGiacs604" type="text" class="" style="width: 200px;" tabindex="102" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Source</td>
				<td class="leftAligned" colspan="3">
					<input id="txtSourceCdGiacs604" type="text" class="" style="width: 100px;" tabindex="103" readonly="readonly">
					<input id="txtSourceNameGiacs604" type="text" class="" style="width: 389px;" tabindex="104" readonly="readonly">
				</td>
			</tr>		
			<tr>
				<td class="rightAligned">Tran Date</td>
				<td class="leftAligned">
					<input id="txtTranDateGiacs604" type="text" class="" style="width: 200px;" tabindex="105" readonly="readonly">
				</td>
				<td class="rightAligned">OR/Req/JV No</td>
				<td class="leftAligned">
					<input id="txtOrReqJvNoGiacs604" type="text" class="" style="width: 200px;" tabindex="106" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td colspan="4" align="center" style="padding-top: 20px;">
					<input type="button" class="button" id="btnPaymentDetails" value="Payment Details" tabindex="107">
				</td>
			</tr>				
		</table>
	</div>
	<div class="sectionDiv" id="processDatePerBillTableDiv">
		<div id="processDatePerBillTable" style="height: 331px; padding: 20px 100px 20px 100px;"></div>
		<table style="margin-top: 5px;" align="center">
			<th></th>
			<th></th>
			<th>Legend</th>
			<tr>
				<td class="rightAligned">Payor</td>
				<td class="leftAligned">
					<input id="txtPayorGiacs604" type="text" class="" style="width: 450px;" tabindex="201" readonly="readonly">
				</td>
				<td class="leftAligned" rowspan="3">
				<div>
					<textarea class="required" readonly="readonly" style="float: left; height: 90px; width: 150px; margin-top: 0; resize: none;" id="txtLegend" name="txtLegend" maxlength="4000" onkeyup="limitText(this,4000);" tabindex="204"></textarea>
				</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Payment Details</td>
				<td class="leftAligned">
					<input id="txtPaymentDetails" type="text" class="" style="width: 450px;" tabindex="202" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center" style="padding-top: 10px; padding-bottom: 10px;">
					<input type="button" class="button" id="btnForeignCurrency" value="Foreign Currency" tabindex="203">
				</td>
			</tr>				
		</table>
	</div>
	<div class="sectionDiv" align="center" id="giacs604Header" style="margin-bottom: 15px;">
		<table>
			<tr>
				<td>
					<fieldset style="width: 240px; height: 50px; margin: 20px;">
						<legend>Transaction</legend>
						<table style="margin-top: 8px;">
							<tr>
								<td class="rightAligned">
									<input type="radio" name="transaction" id="rdoOR" style="float: left; margin: 3px 2px 3px 30px;" tabindex="301"/>
									<label for="rdoOR" style="float: left; height: 20px; padding-top: 3px;" title="OR">OR</label>
								</td>
								<td class="rightAligned">
									<input type="radio" name="transaction" id="rdoDV" style="float: left; margin: 3px 2px 3px 30px;" tabindex="302"/>
									<label for="rdoDV" style="float: left; height: 20px; padding-top: 3px;" title="DV">DV</label>
								</td>
								<td class="rightAligned">
									<input type="radio" name="transaction" id="rdoJV" style="float: left; margin: 3px 2px 3px 30px;" tabindex="303"/>
									<label for="rdoJV" style="float: left; height: 20px; padding-top: 3px;" title="JV">JV</label>
								</td>
							</tr>
						</table>
					</fieldset>
				</td>
				<td class="rightAligned" style="width: 60px"><label id="lblOrDate">O.R. Date</label></td>
				<td class="leftAligned" style="width: 170px">
					<!-- <input id="txtOrDate" type="text" class="" style="width: 150px;" tabindex="304" readonly="readonly"> -->
					<div id="OrDateDiv" style="float: left; width: 150px;" class="withIconDiv">
						<input type="text" id="txtOrDate" name="txtOrDate" class="withIcon date" readonly="readonly" style="width: 125px;" tabindex="1005"/>
						<img id="btnOrDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="OR Date" tabindex="107"/>
					</div>
				</td>
				<td class="rightAligned">Upload Date</td>
				<td class="leftAligned">
					<input id="txtUploadDate" type="text" class="" style="width: 150px;" tabindex="305" readonly="readonly">
				</td>
			</tr>
		</table>
		<div align="center" style="padding: 10px 0 10px 0; border-top: 1px solid #E0E0E0;">
			<input type="button" class="button" id="btnCheckData" value="Check Data" tabindex="401" style="width: 150px; ">
			<input type="button" class="button" id="btnPrintReport" value="Print Report" tabindex="402" style="width: 150px;">
			<input type="button" class="button" id="btnUpload" value="Upload" tabindex="403" style="width: 150px;">
			<input type="button" class="button" id="btnPrintUpload" value="Print" tabindex="404" style="width: 150px;">
			<input type="button" class="button" id="btnCancelFile" value="Cancel File" tabindex="405" style="width: 150px;">
		</div>
	</div>
</div>
<div id="otherModuleDiv">
</div>
<script type="text/javascript">
	setModuleId("GIACS604");
	setDocumentTitle("Process Data per Bill");
	initializeAll();
	object = JSON.parse('${showGiacs604Head}');
	$("txtFileNoGiacs604").value = object.fileNo;
	$("txtFileNameGiacs604").value = object.fileName;
	$("txtSourceCdGiacs604").value = object.sourceCd;
	$("txtSourceNameGiacs604").value = object.dspSourceName;
	$("txtTranDateGiacs604").value = object.tranDate;
	$("txtOrReqJvNoGiacs604").value = object.dspOrReqJvNo;
	$("txtOrDate").value = object.tranDate == null ? dateFormat(object.nbtOrDate, "mm-dd-yyyy") : object.tranDate;
	$("txtUploadDate").value = object.uploadDate;
	if(object.dspTranClass == "DV"){
		$("rdoDV").checked = true;
		$("lblOrDate").hide();
		//$("txtOrDate").hide();
		$("OrDateDiv").hide();
		enableButton("btnPaymentDetails");
	} else if(object.dspTranClass == "JV"){
		$("rdoJV").checked = true;
		$("lblOrDate").hide();
		//$("txtOrDate").hide();
		$("OrDateDiv").hide();
		enableButton("btnPaymentDetails");
	} else {
		$("rdoOR").checked = true;
		$("lblOrDate").show();
		//$("txtOrDate").show();
		$("OrDateDiv").show();
		disableButton("btnPaymentDetails");
	}  
	disableButton("btnForeignCurrency");
	
	if (object.fileStatus == "C"){
		disableButton("btnCancelFile");
		disableButton("btnUpload");
		disableButton("btnPrint");
		
		disableDate("btnOrDate");
	}else if (object.fileStatus != 1){
		disableButton("btnCancelFile");
		disableButton("btnUpload");
		disableButton("btnCheckData");
		
		disableButton("rdoOR");
		disableButton("rdoDV");
		disableButton("rdoJV");
		
		disableDate("btnOrDate");
	}else{
		enableButton("btnCancelFile");
		enableButton("btnUpload");
		enableButton("btnCheckData");
		
		enableButton("rdoOR");
		enableButton("rdoDV");
		enableButton("rdoJV");
		
		enableDate("btnOrDate");
	}
	
	legend = JSON.parse('${giacs603Legend}');
	var legendString = "";
	for ( var i = 0; i < legend.rows.length; i++) {
		if (i == 0){
			legendString = legend.rows[i].legend;
		} else {
			legendString = legendString + "\n" +legend.rows[i].legend;
		}
	}
	
	$("txtLegend").value = legendString;
	
	function showGiacs604(){ //john 8.27.2015 : conversion of GIACS604
		new Ajax.Updater("process", contextPath+"/GIACUploadingController",{
			parameters:{
				action: "showGiacs604",
				sourceCd: $("txtSourceCdGiacs604").value,
				fileNo: $("txtFileNoGiacs604").value
			},
			asynchronous: false,
			evalScripts: true, 
			onCreate: showNotice("Loading, please wait..."),
			onComplete: function(response){
				hideNotice();
				if (checkErrorOnResponse(response)) {
					$("convertFileMainDiv").hide();
					//$("process").show();
				}	
			}
		});
	}
	
	$("reloadForm").observe("click", showGiacs604);
	
	//nieko Accounting Uploading GIACS604, modify exit toolbar
	/*$("acExit").stopObserving();
	$("acExit").observe("click", function() {
		objACGlobal.callingForm = "";
		$("process").innerHTML = "";
		$("process").hide();
		
		setModuleId("GIACS601");
		$("convertFileMainDiv").show();
		$("acExit").show();
		$("acExit").stopObserving();
		$("acExit").observe("click", function() {
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		});
	});*/
	
	objGIACS604 = {};
	objGIACS604.giacs604RecList = JSON.parse('${jsonGiacs604Table}');
	var rowIndex = -1;
	objCurrGiacs604 = null;
	variables = {};
	
	objGIACS604.tranClass = object.tranClass;
	objGIACS604.fileStatus = object.fileStatus;
	
	var giacs604Table = {
			url : contextPath + "/GIACUploadingController?action=showGiacs604RecList&refresh=1&fileNo="+object.fileNo+"&sourceCd="+object.sourceCd,
			//id: "1",		//nieko Accounting Uploading GIACS604
			options : {
				width : '720px',
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrGiacs604 = tbgGiacs604Table.geniisysRows[y];
					setFieldValues(objCurrGiacs604);
					tbgGiacs604Table.keys.removeFocus(tbgGiacs604Table.keys._nCurrentFocus, true);
					tbgGiacs604Table.keys.releaseKeys();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgGiacs604Table.keys.removeFocus(tbgGiacs604Table.keys._nCurrentFocus, true);
					tbgGiacs604Table.keys.releaseKeys();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgGiacs604Table.keys.removeFocus(tbgGiacs604Table.keys._nCurrentFocus, true);
						tbgGiacs604Table.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					if(changeTag == 1){
						return false;
					}
				},
				onSort: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgGiacs604Table.keys.removeFocus(tbgGiacs604Table.keys._nCurrentFocus, true);
					tbgGiacs604Table.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgGiacs604Table.keys.removeFocus(tbgGiacs604Table.keys._nCurrentFocus, true);
					tbgGiacs604Table.keys.releaseKeys();
				},				
				prePager: function(){
					if(changeTag == 1){
						return false;
					}
					tbgGiacs604Table.keys.removeFocus(tbgGiacs604Table.keys._nCurrentFocus, true);
					tbgGiacs604Table.keys.releaseKeys();
				},
				checkChanges: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetail: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (changeTag == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTag == 1 ? true : false);
				}
			},
			columnModel : [
				{ 								// this column will only use for deletion
				    id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
				    width: '0',				    
				    visible : false			
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},	
				{
					id : 'billNo',
					title : 'Bill No',
					align : "left",
					titleAlign: "left",
					width : '150px',
					filterOption : true,
				},
				{
					id : 'collectionAmt',
					filterOption : true,
					title : 'Collection Amt',
					align : "right",
					titleAlign: "right",
					width : '150px',
					renderer : function(value) {
				    	return formatCurrency(value);
				    }
				},
				{
					id : 'dspCollnAmtDiff',
					filterOption : true,
					title : 'Colln Amt Diff',
					align : "right",
					titleAlign: "right",
					width : '150px',
					renderer : function(value) {
				    	return formatCurrency(value);
				    }		
				},
				{
					id : 'premChkFlag',
					filterOption : true,
					title : 'P',
					width : '20px'				
				},
				{
					id : 'chkRemarks',
					filterOption : true,
					title : 'Checking Results',
					width : '230px',
					align : "left",
					titleAlign: "left"
				}
			],
			rows : objGIACS604.giacs604RecList.rows
		};

		tbgGiacs604Table = new MyTableGrid(giacs604Table);
		tbgGiacs604Table.pager = objGIACS604.giacs604RecList;
		tbgGiacs604Table.render("processDatePerBillTable");
		
		function setFieldValues(rec){
			$("txtPayorGiacs604").value = 		(rec == null ? "" : unescapeHTML2(rec.payor));
			$("txtPaymentDetails").value = 		(rec == null ? "" : unescapeHTML2(rec.dspPaymentDetails));
			rec == null ? disableButton("btnForeignCurrency") : enableButton("btnForeignCurrency");
		}
		
		$("btnCheckData").observe("click", function(){
			function checkData(){
				new Ajax.Request(contextPath+"/GIACUploadingController", {
					method: "POST",
					asynchronous: true,
					parameters : {action : "checkDataGiacs604",
								sourceCd : $("txtSourceCdGiacs604").value,
								fileNo : $("txtFileNoGiacs604").value,
							 	  },
					onCreate : showNotice("Processing, please wait..."),
					onComplete: function(response){
						hideNotice();
						if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
							showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
								showGiacs604();
							});
						}
					}
				});
			}
			
			checkData();
		});
		
		function printReport(){
			try {
				if (!$("convertDate").checked && !$("uploadDate").checked){
					showMessageBox("Please select type of report.", "I");
					return false;
				}
				
				var content = contextPath+"/UploadingReportPrintController?action=printReport&sourceCd="+$F("txtSourceCdGiacs604")+
										"&fileName="+$F("txtFileNoGiacs604")+"&transactionCd=1&printerName="+$F("selPrinter");							
				var repDateParam = "";
				var reports = [];
				
				if ($("convertDate").checked){
					repDateParam = object.convertDate == "" || object.convertDate == null ? "" : dateFormat(Date.parse(object.convertDate), "mm-dd-yyyy");
					reportId = "GIACR601";
					reports.push({reportUrl : content+"&reportId="+reportId+"&fromDate="+repDateParam+"&toDate="+repDateParam,
								  reportTitle : reportId});
				}
				if ($("uploadDate").checked){
					repDateParam = object.uploadDate == "" || object.uploadDate == null ? "" : dateFormat(Date.parse(object.uploadDate), "mm-dd-yyyy");
					reportId = "GIACR602";
					reports.push({reportUrl : content+"&reportId="+reportId+"&fromDate="+repDateParam+"&toDate="+repDateParam,
						  reportTitle : reportId});
				}

				if("screen" == $F("selDestination")){
					showMultiPdfReport(reports);
					reports = [];
				}else if($F("selDestination") == "printer"){
					for(var i=0; i<reports.length; i++){
						new Ajax.Request(reports[i].reportUrl, {
							asynchronous : false,
							parameters : {noOfCopies : $F("txtNoOfCopies")},
							onCreate: showNotice("Processing, please wait..."),				
							onComplete: function(response){
								hideNotice();
								if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
									if (i == reports.length-1){
										overlayGenericPrintDialog.close();
									}					
								}
							}
						});
					}
				}else if("file" == $F("selDestination")){
					for(var i=0; i<reports.length; i++){
						new Ajax.Request(reports[i].reportUrl, {
							parameters : {destination : "FILE"},
							onCreate: showNotice("Generating report, please wait..."),
							onComplete: function(response){
								hideNotice();
								if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
									copyFileToLocal(response);
									if (i == reports.length-1){
										overlayGenericPrintDialog.close();
									}
								}
							}
						});
					}
				}else if("local" == $F("selDestination")){
					for(var i=0; i<reports.length; i++){
						new Ajax.Request(reports[i].reportUrl, {
							asynchronous : false,
							parameters : {destination : "LOCAL"},
							onComplete: function(response){
								hideNotice();
								if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
									var result = printToLocalPrinter(response.responseText);
									if(result){
										if (i == reports.length-1){
											overlayGenericPrintDialog.close();
										}
									}
								}
							}
						});
					}
				}
				
			} catch (e){
				showErrorMessage("printReport", e);
			}
		}
		
		function showPrintDialog(){
			overlayGenericPrintDialog = Overlay.show(contextPath+"/GIISController", {
				urlContent : true,
				urlParameters: {action : "showGenericPrintDialog",
								showFileOption : true},
			    title: "Print Report",
			    height: 220,
			    width: 380,
			    draggable: true
			});
			
			overlayGenericPrintDialog.onPrint = printReport;
			overlayGenericPrintDialog.onLoad  = nvl(addPrintForm,null);
			overlayGenericPrintDialog.onCancel = function(){
				false;
			};
		}
		
		function addPrintForm(){
			try{ 
				var content = "<table border='0' style='margin: auto; margin-top: 10px; margin-bottom: 10px;'>" +
								"<tr><td><input type='checkbox' id='convertDate' name='convertDate' style='float: left; margin-bottom: 3px;'><label style='margin: 2px 60px 0 4px;' for='convertDate'>Convert Date</label></td>"+
							  	"<td><input type='checkbox' id='uploadDate' name='uploadDate' style='float: left; padding-bottom: 3px; margin: 0 4px 3px 0;'><label for='uploadDate'>Upload Date</label></td></tr>";
				$("printDialogFormDiv3").update(content); 
				$("printDialogFormDiv3").show();
				enableButton("btnPrint");
				
				$("convertDate").checked = true;
				
				$("uploadDate").observe("click", function(){
					if (this.checked && nvl(object.uploadDate, "*") == "*"){
						showMessageBox("This file has not been uploaded yet.", "E");
						$("uploadDate").checked = false;
					}
				});
			}catch(e){
				showErrorMessage("addPrintForm", e);	
			}
		}	
		
		$("btnPrintReport").observe("click", showPrintDialog);
		
		$("btnCancelFile").observe("click", function(){
			if(object.fileStatus != 1){
				showMessageBox("This file cannot be cancelled.", imgMessage.ERROR);
			} else {
				showConfirmBox("Confirmation", "Are you sure you want to cancel this file?", "Yes", "No",
						function(){
							cancelFile();
						}, null
				);
			}
		});
		
		function cancelFile(){
			new Ajax.Request(contextPath+"/GIACUploadingController", {
				method: "POST",
				parameters : {action : "cancelFileGiacs604",
								sourceCd : $("txtSourceCdGiacs604").value,
								fileNo : $("txtFileNoGiacs604").value
						 	  },
				onCreate : showNotice("Processing, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
							disableButton("btnUpload");
							disableButton("btnPrintUpload");
							disableButton("btnCancelFile");
							disableButton("btnPaymentDetails");
						});
					}
				}
			});
		}
		
		function showPaymentDetails(action) {
			try {				
				overlayPaymentDetails = Overlay.show(contextPath
						+ "/GIACUploadingController", {
					urlContent : true,
					urlParameters : {
						action : action,
						sourceCd : $("txtSourceCdGiacs604").value,
						fileNo : $("txtFileNoGiacs604").value,
						ajax : "1",
						},
					title : "Payment Details",
					 height: action == "giacs604ShowPaymentDetailsDV" ? 350 : 270,
					 width: 855,
					draggable : true
				});
			} catch (e) {
				showErrorMessage("overlay error: ", e);
			}
		}
		
		$("rdoOR").observe("click", function(){
			$("lblOrDate").show();
			//$("txtOrDate").show();
			$("OrDateDiv").show();
			disableButton("btnPaymentDetails");
		});
		
		$("rdoDV").observe("click", function(){
			$("lblOrDate").hide();
			//$("txtOrDate").hide();
			$("OrDateDiv").hide();
			enableButton("btnPaymentDetails");
		});
		
		$("rdoJV").observe("click", function(){
			$("lblOrDate").hide();
			//$("txtOrDate").hide();
			$("OrDateDiv").hide();
			enableButton("btnPaymentDetails");
		});
		
		$("btnPaymentDetails").observe("click", function(){
			if ($("rdoDV").checked == true){
				showPaymentDetails("giacs604ShowPaymentDetailsDV");
			} else {
				showPaymentDetails("giacs604ShowPaymentDetailsJV");
			}
		});
		
		$("btnForeignCurrency").observe("click", function(){
			showForeignCurrency();
		});
		
		function showForeignCurrency() {
			try {
				overlayForeignCurrency = Overlay.show(contextPath
						+ "/GIACUploadingController", {
					urlContent : true,
					urlParameters : {
						action : "uploadingForeignCurrencyPerBill",
						ajax : "1",
						},
					title : "Foreign Currency",
					 height: 125,
					 width: 600,
					draggable : true
				});
			} catch (e) {
				showErrorMessage("overlay error: ", e);
			}
		}
		
		$("btnUpload").observe("click", function(){
			function validateUpload(){
				new Ajax.Request(contextPath+"/GIACUploadingController", {
					method: "POST",
					parameters : {action : "validateUploadGiacs603",
								sourceCd : $("txtSourceCdGiacs604").value,
								fileNo : $("txtFileNoGiacs604").value
							 	  },
					onCreate : showNotice("Processing, please wait..."),
					onComplete: function(response){
						hideNotice();
						if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
							afterValidateUpload();
						}
					}
				});
			}
			
			function afterValidateUpload(){
				if($("rdoOR").checked){
					showConfirmBox("Confirmation", "O.R. transactions will be created for "
					           + object.branchCd +" branch. The indicated O.R. Date will be used for the transactions. Do you wish to proceed?"
					           , "Yes", "No",
							function(){
					        	objGIACS604.branchCd = unescapeHTML2(object.branchCd);
					        	showDefaultBank();
							}, null
					);
				} else if ($("rdoDV").checked){
					if(checkUserPerIssCdAcctg(object.branchCd, "GIACS016")){
						showConfirmBox("Confirmation", "A Disbursement Request will be created for "
						           + object.branchCd +" branch. The indicated date in the Payment Request Details will be used for the transaction. Do you wish to proceed?"
						           , "Yes", "No",
								function(){
						        	checkPaymentDetails();
								}, null
						);
					} else {
						showMessageBox("You are not allowed to create a JV transaction for " + object.branchCd + " branch.", imgMessage.ERROR);
					}
				} else if ($("rdoJV").checked){
					if(checkUserPerIssCdAcctg(object.branchCd, "GIACS003")){
						showConfirmBox("Confirmation", "A JV transaction will be created for "
						           + object.branchCd +" branch. The indicated date in the JV Details will be used for the transaction. Do you wish to proceed?"
						           , "Yes", "No",
								function(){
						        	checkPaymentDetails();
								}, null
						);
					} else {
						showMessageBox("You are not allowed to create a Disbursement Request for " + object.branchCd + " branch.", imgMessage.ERROR);
					}
				}	
			}
			
			function showDefaultBank() {
				try {
					overlayBank = Overlay.show(contextPath
							+ "/GIACUploadingController", {
						urlContent : true,
						urlParameters : {
							action : "showGiacs604DefaultBank",
							branchCd: object.branchCd,
							ajax : "1"
							},
						title : "Details",
						 height: 170,
						 width: 458,
						draggable : true
					});   
				} catch (e) {
					showErrorMessage("showDefaultBank", e);
				}
			}
			
			validateUpload();
		});
		
		
		function checkPaymentDetails(){
			new Ajax.Request(contextPath+"/GIACUploadingController", {
				method: "POST",
				parameters : {action : "checkForClaim",
							sourceCd : $F("txtSourceCdGiacs604"),
							fileNo : $F("txtFileNoGiacs604"),
							moduleId : "GIACS604"
						 	  },
				onCreate : showNotice("Processing, please wait..."),
				onComplete: function(response){
					hideNotice();
					 if(checkErrorOnResponse(response)){
						 if (response.responseText.include("Geniisys Exception")){
							var message = response.responseText.split("#"); 
							showConfirmBox2("Confirmation",message[2], "Yes", "No",
								function(){
									if(hasCCFunction == "Y"){
										checkOverride();
									} else {
										showGenericOverride("GIACS007", "CC",
												function(ovr, userId, res){
													if(res == "FALSE"){
														showMessageBox(userId + " is not allowed to process collections for policies with existing claim.", imgMessage.ERROR);
														$("txtOverrideUserName").clear();
														$("txtOverridePassword").clear();
														return false;
													} else if(res == "TRUE"){
														checkOverride();
														ovr.close();
														delete ovr;
													}
												},
												null
										);
									}
								},
								""
							);
						} else {
							checkOverride();
						}
					 } 
				}
			});
		}
		
		function checkOverride(){
			new Ajax.Request(contextPath+"/GIACUploadingController", {
				method: "POST",
				parameters : {action : "checkForOverride",
							sourceCd : $F("txtSourceCdGiacs604"),
							fileNo : $F("txtFileNoGiacs604"),
							moduleId : "GIACS604"
						 	  },
				onCreate : showNotice("Processing, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						 if (response.responseText.include("Geniisys Exception")){
							var message = response.responseText.split("#");
							showConfirmBox2("Confirmation",message[2], "Yes", "No",
								function(){
									showGenericOverride("GIACS604", "UA",
										function(ovr, userId, res){
											if(res == "FALSE"){
												showMessageBox(userId + " does not have an overriding function for this module.", imgMessage.ERROR);
												$("txtOverrideUserName").clear();
												$("txtOverridePassword").clear();
												return false;
											} else if(res == "TRUE"){
												uploadPayments();
												ovr.close();
												delete ovr;
											}
										},
										null
									);
								},
								""
							);
						 } else {
							 uploadPayments();
						 }
					}
				}
			});
		}
		
		function uploadPayments(){
			new Ajax.Request(contextPath+"/GIACUploadingController", {
				method: "GET",
				parameters : {action : "giacs604UploadPayments",
							branchCd : object.branchCd,
							sourceCd : $F("txtSourceCdGiacs604"),
							fileNo : $F("txtFileNoGiacs604"),
							orDate : $F("txtOrDate"),
							paymentDate: object.paymentDate,
							tranClass : $("rdoDV").checked ? "DV" : "JV"
						 	  },
				onCreate : showNotice("Processing, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
						showGiacs604();
					}
				}
			});
		}
		
		$("btnPrintUpload").observe("click", function(){
			if(objGIACS604.tranClass == "" || objGIACS604.tranClass == null){
				showMessageBox("This file has not been uploaded yet.", "E");
			} else {
				tbgGiacs604Table.onRemoveRowFocus();
				if($("rdoOR").checked){
					validatePrintOr();
				} else if($("rdoDV").checked){
					validatePrintDv();
				} else if($("rdoJV").checked){
					validatePrintJv();
				}
			}
		});
		
		function validatePrintOr(){
			new Ajax.Request(contextPath+"/GIACUploadingController", {
				method: "POST",
				asynchronous: true,
				parameters : {action : "giacs604ValidatePrintOr", // nieko Accounting Uploading GIACS604
							sourceCd : $("txtSourceCdGiacs604").value,
							fileNo : $("txtFileNoGiacs604").value,
						 	  },
				onCreate : showNotice("Processing, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
						var obj = JSON.parse(response.responseText);
						objACGlobal.callingForm = "GIACS604";
						objACGlobal.callingForm2 = "GIACS604";
						objGIACS604.fundCd = unescapeHTML2(obj.vFundCd);
						objGIACS604.fundDesc = unescapeHTML2(obj.vFundDesc);
						objGIACS604.branchCd = unescapeHTML2(obj.vBranchCd);
						objGIACS604.branchName = unescapeHTML2(obj.vBranchName);
						objGIACS604.gaccTranId = obj.vTranId;
						
						objGIACS604.sourceCd = object.sourceCd;
						objGIACS604.fileNo = object.fileNo;
						//nieko Accounting Uploading GIACS604
						objGIACS604.uploadQuery = unescapeHTML2(obj.vUploadQuery);

						new Ajax.Request(contextPath+"/GIACOrderOfPaymentController",{
							parameters: {
								action : "showBatchORPrinting"
							},
							asynchronous: false,
							evalScripts: true,
							onCreate: function (){
								showNotice("Loading, please wait...");
							},
							onComplete: function(response){
								hideNotice();
								if (checkErrorOnResponse(response)){
									//$("otherModuleDiv").update(response.responseText);
									//$("otherModuleDiv").show();
									$("mainContents").update(response.responseText);
									$("processDataPerBill").hide();
								}
							}
						});
					}
				}
			});
		}
		
		function validatePrintDv(){
			new Ajax.Request(contextPath+"/GIACUploadingController", {
				method: "POST",
				asynchronous: true,
				parameters : {action : "giacs604ValidatePrintDv", // nieko --nieko Accounting Uploading GIACS60
							sourceCd : $("txtSourceCdGiacs604").value,
							fileNo : $("txtFileNoGiacs604").value,
						 	  },
				onCreate : showNotice("Processing, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
						var obj = JSON.parse(response.responseText);
						var disbursement = "";
						if (obj.docCd == "BCSR" || obj.docCd == "CSR" || obj.docCd == "SCSR") {
							disbursement = "CPR";
						}else if (obj.docCd == "OFPPR") {
							disbursement = "FPP";
						}else if (obj.docCd == "CPR") {
							disbursement = "CP";
						}else{
							disbursement = "OP";
						}
						
						objGIACS604.sourceCd = object.sourceCd;
						objGIACS604.fileNo = object.fileNo;
						
						new Ajax.Request(contextPath+"/GIACPaytRequestsController",{
							parameters: {
								action: "showMainDisbursementPage",
								disbursement: disbursement,
								refId: obj.gprqRefId,
								newRec: "N",
								branch: obj.branchCd
							},
							asynchronous : false,
							evalScripts : true,
							onCreate : function() {
								showNotice("Getting Disbursement Page, please wait...");
							},
							onComplete : function(response) {
								if (checkErrorOnResponse(response)) {
									objACGlobal.callingForm = "GIACS604";
									objACGlobal.callingForm2 = "GIACS604";
									//$("otherModuleDiv").update(response.responseText);
									//$("otherModuleDiv").show();
									$("mainContents").update(response.responseText);
									$("processDataPerBill").hide();
								}
							}
						});
					}
				}
			});
		}
		
		function validatePrintJv(){
			new Ajax.Request(contextPath+"/GIACUploadingController", {
				method: "POST",
				asynchronous: true,
				parameters : {action : "giacs604ValidatePrintJv", // nieko --nieko Accounting Uploading GIACS604
							sourceCd : $("txtSourceCdGiacs604").value,
							fileNo : $("txtFileNoGiacs604").value,
						 	  },
				onCreate : showNotice("Processing, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
						var obj = JSON.parse(response.responseText);
						
						objGIACS604.sourceCd = object.sourceCd;
						objGIACS604.fileNo = object.fileNo;
						
						new Ajax.Request(contextPath + "/GIACJournalEntryController?action=showJournalEntries", {
							parameters : {
								action2 : "getJournalEntries",
								moduleId : "GIACS004",
								fundCd : obj.fundCd,
								branchCd : obj.branchCd,
								tranId : obj.tranId,
								pageStatus : ""
							},
							asynchronous : true,
							evalScripts : true,
							onCreate : showNotice("Loading, please wait..."),
							onComplete : function(response) {
								hideNotice();
								if (checkErrorOnResponse(response)) {
									objACGlobal.callingForm = "GIACS604";
									objACGlobal.callingForm2 = "GIACS604";
									//$("otherModuleDiv").update(response.responseText);
									//$("otherModuleDiv").show();
									$("mainContents").update(response.responseText);
									$("processDataPerBill").hide();
								}
							}
						});
					}
				}
			});
		}
		
		$("uploadingExit").observe("click", function() {
			exitGiacs604();
		});
		
		function exitGiacs604() {
			try {
				$("processDataPerBill").hide();
				objACGlobal.callingForm = "GIACS604";
				objACGlobal.callingForm2 = "GIACS604";
				if (objACGlobal.prevForm == "GIACS601") {
					objGIACS604.convertDate = object.convertDate;
					objGIACS604.sourceCd = object.sourceCd;
					objGIACS604.sourceName = object.dspSourceName;
					objGIACS604.remarks = object.remarks;
					objGIACS604.noOfRecords = object.noOfRecords;
					objGIACS604.totRecs = objUploading.totRecs;
					objGIACS604.fileNo = object.fileNo;
					$("mainNav").show();
					showConvertFile();
				} else {
					showGiacs602();
				}
				objACGlobal.prevForm = "";
			} catch (e){
				showErrorMessage("exitGiacs604 end", e);
			}
		}
		
		function showGiacs602(){
			try {
				new Ajax.Request(contextPath+"/GIACUploadingController",{
					parameters:{
						action: "showProcessDataListing",
						sourceCd : $("txtSourceCdGiacs604").value 
					},
					asynchronous: false,
					evalScripts: true,
					onCreate: function (){
						showNotice("Loading, please wait...");
					},
					onComplete: function (response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							objGIACS604.sourceCd = object.sourceCd;
							objGIACS604.sourceName = object.dspSourceName;
							hideAccountingMainMenus();
							$("mainContents").update(response.responseText);
						}
					}
				});
			} catch (e){
				showErrorMessage("showGiacs602", e);
			}
		}
		
		$("btnOrDate").observe("click", function() { 
			scwNextAction = validateOrDate.runsAfterSCW(this, null); 
			scwShow($("txtOrDate"),this, null); 
		});
		
		function validateOrDate(){
			changeTag = 1;
		}
</script>