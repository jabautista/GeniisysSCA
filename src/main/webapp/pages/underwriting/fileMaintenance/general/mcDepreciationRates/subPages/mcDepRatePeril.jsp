<div id="perilDepRateDiv" name="perilDepRateDiv" style="width: 100%; font-size: 11px;">
	<div class="sectionDiv" style="width: 470px; margin: 10px; height:380px;">
	<div id="perilDepRateTable" style="height: 200px; margin: 10px;"></div>
		<div id="perilDepRateDivForm" name="perilDepRateDivForm" style="width: 450px; margin: 10px; ">
			<table width="400px" style="margin-top: 78px; margin-left: 25px;">			
				<tr>	
					<td class="leftAligned" style="width: 80px;">Peril</td>
					<td style="width: 8px;">:</td>
					<td class="leftAligned">
						<span class="lovSpan required" style="width: 280px; height: 22px; margin: 2px 2px 0 0; float: left;">
							<input id="txtPerilName" type="text" readonly="readonly" class="required upper" style="width: 250px; text-align: left; height: 13px; float: left; border: none;" tabindex="101" maxlength="50" ignoreDelKey="true">
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchPerilName" name="searchPerilName" alt="Go" style="float: right;">
						</span>			
				    </td>		
				</tr>												
			</table>
			<div style="margin-left: 0px;">
				<table align="center" width="450px">
					<td class="rightAligned"><input type="button" class="button" style="width: 80px; margin-top: 10px;" id="btnAddPerilDepRate" name="btnAddPerilDepRate" value="Add"/></td>
					<td><input type="button" class="disabledButton" style="width: 80px; margin-top: 10px;" id="btnDeletePerilDepRate" name="btnDeletePerilDepRate" disabled="disabled" value="Delete" /></td>
				</table>
			</div>
		</div>
		<div style="margin-top: 25px; margin-left: 0px;">
			<table align="center" width="450px">				
				<td class="rightAligned"><input type="button" class="button" style="width: 100px; margin-top: 10px;" id="btnSavePerilDepRate" name="btnSavePerilDepRate" value="Save"/></td>
				<td><input type="button" class="button" style="width: 100px; margin-top: 10px;" id="btnReturnPerilDepRate" name="btnReturnPerilDepRate" value="Return"/></td>
			</table>
		</div>
    	<input id="lineCd" type="hidden" value="" name="lineCd"/>
		<input id="perilCd" type="hidden" value="" name="perilCd"/>
		<input id="perilName" type="hidden" value="" name="perilName"/>
	</div>
</div>

