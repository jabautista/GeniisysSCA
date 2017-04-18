<div id="invoiceTableGridSectionDiv" name=""invoiceTableGridSectionDiv"" class="sectionDiv" style="height: 450px;">
	<div id="invoiceGridDiv" style="padding-left: 10px; padding-top: 10px; padding-bottom: 10px; height: 245px"></div>
	<div id="invoiceDetails" name="invoiceDetails" class="sectionDiv" style="height:140px; width: 900px; margin-left: 10px; margin-bottom: 10px;" align="center">
		<table style="margin-top: 10px;">
			<tr>
				<td class="rightAligned">Inst. No.</td>
				<td class="leftAligned">
					<input id="txtInstNo" type="text" readonly="readonly" value=""  name="txtInstNo" style="width: 150px; text-align: right;"/>
				</td>
				<td class="rightAligned" style="padding-left: 30px;">Tax Amount</td>
				<td class="leftAligned">
					<input id="txtTaxAmount" type="text" readonly="readonly" value=""  name="txtTaxAmount" style="width: 200px; text-align: right;"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">% Share</td>
				<td class="leftAligned">
					<input id="txtSharePct" type="text" readonly="readonly" value=""  name="txtSharePct" style="width: 150px; text-align: right;"/>
				</td>
				<td class="rightAligned" style="padding-left: 30px;">Premium Amount</td>
				<td class="leftAligned">
					<input id="txtPremAmnt" type="text" readonly="readonly" value=""  name="txtPremAmnt" style="width: 200px; text-align: right;"/>
				</td>
			</tr>
			<tr>
				<td class="leftAligned">Due Date</td>
				<td class="rightAligned">
					<div class="withIconDiv" style="float: left; margin-left: 3px; width: 157px;">
						<input id="txtInvDueDate" class="withIcon" type="text" style="width: 133px;" name="txtInvDueDate" readOnly="readonly"/> 
						<img src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" id="hrefInvDueDate" alt="Due Date"/>
					</div>
				</td>
			</tr>
		</table>
		<div align="center" style="margin-top: 10px;">
			<input type="button" class="button" id="btnInvUpdate" name="btnInvUpdate" value="Update" style="width: 100px;"/>
		</div>
	</div>
	<div align="center">
			<input type="button" class="button" style="width: 130px;" id="btnInvApply" name="btnInvApply" value="Apply" />
	</div>
	<input id="txtInceptDate" type="hidden" value=""/>
	<input id="txtExpiryDate" type="hidden" value=""/>
	<input id="txtDue" type="hidden" value=""/>
	<input id="txtDueDateOld" type="hidden" value=""/>
</div>

