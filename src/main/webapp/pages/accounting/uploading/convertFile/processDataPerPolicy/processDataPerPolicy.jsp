<div id="processDataPerPolicy" name="processDataPerPolicy">
	<div id="toolbarGiacs603">
		<div id="toolbarDiv" name="toolbarDiv">	
			<div class="toolButton" style="float: right;">
				<span style="background: url(${pageContext.request.contextPath}/images/toolbar/exit.png) left center no-repeat;" id="uploadingExit">Exit</span>
				<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/exitDisabled.png) left center no-repeat;" id="btnToolbarExitDisabled">Exit</span>
			</div>
	 	</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Process Data per Policy</label>
	   		<span class="refreshers" style="margin-top: 0;">
	   			<!-- nieko Accounting Uploading GIACS603, added reload form -->
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	<div class="sectionDiv" align="center" id="giacs603Header" style="padding-top: 10px; padding-bottom: 10px;">
		<table style="margin-top: 5px;">
			<tr>
				<td class="rightAligned">Batch No</td>
				<td class="leftAligned">
					<input id="txtFileNoGiacs603" type="text" class="" style="width: 200px;" tabindex="101" readonly="readonly">
				</td>
				<td class="rightAligned">File Name</td>
				<td class="leftAligned">
					<input id="txtFileNameGiacs603" type="text" class="" style="width: 200px;" tabindex="102" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Source</td>
				<td class="leftAligned" colspan="3">
					<input id="txtSourceCdGiacs603" type="text" class="" style="width: 100px;" tabindex="103" readonly="readonly">
					<input id="txtSourceNameGiacs603" type="text" class="" style="width: 389px;" tabindex="104" readonly="readonly">
				</td>
			</tr>		
			<tr>
				<td class="rightAligned">Tran Date</td>
				<td class="leftAligned">
					<input id="txtTranDateGiacs603" type="text" class="" style="width: 200px;" tabindex="105" readonly="readonly">
				</td>
				<td class="rightAligned">OR/Req/JV No</td>
				<td class="leftAligned">
					<input id="txtOrReqJvNoGiacs603" type="text" class="" style="width: 200px;" tabindex="106" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td colspan="4" align="center" style="padding-top: 20px;">
					<input type="button" class="button" id="btnPaymentDetails" value="Payment Details" tabindex="107">
				</td>
			</tr>				
		</table>
	</div>
	<div class="sectionDiv" id="processDatePerPolicyTableDiv">
		<div id="processDatePerPolicyTable" style="height: 331px; padding: 20px 100px 20px 100px;"></div>
		<table style="margin-top: 5px;" align="center">
			<th></th>
			<th></th>
			<th>Legend</th>
			<tr>
				<td class="rightAligned">Payor</td>
				<td class="leftAligned">
					<input id="txtPayorGiacs603" type="text" class="" style="width: 450px;" tabindex="201" readonly="readonly">
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
	<div class="sectionDiv" align="center" id="giacs603Header" style="margin-bottom: 15px;">
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
					<!-- <input id="txtOrDate" type="text" class="" style="width: 150px;" tabindex="304" readonly="readonly">  -->
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
	setModuleId("GIACS603");
	setDocumentTitle("Process Data per Policy");
	object = JSON.parse('${showGiacs603Head}');
	$("txtFileNoGiacs603").value = object.fileNo;
	$("txtFileNameGiacs603").value = object.fileName;
	$("txtSourceCdGiacs603").value = object.sourceCd;
	$("txtSourceNameGiacs603").value = object.dspSourceName;
	$("txtTranDateGiacs603").value = dateFormat(object.tranDate, "mm-dd-yyyy");
	$("txtOrReqJvNoGiacs603").value = object.dspOrReqJvNo;
	$("txtOrDate").value = object.tranDate == null ? dateFormat(object.nbtOrDate, "mm-dd-yyyy") : object.tranDate;
	$("txtUploadDate").value = dateFormat(object.uploadDate, "mm-dd-yyyy");
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
	
	objGIACS603 = {};
	objGIACS603.giacs603RecList = JSON.parse('${jsonGiacs603Table}');
	var rowIndex = -1;
	objCurrGiacs603 = null;
	variables = {};
	
	objGIACS603.tranClass = object.tranClass;
	objGIACS603.fileStatus = object.fileStatus;
	
	var giacs603Table = {
			url : contextPath + "/GIACUploadingController?action=showGiacs603RecList&refresh=1&fileNo="+object.fileNo+"&sourceCd="+object.sourceCd,
			//id: "1",		//nieko Accounting Uploading GIACS603
			options : {
				width : '720px',
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrGiacs603 = tbgGiacs603Table.geniisysRows[y];
					setFieldValues(objCurrGiacs603);
					tbgGiacs603Table.keys.removeFocus(tbgGiacs603Table.keys._nCurrentFocus, true);
					tbgGiacs603Table.keys.releaseKeys();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgGiacs603Table.keys.removeFocus(tbgGiacs603Table.keys._nCurrentFocus, true);
					tbgGiacs603Table.keys.releaseKeys();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgGiacs603Table.keys.removeFocus(tbgGiacs603Table.keys._nCurrentFocus, true);
						tbgGiacs603Table.keys.releaseKeys();
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
					tbgGiacs603Table.keys.removeFocus(tbgGiacs603Table.keys._nCurrentFocus, true);
					tbgGiacs603Table.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgGiacs603Table.keys.removeFocus(tbgGiacs603Table.keys._nCurrentFocus, true);
					tbgGiacs603Table.keys.releaseKeys();
				},				
				prePager: function(){
					if(changeTag == 1){
						return false;
					}
					tbgGiacs603Table.keys.removeFocus(tbgGiacs603Table.keys._nCurrentFocus, true);
					tbgGiacs603Table.keys.releaseKeys();
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
					id : 'policyNo',
					title : 'Policy No.',
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
					width : '200px',
					align : "left",
					titleAlign: "left"
				}
			],
			rows : objGIACS603.giacs603RecList.rows
		};
		
		tbgGiacs603Table = new MyTableGrid(giacs603Table);
		tbgGiacs603Table.pager = objGIACS603.giacs603RecList;
		tbgGiacs603Table.render("processDatePerPolicyTable");
		
		function setFieldValues(rec){
			$("txtPayorGiacs603").value = 		(rec == null ? "" : unescapeHTML2(rec.payor));
			$("txtPaymentDetails").value = 		(rec == null ? "" : unescapeHTML2(rec.dspPaymentDetails));
			rec == null ? disableButton("btnForeignCurrency") : enableButton("btnForeignCurrency");
		}
		
		$("btnPaymentDetails").observe("click", function(){
			if ($("rdoDV").checked == true){
				showPaymentDetails("showPaymentDetailsDV");
			} else {
				showPaymentDetails("showPaymentDetailsJV");
			}
		});
		
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
		
		function showPaymentDetails(action) {
			try {
				overlayPaymentDetails = Overlay.show(contextPath
						+ "/GIACUploadingController", {
					urlContent : true,
					urlParameters : {
						action : action,
						sourceCd : $("txtSourceCdGiacs603").value,
						fileNo : $("txtFileNoGiacs603").value,
						ajax : "1",
						},
					title : "Payment Details",
					 height: action == "showPaymentDetailsDV" ? 350 : 270,
					 width: 855,
					draggable : true
				});
			} catch (e) {
				showErrorMessage("overlay error: ", e);
			}
		}
		
		function showForeignCurrency() {
			try {
				overlayForeignCurrency = Overlay.show(contextPath
						+ "/GIACUploadingController", {
					urlContent : true,
					urlParameters : {
						action : "uploadingForeignCurrency",
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
		
		$("btnForeignCurrency").observe("click", function(){
			showForeignCurrency();
		});
		
		$("btnCheckData").observe("click", function(){
			checkData();
		});
		
		$("btnPrintReport").observe("click", function(){
			showPrintDialog();
		});
		
		function checkData(){
			if(object.tranClass != null){
				showMessageBox("This file has already been uploaded.", imgMessage.ERROR);
			} else {
				new Ajax.Request(contextPath+"/GIACUploadingController", {
					method: "POST",
					parameters : {action : "checkDataGiacs603",
								sourceCd : $("txtSourceCdGiacs603").value,
								fileNo : $("txtFileNoGiacs603").value
							 	  },
					onCreate : showNotice("Processing, please wait..."),
					onComplete: function(response){
						hideNotice();
						if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
							showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
								showGiacs603();
							});
						}
					}
				});
			}
		}
		
		function showGiacs603(){
			new Ajax.Updater("process", contextPath+"/GIACUploadingController",{
				parameters:{
					action: "showGiacs603",
					sourceCd : $("txtSourceCdGiacs603").value,
					fileNo : $("txtFileNoGiacs603").value
				},
				asynchronous: true,
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
		
		//nieko Accounting Uploading GIACS603, added reload form
		$("reloadForm").observe("click", showGiacs603);
		
		function showPrintDialog(){
			overlayPrintDialog = Overlay.show(contextPath+"/GIACUploadingController", {
				urlContent : true,
				urlParameters: {action : "showPrintDialog",
								},
			    title: "Print Report",
			    height: 210,
			    width: 380,
			    draggable: true,
			});
		}
		
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
				parameters : {action : "cancelFileGiacs603",
								sourceCd : $("txtSourceCdGiacs603").value,
								fileNo : $("txtFileNoGiacs603").value
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
		
		$("btnUpload").observe("click", function(){
			validateUpload();
		});
		
		function validateUpload(){
			new Ajax.Request(contextPath+"/GIACUploadingController", {
				method: "POST",
				parameters : {action : "validateUploadGiacs603",
							sourceCd : $("txtSourceCdGiacs603").value,
							fileNo : $("txtFileNoGiacs603").value
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
				        	objGIACS603.branchCd = unescapeHTML2(object.branchCd);   
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
						action : "showDefaultBank",
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
		
		function checkPaymentDetails(){
			new Ajax.Request(contextPath+"/GIACUploadingController", {
				method: "POST",
				parameters : {action : "checkPaymentDetails",
							sourceCd : $("txtSourceCdGiacs603").value,
							fileNo : $("txtFileNoGiacs603").value,
							tranClass : $("rdoDV").checked ? "DV" : $("rdoJV").checked ? "JV" : "COL"
						 	  },
				onCreate : showNotice("Processing, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
						var obj = JSON.parse(response.responseText);
						variables.dcbNo = obj.dcbNo;
						if (obj.exists == "Y"){
							if(hasCCFunction == "Y"){
								checkForOverride();
							} else {
								showConfirmBox("CONFIRMATION", "User is not allowed to disburse commission. Would you like to override?",
										"Yes", "No",
										function() {
											showGenericOverride("GIACS007", "CC",
													function(ovr, userId, res){
														if(res == "FALSE"){
															showMessageBox(userId + " is not allowed to process collections for policies with claim", imgMessage.ERROR);
															$("txtOverrideUserName").clear();
															$("txtOverridePassword").clear();
															return false;
														} else if(res == "TRUE"){
															checkForOverride();
															ovr.close();
															delete ovr;
														}
													},
													function() {
														$("txtOverrideUserName").clear();
														$("txtOverridePassword").clear();
													}
											);
										},
										function(){	// no for USER confirmation
											null;
										}
								);
							}
						} else {
							checkForOverride();
						}
					}
				}
			});
		}
		
		function checkForOverride(){
			new Ajax.Request(contextPath+"/GIACUploadingController", {
				method: "POST",
				parameters : {action : "giacs603CheckForOverride",
							fileNo : $F("txtFileNoGiacs603"),
							sourceCd : $F("txtSourceCdGiacs603")
						 	  },
				onCreate : showNotice("Processing, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
						var obj = JSON.parse(response.responseText);
						if (obj.exists == "Y"){
							if(hasAUFunction == "N"){
								showConfirmBox("CONFIRMATION", "User is not allowed to process invalid records. Would you like to override?",
										"Yes", "No",
										function() {
											showGenericOverride("GIACS603", "UA",
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
													function() {
														$("txtOverrideUserName").clear();
														$("txtOverridePassword").clear();
													}
											);
										},
										function(){	// no for USER confirmation
											null;
										}
								);
							} else {
								uploadPayments();
							}
						} else {
							uploadPayments();
						}
					}
				}
			});
		}
		
		function uploadPayments(){
			if($("rdoOR").checked){
				variables.tranClass = "COL";
			} else if($("rdoDV").checked){
				variables.tranClass = "DV";
			} else if($("rdoJV").checked){
				variables.tranClass = "JV";
			}
			proceedUploadPayments();
		}
		
		function proceedUploadPayments(){
			new Ajax.Request(contextPath+"/GIACUploadingController", {
				method: "GET",
				parameters : {action : "giacs603UploadPayments",
							branchCd : object.branchCd,
							sourceCd : $F("txtSourceCdGiacs603"),
							fileNo : $F("txtFileNoGiacs603"),
							dcbNo : variables.dcbNo,
							orDate : $F("txtOrDate"),
							paymentDate: object.paymentDate,
							tranClass : variables.tranClass
						 	  },
				onCreate : showNotice("Processing, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
						showGiacs603();
					}
				}
			});
		}
		
		$("btnPrintUpload").observe("click", function(){
			if(objGIACS603.tranClass == "" || objGIACS603.tranClass == null){
				showMessageBox("This file has not been uploaded yet.", "E");
			} else {
				tbgGiacs603Table.onRemoveRowFocus();
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
				parameters : {action : "validatePrintOr",
							sourceCd : $("txtSourceCdGiacs603").value,
							fileNo : $("txtFileNoGiacs603").value,
						 	  },
				onCreate : showNotice("Processing, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
						var obj = JSON.parse(response.responseText);
						objACGlobal.callingForm = "GIACS603";
						objACGlobal.callingForm2 = "GIACS603";
						objGIACS603.fundCd = unescapeHTML2(obj.vFundCd);
						objGIACS603.fundDesc = unescapeHTML2(obj.vFundDesc);
						objGIACS603.branchCd = unescapeHTML2(obj.vBranchCd);
						objGIACS603.branchName = unescapeHTML2(obj.vBranchName);
						objGIACS603.gaccTranId = obj.vTranId;
						
						objGIACS603.sourceCd = object.sourceCd;
						objGIACS603.fileNo = object.fileNo;
						
						//nieko Accounting Uploading GIACS603
						objGIACS603.uploadQuery = unescapeHTML2(obj.vUploadQuery);

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
									$("processDataPerPolicy").hide();									
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
				parameters : {action : "validatePrintDv",
							sourceCd : $("txtSourceCdGiacs603").value,
							fileNo : $("txtFileNoGiacs603").value,
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
						
						objGIACS603.sourceCd = object.sourceCd;
						objGIACS603.fileNo = object.fileNo;
						
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
									objACGlobal.callingForm = "GIACS603";
									objACGlobal.callingForm2 = "GIACS603";
									//$("otherModuleDiv").update(response.responseText);
									//$("otherModuleDiv").show();
									$("mainContents").update(response.responseText);
									$("processDataPerPolicy").hide();
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
				parameters : {action : "validatePrintJv",
							sourceCd : $("txtSourceCdGiacs603").value,
							fileNo : $("txtFileNoGiacs603").value,
						 	  },
				onCreate : showNotice("Processing, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
						var obj = JSON.parse(response.responseText);
						
						objGIACS603.sourceCd = object.sourceCd;
						objGIACS603.fileNo = object.fileNo;
						
						new Ajax.Request(contextPath + "/GIACJournalEntryController?action=showJournalEntries", {
							parameters : {
								action2 : "getJournalEntries",
								moduleId : "GIACS003",
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
									objACGlobal.callingForm = "GIACS603";
									objACGlobal.callingForm2 = "GIACS603";
									//$("otherModuleDiv").update(response.responseText);
									//$("otherModuleDiv").show();
									$("mainContents").update(response.responseText);
									$("processDataPerPolicy").hide();
								}
							}
						});
					}
				}
			});
		}
		
		//$("acExit").stopObserving();
		
		//nieko Accounting Uploading GIACS603, modify exit toolbar
		/* $("acExit").observe("click", function() {
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
		}); */
		
		$("uploadingExit").observe("click", function() {
			exitGiacs603();
		});
		
		function exitGiacs603() {
			try {
				$("processDataPerPolicy").hide();
				objACGlobal.callingForm = "GIACS603";
				objACGlobal.callingForm2 = "GIACS603";
				if (objACGlobal.prevForm == "GIACS601") {
					objGIACS603.convertDate = object.convertDate;
					objGIACS603.sourceCd = object.sourceCd;
					objGIACS603.sourceName = object.dspSourceName;
					objGIACS603.remarks = object.remarks;
					objGIACS603.noOfRecords = object.noOfRecords;
					objGIACS603.totRecs = objUploading.totRecs;
					objGIACS603.fileNo = object.fileNo;
					$("mainNav").show();
					showConvertFile();
				} else {
					showGiacs602();
				}
				objACGlobal.prevForm = "";
			} catch (e){
				showErrorMessage("exitGiacs603", e);
			}
		}
		
		function showGiacs602(){
			try {
				new Ajax.Request(contextPath+"/GIACUploadingController",{
					parameters:{
						action: "showProcessDataListing",
						sourceCd : $("txtSourceCdGiacs603").value 
					},
					asynchronous: false,
					evalScripts: true,
					onCreate: function (){
						showNotice("Loading, please wait...");
					},
					onComplete: function (response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							objGIACS603.sourceCd = object.sourceCd;
							objGIACS603.sourceName = object.dspSourceName;
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
