<div id="rfDetailDiv" style="padding: 10px;">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>RF Detail</label>
			<span class="refreshers" style="margin-top: 0;">
		 	<!-- 	<label id="reloadForm" name="reloadForm">Reload Form</label> -->
			</span>
		</div>
	</div>
	
	<div class="sectionDiv" >
		<div id="rfDetailTgDiv" style="height: 240px; "></div>
	</div>	
	
	<div class="sectionDiv"  style="padding-top: 5px; padding-bottom:5px; margin-top: 30px; margin-bottom:2px; " >
		<div  style="padding: 10px;  height: 80px;" changeTagAttr="true" >
			<table align="center">
				<tr>
					<td class="rightAligned" >DV No.:</td>  
					<td class="rightAligned" >
						<input style="width: 210px;   float: left;"  id="dspDvNo" name="dspDvNo" type="text" readonly="readonly"/>
					</td>
					<td class="rightAligned" >Check No.:</td> 
					<td class="leftAligned" >
						<input style="width: 210px;  float: left;" readonly="readonly" id="dspCheckNo" name="dspCheckNo" type="text" />
					</td>   
				</tr>
				<tr>
					<td class="rightAligned" >Payment Request No.:</td> 
					<td class="leftAligned" >
						<input style="width: 210px;  float: left;" readonly="readonly" id="dspPaymentRequestNo" name="dspPaymentRequestNo" type="text" />
					</td>   
					
					<td class="rightAligned" >Amount:</td> 
					<td class="leftAligned" >
						<input style="width: 210px;  float: left;" readonly="readonly" id="dspAmount" name="dspAmount" type="text" class="money2"/>
					</td>  
				</tr>		
				<tr >
					<td class="rightAligned" colspan="2" ><label style="margin-top: 3px; margin-left:280px;" class="rightAligned">Include Tag:</label></td>
					<td class="leftAligned" colspan="2">
						<input type="checkbox" id="includeTag" name="includeTag" disabled="disabled" style="margin-top: 5px;"/>
					</td>
				</tr>		
			</table>
		</div>
		
		<div style="text-align:center">
			<input type="button" class="button" id="btnUpdate" value="Update" style="width:100px;" title="Update" />
		</div>
		
		<div  style="padding: 10px;  height: 80px;" changeTagAttr="true" >
			<table align="center">
				<tr>
					<td class="rightAligned" >Payee:</td>  
					<td class="rightAligned" >
						<input style="width: 200px;   float: left;"  id="dspPayee" name="dspPayee" type="text" readonly="readonly"/>
					</td>
					<td class="rightAligned" >Total Requested Amount.:</td> 
					<td class="leftAligned" >
						<input style="width: 150px;  float: left;" readonly="readonly" id="dspRequestedAmt" name="dspRequestedAmt" type="text" class="money2"/>
					</td>   
				</tr>
				<tr>
					<td class="rightAligned" >Particulars:</td> 
					<td class="leftAligned" >
						<div style="float: left; width: 206px;" class="withIconDiv">
							<input type="text" onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" id="dspParticulars" name="dspParticulars" style="width: 180px;" class="withIcon" readonly="readonly" /> 
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="viewDspPaticulars" class="hover"/>
						</div>
					</td>   
					
					<td class="rightAligned" >Less: Disapproved:</td> 
					<td class="leftAligned" >
						<input style="width: 150px;  float: left;" readonly="readonly" id="dspDisapprovedAmt" name="dspDisapprovedAmt" type="text" class="money2"/>
					</td>  
				</tr>		
				<tr>
					<td></td>
					<td></td>
					<td class="rightAligned" >Total Approved Amount:</td> 
					<td class="leftAligned" >
						<input style="width: 150px;  float: left;" readonly="readonly" id="dspApprovedAmt" name="dspApprovedAmt" type="text" class="money2"/>
					</td>  
				</tr>
			</table>
		</div>
	</div>

	<div class="sectionDiv"  style="padding-top: 5px; padding-bottom:5px; margin-top: 30px; margin-bottom:10px; " >
		<div style="text-align:center">
			<input type="button" class="button" id="btnAccountingEntries" value="Accounting Entries" style="width:150px;" title="Accounting Entries"/>
			<input type="button" class="button" id="btnSummarizedEntries" value="Summarized Entries" style="width:150px;" title="Summarized Entries"/>
			<input type="button" class="button" id="btnRfPrint" value="Print" style="width:100px;" title="Print"/>
			<input type="button" class="button" id="btnSaveRf" value="Save" style="width:100px;" title="Save"/>
			<input type="button" class="button" id="btnReturnRf" value="Return" style="width:100px;" title="back to main"/>
		</div>
	</div>
