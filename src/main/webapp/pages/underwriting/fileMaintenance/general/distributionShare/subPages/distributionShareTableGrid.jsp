<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="distributionShareTableGrid" style="position:relative; margin-left: 7%; margin-top: 10px; margin-bottom: 10px; float: left"></div>
<div id="xolTableGrid" style="position:relative; margin-left: 7%; margin-top: 10px; margin-bottom: 10px; float: left"></div>

<div id="shareTypeDiv" name="shareTypeDiv" style="position: absolute; margin-left: 650px; margin-top: 30px;  border: 1px solid #E0E0E0">
	<label style="margin-top:15px; margin-left:62px; font-weight: bold;">Share Type</label> <br />
		<input type="hidden" id="curShareType" name="curShareType" value="" /> 
		<div id="shareTypeRadioBtnDiv" align="left" style="margin-top: 18px;  float: right; margin-right: 20px; margin-bottom: 15px;">
			<table>
				<tr>
					<td><input type="radio" id="rdoNetRetention" name="optShareType" value="1" style="margin-left: 30px; margin-top: 5px; margin-bottom: 6px;" tabindex=201 checked/></td>
					<td><label for="rdoNetRetention" id="lblNetRetention" style="margin-bottom: 6px;">Net Retention</label></td>
				</tr>
				<tr>
					<td><input type="radio" id="rdoFacultative" name="optShareType" value="3" style="margin-left: 30px; margin-top: 5px; margin-bottom: 6px;" tabindex=202/></td>
					<td><label for="rdoFacultative" id="lblFacultative" style="margin-bottom: 6px;">Facultative</label></td>
				</tr>
				<tr>
					<td><input type="radio" id="rdoPropTreaty" name="optShareType" value="2" style="margin-left: 30px; margin-top: 5px; margin-bottom: 6px;" tabindex=203/></td>
					<td><label for="rdoPropTreaty" id="lblPropTreaty" style="margin-bottom: 6px;">Proportional Treaty</label></td>
				</tr>
				<tr>
					<td><input type="radio" id="rdoNonPropTreaty" name="optShareType" value="4"  style="margin-left: 30px; margin-top: 5px; margin-bottom: 6px;" tabindex=204/></td>
					<td><label for="rdoNonPropTreaty" id="lblNonPropTreaty" style="margin-bottom: 6px;">Non-Proportional Treaty</label></td>
				</tr>
			</table>
		</div>	
</div>
<div id="treatyDetailsDiv" style="position: absolute; margin-left: 685px; margin-top: 220px;">
	<input type="button" class="button" id="btnTreatyDetails" name="btnTreatyDetails" value="Treaty Details" style="width: 140px;" tabindex=205/>
</div>

<div id="distributionShareInfo" style="position:absolute; height:160px; margin-left:80px; margin-top: 275px;">
	<table>
		<tr>
			<input type="hidden" id="shareType"/>
			<td class="rightAligned" id="lblShareCode">Share Code</td>
			<td colspan="3" class="leftAligned"><input type="text" id="txtShareCode" name="txtShareCode" value="" class="required integerNoNegativeUnformattedNoComma rightAligned" maxlength="3" style="width: 340px;" tabindex=206/></td>
		</tr>
		<tr>
			<td class="rightAligned" id="lblShareName" style="width: 150px;">Share Name/Treaty Name</td>
			<td colspan="3" class="leftAligned"><input type="text" id="txtShareName" name="txtShareName" value="" class="required" maxlength="30" style="width: 340px;" tabindex=207/></td>
		</tr>
		<tr>
			<td class="rightAligned">Remarks</td>
			<td colspan="3" class="leftAligned">
				<div style="border: 1px solid gray; height: 21px; width: 346px; ">
					<textarea id="txtRemarks" name="txtRemarks" style="width: 320px; border: none; height: 13px; resize: none;" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex=208></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="EditRemark" id="editRemarksText" tabindex=209/>
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">User ID</td>
			<td class="leftAligned">
				<input type="text" id="txtUserId" name="txtUserId" value="" readonly="readonly" style="width: 100px;" tabindex=210/>
			</td>
			
			<td class="rightAligned" style="width:90px;">Last Update</td>
			<td class="rightAligned"><input type="text" id="txtLastUpdate" name="txtLastUpdate" value="" readonly="readonly" style="width: 135px;" tabindex=211/></td></td>
		</tr>		
		<tr>
			<td colspan="2" align="right"><input type="button" id="btnAddDShare" name="btnAddDShare" value="Add" class="button" style="width: 80px; margin-top:20px;" tabindex=212/></td>
			<td colspan="2" align="left"><input type="button" id="btnDeleteDShare" name="btnDeleteDShare" value="Delete" class="button" style="width: 80px; margin-top:20px;" tabindex=213/></td>
		</tr>
	</table>
