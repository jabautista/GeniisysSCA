<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="lineMaintenanceMainDiv" name="lineMaintenanceMainDiv" style="float: left; width: 100%;">
	<div id="lineMaintenanceTableGridDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="giiss001Exit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	
	<div id="lineMaintenanceDiv">
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
				<label>Line Maintenance</label>
				<span class="refreshers" style="margin-top: 0;">
			 		<label id="reloadForm" name="reloadForm">Reload Form</label> 
				</span>
			</div>
		</div>
		<div class="sectionDiv" id="lineMaintenanceSectionDiv">
		
			<div id="lineMaintenanceTableDiv" style="padding: 10px;">
				<div id="giisLineTable" style="height: 340px"></div>
				
				<div id="lineMaintenanceInfoSectionDiv" style="width: 100%;">
					<div id="lineMaintenanceInfo" style="margin-top: 20px;">
						<table align="center">
							<tr>
								<td class="rightAligned">
								</td>
								<td colspan="3" class="leftAligned">
									<table style="width: 100%">
										<tr>
											<td>
												<input id="chkPackage" type="checkbox" style="float: left; margin: 0pt; width: 13px; height: 13px;" name="chkPackage" tabindex="101">
												<label for="chkPackage" style="float: left; margin-left: 3px;" title="Package">Package</label>
											</td>
											<td>
												<input id="chkProfCommTag" type="checkbox" style="float: left; margin: 0pt; width: 13px; height: 13px;" name="chkProfCommTag"  tabindex="102">
												<label for="chkProfCommTag" style="float: left; margin-left: 3px;" title="Profit Commission Tag">Profit Commission Tag</label>
											</td>
											<td>
												<input id="chkNonRenewal" type="checkbox" style="float: left; margin: 0pt; width: 13px; height: 13px;"  name="chkNonRenewal" tabindex="103">
												<label for="chkNonRenewal" style="float: left; margin-left: 3px;" title="Non-Renewal">Non-Renewal</label>
											</td>
										</tr>
										<tr>
											<td id = "tdSpecialTags">
												<input id="chkSpecialDistSw" type="checkbox" style="float: left; margin: 0pt; width: 13px; height: 13px;"  name="chkSpecialDistSw" tabindex="104">
												<label for="chkSpecialDistSw" style="float: left; margin-left: 3px;" title="Special Distribution Switch">Special Distribution</label>
											</td>
											<td>
												<input id="chkEdstSw" type="checkbox" style="float: left; margin: 0pt; width: 13px; height: 13px;"  name="chkEdstSw" tabindex="105">
												<label for="chkEdstSw" style="float: left; margin-left: 3px;" title="EDST Switch">Exclude EDST Switch</label>
											</td>
											<td>
												<input id="chkEnrolleeTag" type="checkbox" style="float: left; margin: 0pt; width: 13px; height: 13px;"  name="chkEnrolleeTag" tabindex="106">
												<label for="chkEnrolleeTag" style="float: left; margin-left: 3px;" title="Enrollee Tag">Enrollee Tag</label>
											</td>
											<td>
												<input id="chkOtherCertTag" type="checkbox" style="float: left; margin: 0pt; width: 13px; height: 13px;"  name="chkOtherCertTag" tabindex="106">
												<label id="lblOtherCertTag" for="chkOtherCertTag" style="float: left; margin-left: 3px;" title="Enrollee Tag">Other Certificate</label>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td class="rightAligned">Line Code</td>
								<td class="leftAligned">
									<input type = "hidden" id = "saveCond" value="N"/>
									<input type="text" id="txtLineCode" value="" style="width: 200px;" class="required upper" maxlength="2" tabindex="107"/>	
								</td>
								<td class="rightAligned" style="padding-left: 40px;">Menu Line Code</td>
								<td class="leftAligned">
									<span class="lovSpan" style="width: 206px; margin: 0px;">
										<input type="text" id="txtMenuLineCd" ignoreDelKey="true" style="width: 180px; float: left; border: none; height: 14px; margin: 0;" class="" lastValidValue="" tabindex="108" maxlength="2"/> 
										<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgMenuLineCdSearch" alt="Go" style="float: right;" tabindex="109"/>
									</span>
								</td>
							</tr>
							<tr>
								<td class="rightAligned">Line Name</td>
								<td class="leftAligned"><input type="text" id="txtLineName" value="" style="width: 200px;" class="required upper" maxlength="20" tabindex="110"/></td>
								<td class="rightAligned">Recaps</td>
								<td class="leftAligned">
									<span class="lovSpan" style="width: 206px; margin: 0px;">
										<input type="text" id="txtRecaps" ignoreDelKey="true" style="width: 180px; float: left; border: none; height: 14px; margin: 0;" class="" lastValidValue="" tabindex="111"  maxlength="2"/> 
										<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgRecapsSearch" alt="Go" style="float: right;" tabindex="112"/>
									</span>
								</td>
							</tr>
							<tr>
								<td class="rightAligned">Acct. Line Code</td>
								<td class="leftAligned"><input type="text" id="txtAcctLineCd" value=""  class="required integerNoNegativeUnformattedNoComma rightAligned" maxlength="2" style="width: 200px;" lpad="2" tabindex="113"/></td>
								<td class="rightAligned">Min. Prem. Amount</td>
								<td class="leftAligned"><input id="txtMinPremAmt" type="text" class="money4" style="width: 200px;" maxlength="13" errorMsg = "Entered Min. Prem. Amount is invalid. Valid value is from 0.00 to 9,999,999,999.99." min="0" max="9999999999.99" tabindex="114"></td>
							</tr>
							<tr>
								<td width="" class="rightAligned">Remarks</td>
								<td class="leftAligned" colspan="3">
									<div id="remarksDiv" name="remarksDiv" style="float: left; width: 556px; border: 1px solid gray; height: 22px;">
										<textarea style="float: left; height: 16px; width: 530px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="115"></textarea>
										<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" tabindex="116"/>
									</div>
								</td>
							</tr>
							<tr>
								<td class="rightAligned">User ID</td>
								<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="117"></td>
								<td width="" class="rightAligned" style="padding-left: 47px">Last Update</td>
								<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="118"></td>
							</tr>	
						</table>
					</div>
					<div style="margin: 15px;" align = "center">
						<input type="button" class="button" id="btnAdd" value="Add" tabindex="119">
						<input type="button" class="button" id="btnDelete" value="Delete" tabindex="120">
					</div>
				</div>
			</div>
			
	   	</div>
	</div>
	<div class="buttonsDiv">
		<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="121">
		<input type="button" class="button" id="btnSave" value="Save" tabindex="122">
	</div>
