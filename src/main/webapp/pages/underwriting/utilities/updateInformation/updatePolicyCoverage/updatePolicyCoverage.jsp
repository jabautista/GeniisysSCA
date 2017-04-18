<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>

<div id="updatePolicyCoverageDiv" name="updatePolicyCoverageDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
   			<label>Update Policy Coverage</label>
   			<span class="refreshers" style="margin-top: 0;">
				<!-- <label name="gro" style="margin-left: 5px;">Hide</label> --> 
			 	<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
	   	</div>
	</div>
	
	<div id="moduleDiv" name="moduleDiv" class="sectionDiv" style="border:none; margin: 0 0 2px 0;">
		<div id="policyDiv" name="policyDiv" class="sectionDiv" style="height:80px;">
			<table border="0" align="center" style="margin-top: 10px; margin-bottom: 10px;">
				<tr>
					<td class="rightAligned">Policy No.</td>
					<td>
						<input type="text" id="txtLineCd" 		name="freeze" 	style="width:40px; float:left; height:13px; margin-left:5px;" class="upper" maxlength="2" tabindex="101"/>
						<input type="text" id="txtSublineCd" 	name="freeze" 	style="width:90px; float:left; height:13px; margin-left:3px;" class="upper" maxlength="7" tabindex="102"/>
						<input type="text" id="txtIssCd" 		name="freeze" 	style="width:40px; float:left; height:13px; margin-left:3px;" class="upper" maxlength="2" tabindex="103"/>
						<input type="text" id="txtIssueYy" 		name="freeze" 	style="width:40px; float:left; height:13px; margin-left:3px; text-align:right;" class="integerUnformatted" lpad="2" maxlength="2" tabindex="104"/>
						<input type="text" id="txtPolSeqNo" 	name="freeze" 	style="width:70px; float:left; height:13px; margin-left:3px; text-align:right;" class="integerUnformatted" lpad="7" maxlength="7" tabindex="105"/>
						<input type="text" id="txtRenewNo" 		name="freeze" 	style="width:40px; float:left; height:13px; margin-left:3px; text-align:right;" class="integerUnformatted" lpad="2" maxlength="2" tabindex="106"/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osPolicyNo" name="osPolicyNo" style="margin-left: 3px; float:left; padding:3px; cursor: pointer;" tabindex="107"/>
						<input type="hidden" id="hidPolicyId" />
						<input type="hidden" id="hidParId" />						
					</td>
					<td style="width:50px;"></td>
					<td class="rightAligned">Endorsement No.</td>
					<td>
						<input type="text" id="txtEndtIssCd" 	name="freeze" 	style="width:40px; float:left; height:13px; margin-left:5px;" class="upper" maxlength="2" tabindex="108"/>
						<input type="text" id="txtEndtYy" 		name="freeze" 	style="width:40px; float:left; height:13px; margin-left:3px; text-align:right;" class="integerUnformatted" lpad="2" maxlength="2" tabindex="109"/>
						<input type="text" id="txtEndtSeqNo"  	name="freeze" 	style="width:70px; float:left; height:13px; margin-left:3px; text-align:right;" class="integerUnformatted" lpad="7" maxlength="7" tabindex="110"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Assured</td>
					<td colspan="4">
						<input type="text" id="txtAssdName" 	name="freeze" style="width:745px; float:left; height:13px; margin-left:5px;" class="upper" maxlength="500" tabindex="111"/>
						<input type="hidden" id="hidAssdNo" />	
					</td>
				</tr>
			</table>
		</div> <!-- end: policyDiv -->		
		
		
		<div id="tgDiv" name="tgDiv" class="sectionDiv"  style="margin: 0 0 5px 0;">
		<div id="tgMainDiv" name="tgMainDiv" style="float: left; height: 340px; margin: 15px 15px 0 15px;">
			<div id="itemTableGrid" name="itemTableGrid" style="height: 390px; width: 870px;">					
			</div> <!-- end: itemTableGrid -->
		</div> <!-- end: tgMainDiv -->
		
		<div id="fieldsDiv" name="fieldsDiv" class="sectionDiv" style="border:none; margin-top:10px;">
			<table align="center">
				<tr>
					<td class="rightAligned">Item</td>
					<td>
						<input type="text" id="txtItemNo" name="txtItemNo" style="width: 105px; margin: 0 0 0 5px; text-align:right;" readonly="readonly" tabindex="201" />
						<input type="text" id="txtItemTitle" name="txtItemTitle" style="width: 400px; margin: 0 0 0 0;" readonly="readonly" tabindex="202" />
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Coverage</td>
					<td>
						<div  style="border: 1px solid gray; float: left; width:110px; height: 21px; margin: 2px 5px 2px 5px;">
							<input type="text" id="txtCoverageCd" name="txtCoverageCd" removeStyle="true" lastValidValue="" style=" height: 12px; border: none; width: 85px; float:left; margin: 1px 0 4px 0; text-align:right;" class="integerNoNegativeUnformattedNoComma" maxlength="2" tabindex="203" />							  
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osCoverageCd" name="osCoverageCd" style="float:left; margin-top:2px; cursor: pointer;" tabindex="204"/>
						</div>
						<input type="text" id="txtCoverageDesc" name="txtCoverageDesc" style="width: 400px;" readonly="readonly" tabindex="205" maxlength="30" />
					</td>
				</tr>
			</table>
		</div>
		<div id="btnDiv1" name="btnDiv1" class="buttonsDiv" style="margin: 10px 0 15px 0;">
			<input type="button" id="btnUpdate" name="btnUpdate" class="button" style="width:90px;" value="Update" tabindex="206" />
		</div>
	</div>
	
	<div id="btnDiv2" name="btnDiv2" class="buttonsDiv" style="margin-bottom: 30px;">
		<input type="button" id="btnCancel" name="btnCancel" class="button"	style="width:90px;" value="Cancel" tabindex="207" />
		<input type="button" id="btnSave" 	name="btnSave" 	 class="button"	style="width:90px;" value="Save" tabindex="208" />
	</div>
	</div> <!-- end: moduleDiv -->
	
	
	