<script type="text/JavaScript">
	changeTag = 0;
	var delObj;
	var rowObj;
	var changeCounter = 0;
	var deleteStatus = false;
	
	try {
		var row = 0;
		var objPerilDepRateMaintenance = [];
		var objPerilDepRate = new Object();
		objPerilDepRate.objPerilListingDepRate = JSON.parse('${giisMcDrPeril}'.replace(/\\/g, '\\\\'));
		objPerilDepRate.objPerilDepRateMaintain = objPerilDepRate.objPerilListingDepRate.rows || [];

		var perilDepRateTG = {
			 url : contextPath+"/GIISMcDepreciationRateController?action=getGIISMcDrPeril&refresh=1"
								+"&id="+$("id").value
								+"&lineCd="+encodeURIComponent(unescapeHTML2($("txtLineCd").value)),
			options : {
				width : '450px',
				height : '230px',
				onCellFocus : function(element, value, x, y, id) {
					row = y;
					objPerilMain = perilDepRateTableGrid.geniisysRows[y];
					perilDepRateTableGrid.keys.releaseKeys();	
					populatePerilDepRateInfo(objPerilMain);
				},
				onRemoveRowFocus : function() {
					populatePerilDepRateInfo(null);
					onRemove();
				},
				beforeSort : function() {
					if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
                	}
				},
				onSort : function() {
					populatePerilDepRateInfo(null);
					onRemove();
				},
				prePager: function(){
	            	if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
                	} else {	        
                		populatePerilDepRateInfo(null);
                		onRemove();
                	}
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
		                onRefresh: function(){
		                	populatePerilDepRateInfo(null);
		                	onRemove();
						},
						onFilter : function() {	
	                		populatePerilDepRateInfo(null);
	                		onRemove();
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
				id : 'id',
				width : '0px',
				visible : false
			}, {
				id : 'lineCd',
				title : 'Line',
				titleAlign: 'left',
				width : '100px',
				visible : true,
				filterOption : true
			},{
				id : 'perilCd',
				width : '0px',
				visible : false
			},{
				id : 'perilName',
				title : 'Peril',
				titleAlign: 'left',
				width : '335px',
				visible : true,
				filterOption : true
			}],
			rows : objPerilDepRate.objPerilDepRateMaintain
		};
		perilDepRateTableGrid = new MyTableGrid(perilDepRateTG);
		perilDepRateTableGrid.pager = objPerilDepRate.objPerilListingDepRate;
		perilDepRateTableGrid.render('perilDepRateTable');
		perilDepRateTableGrid.afterRender = function() {
			objPerilDepRateMaintenance = perilDepRateTableGrid.geniisysRows;
			changeTag = 0;	
		}; 
	} catch (e) {
		showErrorMessage("MC Peril Depreciation Rate Table Grid", e);
	}
	
 	function populatePerilDepRateInfo(obj){
		try{
			$("lineCd").value 			        = obj			== null ? "" : obj.lineCd;			
			$("perilCd").value 			        = obj			== null ? "" : obj.perilCd;
			$("perilName").value 	            = obj			== null ? "" : obj.perilName;
			$("txtPerilName").value 			= obj			== null ? "" : unescapeHTML2(obj.perilName); 			
			$("txtPerilName").setAttribute("lastValidValue", (obj == null ? "" : unescapeHTML2(obj.perilName)));
			$("perilCd").setAttribute("lastValidValue", (obj == null ? "" : obj.perilCd));			
			obj == null ? enableSearch("searchPerilName") : disableSearch("searchPerilName");
			obj == null ? enableButton("btnAddPerilDepRate") : disableButton("btnAddPerilDepRate");			
			obj == null ? disableButton("btnDeletePerilDepRate") : enableButton("btnDeletePerilDepRate");					
		}catch(e){
			showErrorMessage("populatePerilDepRateInfo", e);
		}
	}
	
	$("searchPerilName").observe("click", function(){
		var notIn = "";
		var withPrevious = false;
		
		notIn = createNotInParamInObj(objPerilDepRateMaintenance, function(obj){ return parseInt(obj.id) == $F("id") && nvl(obj.recordStatus, 0) != -1;	}, "perilCd");	
		showGIISS224PerilName(notIn);	
	});	
	
	$("txtPerilName").setAttribute("lastValidValue", "");
	
	$("txtPerilName").observe("keyup", function(){
		$("txtPerilName").value = $F("txtPerilName").toUpperCase();
	});
	
	$("txtPerilName").observe("change", function() {	
		if($F("txtPerilName").trim() == "") {
			$("txtPerilName").value = "";
			$("txtPerilName").setAttribute("lastValidValue", "");		
			$("perilCd").value = "";
			$("perilCd").setAttribute("lastValidValue", "");						
		} else { 
			if($F("txtPerilName").trim() != "" && $F("txtPerilName") != $("txtPerilName").readAttribute("lastValidValue")) {
				showGIISS224PerilName();
			}
		} 
	});				
	
	function showGIISS224PerilName(notIn){
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters: {
				action : "getGIISS224PerilName", 
				filterText : ($("txtPerilName").readAttribute("lastValidValue").trim() != $F("txtPerilName").trim() ? $F("txtPerilName").trim() : ""),
				lineCd: $("txtLineCd").value,
				notIn : notIn,
				page : 1
			},
			title: "List of Peril Name",
			width: '395px',
			height: '386px',
			columnModel : [
					{
						id : "perilCd",
						title: "Peril Code",
						width: '100px',
						filterOption: true
					},
					{
						id : "perilName",
						title: "Peril Name",
						width: '280px',
						filterOption: true
					}						
			],
			autoSelectOneRecord: true,
			filterText : ($("txtPerilName").readAttribute("lastValidValue").trim() != $F("txtPerilName").trim() ? $F("txtPerilName").trim() : ""),
			onSelect: function(row) {
				$("txtPerilName").value = unescapeHTML2(row.perilName);
				$("txtPerilName").setAttribute("lastValidValue", $("txtPerilName").value);	
				$("perilCd").value = row.perilCd;
				$("perilCd").setAttribute("lastValidValue", $("perilCd").value);					
			},
			onCancel: function (){
				$("txtPerilName").value = $("txtPerilName").readAttribute("lastValidValue");
				$("perilCd").value = $("perilCd").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtPerilName").value = $("txtPerilName").readAttribute("lastValidValue");
				$("perilCd").value = $("perilCd").readAttribute("lastValidValue");
			},
			onShow : function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		  });
	}		

	//Add/Update Record 
	function setPerilDepRateTableValues(func){
		var rowObjectPerilDepRate = new Object(); 
		rowObjectPerilDepRate.id	 			= $("id").value;
		rowObjectPerilDepRate.lineCd			= $("txtLineCd").value;
		rowObjectPerilDepRate.perilCd	 	    = $("perilCd").value;
		rowObjectPerilDepRate.perilName	 	    = $("txtPerilName").value;
		rowObjectPerilDepRate.recordStatus 		= func == "Delete" ? -1 : func == "Add" ? 0 : 1;
		return rowObjectPerilDepRate;        
	}	
 	
	function addPerilDepRate(){ 
		if(!checkAllRequiredFieldsInDiv("perilDepRateDivForm")){
			return false;
		}		
		
		rowObj  = setPerilDepRateTableValues($("btnAddPerilDepRate").value);			
		rowObj.recordStatus = 0;
		rowObj.unsavedAddStat = 1;
		objPerilDepRateMaintenance.push(rowObj);
		perilDepRateTableGrid.addBottomRow(rowObj);
		changeTag = 1;
		changeCounter++;
		clearDetails();
		populatePerilDepRateInfo(null);		
	}
		
	$("btnAddPerilDepRate").observe("click",addPerilDepRate);	
	
	//Delete Record	
	function deletePerilDepRate(){ 
		delObj = setPerilDepRateTableValues($("btnDeletePerilDepRate").value);
		objPerilDepRateMaintenance.splice(row, 1, delObj);
		perilDepRateTableGrid.deleteVisibleRowOnly(row);
		perilDepRateTableGrid.onRemoveRowFocus();
		if(changeCounter == 1 && delObj.unsavedAddStat == 1){
			changeTag = 0;
			changeCounter = 0;
		}else{
			changeCounter++;
			changeTag=1;
		}	
	}
	
	$("btnDeletePerilDepRate").observe("click",deletePerilDepRate);
	
	//Save Function
	function savePerilDepRate(){ 
		var objParams = new Object(); 
		objParams.setRows = getAddedAndModifiedJSONObjects(objPerilDepRateMaintenance);
		objParams.delRows = getDeletedJSONObjects(objPerilDepRateMaintenance);
		new Ajax.Request(contextPath+"/GIISMcDepreciationRateController?action=savePerilDepRate",{
			method: "POST",
			parameters:{
				parameters : JSON.stringify(objParams)
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				hideNotice("");
				changeTag = 0;
				if(checkErrorOnResponse(response)) {
					if (response.responseText == "SUCCESS"){
						showMessageBox(objCommonMessage.SUCCESS, "S");	                	
	                	perilDepRateTableGrid._refreshList();
					}
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	observeSaveForm("btnSavePerilDepRate", savePerilDepRate);
	
	function clearDetails(){
		$("txtPerilName").value = "";
		$("perilCd").value = "";
	}
	
	function onRemove(){
		perilDepRateTableGrid.keys.releaseKeys();
		clearDetails();
	}
	
	observeCancelForm("btnReturnPerilDepRate", savePerilDepRate, function(){
		perilDepRateTableGrid.keys.releaseKeys();
		changeTag = 0;
		overlayMcDr.close();
	});
</script>