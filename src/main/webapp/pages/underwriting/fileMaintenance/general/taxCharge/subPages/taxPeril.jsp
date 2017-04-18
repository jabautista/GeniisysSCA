<div id="perilDiv" name="perilDiv" style="width: 463px; height: 410px;">
	<div class="sectionDiv" style="width: 470px; margin: 10px; margin-left: 0px; margin-bottom: 0px; height:425px;">
		<div id="perilTable" style="height: 340px; margin: 10px; margin-bottom: 0px;"></div>
		<div id="perilDivForm" name="perilDivForm" style="width: 470px;" align="center">
			<table>	 			
				<tr>
					<td class="rightAligned" style="padding-right: 5px;">Peril</td>
					<td class="leftAligned">
						<span class="lovSpan required" style="width: 357px; margin-top: 2px; height: 21px;">
							<input class="required allCaps" type="text" id="txtTaxPeril" name="txtTaxPeril" style="width: 330px; border: none; height: 15px; margin: 0;" maxlength="20" tabindex="401" lastValidValue=""/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchTaxPerilLOV" name="searchTaxPerilLOV" alt="Go" style="float: right;" tabindex="402"/>
						</span>
					</td>						
				</tr>
				</table>
 			<div align="center" style="margin-top: 5px;">
				<table width="470px">
					<td class="rightAligned"><input type="button" class="button" style="width: 80px;" id="btnAddPeril" name="btnAddPeril" value="Add" tabindex="403"/></td>
					<td><input type="button" class="button" style="width: 80px;" id="btnDeletePeril" name="btnDeletePeril" value="Delete" tabindex="404"/></td>
				</table>
			</div>
		</div>
	</div>

	<div class="buttonsDiv" style="margin-left: 5px; margin-bottom: 0px;">
		<input type="button" class="button" style="width: 100px;" id="btnCancelPeril" name="btnCancelPeril" value="Cancel" tabindex="405"/>
		<input type="button" class="button" style="width: 100px;" id="btnSavePeril" name="btnSavePeril" value="Save" tabindex="406"/>
	</div>
</div>