</div>
<script>
	
	var deleteStatus = false;
	var addStatus = false;
	var selectedIndex = -1;
	var row = 0;
	var obj = null;
	shareType = ($("curShareType").value == null || $("curShareType").value == "")  ? "1" : $("curShareType").value;
	objUW.hideGIIS060 = {};
	var distShareRows = [];
	var distShareObj = new Object();
	distShareObj.distShareTableGrid1 = []; 
	distShareObj.distShareObjRows = distShareObj.distShareTableGrid1.rows || [];
	
	var distShareTableModel = {
 			url: contextPath+"/GIISDistributionShareController?action=getDistShareMaintenance&lineCd="+encodeURIComponent(unescapeHTML2(objUW.hideGIIS060.lineCd))
					+"&shareType="+shareType, 	 					
			options: {
				width: '550px',
				height: '220px',
				onCellFocus: function(element, value, x, y, id){
					row = y;
					obj = distShareTableGrid.geniisysRows[y];
					objUW.hideGIIS060.shareCd = obj.shareCd;
					objUW.hideGIIS060.trtyName = obj.trtyName;
					populateDetails(obj);
					distShareTableGrid.keys.releaseKeys();
				},
  				prePager : function(){
  					if(changeTag == 1){ // Added by J. Diago 12.11.2013
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
  					
  		 			distShareTableGrid.keys.releaseKeys();
  					populateDetails(null);
  				},
				onRemoveRowFocus: function(){
					selectedIndex = -1;
					distShareTableGrid.keys.releaseKeys();
					populateDetails(null);
		        }, 
		        beforeSort : function(){ // Added by J. Diago 12.11.2013
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
				},
	            onSort: function(){
	                distShareTableGrid.onRemoveRowFocus();
	            },
	            onRefresh: function(){
            		distShareTableGrid.keys.releaseKeys();
                	populateDetails(null);	
				},
	            toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
						onFilter: function(){
 							distShareTableGrid.keys.releaseKeys();
		                	populateDetails(null);
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
				}
				},
				columnModel: [
								{   
									id: 'recordStatus',
								    width: '0',
								    visible: false,
								    editor: 'checkbox' 			
								},
								{	
									id: 'divCtrId',
									width: '0',
									visible: false
								},
								{   id: 'shareCd',
								    title: 'Share Code',
								    titleAlign: 'right',
								    align: 'right',
								    width: '90px',
								    visible: true,
								    filterOption: true,
								    filterOptionType : "integerNoNegative"
								},
								{	id: 'trtyName',
									title: 'Share Name/Treaty Name', 
									titleAlign: 'left',
									width: '430px',
									visible: true,
									filterOption: true
								},
								{	id: 'remarks',
									title: 'Remarks',
									//titleAlign: 'left',
									width: '0px',
									visible: false,
									//filterOption: true
								}
							],
							rows: distShareObj.distShareObjRows	,
							resetChangeTag: true,
		};
 		distShareTableGrid = new MyTableGrid(distShareTableModel);
		distShareTableGrid.pager = distShareObj.distShareTableGrid1;
		distShareTableGrid.render('distributionShareTableGrid');
		distShareTableGrid.afterRender = function(){
			distShareRows = distShareTableGrid.geniisysRows;
			objUW.hideGIIS060.distShareRows = distShareRows;
			changeTag = 0;
		}; 
					
	var xolRows = [];
	var xolObj = new Object();
	xolObj.xolTableGrid1 = []; 
	xolObj.xolObjRows = xolObj.xolTableGrid1.rows || [];
			
	var xolTableModel = {
		url: contextPath+"/GIISXolController?action=getXolList&lineCd="+encodeURIComponent(unescapeHTML2(objUW.hideGIIS060.lineCd)), 	 					
		options: {
			width: '550px',
			height: '220px',
			onCellFocus: function(element, value, x, y, id){
				row = y;
				obj = xolTableGrid.geniisysRows[y];
				objUW.hideGIIS060.xolTrtyName = obj.xolTrtyName;
				objUW.hideGIIS060.xolId = obj.xolId;
				populateDetails(obj);
				xolTableGrid.keys.releaseKeys();
			},
			onRemoveRowFocus: function(){
				selectedIndex = -1;
				xolTableGrid.keys.releaseKeys();
				populateDetails(null);
			},
			prePager: function(){ // Added by J. Diago 12.11.2013
				if(changeTag == 1){
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
						$("btnSave").focus();
					});
					return false;
				}
				xolTableGrid.keys.releaseKeys();
				populateDetails(null);
			},
			postPager : function(){
				xolTableGrid.keys.releaseKeys();
				populateDetails(null);
			},
			beforeSort : function(){ // Added by J. Diago 12.11.2013
				if(changeTag == 1){
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
						$("btnSave").focus();
					});
					return false;
				}
			},
		    onSort: function(){
		       	xolTableGrid.onRemoveRowFocus();
		    },
		    onRefresh: function(){
		    	xolTableGrid.keys.releaseKeys();
				populateDetails(null);
			},
		    toolbar: {
				elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
				onFilter: function(){
					xolTableGrid.keys.releaseKeys();
					populateDetails(null);
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
			}
		},
		columnModel: [
					{   
						id: 'recordStatus',
						width: '0',
						visible: false,
						editor: 'checkbox' 			
					},
					{	
						id: 'divCtrId',
						width: '0',
						visible: false
					},
					{	
						id: 'xolId',
						width: '0',
						visible: false
					},
					{   id: 'xolSeqNo',
					    title: 'XOL No.',
					    titleAlign: 'right',
					    align: 'right',
					    width: '90px',
					    visible: true,
					    filterOption: true,
					    filterOptionType : "integerNoNegative"
					},
					{	id: 'xolTrtyName',
						title: 'XOL Name', 
						titleAlign: 'left',
						width: '430px',
						visible: true,
						filterOption: true
					},
					{
						id : 'lineCd',
						width : '0',
						visible: false				
					},
					{	id: 'remarks',
						title: 'Remarks',
						//titleAlign: 'left',
						width: '0px',
						visible: true
					}
		],
			rows: xolObj.xolObjRows	,
			resetChangeTag: true,
	};
		xolTableGrid = new MyTableGrid(xolTableModel);
		xolTableGrid.pager = xolObj.xolTableGrid1;
		xolTableGrid.render('xolTableGrid');
		xolTableGrid.afterRender = function(){
			xolRows = xolTableGrid.geniisysRows;
			objUW.hideGIIS060.xolRows = xolRows;
			changeTag = 0;
		}; 			

	function setShareTypeRadio(shareType) {
		try {
			if(shareType=="1") {
				$("rdoNetRetention").checked = true;
				disableButton("btnTreatyDetails");
			} else if(shareType=="2") {
				$("rdoPropTreaty").checked = true;
				enableButton("btnTreatyDetails");
			} else if(shareType=="3") {
				$("rdoFacultative").checked = true;
				disableButton("btnTreatyDetails");
			} else if(shareType=="4") {
				$("rdoNonPropTreaty").checked = true;
				enableButton("btnTreatyDetails");
			}
			
			if(objUW.hideGIIS060.lineCd == null){
				disableButton("btnTreatyDetails");
			}
		} catch(e) {
			showErrorMessage("setShareTypeRadio", e);
		}
	}
	setShareTypeRadio();		
		
  	function populateDetails(obj){
		try{ 
			$("txtShareCode").value = (obj==null ? ""  : (shareType != "4" ? obj.shareCd : obj.xolSeqNo));
			$("txtShareName").value = (obj==null ? "" : (shareType != "4" ? unescapeHTML2(obj.trtyName) : unescapeHTML2(obj.xolTrtyName)));
			$("txtRemarks").value = (obj==null ? "" : unescapeHTML2(obj.remarks));
			$("txtUserId").value = (obj==null ? "" : (obj.userId));
			$("txtLastUpdate").value = (obj == null ? "" : obj.strLastUpdate == undefined ? obj.lastUpdate : obj.strLastUpdate);
			$("btnAddDShare").value = (obj==null ? "Add" : "Update");
			obj == null ? disableButton("btnDeleteDShare") : enableButton("btnDeleteDShare");
			if((shareType == "1" || shareType == "3") ){
				if(distShareTableGrid.rows.length > 0){ // Nica 05.27.2013 - to disallow addition of records for share_type = 1 or share_type = 3 
					obj==null ? disableButton("btnAddDShare"): enableButton("btnAddDShare");
					obj == null ? disableInputField("txtRemarks") : enableInputField("txtRemarks"); 
					obj == null ? $("editRemarksText").hide() : $("editRemarksText").show(); 
					disableInputField("txtShareCode");
					disableInputField("txtShareName");
				}else{
					enableInputField("txtRemarks");
					$("editRemarksText").show();
					enableInputField("txtShareCode");
					enableButton("btnAddDShare");
					enableInputField("txtShareName");
				}
			}else{
				enableInputField("txtRemarks");
				$("editRemarksText").show();
				//enableInputField("txtShareCode");
				obj == null ? enableInputField("txtShareCode") : disableInputField("txtShareCode");
				obj == null ? disableButton("btnTreatyDetails") : enableButton("btnTreatyDetails");
				enableButton("btnAddDShare");
				enableInputField("txtShareName");
			}
			//obj == null ? $("txtShareCode").readOnly = false : $("txtShareCode").readOnly = true; Removed by J. Diago to avoid conflict on showTableGrid.
			if(shareType == "4"){
				$("txtShareCode").readOnly = true;
			} 
		}catch(e){
			showErrorMessage("populateDetails", e);
		}
	}  		
	
	function setDistShareObj(){
		try{
			var obj = new Object();
			var date = new Date();
			var objUserId = userId;
			
			obj.shareCd = $F("txtShareCode");
			obj.trtyName = escapeHTML2($F("txtShareName"));
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = objUserId;
			obj.lastUpdate = dateFormat(date, "mm-dd-yyyy HH:MM:ss");
		    obj.trtyYy = dateFormat(date, "yy");
		    obj.trtySw = ((shareType == "1" || shareType == "3") ? "N" : "Y");
			return obj;
		}catch(e){
			showErrorMessage("setDistShareObj", e);
		}
	}
	
	function setXolObj(){
		try{
			var obj = new Object();
			var date = new Date();
			var objUserId = userId;
			
			obj.xolId = objUW.hideGIIS060.xolId;
			obj.xolSeqNo = $F("txtShareCode");
			obj.xolTrtyName = escapeHTML2($F("txtShareName"));
			obj.lineCd = objUW.hideGIIS060.lineCd; //added by steven 11.18.2013
			obj.userId = objUserId;
			obj.lastUpdate = dateFormat(date, "mm-dd-yyyy HH:MM:ss");
		    obj.xolYy = dateFormat(date, "yy");
		    obj.remarks = escapeHTML2($F("txtRemarks"));
			return obj;	
		}catch(e){
			showErrorMessage("setXolObj", e);
		}
	}
  	
	function addUpdateDistShare(obj){
		try{
			 changeTagFunc = objGIIS060.saveDistShare; // Added by J. Diago 12.11.2013
			 if($F("btnAddDShare") == "Add"){
				validateAddDistShare();
				var newObj = setDistShareObj();
					 if(addStatus == true){
						 newObj.recordStatus = 0;
						 distShareRows.push(newObj);
						 distShareTableGrid.addBottomRow(newObj);
						 changeTag =1;
						 populateDetails(null);
					 }
			 } else{
				validateUpdateDistShare();
				var newObj = setDistShareObj();
			 	for ( var a = 0; a < distShareRows.length; a++) {
					if(distShareRows[a].shareCd == newObj.shareCd
		 				&& distShareRows[a].recordStatus != -1) {
						if(addStatus == true){
					  		newObj.recordStatus = 1;
						 	distShareRows.splice(row, 1, newObj);
						 	distShareTableGrid.updateVisibleRowOnly(newObj, row);
						 	changeTag = 1;
						 	populateDetails(null);
					  	}
			 		}
				}
			}
		}catch (e) {
			showErrorMessage("addUpdateDistShare", e);
		}
	}
	
	function addUpdateXol(obj){
		try{
			 changeTagFunc = objGIIS060.saveXol; // Added by J. Diago 12.11.2013
			 if($F("btnAddDShare") == "Add"){
					validateAddXol();
					var newObj = setXolObj();
						 if(addStatus == true){
							 newObj.recordStatus = 0;
							 xolRows.push(newObj);
							 xolTableGrid.addBottomRow(newObj);
							 changeTag =1;
							 populateDetails(null);
						 }
				 } else{
					validateUpdateXol();
					var newObj = setXolObj();
				 	for ( var a = 0; a < xolRows.length; a++) {
						if(xolRows[a].xolSeqNo == newObj.xolSeqNo
			 				&& xolRows[a].recordStatus != -1) {
							if(addStatus == true){
						  		newObj.recordStatus = 1;
							 	xolRows.splice(row, 1, newObj);
							 	xolTableGrid.updateVisibleRowOnly(newObj, row);
							 	changeTag = 1;
							 	populateDetails(null);
						  	}
				 		}
					}
				}
			
		}catch(e){
			showErrorMessage("addUpdateXol", e);
		}
	}
	
	function deleteDistShare(obj){
		try {
			changeTagFunc = objGIIS060.saveDistShare; // Added by J. Diago 12.11.2013
			var delObj = setDistShareObj();
			if($F("btnDeleteDShare") == "Delete"){
				validateDelete();
				if(deleteStatus == true){
					delObj.recordStatus = -1; 
					distShareRows.splice(row, 1, delObj); 
					distShareTableGrid.deleteVisibleRowOnly(row);
					distShareTableGrid.onRemoveRowFocus();
					changeTag = 1;
 				} 
			}
		} catch (e) {
			showErrorMessage("deleteDistShare",e);
		}
	}
	
	function deleteXol(obj){
		try{
			changeTagFunc = objGIIS060.saveXol; // Added by J. Diago 12.11.2013
			var delObj = setXolObj();
			if($F("btnDeleteDShare") == "Delete"){
				validateDeleteXol();
				if(deleteStatus == true){
					delObj.recordStatus = -1; 
					xolRows.splice(row, 1, delObj); 
					xolTableGrid.deleteVisibleRowOnly(row);
					xolTableGrid.onRemoveRowFocus();
					changeTag = 1;
 				} 
			}
		}catch(e){
			showErrorMessage("deleteXol", e);
		}
	}
	
	function whenValidateItemShareCd(){ // Added by J. Diago 12.12.2013
		addStatus = true;
		if($("rdoNetRetention").checked){
			if($F("txtShareCode") == "999"){
				$("txtShareCode").value = "";
				$("txtShareName").value = "";
				showMessageBox("Share Code 999 is reserved for Facultative share type only.");
				addStatus = false;
			} else if($F("txtShareCode") != "1"){
				$("txtShareCode").value = "1";
			}
		} else if($("rdoPropTreaty").checked){
			if($F("txtShareCode") == "1"){
				$("txtShareCode").value = "";
				$("txtShareName").value = "";
				showMessageBox("Share Code 1 is reserved for Net Retention share type only.");
				addStatus = false;
			} else if($F("txtShareCode") == "999"){
				$("txtShareCode").value = "";
				$("txtShareName").value = "";
				showMessageBox("Share Code 999 is reserved for Facultative share type only.");
				addStatus = false;
			}
		} else if($("rdoFacultative").checked){
			if($F("txtShareCode") == "1"){
				$("txtShareCode").value = "";
				$("txtShareName").value = "";
				showMessageBox("Share Code 1 is reserved for Net Retention share type only.");
				addStatus = false;
			}else if($F("txtShareCode") != "999"){
				$("txtShareCode").value = "999";
			}
		}
	}
	
	function whenValidateItemShareName(){ // Added by J. Diago 12.12.2013
		addStatus = true;
		if($("rdoNetRetention").checked){
			if($F("txtShareName") != "NET RETENTION" || $F("txtShareName") == ""){
				$("txtShareName").value = "NET RETENTION";
			}
		} else if($("rdoFacultative").checked){
			if($F("txtShareName") != "FACULTATIVE" || $F("txtShareName") == ""){
				$("txtShareName").value = "FACULTATIVE";
			}
		} else {
			if($F("txtShareName") == "FACULTATIVE"){
				showMessageBox("FACULTATIVE is a reserved word strictly to be used for share code 999 only.");
				$("txtShareName").value = "";
				addStatus = false;
			} else if($F("txtShareName") == "NET RETENTION"){
				showMessageBox("NET RETENTION is a reserved word strictly to be used for share code 1 only.");
				$("txtShareName").value = "";
				addStatus = false;
			}
		}
	}
	
	function validateAddDistShare(){
		try{
			var addedSameExists = false;
			var deletedSameExists = false;	
			var addedSameExistsTrtyName = false;
			var deletedSameExiststTrtyName = false;
			addStatus = false;
			
			new Ajax.Request(contextPath+"/GIISDistributionShareController",{
				method: "POST",
				parameters: {
					action: "valAddDistShare",
					lineCd: unescapeHTML2(objUW.hideGIIS060.lineCd),
					shareCd: $F("txtShareCode"),
					trtyName: $F("txtShareName"),
					shareType: shareType
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function(){
					showNotice("Validating Share Code, please wait...");
				},
				onComplete: function(response){
					hideNotice("");
					if (checkErrorOnResponse(response)){
 						var obj = JSON.parse(response.responseText);
 						if(obj.exists == "Y"){
 							$("txtShareCode").value = "";
 							//showMessageBox("Distribution Share Code must be unique for each line regardless of Share Type.");
 							showMessageBox("Record already exists with the same line_cd and share_cd.", "E");
 						}else if(obj.exists == "X"){
 							$("txtShareName").value = "";
 							showMessageBox("Record already exists with the same trty_name.", "E");
 						}else {
							addStatus = true;
						}
 						/* Removed by J. Diago 12.12.2013 
 						else if(obj.exists == "N"){
 							if (obj.msg == "NR"){
 								$("txtShareName").value = obj.trtyName;
 								$("curShareType").value = obj.shareType;
 								setShareTypeRadio(obj.shareType);
 								objGIIS060.loadDistShare(obj.shareType);
 								addStatus = true;
 							} else if (obj.msg == "F"){
 								$("txtShareName").value = obj.trtyName;
 								$("curShareType").value = obj.shareType;
 								setShareTypeRadio(obj.shareType);
 								objGIIS060.loadDistShare(obj.shareType);
 								addStatus = true;
 							} else if (obj.msg == "NET RETENTION"){
 								$("txtShareName").value = "";
 								showMessageBox("'" +obj.msg+ "' is a reserved word strictly to be used for share code 1 only.");
 							} else if (obj.msg == "FACULTATIVE"){
 								$("txtShareName").value = "";
 								showMessageBox("'" +obj.msg+ "' is a reserved word strictly to be used for share code 999 only.");
 							} else {
 								addStatus = true;
 							}
 						} 
 						*/
					}
				}
			});
			
			for(var i = 0; i<distShareTableGrid.geniisysRows.length; i++){
			 if(distShareTableGrid.geniisysRows[i].recordStatus == 0 || distShareTableGrid.geniisysRows[i].recordStatus == 1){								
			 	 if(distShareTableGrid.geniisysRows[i].shareCd == $F("txtShareCode")){
					 addedSameExists = true;								
				 }							
			 } else if(distShareTableGrid.geniisysRows[i].recordStatus == -1){
					if(distShareTableGrid.geniisysRows[i].shareCd == $F("txtShareCode")){
					 deletedSameExists = true;
					}
				}
			 }
				
			for(var i = 0; i<distShareTableGrid.geniisysRows.length; i++){
			 if(distShareTableGrid.geniisysRows[i].recordStatus == 0 || distShareTableGrid.geniisysRows[i].recordStatus == 1){								
			 	 if(distShareTableGrid.geniisysRows[i].trtyName == $F("txtShareName")){
			 		addedSameExistsTrtyName = true;								
				 }							
			 } else if(distShareTableGrid.geniisysRows[i].recordStatus == -1){
					if(distShareTableGrid.geniisysRows[i].trtyName == $F("txtShareName")){
						deletedSameExiststTrtyName = true;
					}
				}
			}
				
			if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
				showMessageBox("Record already exists with the same line_cd and share_cd.", "E");
				addStatus = false;
			}
			
			if((addedSameExistsTrtyName && !deletedSameExiststTrtyName) || (deletedSameExiststTrtyName && addedSameExistsTrtyName)){
				showMessageBox("Record already exists with the same trty_name.", "E");
				addStatus = false;
			}
			
		} catch (e){
			showErrorMessage("validateAddDistShare", e);
		}
	}
	
	function validateAddXol(){
		try{
			var addedSameExists = false;
			var deletedSameExists = false;
			addStatus = false;
			
			new Ajax.Request(contextPath+"/GIISXolController", {
				method:	"POST",
				parameters: {
					action:	"validateAddXol",
					lineCd:	unescapeHTML2(objUW.hideGIIS060.lineCd),
					xolSeqNo: $F("txtShareCode"),
					xolTrtyName: $F("txtShareName")
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function(){
					showNotice("Validating Treaty Name, please wait...");
				},
				onComplete: function(response){
					hideNotice("");
					if (response.responseText == 'F'){
						$("txtShareName").value = "";
						showMessageBox("FACULTATIVE is a reserved word strictly to be used for share code 999 only.");
					}else if (response.responseText == 'NR'){
						$("txtShareName").value = "";
						showMessageBox("NET RETENTION is a reserved word strictly to be used for share code 1 only.");
					}else if (response.responseText == 'X'){
						$("txtShareName").value = "";
						//showMessageBox("XOL Name must be unique.");
						showMessageBox("Record already exists with the same xol_trty_name.", "E");
					}else{
						addStatus = true;
					}
				}
			});
			
			for(var i = 0; i<xolTableGrid.geniisysRows.length; i++){
				if(xolTableGrid.geniisysRows[i].recordStatus == 0 || xolTableGrid.geniisysRows[i].recordStatus == 1){								
					if(xolTableGrid.geniisysRows[i].xolTrtyName == $F("txtShareName")){
						addedSameExists = true;								
					}							
				} else if(xolTableGrid.geniisysRows[i].recordStatus == -1){
					if(tbgintmPcommRt.geniisysRows[i].xolTrtyName == $F("txtShareName")){
						deletedSameExists = true;
					}
				}
			}
			
			if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
				showMessageBox("Record already exists with the same xol_trty_name.", "E");
				addStatus = false;
			}
			
		}catch(e){
			showErrorMessage("validateAddXol", e);
		}
	} 
	
 	function validateUpdateDistShare(){
		try{
			addStatus = false;
			new Ajax.Request(contextPath+"/GIISDistributionShareController",{
				method: "POST",
				parameters: {
					action: "validateUpdateDistShare",
					lineCd: unescapeHTML2(objUW.hideGIIS060.lineCd),
					shareCd: $F("txtShareCode"),
					trtyName: $F("txtShareName"),
					shareType: shareType
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function(){
					showNotice("Validating Share Code, please wait...");
				},
				onComplete: function(response){
					hideNotice("");
					if (checkErrorOnResponse(response)){
						var obj = JSON.parse(response.responseText);
						addStatus = true;
						/* Removed by J. Diago 12.12.2013 
						if (obj.msg == "NR"){
							$("txtShareName").value = obj.trtyName;
							$("curShareType").value = obj.shareType;
							addStatus = true;
						} else if (obj.msg == "F"){
							$("txtShareName").value = obj.trtyName;
							$("curShareType").value = obj.shareType;
							addStatus = true;
						} else if (obj.msg == "NET RETENTION"){
							showMessageBox("'" +obj.msg+ "' is a reserved word strictly to be used for share code 1 only.");
							$("txtShareName").value = objUW.hideGIIS060.trtyName;
						} else if (obj.msg == "FACULTATIVE"){
							showMessageBox("'" +obj.msg+ "' is a reserved word strictly to be used for share code 999 only.");
							$("txtShareName").value = objUW.hideGIIS060.trtyName;	
						}else{
							if(obj.exists == "Y" || obj.exists == "N"){
								addStatus = true;
							}else if(obj.exists == "X"){
								showMessageBox("Share Name must be unique.");
								$("txtShareName").value = objUW.hideGIIS060.trtyName;	
							}
						} */
					}
				}
			});
		}catch(e){
			showErrorMessage("validateUpdateDistShare", e);
		}
	} 
	
  	function validateUpdateXol(){
		try{
			addStatus = false;
			new Ajax.Request(contextPath+"/GIISXolController", {
				method:	"POST",
				parameters: {
					action:	"validateUpdateXol",
					lineCd:	unescapeHTML2(objUW.hideGIIS060.lineCd),
					xolSeqNo: $F("txtShareCode"),
					xolTrtyName: $F("txtShareName"),
					remarks: $F("txtRemarks")
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function(){
					showNotice("Validating Treaty Name, please wait...");
				},
				onComplete: function(response){
					hideNotice("");
					if (response.responseText == 'F'){
						$("txtShareName").value = objUW.hideGIIS060.xolTrtyName;
						showMessageBox("FACULTATIVE is a reserved word strictly to be used for share code 999 only.");
					}else if (response.responseText == 'NR'){
						$("txtShareName").value = objUW.hideGIIS060.xolTrtyName;
						showMessageBox("NET RETENTION is a reserved word strictly to be used for share code 1 only.");
					}else if (response.responseText == 'N' || response.responseText == 'Y'){
						addStatus = true;
					}else{
						$("txtShareName").value = objUW.hideGIIS060.xolTrtyName;
						showMessageBox("XOL Name must be unique.");	
					}
				}
			});
		}catch(e){
			showErrorMessage("validateUpdateXol", e);
		}
	} 
 	
	function validateDelete(){
		try{		
			deleteStatus = false;
			new Ajax.Request(contextPath+"/GIISDistributionShareController",{
				method: "POST",
				parameters:{
					action: "valDeleteDistShare",
					lineCd: unescapeHTML2(objUW.hideGIIS060.lineCd),
					shareCd: objUW.hideGIIS060.shareCd
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function(){
					showNotice("Validating Share Code, please wait...");
				},
				onComplete: function(response){
					hideNotice("");
					if(response.responseText.substr(0,1) == 'N'){
						deleteStatus = true;
					}else if (response.responseText.substr(0,1) == 'Y' || response.responseText.substr(0,1) == 'X'){
						//showMessageBox("Cannot delete this record. Share code being used by distribution tables.");
						showMessageBox("Cannot delete record from GIIS_DIST_SHARE while dependent record(s) in " + response.responseText.slice(1) + " exists.", "E");
						distShareRows.refresh();
					}/* else if (response.responseText.substr(0,1) == 'X'){
						showMessageBox("Cannot delete this record. Default value being used by distribution tables.");
						distShareRows.refresh();
					} */
				}
			});
		} catch (e) {
			showErrorMessage("validateDelete", e);
		}
	}
	
	function validateDeleteXol() {
		try{
			deleteStatus = false;
			new Ajax.Request(contextPath+"/GIISXolController",{
				method: "POST",
				parameters:{
					action: "validateDeleteXol",
					xolId: objUW.hideGIIS060.xolId
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function(){
					showNotice("Validating Share Code, please wait...");
				},
				onComplete: function(response){
					hideNotice("");
					if(response.responseText == 'N'){
						deleteStatus = true;
					}else if (response.responseText == 'Y'){
						//showMessageBox("There are existing details for this Treaty No. You cannot delete this record.");
						showMessageBox("Cannot delete record from GIIS_XOL while dependent record(s) in GIIS_DIST_SHARE exists. ", "E");
						xolRows.refresh();
					}
				}
			});
		}catch(e){
			showErrorMessage("validateDeleteXol", e);
		}
	}
	
	$$("input[name='optShareType']").each(function(row) {
		$(row.id).observe("click", function() {
			var prevShareType = shareType;
			if (objUW.hideGIIS060.lineCd == null){
				showMessageBox("Please select a line code.");
				setShareTypeRadio(prevShareType);
			}else{
				if(row.checked == true) {
					if(changeTag == 1){
						showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
								function() {
									if (valChangeOfShareType()) {
										/*shareType = row.value; commented out by Gzelle 02272015*/ 
										objGIIS060.showTGShareType = shareType; 
										objGIIS060.changeShareType = showTableGrid;
										prevShareType != "4" ? objGIIS060.saveDistShare(unescapeHTML2(objUW.hideGIIS060.lineCd)) : objGIIS060.saveXol(unescapeHTML2(objUW.hideGIIS060.lineCd));
									}
								},
								function() {
									shareType = row.value; showTableGrid(shareType); changeTag = 0; populateDetails(null);
								},
								function() {
									""; setShareTypeRadio(prevShareType);
								});		
						/*showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
		 						function(){shareType = row.value; objGIIS060.showTGShareType = row.value; objGIIS060.changeShareType = showTableGrid;
		 						           prevShareType != "4" ? objGIIS060.saveDistShare(objUW.hideGIIS060.lineCd) : objGIIS060.saveXol(objUW.hideGIIS060.lineCd);}, 
								function(){shareType = row.value; showTableGrid(shareType); changeTag = 0; populateDetails(null);}, 
								function(){""; setShareTypeRadio(prevShareType);});	commented out by Gzelle 02102015 - replaced with codes above*/				
					}else{
						shareType = row.value; 
						showTableGrid(shareType);
						changeTag = 0;
					}
				}
			}
			objGIIS060.showTGShareType = row.value;
		});
	});
	
	function showTableGrid(shareType){
		if(shareType != "4"){
			$("distributionShareTableGrid").show();	
			$("xolTableGrid").hide();
			objGIIS060.loadDistShare(shareType);
			/* Removed by J. Diago 12.11.2013
			$("txtRemarks").enable();
			$("editRemarksText").stopObserving("click");
			$("editRemarksText").observe("click", function () {
				showEditor("txtRemarks", 4000);
			}); 
			*/
			distShareTableGrid.onRemoveRowFocus();
			$("lblShareCode").innerHTML = "Share Code"; // added by: Nica 05.24.2013
			$("lblShareName").innerHTML = "Share Name/Treaty Name";
			if (!$("txtShareCode").hasClassName('required')){
				$('txtShareCode').addClassName('required');
			}
			$("txtShareCode").readOnly = false;
		}else{
			$("xolTableGrid").show();
			$("distributionShareTableGrid").hide();
			objGIIS060.loadDistShare(shareType);
			/* Removed by J. Diago 12.11.2013 
			$("txtRemarks").disable();
			$("editRemarksText").stopObserving("click");
			$("editRemarksText").observe("click", function () {
				showEditor("txtRemarks", 4000, 'true');
			}); */
			
			distShareTableGrid.onRemoveRowFocus();
			$("lblShareCode").innerHTML = "XOL No.";
			$("lblShareName").innerHTML = "XOL Name";
			if ($("txtShareCode").hasClassName('required')){
				$('txtShareCode').removeClassName('required');
			}
			$("txtShareCode").readOnly = true;
		}
		populateDetails(null); // Added by J. Diago
	}
		
	$("txtShareName").observe("keyup", function(){
		this.value = this.value.toUpperCase();
	});
	$("txtShareName").observe("blur", function(){
		this.value = trim(this.value);
	});
 	
	$("txtRemarks").observe("blur", function(){
		this.value = trim(this.value);
 	});
	$("editRemarksText").observe("click", function () {
		showEditor("txtRemarks", 4000);
	}); 
	
	/*
	$("editRemarksText").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	*/
	$("btnAddDShare").observe("click", function(){
		if (objUW.hideGIIS060.lineCd == null){
			showMessageBox("Please select a line code.");
		}else if(checkAllRequiredFieldsInDiv("distributionShareInfo")){
			if(shareType != "4"){
				addUpdateDistShare();	
			}else{
				addUpdateXol();
			}
		}
	});
	
	$("btnDeleteDShare").observe("click", function(){
		if(shareType != "4"){
			deleteDistShare();
		}else{
			deleteXol();
		}	
	});
	$("btnTreatyDetails").observe("click", function(){
		if(changeTag != 0){
			showMessageBox("Please save changes first.", "I");
		} else {
			if(shareType == 2){
				showProportionalTreatyInfo();
			} else if(shareType == 4){
				showNonProportionalTreatyInfo();
			} else {
				showMessageBox(objCommonMessage.UNAVAILABLE_MODULE, imgMessage.INFO);
			}	
		}
	});
	
	$("txtShareCode").observe("change", function(){ // Added by J. Diago 12.11.2013
		if($F("txtShareCode") != null || $F("txtShareCode") != ""){
			if($F("txtShareCode") == "0"){
				$("txtShareCode").value = "";
				showMessageBox("Kindly enter a number between 1 and 999.", imgMessage.ERROR);
			} else {
				whenValidateItemShareCd();
			}
		}
	});
	
	$("txtShareName").observe("change", function(){ // Added by J. Diago 12.11.2013
		if($F("txtShareName") != null || $F("txtShareName") != ""){
			whenValidateItemShareName();
		}
	});
	
	populateDetails(null);
	$("xolTableGrid").hide();
	disableButton("btnTreatyDetails");
	
	function showProportionalTreatyInfo(){
		try{
			new Ajax.Request(contextPath + "/GIISDistributionShareController", {
				method: "POST",
				parameters : {
					action : "showProportionalTreatyInfo",
					lineCd: objUW.hideGIIS060.lineCd,
					shareCd: objUW.hideGIIS060.shareCd
				},
				onCreate : showNotice("Loading, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						$("mainContents").update(response.responseText);
						
					}
				}
			});
		}catch(e){
			showErrorMessage("showProportionalTreatyInfo",e);
		}
	}
	
	function showNonProportionalTreatyInfo(){
		try{
			new Ajax.Request(contextPath + "/GIISDistributionShareController", {
				method: "POST",
				parameters : {
					action : "showNonProportionalTreatyInfo",
					xolId: objUW.hideGIIS060.xolId
				},
				onCreate : showNotice("Loading, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						$("mainContents").update(response.responseText);
						
					}
				}
			});
		}catch(e){
			showErrorMessage("showNonProportionalTreatyInfo",e);
		}
	}
	
	//added by Gzelle 02102015
	function valChangeOfShareType() {
		var ret = false;
		for ( var i = 0; i < objUW.hideGIIS060.distShareRows.length; i++) {
			if($("rdoNetRetention").checked){
				if(objUW.hideGIIS060.distShareRows[i]['shareCd'] == "999"){
					$("rdoFacultative").checked = true;
					shareType = $("rdoFacultative").value;
					ret = true;
				}
			} else if($("rdoPropTreaty").checked){
				if(objUW.hideGIIS060.distShareRows[i]['shareCd'] == "1"){
					$("rdoNetRetention").checked = true;
					shareType = $("rdoNetRetention").value;
					ret = true;
				} else if(objUW.hideGIIS060.distShareRows[i]['shareCd'] == "999"){
					$("rdoFacultative").checked = true;
					shareType = $("rdoFacultative").value;
					ret = true;
				}
			} else if($("rdoFacultative").checked){
				if(objUW.hideGIIS060.distShareRows[i]['shareCd'] == "1"){
					$("rdoNetRetention").checked = true;
					shareType = $("rdoNetRetention").value;
					ret = true;
				}
			}else {
				if(objUW.hideGIIS060.distShareRows[i]['trtyName'] == "FACULTATIVE" && objUW.hideGIIS060.distShareRows[i]['shareCd'] != "999"){
					ret = true;
				} else if(objUW.hideGIIS060.distShareRows[i]['trtyName'] == "NET RETENTION" && objUW.hideGIIS060.distShareRows[i]['shareCd'] != "1"){
					ret = true;
				} else if(objUW.hideGIIS060.distShareRows[i]['shareCd'] == "1"){
					$("rdoNetRetention").checked = true;
					shareType = $("rdoNetRetention").value;
					ret = true;
				} else if(objUW.hideGIIS060.distShareRows[i]['shareCd'] == "999"){
					$("rdoFacultative").checked = true;
					shareType = $("rdoFacultative").value;
					ret = true;
				}
			}
		}
		return ret;
	}
</script> 
