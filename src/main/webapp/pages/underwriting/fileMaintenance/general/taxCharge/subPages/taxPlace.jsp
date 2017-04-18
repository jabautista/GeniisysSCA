<div id="placeDiv" name="placeDiv" style="width: 463px; height: 43px;">
	<div class="sectionDiv" style="width: 470px; margin: 10px; margin-left: 0px; margin-bottom: 0px; height:425px;">
		<div id="placeTabe" style="height: 340px; margin: 10px; margin-bottom: 0px;"></div>
		<div id="placeDivForm" name="placeDivForm" style="width: 470px;" align="center">
			<table>	 			
				<tr>
					<td class="rightAligned">Place</td>
					<td class="leftAligned">
						<span class="lovSpan required" style="width: 250px; margin-top: 2px; height: 21px;">
							<input class="required allCaps" type="text" id="txtPlace" name="txtPlace" style="width: 225px; border: none; height: 15px; margin: 0;" maxlength="20" tabindex="350" lastValidValue="" ignoreDelKey="1"/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchPlaceLOV" name="searchPlaceLOV" alt="Go" style="float: right;" tabindex="351"/>
						</span>
					</td>	
					<td class="rightAligned" style="padding-left: 15px;">Rate</td>
					<td class="leftAligned">
					<input id="txtPlaceRate"" type="text" class="applyDecimalRegExp2 required" hasOwnKeyUp="N" hasOwnBlur="N" hasOwnChange="N" customLabel="Rate" max="100.00" min="0.01" regexppatt="pDeci0302" hideErrMsg="Y" name="txtPlaceRate" style="width: 100px; height: 15px; margin: 0; text-align: right;" tabindex="352"></td>
					</td>						
				</tr>
				</table>
 			<div align="center" style="margin-top: 5px;">
				<table width="470px">
					<td class="rightAligned"><input type="button" class="button" style="width: 80px;" id="btnAddPlace" name="btnAddPlace" value="Add" tabindex="353"/></td>
					<td><input type="button" class="button" style="width: 80px;" id="btnDeletePlace" name="btnDeletePlace" value="Delete" tabindex="354"/></td>
				</table>
			</div>
		</div>
	</div>

	<div class="buttonsDiv" style="margin-left: 5px; margin-bottom: 0px;">
		<input type="button" class="button" style="width: 100px;" id="btnCancelPlace" name="btnCancelPlace" value="Cancel" tabindex="355"/>
		<input type="button" class="button" style="width: 100px;" id="btnSavePlace" name="btnSavePlace" value="Save" tabindex="356"/>
	</div>
</div>