<script type="text/JavaScript">
	initializeAll();
	initializeAccordion();
	makeInputFieldUpperCase();
	changeTag = 0;
	var rowIndex = -1;
	objGIISS028.exitPerilPage = null;
	var objPerilMain = null;
	perilCd = "";
	lastValidPerilCd = "";
	var notIn = "";
	
	function saveGiiss028Dtl() {
		if (changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(perilTableGrid.geniisysRows);
		var delRows = getDeletedJSONObjects(perilTableGrid.geniisysRows);
		
		new Ajax.Request(contextPath + "/GIISTaxChargesController", {
			method : "POST",
			parameters : {
				action : "saveGiiss028Dtl",
				setRows : prepareJsonAsParameter(setRows),
				delRows : prepareJsonAsParameter(delRows)
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete : function(response) {
				hideNotice();
				if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)) {
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function() {
						if (objGIISS028.exitPerilPage != null) {
							objGIISS028.exitPerilPage();
							objGIISS028.exitPerilPage = null;
						} else {
							perilTableGrid._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	} 
	
	try {
		var objTaxPeriDtl = [];
		var objPeril = new Object();
		objPeril.objPerilListing = JSON.parse('${jsonTaxPerilList}'.replace(/\\/g, '\\\\'));
		objPeril.objPerilMaintain = objPeril.objPerilListing.rows || [];

		var periTable = {
			 url : contextPath+"/GIISTaxChargesController?action="+ "getTaxPeril" + "&issCd=" + encodeURIComponent($F("txtIssCd")) + "&lineCd=" + encodeURIComponent($F("txtLineCd")) + "&taxCd=" + taxCd + "&taxId=" + taxId+ "&refresh=" + 1,
			options : {
				width : '450px',
				height : '308px',
				onCellFocus : function(element, value, x, y, id) {
					rowIndex = y;
					objPerilMain = perilTableGrid.geniisysRows[y];
					perilTableGrid.keys.releaseKeys();
					populatePerilInfo(objPerilMain);
				},
				onRemoveRowFocus : function() {
					onRemove();
				},
				beforeSort : function() {
					if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
                	}
				},
				onSort : function() {
					onRemove();
				},
				prePager: function(){
	            	if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
                	} else {	          
                		onRemove();
                	}
                },
                onRefresh: function(){
                	onRemove();
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
						if (changeTag == 1){
	                		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
							return false;
	                	} else {
	                		onRemove();
	                	}
					}
				}
			},
			columnModel : [ {
				id : 'recordStatus',
				title : '',
				width : '0',
				visible : false,
				editor : 'checkbox'
			}, {
				id : 'divCtrId',
				width : '0',
				visible : false
			}, {
				id : 'perilName',
				title : 'Peril',
				titleAlign: 'left',
				width : '425px',
				visible : true,
				filterOption : true
			}],
			rows : objPeril.objPerilMaintain
		};
		perilTableGrid = new MyTableGrid(periTable);
		perilTableGrid.pager = objPeril.objPerilListing;
		perilTableGrid.render('perilTable');
		perilTableGrid.afterRender = function() {
			objTaxPeriDtl = perilTableGrid.geniisysRows;
			changeTag = 0;
			if (perilTableGrid.geniisysRows.length > 0){
				notIn = unescapeHTML2(perilTableGrid.geniisysRows[0].notIn);
			}
		};
	} catch (e) {
		showErrorMessage("Peril Tax Table Grid", e);
	}
	
	function showPerilTaxLOV(isIconClicked) {
		try {
			var searchString = isIconClicked ? "%" : ($F("txtTaxPeril").trim() == "" ? "%" : $F("txtTaxPeril"));

			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGiiss028TaxPerilLOV",
					searchString : searchString,
					lineCd : unescapeHTML2($F("txtLineCd")),
					notIn : nvl(notIn, ""),
					issCd : unescapeHTML2($F("txtIssCd")),
					taxCd : taxCd,
					taxId : taxId
				},
				title : "List of Perils",
				width : 415,
				height : 386,
				columnModel : [ {
					id : "perilCd",
					title : "Peril Cd",
					width : '70px',
					titleAlign: 'right',
					align: 'right'
				}, {
					id : "perilName",
					title : "Peril Name",
					width : '255px'
				}, {
					id : "sublineCd",
					title : "Subline Cd",
					width : '70px'
				} ],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : escapeHTML2(searchString),
				onSelect : function(row) {
					if (row != null || row != undefined) {
						$("txtTaxPeril").value = unescapeHTML2(row.perilName);
						$("txtTaxPeril").setAttribute("lastValidValue", unescapeHTML2(row.perilName));
						perilCd = row.perilCd;
						lastValidPerilCd = row.perilCd;
					}
				},
				onCancel : function() {
					$("txtTaxPeril").focus();
					$("txtTaxPeril").value = $("txtTaxPeril").readAttribute("lastValidValue");
					perilCd = lastValidPerilCd;
				},
				onUndefinedRow : function() {
					$("txtTaxPeril").value = $("txtTaxPeril").readAttribute("lastValidValue");
					perilCd = lastValidPerilCd;
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtTaxPeril");
				}
			});
		} catch (e) {
			showErrorMessage("showTaxLOV", e);
		}
	}
	
	function prepareNotInParam(){
		var withPrevious = false;
		for(var i = 0; i < objTaxPeriDtl.length; i++){
			if(objTaxPeriDtl[i].recordStatus != -1){
				if(withPrevious){
					notIn += ",";
				}
				notIn += "'" + objTaxPeriDtl[i].perilCd + "'";
				withPrevious = true;
			}
		}
	} 
	
	$("searchTaxPerilLOV").observe("click", function() {
		showPerilTaxLOV(true);
	});

	$("txtTaxPeril").observe("change", function() {
		if (this.value != "") {
			showPerilTaxLOV(false);
		} else {
			$("txtTaxPeril").value = "";
			$("txtTaxPeril").setAttribute("lastValidValue", "");
			perilCd = "";
			lastValidPerilCd= "";
		}
	});

	function populatePerilInfo(rec){
		try{
			$("txtTaxPeril").value	= rec	== null ? "" : unescapeHTML2(rec.perilName); 
			perilCd 				= rec == null ? "" :rec.perilCd;
			lastValidPerilCd 		= rec == null ? "" :rec.perilCd;
			
			rec == null ? enableButton("btnAddPeril") : disableButton("btnAddPeril");
			rec == null ? $("txtTaxPeril").readOnly = false : $("txtTaxPeril").readOnly = true;
			rec == null ? disableButton("btnDeletePeril") : enableButton("btnDeletePeril");
			rec == null ? enableSearch("searchTaxPerilLOV") : disableSearch("searchTaxPerilLOV");
			objPerilMain = rec;
			
		}catch(e){
			showErrorMessage("populatePerilInfo", e);
		}
	}
	
	function setRec(rec) {
		try {
			var obj = (rec == null ? {} : rec);
			obj.issCd = escapeHTML2($F("txtIssCd"));
			obj.lineCd = escapeHTML2($F("txtLineCd"));
			obj.taxCd = taxCd;
			obj.taxId = taxId;
			obj.perilCd = perilCd;
			obj.perilName = escapeHTML2($F("txtTaxPeril"));
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch (e) {
			showErrorMessage("setRec", e);
		}
	}

	function addPerilRec() {
		try {
			changeTagFunc = saveGiiss028Dtl;
			var taxPerilAdd = setRec(objPerilMain);
			notIn += (notIn == '' ? taxPerilAdd.perilCd : "," + taxPerilAdd.perilCd);
			perilTableGrid.addBottomRow(taxPerilAdd);
			changeTag = 1;
			populatePerilInfo(null);
			perilTableGrid.keys.removeFocus(perilTableGrid.keys._nCurrentFocus, true);
			perilTableGrid.keys.releaseKeys();
			$("txtTaxPeril").value = "";
			$("txtTaxPeril").setAttribute("lastValidValue", "");
			perilCd = "";
			lastValidPerilCd = "";
		} catch (e) {
			showErrorMessage("addRec", e);
		}
	}
	
	function deletePerilRec() {
		if(notIn.contains(","+perilTableGrid.geniisysRows[rowIndex].perilCd)){
			notIn = notIn.replace(","+perilTableGrid.geniisysRows[rowIndex].perilCd, '');
		} else if(notIn.contains(perilTableGrid.geniisysRows[rowIndex].perilCd+",")){
			notIn = tranNotIn.replace(perilTableGrid.geniisysRows[rowIndex].perilCd+",", '');
		} else if(notIn.contains(perilTableGrid.geniisysRows[rowIndex].perilCd)){
			notIn = notIn.replace(perilTableGrid.geniisysRows[rowIndex].perilCd, '');
		}
		
		changeTagFunc = saveGiiss028Dtl;
		objPerilMain.recordStatus = -1;
		perilTableGrid.deleteRow(rowIndex);
		changeTag = 1;
		populatePerilInfo(null);
	}
	
	function onRemove(){
		rowIndex = -1;
		perilTableGrid.keys.removeFocus(perilTableGrid.keys._nCurrentFocus, true);
		perilTableGrid.keys.releaseKeys();
		populatePerilInfo(null);
		$("txtTaxPeril").focus();
	}
	
	function exitPage() {
		overlayTax.close();
	}
	
	function cancelGiiss028() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function() {
				objGIISS028.exitPerilPage = exitPage;
				saveGiiss028Dtl();
			}, function() {
				changeTag = 0;
				exitPage();
			}, "");
		} else {
			exitPage();
		}
	}
	
	$("btnDeletePeril").observe("click", deletePerilRec);
	$("btnCancelPeril").observe("click", cancelGiiss028);
	$("txtTaxPeril").focus();
	disableButton("btnDeletePeril");
	
	observeSaveForm("btnSavePeril", saveGiiss028Dtl);
	
	$("btnAddPeril").observe("click", function (){
		if(checkAllRequiredFieldsInDiv("perilDivForm")){
			addPerilRec();
		}
	});
</script>