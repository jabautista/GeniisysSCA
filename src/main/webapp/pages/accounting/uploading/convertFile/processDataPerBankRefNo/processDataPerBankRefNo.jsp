<div id="processDataPerBankRefNo" name="processDataPerBankRefNo">
	<!-- Deo [10.06.2016] start: added exit button -->
    <div id="toolbarGiacs610">
		<div id="toolbarDiv" name="toolbarDiv">	
			<div class="toolButton" style="float: right;">
				<span style="background: url(${pageContext.request.contextPath}/images/toolbar/exit.png) left center no-repeat;" id="uploadingExit">Exit</span>
				<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/exitDisabled.png) left center no-repeat;" id="btnToolbarExitDisabled">Exit</span>
			</div>
	 	</div>
	</div>
    <!-- Deo [10.06.2016] ends -->
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Process Data Per Bank Reference Number</label>
	   		<span class="refreshers" style="margin-top: 0;">
                <label id="reloadForm" name="reloadForm">Reload Form</label> <!-- Deo [10.06.2016] -->
            </span>
	   	</div>
	</div>
	<div class="sectionDiv" align="center" id="giacs610Header" style="padding-top: 10px; padding-bottom: 10px;">
		<table style="margin-top: 5px;">
			<tr>
				<td class="rightAligned">Batch No</td>
				<td class="leftAligned" colspan="2">
					<input id="txtFileNoGiacs610" type="text" class="" style="width: 186px;" tabindex="101" readonly="readonly">
				</td>
				<td class="rightAligned">File Name</td>
				<td class="leftAligned" colspan="2">
					<input id="txtFileNameGiacs610" type="text" class="" style="width: 186px;" tabindex="102" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Source</td>
				<td class="leftAligned" colspan="5">
					<input id="txtSourceCdGiacs610" type="text" class="" style="width: 100px;" tabindex="103" readonly="readonly">
					<input id="txtSourceNameGiacs610" type="text" class="" style="width: 468px;" tabindex="104" readonly="readonly"> <!-- Deo [10.06.2016]: changed width from 486 to 468 -->
				</td>
			</tr>		
			<tr>
				<!-- Deo [10.06.2016]: interchange tran date and deposit date -->
				<td class="rightAligned">Deposit Date</td>
				<td class="leftAligned">
					<input id="txtDepositDate" type="text" class="" style="width: 150px;" tabindex="105" readonly="readonly">
				</td>
				<td class="rightAligned">Tran Date</td>
				<td class="leftAligned">
					<input id="txtTranDateGiacs610" type="text" class="" style="width: 150px;" tabindex="105" readonly="readonly">
				</td>
				<td class="rightAligned">JV No</td>
				<td class="leftAligned">
					<input id="txtOrReqJvNoGiacs610" type="text" class="" style="width: 150px;" tabindex="106" readonly="readonly">
				</td>
			</tr>
			<!-- <tr> Deo [10.06.2016]: comment out, moved below
				<td colspan="6" align="center" style="padding-top: 20px;">
					<input type="button" class="button" id="btnPaymentDetails" value="Payment Details" tabindex="107">
				</td>
			</tr> -->				
		</table>
	</div>
	<div class="sectionDiv" id="processDataPerBankRefNoDiv">
		<div id="processDataPerBankRefNoTable" style="height: 331px; padding: 20px 100px 20px 100px;"></div>
		<table style="margin-top: 5px;" align="center">
			<th></th>
			<th></th>
			<th>Legend</th>
			<tr>
				<td class="rightAligned">OR No</td>
				<td class="leftAligned">
					<input id="txtOrNoGiacs610" type="text" class="" style="width: 200px;" tabindex="201" readonly="readonly">
				</td>
				<td class="leftAligned" rowspan="4">
				<div>
					<textarea class="required" readonly="readonly" style="float: left; height: 120px; width: 150px; margin-top: 0; resize: none;" id="txtLegend" name="txtLegend" maxlength="4000" onkeyup="limitText(this,4000);" tabindex="204"></textarea>
				</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Payor</td>
				<td class="leftAligned">
					<input id="txtPayorGiacs610" type="text" class="" style="width: 450px;" tabindex="201" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="rightAligned" valign="top" style="padding-top: 5px;">Checking Remarks</td> <!-- Deo [10.06.2016]: add valign and style -->
				<td class="leftAligned">
					<!-- <input id="txtCheckingRemarks" type="text" class="" style="width: 450px;" tabindex="202" readonly="readonly"> Deo [10.06.2016]: comment out-->
					<textarea id="txtCheckingRemarks" type="text" class="" style="width: 450px; float: left; resize: none;" tabindex="202" readonly="readonly"></textarea> <!-- Deo [10.06.2016]: to display multiline -->
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center" style="padding-top: 10px; padding-bottom: 10px;">
					<input type="button" class="button" id="btnForeignCurrency" value="Foreign Currency" tabindex="203" hidden="hidden">
				</td>
			</tr>				
		</table>
	</div>
	<div class="sectionDiv" align="center" id="giacs610Header" style="margin-bottom: 15px;">
		<table>
			<tr style="height: 50px;">
				<td id="hiddenRadioButtons">
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
				<!-- <td class="rightAligned" style="width: 60px"><label id="lblOrDate">Transaction Date</label></td>
				<td class="leftAligned" style="width: 170px">
					<input id="txtTransactionDate" type="text" class="" style="width: 150px;" tabindex="304" readonly="readonly"> Deo [10.06.2016]: comment out -->
				<!-- Deo [10.06.2016]: add start -->
				<td class="rightAligned"><label id="lblOrDate">Transaction Date</label></td>
				<td style="width: 175px">
					<div style="float: left; width: 150px;" class="withIconDiv required"; id="transactionDateDiv">
						<input type="text" id=txtTransactionDate class="withIcon date required" style="width: 125px;" readonly="readonly" tabindex="304"/>
						<img id="btnTransactionDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Transaction Date" tabindex="305"/>
					</div>
				</td>
				<td style="width: 200px; padding-left: 5px;">
					<input type="button" class="button" id="btnPaymentDetails" value="Payment Details" tabindex="306" style="width: 150px;">
				</td>
				<!-- Deo [10.06.2016]: add ends -->
				<td class="rightAligned">Upload Date</td>
				<td class="leftAligned">
					<input id="txtUploadDate" type="text" class="" style="width: 150px;" tabindex="307" readonly="readonly"> <!-- Deo [10.06.2016]: change tabindex from 305 to 307 -->
				</td>
			</tr>
		</table>
		<div align="center" style="padding: 10px 0 10px 0; border-top: 1px solid #E0E0E0;">
			<input type="button" class="button" id="btnCheckData" value="Check Data" tabindex="401" style="width: 150px; ">
			<input type="button" class="button" id="btnPrintReport" value="Print Report" tabindex="402" style="width: 150px;">
			<input type="button" class="button" id="btnUpload" value="Upload" tabindex="403" style="width: 150px;">
			<input type="button" class="button" id="btnPrintUpload" value="Print" tabindex="404" style="width: 150px;">
			<input type="button" class="button" id="btnCancelFile" value="Cancel File" tabindex="405" style="width: 150px;">
			<input type="hidden" id="orDateHid" name="orDateHid" style="width: 150px;"/> <!-- Deo [10.06.2016] -->
		</div>
	</div>