<script type="text/JavaScript">
	initializeAll();
	initializeAccordion();
	initializeAllMoneyFields();
	makeInputFieldUpperCase();
	changeTag = 0;
	var rowIndex = -1;
	objGIISS028.exitPlacePage = null;
	var objPlaceMain = null;
	placeCd = "";
	lastValidPlaceCd = "";
	var notIn = "";
	
	function saveGiiss028TaxPlace() {
		if (changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(placeTableGrid.geniisysRows);
		var delRows = getDeletedJSONObjects(placeTableGrid.geniisysRows);
		
		new Ajax.Request(contextPath + "/GIISTaxChargesController", {
			method : "POST",
			parameters : {
				action : "saveGiiss028TaxPlace",
				setRows : prepareJsonAsParameter(setRows),
				delRows : prepareJsonAsParameter(delRows)
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete : function(response) {
				hideNotice();
				if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)) {
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function() {
						if (objGIISS028.exitPlacePage != null) {
							objGIISS028.exitPlacePage();
							objGIISS028.exitPlacePage = null;
						} else {
							placeTableGrid._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	} 
	
	try {
		var objTaxPlaceDtl = [];
		var objPlace = new Object();
		objPlace.objPlaceListing = JSON.parse('${jsonTaxPlaceList}'.replace(/\\/g, '\\\\'));
		objPlace.objPlaceMaintain = objPlace.objPlaceListing.rows || [];
	
		var periTable = {
			 url : contextPath+"/GIISTaxChargesController?action="+ "getTaxPlaceList" + "&issCd=" + encodeURIComponent($F("txtIssCd")) + "&lineCd=" + encodeURIComponent($F("txtLineCd")) + "&taxCd=" + taxCd + "&taxId=" + taxId+ "&refresh=" + 1,
			options : {
				width : '450px',
				height : '308px',
				onCellFocus : function(element, value, x, y, id) {
					rowIndex = y;
					objPlaceMain = placeTableGrid.geniisysRows[y];
					placeTableGrid.keys.releaseKeys();
					populatePlaceInfo(objPlaceMain);
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
				id : 'place',
				title : 'Place',
				width : '295px',
				filterOption : true
			}, {
				id : 'rate',
				title : 'Rate',
				filterOption : true,
				filterOptionType : 'numberNoNegative',
				titleAlign: 'right',
				align: 'right',
				width : '125px',
				renderer: function(value) {
				  	return formatToNthDecimal(value, 2);
		   		}
			}],
			rows : objPlace.objPlaceMaintain
		};
		placeTableGrid = new MyTableGrid(periTable);
		placeTableGrid.pager = objPlace.objPlaceListing;
		placeTableGrid.render('placeTabe');
		placeTableGrid.afterRender = function() {
			objTaxPlaceDtl = placeTableGrid.geniisysRows;
			changeTag = 0;
			if (placeTableGrid.geniisysRows.length > 0){
				notIn = unescapeHTML2(placeTableGrid.geniisysRows[0].notIn);
			}
		};
	} catch (e) {
		showErrorMessage("Tax Place Table Grid", e);
	}
	
	function showPlaceLOV(isIconClicked) {
		try {
			var searchString = isIconClicked ? "%" : ($F("txtPlace").trim() == "" ? "%" : $F("txtPlace"));
	
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGiiss028TaxPlaceLOV",
					searchString : searchString,
					issCd : unescapeHTML2($F("txtIssCd")),
					notIn : nvl(notIn, ""),
					lineCd : unescapeHTML2($F("txtLineCd")),
					taxCd : taxCd,
					taxId : taxId
				},
				title : "List of Places",
				width : 415,
				height : 386,
				columnModel : [ {
					id : "placeCd",
					width : '0px',
					visible : false
				}, {
					id : "place",
					title : "Place",
					width : '400px'
				} ],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : escapeHTML2(searchString),
				onSelect : function(row) {
					if (row != null || row != undefined) {
						$("txtPlace").value = unescapeHTML2(row.place);
						$("txtPlace").setAttribute("lastValidValue", row.place);
						placeCd = row.placeCd;
						lastValidPlaceCd = row.placeCd;
						$("txtPlaceRate").focus();
					}
				},
				onCancel : function() {
					$("txtPlace").focus();
					$("txtPlace").value = $("txtPlace").readAttribute("lastValidValue");
					placeCd = lastValidPlaceCd;
				},
				onUndefinedRow : function() {
					$("txtPlace").value = $("txtPlace").readAttribute("lastValidValue");
					placeCd = lastValidPlaceCd;
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtPlace");
				}
			});
		} catch (e) {
			showErrorMessage("showPlaceLOV", e);
		}
	}
	
	function prepareNotInParam(){
		var withPrevious = false;
		for(var i = 0; i < objTaxPlaceDtl.length; i++){
			if(objTaxPlaceDtl[i].recordStatus != -1){
				if(withPrevious){
					notIn += ",";
				}
				notIn += "'" + objTaxPlaceDtl[i].place + "'";
				withPrevious = true;
			}
		}
	} 
	
	$("searchPlaceLOV").observe("click", function() {
		showPlaceLOV(true);
	});
	
	$("txtPlace").observe("change", function() {
		if (this.value != "") {
			showPlaceLOV(false);
		} else {
			$("txtPlace").value = "";
			$("txtPlace").setAttribute("lastValidValue", "");
			placeCd = "";
			lastValidPlaceCd= "";
		}
	});
	
	function populatePlaceInfo(rec){
		try{
			$("txtPlace").value			= rec	== null ? "" : unescapeHTML2(rec.place); 
			$("txtPlaceRate").value		= rec	== null ? "" : formatToNthDecimal(rec.rate, 2);
			
			placeCd = rec == null ? "" :rec.placeCd;
			lastValidPlaceCd = rec == null ? "" :rec.placeCd;
			
			rec == null ? $("btnAddPlace").value = "Add" : $("btnAddPlace").value = "Update";
			rec == null ? $("txtPlace").readOnly = false : $("txtPlace").readOnly = true;
			rec == null ? disableButton("btnDeletePlace") : enableButton("btnDeletePlace");
			rec == null ? enableSearch("searchPlaceLOV") : disableSearch("searchPlaceLOV");
			objPlaceMain = rec;
			
		}catch(e){
			showErrorMessage("populatePlaceInfo", e);
		}
	}
	
	function setRec(rec) {
		try {
			var obj = (rec == null ? {} : rec);
			obj.issCd 		= escapeHTML2($F("txtIssCd"));
			obj.lineCd 		= escapeHTML2($F("txtLineCd"));
			obj.taxCd 		= taxCd;
			obj.taxId 		= taxId;
			obj.placeCd 	= placeCd;
			obj.place 		= escapeHTML2($F("txtPlace"));
			obj.rate 		= unformatNumber($F("txtPlaceRate"));
			obj.remarks 	= escapeHTML2($F("txtRemarks"));
			obj.userId 		= userId;
			var lastUpdate 	= new Date();
			obj.lastUpdate 	= dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch (e) {
			showErrorMessage("setRec", e);
		}
	}
	
	function addPlaceRec() {
		try {
			changeTagFunc = saveGiiss028TaxPlace;
			var taxPlaceAdd = setRec(objPlaceMain);
			
			notIn += (notIn == '' ? "'"+taxPlaceAdd.place+"'" : ",'" +taxPlaceAdd.place+"'");
			if ($F("btnAddPlace") == "Add") {
				placeTableGrid.addBottomRow(taxPlaceAdd);
			} else {
				placeTableGrid.updateVisibleRowOnly(taxPlaceAdd, rowIndex, false);
			}
			
			changeTag = 1;
			populatePlaceInfo(null);
			placeTableGrid.keys.removeFocus(placeTableGrid.keys._nCurrentFocus, true);
			placeTableGrid.keys.releaseKeys();
			$("txtPlace").value = "";
			$("txtPlace").setAttribute("lastValidValue", "");
			placeCd = "";
			lastValidPlaceCd = "";
		} catch (e) {
			showErrorMessage("addRec", e);
		}
	}
	
	function valDeleteTaxPlaceRec() {
		try {
			new Ajax.Request(contextPath + "/GIISTaxChargesController", {
				parameters : {
					action : "valDeleteTaxPlaceRec",
					lineCd : unescapeHTML2($F("txtLineCd")),
					issCd : unescapeHTML2($F("txtIssCd")),
					placeCd : placeCd
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response) {
					hideNotice();
					if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
						deletePlaceRec();
					}
				}
			});
		} catch (e) {
			showErrorMessage("valDeleteRec", e);
		}
	}
	
	function deletePlaceRec() {
		if(notIn.contains(",'"+placeTableGrid.geniisysRows[rowIndex].place+"'")){
			notIn = notIn.replace(",'"+placeTableGrid.geniisysRows[rowIndex].place+"'", '');
		}else if(notIn.contains("'"+placeTableGrid.geniisysRows[rowIndex].place+"',")){
			notIn = notIn.replace("'"+placeTableGrid.geniisysRows[rowIndex].place+"',", '');
		}else if(notIn.contains("'"+placeTableGrid.geniisysRows[rowIndex].place+"'")){
			notIn = notIn.replace("'"+placeTableGrid.geniisysRows[rowIndex].place+"'", '');			
		}
		
		changeTagFunc = saveGiiss028TaxPlace;
		objPlaceMain.recordStatus = -1;
		placeTableGrid.deleteRow(rowIndex);
		changeTag = 1;
		populatePlaceInfo(null);
	}
	
	function onRemove(){
		rowIndex = -1;
		placeTableGrid.keys.removeFocus(placeTableGrid.keys._nCurrentFocus, true);
		placeTableGrid.keys.releaseKeys();
		populatePlaceInfo(null);
		$("txtPlace").focus();
	}
	
	function exitPage() {
		overlayTax.close();
	}
	
	function cancelGiiss028() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function() {
				objGIISS028.exitPlacePage = exitPage;
				saveGiiss028TaxPlace();
			}, function() {
				changeTag = 0;
				exitPage();
			}, "");
		} else {
			exitPage();
		}
	}
	
	$("btnDeletePlace").observe("click", valDeleteTaxPlaceRec);
	$("btnCancelPlace").observe("click", cancelGiiss028);
	$("txtPlace").focus();
	disableButton("btnDeletePlace");
	
	observeSaveForm("btnSavePlace", saveGiiss028TaxPlace);
	
	$("btnAddPlace").observe("click", function (){
		if(checkAllRequiredFieldsInDiv("placeDivForm")){
			addPlaceRec();
		}
	});
	
	/* $("txtPlaceRate").observe("change",function(){
		var rateFieldValue = formatToNineDecimal($F("txtPlaceRate"));
		if (rateFieldValue < 0.01 && rateFieldValue != "") {
			customShowMessageBox("Invalid Rate. Valid value should be from 0.01 to 100.00.", imgMessage.INFO, "txtPlaceRate");
			$("txtPlaceRate").value = "";
		}else if ($F("txtPlaceRate") != "" && isNaN($F("txtPlaceRate"))) {
			customShowMessageBox("Invalid Rate. Valid value should be from 0.01 to 100.00.", imgMessage.INFO, "txtPlaceRate");
			$("txtPlaceRate").value = "";
		}else if (rateFieldValue > 100 && rateFieldValue != ""){
			customShowMessageBox("Invalid Rate. Valid value should be from 0.01 to 100.00.", imgMessage.INFO, "txtPlaceRate");
			$("txtPlaceRate").value = "";
		}else if ($F("txtPlaceRate").include("-")){
			customShowMessageBox("Invalid Rate. Valid value should be from 0.01 to 100.00.", imgMessage.INFO, "txtPlaceRate");
			$("txtPlaceRate").value = "";
		}else if ($F("txtPlaceRate") == ""){
			$("txtPlaceRate").value = "";
		}else{
			
			var returnValue = "";
			var amt;
			amt = (($F("txtPlaceRate")).include(".") ? $F("txtPlaceRate") : ($F("txtPlaceRate")).concat(".00")).split(".");
		
			if(2 < amt[1].length){				
				returnValue = amt[0] + "." + amt[1].substring(0, 2);
				customShowMessageBox("Invalid Rate. Valid value should be from 0.01 to 100.00.", imgMessage.INFO, "txtPlaceRate");
				$("txtPlaceRate").value = "";
				
			}else{				
				returnValue = amt[0] + "." + rpad(amt[1], 2, "0");
				$("txtPlaceRate").value = returnValue;
			}
		} 
	}); */
	
</script>