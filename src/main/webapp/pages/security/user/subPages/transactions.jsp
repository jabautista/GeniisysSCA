<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>
<div id="userTranMainDiv" name="userTranMainDiv" style="">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="menuUserTranExit">Exit</a></li>
			</ul>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Transaction</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="ugtReloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>		
	<div id="" class="sectionDiv" align="center">
		<table style="margin: 10px 0 10px 0;">
			<tr>
				<td class="rightAligned">User ID</td>
				<td class="leftAligned"><input type="text" id="txtUserTranUserId" readonly="readonly" style="width: 200px;" value="" tabindex="301"></input></td>
			</tr>
		</table>
	</div>
	<div id="userTranTableDiv" style="" class="sectionDiv">
		<div style="float: right;"><input type="button" class="button" id="btnModules" value="Modules" style="width: 120px; margin: 100px 70px 0 0;" tabindex="307"></div>
		<div id="userTranTable" style="height: 175px; margin-left: 210px; margin-top: 10px;"></div>
		<div align="center">
			<table style="margin-top: 30px;">	 			
				<tr>
					<td class="rightAligned" width="85px">Transaction</td>
					<td class="leftAligned">
						<span class="lovSpan required" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px; height: 21px;">
							<input class="required integerNoNegativeUnformattedNoComma" type="text" id="txtTranCd" style="text-align: right; width: 40px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="302" lastValidValue="" ignoreDelKey="1"/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchTranCd" alt="Go" style="float: right;" tabindex="303"/>
						</span>
						<input id="txtTranDesc" type="text" style="width: 280px;" value="" readonly="readonly" tabindex="304"/>
					</td>
				</tr>
			</table>
		</div>
		<div align="center">
			<input type="button" class="button" id="btnGUTAdd" value="Add" style="width: 60px; margin-top: 5px; margin-bottom: 10px;" tabindex="305">
			<input type="button" class="button" id="btnGUTDelete" value="Delete" style="width: 60px; margin-top: 5px; margin-bottom: 10px;" tabindex="306">
		</div>
	</div>
	<div id="userIssCdTableDiv" style="" class="sectionDiv">
		<div style="float: right;"><input type="button" class="button" id="btnAllIssueCodes" value="All Issue Codes" style="width: 120px; margin: 100px 70px 0 0;" tabindex="313"></div>
		<div id="userIssCdTable" style="height: 175px;  margin-left: 210px; margin-top: 8px;"></div>
		<div align="center">
			<table style="margin-top: 30px;">	 			
				<tr>
					<td class="rightAligned" width="85px">Issuing Source</td>
					<td class="leftAligned">
						<span class="lovSpan required" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px; height: 21px;">
							<input class="required" type="text" id="txtIssCd" style="width: 40px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="308" lastValidValue="" ignoreDelKey="1"/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchIssCd" alt="Go" style="float: right;" tabindex="309"/>
						</span>
						<input id="txtIssName" name="txtIssName" type="text" style="width: 280px;" value="" readonly="readonly" tabindex="310"/>
					</td>
				</tr>
			</table>	
		</div>	
		<div align="center">
			<input type="button" class="button" id="btnGUIAdd" value="Add" style="width: 60px; margin-top: 5px; margin-bottom: 10px;" tabindex="311">
			<input type="button" class="button" id="btnGUIDelete" value="Delete" style="width: 60px; margin-top: 5px; margin-bottom: 10px;" tabindex="312">
		</div>
	</div>
	<div id="userLineTableDiv" style="" class="sectionDiv">
		<div style="float: right;"><input type="button" class="button" id="btnAllLineCodes" value="All Line Codes" style="width: 120px; margin: 100px 70px 0 0;" tabindex="319"></div>
		<div id="userLineTable" style="height: 175px;  margin-left: 210px; margin-top: 10px; margin-bottom: 10px;"></div>
		<div align="center">
			<table style="margin-top: 30px;">	 			
				<tr>
					<td class="rightAligned" width="85px">Line</td>
					<td class="leftAligned">
						<span class="lovSpan required" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px; height: 21px;">
							<input class="required" type="text" id="txtLineCd" style="width: 40px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="314" lastValidValue="" ignoreDelKey="1"/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchLineCd" alt="Go" style="float: right;" tabindex="315"/>
						</span>
						<input id="txtLineName" type="text" style="width: 280px;" value="" readonly="readonly" tabindex="316"/>
					</td>
				</tr>
			</table>	
		</div>	
		<div align="center">
			<input type="button" class="button" id="btnGULAdd" value="Add" style="width: 60px; margin-top: 5px; margin-bottom: 10px;" tabindex="317">
			<input type="button" class="button" id="btnGULDelete" value="Delete" style="width: 60px; margin-top: 5px; margin-bottom: 10px;" tabindex="318">
		</div>
	</div>
	<div class="buttonsDiv">
		<input type="button" class="button" id="btnGUTCancel" value="Cancel" tabindex="320">
		<input type="button" class="button" id="btnGUTSave" value="Save" tabindex="321">
	</div>
