<div id="taxTableGridSectionDiv" name="taxTableGridSectionDiv" class="sectionDiv" style="height: 430px;">
	<div id="taxAllocationDiv" style="padding-left: 10px; padding-top: 10px; padding-bottom: 10px; height: 245px"></div>
	<div id="taxAllocationDetails" name="taxAllocationDetails" class="sectionDiv" style="height:120px; width: 900px; margin-left: 10px; margin-bottom: 10px; margin">
		<table style="margin-top: 10px; margin-left: 48px;">
			<tr>
				<td class="rightAligned">Tax Code</td>
				<td class="leftAligned">
					<input id="txtTaxCd" type="text" readonly="readonly" value=""  name="txtTaxCd" style="width: 110px;"/>
				</td>
				<td class="rightAligned" style="padding-left: 35x;">Tax Amount</td>
				<td class="leftAligned">
					<input id="txtTaxAmt" type="text" readonly="readonly" value=""  name="txtTaxAmt" style="width: 237px;"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Tax Description</td>
				<td class="leftAligned">
					<input id="txtTaxDesc" type="text" readonly="readonly" value=""  name=""txtTaxDesc"" style="width: 285px;"/>
				</td>
				<td class="rightAligned" style="padding-left: 35px;">Tax Allocation</td>
				<td class="leftAligned">
					<!-- <input id="txtTaxAlloc" type="text" readonly="readonly" value=""  name="txtTaxAlloc" style="width: 237px;"/> -->
					<select id="dDnTaxAlloc" name="dDnTaxAlloc" style="text-align: left; width: 245px;">
							<option>First</option>
							<option>Spread</option>
							<option>Last</option>
 					</select>
				</td>
			</tr>
		</table>
		<div align="center" style="margin-top: 10px;">
			<input type="button" class="button" id="btnTaxUpdate" name="btnTaxUpdate" value="Update" style="width: 100px;"/>
		</div>
	</div>
	<div align="center">
			<input type="button" class="button" style="width: 130px;" id="btnTaxApply" name="btnTaxApply" value="Apply" />
			<input id="hidTaxAllocation" type="hidden" value="" name="hidTaxAllocation"/>
	</div>
	
</div>

