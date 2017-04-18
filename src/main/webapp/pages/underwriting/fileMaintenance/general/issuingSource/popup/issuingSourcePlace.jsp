<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss004PlaceMainDiv" name="giiss004PlaceMainDiv" style="">	
	<div class="sectionDiv" style="width: 458px; margin: 3px 0 15px 0px;">
		<div id="issourcePlaceTableDiv" style="padding-top: 10px;">
			<div id="issourcePlaceTable" style="height: 230px; margin-left: 5px;"></div>
		</div>
		<div align="center" id="issourcePlaceFormDiv">
			<table style="margin-top: 20px;">
				<tr>
					<input id="hidIssCd" type="hidden" value="${issCd}"/>
					<td class="rightAligned" style="padding-right: 7px;">Place Code</td>
					<td class="leftAligned"><input id="txtPlaceCd" type="text" class="required" maxlength="4" style="width: 70px;" tabindex="701"></td>
					<td width="" class="rightAligned" style="padding: 0 7px 0 30px;">Place</td>
					<td class="leftAligned"><input id="txtPlace" type="text" class="required" maxlength="20" style="width: 150px;" tabindex="702"></td>
				</tr>	
			</table>
		</div>
		<div class="buttonsDiv" style="margin: 10px 0 10px 0px;">
			<input type="button" class="button" id="btnAddPlace" value="Add" tabindex="703">
			<input type="button" class="button" id="btnDeletePlace" value="Delete" tabindex="704">
		</div>
	</div>
	<div align="center">
		<input type="button" class="button" id="btnReturn" value="Return"  style="width: 80px;" tabindex="705">
		<input type="button" class="button" id="btnSavePlace" value="Save" tabindex="706">
	</div>
</div>

