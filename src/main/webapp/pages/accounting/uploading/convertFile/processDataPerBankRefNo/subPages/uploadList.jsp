<!-- Created by Deo [10.06.2016] -->
<div id="uploadList" name="uploadList">
	<div class="sectionDiv" id="uploadListDiv"
		style="height: 331px; width: 698px;">
		<div id="uploadListTable" style="height: 331px; padding: 1px;"></div>
	</div>
	<center>
		<input type="button" class="button" value="Ok" id="btnOk" style="margin-top: 10px; width: 100px;" tabindex="2001"/>
		<input type="button" class="button" value="Return" id="btnReturn" style="margin-top: 10px; width: 100px;" tabindex="2002"/>
		<input type="button" class="button" value="Check All" id="btnCheckAll" style="margin-top: 10px; width: 100px;" tabindex="2003"/>
	</center>
</div>
<script type="text/javascript">
	initializeAll();
	$("btnOk").focus();
	
	$("btnOk").observe("click", function(){
		if (taggedRows.length == 0) {
			showMessageBox("No record(s) tagged for upload.", "E");
		} else {
			uploadListTG.onRemoveRowFocus();
			checkValidated();
		}
	});
	
	$("btnReturn").observe("click", function() {
		overlayUploadList.close();
		delete overlayUploadList;
	});
	
	$("btnCheckAll").observe("click", function() {
		checkOrUncheckAll(this.value);
		if (this.value == 'Check All') {
			this.value = 'Uncheck All';
		} else {
			this.value = 'Check All';
		}
	});
	
	var taggedRows = [];
	validRecords = JSON.parse('${validRecords}');
	tagValidRows();
	
	function tagValidRows() {
		for (var i = 0; i < validRecords.rows.length; i++) {
			addRow(validRecords.rows[i]);
		}
	}
	
	objUploadList = {};
	objUploadList.giacs610RecList = JSON.parse('${gupr}');
	var currRow = null;

	try {
		var uploadListTable = {
			url : contextPath
					+ "/GIACUploadingController?action=showGiacs610RecList&refresh=1&fileNo="
					+ guf.fileNo + "&sourceCd=" + guf.sourceCd,
			options : {
				width : '696px',
				pager : {},
				onCellFocus : function(element, value, x, y, id) {
					currRow = uploadListTG.geniisysRows[y];
				},
				onRemoveRowFocus : function(){
					uploadListTG.keys.removeFocus(uploadListTG.keys._nCurrentFocus, true);
					uploadListTG.keys.releaseKeys();
				},
				toolbar : {
					elements : [ MyTableGrid.FILTER_BTN,
					             MyTableGrid.REFRESH_BTN ]
				},
				onSort : function() {
					checkTaggedRows();
				},
				onRefresh : function() {
					taggedRows = [];
					tagValidRows();
					checkTaggedRows();
					toggleBtnCheck();
				},
				postPager : function() {
					checkTaggedRows();
					toggleBtnCheck();
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
			columnModel : [ {
				id : 'recordStatus',
				width : '0',
				visible : false
			}, {
				id : 'divCtrId',
				width : '0',
				visible : false
			}, {
				id : 'includeSw',
				title : '&#160;&#160;I',
				altTitle : 'Include',
				titleAlign : "center",
				width : '23px',
				sortable : false,
				editable : true,
				editor : new MyTableGrid.CellCheckbox({
					onClick : function(value) {
						observeChkBox(value);
					},
					getValueOf : function(value) {
						return value ? "Y" : "N";
					}
				})
			}, {
				id : 'bankRefNo',
				filterOption : true,
				title : 'Bank Reference Number',
				align : "center",
				titleAlign : "center",
				width : '175px'
			}, {
				id : 'collectionAmt',
				filterOption : true,
				filterOptionType : 'number',
				title : 'Collection Amt',
				align : "right",
				titleAlign : "center",
				width : '120px',
				renderer : function(value) {
					return formatCurrency(value);
				}
			}, {
				id : 'premChkFlag',
				filterOption : true,
				title : 'P',
				altTitle : 'Premium Check Flag',
				width : '24px',
				align : "center"
			}, {
				id : 'chkRemarks',
				filterOption : true,
				title : 'Checking Results',
				align : "left",
				titleAlign : "center",
				width : '338px'
			}, ],
			rows : objUploadList.giacs610RecList.rows
		};

		uploadListTG = new MyTableGrid(uploadListTable);
		uploadListTG.pager = objUploadList.giacs610RecList;
		uploadListTG.render("uploadListTable");

		uploadListTG.afterRender = function() {
			checkTaggedRows();
		};
	} catch (e) {
		showErrorMessage("uploadListTable", e);
	}

	function observeChkBox(value) {
		if (value == "Y") {
			addRow(currRow);
		} else {
			deleteRow(currRow.recId);
		}
		toggleBtnCheck();
	}

	function addRow(obj) {
		var row = new Object();

		if (!inTaggedRows(obj.recId)) {
			row.recId = obj.recId;
			row.validSw = obj.validSw;
			row.claimSw = obj.claimSw;
			taggedRows.push(row);
		}
	}

	function deleteRow(recId) {
		if (inTaggedRows(recId)) {
			for (var i = 0; i < taggedRows.length; i++) {
				if (recId == taggedRows[i].recId) {
					taggedRows.splice(i, 1);
				}
			}
		}
	}

	function inTaggedRows(recId) {
		var exists = false;
		for (var i = 0; i < taggedRows.length; i++) {
			if (recId == taggedRows[i].recId) {
				exists = true;
				break;
			}
		}
		return exists;
	}
	
	function checkTaggedRows() {
		try {
			var colIndex = uploadListTG.getColumnIndex("includeSw");
			var mtgId = uploadListTG._mtgId;

			for (var i = 0; i < uploadListTG.rows.length; i++) {
				if (inTaggedRows(uploadListTG.geniisysRows[i].recId)) {
					$('mtgInput' + mtgId + '_' + colIndex + ',' + i).checked = true;
					$('mtgIC' + mtgId + '_' + colIndex + ',' + i).addClassName(
							'modifiedCell');
				} else {
					if ($('mtgInput' + mtgId + '_' + colIndex + ',' + i).checked) {
						$('mtgInput' + mtgId + '_' + colIndex + ',' + i).checked = false;
						$('mtgIC' + mtgId + '_' + colIndex + ',' + i)
								.removeClassName('modifiedCell');
					}
				}
				if (uploadListTG.geniisysRows[i].validSw == "N") {
					$('mtgRow' + mtgId + '_' + i).style.color = "#FF6633";
				}
			}
		} catch (e) {
			showErrorMessage("checkTaggedRows", e);
		}
	}
	
	function checkOrUncheckAll(value) {
		try {
			var colIndex = uploadListTG.getColumnIndex("includeSw");
			var mtgId = uploadListTG._mtgId;

			for (var i = 0; i < uploadListTG.rows.length; i++) {
				if (value == "Check All") {
					addRow(uploadListTG.geniisysRows[i]);
					$('mtgInput' + mtgId + '_' + colIndex + ',' + i).checked = true;
					$('mtgIC' + mtgId + '_' + colIndex + ',' + i).addClassName(
							'modifiedCell');
				} else {
					deleteRow(uploadListTG.geniisysRows[i].recId);
					$('mtgInput' + mtgId + '_' + colIndex + ',' + i).checked = false;
					$('mtgIC' + mtgId + '_' + colIndex + ',' + i)
							.removeClassName('modifiedCell');
				}
			}
		} catch (e) {
			showErrorMessage("checkOrUncheckAll", e);
		}
	}
	
	function toggleBtnCheck() {
		var cntTagged = 0;
		var colIndex = uploadListTG.getColumnIndex("includeSw");
		var mtgId = uploadListTG._mtgId;
		for (var i = 0; i < uploadListTG.rows.length; i++) {
			if ($('mtgInput' + mtgId + '_' + colIndex + ',' + i).checked) {
				cntTagged = cntTagged + 1;
			}
		}
		if (cntTagged == uploadListTG.rows.length) {
			$("btnCheckAll").value = "Uncheck All";
		} else if (cntTagged == 0) {
			$("btnCheckAll").value = "Check All";
		}
	}
	
	function checkValidated() {
		try {
			new Ajax.Request(
					contextPath + "/GIACUploadingController",
					{
						method : "POST",
						parameters : {
							action : "checkValidatedGiacs610",
							sourceCd : guf.sourceCd,
							fileNo : guf.fileNo
						},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response) {
							hideNotice();
							if (checkCustomErrorOnResponse(response)
									&& checkErrorOnResponse(response)) {
								var arrMessage = response.responseText.split("#");
								message = "A JV transaction will be created for "
										+ arrMessage[1]
										+ " branch. The indicated date in the JV Details will be used for the transaction. Do you wish to proceed?";
								showConfirmBox2("Confirmation", message, "Yes", "No",
										function() {
											objGIACS610.branchCd = arrMessage[3].trim();
											showBankAcctWindow(objGIACS610.branchCd);
										}, null);
							}
						}
					});
		} catch (e) {
			showErrorMessage("checkValidated", e);
		}
	}
	
	function showBankAcctWindow(branchCd) {
		try {
			var objTaggedRows = new Object();
			objTaggedRows = taggedRows;
			
			overlayBank = Overlay.show(
					contextPath + "/GIACUploadingController", {
						urlContent : true,
						urlParameters : {
							action : "showGiacs610DefaultBank",
							branchCd : branchCd,
							processAll : "N",
							parameters : prepareJsonAsParameter(objTaggedRows),
							ajax : "1"
						},
						title : "Bank Account Details",
						height : 170,
						width : 458,
						draggable : true
					});
		} catch (e) {
			showErrorMessage("showBankAcctWindow", e);
		}
	}
	
	$("uploadList").observe("keydown", function(event){
		var curEle = document.activeElement.id;
		if (event.keyCode == 9 && !event.shiftKey) {
			if (curEle == "btnCheckAll") {
				$("btnOk").focus();
				event.preventDefault();
			}
		} else if (event.keyCode == 9 && event.shiftKey) {
			if (curEle == "btnOk") {
				$("btnCheckAll").focus();
				event.preventDefault();
			}
		}
	});
</script>