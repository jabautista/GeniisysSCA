<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="giiss220MainDiv" name="giiss220MainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Sliding Commission Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	
	<div>
		<div id="headerDiv" class="sectionDiv">
			<table style="margin: 10px auto;">
				<tr>
					<td class="rightAligned">Line</td>
					<td class="leftAligned">
						<span class="lovSpan required" style="float: left; width: 85px; margin-right: 5px; margin-top: 2px;">
							<input class="required upper" type="text" id="lineCd" name="headerField" style="width: 60px; float: left; border: none; height: 13px; margin: 0;" maxlength="2" tabindex="101" lastValidValue="" ignoreDelKey=""/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineCd" name="searchLineCd" alt="Go" style="float: right;"/>
						</span>
						<input id="lineName" name="headerField" type="text" style="width: 240px; height: 15px;" readonly="readonly" tabindex="102"/>
					</td>
					<td class="rightAligned" style="width: 75px;">Subline</td>
					<td class="leftAligned">
						<span class="lovSpan required" style="float: left; width: 85px; margin-right: 5px; margin-top: 2px;">
							<input class="required upper" type="text" id="sublineCd" name="headerField" style="width: 60px; float: left; border: none; height: 13px; margin: 0;" maxlength="7" tabindex="103" lastValidValue="" ignoreDelKey=""/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchSublineCd" name="searchSublineCd" alt="Go" style="float: right;"/>
						</span>
						<input id="sublineName" name="headerField" type="text" style="width: 240px; height: 15px;" readonly="readonly" tabindex="104"/>
					</td>
				</tr>
			</table>
		</div>
		
		<div class="sectionDiv">
			<div id="perilTableDiv" style="padding-top: 10px;">
				<div id="perilTable" style="height: 220px; margin-left: 165px;"></div>
			</div>
		</div>
		
		<div class="sectionDiv">
			<div id="slidingCommTableDiv" style="padding-top: 10px;">
				<div id="slidingCommTable" style="height: 340px; margin-left: 210px;"></div>
			</div>
			
			<div align="center" id="slidingCommFormDiv" style="margin-right: 20px;">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Prem Rate Low Limit</td>
						<td class="leftAligned">
							<input id="loPremLim" type="text" class="required" field="Prem Rate Low Limit" style="width: 175px; text-align: right; padding-top: 5px; height: 13px;" tabindex="105" maxlength="13" lastValidValue=""> 
						</td>
						<td class="rightAligned">Prem Rate High Limit</td>
						<td class="leftAligned">
							<input id="hiPremLim" type="text" class="required" field="Prem Rate High Limit" style="width: 178px; text-align: right; padding-top: 5px; height: 13px;" tabindex="106" maxlength="13" lastValidValue="">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Commission Rate</td>
						<td class="leftAligned" colspan="3">
							<input id="slidCommRt" type="text" class="required" field="Commission Rate" style="width: 175px; text-align: right; padding-top: 5px; height: 13px;" tabindex="107" maxlength="13" lastValidValue=""> 
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 510px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 480px; margin-top: 0; border: none;" id="remarks" name="remarks" maxlength="2000"  onkeyup="limitText(this,2000);" tabindex="108" ignoreDelKey=""></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="userId" type="text" style="width: 175px; margin-right: 10px;" readonly="readonly" tabindex="109"></td>
						<td width="" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="lastUpdate" type="text" style="width: 178px;" readonly="readonly" tabindex="110"></td>
					</tr>
				</table>
			</div>
			
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="115">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="116">
			</div>
			
			<div style="margin: 10px; padding: 10px; border-top: 1px solid #E0E0E0; margin-bottom: 0;" align="center">
				<input type="button" class="disabledButton" id="btnHistory" value="History" style="width: 100px;" tabindex="119">
			</div>
		</div>
		
		<div class="buttonsDiv">
			<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="120">
			<input type="button" class="button" id="btnSave" value="Save" tabindex="121">
		</div>
	</div>
</div>

