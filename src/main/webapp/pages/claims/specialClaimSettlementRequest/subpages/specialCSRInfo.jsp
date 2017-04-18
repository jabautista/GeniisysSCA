<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<input type="hidden" value="${isEdit }" id="isEdit" name="isEdit" />
<input type="hidden" value="${overrideParameter}" id="overrideParameter"/>


<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
		<label>Special Claim Settlement Request</label>
		<span class="refreshers" style="margin-top: 0;">
			<label name="gro" style="margin-left: 5px;">Hide</label>
	 		<input type="hidden" id="lineCd" name="lineCd" value="${lineCd}"> 
	 		<label id="reloadForm1" name="reloadForm1">Reload Form</label>
		</span>
	</div>
</div>

<div id="specialCSRHeaderDiv" name="specialCSRHeaderDiv" class="sectionDiv">
	<input type="hidden" id="insertTag" name="insertTag" value=${insertTag} />
	<jsp:include page="/pages/claims/batchCsr/batchHeader.jsp"></jsp:include>
	<jsp:include page="/pages/claims/batchCsr/batchDetailHeader.jsp"></jsp:include>
	<jsp:include page="/pages/claims/specialClaimSettlementRequest/subpages/specialCSRAdviceListing.jsp"></jsp:include>
	<%-- <jsp:include page="/pages/claims/batchCsr/batchCsrDetail.jsp"></jsp:include> --%>
	<div align="center">
		<table>
			<tr>
				<td class="rightAligned">User Id</td>
				<td class="leftAligned">
					<input type="text" id="userId" name="userId" readonly="readonly" style="width: 100px;"/>
				</td>
				<td class="rightAligned" style="width: 100px;">Last Update</td>
				<td class="leftAligned">
					<input type="text" id="lastUpdate" name="lastUpdate" readonly="readonly" style="width: 150px;"/>
				</td>
			</tr>
		</table>
	</div>
	<div id="batchCsrButtonsDiv" name="batchCsrButtonsDiv" align="center" style="margin: 10px; padding-bottom: 10px; margin-bottom: 50px;">
		<input type="button" class="disabledButton" style="width: 100px;" id="btnGenerateAE" name="btnGenerateAE" 	value="Generate A.E."/>
		<input type="button" class="disabledButton" style="width: 100px;" id="btnCancelBatch" 	name="btnCancelBatch" 		value="Cancel Batch"/>
		<input type="button" class="disabledButton" style="width: 120px;" id="btnAccountingEntries" 	name="btnAccountingEntries" 		value="Accounting Entries"/>
		<input type="button" class="disabledButton" style="width: 100px;" id="btnPrintCSR" 	name="btnPrintCSR" 		value="Print CSR"/><!-- changed Print SCR to Print CSR reymon 05102013 -->
		<input type="button" class="button" style="width: 100px;" id="btnReturn" 		name="btnReturn" 			value="Return"/>
	</div>
</div>