</div>
<input id="replenishId" type="hidden" />
<script>

	var objRfDetail = new Object();
	var selectedIndex; 
	changeTag = 0;
	
	objRfDetail.objRfDetailTG = JSON.parse('${rfDetailJSON}'.replace(/\\/g, '\\\\'));
	objRfDetail.objRfAmounts = JSON.parse('${rfAmountsJSON}');
	objRfDetail.objRfDetailTGRows = objRfDetail.objRfDetailTG.rows || [];
	var objRfArr = JSON.parse('${rfDetailJSON}'.replace(/\\/g, '\\\\')).rows;
	
	$("dspRequestedAmt").value = formatCurrency(objRfDetail.objRfAmounts.dspRequestedAmt);
	$("dspDisapprovedAmt").value = formatCurrency(objRfDetail.objRfAmounts.dspDisapprovedAmt);
	$("dspApprovedAmt").value = formatCurrency(objRfDetail.objRfAmounts.dspApprovedAmt);
	
	try{
		var rfDetailTableModel= {
				id: 8,
				url: contextPath+"/GIACReplenishDvController?action=showRfDetailTG&refresh=1&replenishId="+$F("replenishId"),
				options: {
					hideColumnChildTitle: true,
					newRowPosition: 'bottom',
					prePager: function(){
						if(changeTag == 1){
							showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
							return false;
						} else {
							populateRfDetail(null);
							return true;
						}
					},beforeSort: function(){
						if(changeTag == 1){
							showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
							return false;
						} else {
							populateRfDetail(null);
							return true;
						}
					},
					onCellFocus: function(element, value, x, y, id) {
						if (y >= 0){
							selectedIndex = y;
							objRfDetail.selectedObj = rfDetailGrid.geniisysRows[y] ;
							populateRfDetail(objRfDetail.selectedObj); 
							enableButton("btnAccountingEntries");
						}						
						rfDetailGrid.keys.releaseKeys();
					},onRemoveRowFocus : function(){
						selectedIndex = null;
						rfDetailGrid.releaseKeys();
						populateRfDetail(null);
						objRfDetail.selectedObj = null;
						disableButton("btnAccountingEntries");
				  	},toolbar: {
						elements: [MyTableGrid.FILTER_BTN , MyTableGrid.REFRESH_BTN],// removed filter for now
						onRefresh: function (){
					
						}
					}
				},columnModel : [
					{   
						id: 'recordStatus',
					    width: '0px',
					    visible: false,
					    editor: 'checkbox' 			
					},
					{	
						id: 'divCtrId',
						width: '0px',
						visible: false
					},
					{	id:			'dspIncludeTag',
						sortable:	false,
						align:		'center',
						title:		'&#160;&#160;I',
						tooltip:	'Include Tag',
						altTitle:   'Include Tag',
						titleAlign:	'center',
						width:		'23px',
						editable:	false,
						defaultValue:	false,
						otherValue:	false,
						editor: new MyTableGrid.CellCheckbox({
				            getValueOf: function(value){
			            		if (value){
									return "Y";
			            		}else{
									return "N";	
			            		}	
			            	},
			            	onClick: function(value, checked) {
			            		// just in case i allow sa TG ang tagging..
			            		
		 			    	}
			            })
	              	},
					{
						id: 'dspDvPref dspDvNo',
						title: 'DV Number',
						titleAlign : 'center',
						width: 90,
						align : 'center',
						children: [
							{
								id : 'dspDvPref',
								title: 'DV Pref',
				                width : 60,
				                editable: false,
				                sortable: false,
				                alight: 'left',
				                filterOption: true
							},{
								id : 'dspDvNo',
								title: 'DV Number',
				                width : 80,
				                editable: false,
				                sortable: false,
				                align: 'right',
				                filterOptionType: 'integerNoNegative',
				                filterOption: true
							}          
						]
					},
					{
						id: 'dspCheckPrefSuf dspCheckNo',
						title: 'Check Number',
						titleAlign : 'center',
						width: 100,
						align : 'center',
						children: [
							{
								id : 'dspCheckPrefSuf',
								title: 'Check Pref Suf',
				                width : 70,
				                editable: false,
				                sortable: false,
				                alight: 'left',
				                filterOption: true
							},{
								id : 'dspCheckNo',
								title: 'Check Number',
				                width : 70,
				                editable: false,
				                sortable: false,
				                align: 'right',
				                filterOptionType: 'integerNoNegative',
				                filterOption: true
							}          
						]
					},
					{
						id: 'dspDocumentCd dspReqBranch dspLineCd dspDocYear dspDocMm dspDocSeqNo',
						title: 'Payment Request No.',
						titleAlign : 'center',
						width: 120,
						align : 'center',
						children: [
							{
								id : 'dspDocumentCd',
								title: 'Document Code',
				                width : 70,
				                editable: false,
				                sortable: false,
				                alight: 'left',
				                filterOptionType: 'integerNoNegative',
				                filterOption: true
				                
							},{
								id : 'dspReqBranch',
								title: 'Branch',
				                width : 40,
				                editable: false,
				                sortable: false,
				                filterOption: true,
				                align: 'left'
							},{
								id : 'dspLineCd',
								title: 'Line Code',
				                width : 40,
				                editable: false,
				                sortable: false,
				                filterOption: true,
				                align: 'left'
							},{
							   id : 'dspDocYear',
							   title: 'Doc Year',
							   width: 40,
							   align: 'right',
							   filterOptionType: 'integerNoNegative',
				               filterOption: true
							},{
							   id : 'dspDocMm',
							   title: 'Doc Month',
							   width: 30,
							   align: 'right',
							   filterOptionType: 'integerNoNegative',
				                filterOption: true
							},{
							   id : 'dspDocSeqNo',
							   title: 'Doc Sequence Number',
							   width: 40,
							   align: 'right',
							   filterOptionType: 'integerNoNegative',
				                filterOption: true
							}           
						]
					},{
					   id : 'dspAmount',
					   title: 'Amount',
					   width: 120,
					   geniisysClass: 'money',
					   align: 'right',
					   filterOptionType: 'number',
		                filterOption: true
					},{
					   id : 'dspParticulars',
					   width: '0px',
					   visible: false
					},{
					   id : 'dspPayee',
					   width:'0px',
					   visible: false
					},{
					   id : 'dvTranId',
					   width:'0px',
					   visible: false
					}      
				],
				rows: objRfDetail.objRfDetailTGRows
			};
			
			rfDetailGrid = new MyTableGrid(rfDetailTableModel);
			rfDetailGrid.pager = objRfDetail.objRfDetailTG;
			rfDetailGrid.render('rfDetailTgDiv');
	}catch(e){
		showErrorMessage("rfDetailTgDiv",e);
	}
	
	function populateRfDetail(obj){
		try{	
			$("dspDvNo").value = obj == null ? "" : obj.dspDvPref +"-"+ obj.dspDvNo;
			$("dspCheckNo").value = obj == null ? "" : obj.dspCheckPrefSuf +"-"+ obj.dspCheckNo;
			$("dspPaymentRequestNo").value = obj == null ? "" : obj.dspDocumentCd +"-"+ obj.dspReqBranch+"-"+ obj.dspLineCd+"-"+ obj.dspDocYear+"-"+ obj.dspDocMm+"-"+ obj.dspDocSeqNo;
			$("dspAmount").value = obj == null ? "" : formatCurrency(obj.dspAmount);
			$("dspPayee").value = obj == null ? "" : unescapeHTML2(obj.dspPayee);
			$("dspParticulars").value = obj == null ? "" : unescapeHTML2(obj.dspParticulars);
			if (obj != null){
				$("includeTag").disabled = false;
				$("includeTag").checked = obj.dspIncludeTag == "Y" ? true : false;
				enableButton("btnUpdate");
			}else{
				$("includeTag").checked = false;
				$("includeTag").disabled = true;
				disableButton("btnUpdate");
				objRfDetail.selectedObj = null;
			}
			
		}catch(e){
			showErrorMessage("populateRfDetail",e);
		}
	}
	
	function saveRfDetail(){
		try{
			var objParameters = {};
			objParameters.setRows 	= getAddedAndModifiedJSONObjects(objRfArr);
			objParameters.replenishId = $F("replenishId");
			
			var strParameters = JSON.stringify(objParameters);
			new Ajax.Request(contextPath + "/GIACReplenishDvController", {
				parameters:{
					action: "saveRfDetail",
					strParameters: strParameters
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response)) {
						if(response.responseText == "SUCCESS"){
							showWaitingMessageBox(objCommonMessage.SUCCESS,"S", function(){
								genericObjOverlay.close();
								showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, objACGlobal.otherBranch);
							});	
						}else{
							showMessageBox(response.responseText, "E");
						}
					}
				}		
			});	
		}catch(e){
			showErrorMessage("saveRfDetail",e);
		}
	}
	
	function addModifiedRfDtl(editedRf){
		try{
			for ( var i = 0; i < objRfArr.length; i++) {
				var rf = objRfArr[i];
				if(editedRf.dvTranId == rf.dvTranId && editedRf.checkItemNo == rf.checkItemNo){	// added checkItemNo : shan 10.09.2014
					if(editedRf.recordStatus == "0" && editedRf.recordStatus == "-1"){ // removed if just added
						objRfArr.splice(i,1);
					}else{// if modified
						objRfArr.splice(i,1,editedRf);
					}
				}
			}
		}catch(e){
			showErrorMessage("addModifiedRfDtl",e);
		}
	}
	
	$("btnAccountingEntries").observe("click", function(){
		accountingEntriesOverlay = Overlay.show(contextPath+"/GIACBatchDVController", { 
			urlContent: true,
			urlParameters: {action : "getGIACS086AcctEntriesTableGrid",
				tranId : objRfDetail.selectedObj.dvTranId,
				moduleId : 'GIACS016',
							ajax : "1"},
			title: "Accounting Entries",							
		    height: 450,
		    width: 760,
		    draggable: true
	   }); 
	});
	$("btnSummarizedEntries").observe("click", function(){
		accountingEntriesOverlay = Overlay.show(contextPath+"/GIACReplenishDvController", { 
			urlContent: true,
			urlParameters: {action : "getGIACS016SumAcctEntriesTableGrid",
				replenishId : $F("replenishId"),
				moduleId : 'GIACS016',
							ajax : "1"},
			title: "Summarized Entries",							
		    height: 450,
		    width: 760,
		    draggable: true
	   }); 
	});
	$("btnSaveRf").observe("click",function(){
		if (changeTag == 1) {
			saveRfDetail();
		}else{
			showMessageBox(objCommonMessage.NO_CHANGES);
		}
	});
	
	$("btnUpdate").observe("click",function(){
		var prevIncludeTag = objRfDetail.selectedObj.dspIncludeTag; // gets the original first, then compare to decide if the total should be updated.
		if($("includeTag").checked == true){
			//$("mtgInput"+rfDetailGrid._mtgId+"_2,"+selectedIndex).checked = true;
		//	rfDetailGrid.setValueAt("Y", 2,selectedIndex,true);
			objRfDetail.selectedObj.dspIncludeTag = "Y";
		}else{
			objRfDetail.selectedObj.dspIncludeTag = "N";
			
		}
		objRfDetail.selectedObj.recordStatus = 1;
		rfDetailGrid.updateVisibleRowOnly(objRfDetail.selectedObj, selectedIndex);
		addModifiedRfDtl(objRfDetail.selectedObj);
		var dspDisapprovedAmt = parseFloat(nvl(unformatNumber($F("dspDisapprovedAmt")),"0")); 
		var dspApprovedAmt = parseFloat(nvl(unformatNumber($F("dspApprovedAmt")),"0"));
		var dspRequestedAmt = parseFloat(nvl(unformatNumber($F("dspRequestedAmt")),"0"));
		var amount = parseFloat(nvl(unformatNumber(objRfDetail.selectedObj.dspAmount),"0"));
		var total = 0;
		if(prevIncludeTag != objRfDetail.selectedObj.dspIncludeTag){
			if($("includeTag").checked == true){
				$("dspDisapprovedAmt").value = formatCurrency(dspDisapprovedAmt - amount);
				$("dspApprovedAmt").value = formatCurrency((dspApprovedAmt + amount));
			}else{
				total = dspDisapprovedAmt + amount;
				$("dspDisapprovedAmt").value = formatCurrency(total);
				$("dspApprovedAmt").value = formatCurrency((dspRequestedAmt - total));
			}
		}
		fireEvent($("mtgInput"+rfDetailGrid._mtgId+"_2,"+selectedIndex), "change");
		populateRfDetail(null);
		rfDetailGrid.unselectRows();
		rfDetailGrid.releaseKeys();
	});
	
	$("includeTag").observe("change",function(){
		/*var dspDisapprovedAmt = parseFloat(nvl(unformatNumber($F("dspDisapprovedAmt")),"0")); moved to update
		var dspApprovedAmt = parseFloat(nvl(unformatNumber($F("dspApprovedAmt")),"0"));
		var amount = parseFloat(nvl(unformatNumber(objRfDetail.selectedObj.dspAmount),"0"));
		var total;
		if($("includeTag").checked == true){
			total = dspDisapprovedAmt - amount;
			$("dspDisapprovedAmt").value = formatCurrency(total);
			$("dspApprovedAmt").value = formatCurrency((dspApprovedAmt + amount));
		}else{
			total = dspDisapprovedAmt + amount;
			$("dspDisapprovedAmt").value = formatCurrency(total);
			$("dspApprovedAmt").value = formatCurrency((dspApprovedAmt - total));
		}
		*/
	});
	
	$("btnRfPrint").observe("click", function(){
		function printGIACR081(){
			var fileType = $("rdoPdf").checked ? "PDF" : "XLS";
			var content = contextPath+"/GeneralDisbursementPrintController?action=printGIACR081" // check requisition printing
			+"&noOfCopies="+$F("txtNoOfCopies")+"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination")
			+"&branchCd="+nvl(objACGlobal.branchCd, "")
			+"&moduleId=GIACS016"	
			+"&replenishId="+nvl($F("replenishId"), "")
			+"&reportId=GIACR081"	
			+"&fileType="+fileType;	
			
			printGenericReport(content, "DV RECORDS FOR REPLENISHMENT");
		}
		
		showGenericPrintDialog("DV Records for Replenishment", printGIACR081, null, true);
	});
	
	observeCancelForm("btnReturnRf", saveRfDetail, function(){genericObjOverlay.close();});
	
	$("viewDspPaticulars").observe("click",function(){
		showEditor("dspParticulars", 2000, 'true');
	});
	initializeChangeTagBehavior(saveRfDetail);
	//observeReloadForm("reloadForm", function(){objACGlobal.showRfDetailTG($F("replenishId"));});
	disableButton("btnUpdate");
	disableButton("btnAccountingEntries");
</script>