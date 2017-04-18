<div id="mortgageeInformationMainDiv">
	<div id="mortgageeInformationMain" class="sectionDiv"
		style="border: none;">
		<div id="mortgageeInformation" style="padding: 0px;"
			class="sectionDiv">
			<div id="mortgageeInformationDetails" name="policyBillInvoiceDetails"
				class="sectionDiv"
				style="border: none; margin-top: 10px; margin-left: 10px;">
				<div id="mortgageeTableGrid" class="sectionDiv"
					style="border: none; height: 200px; width: 900px; margin: auto; margin-bottom: 15px;"></div>
				<div id="mortgageeInformationTextDiv"
					name="mortgageeInformationTextDiv"
					style="margin-top: 20px; float: left; width: 900px;" align="center">
					<table align="center">
						<tr>
							<td class="rightAligned" style="width: 120px;">Mortgagee
								Name</td>
							<td class="leftAligned" colspan="5">
								<div style="width: 360px;"
									class="required withIconDiv">
									<input type="text" id="txtMortgCd" name="txtMortgCd" value=""
										style="width: 330px;"
										class="required withIcon" readonly="readonly" tabindex="601"> <img
										style="float: right;"
										src="${pageContext.request.contextPath}/images/misc/searchIcon.png"
										id="searchMortgageeName" name="searchMortgageeName" alt="Go" tabindex="602"/>
								</div> 
							</td>
						</tr>
						<tr>
							<td class="rightAligned">Amount</td>
							<td><input id="mortgAmount" name="mortgAmount"
								class="money numeric" type="text" align="right"
								style="width: 354px; margin-left: 5px;" tabindex="603"></td>
						</tr> 
						<tr>
							<td class="rightAligned">Remarks</td>
							<td colspan="3">
								<div id="remarksDiv"
									style="border: 1px solid gray; height: 20px; width: 360px; margin-left: 5px;">
									<textarea id="mortgRemarks" name="mortgRemarks"
										style="width: 330px; border: none; height: 13px; resize: none;"
										maxlength="50" tabindex="604"/></textarea>
									<img
										src="${pageContext.request.contextPath}/images/misc/edit.png"
										style="width: 14px; height: 14px; margin: 3px; float: right;"
										alt="Edit" id="mortgEditRemarks" tabindex="605"/>
								</div>
							</td>
						</tr>
					</table>
					<input id="hidMorgCd" name="hidMorgCd" type="hidden">
					<input id="hidMorgId" name="hidMorgId" type="hidden">
					<input id="hidMorgName" name="hidMorgName" type="hidden">
				</div>
				<div id="mortgageeInformationButtonsDiv"
					name="mortgageeInformationButtonsDiv" class="buttonsDiv"
					style="margin-bottom: 10px;">
					<input id="btnAddMortgagee" name="btnAddMortgagee" type="button"
						class="button" value="Add"style="width: 90px;" tabindex="606"> <input id="btnDeleteMortgagee"
						name="btnDeleteMortgagee" type="button" class="button"
						value="Delete"style="width: 90px;" tabindex="607">
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	try {
		disableButton("btnDeleteMortgagee");
		var mortgageeItems = {};

		initializeAll();
		initializeAccordion();
		initializeAllMoneyFields();
		objQuote.objMortgagee = [];
		objQuote.selectedMortgageeIndex = -1;
		var mortgageeListMain = new Object();
		mortgageeListMain.mortgageeListMainTableGrid = JSON
				.parse('${mortgageeList}');
		mortgageeListMain.mortgageeListMain = mortgageeListMain.mortgageeListMainTableGrid
				|| [];
		var mortgageeListTableModel = {
			url : contextPath
					+ "/GIPIQuoteItmMortgageeController?action=getMortgageeList&refresh=1&quoteId="
					+ objGIPIQuote.quoteId + "&itemNo=" + $("itemNoHid").value
					+ "&issCd=" + objGIPIQuote.issCd,
			options : {
				title : '',
				height : '206px',
				width : '900px',
				onCellFocus : function(element, value, x, y, id) {
					mortgageeTableGrid.keys.releaseKeys();
					mortgageeListMain.selectedMortgageeIndex = y;
					objQuote.selectedMortgageeInfoRow = mortgageeTableGrid.geniisysRows[y];
					mortgDetails(mortgageeTableGrid.geniisysRows[y]);
					enableButton("btnDeleteMortgagee");
				},
				prePager : function() {
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					mortgageeTableGrid.keys.releaseKeys();
					objQuote.selectedMortgageeIndex = -1;
					objQuote.selectedMortgageeInfoRow = "";
					clearDetails();
					disableButton("btnDeleteMortgagee");
				},
				onRowDoubleClick : function(y) {
				},
				beforeSort: function(){
					if (changeTag == 1){
						showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", objQuoteGlobal.saveAllQuotationInformation, showQuotationInformation,"");
						return false;
					} else {
						return true;
					}
				},
				onSort : function() {
					objQuote.selectedMortgageeIndex = -1;
                	//objQuote.selectedMortgageeInfoRow = "";
				},
				toolbar : {
					elements : [ MyTableGrid.REFRESH_BTN,
							MyTableGrid.FILTER_BTN ],
					onRefresh : function() {
						objQuote.selectedMortgageeIndex = -1;
						objQuote.selectedMortgageeInfoRow = "";
					} 
				}
			},
			columnModel : [ {
				id : 'recordStatus',
				width : '0px',
				visible : false,
				editor : 'checkbox'
			}, {
				id : 'divCtrId',
				width : '0px',
				visible : false
			},  {
				id : 'itemNo',
				title : 'Item No',
				titleAlign : 'right',
				width : '52px',
				align : 'right',
				renderer : function(value) {
					return lpad(value.toString(), 5, "0");
				}
			}, {
				id : 'mortgCd',
				title : 'Code',
				titleAlign: 'left',
				align: 'left',
				width : '100px',
				filterOption : true
			}, {
				id : 'mortgName',
				title : 'Mortagee',
				titleAlign: 'left',
				align: 'left',
				width : '330px',
				filterOption : true
			}, {
				id : 'amount',
				title : 'Amount',
				width : '150px',
				geniisysClass : 'money',
				titleAlign : 'right',
				align : 'right'
			},{
				id : 'remarks',
				title: 'Remarks',
				titleAlign: 'left',
				align: 'left',
				sortable: false,
				width: '250px'
			}, {
				id : 'mortgageeId',
				width : '0px',
				visible: false
			} ],
			rows : mortgageeListMain.mortgageeListMainTableGrid.rows,
			id: 25
		};
		mortgageeTableGrid = new MyTableGrid(mortgageeListTableModel);
		mortgageeTableGrid.pager = mortgageeListMain.mortgageeListMainTableGrid;
		mortgageeTableGrid.render('mortgageeTableGrid');
		mortgageeTableGrid.afterRender = function(){
			objQuote.objMortgagee = mortgageeTableGrid.geniisysRows;
		};
	} catch (e) {
		showErrorMessage("mortgagee.jsp", e);
	}

	$("searchMortgageeName").observe("click", function() {
		if (objQuote.selectedItemInfoRow == null
				|| objQuote.selectedItemInfoRow == "") {
			showMessageBox("Please select an item first.", "I");
		} else {
			getMortgageeLOV2();
		}
	});
	
	$("searchMortgageeName").observe("keypress", function (event) {
		if (event.keyCode == 13){
			if (objQuote.selectedItemInfoRow == null
					|| objQuote.selectedItemInfoRow == "") {
				showMessageBox("Please select an item first.", "I");
			} else {
				getMortgageeLOV2();
			}
		}
	});

	function getMortgageeLOV2() {
		var notIn = [];
		var withPrevious = false;
		try {
			for ( var i = 0; i < objQuote.objMortgagee.length; i++) {
				if (objQuote.objMortgagee[i].recordStatus != -1) {
					notIn += withPrevious ? "," : "";
					notIn = notIn + objQuote.objMortgagee[i].mortgageeId;
					withPrevious = true;
				}
			}
			LOV.show({
				controller : "MarketingLOVController",
				urlParameters : {
					action : "getMortgageeLOV2",
					issCd : objGIPIQuote.issCd,
					notIn : notIn != null ? notIn : null,
					page : 1
				},
				title : "Mortgagee",
				width : 631,
				height : 386,
				columnModel : [ {
					id : "mortgCd",
					title : "Mortgagee Code",
					width : '200px'
				}, {
					id : "mortgName",
					title : "Mortgagee Name",
					width : '400pxx'
				},{
					id: "mortgageeId",
					width: '0px',
					visible: false
				} ],
				draggable : true,
				onSelect : function(row) {
					if (row != undefined) {
						$("hidMorgCd").value = unescapeHTML2(row.mortgCd);
						$("txtMortgCd").value = unescapeHTML2(row.mortgCd)+" - "+unescapeHTML2(row.mortgName);
						//$("txtMortgName").value = unescapeHTML2(row.mortgName);
						$("hidMorgId").value = row.mortgageeId;
						$("hidMorgName").value = unescapeHTML2(row.mortgName);
					}
				}
			});

		} catch (e) {
			showErrorMessage("getMortgageeLOV", e);
		}
	}

	//$("mortItemNo").value = $F("txtItemNo");

	$("btnAddMortgagee").observe("click", function() {
		addMortgagee();

	});

	$("btnDeleteMortgagee").observe("click", function() {
		deleteMortgagee();
	});

	function addMortgagee() {
		try {
			if (objQuote.selectedItemInfoRow == null
					|| objQuote.selectedItemInfoRow == "") {
				showMessageBox("Please select an item first.", "I");
			} else {
				if (checkAllRequiredFieldsInDiv("mortgageeInformationTextDiv")) {
					var rowObj = setObjMortg($("btnAddMortgagee").value);
					if ($("btnAddMortgagee").value == "Add") {
						mortgageeItems.newMortgagee = [];
						objQuote.objMortgagee.push(rowObj);
						mortgageeItems.newMortgagee.push(rowObj);
						mortgageeTableGrid.addBottomRow(rowObj);
						if (mortgageeTableGrid.getModifiedRows().length == 0
								&& mortgageeTableGrid.getNewRowsAdded().length == 0
								&& mortgageeTableGrid.getDeletedRows().length == 0) {
						}
					} else {
						objQuote.objMortgagee.splice(
								mortgageeListMain.selectedMortgageeIndex, 1,
								rowObj);
						mortgageeTableGrid.updateVisibleRowOnly(rowObj,
								mortgageeListMain.selectedMortgageeIndex);
						if (mortgageeTableGrid.getModifiedRows().length == 0
								&& mortgageeTableGrid.getNewRowsAdded().length == 0
								&& mortgageeTableGrid.getDeletedRows().length == 0) {
						}
					}
					clearDetails();
					clearChangeAttribute("mortgageeInformation");
				} else {
					showMessageBox(objCommonMessage.REQUIRED, "I");
				}
			}
			disableButton("btnDeleteMortgagee");
		} catch (e) {
			showErrorMessage("addMortgagee", e);
		}
	}

	function deleteMortgagee() {
		try {
			var delObj = setObjMortg("Delete");
			objQuote.objMortgagee.splice(
					mortgageeListMain.selectedMortgageeIndex, 1, delObj);
			mortgageeTableGrid
					.deleteRow(mortgageeListMain.selectedMortgageeIndex);

			if (mortgageeTableGrid.getModifiedRows().length == 0
					&& mortgageeTableGrid.getNewRowsAdded().length == 0
					&& mortgageeTableGrid.getDeletedRows().length == 0) {
			} else {
				changeTag = 1;				
			}
			clearDetails();
			disableButton("btnDeleteMortgagee");
		} catch (e) {
			showErrorMessage("deleteMortgagee", e);
		}
	}
	$("mortgEditRemarks").observe("click", function() {
		if (objQuote.selectedItemInfoRow == null
				|| objQuote.selectedItemInfoRow == "") {
			showMessageBox("Please select an item first.", "I");
		} else {
			showEditor("mortgRemarks", 50, "false");
		}		
	});
	
	$("mortgEditRemarks").observe("keypress", function (event) {
		if (event.keyCode == 13){
			if (objQuote.selectedItemInfoRow == null
					|| objQuote.selectedItemInfoRow == "") {
				showMessageBox("Please select an item first.", "I");
			} else {
				showEditor("mortgRemarks", 50, "false");
			}	
		}
	});
	
	function mortgDetails(obj) {
		try {
			$("searchMortgageeName").hide();
			$("txtMortgCd").value = nvl(unescapeHTML2(obj.mortgCd), "")+" - "+nvl(unescapeHTML2(obj.mortgName), "");
			//$("txtMortgName").value = nvl(unescapeHTML2(obj.mortgName), "");
			$("mortgAmount").value = formatCurrency(nvl(obj.amount, "0.00"));
			$("mortgRemarks").value = nvl(unescapeHTML2(obj.remarks), "");
			$("hidMorgId").value = obj.mortgageeId;
			$("hidMorgCd").value = nvl(unescapeHTML2(obj.mortgCd),"");
			$("hidMorgName").value = nvl(unescapeHTML2(obj.mortgName),"");
			$("btnAddMortgagee").value = "Update";
		} catch (e) {
			showErrorMessage("mortgDetails", e);
		}
	}

	function setObjMortg(func) {
		mortgageeItems.newMortgagee = [];
		mortgageeItem = new Object();
		mortgageeItem.quoteId = objGIPIQuote.quoteId;
		mortgageeItem.issCd = unescapeHTML2(objGIPIQuote.issCd);
		mortgageeItem.mortgCd = unescapeHTML2($F("hidMorgCd"));
		mortgageeItem.mortgName = unescapeHTML2($F("hidMorgName"));
		mortgageeItem.itemNo = objQuote.selectedItemInfoRow.itemNo;
		mortgageeItem.amount = $F("mortgAmount");
		mortgageeItem.remarks = unescapeHTML2($F("mortgRemarks"));
		mortgageeItem.mortgageeId = $F("hidMorgId");
		mortgageeItem.recordStatus = func == "Delete" ? -1 : func == "Add" ? 0
				: 1;
		return mortgageeItem;
	}

	function clearDetails() {
		try {
			$("searchMortgageeName").show();
			$("txtMortgCd").value = "";
			//$("txtMortgName").value = "";
			$("mortgAmount").value = "0.00";
			$("mortgRemarks").value = "";
			$("btnAddMortgagee").value = "Add";
		} catch (e) {
			showErrorMessage("clearDetails", e);
		}
	}

	$("mortgAmount").observe(
			"change",
			function() {
				if (objQuote.selectedItemInfoRow == null
						|| objQuote.selectedItemInfoRow == "") {
					showMessageBox("Please select an item first.", "I");
					$("mortgAmount").clear();
				} else {
					if (isNaN($F("mortgAmount"))
							|| $F("mortgAmount") > 100000000000000) {
						$("mortgAmount").clear();
						customShowMessageBox(
								"Field must be of form 99,999,999,999,999.99.",
								"E", "mortgAmount");
					} else if ($F("mortgAmount") < 0) {
						$("mortgAmount").clear();
						customShowMessageBox(
								"Must be in range 0.00 to 99,999,999,999,999.99.",
								"E", "mortgAmount");
					}
				}
				
			});
	
	$("mortgRemarks").observe("change",function(){
		if (objQuote.selectedItemInfoRow == null
				|| objQuote.selectedItemInfoRow == "") {
			showMessageBox("Please select an item first.", "I");
			$("mortgRemarks").clear();
		} else {
		}
	});
	
</script>