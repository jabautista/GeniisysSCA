<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss010MainDiv" name="giiss010MainDiv" style="">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Deductible Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss010" name="giiss010">		
		<div class="sectionDiv">
			<div style="" align="center" id="lineDiv">
				<table cellspacing="2" border="0" style="margin: 10px 10px 10px 30px;">	 			
					<tr>
						<td class="rightAligned" style="" id="">Line</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan required" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required allCaps" type="text" id="txtLineCd" name="txtLineCd" style="width: 40px; float: left; border: none; height: 13px; margin: 0;" maxlength="2" tabindex="101" lastValidValue="" ignoreDelKey="1"/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineLOV" name="searchLineLOV" alt="Go" style="float: right;" tabindex="102"/>
							</span>
							<input id="txtLineName" name="txtLineName" type="text" style="width: 280px;" value="" readonly="readonly" tabindex="103"/>
						</td>	
						<td class="rightAligned" style="padding-left: 35px;" id="">Subline</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan required" style="float: left; width: 80px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required allCaps" type="text" id="txtSublineCd" name="txtSublineCd" style="width: 55px; float: left; border: none; height: 13px; margin: 0;" maxlength="7" tabindex="104" lastValidValue="" ignoreDelKey="1"/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchSublineLOV" name="searchSublineLOV" alt="Go" style="float: right;" tabindex="105"/>
							</span>
							<input id="txtSublineName" name="txtSublineName" type="text" style="width: 280px;" value="" readonly="readonly" tabindex="106"/>
						</td>					
					</tr>
				</table>			
			</div>		
		</div>
		<div class="sectionDiv">
			<div id="deductibleDescTableDiv" style="padding-top: 10px;">
				<div id="deductibleDescTable" style="height: 335px; margin-left: 10px;"></div>
			</div>
			<div align="center" id="deductibleDescFormDiv">
				<table style="margin: 5px 15px 0 70px; float: left;">
					<tr>
						<td class="rightAligned"></td>
						<td colspan="4">
							<input id="fixedAmtRB" name="deductibleTypeRG" type="radio" value="F" checked="checked" style="float: left; margin: 8px 7px 0 0px;">
							<label for="fixedAmtRB" style="float: left; margin: 7px 0 5px 0;">Fixed Amount</label>
							<input id="lossAmtRB" name="deductibleTypeRG" type="radio" value="L" style="float: left; margin: 8px 7px 0 30px;">
							<label for="lossAmtRB" style="float: left; margin: 7px 0 5px 0;">% of Loss Amount</label>
							<input id="tsiAmtRB" name="deductibleTypeRG" type="radio" value="T" style="float: left; margin: 8px 7px 0 30px;">
							<label for="tsiAmtRB" style="float: left; margin: 7px 0 5px 0;">% of TSI Amount</label>
							<input id="insuredAmtRB" name="deductibleTypeRG" type="radio" value="I" style="float: left; margin: 8px 7px 0 30px;">
							<label for="insuredAmtRB" style="float: left; margin: 7px 0 5px 0;">% of Insured's Value<br>at the time of Loss</label>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Deductible</td>
						<td class="leftAligned" colspan="4">
							<input id="txtDeductibleCd" type="text" class="required" style="width: 90px; text-align: left;" tabindex="201" maxlength="5">
							<input id="txtDeductibleTitle" type="text" class="required" style="width: 460px;" tabindex="202" maxlength="30">
						</td>
					</tr>		
					<tr>
						<td class="rightAligned">Deductible Amount</td>
						<td class="leftAligned"><input id="txtDeductibleAmt" type="text" class="required applyDecimalRegExp2" regExpPatt="pDeci1302" style="width: 200px;" tabindex="203" maxlength="13" customLabel="Deductible Amount" min="0.01" max="9999999999.99" hideErrMsg="Y"></td>
						<td width="" class="rightAligned" style="padding-left: 23px;"><label id="lblDeductibleRate">% of Loss Amount</label></td>
						<td class="leftAligned"><input id="txtDeductibleRate" type="text" class="required applyDecimalRegExp2" regExpPatt="pDeci1309" maxlength="13" style="width: 200px;" tabindex="204" min="0.000000001" max="999.999999999" hideErrMsg="Y"></td>
					</tr>	
					<tr>
						<td class="rightAligned">Minimum Amount</td>
						<td class="leftAligned"><input id="txtMinimumAmount" type="text" class="applyDecimalRegExp2" regExpPatt="pDeci1302"  maxlength="13" style="width: 200px;" tabindex="205" customLabel="Minimum Amount" min="0.01" max="9999999999.99" hideErrMsg="Y"></td>
						<td width="" class="rightAligned" style="">Maximum Amount</td>
						<td class="leftAligned"><input id="txtMaximumAmount" type="text" class="applyDecimalRegExp2" regExpPatt="pDeci1302" maxlength="13"  style="width: 200px;" tabindex="206" customLabel="Maximum Amount" min="0.01" max="9999999999.99" hideErrMsg="Y"></td>
					</tr>
					<tr>
						<td class="rightAligned" style="vertical-align: top;">Deductible Text</td>
						<td class="leftAligned" colspan="4">
							<textarea style="float: left; height: 80px; width: 561px;" id="txtDeductibleText" maxlength="2000" class="required"  onkeyup="limitText(this,2000);" tabindex="207"></textarea>
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="4">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 567px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 540px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="208"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="209"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="210"></td>
						<td width="" class="rightAligned" style="padding-left: 39px;">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="211"></td>
					</tr>			
				</table>
				
				<div id="rangeSwDiv" class="sectionDiv" style="width: 100px; height: 90px; margin-top: 120px;">
					<table>
						<tr>
							<td>
								<input id="higherRB" name="rangeSwRG" type="radio" value="H" style="float: left; margin: 8px 7px 0 0px;">
								<label for="higherRB" style="float: left; margin: 7px 0 5px 0;">Higher</label>
							</td>
						</tr>
						<tr>
							<td>
								<input id="lowerRB" name="rangeSwRG" type="radio" value="L" style="float: left; margin: 6px 7px 0 0px;">
								<label for="lowerRB" style="float: left; margin: 5px 0 5px 0;">Lower</label>
							</td>
						</tr>
						<tr>
							<td>
								<input id="noRangeRB" name="rangeSwRG" type="radio" value="" checked="checked" style="float: left; margin: 6px 7px 0 0px;">
								<label for="noRangeRB" style="float: left; margin: 5px 0 5px 0;">No Range</label>
							</td>
						</tr>
					</table>
				</div>
			</div>
			<div style="margin: 10px 0 10px 0;" class="buttonsDiv">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="212">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="213">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="212">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="213">
