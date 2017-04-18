<div id="engineSeriesMainDiv" style="width: 99.5%; margin-top: 5px;">
    <div class="sectionDiv">
   		<div style="" align="center" id="lovDiv">
			<table cellspacing="2" border="0" style="margin: 10px auto;">
				<tr>
					<td class="rightAligned">Make Code</td>
					<td class="leftAligned">
						<input readonly="readonly" type="text" id="txtMakeCd" name="txtMakeCd" style="width: 60px; float: left; height: 13px; margin-left: 2px; text-align: right;"tabindex="201" value="${makeCd}"/>
					</td>
					<td class="leftAligned">
						<input id="txtMake" name="txtMake" type="text" style="width: 350px; height: 13px;" value="" readonly="readonly" tabindex="202"/>
					</td>
				</tr>	
				<tr>
					<td class="rightAligned">Car Company Code</td>
					<td class="leftAligned">
						<input readonly="readonly" type="text" id="txtCarCompanyCd" name="txtCarCompanyCd" style="width: 60px; float: left; height: 13px; margin-left: 2px; text-align: right;" tabindex="203" value="${carCompanyCd}"/>
					</td>
					<td class="leftAligned">
						<input id="txtCarCompany" name="txtCarCompany" type="text" style="width: 350px; height: 13px;" value="" readonly="readonly" tabindex="204"/>
					</td>
				</tr>
			</table>
		</div>
    </div>
	<div class="sectionDiv" style="padding: 10px 0 10px 10px; height: 350px; width: 98.5%">
		<div>
			<div id="engineTable" style="height: 260px;"></div>
		</div>
		
		<div align="center" id="engineFormDiv">
			<table style="margin-top: 5px;">
				<tr>
					<td class="rightAligned">Series Code</td>
					<td class="leftAligned"><input id="txtSeriesCd" type="text" class="required integerNoNegativeUnformattedNoComma" style="width: 150px; text-align: right; margin-left: 3px;" maxlength="12" lastValidValue="" tabindex="205"></td>
				</tr>
				<tr>
					<td class="rightAligned">Engine Series</td>
					<td class="leftAligned">
						<input id="txtEngineSeries" type="text" class="required upper" style="width: 425px; margin-left: 3px;" maxlength="50" tabindex="206">
						<input id="txtUserId" type="hidden" value="">
					</td>
				</tr>
			</table>
		</div>
		
		<div style="margin: 8px 8px 0px 0px;" align="center">
			<input type="button" class="button" id="btnAddEngine" value="Add" tabindex="207">
			<input type="button" class="disabledButton" id="btnDeleteEngine" value="Delete" tabindex="208">
		</div>
	</div>
</div>
<div align="center">
	<input type="button" class="button" value="Cancel" id="btnCancelEngine" style="margin-top: 5px;" tabindex="209"/>
	<input type="button" class="button" value="Save" id="btnSaveEngine" style="margin-top: 5px;" tabindex="210"/>
</div>