<script type="text/javascript">
	initializeAll();
	changeTag = 0;
	saveChange = 0;
	objChangePayTerm = new Object();
	applyTag = null;
	applyTax = null;
	var update = null;
	var prevDueDate = null;
	var incept = null;
	var expiry = null;
	
	try {
		var objInvoice = new Object();
		var objInvList = [];
		array = [];
		objInvoice.objInvoiceListing = [];
		objInvoice.InvoiceDetail = objInvoice.objInvoiceListing.rows || [];
		row = 0;

		var invInfoListTG = {
			url : contextPath + "/GIUTSChangeInPaymentTermController?action=getInstallmentDetails",
			options : {
				width : '900px',
				height : '220px',
				onCellFocus : function(elemsent, value, x, y, id) {
					row = y;
					enableButton("btnInvUpdate");
					enableDate("hrefInvDueDate");
					if (y < 0) {
						populateInvoiceInformation(objNewPaySched.newSched[Math.abs(y) - 1]);
					} else {
						objInv = invInfoListTableGrid.geniisysRows[y];
						populateInvoiceInformation(objInv);
					}
					invInfoListTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus : function() {
					populateInvoiceInformation(null);
					//$("txtInstNo").focus();
					disableButton("btnInvUpdate");
					disableDate("hrefInvDueDate");
					invInfoListTableGrid.keys.releaseKeys();
				},
				 beforeSort: function(){
	            	if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
                	}
	            	invInfoListTableGrid.keys.releaseKeys();
	            },
				onSort : function() {
					populateInvoiceInformation(null);
					//$("txtInstNo").focus();
					disableButton("btnInvUpdate");
					disableDate("hrefInvDueDate");
					invInfoListTableGrid.keys.releaseKeys();
				},
				prePager: function(){
	            	if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
                	} else {	
                		populateInvoiceInformation(null);
                		//$("txtInstNo").focus();
                		disableButton("btnInvUpdate");
                		disableDate("hrefInvDueDate");
                	}
	            	invInfoListTableGrid.keys.releaseKeys();
                },
				onRefresh : function() {
					invInfoListTableGrid.onRemoveRowFocus();
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
				},
				toolbar : {
					elements : [ MyTableGrid.REFRESH_BTN,MyTableGrid.FILTER_BTN ],
					onFilter : function() {
						invInfoListTableGrid.onRemoveRowFocus();
					} 
				}
			},
			columnModel : [ {
				id 			 : 'recordStatus',
				width 		 : '0',
				visible 	 : false,
				editor 		 : 'checkbox'
			}, {
				id 			 : 'divCtrId',
				width 		 : '0',
				visible 	 : false
			}, {
				id 			 : 'issCd',
				title 		 : 'Inst. No.',
				width 		 : '0px',
				visible 	 : false
			}, {
				id 			 : 'premSeqNo',
				title 		 : 'Inst. No.',
				width 		 : '0px',
				visible 	 : false
			}, {
				id 			 : 'instNo',
				title 		 : 'Inst. No.',
				width 		 : '90px',
				visible 	 : true,
				filterOption : true,
				titleAlign   : 'right',
				align 		 : 'right'
			}, {
				id 			 : 'sharePercentage',
				title 		 : '% Share',
				width 		 : '155px',
				visible 	 : true,
				filterOption : true,
				titleAlign 	 : 'right',
				align 		 : 'right',
				renderer 	 : function(value) {
							   	return formatCurrency(value);
							   }
			}, {
				id 			 : 'taxAmount',
				title 		 : 'Tax Amount',
				width 		 : '210px',
				visible 	 : true,
				filterOption : true,
				titleAlign 	 : 'right',
				align 		 : 'right',
				renderer 	 : function(value) {
								return formatCurrency(value);
							   }
			}, {
				id 			 : 'premAmount',
				title 		 : 'Premium Amount',
				width 		 : '205px',
				visible 	 : true,
				filterOption : true,
				titleAlign 	 : 'right',
				align 		 : 'right',
				renderer 	 : function(value) {
								return formatCurrency(value);
							   }
			}, {
				id 			 : 'dueDate',
				title 		 : 'Due Date',
				width 		 : '203px',
				visible 	 : true,
				filterOption : true,
				renderer 	 : function(value) {
								return dateFormat(value, 'mm-dd-yyyy');
							   }
			} ],
			rows : objInvoice.InvoiceDetail
		};
		invInfoListTableGrid = new MyTableGrid(invInfoListTG);
		invInfoListTableGrid.pager = objInvoice.objInvoiceListing;
		invInfoListTableGrid.render('invoiceGridDiv');
		invInfoListTableGrid.afterRender = function() {
			objInvList = invInfoListTableGrid.geniisysRows;
			changeTag = 0;
		};

	} catch (e) {
		showErrorMessage("Change Payment Term", e);
	}

	function populateInvoiceInformation(obj) {
		try {
			$("txtInstNo").value 		= obj == null ? "" : obj.instNo;
			$("txtTaxAmount").value		= obj == null ? "" : formatCurrency(obj.taxAmount);
			$("txtSharePct").value 		= obj == null ? "" : formatCurrency(obj.sharePercentage);
			$("txtPremAmnt").value 		= obj == null ? "" : formatCurrency(obj.premAmount);
			$("txtInvDueDate").value 	= obj == null ? "" : dateFormat(obj.dueDate, 'mm-dd-yyyy');
			issCd 						= obj == null ? "" : obj.issCd;
			premSeqNo 					= obj == null ? "" : obj.premSeqNo;
		} catch (e) {
			showErrorMessage("populateInvoiceInformation", e);
		}
	}
	
	objChangePayTerm.populateInstallment = populateInvoiceInformation;

	function setInvoiceInformationInfo() {
		var rowObjectInvoice 			 = new Object();
		rowObjectInvoice.instNo 		 = $("txtInstNo").value;
		rowObjectInvoice.taxAmount 	 	 = $("txtTaxAmount").value;
		rowObjectInvoice.sharePercentage = $("txtSharePct").value;
		rowObjectInvoice.premAmount 	 = $("txtPremAmnt").value;
		rowObjectInvoice.dueDate 		 = $("txtInvDueDate").value;
		rowObjectInvoice.issCd 			 = issCd;
		rowObjectInvoice.premSeqNo 		 = premSeqNo;
		return rowObjectInvoice;
	}

	function updateInvoiceDueDate() {
		if (row < 0) {
			rowObj = setInvoiceInformationInfo();
			rowObj.recordStatus = 1;

			objNewPaySched.newSched.splice(Math.abs(row) - 1, 1, rowObj);
			invInfoListTableGrid.empty();
			invInfoListTableGrid.clear();
			invInfoListTableGrid.createNewRows(objNewPaySched.newSched);

			totalNumberRecords();

			changeTag = 1;
			objNewPaySched.commitSw = 1;
			objChangePayTerm.setRows = objNewPaySched.newSched;

		} else {
			rowObj = setInvoiceInformationInfo();
			rowObj.recordStatus = 1;
			objInvList.splice(row, 1, rowObj);
			invInfoListTableGrid.updateVisibleRowOnly(rowObj, row);
			
			changeTag = 1;
			objNewPaySched.commitSw = 2;
			objChangePayTerm.setRows = objInvList;
		}
		enableButton("btnSave");
		invInfoListTableGrid.onRemoveRowFocus();

	}
	
	function saveDueDateDetail() {
		var objParams = new Object();
		if (objNewPaySched.commitSw == 1) {
			objParams.setRows = getAddedAndModifiedJSONObjects(objNewPaySched.newSched);
		} else if (objNewPaySched.commitSw == 2) {
			objParams.setRows = getAddedAndModifiedJSONObjects(objInvList);
		} else if (objNewPaySched.commitSw == 3) {
			objParams.setRows = getAddedAndModifiedJSONObjects(objTax);
		}

		new Ajax.Request(contextPath + "/GIUTSChangeInPaymentTermController?action=updateDueDate", {
			method : "POST",
			parameters : {
				parameters : JSON.stringify(objParams)
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response) {
				hideNotice("");
				if (checkErrorOnResponse(response)) {
					if(applyTag == 1){
						updateDueDateInvoice();	
					}
					//showMessageBox(objCommonMessage.SUCCESS, "S");
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGiuts022.exitPage != null) {
							objGiuts022.exitPage();
						} else {
							invInfoListTableGrid._refreshList();
						}
					});
					invInfoListTableGrid.onRemoveRowFocus;
					populateInvoiceInformation(null);
					
				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	objChangePayTerm.updateDueDate = saveDueDateDetail;
	
	function totalNumberRecords(){
		var html = [];
		var idx = 0;
		var pager = invInfoListTableGrid.pager;

		var temp = invInfoListTableGrid._messages.totalDisplayMsg;
		temp = temp.replace(/\{total\}/g, $("txtPayTermNo").value);
			if (pager.from && pager.to) {
				var visibleRow = ((invInfoListTableGrid.bodyTable.down('tbody').childElements()).filter(function(row) {return row.style.display != "none";})).length;
				temp += invInfoListTableGrid._messages.rowsDisplayMsg;
				temp = temp.replace(/\{from\}/g, pager.from);
				temp = temp.replace(/\{to\}/g, (((pager.from - 1) + invInfoListTableGrid.rows.length) + invInfoListTableGrid.getNewRowsAdded().length) < pager.to ? ((pager.from - 1) + visibleRow) : pager.to);
			} else {
				temp += invInfoListTableGrid._messages.pagerNoRecordsLeft;
			}

		html[idx++] = temp;
		html.join('');
		$("mtgPagerMsg" + invInfoListTableGrid._mtgId).update(html);
	}
	
	objChangePayTerm.updateTotal = totalNumberRecords;
	
	function updateDueDateInvoice() {
		new Ajax.Request(contextPath + "/GIUTSChangeInPaymentTermController?",{
			method : "POST",
			parameters 		: {
				action 		: "updateInvoiceDueDate",
				dueDate 	: $("txtDueDate").value,
				policyId 	: policyId
			},
			asynchronous : true,
			evalScripts : true,
			onComplete : function(response) {
				disableButton("btnSave");
			}
		});
	};
	
	function getInceptExpiry() {
		new Ajax.Request(contextPath + "/GIUTSChangeInPaymentTermController?action=getDates", {
			parameters : {
				lineCd 		: $("txtLineCd").value,
				sublineCd 	: $("txtSublineCd").value,
				issCd 		: $("txtIssCd").value,
				issueYy 	: unformatNumber($("txtIssueYy").value),
				polSeqNo 	: unformatNumber($("txtPolSeqNo").value),
				renewNo 	: unformatNumber($("txtRenewNo").value),
				invDueDate	: $("txtInvDueDate").value
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response) {
				var res = JSON.parse(response.responseText);
				incept  = JSON.stringify(res.inceptDate);
				expiry  = JSON.stringify(res.expiryDate);
				if(JSON.stringify(res.message) != "null"){
					customShowMessageBox(res.message, imgMessage.WARNING, "txtInvDueDate");
					$("txtInvDueDate").value = prevDueDate;
				}
			}
		});
	};
	
	$("hrefInvDueDate").observe("click", function() {
		scwShow($("txtInvDueDate"), this, null);
		update = 1;
		prevDueDate = $("txtInvDueDate").value;
	});

	$("btnInvUpdate").observe("click", function() {
		if ($("txtPayTermNo").value > 1) {
			if ($('txtInstNo').value == 1) {
				customShowMessageBox("Press Apply button if you want to update the due date of the other installments", imgMessage.INFO, "txtInvDueDate");
				$("txtDueDateOld").value = $("txtDueDate").value;
				$("txtDueDate").value = $("txtInvDueDate").value;
				applyTag   = 1;
				applyTax   = 1;
				saveChange = 1;
				enableButton("btnInvApply");
			}else {
				applyTag = 0;
				applyTax = null;
				disableButton("btnInvApply");
			}
		}
		updateInvoiceDueDate();
		objNewPaySched.clearFields();
		
	});

	$("txtInvDueDate").observe("focus", function() {
		if (update == 1) {
			new Ajax.Request(contextPath + "/GIUTSChangeInPaymentTermController?action=validateFullyPaid",{
				parameters : {
					issCd : issCd,
					premSeqNo : premSeqNo
				},
				asynchronous : false,
				evalScripts : true,
				onComplete : function(response) {
					if (checkErrorOnResponse(response)) {
						if (objNewPaySched.premAmt == response.responseText) {
							$("txtInvDueDate").value = prevDueDate;
							customShowMessageBox("This bill is fully paid. Cannot change due date.", imgMessage.INFO, "txtInvDueDate");
							disableButton("btnInvUpdate");
							disableButton("btnSave");
						} else {
							/* var incDate = incept; comment out by Kenneth L.06.19.2013
							var expDate = expiry;
							$("txtInceptDate").value = incDate.replace(/"/g, "");
							$("txtExpiryDate").value = expDate.replace(/"/g, "");
		
							if (makeDate($("txtInvDueDate").value) < makeDate($("txtInceptDate").value)) {
								$("txtInvDueDate").value = prevDueDate;
								customShowMessageBox("Due date must not be earlier than " + dateFormat($("txtInceptDate").value, 'mmmm dd, yyyy') + ".", imgMessage.WARNING, "txtInvDueDate");
							} else if (makeDate($("txtInvDueDate").value) > makeDate($("txtExpiryDate").value)) {
								$("txtInvDueDate").value = prevDueDate;
								customShowMessageBox("Due date must not be later than " + dateFormat($("txtExpiryDate").value, 'mmmm dd, yyyy') + ".", imgMessage.WARNING, "txtInvDueDate");
							} else if ($("txtInvDueDate").value == "") {
								$("txtInvDueDate").value = prevDueDate;
							}*/
							getInceptExpiry();
 						}
							update = null;
							prevDueDate = null;
							$("txtInceptDate").value = "";
							$("txtExpiryDate").value = "";
					} else {
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		} else {
			return;
		}

	});

	$("btnInvApply").observe("click", function() {
	if(applyTag == 0){
		for ( var i = 0; i < objInvList.length; i++) {
			var due = JSON.stringify(objInvList[i].dueDate);
			var expiryDate = expiry;
			$("txtExpiryDate").value = expiryDate.replace(/"/g, "");
			$("txtDue").value = due.replace(/"/g, "");
			if(makeDate(dateFormat($("txtDue").value, 'mm-dd-yyyy')) > makeDate($("txtExpiryDate").value)){
				var inst = i+1;
				customShowMessageBox("Due date of installment number " + inst + " has gone beyond the expiry date " + dateFormat($("txtExpiryDate").value, 'mmmm dd, yyyy'), imgMessage.WARNING, "txtInstNo");
				return;
			}   
		}   
	}else if(applyTag == 1){
		new Ajax.Request(contextPath + "/GIUTSChangeInPaymentTermController?",{
			parameters : {
				action 		  : "updatePaymentTerm",
				issCd 		  : $("txtIssCd").value,
				premSeqNo 	  : $("txtInvPremSeqNo").value,
				itemGrp 	  : $("txtInvItemGrp").value,
				policyId 	  : policyId,
				dueDate	 	  : dateFormat($("txtDueDate").value, 'mm-dd-yyyy'),
				paytTermsDesc : $("txtPayTerm").value,
				premAmt 	  : unformatNumber($("txtPremium").value),
				otherCharges  : unformatNumber($("txtOtherCharges").value),
				notarialFee   : unformatNumber($("txtNotarialFee").value),
				taxAmt 		  : unformatNumber($("txtTotalTax").value),
				commitChanges : "N"
			},
			asynchronous : true,
			evalScripts : true,
			onComplete : function(response) {
				if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
					objNewPaySched.commitSw = 1;
					changeTag = 1;
					updateNew = JSON.parse(response.responseText);
					invInfoListTableGrid.empty();
					invInfoListTableGrid.clear();
					
					for ( var i = updateNew.newItems.length - 1; i > -1; i--) {
						invInfoListTableGrid.createNewRow(updateNew.newItems[i]);
					}

					objNewPaySched.newSched = invInfoListTableGrid.getNewRowsAdded();
					totalNumberRecords();
					
					for ( var i = 0; i < updateNew.newItems.length; i++) {
						var due = JSON.stringify(updateNew.newItems[i].dueDate);
						var expiryDate = expiry;
						$("txtExpiryDate").value = expiryDate.replace(/"/g, "");
						$("txtDue").value = due.replace(/"/g, "");
						
						if(makeDate(dateFormat($("txtDue").value, 'mm-dd-yyyy')) > makeDate($("txtExpiryDate").value)){
							customShowMessageBox("Due date of installment number " + (i+1) + " has gone beyond the expiry date " + dateFormat($("txtExpiryDate").value, 'mmmm dd, yyyy'), imgMessage.WARNING, "txtInstNo");
							return
						}  
					}
				}
			}
		});
		$("txtExpiryDate").value = "";
		applyTag = 1;
		disableButton("btnInvApply");
		applyTax = 2;
		saveChange = 0;
	}
	});
	
	disableDate("hrefInvDueDate");
</script>