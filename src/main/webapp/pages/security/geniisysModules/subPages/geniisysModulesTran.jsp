<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="giisModulesTranMainDiv" name="giisModulesTranMainDiv">
	<div id="giisModulesTran" name="giisModulesTran">
		<div class="sectionDiv" style="width: 99%; height: 342px; margin-top: 5px; margin-left: 2px;">
			<div id="giisModulesTranTableDiv" style="padding-top: 10px; padding-left: 10px;">
				<div id="giisModulesTranTable" style="height: 100px; margin-left: 0px;"></div>
			</div>
			<div align="center" id="giisModulesTranFormDiv" style="width: 99%; margin-top: 160px; margin-left: 2px;">
				<table style="margin-top: 5px;">
					<tr>
						<td align="right">Transaction</td>
						<td>
							<span class="lovSpan required" style="width: 100px; height: 19px; margin-top: 2px; margin-bottom: 0px">
								<input id="txtTranCd" class="required" maxlength="2" type="text" style="width:75px; height: 13px; border: 0; margin: 0; text-align: right;" tabindex="401">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchTransaction" class="required" alt="Go" style="float: right; margin-top: 2px;" tabindex="402"/>
							</span>	
						</td>
						<td><input id="txtTranDesc" readonly="readonly" type="text" style="width:360px; margin-bottom: 0px" tabindex="403"></td>
					</tr>
				</table>
			</div>
			<div align="center" style="margin: 10px;">
				<input type="button" class="button" id="btnAddTran" value="Add" tabindex="404" style="width: 80px;">
				<input type="button" class="button" id="btnDeleteTran" value="Delete" tabindex="405" style="width: 80px;">
			</div>
			<div align="center" style="margin: 18px;">
				<input type="button" class="button" id="btnReturn" value="Return" tabindex="406" style="width: 80px;">
				<input type="button" class="button" id="btnSaveTran" value="Save" tabindex="407" style="width: 80px;">
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	changeTagTran = 0;
	var rowIndexTran = -1;
	
	var objGeniisysModuleTran = {};
	var objCurrGeniisysModuleTran = null;
	objGeniisysModuleTran.geniisysModuleTranList = JSON.parse('${jsonGeniisysModuleTranList}');
	objGeniisysModuleTran.exitPage = null;
	
	var giisModulesTranTable = {
			url : contextPath + "/GIISModuleController?action=showGeniisysModuleTran&refresh=1" + "&moduleId=" + $F("txtModuleId"),
			options : {
				width : '575px',
				height : '250px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndexTran = y;
					objCurrGeniisysModuleTran = tbgGiisModulesTran.geniisysRows[y];
					setTranFieldValues(objCurrGeniisysModuleTran);
					tbgGiisModulesTran.keys.removeFocus(tbgGiisModulesTran.keys._nCurrentFocus, true);
					tbgGiisModulesTran.keys.releaseKeys();
					$("txtTranCd").focus();
				},
				onRemoveRowFocus : function(){
					rowIndexTran = -1;
					setTranFieldValues(null);
					tbgGiisModulesTran.keys.removeFocus(tbgGiisModulesTran.keys._nCurrentFocus, true);
					tbgGiisModulesTran.keys.releaseKeys();
					$("txtTranCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndexTran = -1;
						setTranFieldValues(null);
						tbgGiisModulesTran.keys.removeFocus(tbgGiisModulesTran.keys._nCurrentFocus, true);
						tbgGiisModulesTran.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					if(changeTagTran == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSaveTran").focus();
						});
						return false;
					}
				},
				onSort: function(){
					rowIndexTran = -1;
					setTranFieldValues(null);
					tbgGiisModulesTran.keys.removeFocus(tbgGiisModulesTran.keys._nCurrentFocus, true);
					tbgGiisModulesTran.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndexTran = -1;
					setTranFieldValues(null);
					tbgGiisModulesTran.keys.removeFocus(tbgGiisModulesTran.keys._nCurrentFocus, true);
					tbgGiisModulesTran.keys.releaseKeys();
				},				
				prePager: function(){
					if(changeTagTran == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSaveTran").focus();
						});
						return false;
					}
					rowIndexTran = -1;
					setTranFieldValues(null);
					tbgGiisModulesTran.keys.removeFocus(tbgGiisModulesTran.keys._nCurrentFocus, true);
					tbgGiisModulesTran.keys.releaseKeys();
				},
				checkChanges: function(){
					return (changeTagTran == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (changeTagTran == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (changeTagTran == 1 ? true : false);
				},
				masterDetail: function(){
					return (changeTagTran == 1 ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (changeTagTran == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTagTran == 1 ? true : false);
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
						id : "tranCd",
						title : "Tran Cd.",
						filterOption : true,
						filterOptionType : 'integerNoNegative',
						align : 'right',
						titleAlign : 'right',
						width : '100px'
					},
					{
						id : 'tranDesc',
						filterOption : true,
						title : 'Transaction',
						width : '430px'				
					},
					{
						id : 'moduleId',
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
					},
					{
						id : 'unsaveTag',
						width : '0',
						visible : false
					}
			],
			rows : objGeniisysModuleTran.geniisysModuleTranList.rows
	};
	tbgGiisModulesTran = new MyTableGrid(giisModulesTranTable);
	tbgGiisModulesTran.pager = objGeniisysModuleTran.geniisysModuleTranList;
	tbgGiisModulesTran.render("giisModulesTranTable");
	
	function setTranFieldValues(rec){
		try{
			$("txtTranCd").value = (rec == null ? "" : rec.tranCd);
			$("txtTranDesc").value = (rec == null ? "" : unescapeHTML2(rec.tranDesc));
			
			rec == null ? enableButton("btnAddTran") : disableButton("btnAddTran");
			rec == null ? $("txtTranCd").readOnly = false : $("txtTranCd").readOnly = true;
			rec == null ? enableSearch("imgSearchTransaction") : disableSearch("imgSearchTransaction");
			rec == null ? disableButton("btnDeleteTran") : enableButton("btnDeleteTran");
			objCurrGeniisysModuleTran = rec;
		} catch(e){
			showErrorMessage("setTranFieldValues", e);
		}
	}
	
	$("txtTranCd").setAttribute("lastValidValue", "");
	$("imgSearchTransaction").observe("click", showGiiss081TranLov);
	$("txtTranCd").observe("change", function() {		
		if($F("txtTranCd").trim() == "") {
			$("txtTranCd").value = "";
			$("txtTranCd").setAttribute("lastValidValue", "");
		} else {
			if($F("txtTranCd").trim() != "" && $F("txtTranCd") != $("txtTranCd").readAttribute("lastValidValue")) {
				showGiiss081TranLov();
			}
		}
	});
	
	function showGiiss081TranLov(){
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters: {
				action : "getGiiss081TranLov",
				filterText : ($("txtTranCd").readAttribute("lastValidValue").trim() != $F("txtTranCd").trim() ? $F("txtTranCd").trim() : ""),
				page : 1
			},
			title: "List of Transactions",
			width: 500,
			height: 400,
			columnModel : [
					{
						id : "tranCd",
						title: "Tran Cd.",
						width: '100px',
						titleAlign : "right",
						align : "right",
						filterOption: true
					},
					{
						id : "tranDesc",
						title: "Tran Desc.",
						width: '325px',
						renderer: function(value) {
							return unescapeHTML2(value);
						}
					}
			],
			autoSelectOneRecord: true,
			filterText : ($("txtTranCd").readAttribute("lastValidValue").trim() != $F("txtTranCd").trim() ? $F("txtTranCd").trim() : ""),
			onSelect: function(row) {
				$("txtTranCd").value = row.tranCd;
				$("txtTranCd").setAttribute("lastValidValue", row.tranCd);	
				$("txtTranDesc").value = unescapeHTML2(row.tranDesc);
			},
			onCancel: function (){
				$("txtTranCd").value = $("txtTranCd").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtTranCd").value = $("txtTranCd").readAttribute("lastValidValue");
			},
			onShow : function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		  });
	}
	
	function exitTranPage(){
		overlayGeniisysModuleTran.close();
		delete overlayGeniisysModuleTran;
	}
	
	function closeOverlay(){
		if(changeTagTran == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGeniisysModuleTran.exitPage = exitTranPage;
						saveGeniisysModuleTran();
					}, function(){
						overlayGeniisysModuleTran.close();
						delete overlayGeniisysModuleTran;
					}, "");
		} else {
			overlayGeniisysModuleTran.close();
			delete overlayGeniisysModuleTran;
		}
	}
	
	function valAddTranRec(){
		try{
			if(checkAllRequiredFieldsInDiv("giisModulesTranFormDiv")){
				if($F("btnAddTran") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;					
					
					for(var i=0; i<tbgGiisModulesTran.geniisysRows.length; i++){
						if(tbgGiisModulesTran.geniisysRows[i].recordStatus == 0 || tbgGiisModulesTran.geniisysRows[i].recordStatus == 1){								
							if(tbgGiisModulesTran.geniisysRows[i].tranCd == $F("txtTranCd")){
								addedSameExists = true;								
							}							
						} else if(tbgGiisModulesTran.geniisysRows[i].recordStatus == -1){
							if(tbgGiisModulesTran.geniisysRows[i].tranCd == $F("txtTranCd")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same tran_cd.", "E");
						return false;
					} else if(deletedSameExists && !addedSameExists){
						addTranRec();
						return;
					}
					
					new Ajax.Request(contextPath + "/GIISModuleController", {
						parameters : {action : "valAddTranRec",
									  moduleId : $F("txtModuleId"),
									  tranCd : $F("txtTranCd")
						},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								addTranRec();
							}
						}
					});
				} else {
					addTranRec();
				}
			}
		} catch(e){
			showErrorMessage("valAddTranRec", e);
		}
	}
	
	function addTranRec(){
		try {
			changeTagTranFunc = saveGeniisysModuleTran;
			var tran = setTranRec(objCurrGeniisysModuleTran);
			if($F("btnAddTran") == "Add"){
				tbgGiisModulesTran.addBottomRow(tran);
			} else {
				tbgGiisModulesTran.updateVisibleRowOnly(tran, rowIndexTran, false);
			}
			changeTagTran = 1;
			setTranFieldValues(null);
			tbgGiisModulesTran.keys.removeFocus(tbgGiisModulesTran.keys._nCurrentFocus, true);
			tbgGiisModulesTran.keys.releaseKeys();
			$("txtTranCd").setAttribute("lastValidValue", "");
		} catch(e){
			showErrorMessage("addTranRec", e);
		}
	}
	
	function setTranRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.moduleId = escapeHTML2($F("txtModuleId"));
			obj.tranCd = $F("txtTranCd");
			obj.tranDesc = escapeHTML2($F("txtTranDesc"));
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			obj.unsaveTag = 'Y';
			
			return obj;
		} catch(e){
			showErrorMessage("setTranRec", e);
		}
	}
	
	function valDeleteTranRec(){
		for(var i=0; i<tbgGiisModulesTran.geniisysRows.length; i++){
			if(tbgGiisModulesTran.geniisysRows[i].tranCd == $F("txtTranCd")){
				if(tbgGiisModulesTran.geniisysRows[i].unsaveTag == "Y"){
					deleteTranRec();
				} else {
					try{
						new Ajax.Request(contextPath + "/GIISModuleController", {
							parameters : {
								action : "valDeleteTranRec",
								moduleId : $F("txtModuleId"),
								tranCd : $F("txtTranCd")
							},
							onCreate : showNotice("Processing, please wait..."),
							onComplete : function(response){
								hideNotice();
								if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
									deleteTranRec();
								}
							}
						});
					} catch(e){
						showErrorMessage("valDeleteTranRec", e);
					}
				}
			}
		}
	}
	
	function deleteTranRec(){
		changeTagTranFunc = saveGeniisysModuleTran;
		objCurrGeniisysModuleTran.recordStatus = -1;
		tbgGiisModulesTran.deleteRow(rowIndexTran);
		changeTagTran = 1;
		setTranFieldValues(null);
	}
	
	function saveGeniisysModuleTran(){
		if(changeTagTran == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgGiisModulesTran.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgGiisModulesTran.geniisysRows);

		new Ajax.Request(contextPath+"/GIISModuleController", {
			method: "POST",
			parameters : {
				action : "saveGeniisysModuleTran",
				setRows : prepareJsonAsParameter(setRows),
				delRows : prepareJsonAsParameter(delRows)
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagTranFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGeniisysModuleTran.exitPage != null) {
							objGeniisysModuleTran.exitPage();
						} else {
							tbgGiisModulesTran._refreshList();
						}
					});
					changeTagTran = 0;
					$("txtTranCd").setAttribute("lastValidValue", "");
				}
			}
		});
	}
	
	$("btnReturn").observe("click", closeOverlay);
	$("btnAddTran").observe("click", valAddTranRec);
	$("btnDeleteTran").observe("click", valDeleteTranRec);
	$("btnSaveTran").observe("click", saveGeniisysModuleTran);
	
	disableButton("btnDeleteTran");
	$("txtTranCd").focus();	
</script>