<script type="text/javascript">	
	initializeAll();
	initializeAccordion();
	var rowIndex2 = -1;
	
		
	function saveGiiss004Place(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		
		var setRows = getAddedAndModifiedJSONObjects(tbgIssourcePlace.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgIssourcePlace.geniisysRows);
		new Ajax.Request(contextPath+"/GIISISSourceController", {
			method: "POST",
			parameters : {action : "saveGiiss004Place",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIIS004.closeDialog != null) {
							objGIIS004.closeDialog();
						} else {
							tbgIssourcePlace._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	
	var objGIIS004 = {};
	var objIssource = null;
	objGIIS004.issourcePlaceList = JSON.parse('${jsonIssourcePlace}');
	objGIIS004.closeDialog = null;
	objGIIS004.recList = JSON.parse('${recList}');
	var recList = objGIIS004.recList.rows;
	
	var issourcePlaceTableModel = {
			url : contextPath + "/GIISISSourceController?action=showGiiss004Place&refresh=1&issCd="+encodeURIComponent($F("hidIssCd")),
			options : {
				width : '446px',
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex2 = y;
					objIssource = tbgIssourcePlace.geniisysRows[y];
					setFieldValues(objIssource);
					tbgIssourcePlace.keys.removeFocus(tbgIssourcePlace.keys._nCurrentFocus, true);
					tbgIssourcePlace.keys.releaseKeys();
					$("txtPlace").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex2 = -1;
					setFieldValues(null);
					tbgIssourcePlace.keys.removeFocus(tbgIssourcePlace.keys._nCurrentFocus, true);
					tbgIssourcePlace.keys.releaseKeys();
					$("txtPlaceCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex2 = -1;
						setFieldValues(null);
						tbgIssourcePlace.keys.removeFocus(tbgIssourcePlace.keys._nCurrentFocus, true);
						tbgIssourcePlace.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSavePlace").focus();
						});
						return false;
					}
				},
				onSort: function(){
					rowIndex2 = -1;
					setFieldValues(null);
					tbgIssourcePlace.keys.removeFocus(tbgIssourcePlace.keys._nCurrentFocus, true);
					tbgIssourcePlace.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex2 = -1;
					setFieldValues(null);
					tbgIssourcePlace.keys.removeFocus(tbgIssourcePlace.keys._nCurrentFocus, true);
					tbgIssourcePlace.keys.releaseKeys();
				},				
				prePager: function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSavePlace").focus();
						});
						return false;
					}
					rowIndex2 = -1;
					setFieldValues(null);
					tbgIssourcePlace.keys.removeFocus(tbgIssourcePlace.keys._nCurrentFocus, true);
					tbgIssourcePlace.keys.releaseKeys();
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
				{
				    id: 'recordStatus',
				    width: '0',				    
				    visible : false			
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},	
				{
					id : 'issCd',
					width : '0px',
					visible: false
				},
				{
					id : 'updateDeleteAllowed',
					width : '0px',
					visible: false
				},
				{
					id : 'placeCd',
					filterOption : true,
					title : 'Place Code',
					width : '95px'				
				},	
				{
					id : 'place',
					filterOption : true,
					title : 'Place',
					width : '316px'				
				}
			],
			rows : objGIIS004.issourcePlaceList.rows
		};

		tbgIssourcePlace = new MyTableGrid(issourcePlaceTableModel);
		tbgIssourcePlace.pager = objGIIS004.issourcePlaceList;
		tbgIssourcePlace.render("issourcePlaceTable");
	
	function setFieldValues(rec){
		try{
			$("txtPlaceCd").value = (rec == null ? "" : unescapeHTML2(rec.placeCd));
			$("txtPlace").value = (rec == null ? "" : unescapeHTML2(rec.place));
			
			rec == null ? $("btnAddPlace").value = "Add" : $("btnAddPlace").value = "Update";
			rec == null ? $("txtPlaceCd").readOnly = false : $("txtPlaceCd").readOnly = true;
			rec == null ? $("txtPlace").readOnly = false : rec.updateDeleteAllowed == "Y" ? $("txtPlace").readOnly = false : $("txtPlace").readOnly = true;
			rec == null ? enableButton("btnAddPlace") : rec.updateDeleteAllowed == "Y" ? enableButton("btnAddPlace") : disableButton("btnAddPlace");
			rec == null ? disableButton("btnDeletePlace") : rec.updateDeleteAllowed == "Y" ? enableButton("btnDeletePlace") : disableButton("btnDeletePlace");
			objIssource = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setPlaceRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.issCd = escapeHTML2($F("hidIssCd"));
			obj.placeCd = escapeHTML2($F("txtPlaceCd"));
			obj.place = escapeHTML2($F("txtPlace"));	
			obj.updateDeleteAllowed = "Y";
			obj.userId = userId;
			obj.lastUpdate = dateFormat(new Date(), 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setPlaceRec", e);
		}
	}
	
	function addPlaceRec(){
		try {
			var placeRec = setPlaceRec(objIssource);
			if($F("btnAddPlace") == "Add"){
				recList.push(placeRec);
				tbgIssourcePlace.addBottomRow(placeRec);
			} else {
				for(var i = 0; i < recList.length; i++){
					if(unescapeHTML2(recList[i].placeCd) == unescapeHTML2(placeRec.placeCd)){
						recList[i].place = placeRec.place;
					}
				}
				tbgIssourcePlace.updateVisibleRowOnly(placeRec, rowIndex2, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgIssourcePlace.keys.removeFocus(tbgIssourcePlace.keys._nCurrentFocus, true);
			tbgIssourcePlace.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addPlaceRec", e);
		}
	}		
	
	function valAddPlaceRec(){
		try{
			if(checkAllRequiredFieldsInDiv("issourcePlaceFormDiv")){
				if($F("btnAddPlace") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;
					var addedSamePlaceExists = false;
					var deletedSamePlaceExists = false;						
					
					for(var i=0; i<tbgIssourcePlace.geniisysRows.length; i++){
						if(tbgIssourcePlace.geniisysRows[i].recordStatus == 0 || tbgIssourcePlace.geniisysRows[i].recordStatus == 1){								
							if(tbgIssourcePlace.geniisysRows[i].placeCd.toUpperCase() == $F("txtPlaceCd").toUpperCase()){
								addedSameExists = true;								
							}
							if(tbgIssourcePlace.geniisysRows[i].place.toUpperCase() == $F("txtPlace").toUpperCase()){
								addedSamePlaceExists = true;								
							}
						} else if(tbgIssourcePlace.geniisysRows[i].recordStatus == -1){
							if(tbgIssourcePlace.geniisysRows[i].placeCd.toUpperCase() == $F("txtPlaceCd").toUpperCase()){
								deletedSameExists = true;
							}
							if(tbgIssourcePlace.geniisysRows[i].place.toUpperCase() == $F("txtPlace").toUpperCase()){
								deletedSamePlaceExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same Place Code.", "E");
						return;
					}else if((addedSamePlaceExists && !deletedSamePlaceExists) || (deletedSamePlaceExists && addedSamePlaceExists)){
						showMessageBox("Place of Issuance must be unique.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addPlaceRec();
						return;
					}
					
					new Ajax.Request(contextPath + "/GIISISSourceController", {
						parameters : {action : "valAddPlaceRec",
									  issCd  : $F("hidIssCd"),
									  placeCd:	$F("txtPlaceCd"),
									  place:	$F("txtPlace")},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								addPlaceRec();
							}
						}
					});
				} else {
					addPlaceRec();
				}
			}
		} catch(e){
			showErrorMessage("valAddPlaceRec", e);
		}
	}
	
	function valAddFromList(){
		if(checkAllRequiredFieldsInDiv("issourcePlaceFormDiv")){
			if($F("btnAddPlace") == "Add") {
				for(var i = 0; i < recList.length; i++){
					if(unescapeHTML2(recList[i].placeCd).toUpperCase() == $F("txtPlaceCd").toUpperCase()){
						showMessageBox("Record already exists with the same place_cd.", "E");
						return;
					}
					if(unescapeHTML2(recList[i].place).toUpperCase() == $F("txtPlace").toUpperCase()){
						showMessageBox("Record already exists with the same place.", "E");
						return;
					}
				}
			}else{
				for(var i = 0; i < recList.length; i++){
					if(unescapeHTML2(recList[i].placeCd).toUpperCase() != $F("txtPlaceCd").toUpperCase() &&
						unescapeHTML2(recList[i].place).toUpperCase() == $F("txtPlace").toUpperCase()){
						showMessageBox("Record already exists with the same place.", "E");
						return;
					}
				}
			}
			addPlaceRec();
		}
	}
	
	function deletePlaceRec(){
		for(var i = 0; i < recList.length; i++){
			if(unescapeHTML2(recList[i].placeCd) == $F("txtPlaceCd")){
				recList.splice(i, 1);
			}
		}
		
		objIssource.recordStatus = -1;
		tbgIssourcePlace.geniisysRows[rowIndex2].issCd = escapeHTML2($F("hidIssCd"));
		tbgIssourcePlace.geniisysRows[rowIndex2].placeCd = escapeHTML2($F("txtPlaceCd"));
		tbgIssourcePlace.deleteRow(rowIndex2);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeletePlaceRec(){
		try{
			new Ajax.Request(contextPath + "/GIISISSourceController", {
				parameters : {action : "valDeletePlaceRec",
							  issCd  : $F("hidIssCd"),
							  placeCd:	$F("txtPlaceCd")},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						deletePlaceRec();
					}
				}
			});
		} catch(e){
			showErrorMessage("valDeletePlaceRec", e);
		}
	}
	
	function closeDialog(){
		issourcePlaceOverlay.close();
	}	
	
	function closeGiiss004Place(){
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIIS004.closeDialog = closeDialog;
						saveGiiss004Place();
					}, function(){
						changeTag = 0;
						issourcePlaceOverlay.close();
					}, "");
		} else {
			issourcePlaceOverlay.close();
		}
	}
	
	
	disableButton("btnDeletePlace");
	
	$("btnSavePlace").observe("click", saveGiiss004Place);
	$("btnReturn").observe("click", closeGiiss004Place);
	$("btnAddPlace").observe("click", valAddFromList);
	$("btnDeletePlace").observe("click", valDeletePlaceRec);

	
	$("txtPlaceCd").focus();	
</script>