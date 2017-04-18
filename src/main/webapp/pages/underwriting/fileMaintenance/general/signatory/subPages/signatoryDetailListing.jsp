<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" name="innerDiv">
		<label>Signatory Maintenance</label>
		<span class="refreshers" style="margin-top: 0;">
			<label name="gro" style="margin-left: 5px;">Hide</label>
		</span>
	</div>
</div>
<div id="tableGridSectionDiv2" class="sectionDiv" style="height: 480px;">
	<div id="signatoryTableGridDiv" style= "padding: 10px; padding-left: 80px; height: 265px;">
		
	</div>
	
	<div id="signatoryInfoDiv" name="signatoryInfoDiv" style="margin: 3px;">
		<table align="center" border="0">
			<tr>
				<td>
				</td>
				<td colspan="3">
					<div style="float: left; padding-left: 4px;">
						<input id="chkCurrentSignatorySw" type="checkbox" value="Y" name="chkCurrentSignatorySw" style="float: left;" tabindex=201 >
						<label title="Current Signatory Switch" for="chkCurrentSignatorySw" style="float:left; margin-left:5px; margin-bottom: 3px;">Current Signatory Switch</label>
					</div>					
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Signatory</td>
				<td class="leftAligned" colspan="3">
					<span class="lovSpan required" style="width: 120px; margin-right: 0px;">
						<input id="txtSignatoryId" type="text" class="required integerNoNegative" lpad="12" ignoreDelKey="true" style="width: 95px; border: none; height: 14px; margin: 0; text-align: right;" tabindex="202" lastValidValue="" maxlength="12"/>						
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="hrefSignatoryId" alt="Go" style="float: right;"/>
					</span>
					<input id="txtSignatory" type="text" style="width: 367px; margin: 0; margin-left: 4px;" lastValidValue="" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Remarks</td>
				<td class="leftAligned" colspan="3">
					<div style="float: left; width: 499px; border: 1px solid gray; height: 21px; margin: 0;">
						<textarea id="txtRemarks" style="width: 473px; border: none; height: 13px; resize: none;" name="txtRemarks" maxlength="4000"  tabindex=204 ></textarea>
						<img id="editRemarksText" class="hover" tabindex="206/" alt="EditRemark" style="width: 14px; height: 14px; margin: 3px; float: right;" src="/Geniisys/images/misc/edit.png">
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">User ID</td>
				<td class="leftAligned"><input id="txtUserID" type="text" class="" style="width: 180px;" readonly="readonly" tabindex="205"></td>
				<td width="113px" class="rightAligned">Last Update</td>
				<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 180px;" readonly="readonly" tabindex="206"></td>
			</tr>
			
			<input id="hidFileName" type="hidden" />
			<input id="hidStatus" type="hidden" />
		</table>
	</div>
	
	<div class="buttonsDiv" style="margin-bottom: 0px;">
		<input type="button" class="button" id="btnAddSignatory" name="btnAddSignatory" value="Add" tabindex=207 />
		<input type="button" class="button" id="btnDeleteSignatory" name="btnDeleteSignatory" value="Delete" tabindex=208 />
	</div>
	
	<div class="buttonsDiv">
		<input type="button" class="button" id="btnAttach" name="btnAttach" value="Attach" tabindex=209 style="width: 50px;"/>
		<input type="button" class="button" id="btnView" name="btnView" value="View" tabindex=210 style="width: 50px;"/>
	</div>
</div>
             