</div>

<script type="text/javascript">
	setModuleId("GIISS001");
	setDocumentTitle("Line Maintenance");
	initializeAllMoneyFields();
	makeInputFieldUpperCase();
	initializeAll();
	changeTag = 0;
	var rowIndex = -1;
	var allowSpecialDist = '${allowSpecialDist}';
	var origAcctLineCd = null;
	var condMenuLineCd = null;
	allowSpecialDist == 'Y' ? $("tdSpecialTags").show() : $("tdSpecialTags").hide();
	var objAllRecord = [];
	var printOtherCert = '${printOtherCert}';
	if(nvl(printOtherCert,"N") == "Y"){
		$("lblOtherCertTag").show();
		$("chkOtherCertTag").show();
	}else{
		$("lblOtherCertTag").hide();
		$("chkOtherCertTag").hide();
	}
	
	function saveGiiss001(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgGIISLine.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgGIISLine.geniisysRows);
		new Ajax.Request(contextPath+"/GIISLineController", {
			method: "POST",
			parameters : {action : "saveGiiss001",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS001.exitPage != null) {
							objGIISS001.exitPage();
						} else {
							tbgGIISLine._refreshList();
							tbgGIISLine.keys.releaseKeys();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss001);
	
	var objGIISS001 = {};
	var objCurrGIISLine = null;
	objGIISS001.giisLineList = JSON.parse('${jsonGIISLine}');
	objGIISS001.exitPage = null;
	
	var giisLineTable = {
			url : contextPath + "/GIISLineController?action=getLineMaintenance",
			options : {
				width : '900px',
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrGIISLine = tbgGIISLine.geniisysRows[y];
					setFieldValues(objCurrGIISLine);
					tbgGIISLine.keys.removeFocus(tbgGIISLine.keys._nCurrentFocus, true);
					tbgGIISLine.keys.releaseKeys();
					$("chkPackage").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgGIISLine.keys.removeFocus(tbgGIISLine.keys._nCurrentFocus, true);
					tbgGIISLine.keys.releaseKeys();
					$("chkPackage").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN,MyTableGrid.PRINT_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgGIISLine.keys.removeFocus(tbgGIISLine.keys._nCurrentFocus, true);
						tbgGIISLine.keys.releaseKeys();
					},
					onPrint: function(){
// 						if (rowIndex == -1){
// 							showMessageBox("Please select Line from the list.", "I");
// 							return false;
// 						}else{	
							showGenericPrintDialog("Print List of Line",printGIPIR802,null,false);
// 						}
					},
					onSave: function() {saveLineDetail();} //added by cherrie | 03.20.2014
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
					tbgGIISLine.keys.removeFocus(tbgGIISLine.keys._nCurrentFocus, true);
					tbgGIISLine.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgGIISLine.keys.removeFocus(tbgGIISLine.keys._nCurrentFocus, true);
					tbgGIISLine.keys.releaseKeys();
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
					tbgGIISLine.keys.removeFocus(tbgGIISLine.keys._nCurrentFocus, true);
					tbgGIISLine.keys.releaseKeys();
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
					id : 'saveCond',
					width : '0',
					visible : false
				},	
				{
			 		
			    	id: 'packPolFlag',
			    	title: 'P',
			    	altTitle: 'Package',
			    	width: '30px',
	            	align: 'center',
					titleAlign: 'center',
			    	defaultValue: false,
					otherValue: false,
					filterOption: true,
					filterOptionType: 'checkbox',
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
			    	id: 'profCommTag',
			    	title: 'R',
			    	altTitle: 'Prof Tag',
			    	width: '30px',
	            	align: 'center',
					titleAlign: 'center',
			    	defaultValue: false,
					otherValue: false,
					filterOption: true,
					filterOptionType: 'checkbox',
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
			    	id: 'nonRenewalTag',
			    	title: 'N',
			    	altTitle: 'Non-Renewal',
			    	width: '30px',
	            	align: 'center',
					titleAlign: 'center',
			    	defaultValue: false,
					otherValue: false,
					filterOption: true,
					filterOptionType: 'checkbox',
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
			    	id: 'specialDistSw',
			    	title: 'D',
			    	altTitle: 'Special Distribution',
			    	width: allowSpecialDist == 'Y' ? '30px' : '0',
	    			visible: allowSpecialDist == 'Y' ? true : false,
	            	align: 'center',
					titleAlign: 'center',
			    	defaultValue: false,
					otherValue: false,
					filterOption: allowSpecialDist == 'Y' ? true : false,
					filterOptionType: 'checkbox',
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
			    	id: 'edstSw',
			    	title: 'S',
			    	altTitle: 'Exclude EDST Switch',
			    	width: '30px',
	            	align: 'center',
					titleAlign: 'center',
			    	defaultValue: false,
					otherValue: false,
					filterOption: true,
					filterOptionType: 'checkbox',
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
			    	id: 'enrolleeTag',
			    	title: 'E',
			    	altTitle: 'Enrollee Tag',
			    	width: '30px',
	            	align: 'center',
					titleAlign: 'center',
			    	defaultValue: false,
					otherValue: false,
					filterOption: true,
					filterOptionType: 'checkbox',
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
			    	id: 'otherCertTag',
			    	title: 'O',
			    	altTitle: 'Other Certificate',
			    	width: '30px',
	            	align: 'center',
					titleAlign: 'center',
			    	defaultValue: false,
					otherValue: false,
					filterOption: printOtherCert == 'Y' ? true : false,
					visible: printOtherCert == "Y" ? true : false,
					filterOptionType: 'checkbox',
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
				{   id: 'lineCd',
				    title: 'Line Code',
				    width: '80px',
				    visible: true,
				    filterOption: true
				},
				{	id: 'lineName',
					title: 'Line Name',
					width: allowSpecialDist == 'Y' ? '200px' : '230px',
					visible: true,
					filterOption: true
				},
				{
					id: 'acctlineCd',
					title: 'Acct. Line Code',
					align: 'right',
					titleAlign: 'right',
					width: '100px',
					filterOptionType: 'integerNoNegative',
					visible: true,
					filterOption: true,
					renderer : function(value){
						return lpad(value.toString(), 2, "0");					
					}
				},
	            {
			    	id : "menuLineCd",
					title: "Menu",
					width: '60px',
					filterOption: true
			    },
			    {
			   		id: "recapsLineCd",
			   		title: "Recaps",
					width: '60px',
			   		filterOption: true
			    },
			    {
			    	id: "minPremAmt",
			    	title: "Min Prem Amt",
			    	width: '130px',
			    	align: 'right',
					titleAlign: 'right',
					filterOptionType: 'numberNoNegative',
			    	filterOption: true,
					renderer : function(value){
						return formatCurrency(value);					
					}
			    },
			    {
			    	id: 'unsavedAddStat',
			    	width: '0',
				    visible: false,
				    editor: 'checkbox'
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
			rows : objGIISS001.giisLineList.rows
		};
	
		tbgGIISLine = new MyTableGrid(giisLineTable);
		tbgGIISLine.pager = objGIISS001.giisLineList;
		tbgGIISLine.render("giisLineTable");
		tbgGIISLine.afterRender = function(){
			objAllRecord = getAllRecord();
		};
		
		function showGIISS001MenuLineLOV(){
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {action : "getGiiss001MenuLineLOV",
								filterText : ($("txtMenuLineCd").readAttribute("lastValidValue").trim() != $F("txtMenuLineCd").trim() ? $F("txtMenuLineCd").trim() : ""),
								page : 1},
				title: "List of Menu Line Codes",
				width: 500,
				height: 400,
				columnModel : [ {
									id: "lineCd",
									title: "Menu Line Code",
									width : '100px',
								}, {
									id : "lineName",
									title : "Description",
									width : '360px'
								} ],
					autoSelectOneRecord: true,
					filterText : ($("txtMenuLineCd").readAttribute("lastValidValue").trim() != $F("txtMenuLineCd").trim() ? $F("txtMenuLineCd").trim() : ""),
					onSelect: function(row) {
						if (condMenuLineCd == null) {
							$("txtMenuLineCd").value = unescapeHTML2(row.lineCd);
							$("txtMenuLineCd").setAttribute("lastValidValue", unescapeHTML2(row.lineCd));
						} else {
							$("txtMenuLineCd").value = $("txtMenuLineCd").readAttribute("lastValidValue");
							showMessageBox(condMenuLineCd,"E");
						}
					},
					onCancel: function (){
						$("txtMenuLineCd").value = $("txtMenuLineCd").readAttribute("lastValidValue");
					},
					onUndefinedRow : function(){
						showMessageBox("No record selected.", "I");
						$("txtMenuLineCd").value = $("txtMenuLineCd").readAttribute("lastValidValue");
					},
					onShow : function(){$(this.id+"_txtLOVFindText").focus();}
			  });
		}
		
		function showGIISS001RecapLineLOV(){
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {action : "getGiiss001RecapLineLOV",
								filterText : ($("txtRecaps").readAttribute("lastValidValue").trim() != $F("txtRecaps").trim() ? $F("txtRecaps").trim() : ""),
								page : 1},
				title: "List of Recap Line Codes",
				width: 400,
				height: 400,
				columnModel : [ {
									id: "lineCd",
									title: "Recap Line Code",
									width : '350px',
								}],
					autoSelectOneRecord: true,
					filterText : ($("txtRecaps").readAttribute("lastValidValue").trim() != $F("txtRecaps").trim() ? $F("txtRecaps").trim() : ""),
					onSelect: function(row) {
						$("txtRecaps").value = unescapeHTML2(row.lineCd);
						$("txtRecaps").setAttribute("lastValidValue", unescapeHTML2(row.lineCd));
					},
					onCancel: function (){
						$("txtRecaps").value = $("txtRecaps").readAttribute("lastValidValue");
					},
					onUndefinedRow : function(){
						showMessageBox("No record selected.", "I");
						$("txtRecaps").value = $("txtRecaps").readAttribute("lastValidValue");
					},
					onShow : function(){$(this.id+"_txtLOVFindText").focus();}
			  });
		}
	
	function setFieldValues(rec){
		try{
			$("txtLineCode").value 				= (rec == null ? "" : unescapeHTML2(rec.lineCd));
			$("txtMenuLineCd").value 			= (rec == null ? "" : unescapeHTML2(rec.menuLineCd));
			$("txtMenuLineCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.menuLineCd)));
			$("txtLineName").value 				= (rec	== null ? "" : unescapeHTML2(rec.lineName));
			$("txtRecaps").value 				= (rec	== null ? "" : unescapeHTML2(rec.recapsLineCd));
			$("txtRecaps").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.recapsLineCd)));
			$("txtAcctLineCd").value 			= (rec	== null ? "" : rec.acctlineCd);
			$("txtMinPremAmt").value 			= (rec	== null ? "" : formatCurrency(rec.minPremAmt));
			$("chkPackage").checked 			= (rec	== null ? "" : rec.packPolFlag == 'Y' ? true : false);
			$("chkProfCommTag").checked 		= (rec	== null ? "" : rec.profCommTag == 'Y' ? true : false);
			$("chkNonRenewal").checked 			= (rec	== null ? "" : rec.nonRenewalTag == 'Y' ? true : false);
			$("chkSpecialDistSw").checked 		= (rec	== null ? "" : rec.specialDistSw == 'Y' ? true : false);
			$("chkEdstSw").checked 				= (rec	== null ? "" : rec.edstSw == 'Y' ? true : false);
			$("chkEnrolleeTag").checked 		= (rec	== null ? "" : rec.enrolleeTag == 'Y' ? true : false);
			
			origAcctLineCd = (rec == null ? "" : rec.acctlineCd);
			$("txtRemarks").value				= (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("txtUserId").value 				= (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value 			= (rec == null ? "" : rec.lastUpdate);
			$("saveCond").value 				= (rec == null ? "N" : nvl(rec.saveCond,""));
			$("chkOtherCertTag").checked 		= (rec	== null ? "" : rec.otherCertTag == 'Y' ? true : false);
			if (rec == null) {
				condMenuLineCd = null;
			}else{
				condMenuLineCd = valMenuLineCd();
			}
			
			rec == null ? $("chkPackage").disabled = false : nvl(rec.saveCond,"") == "" ? $("chkPackage").disabled = true : $("chkPackage").disabled = false;
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtLineCode").readOnly = false : $("txtLineCode").readOnly = true;
			rec == null ? $("txtLineName").readOnly = false : $("txtLineName").readOnly = true;
			rec == null ? $("txtAcctLineCd").readOnly = false : $("txtAcctLineCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			if (rec != null && $("chkPackage").checked) {
				$("txtMenuLineCd").readOnly = true;
				disableSearch("imgMenuLineCdSearch");
			} else {
				$("txtMenuLineCd").readOnly = false;
				enableSearch("imgMenuLineCdSearch");
			}
			objCurrGIISLine = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.lineCd 			= escapeHTML2($("txtLineCode").value);
			obj.lineName 		= escapeHTML2($("txtLineName").value);
			obj.acctlineCd 		= $("txtAcctLineCd").value;
			obj.menuLineCd 		= escapeHTML2($("txtMenuLineCd").value);
			obj.recapsLineCd	= escapeHTML2($("txtRecaps").value);
			obj.minPremAmt 		= unformatCurrencyValue($("txtMinPremAmt").value);
			obj.packPolFlag 	= ($("chkPackage").checked ? "Y" : "N");
			obj.profCommTag 	= ($("chkProfCommTag").checked ? "Y" : "N");
			obj.nonRenewalTag 	= ($("chkNonRenewal").checked ? "Y" : "N");
			obj.specialDistSw 	= ($("chkSpecialDistSw").checked ? "Y" : "N");
			obj.edstSw 			= ($("chkEdstSw").checked ? "Y" : "N");
			obj.enrolleeTag 	= ($("chkEnrolleeTag").checked ? "Y" : "N");
			obj.remarks 		= escapeHTML2($F("txtRemarks"));
			obj.userId 			= userId;
			obj.saveCond 		= $("saveCond").value;
			obj.otherCertTag 	= ($("chkOtherCertTag").checked ? "Y" : "N");
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			obj.origAcctLineCd = origAcctLineCd == null ? $F("txtAcctLineCd") : origAcctLineCd;
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGiiss001;
			var dept = setRec(objCurrGIISLine);
			var newObj = setRec(null);
			if($F("btnAdd") == "Add"){
				tbgGIISLine.addBottomRow(dept);
				newObj.recordStatus = 0;
				objAllRecord.push(newObj);
			} else {
				tbgGIISLine.updateVisibleRowOnly(dept, rowIndex, false);
				for(var i = 0; i<objAllRecord.length; i++){
					if ((unescapeHTML2(objAllRecord[i].lineCd) == unescapeHTML2(newObj.lineCd))&&(objAllRecord[i].recordStatus != -1)){
						newObj.recordStatus = 1;
						objAllRecord.splice(i, 1, newObj);
					}
				}
			}
			changeTag = 1;
			setFieldValues(null);
			tbgGIISLine.keys.removeFocus(tbgGIISLine.keys._nCurrentFocus, true);
			tbgGIISLine.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddUpdateRec(mode) {
		try {
			for(var i=0; i<objAllRecord.length; i++){
				if(objAllRecord[i].recordStatus != -1 ){
					if (mode == "add") {
						if(unescapeHTML2(objAllRecord[i].lineCd) == $F("txtLineCode")){
							showMessageBox("Record already exists with the same line_cd.", "E");
							return;
						}else if(objAllRecord[i].acctlineCd == $F("txtAcctLineCd")){
							showMessageBox("Record already exists with the same acct_line_cd.", "E");
							return;
						}
					} else{
						if(origAcctLineCd != $F("txtAcctLineCd") && objAllRecord[i].acctlineCd == $F("txtAcctLineCd")){
							showMessageBox("Record already exists with the same acct_line_cd.", "E");
							return;
						}
					}
				} 
			}
			addRec();
		} catch (e) {
			showErrorMessage("valAddUpdateRec",e);
		}
	}
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("lineMaintenanceInfo")){
				if($F("btnAdd") == "Add") {
					valAddUpdateRec("add");
				} else {
					valAddUpdateRec("update");
				}
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}	
	
	function deleteRec(){
		changeTagFunc = saveGiiss001;
		objCurrGIISLine.recordStatus = -1;
		tbgGIISLine.deleteRow(rowIndex);
		tbgGIISLine.geniisysRows[rowIndex].lineCd = escapeHTML2($F("txtLineCode"));
		
		var newObj = setRec(null);
		for(var i = 0; i<objAllRecord.length; i++){
			if ((objAllRecord[i].lineCd == newObj.lineCd)&&(objAllRecord[i].recordStatus != -1)){
				newObj.recordStatus = -1;
				objAllRecord.splice(i, 1, newObj);
			}
		}
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISLineController", {
				parameters : {action : "valDeleteRec",
							  lineCd : $F("txtLineCode")},
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
	
	function getAllRecord(){
		try{
			var result = []; 
			new Ajax.Request(contextPath + "/GIISLineController", {
				parameters : {action : "getAllLine"},
		  		evalScripts: true,
				asynchronous: false,
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						result = JSON.parse((response.responseText).replace(/\\\\/g,"\\"));
						result = result.rows;
					}
				}
			});
			return result;
		} catch(e){
			showErrorMessage("getAllRecord", e);
		}
	}
	
	function customReturnOnResponse(response) {
		if (response.responseText.include("Geniisys Exception")){
			var message = response.responseText.split("#"); 
			return message[2];
		} else {
			return null;
		}
	}
	
	function valMenuLineCd(){
		try{
			var result = null;
			new Ajax.Request(contextPath + "/GIISLineController", {
				parameters : {action : "valMenuLineCd",
							  lineCd : $("txtMenuLineCd").readAttribute("lastValidValue")},
			  	asynchronous : false,
				evalScripts : true,
				onComplete : function(response){
					if(checkErrorOnResponse(response)){
						result = customReturnOnResponse(response);
					}
				}
			});
			return result;
		} catch(e){
			showErrorMessage("valMenuLineCd", e);
		}
	}
	
	function exitPage(){ 
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", "");
	}	
	
	function cancelGiiss001(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS001.exitPage = exitPage;
						saveGiiss001();
					}, function(){
						goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", "");
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", "");
		}
	}
	
	function printGIPIR802() {
		try {
			var content = contextPath+"/MaintenanceReportsController?action=printReport"
			+"&noOfCopies="+$F("txtNoOfCopies")
			+"&printerName="+$F("selPrinter")
			+"&destination="+$F("selDestination")
			+"&reportId=GIPIR802";	
			printGenericReport(content, "LINE OF BUSINESS");
		} catch (e) {
			showErrorMessage("printGIPIR802",e);
		}
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("imgMenuLineCdSearch").observe("click",showGIISS001MenuLineLOV);
	$("imgRecapsSearch").observe("click",showGIISS001RecapLineLOV);
	
	$("txtMenuLineCd").observe("change", function() {
		if($F("txtMenuLineCd").trim() == "") {
			$("txtMenuLineCd").clear();
			$("txtMenuLineCd").setAttribute("lastValidValue", "");
		} else {
			if($F("txtMenuLineCd").trim() != "" && $F("txtMenuLineCd") != unescapeHTML2($("txtMenuLineCd").readAttribute("lastValidValue"))) {
				showGIISS001MenuLineLOV();
			}
		}
	});
	
	$("txtRecaps").observe("change", function() {
		if($F("txtRecaps").trim() == "") {
			$("txtRecaps").clear();
			$("txtRecaps").setAttribute("lastValidValue", "");
		} else {
			if($F("txtRecaps").trim() != "" && $F("txtRecaps") != unescapeHTML2($("txtRecaps").readAttribute("lastValidValue"))) {
				showGIISS001RecapLineLOV();
			}
		}
	});
	
	$("chkPackage").observe("change",function(){
		if ($("chkPackage").checked) {
			$("txtMenuLineCd").readOnly = true;
			disableSearch("imgMenuLineCdSearch");
			$("txtMenuLineCd").clear();
			$("txtMenuLineCd").setAttribute("lastValidValue", "");
		} else {
			$("txtMenuLineCd").readOnly = false;
			enableSearch("imgMenuLineCdSearch");
		}
	});
	
	disableButton("btnDelete");
	observeSaveForm("btnSave", saveGiiss001);
	$("btnCancel").observe("click", cancelGiiss001);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);
	
	$("giiss001Exit").stopObserving("click");
	$("giiss001Exit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("chkPackage").focus();	
</script>