</div>
<div id="otherModuleDiv">
</div>

<script type="text/javascript">
	setModuleId("GIACS610");
	setDocumentTitle("Process Data Per Bank Reference Number");
	$("hiddenRadioButtons").hide();
	
	legend = JSON.parse('${giacs610Legend}');
	var legendString = "";
	for ( var i = 0; i < legend.rows.length; i++) {
		if (i == 0){
			legendString = legend.rows[i].legend;
		} else {
			legendString = legendString + "\n" +legend.rows[i].legend;
		}
	}
	
	$("txtLegend").value = legendString;
	
	guf = JSON.parse('${guf}');
	$("txtFileNoGiacs610").value = guf.fileNo;
	$("txtFileNameGiacs610").value = guf.fileName;
	$("txtSourceCdGiacs610").value = guf.sourceCd;
	$("txtSourceNameGiacs610").value = guf.dspSourceName;
	//$("txtTranDateGiacs610").value = dateFormat(guf.tranDate, "mm-dd-yyyy"); //Deo [10.06.2016] comment out
	$("txtTranDateGiacs610").value = (guf.tranDate == null ? "" : dateFormat(guf.tranDate, "mm-dd-yyyy")); //Deo [10.06.2016]: replacement, null should not be change to sysdate
	$("txtDepositDate").value = dateFormat(guf.paymentDate, "mm-dd-yyyy");
	$("txtOrReqJvNoGiacs610").value = guf.dspJvNo;
    
	legend = JSON.parse('${giacs610Legend}');
	var legendString = "";
	for ( var i = 0; i < legend.rows.length; i++) {
		if (i == 0){
			legendString = legend.rows[i].legend;
		} else {
			legendString = legendString + "\n" +legend.rows[i].legend;
		}
	}
	
	$("txtLegend").value = legendString;
	
	objGIACS610 = {};
	objGIACS610.giacs610RecList = JSON.parse('${gupr}');
	var rowIndex = -1;
	objCurrGiacs610 = null;
	variables = {};
	
	var giacs610Table = {
			url : contextPath + "/GIACUploadingController?action=showGiacs610RecList&refresh=1&fileNo="+guf.fileNo+"&sourceCd="+guf.sourceCd,
			//id: "1", //Deo [10.06.2016]: comment out to fix error in populating table grid records
			options : {
				width : '720px',
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrGiacs610 = tbgGiacs610Table.geniisysRows[y];
					setFieldValues(objCurrGiacs610);
					tbgGiacs610Table.keys.removeFocus(tbgGiacs610Table.keys._nCurrentFocus, true);
					tbgGiacs610Table.keys.releaseKeys();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgGiacs610Table.keys.removeFocus(tbgGiacs610Table.keys._nCurrentFocus, true);
					tbgGiacs610Table.keys.releaseKeys();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgGiacs610Table.keys.removeFocus(tbgGiacs610Table.keys._nCurrentFocus, true);
						tbgGiacs610Table.keys.releaseKeys();
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
					tbgGiacs610Table.keys.removeFocus(tbgGiacs610Table.keys._nCurrentFocus, true);
					tbgGiacs610Table.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgGiacs610Table.keys.removeFocus(tbgGiacs610Table.keys._nCurrentFocus, true);
					tbgGiacs610Table.keys.releaseKeys();
				},				
				prePager: function(){
					if(changeTag == 1){
						return false;
					}
					tbgGiacs610Table.keys.removeFocus(tbgGiacs610Table.keys._nCurrentFocus, true);
					tbgGiacs610Table.keys.releaseKeys();
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
					id : 'bankRefNo',
					filterOption : true,
					title : 'Bank Reference Number',
					align : "left",
					titleAlign: "left",
					width : '200px',
					filterOption : true,
				},
				{
					id : 'collectionAmt',
					filterOption : true,
					filterOptionType: 'number',
					title : 'Collection Amt',
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
					altTitle : 'Premium Check Flag', //Deo [10.06.2016]: add tooltip
					width : '20px'				
				},
				{
					id : 'premAmtDue',
					filterOption : true,
					title : 'Prem Amt Due',
					filterOptionType: 'number',
					align : "right",
					titleAlign: "right",
					width : '150px',
					renderer : function(value) {
				    	return formatCurrency(value);
				    }		
				},
				{
					id : 'commAmtDue',
					filterOption : true,
					title : 'Comm Amt Due',
					filterOptionType: 'number',
					align : "right",
					titleAlign: "right",
					width : '150px',
					renderer : function(value) {
				    	return formatCurrency(value);
				    }		
				},
				{
					id: 'uploadSw',
              		title : 'U', //Deo [10.06.2016]: change from ' ' to 'U'
              		altTitle : 'Upload Switch', //Deo [10.06.2016]: add tool tip
              		titleAlign : "right", //Deo [10.06.2016]
	              	width: '30px',
	              	sortable: false,
	              	editable: false,
	              	editor: new MyTableGrid.CellCheckbox({
		            	getValueOf : function(value) {
							if (value) {
								return "Y";
							} else {
								return "N";
							}
						}
	              	})
				},
			],
			rows : objGIACS610.giacs610RecList.rows
		};

		tbgGiacs610Table = new MyTableGrid(giacs610Table);
		tbgGiacs610Table.pager = objGIACS610.giacs610RecList;
		tbgGiacs610Table.render("processDataPerBankRefNoTable");
		
		//Deo [10.06.2016]: change font color to red
	    tbgGiacs610Table.afterRender = function() {
	        for (var i = 0; i < tbgGiacs610Table.geniisysRows.length; i++) {
	            if (tbgGiacs610Table.geniisysRows[i].validSw == "N") {
	                $('mtgRow' + tbgGiacs610Table._mtgId + '_' + i).style.color = "#FF6633";
	            }
	        }
	    };
	    //Deo [10.06.2016]: add ends
		
		function setFieldValues(rec){
			$("txtOrNoGiacs610").value = 		(rec == null ? "" : unescapeHTML2(rec.dspOrNo));
			$("txtPayorGiacs610").value = 		(rec == null ? "" : unescapeHTML2(rec.payor));
			$("txtCheckingRemarks").value = 	(rec == null ? "" : unescapeHTML2(rec.chkRemarks));
			/* $("txtTransactionDate").value = 	(rec == null ? "" : dateFormat(guf.tranDate, "mm-dd-yyyy"));
			$("txtUploadDate").value = 			(rec == null ? "" : dateFormat(guf.uploadDate, "mm-dd-yyyy")); */ //Deo [10.06.2016]: comment out
			if (guf.fileStatus != 1) { //Deo [10.06.2016]: add start
				$("txtTransactionDate").value = 	(rec == null ? "" : (rec.tranDate == null ? "" : dateFormat(rec.tranDate, "mm-dd-yyyy")));
		        $("txtUploadDate").value = 			(rec == null ? "" : rec.uploadDate);
			} //Deo [10.06.2016]: add ends
		}
		
		//$("btnPaymentDetails").observe("click", showPaymentDetails); //Deo [10.06.2016]: comment out
		
		function showPaymentDetails() {
			try {
				overlayPaymentDetails = Overlay.show(contextPath
						+ "/GIACUploadingController", {
					urlContent : true,
					urlParameters : {
						action : "showPaymentDetailsJVGiacs610",
						sourceCd : $("txtSourceCdGiacs610").value,
						fileNo : $("txtFileNoGiacs610").value,
						ajax : "1",
						},
					title : "JV Details", //Deo [10.06.2016]: change Payment to JV
					 height: 270,
					 width: 855,
					draggable : true
				});
				initSubPageProp(); //Deo [10.06.2016]
			} catch (e) {
				showErrorMessage("overlay error: ", e);
			}
		}
		
		$("btnCheckData").observe("click", checkData);
		
		$("btnPrintReport").observe("click", function(){
			showPrintDialog();
		});
		
		function checkData(){
			if(guf.tranClass != null){
				showMessageBox("This file has already been uploaded.", imgMessage.ERROR);
			} else {
				new Ajax.Request(contextPath+"/GIACUploadingController", {
					method: "POST",
					parameters : {action : "checkDataGiacs610",
								sourceCd : $("txtSourceCdGiacs610").value,
								fileNo : $("txtFileNoGiacs610").value
							 	  },
					onCreate : showNotice("Processing, please wait..."),
					onComplete: function(response){
						hideNotice();
						if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
							showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
								showGiacs610();
							});
						}
					}
				});
			}
		}
		
		function showGiacs610(){
			new Ajax.Updater("process", contextPath+"/GIACUploadingController",{
				parameters:{
					action: "showGiacs610",
					sourceCd : $("txtSourceCdGiacs610").value,
					fileNo : $("txtFileNoGiacs610").value
				},
				asynchronous: false,
				evalScripts: true, 
				onCreate: showNotice("Loading, please wait..."),
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)) {
						$("convertFileMainDiv").hide();
					}	
				}
			});
		}
		
		/* function showPrintDialog(){
			overlayPrintDialog = Overlay.show(contextPath+"/GIACUploadingController", {
				urlContent : true,
				urlParameters: {action : "showPrintDialog",
								},
			    title: "Print Report",
			    height: 210,
			    width: 380,
			    draggable: true,
			});
		} */ //Deo [10.06.2016]: comment out
		
		$("btnCancelFile").observe("click", function(){
			if(guf.fileStatus != 1){
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
				parameters : {action : "cancelFileGiacs610", //Deo [10.06.2016]: replace cancelFileGiacs603 with cancelFileGiacs610
							sourceCd : guf.sourceCd,
							fileNo : guf.fileNo
						 	  },
				onCreate : showNotice("Processing, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
							/* disableButton("btnUpload");
							disableButton("btnPrintUpload");
							disableButton("btnCancelFile");
							disableButton("btnPaymentDetails"); */ //Deo [10.06.2016]: comment out
							guf.fileStatus = "C";  //Deo [10.06.2016]
							initProp(); //Deo [10.06.2016]
						});
					}
				}
			});
		}
		
		$("btnPrintUpload").observe("click", function(){
			if(guf.tranClass == "" || guf.tranClass == null){
				showMessageBox("This file has not been uploaded yet.", "E");
			} else {
				tbgGiacs610Table.onRemoveRowFocus();
				validatePrintOr();
			}
		});
		
		function validatePrintOr(){
			new Ajax.Request(contextPath+"/GIACUploadingController", {
				method: "POST",
				asynchronous: true,
				parameters : {action : "giacs610ValidatePrintOr", //Deo [10.06.2016]: replace validatePrintOr with giacs610ValidatePrintOr
							sourceCd : guf.sourceCd,
							fileNo : guf.fileNo,
						 	  },
				onCreate : showNotice("Processing, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
						var obj = JSON.parse(response.responseText);
						objACGlobal.callingForm2 = "GIACS610";
						objGIACS610.fundCd = unescapeHTML2(obj.vFundCd);
						objGIACS610.fundDesc = unescapeHTML2(obj.vFundDesc);
						objGIACS610.branchCd = unescapeHTML2(obj.vBranchCd);
						objGIACS610.branchName = unescapeHTML2(obj.vBranchName);
						objGIACS610.gaccTranId = /* obj.vTranId */unescapeHTML2(obj.uploadQuery); //Deo [10.06.2016]: replace source
						objGIACS610.sourceCd = guf.sourceCd; //Deo [10.06.2016]
                        objGIACS610.fileNo = guf.fileNo; //Deo [10.06.2016]

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
									/* $("otherModuleDiv").update(response.responseText);
									$("otherModuleDiv").show(); */ //Deo [10.06.2016]: comment out
									$("mainContents").update(response.responseText); //Deo [10.06.2016]
									$("processDataPerBankRefNo").hide();
								}
							}
						});
					}
				}
			});
		}
		
		$("btnUpload").observe("click", function(){
			//checkValidated(); //Deo [10.06.2016]: comment out
			//Deo [10.06.2016]: add start
			if ($("txtTransactionDate").value == "") {
				showMessageBox("Please enter O.R. date first.", "I");
			} else {
				validateUploadTranDate(1);
			}
			//Deo [10.06.2016]: add ends
		});
		
		function checkValidated(){
			new Ajax.Request(contextPath+"/GIACUploadingController", {
				method: "POST",
				parameters : {action : "checkValidatedGiacs610",
								sourceCd : guf.sourceCd,
								fileNo : guf.fileNo
						 	  },
				onCreate : showNotice("Processing, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
						/* if (response.responseText.include("UPLOAD_LIST")){
	                        alert();
	                    } else { */
							var arrMessage = response.responseText.split("#");
							message = "A JV transaction will be created for " + arrMessage[1] + " branch. The indicated date in the JV Details will be used for the transaction. Do you wish to proceed?";
							showConfirmBox2("Confirmation", message , "Yes", "No", function(){
								//objGIACS610.branchCd = arrMessage[1]; //Deo [10.06.2016]: comment out
								objGIACS610.branchCd = arrMessage[3].trim(); //Deo [10.06.2016]: fix no default bank acct displayed
								showBankAcctWindow(objGIACS610.branchCd);
							}, null);	
						//}
					}
				}
			});
		}
		
		function showBankAcctWindow(branchCd){
			try {
				overlayBank = Overlay.show(contextPath
						+ "/GIACUploadingController", {
					urlContent : true,
					urlParameters : {
						action : "showGiacs610DefaultBank",
						branchCd: branchCd,
						processAll : "Y", //Deo [10.06.2016]
						ajax : "1"
						},
					title : "Bank Account Details", //Deo [10.06.2016]: add Bank Account to title
					 height: 170,
					 width: 458,
					draggable : true
				});   
			} catch (e) {
				showErrorMessage("showBankAcctWindow", e);
			}
		}
		
		/* $("acExit").stopObserving();
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
		}); */ //Deo [10.06.2016]: comment out
	
	//Deo [10.06.2016]: add start
	initProp();
	
	$("uploadingExit").observe("click", function() {
		exitGiacs610();
	});

	$("reloadForm").observe("click", function() {
		showGiacs610();
	});
	
	$("btnTransactionDate").observe("click", function() {
		scwNextAction = validateUploadTranDate.runsAfterSCW(this, null);
		scwShow($("txtTransactionDate"),this, null);
	});
	
	$("txtTransactionDate").observe("keyup", function(event){
		if(event.keyCode == 46){
			$("txtTransactionDate").value = "";
		}
	});
	
	$("btnPaymentDetails").observe("click", function(){
		if (guf.fileStatus == "1" && $F("txtTransactionDate") == "") {
			showMessageBox("Please enter O.R. date first.", "I");
		} else {
			showPaymentDetails();
		}
	});
	
	function initProp() {
		if (guf.fileStatus != "1") {
			disableButton("btnCheckData");
			disableButton("btnUpload");
			disableButton("btnCancelFile");
			$("txtTransactionDate").removeClassName("required");
		    $("transactionDateDiv").removeClassName("required");
		    disableDate("btnTransactionDate");
		    $("txtTransactionDate").disable();
		    $("transactionDateDiv").style.backgroundColor = "#d4d0c8";
		} 
		if (guf.fileStatus == "C") {
			disableButton("btnPrintUpload");
			$("txtTransactionDate").value = "";
		}
	}
	
	function initSubPageProp() {
		if (guf.fileStatus != "1") {
            $("txtBranchCd").disable();
            $("txtTranDate").disable();
            $("txtTranYy").disable();
            $("txtTranMm").disable();
            $("txtParticulars").disable();
            $("particularsDiv").disabled = true;
            $("txtBranchCd").removeClassName("required");
            $("branchCdSpan").removeClassName("required");
            $("txtTranDate").removeClassName("required");
            $("tranDateDiv").removeClassName("required");
            $("txtTranYy").removeClassName("required");
            $("txtTranMm").removeClassName("required");
            $("particularsDiv").removeClassName("required");
            $("txtParticulars").removeClassName("required");
            $("txtParticulars").writeAttribute("readonly");
            disableSearch("btnBranchCd");
            disableDate("btnTranDate");
            disableButton("btnSave");
            disableButton("btnDelete");
            $("branchCdSpan").style.backgroundColor = "#d4d0c8";
            $("tranDateDiv").style.backgroundColor = "#d4d0c8";
            $("particularsDiv").style.backgroundColor = "#d4d0c8";
        } else {
        	$("tranDateHid").value = $F("orDateHid");
        }
	}

	function showUploadList() {
		try {
			overlayUploadList = Overlay.show(contextPath
					+ "/GIACUploadingController", {
				urlContent : true,
				urlParameters : {
					action : "showUploadList",
					sourceCd : $("txtSourceCdGiacs610").value,
					fileNo : $("txtFileNoGiacs610").value,
					ajax : "1",
				},
				title : "Upload List",
				height : 375,
				width : 700,
				draggable : true
			});
		} catch (e) {
			showErrorMessage("showUploadList", e);
		}
	}

	function preUploadCheck() {
		try {
			new Ajax.Request(contextPath + "/GIACUploadingController", {
				method : "POST",
				parameters : {
					action : "preUploadCheck",
					sourceCd : guf.sourceCd,
					fileNo : guf.fileNo
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response) {
					hideNotice();
					if (checkCustomErrorOnResponse(response)
							&& checkErrorOnResponse(response)) {
						if (response.responseText.include("UPLOAD_LIST")) {
							tbgGiacs610Table.onRemoveRowFocus();
							showUploadList();
						} else {
							checkValidated();
						}
					}
				}
			});
		} catch (e) {
			showErrorMessage("preUploadCheck", e);
		}
	}
	
	function validateUploadTranDate(btn) {
		try {
			new Ajax.Request(
					contextPath + "/GIACUploadingController",
					{
						method : "POST",
						parameters : {
							action : "validateUploadTranDate",
							tranDate : $F("txtTransactionDate"),
							sourceCd : guf.sourceCd,
							fileNo : guf.fileNo
						},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response) {
							hideNotice();
							if (checkErrorOnResponse(response)) {
								if (response.responseText.include("Geniisys Exception")) {
									var message = response.responseText.split("#");
									showWaitingMessageBox(message[2], message[1],
											function() {
												$("txtTransactionDate").focus();
											});
									$("orDateHid").value = "";
								} else {
									$("orDateHid").value = $F("txtTransactionDate");
									if (btn == 1) {
										if (response.responseText.include("Unequal Date")) {
											showPaymentDetails();
										} else {
											preUploadCheck();
										}
									} 
								}
							}
						}
					});
		} catch (e) {
			showErrorMessage("validateUploadTranDate", e);
		}
	}
	
	function exitGiacs610() {
		try {
			$("processDataPerBankRefNo").hide();
			objACGlobal.callingForm = "GIACS610";
			if (objACGlobal.prevForm == "GIACS601") {
				objGIACS610.convertDate = guf.convertDate;
				objGIACS610.sourceCd = guf.sourceCd;
				objGIACS610.sourceName = guf.dspSourceName;
				objGIACS610.remarks = guf.remarks;
				objGIACS610.noOfRecords = guf.noOfRecords;
				objGIACS610.totRecs = objUploading.totRecs;
				objGIACS610.fileNo = guf.fileNo;
				$("mainNav").show();
				showConvertFile();
			} else {
				showGiacs602();
			}
			objACGlobal.prevForm = "";
			objACGlobal.callingForm2 = "";
		} catch (e){
			showErrorMessage("exitGiacs610", e);
		}
	}
	
	function showGiacs602(){
		try {
			new Ajax.Request(contextPath+"/GIACUploadingController",{
				parameters:{
					action: "showProcessDataListing",
					sourceCd : $("txtSourceCdGiacs610").value
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function (){
					showNotice("Loading, please wait...");
				},
				onComplete: function (response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						objGIACS610.sourceCd = guf.sourceCd;
						objGIACS610.sourceName = guf.dspSourceName;
						hideAccountingMainMenus();
						$("mainContents").update(response.responseText);
					}
				}
			});
		} catch (e){
			showErrorMessage("showGiacs602", e);
		}
	}
	
	function showPrintDialog() {
		try {
			overlayGenericPrintDialog = Overlay.show(contextPath+"/GIISController", {
				urlContent : true,
				urlParameters: {
					action : "showGenericPrintDialog",
					showFileOption : true
				},
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
		} catch (e) {
			showErrorMessage("showPrintDialog", e);
		}
	}
	
	function printReport() {
		try {
			if (!$("converted").checked && !$("uploaded").checked) {
				showMessageBox("Please select type of report.", "I");
				return false;
			}
			var content = contextPath+"/UploadingReportPrintController?action=printReport&sourceCd="+guf.sourceCd+
									"&fileName="+guf.fileNo+"&transactionCd=5&printerName="+$F("selPrinter");							
			var repDateParam = "";
			var reports = [];
			
			if ($("converted").checked) {
				repDateParam = guf.convertDate == "" || guf.convertDate == null ? "" : dateFormat(Date.parse(guf.convertDate), "mm-dd-yyyy");
				reportId = "GIACR601";
				reports.push({reportUrl : content+"&reportId="+reportId+"&fromDate="+repDateParam+"&toDate="+repDateParam,
							  reportTitle : reportId});
			}
			
			if ($("uploaded").checked) {
				repDateParam = guf.uploadDate == "" || guf.uploadDate == null ? "" : dateFormat(Date.parse(guf.uploadDate), "mm-dd-yyyy");
				reportId = "GIACR602";
				reports.push({reportUrl : content+"&reportId="+reportId+"&fromDate="+repDateParam+"&toDate="+repDateParam,
					  reportTitle : reportId});
			}

			if ("screen" == $F("selDestination")) {
				showMultiPdfReport(reports);
				reports = [];
			} else if ($F("selDestination") == "printer") {
				for (var i = 0; i < reports.length; i++) {
					new Ajax.Request(reports[i].reportUrl, {
						asynchronous : false,
						parameters : {
							noOfCopies : $F("txtNoOfCopies")
						},
						onCreate: showNotice("Processing, please wait..."),				
						onComplete: function(response) {
							hideNotice();
							if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)) {
								if (response.responseText == "SUCCESS") {
									if (i == reports.length-1) {
										showWaitingMessageBox("Printing complete.", imgMessage.SUCCESS, function(){
											overlayGenericPrintDialog.close();
										});
									}
								} else {
									showMessageBox(response.responseText, imgMessage.INFO)
								}			
							}
						}
					});
				}
			} else if ("file" == $F("selDestination")) {
				for (var i = 0; i < reports.length; i++) {
					new Ajax.Request(reports[i].reportUrl, {
						parameters : {
							destination : "FILE"
						},
						onCreate: showNotice("Generating report, please wait..."),
						onComplete: function(response) {
							hideNotice();
							if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)) {
								if (response.responseText == "SUCCESS") {
									copyFileToLocal(response);
									if (i == reports.length-1) {
										showWaitingMessageBox("Printing complete.", imgMessage.SUCCESS, function(){
											overlayGenericPrintDialog.close();
										});
									}
								} else {
									showMessageBox(response.responseText, imgMessage.INFO)
								}
							}
						}
					});
				}
			} else if ("local" == $F("selDestination")) {
				for (var i = 0; i < reports.length; i++) {
					new Ajax.Request(reports[i].reportUrl, {
						asynchronous : false,
						parameters : {
							destination : "LOCAL"
						},
						onComplete: function(response) {
							hideNotice();
							if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)) {
								var result = printToLocalPrinter(response.responseText);
								if (result){
									if (i == reports.length-1){
										showWaitingMessageBox("Printing complete.", imgMessage.SUCCESS, function(){
											overlayGenericPrintDialog.close();
										});
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
	
	function addPrintForm(){
		try{ 
			var content = "<table border='0' style='margin: auto; margin-top: 10px; margin-bottom: 10px;'>" +
							"<tr><td><input type='checkbox' id='converted' name='converted' style='float: left; margin-bottom: 3px;'><label style='margin: 2px 60px 0 4px;' for='converted'>Converted</label></td>"+
						  	"<td><input type='checkbox' id='uploaded' name='uploaded' style='float: left; padding-bottom: 3px; margin: 0 4px 3px 0;'><label for='uploaded'>Uploaded</label></td></tr>";
			$("printDialogFormDiv3").update(content); 
			$("printDialogFormDiv3").show();
			enableButton("btnPrint");
			
			$("converted").checked = true;
			
			$("uploaded").observe("click", function(){
				if (this.checked && nvl(guf.uploadDate, "*") == "*"){
					showMessageBox("This file has not been uploaded yet.", "I");
					$("uploaded").checked = false;
				}
			});
		}catch(e){
			showErrorMessage("addPrintForm", e);	
		}
	}
	//Deo [10.06.2016]: add ends
</script>