</div>
<script type="text/javascript">	
	setModuleId("GIISS010");
	setDocumentTitle("Deductible Maintenance");
	
	changeTag = 0;
	var rowIndex = -1;
	var deductibleTypeRB = $F("fixedAmtRB");
	var rangeSwRB = $F("noRangeRB");
	
	function saveGiiss010(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgDeductibleDesc.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgDeductibleDesc.geniisysRows);
		new Ajax.Request(contextPath+"/GIISDeductibleDescController", {
			method: "POST",
			parameters : {action : "saveGiiss010",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS010.afterSave != null) {
							objGIISS010.afterSave();
							objGIISS010.afterSave = null;
						} else {
							tbgDeductibleDesc._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss010);
	
	var objGIISS010 = {};
	var objDeductibleDesc = null;
	objGIISS010.deductibleDescList = JSON.parse('${jsonDeductiblesList}');
	objGIISS010.afterSave = null;
	
	var deductibleDescTable = {
			url : contextPath + "/GIISDeductibleDescController?action=showGiiss010&refresh=1",
			options : {
				width : '900px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objDeductibleDesc = tbgDeductibleDesc.geniisysRows[y];
					setFieldValues(objDeductibleDesc);
					tbgDeductibleDesc.keys.removeFocus(tbgDeductibleDesc.keys._nCurrentFocus, true);
					tbgDeductibleDesc.keys.releaseKeys();
					$("txtDeductibleTitle").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgDeductibleDesc.keys.removeFocus(tbgDeductibleDesc.keys._nCurrentFocus, true);
					tbgDeductibleDesc.keys.releaseKeys();
					$("txtDeductibleCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgDeductibleDesc.keys.removeFocus(tbgDeductibleDesc.keys._nCurrentFocus, true);
						tbgDeductibleDesc.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
				},
				onSort: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgDeductibleDesc.keys.removeFocus(tbgDeductibleDesc.keys._nCurrentFocus, true);
					tbgDeductibleDesc.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgDeductibleDesc.keys.removeFocus(tbgDeductibleDesc.keys._nCurrentFocus, true);
					tbgDeductibleDesc.keys.releaseKeys();
				},				
				prePager: function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
					rowIndex = -1;
					setFieldValues(null);
					tbgDeductibleDesc.keys.removeFocus(tbgDeductibleDesc.keys._nCurrentFocus, true);
					tbgDeductibleDesc.keys.releaseKeys();
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
				{ 								// this column will only use for deletion
				    id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
				    width: '0',				    
				    visible : false			
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},
				{
					id : 'lineCd',
					width : '0',
					visible : false
				},
				{
					id : 'sublineCd',
					width : '0',
					visible : false
				},
				{
					id : 'deductibleText',
					width : '0',
					visible : false
				},
				{
					id : 'minimumAmount',
					width : '0',
					visible : false
				},
				{
					id : 'maximumAmount',
					width : '0',
					visible : false
				},
				{
					id : 'rangeSw',
					width : '0',
					visible : false
				},	
				{
					id : "deductibleCd deductibleTitle",
					title: "Deductible",
					filterOption: true,
					sortable: true,
					children: [
						{
							id: "deductibleCd",
							title: "Deductible Code",
							width: 51,
							filterOption: true
						},
						{
							id: "deductibleTitle",
							title: "Deductible Title",
							width: 337,
							filterOption: true
						}
		            ]
				},	
				{
					id : "deductibleType",
					title : "Deductible Type",
					filterOption : true,
					width : '180px'
				},
				{
					id : 'deductibleRate',
					title : 'Rate',
					align: 'right',
					titleAlign: 'right',
					geniisysClass: 'rate',
					width : '140px',		
					filterOption : true,
					filterOptionType: 'numberNoNegative'
				},
				{
					id : 'deductibleAmt',
					title : 'Deductible Amount',
					align: 'right',
					titleAlign: 'right',
					geniisysClass: 'money',
					width : '140px',		
					filterOption : true,
					filterOptionType: 'numberNoNegative'
				},	
				{
					id : 'remarks',
					width : '0',
					visible: false				
				},
				{
					id : 'userId',
					width : '0',
					visible: false
				},
				{
					id : 'lastUpdate',
					width : '0',
					visible: false				
				}
			],
			rows : objGIISS010.deductibleDescList.rows
		};

		tbgDeductibleDesc = new MyTableGrid(deductibleDescTable);
		tbgDeductibleDesc.pager = objGIISS010.deductibleDescList;
		tbgDeductibleDesc.render("deductibleDescTable");
	
	function setFieldValues(rec){
		try{
			$("txtDeductibleCd").value = (rec == null ? "" : unescapeHTML2(rec.deductibleCd));
			$("txtDeductibleCd").setAttribute("lastValidValue", (rec == null ? "" : $F("txtDeductibleCd")));
			$("txtDeductibleTitle").value = (rec == null ? "" : unescapeHTML2(rec.deductibleTitle));
			$("txtDeductibleText").value = (rec == null ? "" : unescapeHTML2(rec.deductibleText));
			$("txtDeductibleAmt").value = (rec == null ? "" : formatCurrency(rec.deductibleAmt));
			$("txtDeductibleRate").value = (rec == null ? "" : formatCurrency(rec.deductibleRate));
			$("txtMinimumAmount").value = (rec == null ? "" : formatCurrency(rec.minimumAmount));
			$("txtMaximumAmount").value = (rec == null ? "" : formatCurrency(rec.maximumAmount));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtDeductibleCd").readOnly = false : $("txtDeductibleCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			
			if (rec != null){
				deductibleTypeRB = rec.deductibleType;
				$$("input[name='deductibleTypeRG']").each(function(rb){
					if (rb.value == rec.deductibleType){
						rb.checked = true;
					}else{
						rb.checked = false;
					}
					rb.disabled = true;
				});				

				rangeSwRB = rec.rangeSw == null ? "" : rec.rangeSw;
				
			}else{
				$("fixedAmtRB").checked = true;
				deductibleTypeRB = "F";
				$("noRangeRB").checked = true;
				rangeSw = "";
				
				$$("input[name='deductibleTypeRG']").each(function(rb){					
					rb.disabled = false;
				});	
			}
			
			objDeductibleDesc = rec;
			setDeductibleItems();
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.lineCd = escapeHTML2($F("txtLineCd"));
			obj.sublineCd = escapeHTML2($F("txtSublineCd"));
			obj.deductibleCd = escapeHTML2($F("txtDeductibleCd"));
			obj.deductibleTitle = escapeHTML2($F("txtDeductibleTitle"));
			obj.deductibleAmt = unformatCurrency("txtDeductibleAmt");
			obj.deductibleRate = $F("txtDeductibleRate");
			obj.minimumAmount = unformatCurrency("txtMinimumAmount");
			obj.maximumAmount = unformatCurrency("txtMaximumAmount");
			obj.deductibleText = escapeHTML2($F("txtDeductibleText"));
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.rangeSw = deductibleTypeRB == "F" ? null : rangeSwRB;
			obj.deductibleType = deductibleTypeRB;
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGiiss010;
			var deductible = setRec(objDeductibleDesc);
			if($F("btnAdd") == "Add"){
				tbgDeductibleDesc.addBottomRow(deductible);
			} else {
				tbgDeductibleDesc.updateVisibleRowOnly(deductible, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgDeductibleDesc.keys.removeFocus(tbgDeductibleDesc.keys._nCurrentFocus, true);
			tbgDeductibleDesc.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("deductibleDescFormDiv")){
				if($F("btnAdd") == "Add") {					
					if ($("tsiAmtRB").checked && $F("txtDeductibleRate") == "" && $F("txtMinimumAmount") == "" && $F("txtMaximumAmount") == ""){
						showMessageBox("Please enter value to at least one of the fields: <br><ul><li>% of TSI Amount</li><li>Minimum Value</li><li>Maximum Value</li></ul>", "E");
						return;
					}
					
					if (deductibleTypeRB == "L" || deductibleTypeRB == "I"){
						if (rangeSwRB == "" && $F("txtMinimumAmount") != "" && $F("txtMaximumAmount") != ""){
							showMessageBox("Please select either higher or lower for range.", "E");
							return;
						}
					}					
					
					
					var addedSameExists = false;
					var deletedSameExists = false;		
					var addedSameTitleExists = false;
					var deletedSameTitleExists = false;
					
					for(var i=0; i<tbgDeductibleDesc.geniisysRows.length; i++){
						if(tbgDeductibleDesc.geniisysRows[i].recordStatus == 0 || tbgDeductibleDesc.geniisysRows[i].recordStatus == 1){								
							if(unescapeHTML2(tbgDeductibleDesc.geniisysRows[i].deductibleCd) == $F("txtDeductibleCd")){
								addedSameExists = true;								
							}	
							if(unescapeHTML2(tbgDeductibleDesc.geniisysRows[i].deductibleTitle) == $F("txtDeductibleTitle")){
								addedSameTitleExists = true;								
							}
						} else if(tbgDeductibleDesc.geniisysRows[i].recordStatus == -1){
							if(unescapeHTML2(tbgDeductibleDesc.geniisysRows[i].deductibleCd) == $F("txtDeductibleCd")){
								deletedSameExists = true;
							}
							if(unescapeHTML2(tbgDeductibleDesc.geniisysRows[i].deductibleTitle) == $F("txtDeductibleTitle")){
								deletedSameTitleExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same line_cd, subline_cd and deductible_cd.", "E");
						return;
					}else if((addedSameTitleExists && !deletedSameTitleExists) || (deletedSameTitleExists && addedSameTitleExists)){
						showMessageBox("Record already exists with the same deductible_title.", "E");
						return;
					} else if((deletedSameExists && !addedSameExists) || (deletedSameTitleExists && !addedSameTitleExists)){
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIISDeductibleDescController", {
						parameters : {action : 		"valAddRec",
									  lineCd : 		$F("txtLineCd"),
									  sublineCd : 	$F("txtSublineCd"),
									  deductibleCd: $F("txtDeductibleCd"),
									  deductibleTitle: $F("txtDeductibleTitle")},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								addRec();
							}
						}
					});
				} else {
					if ($("tsiAmtRB").checked && $F("txtDeductibleRate") == "" && $F("txtMinimumAmount") == "" && $F("txtMaximumAmount") == ""){
						showMessageBox("Please enter value to at least one of the fields: <br><ul><li>% of TSI Amount</li><li>Minimum Value</li><li>Maximum Value</li></ul>", "E");
						return;
					}
					
					if (deductibleTypeRB == "L" || deductibleTypeRB == "I"){
						if (rangeSwRB == "" && $F("txtMinimumAmount") != "" && $F("txtMaximumAmount") != ""){
							showMessageBox("Please select either higher or lower for range.", "E");
							return;
						}
					}
					
					var addedSameTitleExists = false;
					var deletedSameTitleExists = false;
					
					for(var i=0; i<tbgDeductibleDesc.geniisysRows.length; i++){
						if(tbgDeductibleDesc.geniisysRows[i].recordStatus == 0 || tbgDeductibleDesc.geniisysRows[i].recordStatus == 1){	
							if(unescapeHTML2(tbgDeductibleDesc.geniisysRows[i].deductibleTitle) == $F("txtDeductibleTitle") 
									&& unescapeHTML2(objDeductibleDesc.deductibleTitle) != $F("txtDeductibleTitle") ){
								addedSameTitleExists = true;								
							}
						} else if(tbgDeductibleDesc.geniisysRows[i].recordStatus == -1){
							if(unescapeHTML2(tbgDeductibleDesc.geniisysRows[i].deductibleTitle) == $F("txtDeductibleTitle") 
									&& unescapeHTML2(objDeductibleDesc.deductibleTitle) != $F("txtDeductibleTitle") ){
								deletedSameTitleExists = true;
							}
						}
					}
					
					if((addedSameTitleExists && !deletedSameTitleExists) || (deletedSameTitleExists && addedSameTitleExists)){
						showMessageBox("Record already exists with the same deductible_title.", "E");
						return;
					} else if(deletedSameTitleExists && !addedSameTitleExists){
						addRec();
						return;
					}
					
					var dedTitle = (unescapeHTML2(objDeductibleDesc.deductibleTitle) == $F("txtDeductibleTitle") ? null : $F("txtDeductibleTitle"));
					
					new Ajax.Request(contextPath + "/GIISDeductibleDescController", {
						parameters : {action : 		"valAddRec",
									  lineCd : 		$F("txtLineCd"),
									  sublineCd : 	$F("txtSublineCd"),
									  //deductibleCd: $F("txtDeductibleCd"),
									  deductibleTitle: dedTitle},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								addRec();
							}
						}
					});
				}
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}	
	
	function deleteRec(){
		changeTagFunc = saveGiiss010;
		objDeductibleDesc.recordStatus = -1;
		tbgDeductibleDesc.geniisysRows[rowIndex].lineCd = tbgDeductibleDesc.geniisysRows[rowIndex].lineCd.replace(/\\/g,"&#92;");
		tbgDeductibleDesc.geniisysRows[rowIndex].sublineCd = tbgDeductibleDesc.geniisysRows[rowIndex].sublineCd.replace(/\\/g,"&#92;");
		tbgDeductibleDesc.geniisysRows[rowIndex].deductibleCd = tbgDeductibleDesc.geniisysRows[rowIndex].deductibleCd.replace(/\\/g,"&#92;");
		tbgDeductibleDesc.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISDeductibleDescController", {
				parameters : {action : 		"valDeleteRec",
							  checkBoth:	"Y",
							  lineCd : 		$F("txtLineCd"),
							  sublineCd : 	$F("txtSublineCd"),
							  deductibleCd: $F("txtDeductibleCd")},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						deleteRec();
					}
				}
			});
		} catch(e){
			showErrorMessage("valDeleteRec", e);
		}
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}	
	
	function cancelGiiss010(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS010.afterSave = exitPage;
						saveGiiss010();
					}, function(){
						goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
					}, ""); 
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
	}
	
	function showLineLOV(isIconClicked){
		try{
			var searchString = isIconClicked ? "%" : ($F("txtLineCd").trim() == "" ? "%" : $F("txtLineCd"));	
			
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGiiss010LineLOV",
					searchString : searchString,
					moduleId: 'GIISS010',
					page : 1
				},
				title : "List of Lines",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "lineCd",
					title : "Line Code",
					width : '120px',
				}, {
					id : "lineName",
					title : "Line Name",
					width : '345px'
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("txtLineCd").value = unescapeHTML2(row.lineCd);
						$("txtLineCd").setAttribute("lastValidValue", $F("txtLineCd"));
						$("txtLineName").value = unescapeHTML2(row.lineName);
						$("txtSublineCd").clear();
						$("txtSublineCd").setAttribute("lastValidValue", "");
						$("txtSublineName").clear();
						$("txtSublineCd").readOnly = false;
						enableSearch("searchSublineLOV");
						enableToolbarButton("btnToolbarEnterQuery");
						$("txtSublineCd").focus();
					}
				},
				onCancel: function(){
					$("txtLineCd").focus();
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtLineCd");
				} 
			});
		}catch(e){
			showErrorMessage("showLineLOV", e);
		}		
	}
	
	function showSublineLOV(isIconClicked){
		try{
			var searchString = isIconClicked ? "%" : ($F("txtSublineCd").trim() == "" ? "%" : $F("txtSublineCd"));	
			
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGiiss010SublineLOV",
					lineCd:	$F("txtLineCd"),
					searchString : searchString,
					page : 1
				},
				title : "List of Sublines",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "sublineCd",
					title : "Subline Cd",
					width : '120px',
				}, {
					id : "sublineName",
					title : "Subline Name",
					width : '345px'
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("txtSublineCd").value = unescapeHTML2(row.sublineCd);
						$("txtSublineCd").setAttribute("lastValidValue", $F("txtSublineCd"));
						$("txtSublineName").value = unescapeHTML2(row.sublineName);
						enableToolbarButton("btnToolbarExecuteQuery");
					}
				},
				onCancel: function(){
					$("txtSublineCd").focus();
					$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtSublineCd");
				} 
			});
		}catch(e){
			showErrorMessage("showSublineLOV", e);
		}		
	}
	
	function toggleDeductibleFields(enable){
		try{
			if (enable){
				$$("div#deductibleDescFormDiv input[type='text'], div#deductibleDescFormDiv textarea").each(function(txt){
					if(txt.id != "txtUserId" || txt.id != "txtLastUpdate"){
						txt.readOnly = false;
					}
				});
				$$("div#deductibleDescFormDiv input[type='radio']").each(function(txt){
					txt.disabled = false;
				});
				enableButton("btnAdd");		
			}else{				
				$$("div#deductibleDescFormDiv input[type='text'], div#deductibleDescFormDiv textarea").each(function(txt){
					txt.readOnly = true;
				});
				$$("div#deductibleDescFormDiv input[type='radio']").each(function(txt){
					txt.disabled = true;
				});
				disableButton("btnAdd");
			}
		}catch(e){
			showErrorMessage("toggleDeductibleFields", e);
		}
	}
	
	function setDeductibleItems(){
		try{
			if (deductibleTypeRB == "F"){
				$("txtDeductibleAmt").disabled = false;
				$("txtDeductibleAmt").addClassName("required");
				$("txtDeductibleRate").removeClassName("required");
				$("txtDeductibleRate").disabled = true;
				$("txtMinimumAmount").disabled = true;
				$("txtMaximumAmount").disabled = true;
				$$("input[name='rangeSwRG']").each(function(rb){
					rb.disabled = true;
				});
				$("lblDeductibleRate").innerHTML = "% of Loss Amount";
				$("lblDeductibleRate").style.paddingLeft = "15px";
			}else{
				$("txtDeductibleAmt").disabled = true;
				$("txtDeductibleAmt").removeClassName("required");
				$("txtDeductibleRate").addClassName("required");
				$("txtDeductibleRate").disabled = false;
				$("txtMinimumAmount").disabled = false;
				$("txtMaximumAmount").disabled = false;
				$$("input[name='rangeSwRG']").each(function(rb){
					rb.disabled = false;
					if (rb.value == rangeSwRB){
						rb.checked = true;
					}else{
						rb.checked = false;
					}
				});				
				
				if(deductibleTypeRB == "L"){
					$("lblDeductibleRate").innerHTML = "% of Loss Amount";
					$("lblDeductibleRate").style.paddingLeft = "15px";
					$("txtDeductibleRate").addClassName("required");
				}else if(deductibleTypeRB == "T"){
					$("lblDeductibleRate").innerHTML = "% of TSI Amount";
					$("lblDeductibleRate").style.paddingLeft = "20px";
					$("txtDeductibleRate").removeClassName("required");
				}else if(deductibleTypeRB == "I"){
					$("lblDeductibleRate").innerHTML = "% of Insured's Value <br>at the time of Loss";
					$("lblDeductibleRate").style.paddingLeft = "0px";
					$("txtDeductibleRate").addClassName("required");
				}
			}
			
			
			deductibleTypeRB == "I" ? $("txtDeductibleRate").setAttribute("customLabel", "% of Insured's Value at the time of Loss") : $("txtDeductibleRate").setAttribute("customLabel", $("lblDeductibleRate").innerHTML);
		}catch(e){
			showErrorMessage("setDeductibleItems", e);
		}
	}
	
	function enterQuery(){
		$("txtLineCd").readOnly = false;
		enableSearch("searchLineLOV");
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		tbgDeductibleDesc.url = contextPath+"/GIISDeductibleDescController?action=showGiiss010&refresh=1";
		tbgDeductibleDesc._refreshList();
		$("txtLineCd").clear();
		$("txtLineName").clear();
		$("txtSublineCd").clear();
		$("txtSublineName").clear();
		toggleDeductibleFields(false);
		$("txtLineCd").focus();
		$("txtLineCd").setAttribute("lastValidValue", "");
		$("txtSublineCd").setAttribute("lastValidValue", "");
		changeTag = 0;
	}
	
	$("searchLineLOV").observe("click", function(){
		showLineLOV(true);
	});
	
	$("txtLineCd").observe("change", function(){
		if (this.value != ""){
			showLineLOV(false);
		}else{
			this.setAttribute("lastValidValue", "");
			$("txtLineName").clear();
			$("txtSublineCd").clear();
			$("txtSublineCd").setAttribute("lastValidValue", "");
			$("txtSublineName").clear();
			$("txtSublineCd").readOnly = true;
			disableSearch("searchSublineLOV");
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
		}
	});
	

	$("searchSublineLOV").observe("click", function(){
		showSublineLOV(true);
	});
	
	$("txtSublineCd").observe("change", function(){
		if (this.value != ""){
			showSublineLOV(false);
		}else{
			this.setAttribute("lastValidValue", "");
			$("txtSublineName").clear();
			disableToolbarButton("btnToolbarExecuteQuery");
		}
	});
	
	$$("input[name='deductibleTypeRG']").each(function(rb){
		rb.observe("click", function(){
			deductibleTypeRB = rb.value;
			setDeductibleItems();
		});
	});
	
	$$("input[name='rangeSwRG']").each(function(rb){
		rb.observe("click", function(){
			rangeSwRB = rb.value;
			
			if (deductibleTypeRB == "L" || deductibleTypeRB == "I"){
				if (rb.value == "" && $F("txtMinimumAmount") != "" && $F("txtMaximumAmount") != ""){
					showMessageBox("Please select either higher or lower for range.", "E");
				}
			}
		});
	});
			
	$("txtDeductibleAmt").observe("change", function(){
		if ($F("txtDeductibleRate") != "" && this.value != ""){
			$("txtDeductibleRate").clear();
		}/* else if((parseFloat(this.value) < 0.01) || (unformatCurrencyValue(this.value) > 9999999999.99)) {
			clearFocusElementOnError("txtDeductibleAmt", "Invalid Deductible Amount. Valid value should be from 0.01 to 9,999,999,999.99.");
		} */
	});
	
	$("txtDeductibleRate").observe("change", function(){
		if ($F("txtDeductibleAmt") != "" && this.value != ""){
			$("txtDeductibleAmt").clear();
		}
	});
	
	$("txtMinimumAmount").observe("change", function(){
		if ((this.value != "" && $F("txtMaximumAmount") != "") && (parseFloat(this.value) > parseFloat(unformatCurrency($("txtMaximumAmount"))))){
			this.clear();
			customShowMessageBox("Minimum Amount should not be greater than Maximum Amount.", "E", this.id);
		}/* else if((parseFloat(this.value) < 0.01) || (unformatCurrencyValue(this.value) > 9999999999.99)) {
			clearFocusElementOnError("txtMinimumAmount", "Invalid Minimum Amount. Valid value should be from 0.01 to 9,999,999,999.99.");
		} */
	});
	
	$("txtMaximumAmount").observe("change", function(){
		if ((this.value != "" && $F("txtMinimumAmount") != "") && (parseFloat(this.value) < parseFloat(unformatCurrency($("txtMinimumAmount"))))){
			this.clear();
			customShowMessageBox("Minimum Amount should not be greater than Maximum Amount.", "E", this.id);
		}/* else if((parseFloat(this.value) < 0.01) || (unformatCurrencyValue(this.value) > 9999999999.99)) {
			clearFocusElementOnError("txtMaximumAmount", "Invalid Maximum Amount. Valid value should be from 0.01 to 9,999,999,999.99.");
		} */
	});
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("txtDeductibleTitle").observe("keyup", function(){
		$("txtDeductibleTitle").value = $F("txtDeductibleTitle").toUpperCase();
	});
	
	$("txtDeductibleCd").observe("keyup", function(){
		$("txtDeductibleCd").value = $F("txtDeductibleCd").toUpperCase();
	});
	
	
	$("btnToolbarEnterQuery").observe("click", function(){
		if (changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
					function(){
						objGIISS010.afterSave = enterQuery;
						saveGiiss010();
					},
					function(){
						enterQuery();
					},
					""
			);
		}else{
			enterQuery();
		}
	});
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		disableToolbarButton(this.id);
		enableToolbarButton("btnToolbarEnterQuery");
		tbgDeductibleDesc.url = contextPath+"/GIISDeductibleDescController?action=showGiiss010&refresh=1&lineCd="+encodeURIComponent($F("txtLineCd"))
								+"&sublineCd="+encodeURIComponent($F("txtSublineCd"));
		tbgDeductibleDesc._refreshList();
		$("txtLineCd").readOnly = true;
		$("txtSublineCd").readOnly = true;
		disableSearch("searchLineLOV");
		disableSearch("searchSublineLOV");
		toggleDeductibleFields(true);
		setDeductibleItems();
	});
	
	disableButton("btnDelete");
	showToolbarButton("btnToolbarSave");
	hideToolbarButton("btnToolbarPrint");
	disableToolbarButton("btnToolbarEnterQuery");
	disableToolbarButton("btnToolbarExecuteQuery");
	
	observeSaveForm("btnSave", saveGiiss010);
	observeSaveForm("btnToolbarSave", saveGiiss010);
	$("btnCancel").observe("click", cancelGiiss010);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("btnToolbarExit").stopObserving("click");
	$("btnToolbarExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	$("txtLineCd").focus();	
	$("txtSublineCd").readOnly = true;
	disableSearch("searchSublineLOV");
	
	toggleDeductibleFields(false);
	setDeductibleItems();
	initializeAll();
</script>