</div> <!-- end: updatePolicyCoverageDiv -->

<script type="text/javascript">

	var onLOV = false;
	
	var selectedIndex = -1;
	var selectedRow = null;
	
	var objPolicy = new Object();
	objPolicy.policyTableGrid = JSON.parse('${policyList}'.replace(/\\/g, '\\\\'));
	objPolicy.policyObjRows = objPolicy.policyTableGrid.rows || [];
	objPolicy.policyList = [];
	
	try {
		var policyCoverageTableModel = {
				url: contextPath + "/UpdateUtilitiesController?action=showUpdatePolicyCoverage&refresh=1"
								 + "&policyId=" + $F("hidPolicyId"),
				options: {
					width: '892px',
					height: '310px',
					onCellFocus: function(element, value, x, y, id){
						selectedIndex = y;
						selectedRow = policyListingTableGrid.geniisysRows[y];
						populateFields(selectedRow, 1);
						enableButton("btnUpdate");
						enableSearch("osCoverageCd");
						enableInputField("txtCoverageCd");
						policyListingTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus: function(){
						selectedIndex = -1;
						selectedRow = null;
						populateFields(selectedRow, 1);
						policyListingTableGrid.keys.removeFocus(policyListingTableGrid.keys._nCurrentFocus, true);
						policyListingTableGrid.keys.releaseKeys();
						disableButton("btnUpdate");
						disableSearch("osCoverageCd");
						disableInputField("txtCoverageCd");
					},
					beforeSort : function() {
						if (changeTag == 1){
							showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
							return false;
	                	} else {
	                		return true;
	                	}
					},
					onSort: function(){
						policyListingTableGrid.onRemoveRowFocus();
					},
					prePager: function(){
		            	if (changeTag == 1){
							showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
							return false;
	                	} else {	          
	                		return true;
	                	}
	                },
	                onRefresh: function(){
						policyListingTableGrid.onRemoveRowFocus();
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
					toolbar: {
						elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
						onFilter: function(){
							policyListingTableGrid.onRemoveRowFocus();
						}
					}
				},
				columnModel: [
								{
									id: 'recordStatus',
									width: '0px',
									visible: false,
									editor: 'checkbox'
								},
								{
									id: 'divCtrId',
									width: '0px',
									visible: false
								},
								{
									id: 'policyId',
									width: '0px',
									visible: false
								},
								{
									id: 'itemNo',
									title: 'Item No.',
									titleAlign: 'right',
									align: 'right',
									width: '80px',
									maxlength: 10,
									filterOption: true,
									filterOptionType: 'integerNoNegative',
									geniisysClass: 'integerNoNegativeUnformattedNoComma',
									sortable: true
								},
								{
									id: 'itemTitle',
									title: 'Item Title',
									width: '350px',
									filterOption: true,									
									sortable: true									
								},
								{
									id: 'coverageCd',
									title: 'Coverage Code',
									titleAlign: 'right',
									align: 'right',
									width: '140px',
									filterOption: true,
									filterOptionType: 'integerNoNegative',
									geniisysClass: 'integerNoNegativeUnformattedNoComma',
									sortable: true
								},
								{
									id: 'coverageDesc',
									title: 'Coverage Description',
									width: '300px',
									filterOption: true,
									sortable: true									
								}
							],
							rows: objPolicy.policyObjRows
			};
			
			policyListingTableGrid = new MyTableGrid(policyCoverageTableModel);
			policyListingTableGrid.pager = objPolicy.policyTableGrid;
			policyListingTableGrid.render('itemTableGrid');
			policyListingTableGrid.afterRender = function(){
				 objPolicy.policyList = policyListingTableGrid.geniisysRows;
				changeTag = 0;
		};
	} catch(e){
		showErrorMessage("Policy Coverage Tablemodel: ", e);
	}

	function initializeDefaultValues(){
		disableToolbarButton("btnToolbarExecuteQuery");
		enableToolbarButton("btnToolbarEnterQuery");		
		$("btnToolbarPrint").hide();		
		$("txtLineCd").focus();
		enableSearch("osPolicyNo");
		disableButton("btnUpdate");
		disableSearch("osCoverageCd");
		disableInputField("txtCoverageCd");
	}
	
	function populateFields(row, div){
		if(div == 1){ // from oncellfocus
			$("txtItemNo").value 		= row != null ? nvl(row.itemNo, "") : "";
			$("txtItemTitle").value 	= row != null ? unescapeHTML2(nvl(row.itemTitle, "")) : "";
			$("txtCoverageCd").value 	= row != null ? nvl(row.coverageCd, "") : "";
			$("txtCoverageCd").setAttribute("lastValidValue", (row == null ? "" : row.coverageCd));
			$("txtCoverageDesc").value 	= row != null ? unescapeHTML2(nvl(row.coverageDesc, "")) : "";
		} else if(div == 2){ // from osPolicyNo
			$("txtLineCd").value 	= row != null ? nvl(row.lineCd, "") : "";
			$("txtSublineCd").value = row != null ? unescapeHTML2(nvl(row.sublineCd, "")) : "";
			$("txtIssCd").value 	= row != null ? nvl(row.issCd, "") : "";
			$("txtIssueYy").value 	= row != null ? nvl(row.issueYy, "") : "";
			$("txtPolSeqNo").value 	= row != null ? formatNumberDigits(nvl(row.polSeqNo, ""), 7) : "";
			$("txtRenewNo").value 	= row != null ? nvl(formatNumberDigits(row.renewNo, 2), "") : "";
			$("hidPolicyId").value	= row != null ? nvl(row.policyId, "") : "";
			$("hidParId").value		= row != null ? nvl(row.parId, "") : "";
			$("txtEndtIssCd").value = row != null ? (nvl(row.endtSeqNo, 0) != 0 ? nvl(row.endtIssCd, "") : "") : "";
			$("txtEndtYy").value 	= row != null ? (nvl(row.endtSeqNo, 0) != 0 ? formatNumberDigits(nvl(row.endtYy, ""), 2) : "") : "";
			$("txtEndtSeqNo").value = row != null ? (nvl(row.endtSeqNo, 0) != 0 ? formatNumberDigits(nvl(row.endtSeqNo,""), 7) : "") : "";
			$("txtAssdName").value 	= row != null ? unescapeHTML2(nvl(row.assdName, "")) : "";
		}
	}

	function validateCoverageCd(fieldName, fieldValue, isIconClicked){
		var findText = ($F(fieldName).trim() == "" ? "%" : $F(fieldName));
		var cond = validateTextFieldLOV("/UnderwritingLOVController?action=getGiisCoverageLOV"
						+ "&filterText=" + ( $F(fieldName).trim() == "" ? "%" : encodeURIComponent($F(fieldName)) )
						, findText
						, "");
		if (cond > 1) {
			getCoverageCdLOV(fieldName, findText, isIconClicked);
		} else if(cond < 1) {
			customShowMessageBox("Coverage Code is invalid. Please enter another coverage code.", "I", "txtCoverageCd");
			$("txtCoverageCd").value = "";
			$("txtCoverageDesc").value = "";
		} else if(cond.total == 1 && !isIconClicked){
			getCoverageCdLOV(fieldName, findText, isIconClicked);
		} else if(cond.total == 1 && isIconClicked){
			if( $F("txtCoverageCd") != cond.coverageCd && $F("txtCoverageDesc") != cond.coverageDesc ){
				getCoverageCdLOV(fieldName, "%", isIconClicked);
			} else {
				$("txtCoverageCd").value = cond.coverageCd == null ? "" : cond.coverageCd;
				$("txtCoverageDesc").value = cond.coverageDesc == null ? "" : cond.coverageDesc;
			}
		} else {
			getCoverageCdLOV(fieldName, findText, isIconClicked);
		}
	}
	
	function getCoverageCdLOV(fieldName, myText, isIconClicked){
		var searchString = myText;
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getGiisCoverageLOV",
				searchString : searchString, //+"%",
				//findText : searchString,
				page : 1
			},
			title : "Coverage",
			width : 480,
			height : 386,
			columnModel : [ {
				id : "coverageCd",
				title : "Coverage Code",
				width : '120px',
			}, {
				id : "coverageDesc",
				title : "Coverage Desc",
				width : '345px',
				renderer: function(value) {
					return unescapeHTML2(value);
				}
			} ],
			draggable : true,
			autoSelectOneRecord: true,
			findText: escapeHTML2(searchString),
			onSelect : function(row) {
				if(row != null || row != undefined){
					$("txtCoverageCd").value = row.coverageCd;
					$("txtCoverageDesc").value = unescapeHTML2(row.coverageDesc);
					$("txtCoverageCd").setAttribute("lastValidValue", row.coverageCd);
				}
			},
			onCancel: function(){
				$(fieldName).value = $(fieldName).readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				customShowMessageBox("No record selected.", imgMessage.INFO, fieldName);
				$(fieldName).value = $(fieldName).readAttribute("lastValidValue");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		});
	}
	
	function validateGiuts027PolicyLOV(fieldName, fieldValue, isIconClicked){
		var cond = validateTextFieldLOV("/UnderwritingLOVController?action=getGiuts027PolicyLOV"
						+ "&lineCd=" 	+ encodeURIComponent($F("txtLineCd"))
						+ "&sublineCd=" + encodeURIComponent($F("txtSublineCd"))
						+ "&issCd=" 	+ encodeURIComponent($F("txtIssCd"))
						+ "&issueYy=" 	+ $F("txtIssueYy")
						+ "&polSeqNo=" 	+ $F("txtPolSeqNo")
						+ "&renewNo=" 	+ $F("txtRenewNo")
						+ "&endtIssCd=" + encodeURIComponent($F("txtEndtIssCd"))
						+ "&endtYy=" 	+ $F("txtEndtYy")
						+ "&endtSeqNo=" + $F("txtEndtSeqNo")
						+ "&assdName=" 	+ encodeURIComponent($F("txtAssdName"))		
						+ "&moduleId="	+ "GIUTS027"
						//+ "&filterText=" + ( $F(fieldName).trim() == "" ? "%" : encodeURIComponent($F(fieldName)) )
						, "%" //($F(fieldName).trim() == "" ? "%" : $F(fieldName))
						, "");
		if (cond > 1) {
			getGiuts027PolicyLOV(fieldName, fieldValue, isIconClicked);
		} else if(cond < 1) {
			customShowMessageBox("Query caused no records to be retrieved. Please re-enter.", "I", "txtLineCd");
			populateFields(null, 2);
		} else if(cond.total == 1 && !isIconClicked){
			getGiuts027PolicyLOV(fieldName, fieldValue, isIconClicked);
		} else if(cond.total == 1 && isIconClicked){
			if( $F("hidPolicyId") != cond.policyId && $F("hidParId") != cond.parId ){
				getGiuts027PolicyLOV(fieldName, fieldValue, isIconClicked);
			} else {
				populateFields(row, 2);
			}
		} else {
			getGiuts027PolicyLOV(fieldName, fieldValue, isIconClicked);
		}
	}
	function getGiuts027PolicyLOV(fieldName, fieldValue, isIconClicked){
		if(onLOV) return;
		
		var searchString = isIconClicked ? "%" : ($F(fieldName).trim() == "" ? "%" : $F(fieldName));
		onLOV = true;
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action 		: "getGiuts027PolicyLOV",
				lineCd 		: $F("txtLineCd"), 
				sublineCd 	: $F("txtSublineCd"), 
				issCd 		: $F("txtIssCd"),
				issueYy		: $F("txtIssueYy"),
				polSeqNo	: $F("txtPolSeqNo"),
				renewNo		: $F("txtRenewNo"),
				endtIssCd	: $F("txtEndtIssCd"),
				endtYy		: $F("txtEndtYy"),
				endtSeqNo	: $F("txtEndtSeqNo"),
				assdName	: $F("txtAssdName"),
				moduleId	: "GIUTS027",
				searchString : searchString,//+"%",
				page : 1
			},
			title : "List of Policies",
			width : 700,
			height : 390,
			filterVersion: "2",
			hideColumnChildTitle: true,
			columnModel : [ {
				id: 'policyId',
				visible: false,
				title: 'Policy Id',
				width: '0'
			}, {
				id: 'policyNo',
				visible: true,
				title: 'Policy No.',
				width: '195px',
				filterOption: true,
				sortable: true
			}, {
				id: 'endtNo',
				visible: true,
				title: 'Endorsement No.',
				width: '120px',
				filterOption: true,
				sortable: true
			}, {
				id: 'assdName',
				title: 'Assured Name',
				width: '360px',
				filterOption: true,
				sortable: true,
			}, {
				id: 'assdNo',
				visible: false,
				title: 'AssdNo',
				width: '0'
			} ],
			draggable : true,
			autoSelectOneRecord: true,
			//filterText: escapeHTML2(searchString),
			onSelect : function(row) {
				onLOV = false;
				if(row != null || row != undefined){
					populateFields(row, 2);
					freezeFields(true);
					enableToolbarButton("btnToolbarExecuteQuery");
				}
			},
			onCancel: function(){
				onLOV = false;
				//$(fieldName).focus();
			},
			onUndefinedRow : function(){
				onLOV = false;
				customShowMessageBox("No record selected.", imgMessage.INFO, "osPolicyNo");
				disableToolbarButton("btnToolbarExecuteQuery");
			} 
		});
	}
	
	function executeQuery(){
		policyListingTableGrid.url = contextPath + "/UpdateUtilitiesController?action=showUpdatePolicyCoverage&refresh=1&policyId=" + $F("hidPolicyId");
		policyListingTableGrid._refreshList();
	}
	
	function freezeFields(flag){
		$$("div#policyDiv input[name='freeze']").each(function(a){
			if(flag){
				disableInputField($(a).id);
			} else {
				enableInputField($(a).id);
			}
		});
	}
	
	function updateItemCoverage(){
		updateObj = createItemObj();
		objPolicy.policyList.splice(selectedIndex, 1, updateObj);
		policyListingTableGrid.updateVisibleRowOnly(updateObj, selectedIndex);
		changeTag = 1;
	}
	
	function createItemObj(){
		var objItem = new Object();
		objItem.policyId		= $F("hidPolicyId");
		objItem.itemNo			= $F("txtItemNo");
		objItem.itemTitle		= $F("txtItemTitle");
		objItem.coverageCd		= $F("txtCoverageCd");
		objItem.coverageDesc	= $F("txtCoverageDesc");
		objItem.recordStatus	= 1; // since user can only update.
		return objItem;
	}
	
	function saveItemCoverage(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		
		objParams = new Object();
		objParams.setRows = getModifiedJSONObjects(objPolicy.policyList);
		
		new Ajax.Request(contextPath+"/UpdateUtilitiesController?action=saveItemCoverage",{
			method: "POST",
			parameters:{
				parameters : JSON.stringify(objParams)
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				showNotice("Saving Policy Coverage, please wait...");
			},
			onComplete: function(response){
				hideNotice("");
				changeTag = 0;
				if(checkErrorOnResponse(response)) {
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objPolicy.exitPage != null) {
							objPolicy.exitPage();
						} else {
							policyListingTableGrid.refresh();
							policyListingTableGrid.onRemoveRowFocus();
						}
					});
					changeTag = 0;
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}	
	function cancelGiuts027(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objPolicy.exitPage = exitPage;
						saveItemCoverage();						
					}, function(){
						goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
	}
	
	$("osPolicyNo").observe("click", function(){
		validateGiuts027PolicyLOV("txtLineCd", $F("txtLineCd"), true);
	});
	
	$("osCoverageCd").observe("click", function(){
		validateCoverageCd("txtCoverageCd", $F("txtCoverageCd"), true);
	});
	
	$("txtCoverageCd").observe("change", function(){
		if($F("txtCoverageCd").trim() == "" ){
			$("txtCoverageCd").value = "";
			$("txtCoverageCd").setAttribute("lastValidValue", "");
			$("txtCoverageDesc").value = "";
		} else {
			if($F("txtCoverageCd").trim() != "" && $F("txtCoverageCd") != $("txtCoverageCd").readAttribute("lastValidValue")) {
				validateCoverageCd("txtCoverageCd", $F("txtCoverageCd"), false);
			}
		}
	});
	$("txtCoverageCd").observe("keypress", function(event){
		if(event.keyCode == objKeyCode.ENTER) {
			validateCoverageCd("txtCoverageCd", $F("txtCoverageCd"), false);
		}/* else if(event.keyCode == 8 || event.keyCode == 46 || event.keyCode == 0) {
			$("txtCoverageDesc").clear();
		}*/
	});	
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		isQueryExecuted = true;
		
		disableSearch("osPolicyNo");
		freezeFields(true);
		disableToolbarButton("btnToolbarExecuteQuery");
		executeQuery();
	});
	
	$("btnToolbarEnterQuery").observe("click", function(){
		isQueryExecuted = false;
		freezeFields(false);
		disableToolbarButton("btnToolbarExecuteQuery");
		enableSearch("osPolicyNo");
		populateFields(null, 2);
		populateFields(null, 1);
		executeQuery();
		$("txtLineCd").focus();
		$("txtCoverageCd").setAttribute("lastValidValue", "");
		disableSearch("osCoverageCd");
		disableInputField("txtCoverageCd");
	});
	$("btnToolbarExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	
	$("btnUpdate").observe("click", function(){
		updateItemCoverage();
		populateFields(null, 1);
		disableButton("btnUpdate");
		disableSearch("osCoverageCd");
		disableInputField("txtCoverageCd");
	});
	$("btnSave").observe("click", function(){
		if(changeTag == 1){
			saveItemCoverage();
		} else {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
		}
	});
	$("btnCancel").observe("click", cancelGiuts027);
	observeReloadForm("reloadForm", showUpdatePolicyCoverage);
		
	initializeAll();
	makeInputFieldUpperCase();
	initializeDefaultValues();
	setModuleId("GIUTS027");
	setDocumentTitle("Update Policy Coverage");
</script>