<script type="text/javascript">
	objTaxAllocation = new Object();
	objTaxAllocation.newSched = [];
	try {
		var objTaxAlloc = new Object();
		objTax = new Object();
		objTaxAlloc.objTaxAllocInfo = [];
		objTaxAlloc.objTaxAllocInfoList = objTaxAlloc.objTaxAllocInfo.rows || [];
		var objTaxInfo = [];
		fixedTax = null;

		var taxAllocationTG = {
			url : contextPath + "/GIUTSChangeInPaymentTermController?action=showChangeInPaymentTerm",
			options : {
				width : '900px',
				height : '220px',
				onCellFocus : function(element, value, x, y, id) {
					row = y;
					populateTaxAllocation(taxAllocationTableGrid.geniisysRows[y]);
					if (fixedTax == "N" && (applyTax == 1 || applyTax == 2) && $("txtPayTermNo").value > 1) {
						if (saveChange == 1 && objNewPaySched.commitSw == 1) {
							showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
							return false;
						} else {
							$("dDnTaxAlloc").disabled = false;
							enableButton("btnTaxUpdate");
						}
					} else {
						$("dDnTaxAlloc").disabled = true;
					}
					taxAllocationTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus : function() {
					populateTaxAllocation(null);
					//$("txtTaxCd").focus();
					$("dDnTaxAlloc").value = "First";
					disableButton("btnTaxUpdate");
					taxAllocationTableGrid.keys.releaseKeys();
				},
				beforeSort : function() {
					if (changeTag == 1) {
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}
					taxAllocationTableGrid.keys.releaseKeys();
				},
				onSort : function() {
					populateTaxAllocation(null);
					taxAllocationTableGrid.keys.releaseKeys();
				},
				prePager : function() {
					if (changeTag == 1) {
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					} else {
						populateTaxAllocation(null);
					}
					taxAllocationTableGrid.keys.releaseKeys();
				},
				onRefresh : function() {
					taxAllocationTableGrid.onRemoveRowFocus();
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
						taxAllocationTableGrid.onRemoveRowFocus();
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
				id 			 : 'taxCd',
				title 		 : 'Tax Code',
				width 		 : '100px',
				visible 	 : true,
				filterOption : true,
				titleAlign   : 'right',
				align 		 : 'right'
			}, {
				id 			 : 'taxDescription',
				title 		 : 'Tax Description',
				width 	     : '338px',
				visible 	 : true,
				filterOption : true
			}, {
				id 			 : 'taxAmt',
				title 		 : 'Tax Amount',
				width 	 	 : '215px',
				visible 	 : true,
				filterOption : true,
				titleAlign 	 : 'right',
				align 		 : 'right',
				renderer 	 : function(value) {
								return formatCurrency(value);
							   }
			}, {
				id 			 : 'taxAllocationDesc',
				title 		 : 'Tax Allocation',
				width 		 : '210px',
				visible 	 : true,
				filterOption : true
			}, {
				id 			 : 'taxAllocation',
				width 		 : '0px',
				visible 	 : false
			}, {
				id 			 : 'fixedTaxAllocation',
				width 		 : '0px',
				visible 	 : false
			} ],
			rows : objTaxAlloc.objTaxAllocInfoList
		};
		taxAllocationTableGrid = new MyTableGrid(taxAllocationTG);
		taxAllocationTableGrid.pager = objTaxAlloc.objTaxAllocInfo;
		taxAllocationTableGrid.render('taxAllocationDiv');
		objTaxInfo = taxAllocationTableGrid.geniisysRows;
	} catch (e) {
		showErrorMessage("Change Payment Term", e);
	}

	function populateTaxAllocation(obj) {
		try {
			$("txtTaxCd").value 		= obj == null ? "" : obj.taxCd;
			$("txtTaxAmt").value 		= obj == null ? "" : formatCurrency(obj.taxAmt);
			$("txtTaxDesc").value 		= obj == null ? "" : obj.taxDescription;
			$("dDnTaxAlloc").value 		= obj == null ? "" : obj.taxAllocationDesc;
			$("hidTaxAllocation").value = obj == null ? "" : obj.taxAllocation;
			fixedTax 					= obj == null ? "" : obj.fixedTaxAllocation;
		} catch (e) {
			showErrorMessage("populateInvoiceInformation", e);
		}
	}

	objTaxAllocation.populateTaxAllocation = populateTaxAllocation;
	
	function setTaxAllocationInfo() {
		var rowObjectTax 				= new Object();
		rowObjectTax.taxCd 				= $("txtTaxCd").value;
		rowObjectTax.taxAmt 			= $("txtTaxAmt").value;
		rowObjectTax.taxDescription 	= $("txtTaxDesc").value;
		rowObjectTax.taxAllocationDesc 	= $("dDnTaxAlloc").value;
		rowObjectTax.issCd 				= $("txtInvIssCd").value;
		rowObjectTax.premSeqNo 			= $("txtInvPremSeqNo").value;
		rowObjectTax.taxAllocation 		= $("dDnTaxAlloc").value == "First" ? "F" : $("dDnTaxAlloc").value == "Spread" ? "S" : "L";
		rowObjectTax.fixedTaxAllocation = fixedTax;
		return rowObjectTax;
	}

	function addUpdatePeril() {
		rowObj = setTaxAllocationInfo();
		rowObj.recordStatus = 1;
		objTaxInfo.splice(row, 1, rowObj);
		taxAllocationTableGrid.updateVisibleRowOnly(rowObj, row);
		changeTag = 1;
	}

	$("btnTaxUpdate").observe("click", function() {
		addUpdatePeril();
		enableButton("btnTaxApply");
		populateTaxAllocation(null);
		objNewPaySched.clearFields();
		disableButton("btnTaxUpdate");
	});

	$("btnTaxApply").observe("click", function() {
		changeTagFunc = objNewPaySched.saveAllChanges;
		saveTaxAllocation();
	});

	function saveTaxAllocation() {
		var objParams = new Object();
		objParams.setRows = getAddedAndModifiedJSONObjects(objTaxInfo);
		new Ajax.Request(contextPath + "/GIUTSChangeInPaymentTermController?action=updateTaxAllocation", {
			method : "POST",
			parameters : {
				parameters 	  : JSON.stringify(objParams),
				issCd 		  : $("txtInvIssCd").value,
				premSeqNo 	  : $("txtInvPremSeqNo").value,
				policyId 	  : policyId,
				paytTermsDesc : $("txtPayTerm").value,
				taxAmt 		  : $("txtTotalTax").value,
				itemGrp		  : $("txtInvItemGrp").value,
				dueDate 	  : dateFormat($("txtDueDate").value, 'mm-dd-yyyy'),
				premAmt 	  : unformatNumber($("txtPremium").value),
				otherCharges  : unformatNumber($("txtOtherCharges").value),
				notarialFee   : unformatNumber($("txtNotarialFee").value)
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response) {
				hideNotice("");
				if (checkErrorOnResponse(response)) {
					var result = JSON.parse(response.responseText);
					if (applyTax == 1) {
						function onYes() {
							confirm = 1;
							onSave(confirm);
							objNewPaySched.saveAllChanges();
							disableButton("btnInvApply");
						}
						function onCancel() {
							confirm = 0;
							onSave(confirm);
							objChangePayTerm.updateTotal();
							disableButton("btnInvApply");
						}
						function onSave(confirm) {
							objTax = objChangePayTerm.setRows;
							invInfoListTableGrid.empty();
							invInfoListTableGrid.clear();
							for ( var i = 0; i < result.newItems.length; i++) {
								if (confirm == 1) {
									objTax[i].dueDate = dateFormat(objChangePayTerm.setRows[i].dueDate, 'mm-dd-yyyy');
								} else {
									$("txtDueDate").value = $("txtDueDateOld").value;
									if (i == 0) {
										objTax[0].dueDate = $("txtDueDateOld").value;
									} else {
										objTax[i].dueDate = dateFormat(objChangePayTerm.setRows[i].dueDate, 'mm-dd-yyyy');
									}
								}

								objTax[i].instNo 		  = result.newItems[i].instNo;
								objTax[i].premAmount 	  = result.newItems[i].premAmount;
								objTax[i].taxAmount 	  = result.newItems[i].taxAmount;
								objTax[i].sharePercentage = result.newItems[i].sharePercentage;
								objTax[i].recordStatus 	  = 1;
							}

							for ( var i = objTax.length - 1; i > -1; i--) {
								invInfoListTableGrid.createNewRow(objTax[i]);
							}
							objNewPaySched.newSched = [];
							objNewPaySched.newSched = invInfoListTableGrid.getNewRowsAdded();

							objNewPaySched.commitSw = 3;
						}

						showConfirmBox4( "Information Message", "Do you want to save changes you have made?", "Yes", "No", "Cancel", onYes, onCancel, null, null);

					} else {
						objTax = objNewPaySched.newSched;
						for ( var i = 0; i < result.newItems.length; i++) {
							objTax[result.newItems.length - (i + 1)].taxAmount    = result.newItems[i].taxAmount;
							objTax[result.newItems.length - (i + 1)].recordStatus = 1;
						}
						invInfoListTableGrid.empty();
						invInfoListTableGrid.clear();
						invInfoListTableGrid.createNewRows(objTax);

					}
					objChangePayTerm.updateTotal();

				}
			}
		});
	}

	function saveAllocation() {
		var objParams = new Object();
		objParams.setRows = getAddedAndModifiedJSONObjects(objTaxInfo);
		new Ajax.Request(contextPath + "/GIUTSChangeInPaymentTermController?action=updateAllocation", {
			method : "POST",
			parameters : {
				parameters : JSON.stringify(objParams)
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response) {
				hideNotice("");
				if (checkErrorOnResponse(response)) {
				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}

	objTaxAllocation.saveAllocation = saveAllocation;
	$("dDnTaxAlloc").disabled = true;
	disableButton("btnTaxUpdate");
	disableButton("btnTaxApply");
</script>