</div>
<script type="text/javascript">
try{
	disableButton("btnModules");
	disableButton("btnGUTDelete");
	disableButton("btnGUIDelete");
	disableButton("btnGULDelete");
	disableButton("btnAllIssueCodes");
	disableButton("btnAllLineCodes");
	$("txtUserTranUserId").value = $F("txtGIISS040UserId");
	
	var tranRowIndex = -1;
	var issRowIndex = -1;
	var lineRowIndex = -1;
	var tranNotIn = '';
	var issNotIn = '';
	var lineNotIn = '';
	var tranChangeTag = 0;
	var issChangeTag = 0;
	var lineChangeTag = 0;
	var objGiiss040GUT = {};
	
	function setLineFieldValues(rec){
		try{
			$("txtLineCd").value = (rec == null ? "" : unescapeHTML2(rec.lineCd));
			$("txtLineCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.lineCd)));
			$("txtLineName").value = (rec == null ? "" : unescapeHTML2(rec.lineName));
			
			rec == null ? disableButton("btnGULDelete") : enableButton("btnGULDelete");
			rec == null ? enableButton("btnGULAdd") : disableButton("btnGULAdd");
			rec == null ? $("txtLineCd").readOnly = false : $("txtLineCd").readOnly = true;
			rec == null ? enableSearch("imgSearchLineCd") : disableSearch("imgSearchLineCd");
		} catch(e){
			showErrorMessage("setLineFieldValues", e);
		}
	}	
	
	function saveGiiss040Tran(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setTranRows = getAddedAndModifiedJSONObjects(tbgUserTran.geniisysRows);
		var delTranRows = getDeletedJSONObjects(tbgUserTran.geniisysRows);
		
		var setIssRows = getAddedAndModifiedJSONObjects(tbgUserIssCd.geniisysRows);
		var delIssRows = getDeletedJSONObjects(tbgUserIssCd.geniisysRows);
		
		var setLineRows = getAddedAndModifiedJSONObjects(tbgUserLine.geniisysRows);
		var delLineRows = getDeletedJSONObjects(tbgUserLine.geniisysRows);
		
		new Ajax.Request(contextPath+"/GIISS040Controller", {
			method: "POST",
			parameters : {action : "saveGiiss040Tran",
						  gutUserId: $F("txtUserTranUserId"),
					 	  setTranRows : prepareJsonAsParameter(setTranRows),
					 	  delTranRows : prepareJsonAsParameter(delTranRows),
					 	  setIssRows : prepareJsonAsParameter(setIssRows),
					 	  delIssRows : prepareJsonAsParameter(delIssRows),
					 	  setLineRows : prepareJsonAsParameter(setLineRows),
					 	  delLineRows : prepareJsonAsParameter(delLineRows)
					 	  },
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGiiss040GUT.exitPage != null) {
							objGiiss040GUT.exitPage();
						}
					//START hdrtagudin-07232015-SR18661		remove refreshing
						/*
						else {
							tbgUserTran._refreshList();
						}
						*/
					//END hdrtagudin-07232015-SR18661		remove refreshing	
					});
					changeTag = 0;
					tranChangeTag = 0;
					issChangeTag = 0;
					lineChangeTag = 0;
					
					//START hdrtagudin 07232015-SR 18661
					for (var i = 0; i<tbgUserTran.geniisysRows.length; i++){
						tbgUserTran.geniisysRows[i].recordStatus = '';
					}
		
					for (var i = 0; i<tbgUserIssCd.geniisysRows.length; i++){
						tbgUserIssCd.geniisysRows[i].recordStatus = '';
					}
		
					for (var i = 0; i<tbgUserLine.geniisysRows.length; i++){
						tbgUserLine.geniisysRows[i].recordStatus = '';
					}
					//END hdrtagudin 07232015-SR 18661
				}
			}
		});
	}		
	
	function deleteUserLineRec(){
		if($F("txtTranCd") == "1"){
			try{
				new Ajax.Request(contextPath + "/GIISS040Controller", {
					parameters : {
						action : "valDeleteRecTran1Line",
					    issCd : $F("txtIssCd"),
					    lineCd : $F("txtLineCd")
					},
					onCreate : showNotice("Processing, please wait..."),
					onComplete : function(response){
						hideNotice();
						if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
							deleteRec();
						}
					}
				});
			} catch(e){
				showErrorMessage("valDeleteRecTran1Line", e);
			}	
		} else {
			deleteRec();
		}
		
		function deleteRec(){
			if(lineNotIn.contains(",'"+tbgUserLine.geniisysRows[lineRowIndex].lineCd+"'")){
				lineNotIn = lineNotIn.replace(",'"+tbgUserLine.geniisysRows[lineRowIndex].lineCd+"'", '');
			} else if(lineNotIn.contains("'"+tbgUserLine.geniisysRows[lineRowIndex].lineCd+"',")){
				lineNotIn = lineNotIn.replace("'"+tbgUserLine.geniisysRows[lineRowIndex].lineCd+"',", '');
			} else if(lineNotIn.contains("'"+tbgUserLine.geniisysRows[lineRowIndex].lineCd+"'")){
				lineNotIn = lineNotIn.replace("'"+tbgUserLine.geniisysRows[lineRowIndex].lineCd+"'", '');
			}
			
			changeTagFunc = saveGiiss040Tran;
			tbgUserLine.geniisysRows[lineRowIndex].recordStatus = -1;
			//var currLineCd = unescapeHTML2(tbgUserLine.geniisysRows[lineRowIndex].lineCd);
			//tbgUserLine.geniisysRows[lineRowIndex].lineCd = fixBackSlash(currLineCd);
			tbgUserLine.geniisysRows[lineRowIndex].issCd = escapeHTML2(tbgUserLine.geniisysRows[lineRowIndex].issCd);
			tbgUserLine.geniisysRows[lineRowIndex].lineCd = escapeHTML2(tbgUserLine.geniisysRows[lineRowIndex].lineCd);
			tbgUserLine.deleteRow(lineRowIndex);
			changeTag = 1;
			lineChangeTag = 1;
			setLineFieldValues(null);	
		}
	}
	
	function fixBackSlash(str){
		var newTemp = "";
		if(str.contains("\\")){
			var temp = str.split("");			
			for(var i=0; i<temp.length; i++){
				newTemp += (temp[i] == "\\" ? escapeHTML2(temp[i]) : temp[i]);
			}
		}
		return newTemp != "" ? newTemp : escapeHTML2(str);
	}

	function setLineRec(){
		try {				
			var obj = {};
			obj.gutUserId = escapeHTML2($F("txtUserTranUserId"));
			obj.tranCd = $F("txtTranCd");
			obj.issCd = escapeHTML2($F("txtIssCd"));
			obj.lineCd = escapeHTML2($F("txtLineCd"));
			obj.lineName = escapeHTML2($F("txtLineName"));
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setLineRec", e);
		}
	}	
	
	function addUserLineRec(){
		try {
			if($F("txtLineCd") == ""){
				showWaitingMessageBox(objCommonMessage.REQUIRED, "I", function(){
					$("txtLineCd").focus();
				});
				return;
			}
			
			changeTagFunc = saveGiiss040Tran;
			var lineRec = setLineRec();
			lineNotIn += (lineNotIn == '' ? "'"+unescapeHTML2(lineRec.lineCd).replace("'","''")+"'" : ",'" +unescapeHTML2(lineRec.lineCd).replace("'","''")+"'");
			tbgUserLine.addBottomRow(lineRec);				
			changeTag = 1;
			lineChangeTag = 1;
			setLineFieldValues(null);
			tbgUserLine.keys.removeFocus(tbgUserLine.keys._nCurrentFocus, true);
			tbgUserLine.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addUserLineRec", e);
		}
	}	
	
	var userLine = {
			id : 106,
			url: contextPath+"/GIISS040Controller?refresh=1&action=getUserLine&userId="+encodeURIComponent($F("txtUserTranUserId"))+"&tranCd=&issCd=",
			options: {
				width: '500px',
				hideColumnChildTitle: true,
				toolbar: {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						lineRowIndex = -1;
						setLineFieldValues(null);
					}
				},
				onCellFocus : function(element, value, x, y, id){
					lineRowIndex = y;
					setLineFieldValues(tbgUserLine.geniisysRows[y]);
					tbgUserLine.keys.removeFocus(tbgUserLine.keys._nCurrentFocus, true);
					tbgUserLine.keys.releaseKeys();					
				},
				onRemoveRowFocus : function(){
					lineRowIndex = -1;
					setLineFieldValues(null);
				},
				onSort: function(){
					lineRowIndex = -1;
					setLineFieldValues(null);
				},
				onRefresh: function(){
					lineRowIndex = -1;
					setLineFieldValues(null);
				},				
				prePager: function(){
					lineRowIndex = -1;
					setLineFieldValues(null);
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
				    title: '',
				    width: '0',
				    visible: false 			
				},
				{
					id: 'divCtrId',
					width: '0',
					visible: false 
				},
				{
					id: 'lineCd',
					title: 'Line Code',
					width: '80',
					filterOption: true
				},
				{
					id: 'lineName',
					title: 'Description',
					width: '380',
					filterOption: true
				}
			],
			rows: []
		};

		tbgUserLine = new MyTableGrid(userLine);
		tbgUserLine.pager = {};
		tbgUserLine.render('userLineTable');
		tbgUserLine.afterRender = function(){
			if (tbgUserLine.geniisysRows.length > 0){
				lineNotIn = unescapeHTML2(tbgUserLine.geniisysRows[0].notIn);
			}else{
				lineNotIn = "";
			}
		};	
	
	$("btnGULDelete").observe("click", deleteUserLineRec);
	$("btnGULAdd").observe("click", addUserLineRec);
	
	
	/************ USER ISSUE SOURCE ***********/
	function selectUserIssCd(selected, y){
		try{
			setIssFieldValues((y != undefined ? tbgUserIssCd.geniisysRows[y] : null));
			issRowIndex = (y != undefined ? y : -1);
			tbgUserLine.url = contextPath+"/GIISS040Controller?action=getUserLine&userId="+encodeURIComponent($F("txtUserTranUserId"))
											+"&tranCd="+$F("txtTranCd")
											+"&issCd="+(y != undefined ? encodeURIComponent(unescapeHTML2(tbgUserIssCd.geniisysRows[y].issCd)) : "");
			tbgUserLine._refreshList();	
			tbgUserIssCd.keys.removeFocus(tbgUserIssCd.keys._nCurrentFocus, true);
			tbgUserIssCd.keys.releaseKeys();
			(selected ? enableButton("btnAllLineCodes") : disableButton("btnAllLineCodes"));
		} catch(e){
			showErrorMessage("selectUserIssCd", e);
		}
	}
	
	function setIssFieldValues(rec){
		try{
			$("txtIssCd").value = (rec == null ? "" : unescapeHTML2(rec.issCd));
			$("txtIssCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.issCd)));
			$("txtIssName").value = (rec == null ? "" : unescapeHTML2(rec.issName));
			
			rec == null ? disableButton("btnGUIDelete") : enableButton("btnGUIDelete");
			rec == null ? enableButton("btnGUIAdd") : disableButton("btnGUIAdd");
			rec == null ? $("txtIssCd").readOnly = false : $("txtIssCd").readOnly = true;
			rec == null ? enableSearch("imgSearchIssCd") : disableSearch("imgSearchIssCd");
		} catch(e){
			showErrorMessage("setIssFieldValues", e);
		}
	}	
	
	function deleteUserIssRec(){
		if($F("txtTranCd") == "1"){
			try{
				new Ajax.Request(contextPath + "/GIISS040Controller", {
					parameters : {
						action : "valDeleteRecTran1",
					    issCd : $F("txtIssCd")
					},
					onCreate : showNotice("Processing, please wait..."),
					onComplete : function(response){
						hideNotice();
						if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
							deleteRec();
						}
					}
				});
			} catch(e){
				showErrorMessage("valDeleteRec", e);
			}	
		} else {
			deleteRec();
		}
		
		function deleteRec(){
			if(issNotIn.contains(",'"+tbgUserIssCd.geniisysRows[issRowIndex].issCd+"'")){
				issNotIn = issNotIn.replace(",'"+tbgUserIssCd.geniisysRows[issRowIndex].issCd+"'", '');
			} else if(issNotIn.contains("'"+tbgUserIssCd.geniisysRows[issRowIndex].issCd+"',")){
				issNotIn = issNotIn.replace("'"+tbgUserIssCd.geniisysRows[issRowIndex].issCd+"',", '');
			} else if(issNotIn.contains("'"+tbgUserIssCd.geniisysRows[issRowIndex].issCd+"'")){
				issNotIn = issNotIn.replace("'"+tbgUserIssCd.geniisysRows[issRowIndex].issCd+"'", '');
			}
			
			changeTagFunc = saveGiiss040Tran;
			tbgUserIssCd.geniisysRows[issRowIndex].issCd = escapeHTML2(tbgUserIssCd.geniisysRows[issRowIndex].issCd);
			tbgUserIssCd.geniisysRows[issRowIndex].recordStatus = -1;
			tbgUserIssCd.deleteRow(issRowIndex);
			changeTag = 1;
			issChangeTag = 1;
			setIssFieldValues(null);
			setLineFieldValues(null);
			tbgUserLine.url = contextPath+"/GIISS040Controller?action=getUserLine&userId=&tranCd=&issCd=";				
			tbgUserLine._refreshList();
			disableButton("btnAllLineCodes");	
		}
	}
	
	function setIssRec(){
		try {				
			var obj = {};
			obj.gutUserId = escapeHTML2($F("txtUserTranUserId"));
			obj.tranCd = $F("txtTranCd");
			obj.issCd = escapeHTML2($F("txtIssCd"));
			obj.issName = escapeHTML2($F("txtIssName"));
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setIssRec", e);
		}
	}	
	
	function addUserIssRec(){
		try {
			if($F("txtIssCd") == ""){
				showWaitingMessageBox(objCommonMessage.REQUIRED, "I", function(){
					$("txtIssCd").focus();
				});
				return;
			}
			
			changeTagFunc = saveGiiss040Tran;
			var issRec = setIssRec();
			issNotIn += (issNotIn == '' ? "'"+unescapeHTML2(issRec.issCd).replace("'","''")+"'" : ",'" +unescapeHTML2(issRec.issCd).replace("'","''")+"'");
			tbgUserIssCd.addBottomRow(issRec);				
			changeTag = 1;
			issChangeTag = 1;
			selectUserIssCd(false);
			selectUserIssCd(false);
			tbgUserIssCd.keys.removeFocus(tbgUserIssCd.keys._nCurrentFocus, true);
			tbgUserIssCd.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addUserIssRec", e);
		}
	}
	
	var userIssCdTable = {
			id : 105,
			url: contextPath+"/GIISS040Controller?refresh=1&action=getUserIssCd&userId="+encodeURIComponent($F("txtUserTranUserId"))+"&tranCd="+$F("txtTranCd"),
			options: {
				width: '500px',
				hideColumnChildTitle: true,
				toolbar: {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
				},
				onCellFocus : function(element, value, x, y, id){					
					selectUserIssCd(true, y);
				},
				onRemoveRowFocus : function(){
					selectUserIssCd(false);
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){

					}
				},
				beforeClick : function(){					
					if(issRowIndex != -1 && lineChangeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){

						});
						return false;
					}
				},
				beforeSort : function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){

						});
						return false;
					}
				},
				onSort: function(){

				},
				onRefresh: function(){

				},				
				prePager: function(){
				//START hdrtagudin-07232015-SR18661
					if(changeTag == 1){		
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnGUTSave").focus();
						});
						return false;
					}
				//END hdrtagudin-07232015-SR18661
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
				    title: '',
				    width: '0',
				    visible: false 			
				},
				{
					id: 'divCtrId',
					width: '0',
					visible: false 
				},
				{
					id: 'issCd',
					title: 'Issue Cd',
					width: '80',
					filterOption: true
				},
				{
					id: 'issName',
					title: 'Description',
					width: '380',
					filterOption: true
				}
			],
			rows: []
		};

		tbgUserIssCd = new MyTableGrid(userIssCdTable);
		tbgUserIssCd.pager = {};
		tbgUserIssCd.render('userIssCdTable');	
		tbgUserIssCd.afterRender = function(){
			if (tbgUserIssCd.geniisysRows.length > 0){
				issNotIn = unescapeHTML2(tbgUserIssCd.geniisysRows[0].notIn);
				//tbgUserIssCd.selectRow('0');
				$('mtgRow'+this._mtgId+'_0').addClassName('selectedRow');
				selectUserIssCd(true, 0);
			} else {
				issNotIn = "";
				selectUserIssCd(false);
			}
		};			
		
		$("btnGUIDelete").observe("click", deleteUserIssRec);
		$("btnGUIAdd").observe("click", addUserIssRec);
		
 		/********** USER TRAN ***********/		
 		function setTranFieldValues(rec){
			try{
				$("txtTranCd").value = (rec == null ? "" : rec.tranCd);
				$("txtTranCd").setAttribute("lastValidValue", (rec == null ? "" : rec.tranCd));
				$("txtTranDesc").value = (rec == null ? "" : unescapeHTML2(rec.tranDesc));
				
				rec == null ? disableButton("btnGUTDelete") : enableButton("btnGUTDelete");
				rec == null ? enableButton("btnGUTAdd") : disableButton("btnGUTAdd");
				rec == null ? $("txtTranCd").readOnly = false : $("txtTranCd").readOnly = true;
				rec == null ? enableSearch("imgSearchTranCd") : disableSearch("imgSearchTranCd");
			} catch(e){
				showErrorMessage("setTranFieldValues", e);
			}
		}

		function selectUserTran(selected, y){
			try{
				setTranFieldValues((y != undefined ? tbgUserTran.geniisysRows[y] : null));
				tranRowIndex = (y != undefined ? y : -1);
				$("txtTranCd").value = (y != undefined ? tbgUserTran.geniisysRows[y].tranCd : "");
				tbgUserIssCd.url = contextPath+"/GIISS040Controller?action=getUserIssCd&userId="+encodeURIComponent($F("txtUserTranUserId"))+"&tranCd="+$F("txtTranCd");				
				tbgUserIssCd._refreshList();
				tbgUserTran.keys.removeFocus(tbgUserTran.keys._nCurrentFocus, true);
				tbgUserTran.keys.releaseKeys();
				(selected ? enableButton("btnModules") : disableButton("btnModules"));
				(selected ? enableButton("btnAllIssueCodes") : disableButton("btnAllIssueCodes"));				
			} catch(e){
				showErrorMessage("selectUserTran", e);
			}
		}
		
		function deleteUserTranRec(){
			if(tranNotIn.contains(","+tbgUserTran.geniisysRows[tranRowIndex].tranCd)){
				tranNotIn = tranNotIn.replace(","+tbgUserTran.geniisysRows[tranRowIndex].tranCd, '');
			} else if(tranNotIn.contains(tbgUserTran.geniisysRows[tranRowIndex].tranCd+",")){
				tranNotIn = tranNotIn.replace(tbgUserTran.geniisysRows[tranRowIndex].tranCd+",", '');
			} else if(tranNotIn.contains(tbgUserTran.geniisysRows[tranRowIndex].tranCd)){
				tranNotIn = tranNotIn.replace(tbgUserTran.geniisysRows[tranRowIndex].tranCd, '');
			}
			
			changeTagFunc = saveGiiss040Tran;
			tbgUserTran.geniisysRows[tranRowIndex].recordStatus = -1;
			tbgUserTran.deleteRow(tranRowIndex);
			changeTag = 1;
			tranChangeTag = 1;
			setTranFieldValues(null);
			setIssFieldValues(null);
			setLineFieldValues(null);
			tbgUserIssCd.url = contextPath+"/GIISS040Controller?action=getUserIssCd&userId=&tranCd=";				
			tbgUserIssCd._refreshList();
			tbgUserLine.url = contextPath+"/GIISS040Controller?action=getUserLine&userId=&tranCd=&issCd=";				
			tbgUserLine._refreshList();
			disableButton("btnModules");
			disableButton("btnAllIssueCodes");
			disableButton("btnAllLineCodes");			
		}
		
		function setTranRec(incAllTag){
			try {				
				var obj = {};
				obj.gutUserId = escapeHTML2($F("txtUserTranUserId"));
				obj.tranCd = $F("txtTranCd");
				obj.tranDesc = escapeHTML2($F("txtTranDesc"));
				obj.incAllTag = incAllTag;
				obj.userId = userId;
				var lastUpdate = new Date();
				obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
				
				return obj;
			} catch(e){
				showErrorMessage("setRec", e);
			}
		}	
		
		function addUserTranRec(){
			try {
				if($F("txtTranCd") == ""){
					showWaitingMessageBox(objCommonMessage.REQUIRED, "I", function(){
						$("txtTranCd").focus();						
					});
					return;
				}
				
				function continueAdd(incAllTag){					
					changeTagFunc = saveGiiss040Tran;
					var tranRec = setTranRec(incAllTag);
					tranNotIn += (tranNotIn == '' ? tranRec.tranCd : "," + tranRec.tranCd);
					tbgUserTran.addBottomRow(tranRec);				
					changeTag = 1;
					tranChangeTag = 1;
					selectUserTran(false);
					selectUserIssCd(false);
					tbgUserTran.keys.removeFocus(tbgUserTran.keys._nCurrentFocus, true);
					tbgUserTran.keys.releaseKeys();
				}
				
				showConfirmBox("Confirmation", "Include all modules of the current transaction?", "Yes", "No", 
						function(){
							continueAdd("Y");
						}, function(){
							continueAdd("N");
						});
			} catch(e){
				showErrorMessage("addUserTranRec", e);
			}
		}
		
		function showUserModules(){
			if(changeTag == 1){
				showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){

				});
				return false;
			}
			overlayGIISS040UserModules = Overlay.show(contextPath
					+ "/GIISS040Controller", {
				urlContent : true,
				urlParameters : {
					action : "showUserModules",
					userId : $F("txtUserTranUserId"),
					tranCd : $F("txtTranCd")
				},
				showNotice : true,
				title : "Accessible Modules",
				height : 530,
				width : 620,
				draggable : true
			});
		}		

		$("btnGUTAdd").observe("click", addUserTranRec);
		$("btnGUTDelete").observe("click", deleteUserTranRec);
		
		var objUserTran = new Object();
		objUserTran.userTrans = JSON.parse('${jsonUserTran}');
		objUserTran.selectedTranCd = null;
		
		var userTranTable = {
			id : 104,
			url: contextPath+"/GIISS040Controller?refresh=1&action=showTransactions&userId="+encodeURIComponent($F("txtUserTranUserId")),
			options: {
				width: '500px',
				hideColumnChildTitle: true,
				toolbar: {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
				},
				onCellFocus : function(element, value, x, y, id){						
					selectUserTran(true, y);					
				},
				beforeClick : function(){					
					if(tranRowIndex != -1 && (issChangeTag == 1 || lineChangeTag == 1)){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){

						});
						return false;
					}
				},
				onRemoveRowFocus : function(){
					selectUserTran(false);
					selectUserIssCd(false);
					$("txtTranCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						//selectUserTran(false);
					}
				},
				beforeSort : function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){

						});
						return false;
					}
				},
				onSort: function(){
					//selectUserTran(false);
				},
				onRefresh: function(){
					//selectUserTran(false);
				},				
				prePager: function(){
				//START hdrtagudin-07232015-SR18661
					if(changeTag == 1){		
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnGUTSave").focus();
						});
						return false;
					}
				//END hdrtagudin-07232015-SR18661
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
				    title: '',
				    width: '0',
				    visible: false 			
				},
				{
					id: 'divCtrId',
					width: '0',
					visible: false 
				},
				{
					id: 'tranCd',
					titleAlign : 'right',
					title: 'Tran Cd',
					width: '80',
					align: 'right',
					filterOption: true,
					filterOptionType : 'integerNoNegative'
				},
				{
					id: 'tranDesc',
					title: 'Description',
					width: '320',
					filterOption: true
				},
				{
					id: 'incAllTag',
					title: 'Inc. All',					
					altTitle: 'Inc. All',
					align: 'center',
					titleAlign: 'center',
					width: '60',
					filterOption: true,
					filterOptionType : 'checkbox'
				}
			],
			rows: objUserTran.userTrans.rows
		};

		tbgUserTran = new MyTableGrid(userTranTable);
		tbgUserTran.pager = objUserTran.userTrans,
		tbgUserTran.render('userTranTable');
		tbgUserTran.afterRender = function(){
			if (tbgUserTran.geniisysRows.length > 0){
				tranNotIn = tbgUserTran.geniisysRows[0].notIn;
				//tbgUserTran.selectRow('0');
				$('mtgRow'+this._mtgId+'_0').addClassName('selectedRow');
				selectUserTran(true, 0);
			} else {
				tranNotIn = "";
				selectUserTran(false);
			}
		};	
	
	function exitPage(){
		$("transactionsDiv").innerHTML = "";
		$("giiss040MainDiv").show();
	}	
	
	function cancelGiiss040GUT(){
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGiiss040GUT.exitPage = exitPage;
						saveGiiss040Tran();			
					}, function(){
						changeTag = 0;
						changeTagFunc = "";
						exitPage();
					}, "");
		} else {
			exitPage();
		}
	}			
	
	function getGiiss040TranLOV(){
		LOV.show({
			controller: "GiisLOVController",
			urlParameters: {action: "getGiiss040TranLOV",
							notIn : tranNotIn,
							filterText : ($("txtTranCd").readAttribute("lastValidValue").trim() != $F("txtTranCd").trim() ? $F("txtTranCd").trim() : ""),
							page: 1},
			title: "List of Transactions",
			width: 600,
			height: 400,
			columnModel : [
			               {
			            	   id : "tranCd",
			            	   title: "Tran Cd",
			            	   width: '100px',
			            	   titleAlign: 'right',
			            	   align: 'right'
			               },
			               {
			            	   id: "tranDesc",
			            	   title: "Tran Desc",
			            	   width: '450px'
			               }
			              ],
			draggable: true,
			autoSelectOneRecord: true,
			filterText : ($("txtTranCd").readAttribute("lastValidValue").trim() != $F("txtTranCd").trim() ? $F("txtTranCd").trim() : ""),
			onSelect: function(row) {
				$("txtTranCd").value = row.tranCd;
				$("txtTranDesc").value = unescapeHTML2(row.tranDesc);
				$("txtTranCd").setAttribute("lastValidValue", row.tranCd);
				$("txtTranCd").focus();
			},
			onCancel: function (){
				$("txtTranCd").value = $("txtTranCd").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtTranCd").value = $("txtTranCd").readAttribute("lastValidValue");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		});
	}	
	
	$("txtTranCd").observe("change", function() {		
		if($F("txtTranCd").trim() == "") {
			$("txtTranDesc").value = "";
			$("txtTranCd").setAttribute("lastValidValue", "");
		} else {
			if($F("txtTranCd").trim() != "" && $F("txtTranCd") != $("txtTranCd").readAttribute("lastValidValue")) {
				getGiiss040TranLOV();
			}
		}
	});	
	
	$("imgSearchTranCd").observe("click", getGiiss040TranLOV);	

	function getGiiss040IssLOV(){
		if(tranRowIndex == -1){
			showWaitingMessageBox("Please select Transaction record first.", "I", function(){
				$("txtTranCd").focus();
			});
			return;
		}
		
		LOV.show({
			controller: "GiisLOVController",
			urlParameters: {action: "getGiiss040IssLOV",
							notIn : issNotIn,
							filterText : ($("txtIssCd").readAttribute("lastValidValue").trim() != $F("txtIssCd").trim() ? $F("txtIssCd").trim() : ""),
							page: 1},
			title: "List of Issuing Sources",
			width: 600,
			height: 400,
			columnModel : [
			               {
			            	   id : "issCd",
			            	   title: "Issue Code",
			            	   width: '100px'
			               },
			               {
			            	   id: "issName",
			            	   title: "Issuing Source",
			            	   width: '450px'
			               }
			              ],
			draggable: true,
			autoSelectOneRecord: true,
			filterText : ($("txtIssCd").readAttribute("lastValidValue").trim() != $F("txtIssCd").trim() ? $F("txtIssCd").trim() : ""),
			onSelect: function(row) {
				$("txtIssCd").value = unescapeHTML2(row.issCd);
				$("txtIssName").value = unescapeHTML2(row.issName);
				$("txtIssCd").setAttribute("lastValidValue", $("txtIssCd").value);
				$("txtIssCd").focus();
			},
			onCancel: function (){
				$("txtIssCd").value = $("txtIssCd").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtIssCd").value = $("txtIssCd").readAttribute("lastValidValue");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		});
	}		
	
	$("txtIssCd").observe("change", function() {		
		if($F("txtIssCd").trim() == "") {
			$("txtIssName").value = "";
			$("txtIssCd").setAttribute("lastValidValue", "");
		} else {
			if($F("txtIssCd").trim() != "" && $F("txtIssCd") != $("txtIssCd").readAttribute("lastValidValue")) {
				getGiiss040IssLOV();
			}
		}
	});	
	
	$("imgSearchIssCd").observe("click", getGiiss040IssLOV);

	function getGiiss040LineLOV(){
		if(issRowIndex == -1){
			showWaitingMessageBox("Please select Issuing Source record first.", "I", function(){
				$("txtIssCd").focus();
			});
			return;
		}
		
		LOV.show({
			controller: "GiisLOVController",
			urlParameters: {action: "getGiiss040LineLOV",
							notIn : lineNotIn,
							filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
							page: 1},
			title: "List of Lines",
			width: 600,
			height: 400,
			columnModel : [
			               {
			            	   id : "lineCd",
			            	   title: "Line Cd",
			            	   width: '100px'
			               },
			               {
			            	   id: "lineName",
			            	   title: "Line Name",
			            	   width: '450px'
			               }
			              ],
			draggable: true,
			autoSelectOneRecord: true,
			filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
			onSelect: function(row) {
				$("txtLineCd").value = unescapeHTML2(row.lineCd);
				$("txtLineName").value = unescapeHTML2(row.lineName);
				$("txtLineCd").setAttribute("lastValidValue", $("txtLineCd").value);
				$("txtLineCd").focus();
			},
			onCancel: function (){
				$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		});
	}		
	
	$("txtLineCd").observe("change", function() {		
		if($F("txtLineCd").trim() == "") {
			$("txtLineName").value = "";
			$("txtLineCd").setAttribute("lastValidValue", "");
		} else {
			if($F("txtLineCd").trim() != "" && $F("txtLineCd") != $("txtLineCd").readAttribute("lastValidValue")) {
				getGiiss040LineLOV();
			}
		}
	});	
	
	function includeAllIssCodes(){
		new Ajax.Request(contextPath+"/GIISS040Controller", {
			method: "POST",
			parameters : {action : "includeAllIssCodes"},
			onCreate : showNotice("Processing, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					var result = JSON.parse(response.responseText);
					tbgUserIssCd.clear();	
					tbgUserIssCd.empty();
					tbgUserIssCd.pager.total = 0;
					tbgUserIssCd.pager.to = 0;
					tbgUserIssCd.pager.pages = 0;
					if($("mtgPagerMsg"+tbgUserIssCd._mtgId).next("table") != null) {
						$("mtgPagerMsg"+tbgUserIssCd._mtgId).next("table", 0).hide();
					}
					
					issNotIn = '';
					for(var i=0; i < result.length; i++){
						var issCd = prepareNotInWhereClause(result[i].issCd);
						//issNotIn += (issNotIn == '' ? "'"+result[i].issCd+"'" : ",'" +result[i].issCd+"'");
						issNotIn += (issNotIn == '' ? "'"+issCd+"'" : ",'" +issCd+"'");
						result[i].gutUserId = escapeHTML2($F("txtUserTranUserId"));
						result[i].tranCd = $F("txtTranCd");
						result[i].issCd = escapeHTML2(result[i].issCd);
						result[i].issName = escapeHTML2(result[i].issName);
						result[i].recordStatus = 0;
						tbgUserIssCd.addBottomRow(result[i]);
					}
					changeTag = 1;
					issChangeTag = 1;
					selectUserIssCd(false);
				}
			}
		});
	}
	
	function includeAllLineCodes(){
		new Ajax.Request(contextPath+"/GIISS040Controller", {
			method: "POST",
			parameters : {action : "includeAllLineCodes"},
			onCreate : showNotice("Processing, please wait..."),
			onComplete : function(response){
				try {
					hideNotice();
					if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
						var result = JSON.parse(response.responseText);
						tbgUserLine.clear();
						tbgUserLine.empty();
						tbgUserLine.pager.total = 0;
						tbgUserLine.pager.to = 0;
						tbgUserLine.pager.pages = 0;
						if($("mtgPagerMsg"+tbgUserLine._mtgId).next("table") != null) {
							$("mtgPagerMsg"+tbgUserLine._mtgId).next("table", 0).hide();
						}
						
						lineNotIn = '';
						for(var i=0; i < result.length; i++){
							var lineCd = prepareNotInWhereClause(result[i].lineCd);
							//lineNotIn += (lineNotIn == '' ? "'"+result[i].lineCd+"'" : ",'" +result[i].lineCd+"'");
							lineNotIn += (lineNotIn == '' ? "'"+lineCd+"'" : ",'" +lineCd+"'");
							result[i].lineCd = escapeHTML2(result[i].lineCd);
							result[i].lineName = escapeHTML2(result[i].lineName);
							result[i].gutUserId = escapeHTML2($F("txtUserTranUserId"));
							result[i].tranCd = $F("txtTranCd");
							result[i].issCd = escapeHTML2($F("txtIssCd"));
							result[i].recordStatus = 0;
							tbgUserLine.addBottomRow(result[i]);
						}
						changeTag = 1;
						lineChangeTag = 1;
						setLineFieldValues(null);
					}
				} catch(e){
					showErrorMessage("includeAllLineCodes - onComplete", e);
				}
			}
		});
	}
	
	$("btnAllIssueCodes").observe("click", includeAllIssCodes);
	$("btnAllLineCodes").observe("click", includeAllLineCodes);
	$("imgSearchLineCd").observe("click", getGiiss040LineLOV);
	
	$("menuUserTranExit").observe("click", cancelGiiss040GUT);
	$("btnGUTCancel").observe("click", cancelGiiss040GUT);
	//observeReloadForm("ugtReloadForm", objGIISS040.showTransactions);
	$("ugtReloadForm").observe("click",function(){
		if(changeTag == 1) {
			showConfirmBox("Confirmation", objCommonMessage.RELOAD_WCHANGES, "Yes", "No",
					function(){changeTag = 0; changeTagFunc = ""; objGIISS040.showTransactions();
					}, 
					"");
		} else {
			changeTag = 0; 
			changeTagFunc = "";
			objGIISS040.showTransactions();
		}
	});
	$("btnModules").observe("click", showUserModules);	
	$("btnGUTSave").observe("click", saveGiiss040Tran);
	
	$("txtIssCd").observe("keyup", function(){
		$("txtIssCd").value = $F("txtIssCd").toUpperCase();
	});
	
	$("txtLineCd").observe("keyup", function(){
		$("txtLineCd").value = $F("txtLineCd").toUpperCase();
	});
	
	function prepareNotInWhereClause(str){ // added by jdiago 06172014
		return str.replace("'","''").replace("&","&'||'");
	}
	
	initializeAll();
	initializeAccordion();
} catch (e){
	showErrorMessage("transaction.jsp", e);
}
</script>