<script>
	setModuleId("GIACS086");
	setDocumentTitle("Special Claim Settlement Request");
	initializeAll();
	initializeAllMoneyFields();
	//disableButton("btnGenerateAE");
	var selectedAdviceIndex = null;
	var mtgIdA = null;
	var mtgIdB = null;
	var originalURL = "";
	var objAdviceRow = {};
	var objTemp = {};
	objectSelectedAdviceRows = [];
	
	var filteredByAdvice = "N";
	specialCSR.isInfo = 'Y'; //added by robert 10.24.2013
	
	changeTag = 0; //added by MAC 12/12/2013
	
	if($F("isEdit")== "Y"){
		adviceTGurl = "&batchDvId="+objGICLBatchDv.batchDvId+"&payeeClassCd="+objGICLBatchDv.payeeClassCd+"&payeeCd="+objGICLBatchDv.payeeCd+"&moduleId=GIACS086";
		enableButton("btnCancelBatch");
		enableButton("btnAccountingEntries");
		enableButton("btnPrintCSR");
		$("btnPayeeClass").hide();
		$("btnPayee").hide();
		
		/* $("btnParticulars").observe("click" , function(){
			showEditor("particulars", 2000,"true");
		});
		$("btnPayeeRemarks").observe("click" , function(){
			showEditor("payeeRemarks", 500,"true"); //changed from 2000 to 500 by robert 10.24.2013
		});  comment-out by steven 04.22.2014*/
		$("particulars").setAttribute("readonly", "readonly");
		$("payeeRemarks").setAttribute("readonly", "readonly");
	}else{
		objGICLBatchDv = {};
		adviceTGurl = "";
		$("btnPayee").observe("click", function(){
			if(nvl($F("payeeClass"), "") == ""){
				showMessageBox("Please enter payee class first.");
			}else{
				getGiisPayeesList($("payeeClass").getAttribute("payeeClassCd") , 'GIACS086');			
			}
		});
		
		$("btnPayeeClass").observe("click", function(){
			showClmPayeeClassLov2("GIACS086");
		});
		
		/* $("btnParticulars").observe("click" , function(){
			showEditor("particulars", 2000); // ""
		});
		$("btnPayeeRemarks").observe("click" , function(){
			showEditor("payeeRemarks", 500); //changned from 2000 to 500 by robert 10.24.2013
		}); comment-out by steven 04.22.2014*/
	}

	//added by steven 04.22.2014; adjusted the particulars from 2000 to 1000
	$("btnParticulars").observe("click" , function(){
		showOverlayEditor("particulars", 1000, $("particulars").hasAttribute("readonly")); 
	});
	$("btnPayeeRemarks").observe("click" , function(){
		showOverlayEditor("payeeRemarks", 500, $("payeeRemarks").hasAttribute("readonly")); 
	});
	
	var objAdviceTG = JSON.parse('${adviceListingTG}'.replace(/\\/g, '\\\\'));
	try{	
		var adviceTable = {
				url: contextPath+"/GIACBatchDVController?action=getSpecialCSRInfo&refresh=1&moduleId=GIACS086&isEdit="+$F("isEdit")+"&claimId="+nvl(objCLMGlobal.claimId,"")+adviceTGurl,
				options: {
					title: '',
					onCellFocus: function(element, value, x, y, id) {
						selectedAdviceIndex = y;
						objAdviceRow = adviceGrid.getRow(y);
						objTemp = adviceGrid.getRow(y);
						
					},onRemoveRowFocus : function(element, value, x, y, id){
						selectedAdviceIndex = null;
						objAdviceRow = null;
						objTemp = null;
				  	}, 
				  	toolbar: {
						elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
						onAdd: function(){
							adviceGrid.keys.releaseKeys();
						},
						//added to disallow reloading of Advice Tablegrid with Filter when an advice is tagged by MAC 11/12/2013.
						onFilter: function(){
							filteredByAdvice = "Y";
						}
					},onRefresh : function(){

					}
				}, columnModel : [ 
					{   
						id: 'recordStatus',
					    width: '0',
					    visible: false,
					    editor: 'checkbox' 			
					},
					{	
						id: 'divCtrId',
						width: '0',
						visible: false
					},{	id:'generateSw',
						sortable:	false,
						align:		'left',
						title:		'&#160;G',
						width:		'19px',
						editable:  true,
						hideSelectAllBox : true,
						editor: new MyTableGrid.CellCheckbox({
							getValueOf: function(value){
			            		if (value){
									return "Y";
			            		}else{
									return "N";	
			            		}	
			            	},
			            	onClick: function(value, checked) {
			            		if($F("isEdit")== "N"){
			            			if(value == "Y"){
			            				//marco - 03.25.2014 - added block below
			            				if($F("particulars") == ""){
			    							showMessageBox("Please insert Particulars before tagging this item.", "I");
			    							$("mtgInput"+mtgIdA+"_2,"+selectedAdviceIndex).checked = false;
			    							return;
			    						}
			            				changeTag = 1; //set changeTag if an advice is tagged by MAC 12/12/2013.
			            				if( nvl(objGICLBatchDv.branchCd, "HO" ) != "HO" && objAdviceRow.issueCode == 'RI'){
					            			showMessageBox("You are not allowed to choose this settlement advice.", imgMessage.INFO);
					            			$("mtgInput"+mtgIdA+"_2,"+selectedAdviceIndex).checked = false;		
					            		}else{
					            			//put collection of advices in single function by MAC 12/11/2013.
					            			function collectAdvice(){
					            				objectSelectedAdviceRows.push(adviceGrid.getRow(selectedAdviceIndex));
						            			if(filteredByAdvice == "N"){
						            				adviceTGurl = "";
						            				filteredByAdvice = "Y";
							            			adviceTGurl = "&payeeClassCd=" + objAdviceRow.payeeClassCd +"&payeeCd="+objAdviceRow.payeeCd +"&condition=2";
							    					adviceGrid.url =  specialCSR.originalURL + adviceTGurl;
							    					adviceGrid._refreshList();	
						            			}
						            			populateTempBatchFields();
					            			}
					            			enableButton("btnGenerateAE");
					            			objCLMGlobal.issCd = objAdviceRow.issueCode; //added by steven 11.25.2014; so that when generating AE,it will have a value.
					            			//check first if advice is already on the list before getting its details by MAC 12/11/2013.
					            			if (objectSelectedAdviceRows.length == 0){
					            				collectAdvice();
					            			}else{
					            				var exists = "N";
					            				for ( var i = 0; i < objectSelectedAdviceRows.length; i++) {
					            					if(objectSelectedAdviceRows[i].adviceId == objTemp.adviceId){
					            						exists = "Y";
					            					}
												}
					            				if (exists == "N"){
					            					collectAdvice();
					            				}
					            			}
					            		}
			            				
			            			}else{
			            				for ( var i = 0; i < objectSelectedAdviceRows.length; i++) {
			            					if(objectSelectedAdviceRows[i].adviceId == objTemp.adviceId){
			            						objectSelectedAdviceRows.splice(i,1);
			            					}
										}
			            				if(objectSelectedAdviceRows.length == 0){
			            					changeTag = 0; //reset changeTag if no advice of the list by MAC 12/12/2013.
			            					filteredByAdvice = "N";
				            				disableButton("btnGenerateAE");
				            				
				            				adviceTGurl = "";
				            				adviceGrid.url = contextPath+"/GIACBatchDVController?action=getSpecialCSRInfo&refresh=1&moduleId=GIACS086&isEdit="+$F("isEdit")+adviceTGurl;
				            				adviceGrid._refreshList();	
			            				}
			            				populateTempBatchFields();
			            			}	
			            		}
		 			    	} 
			            })
					},{
						id: 'adviceNo',
						title: 'Advice Number',
					  	width: '120',
					  	filterOption: false
				 	},{
						id: 'claimNo',
						title: 'Claim Number',
					  	width: '150',
					  	filterOption: false//,
					  	//sortable: false
				 	},{
						id: 'policyNo',
						title: 'Policy Number',
					  	width: '150',
					  	filterOption: false
				 	},{
						id: 'assuredName',
						title: 'Assured Name',
					  	width: '150',
					  	filterOption: true
				 	},{
						id: 'dspClmStatDesc',
						title: 'Claim Status',
					  	width: '100',
					  	filterOption: true
				 	},{
						id: 'strLossDate',
						title: 'Loss Date',
					  	width: '100',
					  	filterOption: true
				 	},{
						id: 'dspLossCatDes',
						title: 'Loss Description',
					  	width: '150',
					  	filterOption: true
				 	},{
						id: 'dspPayeeClass',
						title: 'Payee Class',
					  	width: '130',
					  	filterOption: true
				 	},{
						id: 'dspPayee',
						title: 'Payee Name',
					  	width: '150',
					  	filterOption: true
				 	},{
						id: 'dspPaidAmt',
						title: 'Paid Amount',
					  	width: '100',
					  	filterOption: true,
					  	geniisysClass: 'money',
						align: 'right',
						titleAlign: 'right'
				 	},{
						id: 'dspCurrency',
						title: 'Currency',
					  	width: '100',
					  	filterOption: true
				 	},{
						id: 'convertRate',
						title: 'Convert Rate',
					  	width: '100',
					  	filterOption: true,
					  	geniisysClass: 'rate',
						align: 'right',
						titleAlign: 'right'
				 	},{
				 		id: 'issueCode',
				 		title: 'Issue Code',
				 		filterOption: true,
				 		visible: false
				 	},{
				 		id: 'dspPaidFcurrAmt',
				 		title: '',
				 		visible: false
				 	},{
				 		id: 'payeeCd',
				 		title: '',
				 		visible: false,
				 		width: '0'
				 	},{
				 		id: 'payeeClassCd',
				 		title: '',
				 		visible: false,
				 		width: '0'
				 	},{
				 		id: 'batchDvId',
				 		title: '',
				 		visible: false,
				 		width: '0'
				 	},{
				 		id: 'adviceSequenceNumber',
				 		title: '',
				 		visible: false,
				 		width: '0'
				 	},{
				 		id: 'payeeRemarks',
				 		title: '',
				 		visible: false,
				 		width: '0'
				 	},{
				 		id: 'currencyCode',
				 		title: '',
				 		visible: false,
				 		width: '0'
				 	},{
				 		id: 'claimId',
				 		title: '',
				 		visible: false,
				 		width: '0'
				 	},{
				 		id: 'clmLossId',
				 		title: '',
				 		visible: false,
				 		width: '0'
				 	},{
				 		id: 'adviceId',
				 		title: '',
				 		visible: false,
				 		width: '0'
				 	},{
				 		id: 'convRt',
				 		title: '',
				 		visible: false,
				 		width: '0'
				 	},{
				 		id: 'netAmt',
				 		title: '',
				 		visible: false,
				 		width: '0'
				 	},{
				 		id: 'paidAmt',
				 		title: '',
				 		visible: false,
				 		width: '0'
				 	},{
				 		id: 'payeeType',
				 		title: '',
				 		visible: false,
				 		width: '0'
				 	},{
				 		id: 'lineCode',
				 		title: 'Line Code',
				 		filterOption: true,
				 		visible: false,
				 		width: '0'
				 	},{
				 		id: 'sublineCode',
				 		title: 'Subline Code',
				 		filterOption: true,
				 		visible: false,
				 		width: '0'
				 	},{
				 		id: 'adviceYear',
				 		title: 'Advice Year',
				 		filterOption: true,
				 		visible: false,
				 		filterOptionType: 'integerNoNegative',
				 		width: '0'
				 	},{
				 		id: 'adviceSequenceNumber',
				 		title: 'Advice Sequence Number',
				 		filterOption: true,
				 		visible: false,
				 		filterOptionType: 'integerNoNegative',
				 		width: '0'
				 	}
				],
				//resetChangeTag: true, comment out to allow checking of changes by MAC 12/12/2013
				rows: objAdviceTG.rows	
		};
		
		
		
		adviceGrid = new MyTableGrid(adviceTable);
		adviceGrid.pager = objAdviceTG;
		adviceGrid.render('specialCSRAdviceTableGridSample');
		mtgIdA = adviceGrid._mtgId;
		adviceGrid.afterRender = function(){
			if($F("isEdit")== "Y"){
				for ( var i = 0; i <adviceGrid.rows.length; i++) {
					$("mtgInput"+mtgIdA+"_2,"+i).setAttribute("disabled", "disabled");
				}  
			}	
			
			if($F("isEdit")== "N" && filteredByAdvice == "Y"){
				for ( var i = 0; i <adviceGrid.rows.length; i++) {
					var row = adviceGrid.getRow(i);
					if(objTemp.adviceSequenceNumber == row.adviceSequenceNumber){
						$("mtgInput"+mtgIdA+"_2,"+i).checked = true;			            						
					}
				}
			}	
		};
		
		//originalURL = adviceGrid.url;
		specialCSR.originalURL = adviceGrid.url;
	}catch(e){
		showErrorMessage("advice listing",e);
	}
	
	//added by reymon 04292013
	//to store payee remarks
	$("payeeRemarks").observe("blur",function(){
		objNewBatchDV.payeeRemarks = escapeHTML2($F("payeeRemarks"));
	});

	function populateTempBatchFields(){
		try{ 
			if(objectSelectedAdviceRows.length > 0 ){
				$("payeeClass").value = unescapeHTML2(objectSelectedAdviceRows[0].dspPayeeClass);	
				$("payeeClass").setAttribute("payeeClassCd", objectSelectedAdviceRows[0].payeeClassCd);
				$("payee").value = unescapeHTML2(objectSelectedAdviceRows[0].dspPayee);	
				$("payee").setAttribute("payeeNo", objectSelectedAdviceRows[0].payeeCd);
				var totalPaidAmount = 0;
				var totalLocalAmount = 0;
				for ( var i = 0; i < objectSelectedAdviceRows.length; i++) {
					totalPaidAmount += parseFloat(objectSelectedAdviceRows[i].dspPaidFcurrAmt);
					totalLocalAmount += (parseFloat(objectSelectedAdviceRows[i].dspPaidAmt) * parseFloat(objectSelectedAdviceRows[i].convertRate));
					if($F("payeeRemarks") == null){
						$("payeeRemarks").value = unescapeHTML2(objectSelectedAdviceRows[i].payeeRemarks);
					}
					
				}
				$("paidAmount").value = formatCurrency(totalPaidAmount);
				$("localAmount").value = formatCurrency(totalLocalAmount);
				
				objNewBatchDV.payeeClassCd = objectSelectedAdviceRows[0].payeeClassCd;
				objNewBatchDV.payeeCd = objectSelectedAdviceRows[0].payeeCd;
				objNewBatchDV.particulars = escapeHTML2($F("particulars"));
				objNewBatchDV.payeeRemarks = escapeHTML2($F("payeeRemarks"));
				objNewBatchDV.payee= escapeHTML2($F("payee"));
				objNewBatchDV.totalFcurrAmt = totalPaidAmount;
				objNewBatchDV.totalPaidAmt = totalLocalAmount;
				objNewBatchDV.currencyCd = objectSelectedAdviceRows[0].currencyCode;
				objNewBatchDV.convertRate = objectSelectedAdviceRows[0].convertRate;
			}else{
				$("payeeClass").value = null;
				$("payeeClass").setAttribute("payeeClassCd", null);
				$("payee").value = null;	
				$("payee").setAttribute("payeeNo", null);
				$("payeeRemarks").value - "";
				$("paidAmount").value = "";
				$("localAmount").value = "";
				
				objNewBatchDV = {};
			}
			
		}catch(e){
			showErrorMessage("populateTempBatchFields",e);
		}
	}
	//observeReloadForm("reloadForm1",function(){ comment out by MAC 12/12/2013
	$("reloadForm1").observe("click", function(){ //check first if there are changes before reloading form by MAC 12/12/2013.
		if($F("isEdit")== "N"){
			if (changeTag == 1){
				showConfirmBox("Confirm","Reloading form will disregard all changes. Proceed?", "Yes", "No", function(){
					specialCSR.showSpecialCSRInfo($F("isEdit"));
					clearSCSR();}, ''
					);
			} else {
				clearSCSR();
			}
		}
	});
	
	
	$("btnReturn").observe("click",function(){
		if($("acExit") != null){
			showSpecialCSRListing("", objACGlobal.otherBranchCd, "N");
		} else {		
			fadeElement("specialCSRInfoDiv", .2, function(){
				$("specialCSRListingDiv").show();
				sCSRGrid._refreshList();
				specialCSR.isInfo = 'N'; //added by robert 11.04.2013
			});
		}
		//$("specialCSRInfoDiv").hide(); fade override check_user_override_function2
		
	});
	
	
	function showGenerateAE(){
		try{
		    generateAEOverlay = Overlay.show(contextPath+"/OverlayController", { 
								urlContent: true,
								urlParameters: {action : "showGenerateAE",
												payeeClass: $("payeeClass").value,
												payee: $("payee").value,
												ajax : "1"},
							    title: "Generate AE",
							    height: 150,
							    width: 540,
							    draggable: true
							});
		}catch(e){
			showErrorMessage("showGenerateAE",e);
		}
	}
	
	function cancelBatch(){
		try{
			new Ajax.Request(contextPath+"/GIACBatchDVController",{
				method: "POST",
				evalScripts: true,
				asynchronous: false,
				parameters: {
					action : "cancelGIACBatch",
					batchDvId: objGICLBatchDv.batchDvId,
					tranId: objGICLBatchDv.tranId
				},onComplete: function(response){
					if(checkErrorOnResponse(response)){
						if(response.responseText != "SUCCESS"){
							showMessageBox(response.responseText, imgMessage.ERROR);
						}else{
							//showMessageBox(response.responseText, imgMessage.SUCCESS); // replaced with appropriate message - Nica 12.03.2012
							showMessageBox("SCSR was successfully cancelled.", imgMessage.SUCCESS);
							//showSpecialCSRListing();
							fadeElement("specialCSRInfoDiv", .2, function(){
								$("specialCSRListingDiv").show();
								sCSRGrid._refreshList();
								specialCSR.isInfo = 'N'; //added by robert 11.04.2013
							});
						}
						//}						
					}
					
				}
			});
		}catch(e){
			showErrorMessage("cancelBatch",e);
		}
	}
	
	$("btnGenerateAE").observe("click", function (){
		if(validateUserFunc3(userId,'AC','GIACS086') || nvl($F("overrideParameter"), 'N') == "N"){
			showConfirmBox("Generate A.E.","Would you like to continue accounting entry generation?", "Yes", "No",
					showGenerateAE,""
			);
		}else{
			showConfirmBox("User Override.","User is not allowed to generate Accounting entries. Would you like to override?","Yes","No",function(){
				commonOverrideOkFunc = function(){
					showGenerateAE();
				};
				commonOverrideNotOkFunc = function(){
					showWaitingMessageBox("User is not allowed to generate accounting entries.", "E", 
							clearOverride);
					return false;
				};
				commonOverrideCancelFunc = function(){
					
				};
				objAC.funcCode = "AC";
				objACGlobal.calledForm = "GIACS086";
				getUserInfo();
			});
		} 
	});
	
	
	function checkIfFunctionExists(functionCode, modId) { //Added by Jerome Bautista 05.28.2015 SR 4225
		new Ajax.Request(contextPath+ "/GIACFunctionController", {
			parameters : {
				action : "checkFuncExists",
				moduleId : modId,
				funcCode : functionCode
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response) {
				if(checkErrorOnResponse(response)){
					result = response.responseText;
				if (result == "FALSE") {
					result = false;
				} else if (result == "TRUE") {
					result = true;
				}
			}
			}
		});
		return result;
	
	}
	
	$("btnCancelBatch").observe("click", function(){
	/* 	showConfirmBox("Cancel Batch","Cancellation of this batch will also cancel other related accounting records.", "Yes", "No",
				cancelBatch,""
		);
	});  Commented out and replaced by Jerome Bautista - (To validate if user is allowed to Cancel a SCSR) 05.28.2015 SR 4225   */ 
	if(validateUserFunc3(userId,'CR','GIACS086')){
		showConfirmBox("Cancel Batch","Cancellation of this batch will also cancel other related accounting records.", "Yes", "No",
				cancelBatch,""
		);
	}else{
		if(!checkIfFunctionExists('CR',37)){
			showMessageBox("Function GIACS086 does not exist. Please contact MIS for assistance.","E");
		}else{
			showConfirmBox("User Override.","User is not allowed to cancel a SCSR. Would you like to override?","Yes","No",function(){
				commonOverrideOkFunc = function(){
					cancelBatch();
				};
				commonOverrideNotOkFunc = function(){
					showWaitingMessageBox("User is not allowed to cancel a SCSR.", "E", 
							clearOverride);
					return false;
				};
				commonOverrideCancelFunc = function(){
					
				};
				objAC.funcCode = "CR";
				objACGlobal.calledForm = "GIACS086";
				getUserInfo();
			});
	} 
	} //Added by Jerome Bautista 05.28.2015	SR 4225 @lines 629 - 650
});
	$("btnAccountingEntries").observe("click", function(){
		showSpecialCsrAcctEntries();
		adviceGrid.keys.removeFocus(adviceGrid.keys._nCurrentFocus, true);
		adviceGrid.keys.releaseKeys();
	});
	
	function showSpecialCsrAcctEntries(){
		var contentDiv = new Element("div", {id : "modal_content_acctEntries"});
	    var contentHTML = '<div id="modal_content_acctEntries"></div>';
	    
	    winFCurr = Overlay.show(contentHTML, {
						id: 'modal_dialog_acctEntries',
						title: "Accounting Entries",
						width: 675,
						height: 600,
						draggable: true,
						closable: true
					});
	    
	    new Ajax.Updater("modal_content_acctEntries", contextPath+"/GIACBatchDVController?action=getGIACS086AcctTransTableGrid&ajax=1&batchDvId="+objGICLBatchDv.batchDvId, {
			evalScripts: true,
			asynchronous: false,
			onComplete: function (response) {			
				if (!checkErrorOnResponse(response)) {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	$("btnPrintCSR").observe("click", function(){
		overlayGenericPrintDialog = Overlay.show(contextPath+"/GIACBatchDVController", {
			urlContent : true,
			urlParameters: {action : "printCSR",
							adviceLength : adviceGrid.rows.length,
							lineCd : adviceGrid.getValueAt(adviceGrid.getColumnIndex('lineCode'), 0)
			},
		    title: "Special Claim Settlement Request",
		    height: 160,
		    width: 450,
		    draggable: true
		});
	});

	if($("acExit") != null){
	 	$("acExit").stopObserving("click");
		$("acExit").observe("click", function(){
			showSpecialCSRListing("", objACGlobal.otherBranchCd, "N");
		});
	}	
	
	//create function to set SCSR in its default by MAC 12/12/2013.
	function clearSCSR(){
		filteredByAdvice = "N";
		objectSelectedAdviceRows = [];
		disableButton("btnGenerateAE");
		populateTempBatchFields();
		adviceTGurl = "";
		adviceGrid.url = contextPath+"/GIACBatchDVController?action=getSpecialCSRInfo&refresh=1&moduleId=GIACS086&isEdit="+$F("isEdit")+adviceTGurl;
		adviceGrid._refreshList();
		changeTag = 0;
	}
	$("mtgRefreshBtn"+adviceGrid._mtgId).stopObserving();//added by steven 03.26.2014 adviceGrid._mtgId  //added by robert 02.21.2014
	//clear SCSR fields and tagged advices if Refresh button is clicked by MAC 12/11/2013.
	$("mtgRefreshBtn"+adviceGrid._mtgId).observe("click", function(){ //added by steven 03.26.2014 adviceGrid._mtgId
		//check first if there are changes before reloading form by MAC 12/12/2013.
		if($F("isEdit")== "N"){
			if (changeTag == 1){
				showConfirmBox("Confirm","Refreshing list will discard changes. Do you want to continue?", "Yes", "No", function(){
					clearSCSR();}, ''
					);
			} else {
				clearSCSR();
			}
		}
	});
</script>