<script>
	var signatoryDetailRows = "";
	objSignatoryCurrentRow = new Object();
	
	function disableFields(){
		$("chkCurrentSignatorySw").checked = false;
		$("chkCurrentSignatorySw").disabled = true;
		
		$("txtSignatoryId").clear();
		$("txtSignatoryId").readOnly = true;
		$("txtSignatory").clear();
		$("txtRemarks").clear();
		$("txtRemarks").readOnly = true;
		
		disableSearch("hrefSignatoryId");
		
		$("btnAddSignatory").value = "Add";
		
		disableButton("btnDeleteSignatory");
		disableButton("btnAddSignatory");
		disableButton("btnAttach");
		disableButton("btnView");
	}
	
	$("editRemarksText").observe("click", function () {
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").readAttribute("readonly") == '' ? true : false);
	});
	
	$("btnAddSignatory").observe("click", function () {
		addSignatory();
	});
	
	$("btnDeleteSignatory").observe("click", function () {
		deleteSignatory();
	});
	
	$("btnAttach").observe("click", function () {
		if(changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else{
			attachSignature();
		}
	});
	
	function attachSignature(){		
		if($F("hidStatus") == 3){
			showMessageBox("Signatory has already resigned. Cannot attach signature.", "I");
		}else{
			if($F("hidFileName") != ""){
				showConfirmBox("Signatory Attachment", "Do you want to replace the current signature attached?", "Yes", "No", showBrowsePicture, "", "");
			}else{
				showBrowsePicture();
			}
		}		
	}
	
	$("btnView").observe("click", function(){
		//viewAttachment();
		viewAttachment2();
	});	
	
	//pol cruz - 10.23.2013
	//saves the file in the server first before showing it in other window
	function viewAttachment2(){
		if($F("hidFileName") == ""){
			showMessageBox("No attachment found.", "I");
		} else {
			try{
				new Ajax.Request(contextPath+"/GIISSignatoryController", {
					method: "POST",
					parameters : {
					action : "GIISS116WriteFileToServer",
					fileName2 : $F("hidFileName"),
				  	fileName : $F("hidFileName").substring($F("hidFileName").lastIndexOf("/") + 1)
								  },
				  onCreate:function(){
						showNotice("Processing, please wait...");
					},
					onComplete : function(response){
						hideNotice();
						if(checkErrorOnResponse(response)){
							window.open(contextPath + $F("hidFileName").substr($F("hidFileName").indexOf("/", 3), $F("hidFileName").length));
						}
					}
				});
			}catch(e){
				showErrorMessage("viewAttachment2",e);
			}
		}
	}
	
	function prepareNotInParam(){
		var notIn = "";
		
		for(var i = 0; i < usedSignatories.length; i++){
			notIn += usedSignatories[i] + ",";
		}
		
		notIn = "(" + notIn.substr(0, notIn.length - 1) + ")";
		
		if(notIn == "()")
			return "(-99999)";
		else
			return notIn;
	}
	
	function showBrowsePicture(){
		try{
			overlayBrowsePicture = Overlay.show(contextPath+"/GIISSignatoryController", {
				urlContent: true,
				urlParameters: {action : "showAttachPicture",						
								ajax : "1",
								signatoryId : removeLeadingZero($F("txtSignatoryId"))},
			    title: "Browse Picture",
			    height: 115,
			    width: 355,
			    draggable: true
			});
		}catch(e){
			showErrorMessage("showAttachPicture", e);
		}
	};
	
	function addSignatory(){
		try{
			var signatory = createSignatory();
			if ($F("btnAddSignatory") == "Add"){
				if($F("txtSignatoryId") == ""){
					customShowMessageBox(objCommonMessage.REQUIRED,'I','txtSignatoryId');
				}else{
					if(objSignatoryDetail.rows == undefined){
						objSignatoryDetail.rows = [];
					}
					objSignatoryDetail.rows.push(signatory);
					signatoryDetailGrid.addBottomRow(signatory);
					changeTag = 1;
					signatoryChangeTag = 1;
					usedSignatories.push(removeLeadingZero(signatory.signatoryId));
					setSignatoryFields(null);
					changeTagFunc = objGIISS116Func.saveSignatory;
				}
			}else if($F("btnAddSignatory") == "Update"){
				signatoryDetailGrid.updateVisibleRowOnly(signatory, signatoryDetailGrid.getCurrentPosition()[1]);
				changeTag = 1;
				signatoryChangeTag = 1;
				changeTagFunc = objGIISS116Func.saveSignatory;
				setSignatoryFields(null);
			}	
		}catch (e){
			showErrorMessage("addSignatory", e);
		}
	}
	
	function deleteSignatory(){
		try{
			signatoryDetailRows[signatoryRowIndex].recordStatus = -1;
			signatoryDetailGrid.deleteRow(signatoryRowIndex);
			changeTag = 1;
			signatoryChangeTag = 1;
			changeTagFunc = objGIISS116Func.saveSignatory;
			
			for(var i = 0; i < usedSignatories.length; i++){
				if(removeLeadingZero($F("txtSignatoryId")) == usedSignatories[i]){
					usedSignatories.splice(i, 1);
					break;
				}
			}
			setSignatoryFields(null);
		}catch (e){
			showErrorMessage("deleteSignatory", e);
		}
	}
	
	function createSignatory(){
		try{
			var signatory = new Object();
			signatory.reportId 				= escapeHTML2($F("txtReportId")); 
			signatory.issCd					= escapeHTML2($F("txtIssCd"));
			signatory.lineCd				= escapeHTML2($F("txtLineCd"));
			signatory.fileName 				= escapeHTML2($F("hidFileName"));
			signatory.currentSignatorySw 	= $("chkCurrentSignatorySw").checked == false ? "N" : "Y";
			signatory.signatoryId 			= $F("txtSignatoryId");
			signatory.signatory 			= escapeHTML2($F("txtSignatory"));
			signatory.status				= $F("hidStatus");
			signatory.userId				= escapeHTML2("${userId}");
			signatory.remarks 				= escapeHTML2($F("txtRemarks"));
			var lastUpdate = new Date();
			signatory.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			return signatory;
		}catch (e){
			showErrorMessage("createSignatory", e);
		}
	}
	
	function setSignatoryFields(obj) {
		try {
			if(reportRowIndex < 0){
				disableFields();
				return;
			}					
			
			$("hidFileName").value = obj == null ? "" : unescapeHTML2(obj.fileName);
			$("chkCurrentSignatorySw").checked = obj == null ? false : (obj.currentSignatorySw == "Y" ? true : false);
			$("txtSignatoryId").value = obj == null ? "" : formatNumberDigits(obj.signatoryId, 12);				
			$("txtSignatory").value = obj == null ? "" : unescapeHTML2(obj.signatory);
			$("txtRemarks").value = obj == null ? "" : unescapeHTML2(obj.remarks);  
			$("hidStatus").value = obj == null ? "" : obj.status;                      
			$("txtUserID").value = obj == null ? "" : unescapeHTML2(obj.userId);
			$("txtLastUpdate").value = obj == null ? "" : obj.lastUpdate;
			
			$("txtSignatoryId").setAttribute("lastValidValue", (obj == null ? "" : $F("txtSignatoryId")));
			$("txtSignatory").setAttribute("lastValidValue", (obj == null ? "" : unescapeHTML2(obj.signatory)));
			
			obj == null ? $("btnAddSignatory").value = "Add" : $("btnAddSignatory").value = "Update";				
			obj == null ? enableSearch("hrefSignatoryId") : disableSearch("hrefSignatoryId");
			
			obj == null ? disableButton("btnDeleteSignatory") : enableButton("btnDeleteSignatory");
			obj == null ? disableButton("btnAttach") : enableButton("btnAttach");
			obj == null ? disableButton("btnView") : enableButton("btnView");
			obj == null ? $("txtSignatoryId").readOnly = false : $("txtSignatoryId").readOnly = true;
			
			$("chkCurrentSignatorySw").disabled = false;
			enableButton("btnAddSignatory");
			$("txtRemarks").readOnly = false;
		} catch (e) {
			showErrorMessage("setSignatoryFields", e);
		}
	}
	
	function showGIISS116SignatoryLOV(notIn){
		try{
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGIISS116SignatoryLOV",
					notIn : notIn,
					filterText : ($F("txtSignatoryId") == $("txtSignatoryId").readAttribute("lastValidValue") ? "" : $F("txtSignatoryId")),
				},
				title: "List of Signatories",
				width : 450,
				height : 386,
				columnModel : [
	               {
	            	   id : "signatoryId",
	            	   title : "Signatory ID",
	            	   width : 90,
	            	   align: "right",
	            	   titleAlign : "right",
	            	   renderer: function(val) {
	            		   return formatNumberDigits(val, 12);
	            	   }
	               },
	               {
	            	   id : "signatory",
	            	   title : "Signatory",
	            	   width : 345
	               }
				],
				draggable : true,
				autoSelectOneRecord: true,
				filterText : ($F("txtSignatoryId") == $("txtSignatoryId").readAttribute("lastValidValue") ? "" : $F("txtSignatoryId")),
				onSelect: function(row){
					$("txtSignatoryId").value = formatNumberDigits(row.signatoryId, 12);
					$("txtSignatory").value = unescapeHTML2(row.signatory);
					$("txtSignatoryId").setAttribute("lastValidValue", $F("txtSignatoryId"));
					$("txtSignatory").setAttribute("lastValidValue", $F("txtSignatory"));
				},
				onCancel : function () {
					$("txtSignatoryId").value = $("txtSignatoryId").readAttribute("lastValidValue");
					$("txtSignatory").value = $("txtSignatory").readAttribute("lastValidValue");
					$("txtSignatoryId").focus();
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtSignatoryId");
					$("txtSignatoryId").value = $("txtSignatoryId").readAttribute("lastValidValue");
					$("txtSignatory").value = $("txtSignatory").readAttribute("lastValidValue");
					$("txtSignatoryId").focus();		
				}
			});
		}catch(e){
			showErrorMessage("showGIISS116SignatoryLOV", e);
		}
	}
	
	$("hrefSignatoryId").observe("click", function () {
		showGIISS116SignatoryLOV(prepareNotInParam());
	});
	
	$("txtSignatoryId").observe("change", function(){
		if(this.value.trim() == "") {
			$("txtSignatoryId").clear();
			$("txtSignatory").clear();
			$("txtSignatoryId").setAttribute("lastValidValue", "");
			$("txtSignatory").setAttribute("lastValidValue", "");
			return;
		}
		showGIISS116SignatoryLOV(prepareNotInParam());
	});
	
	try {
		var signatoryRowIndex = -1;
		var objSignatoryDetailMain = [];
		var objSignatoryDetail = new Object();
		objSignatoryDetail.objSignatoryDetailListing = JSON.parse('${signatoryDetailMaintenance}'.replace(/\\/g, '\\\\'));
		objSignatoryDetail.objSignatoryDetailMaintenance = objSignatoryDetail.objSignatoryDetailListing.rows || [];
		
		var signatoryDetailTable = {
				url: contextPath+"/GIISSignatoryController?action=getReportSignatoryDetails",
				options: {
					id: 2,
					title: '',
					height: 240,
					width: 765,
					onCellFocus : function(element, value, x, y, id){
						signatoryRowIndex = y;
						setSignatoryFields(signatoryDetailGrid.geniisysRows[y]);
						signatoryDetailGrid.keys.removeFocus(signatoryDetailGrid.keys._nCurrentFocus, true);
						signatoryDetailGrid.keys.releaseKeys();
					},
					onRemoveRowFocus : function(){
						signatoryRowIndex = -1;
						setSignatoryFields(null);
						signatoryDetailGrid.keys.removeFocus(signatoryDetailGrid.keys._nCurrentFocus, true);
						signatoryDetailGrid.keys.releaseKeys();
					},					
					toolbar : {
						elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
						onFilter: function(){
							signatoryRowIndex = -1;
							setSignatoryFields(null);
							signatoryDetailGrid.keys.removeFocus(signatoryDetailGrid.keys._nCurrentFocus, true);
							signatoryDetailGrid.keys.releaseKeys();
						}
					},
					beforeSort : function(){
						if(signatoryChangeTag == 1){
							showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
							return false;
						}
					},
					beforeClick : function() {
						
					},
					onSort: function(){
						signatoryRowIndex = -1;
						setSignatoryFields(null);
						signatoryDetailGrid.keys.removeFocus(signatoryDetailGrid.keys._nCurrentFocus, true);
						signatoryDetailGrid.keys.releaseKeys();
					},
					onRefresh: function(){
						signatoryRowIndex = -1;
						setSignatoryFields(null);
						signatoryDetailGrid.keys.removeFocus(signatoryDetailGrid.keys._nCurrentFocus, true);
						signatoryDetailGrid.keys.releaseKeys();
					},				
					prePager: function(){
						if(signatoryChangeTag == 1){
							showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
							return false;
						}
						signatoryRowIndex = -1;
						setSignatoryFields(null);
						signatoryDetailGrid.keys.removeFocus(signatoryDetailGrid.keys._nCurrentFocus, true);
						signatoryDetailGrid.keys.releaseKeys();
					},
					checkChanges: function(){
						return (signatoryChangeTag == 1 ? true : false);
					},
					masterDetailRequireSaving: function(){
						return (signatoryChangeTag == 1 ? true : false);
					},
					masterDetailValidation: function(){
						return (signatoryChangeTag == 1 ? true : false);
					},
					masterDetail: function(){
						return (signatoryChangeTag == 1 ? true : false);
					},
					masterDetailSaveFunc: function() {
						return (signatoryChangeTag == 1 ? true : false);
					},
					masterDetailNoFunc: function(){
						return (signatoryChangeTag == 1 ? true : false);
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
						id: 'currentSignatorySw',
				    	title: '&nbsp;&nbsp;C',
				    	altTitle: "Current Signatory",
				    	width: 30,
		            	align: 'center',
						titleAlign: 'center',
				    	defaultValue: false,
						otherValue: false,
						filterOption: true,
						filterOptionType : "checkbox",
				    	editor: new MyTableGrid.CellCheckbox({
					        getValueOf: function(value){
					        	if (value){
									return "Y";
				            	}else{
									return "N";	
				            	}
					        }
				    	})
					},
					{
						id: 'signatoryId',
						title: 'Signatory ID',
						width: 100,
						align: 'right',
						titleAlign: 'right',
						editable: false,
						filterOption: true,
						filterOptionType: "integerNoNegative",
						renderer: function(val) {
							return val != null ? formatNumberDigits(val, 12) : null;
						}
					},
					{
						id: 'signatory',
						title: 'Signatory',
						width: 605,
						editable: false,
						filterOption: true
					}
				],
				rows: objSignatoryDetail.objSignatoryDetailListing.rows
		};
		
		signatoryDetailGrid = new MyTableGrid(signatoryDetailTable);
		signatoryDetailGrid.pager = objSignatoryDetail.objSignatoryDetailListing;
		signatoryDetailGrid.render('signatoryTableGridDiv');
		signatoryDetailGrid.afterRender = function(){
			signatoryDetailRows = signatoryDetailGrid.geniisysRows;
			setSignatoryFields(null);
		};
		
	} catch(e) {
		showErrorMessage("prepareSignatoryDetailTG", e);
	}
</script>