<script type="text/javascript">
	var rowIndex = -1;
	var objGIISS220 = {};
	var selectedRow = null;
	var selectedPeril = null;
	objGIISS220.exitPage = null;
	
	var perilModel = {
		url : contextPath + "/GIISSlidCommController?action=getPerils&lineCd="+$F("lineCd"),
		options : {
			width: '600px',
			height: '207px',
			pager : {},
			beforeClick: function(){
				if(changeTag == 1){
					showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
					return false;
				}
			},
			onCellFocus : function(element, value, x, y, id){
				selectedPeril = perilTG.geniisysRows[y];
				getSlidingComm();
				enableButton("btnHistory");
				perilTG.keys.removeFocus(perilTG.keys._nCurrentFocus, true);
				perilTG.keys.releaseKeys();
			},
			onRemoveRowFocus : function(){
				selectedPeril = null;
				getSlidingComm();
				disableButton("btnHistory"); 
				perilTG.keys.removeFocus(perilTG.keys._nCurrentFocus, true);
				perilTG.keys.releaseKeys();
			},					
			toolbar : {
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				onFilter: function(){
					perilTG.onRemoveRowFocus();
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
				perilTG.onRemoveRowFocus();
			},
			onRefresh: function(){
				perilTG.onRemoveRowFocus();
			},				
			prePager: function(){
				if(changeTag == 1){
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
						$("btnSave").focus();
					});
					return false;
				}
				perilTG.onRemoveRowFocus();
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
			{	id: 'recordStatus',
			    width: '0px',				    
			    visible : false			
			},
			{	id : 'divCtrId',
				width : '0px',
				visible : false
			},
			{	id : "perilCd",
				title : "Peril Code",
				align: "right",
				titleAlign: "right",
				filterOption : true,
				filterOptionType: 'integerNoNegative',
				width : '85px'
			},
			{	id : "perilSname",
				title : "Peril Sname",
				filterOption : true,
				width : '100px'
			},
			{	id : "perilName",
				title : "Peril Name",
				filterOption : true,
				width : '250px'
			},
			{	id: 'defaultRate',
				title: 'Default Prem Rate',
				align: 'right',
				titleAlign: 'right',
				filterOption: true,
				filterOptionType: 'numberNoNegative',
				width: '130px',
				renderer: function(value){
					return nvl(value, "") == "" ? "" : formatToNineDecimal(value);
				}
			}
		],
		rows : []
	};
	perilTG = new MyTableGrid(perilModel);
	perilTG.pager = {};
	perilTG.render("perilTable");
	
	var slidingCommModel = {
		url : contextPath + "/GIISSlidCommController?action=showGIISS082&refresh=1",
		options : {
			width: '515px',
			height: '335px',
			pager : {},
			onCellFocus : function(element, value, x, y, id){
				rowIndex = y;
				selectedRow = slidingCommTG.geniisysRows[y];
				setFieldValues(selectedRow);
				slidingCommTG.keys.removeFocus(slidingCommTG.keys._nCurrentFocus, true);
				slidingCommTG.keys.releaseKeys();
			},
			onRemoveRowFocus : function(){
				rowIndex = -1;
				setFieldValues(null);
				slidingCommTG.keys.removeFocus(slidingCommTG.keys._nCurrentFocus, true);
				slidingCommTG.keys.releaseKeys();
			},					
			toolbar : {
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				onFilter: function(){
					rowIndex = -1;
					setFieldValues(null);
					slidingCommTG.keys.removeFocus(slidingCommTG.keys._nCurrentFocus, true);
					slidingCommTG.keys.releaseKeys();
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
				slidingCommTG.keys.removeFocus(slidingCommTG.keys._nCurrentFocus, true);
				slidingCommTG.keys.releaseKeys();
			},
			onRefresh: function(){
				rowIndex = -1;
				setFieldValues(null);
				slidingCommTG.keys.removeFocus(slidingCommTG.keys._nCurrentFocus, true);
				slidingCommTG.keys.releaseKeys();
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
				slidingCommTG.keys.removeFocus(slidingCommTG.keys._nCurrentFocus, true);
				slidingCommTG.keys.releaseKeys();
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
			{	id: 'recordStatus',
			    width: '0px',				    
			    visible : false			
			},
			{	id : 'divCtrId',
				width : '0px',
				visible : false
			},
			{	id : 'loPremLim',
				title : 'Prem Rate Low Limit',
				align: 'right',
				titleAlign : 'right',
				filterOption : true,
				filterOptionType : 'numberNoNegative',
				width : '160px',
				renderer : function(value){
					return nvl(value, "") == "" ? "" : formatToNineDecimal(value);
				}
			},
			{	id : 'hiPremLim',
				title : 'Prem Rate High Limit',
				align: 'right',
				titleAlign : 'right',
				filterOption : true,
				filterOptionType : 'numberNoNegative',
				width : '160px',
				renderer : function(value){
					return nvl(value, "") == "" ? "" : formatToNineDecimal(value);
				}
			},
			{	id : 'slidCommRt',
				title : 'Commission Rate',
				align: 'right',
				titleAlign : 'right',
				filterOption : true,
				filterOptionType : 'numberNoNegative',
				width : '160px',
				renderer : function(value){
					return nvl(value, "") == "" ? "" : formatToNineDecimal(value);
				}
			}
		],
		rows : []
	};
	slidingCommTG = new MyTableGrid(slidingCommModel);
	slidingCommTG.pager = {};
	slidingCommTG.render("slidingCommTable");
	slidingCommTG.afterRender = function(){
		objGIISS220.rateList = eval(slidingCommTG.pager.rateList);
	};

	function showLineCdLOV(){
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {
					action: "getGiiss220LineCdLOV",
					filterText: $F("lineCd") != $("lineCd").getAttribute("lastValidValue") ? nvl($F("lineCd"), "%") : "%"
				},
				title: "List of Lines",
				width: 365,
				height: 386,
				columnModel:[
								{	id: "lineCd",
									title: "Line Code",
									width: "100px"
								},
								{	id: "lineName",
									title: "Line Name",
									width: "250px"
								}
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
				filterText: $F("lineCd") != $("lineCd").getAttribute("lastValidValue") ? nvl($F("lineCd"), "%") : "%",
			    noticeMessage: "Getting list, please wait...",
				onSelect : function(row){
					if(row != undefined) {
						$("lineCd").value = unescapeHTML2(row.lineCd);
						$("lineName").value = unescapeHTML2(row.lineName);
						$("lineCd").setAttribute("lastValidValue", unescapeHTML2(row.lineCd));
						
						$("sublineCd").value = "";
						$("sublineName").value = "";
						$("sublineCd").setAttribute("lastValidValue", "");
						enableSearch("searchSublineCd");
						enableInputField("sublineCd");
						
						$("sublineCd").focus();
						toggleToolbars();
					}
				},
				onCancel: function(){
					$("lineCd").value = $("lineCd").getAttribute("lastValidValue");
					toggleToolbars();
				},
				onUndefinedRow: function(){
					showMessageBox("No record selected.", "I");
					$("lineCd").value = $("lineCd").getAttribute("lastValidValue");
					toggleToolbars();
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
		}catch(e){
			showErrorMessage("showLineCdLOV", e);
		}
	}
	
	function showSublineCdLOV(){
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {
					action: "getGiiss220SublineCdLOV",
					lineCd: $F("lineCd"),
					filterText: $F("sublineCd") != $("sublineCd").getAttribute("lastValidValue") ? nvl($F("sublineCd"), "%") : "%"
				},
				title: "List of Sublines",
				width: 365,
				height: 386,
				columnModel:[
								{	id: "sublineCd",
									title: "Subline Code",
									width: "100px"
								},
								{	id: "sublineName",
									title: "Subline Name",
									width: "250px"
								}
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
				filterText: $F("sublineCd") != $("sublineCd").getAttribute("lastValidValue") ? nvl($F("sublineCd"), "%") : "%",
			    noticeMessage: "Getting list, please wait...",
				onSelect : function(row){
					if(row != undefined) {
						$("sublineCd").value = unescapeHTML2(row.sublineCd);
						$("sublineName").value = unescapeHTML2(row.sublineName);
						$("sublineCd").setAttribute("lastValidValue", unescapeHTML2(row.sublineCd));
						toggleToolbars();
					}
				},
				onCancel: function(){
					$("sublineCd").value = $("sublineCd").getAttribute("lastValidValue");
					toggleToolbars();
				},
				onUndefinedRow: function(){
					showMessageBox("No record selected.", "I");
					$("sublineCd").value = $("sublineCd").getAttribute("lastValidValue");
					toggleToolbars();
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
		}catch(e){
			showErrorMessage("showSublineCdLOV", e);
		}
	}
	
	function showHistory(){
		if(changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else{
			historyOverlay = Overlay.show(contextPath+"/GIISSlidCommController", {
				urlParameters: {
					action: "showHistory",
					lineCd: $F("lineCd"),
					sublineCd: $F("sublineCd"),
					perilCd: selectedPeril.perilCd,
					perilName: unescapeHTML2(selectedPeril.perilName)
				},
				urlContent : true,
				draggable: true,
			    title: "History",
			    height: 470,
			    width: 800
			});
		}
	}

	function newFormInstance(){
		initializeAll();
		makeInputFieldUpperCase();
		
		hideToolbarButton("btnToolbarPrint");
		showToolbarButton("btnToolbarSave");
		disableToolbarButton("btnToolbarExecuteQuery");
		disableToolbarButton("btnToolbarEnterQuery");
		
		resetForm(true);
		setModuleId("GIISS220");
		setDocumentTitle("Sliding Commission Maintenance");
	}
	
	function resetForm(onLoad){
		try{
			$("lineCd").focus();
			$$("input[name='headerField']").each(function(i){
				i.value = "";
				i.setAttribute("lastValidValue", "");
			});
			
			if(!onLoad){
				perilTG.url = contextPath +"/GIISIntmSpecialRateController?action=showGIISS082&refresh=1";
				perilTG._refreshList();
			}
			
			enableInputField("lineCd");
			enableSearch("searchLineCd");
			
			disableInputField("sublineCd");
			disableSearch("searchSublineCd");
			
			disableButton("btnAdd");
			disableButton("btnDelete");
			
			disableInputField("slidCommRt");
			disableInputField("loPremLim");
			disableInputField("hiPremLim");
			disableInputField("remarks");
			
			changeTag = 0;
			toggleToolbars();
		}catch(e){
			showErrorMessage("resetForm", e);
		}
	}
	
	function toggleToolbars(){
		if($F("lineCd") != "" && $F("sublineCd") != ""){
			enableToolbarButton("btnToolbarEnterQuery");
			enableToolbarButton("btnToolbarExecuteQuery");
		}else if($F("lineCd") != "" || $F("sublineCd") != ""){
			enableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
		}else{
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
		}
	}
	
	function enterQuery(){
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
				function(){
					saveGIISS220("Y");
				},
				function(){
					resetForm(false);
				}, "");
		} else {
			resetForm(false);
		}
	}
	
	function executeQuery(){
		perilTG.url = contextPath + "/GIISSlidCommController?action=getPerils&lineCd="+encodeURIComponent($F("lineCd"));
		perilTG._refreshList();
		
		disableInputField("lineCd");
		disableInputField("sublineCd");
		disableSearch("searchLineCd");
		disableSearch("searchSublineCd");
		
		enableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
	}
	
	function getSlidingComm(){
		var perilCd = selectedPeril == null ? "-1" : selectedPeril.perilCd;
		slidingCommTG.url = contextPath + "/GIISSlidCommController?action=getSlidingComm&lineCd="+encodeURIComponent($F("lineCd"))+
											"&sublineCd="+encodeURIComponent($F("sublineCd"))+"&perilCd="+perilCd;
		slidingCommTG._refreshList();
	}
	
	function setFieldValues(rec){
		try{
			$("slidCommRt").value = rec == null ? "" : formatToNineDecimal(rec.slidCommRt);
			$("loPremLim").value =  rec == null ? "" : formatToNineDecimal(rec.loPremLim);
			$("hiPremLim").value = rec == null ? "" : formatToNineDecimal(rec.hiPremLim);
			$("userId").value = rec == null ? "" : unescapeHTML2(rec.userId);
			$("lastUpdate").value = rec == null ? "" : rec.lastUpdate;
			$("remarks").value = rec == null ? "" : unescapeHTML2(rec.remarks);
			
			if(selectedPeril == null){
				disableInputField("loPremLim");
				disableInputField("hiPremLim");
				disableInputField("slidCommRt");
				disableInputField("remarks");
				disableButton("btnAdd");
				disableButton("btnDelete");
			}else{
				rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
				rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
				rec == null ? enableInputField("loPremLim") : disableInputField("loPremLim");
				rec == null ? enableInputField("hiPremLim") : disableInputField("hiPremLim");
				rec == null ? $("loPremLim").focus() : $("slidCommRt").focus();;
				enableButton("btnAdd");
				enableInputField("slidCommRt");
				enableInputField("remarks");
			}
			
			selectedRow = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function validateRate(e){
		if($F(e) != ""){
			if(isNaN($F(e)) || parseFloat($F(e)) < 0 || parseFloat($F(e)) > 100){
				showWaitingMessageBox("Invalid " + $(e).getAttribute("field") + ". Valid value should be from 0.000000000 to 100.000000000.", "E", function(){
					$(e).value = formatToNineDecimal($(e).getAttribute("lastValidValue"));
					$(e).focus();
				});
			}else{
				if(e == "loPremLim"){
					validateLoPremLim();
				}else if(e == "hiPremLim"){
					validateHiPremLim();
				}else{
					$(e).value = formatToNineDecimal($F(e));
					$(e).setAttribute("lastValidValue", $F(e));
				}
			}
		}else{
			$(e).setAttribute("lastValidValue", "");
		}
	}
	
	function validateRange(field){
		var value = $F(field);
		for(var i = 0; i < objGIISS220.rateList.length; i++){
			for(var x = 0; x < objGIISS220.rateList[i].length; x++){
				if(parseFloat(value) >= parseFloat(objGIISS220.rateList[i][x].loPremLim) && parseFloat(value) <= parseFloat(objGIISS220.rateList[i][x].hiPremLim)){
					showWaitingMessageBox("Prem Rate of " + formatToNineDecimal(value) + " is already maintained.", "I", function(){
						$(field).value = $(field).getAttribute("lastValidValue");
						$(field).focus();
					});
					return;
				}
				
				if($F("loPremLim") != "" && $F("hiPremLim") != ""){
					if(parseFloat($F("loPremLim")) <  parseFloat(objGIISS220.rateList[i][x].loPremLim) && 
						parseFloat($F("hiPremLim")) > parseFloat(objGIISS220.rateList[i][x].hiPremLim)){
						showWaitingMessageBox("Range of " + formatToNineDecimal($F("loPremLim")) + " to " +
							formatToNineDecimal($F("hiPremLim")) + " is already maintained.", "I", function(){
							$(field).value = $(field).getAttribute("lastValidValue");
							$(field).focus();
						});
						return;
					}
				} 
			}
		}
		
		$(field).value = formatToNineDecimal($F(field));
	}
	
	function validateLoPremLim(){
		if(parseFloat($F("loPremLim")) >= parseFloat($F("hiPremLim"))){
			showWaitingMessageBox("Prem Rate Low Limit should not be greater than or equal to Prem Rate High Limit.", "E", function(){
				$("loPremLim").value = formatToNineDecimal($("loPremLim").getAttribute("lastValidValue"));
				$("loPremLim").focus();
			});
		}else if(nvl(selectedPeril, null) != null){
			validateRange("loPremLim");			
		}
	}
	
	function validateHiPremLim(){
		if(parseFloat($F("hiPremLim")) <= parseFloat($F("loPremLim"))){
			showWaitingMessageBox("Prem Rate Low Limit should not be greater than or equal to Prem Rate High Limit.", "E", function(){
				$("hiPremLim").value = formatToNineDecimal($("hiPremLim").getAttribute("lastValidValue"));
				$("hiPremLim").focus();
			});
		}else if(nvl(selectedPeril, null) != null){
			validateRange("hiPremLim");
		}
	}
	
	function saveGIISS220(reset){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		
		var setRows = getAddedAndModifiedJSONObjects(slidingCommTG.geniisysRows);
		var delRows = getDeletedJSONObjects(slidingCommTG.geniisysRows);
		
		new Ajax.Request(contextPath+"/GIISSlidCommController", {
			method: "POST",
			parameters: {
				action: "saveGIISS220",
				setRows: prepareJsonAsParameter(setRows),
				delRows: prepareJsonAsParameter(delRows)
			},
			evalScripts: true,
			asynchronous: false,
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTag = 0;
					changeTagFunc = "";
					
					if(nvl(reset, "N") == "Y"){
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
							resetForm(false);
						});
					}else{
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
							if(objGIISS220.exitPage != null) {
								objGIISS220.exitPage();
							} else {
								slidingCommTG._refreshList();
							}
						});
					}
				}
			}
		});
	}
	
	function deleteRec(){
		for(var i = 0; i < objGIISS220.rateList[0].length; i++){
			if($F("loPremLim") == formatToNineDecimal(objGIISS220.rateList[0][i].loPremLim) &&
				$F("hiPremLim") == formatToNineDecimal(objGIISS220.rateList[0][i].hiPremLim)){
				objGIISS220.rateList[0].splice(i, 1);
			}
		}
		
		changeTagFunc = saveGIISS220;
		selectedRow.recordStatus = -1;
		
		slidingCommTG.geniisysRows[rowIndex].lineCd = escapeHTML2($F("lineCd"));
		slidingCommTG.geniisysRows[rowIndex].sublineCd = escapeHTML2($F("sublineCd"));
		slidingCommTG.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("slidingCommFormDiv")){
				if(selectedPeril == null){
					showMessageBox("Please select a peril first.", "I");
					return;
				}
				
				if($F("btnAdd") == "Add") {
					new Ajax.Request(contextPath + "/GIISSlidCommController", {
						parameters: {
							action: "valAddRec",
							lineCd: $F("lineCd"),
							sublineCd: $F("sublineCd"),
							perilCd: selectedPeril.perilCd,
							loPremLim: $F("loPremLim"),
							hiPremLim: $F("hiPremLim")
						},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								addRec();
							}
						}
					});
				} else {
					addRec();
				}
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			
			obj.lineCd = escapeHTML2($F("lineCd"));
			obj.sublineCd = escapeHTML2($F("sublineCd"));
			obj.perilCd = selectedPeril.perilCd;
			obj.loPremLim = $F("loPremLim");
			obj.hiPremLim = $F("hiPremLim");
			obj.slidCommRt = $F("slidCommRt");
			obj.remarks = escapeHTML2($F("remarks"));
			obj.lastUpdate = dateFormat(new Date(), 'mm-dd-yyyy hh:MM:ss TT');
			obj.userId = userId;
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		changeTagFunc = saveGIISS220;
		var rec = setRec(selectedRow);
		
		if($F("btnAdd") == "Add"){
			var obj = {};
			obj.loPremLim = rec.loPremLim;
			obj.hiPremLim = rec.hiPremLim;
			objGIISS220.rateList[0].push(obj);
			slidingCommTG.addBottomRow(rec);
		}else{
			slidingCommTG.updateVisibleRowOnly(rec, rowIndex, false);
		}
		
		changeTag = 1;
		setFieldValues(null);
		slidingCommTG.keys.removeFocus(slidingCommTG.keys._nCurrentFocus, true);
		slidingCommTG.keys.releaseKeys();
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}
	
	function cancelGIISS220(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS220.exitPage = exitPage;
						saveGIISS220();
					}, exitPage, "");
		} else {
			exitPage();
		}
	}
	
	$w("slidCommRt loPremLim hiPremLim").each(function(e){
		$(e).observe("focus", function(){
			$(e).setAttribute("lastValidValue", $F(e));
		});
		
		$(e).observe("keyup", function(){
			$(e).value = $F(e).replace(/,/g, "");
			
			if(isNaN($F(e))){
				$(e).value = $F(e).substr(0, $F(e).length - 1);
			}
		});
		
		$(e).observe("change", function(){
			validateRate(e);
		});
	});
	
	$("lineCd").observe("change", function(){
		if($F("lineCd") == ""){
			$("lineCd").setAttribute("lastValidValue", "");
			$("lineName").value = "";
			
			$("sublineCd").value = "";
			$("sublineName").value = "";
			$("sublineCd").setAttribute("lastValidValue", "");
			
			disableInputField("sublineCd");
			disableSearch("searchSublineCd");
		}else{
			showLineCdLOV();
		}
		toggleToolbars();
	});
	
	$("sublineCd").observe("change", function(){
		if($F("sublineCd") == ""){
			$("sublineCd").setAttribute("lastValidValue", "");
			$("sublineName").value = "";
		}else{
			showSublineCdLOV();
		}
		toggleToolbars();
	});
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("remarks", 2000, $("remarks").hasAttribute("readonly"));
	});
	
	$("btnToolbarExit").stopObserving("click");
	$("btnToolbarExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	$("btnToolbarSave").stopObserving("click");
	$("btnToolbarSave").observe("click", function(){
		fireEvent($("btnSave"), "click");
	});
	
	$("searchLineCd").observe("click", showLineCdLOV);
	$("searchSublineCd").observe("click", showSublineCdLOV);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", deleteRec);
	$("btnSave").observe("click", saveGIISS220);
	$("btnCancel").observe("click", cancelGIISS220);
	$("btnHistory").observe("click", showHistory);
	$("btnToolbarEnterQuery").observe("click", enterQuery);
	$("btnToolbarExecuteQuery").observe("click", executeQuery);

	newFormInstance();
	observeReloadForm("reloadForm", showGIISS220);
</script>