<script type="text/javascript">
	var engineIndex = -1;
	var objEngine = {};
	var selectedEngine = null;
	objEngine.engineList = JSON.parse('${engineJSON}');
	objEngine.exitOverlay = null;
	
	$("txtMake").value = $F("make");
	$("txtCarCompany").value = $F("carCompany");

	var engineModel = {
		url: contextPath + "/GIISMcMakeController?action=showEngineOverlay&refresh=1&makeCd="+$F("txtMakeCd")+"&carCompanyCd="+$F("txtCarCompanyCd"),
		options: {
			width: '625px',
			height: '255px',
			pager: {},
			onCellFocus: function(element, value, x, y, id){
				engineIndex = y;
				selectedEngine = engineTG.geniisysRows[y];
				setEngValues(selectedEngine);
				engineTG.keys.removeFocus(engineTG.keys._nCurrentFocus, true);
				engineTG.keys.releaseKeys();
				$("txtSeriesCd").focus();
			},
			onRemoveRowFocus: function(){
				engineIndex = -1;
				setEngValues(null);
				engineTG.keys.removeFocus(engineTG.keys._nCurrentFocus, true);
				engineTG.keys.releaseKeys();
				$("txtSeriesCd").focus();
			},
			toolbar: {
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				onFilter: function(){
					engineIndex = -1;
					setEngValues(null);
					engineTG.keys.removeFocus(engineTG.keys._nCurrentFocus, true);
					engineTG.keys.releaseKeys();
				}
			},
			beforeSort : function(){
				if(changeTag == 1){
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
						$("btnSaveEngine").focus();
					});
					return false;
				}
			},
			onSort: function(){
				engineIndex = -1;
				setEngValues(null);
				engineTG.keys.removeFocus(engineTG.keys._nCurrentFocus, true);
				engineTG.keys.releaseKeys();
			},
			onRefresh: function(){
				engineIndex = -1;
				setEngValues(null);
				engineTG.keys.removeFocus(engineTG.keys._nCurrentFocus, true);
				engineTG.keys.releaseKeys();
			},				
			prePager: function(){
				if(changeTag == 1){
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
						$("btnSaveEngine").focus();
					});
					return false;
				}
				engineIndex = -1;
				setEngValues(null);
				engineTG.keys.removeFocus(engineTG.keys._nCurrentFocus, true);
				engineTG.keys.releaseKeys();
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
			{   id: 'recordStatus',
			    width: '0',				    
			    visible: false			
			},
			{	id: 'divCtrId',
				width: '0',
				visible: false
			},
			{	id: 'seriesCd',
				title: 'Series Code',
				width: '120px',
				align: 'right',
				titleAlign: 'right',
				filterOption: true,
				filterOptionType: 'integerNoNegative'
			},
			{	id: 'engineSeries',
				title: 'Engine Series',
				width: '473px',
				filterOption: true
			}
		],
		rows : objEngine.engineList.rows
	};
	engineTG = new MyTableGrid(engineModel);
	engineTG.pager = objEngine.engineList;
	engineTG.render("engineTable");
	
	function setEngValues(rec){
		try{
			$("txtSeriesCd").value = (rec == null ? "" : rec.seriesCd);
			$("txtEngineSeries").value = (rec == null ? "" : unescapeHTML2(rec.engineSeries));
			$("txtUserId").value = (rec == null ? "" : rec.userId);
			
			rec == null ? $("btnAddEngine").value = "Add" : $("btnAddEngine").value = "Update";
			rec == null ? $("txtSeriesCd").readOnly = false : $("txtSeriesCd").readOnly = true;
			rec == null ? disableButton("btnDeleteEngine") : enableButton("btnDeleteEngine");
			selectedEngine = rec;
		} catch(e){
			showErrorMessage("setEngValues", e);
		}
	}
	
	function validateSeriesCd(){
		if($F("txtSeriesCd") != ""){
			if(isNaN($F("txtSeriesCd")) || parseInt($F("txtSeriesCd")) < 1 || parseInt($F("txtSeriesCd")) > 10000 || $F("txtSeriesCd").include(".")){
				showWaitingMessageBox("Invalid Series Code. Valid value should be from 1 to 10000.", "E", function(){
					$("txtSeriesCd").value = $("txtSeriesCd").getAttribute("lastValidValue");
					$("txtSeriesCd").focus();
				});
			}
		}
	}
	
	function valAddEngine(){
		try{
			var proceed = false;
			if(checkAllRequiredFieldsInDiv("engineFormDiv")){
				for(var i = 0; i < engineTG.geniisysRows.length; i++){
					var row = engineTG.geniisysRows[i];
					
					if(row.recordStatus != -1 && i != engineIndex){
						if(row.seriesCd == $F("txtSeriesCd")){
							showMessageBox("Record already exists with the same make_cd, car_company_cd and series_cd.", "E");
							return;
						}
					}
					
					if(row.recordStatus != -1 && i != engineIndex){
						if(row.engineSeries == $F("txtEngineSeries")){
							showMessageBox("Record already exists with the same engine_series.", "E");
							return;
						}
					}
					
					if((row.recordStatus == -1 && row.seriesCd == $F("txtSeriesCd")) || (row.recordStatus == -1 && row.engineSeries == $F("txtEngineSeries"))){
						proceed = true;
					}
				}
				if(proceed){
					addEngine();
					return;
				}
				
				//if($F("btnAddEngine") == "Add") { // andrew - 08052015 - SR 19241
					new Ajax.Request(contextPath + "/GIISMcMakeController", {
						parameters: {
							action: "valAddEngine",
							makeCd: $F("txtMakeCd"),
							carCompanyCd: $F("txtCarCompanyCd"),
							seriesCd: $F("txtSeriesCd"),
							engineSeries: $F("txtEngineSeries"),
							valAction: $F("btnAddEngine").toUpperCase()
						},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								addEngine();
							}
						}
					});
				/* } else { // andrew - 08052015 - SR 19241
					addEngine();
				} */
			}
		} catch(e){
			showErrorMessage("valAddEngine", e);
		}
	}
	
	function addEngine(){
		try {
			changeTagFunc = saveEngine;
			var row = setEngine(selectedEngine);
			
			if($F("btnAddEngine") == "Add"){
				engineTG.addBottomRow(row);
			} else {
				engineTG.updateVisibleRowOnly(row, engineIndex, false);
			}
			
			changeTag = 1;
			setEngValues(null);
			engineTG.keys.removeFocus(engineTG.keys._nCurrentFocus, true);
			engineTG.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addEngine", e);
		}
	}
	
	function setEngine(rec){
		try {
			var obj = (rec == null ? {} : rec);
			
			obj.makeCd = $F("txtMakeCd");
			obj.carCompanyCd = $F("txtCarCompanyCd");
			obj.seriesCd = $F("txtSeriesCd");
			obj.engineSeries = escapeHTML2($F("txtEngineSeries"));
			obj.userId = userId;
			
			return obj;
		} catch(e){
			showErrorMessage("setEngine", e);
		}
	}
	
	function valDeleteEngine(){
		try{
			new Ajax.Request(contextPath + "/GIISMcMakeController", {
				parameters: {
					action: "valDeleteEngine",
					makeCd: $F("txtMakeCd"),
					carCompanyCd: $F("txtCarCompanyCd"),
					seriesCd: $F("txtSeriesCd")
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						deleteEngine();
					}
				}
			});
		} catch(e){
			showErrorMessage("valDeleteEngine", e);
		}
	}
	
	function deleteEngine(){
		changeTagFunc = saveEngine;
		selectedEngine.recordStatus = -1;
		engineTG.deleteRow(engineIndex);
		changeTag = 1;
		setEngValues(null);
	}
	
	function saveEngine(){
		var setRows = getAddedAndModifiedJSONObjects(engineTG.geniisysRows);
		var delRows = getDeletedJSONObjects(engineTG.geniisysRows);
		
		new Ajax.Request(contextPath+"/GIISMcMakeController", {
			method: "POST",
			parameters: {
				action: "saveEngine",
				setRows: prepareJsonAsParameter(setRows),
				delRows: prepareJsonAsParameter(delRows)
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objEngine.exitOverlay != null) {
							objEngine.exitOverlay();
						} else {
							engineTG._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	function exitOverlay(){
		changeTag = 0;
		engineOverlay.close();
		delete engineOverlay;
	}
	
	function cancelEngine(){
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
				function(){
					objEngine.exitOverlay = exitOverlay;
					saveEngine();
				}, exitOverlay, "");
		} else {
			exitOverlay();
		}
	}

	$("txtSeriesCd").observe("focus", function(){
		$("txtSeriesCd").setAttribute("lastValidValue", $F("txtSeriesCd"));
	});
	
	$("txtSeriesCd").observe("change", validateSeriesCd);
	$("btnAddEngine").observe("click", valAddEngine);
	$("btnDeleteEngine").observe("click", valDeleteEngine);
	$("btnCancelEngine").observe("click", cancelEngine);
	
	$("txtMakeCd").focus();
	initializeAll();
	makeInputFieldUpperCase();
	observeSaveForm("btnSaveEngine", saveEngine);
</script>