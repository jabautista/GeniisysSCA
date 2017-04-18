<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>

<div id="intermediaryCommissionDiv" name="intermediaryCommissionDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
   			<label>View Invoice Commission Details</label>
	   	</div>
	</div>
	<div id="intermediaryCommissionBodyDiv" name="intermediaryCommissionBodyDiv" class="sectionDiv">
		<table align="center" style="margin-top: 10px; margin-bottom: 10px;">
			<tr>
				<td class="rightAligned">Intermediary</td>
				<td>
					<span class="lovSpan required" style="width: 121px; height: 21px; margin: 2px 0 0 4px; float: left;">
						<input type="text" id="txtIntmNo" name="txtIntmNo" ignoreDelKey="true" style="width: 90px; float: left; border: none; height: 13px;" class="integerUnformatted rightAligned required" lpad="12" tabindex="101"/>								
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIntmNo" name="searchIntmNo" alt="Go" style="float: right;"/>
					</span>
				</td>
				<td>
					<input type="text" id="txtIntmName" name="txtIntmName" style="width: 400px;" readonly="readonly" class="required" tabindex="102"/>								
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Line</td>
				<td>
					<span class="lovSpan required" style="width: 121px; height: 21px; margin: 2px 0 0 4px; float: left;">
						<input type="text" id="txtLineCd" name="txtLineCd" ignoreDelKey="true" style="width: 90px; float: left; border: none; height: 13px;" class="leftAligned required allCaps" tabindex="103"/>								
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineCd" name="searchLineCd" alt="Go" style="float: right;"/>
					</span>
				</td>
				<td>
					<input type="text" id="txtLineName" name="txtLineName" style="width: 400px;" readonly="readonly" class="required" tabindex="104"/>								
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Subline</td>
				<td>
					<span class="lovSpan required" style="width: 121px; height: 21px; margin: 2px 0 0 4px; float: left;">
						<input type="text" id="txtSublineCd" name="txtSublineCd" ignoreDelKey="true" style="width: 90px; float: left; border: none; height: 13px;" class="leftAligned required allCaps" tabindex="105"/>								
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchSublineCd" name="searchSublineCd" alt="Go" style="float: right;"/>
					</span>
				</td>
				<td>
					<input type="text" id="txtSublineName" name="txtSublineName" style="width: 400px;" readonly="readonly" class="required" tabindex="106"/>								
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Crediting Branch</td>
				<td class="rightAligned">
					<input type="text" id="txtCredBranch" name="txtCredBranch" style="width: 115px;" class="required allCaps" tabindex="107"/>		
				</td>
			</tr>
		</table>
	</div>	
	<div id="intermediaryCommissionTableDiv" class="sectionDiv" style="margin-bottom: 40px;">
		<div id="intermediaryCommissionTable" style="height: 340px; padding: 10px;"></div>
		
		<div id="buttonsDiv" name="buttonsDiv" class="buttonsDiv" style="margin: 0 0 15px 0;">
			<input type="button" id="btnCommDetail" name="btnCommDetail" class="button"	style="width:150px;" value="Commission Details" tabindex="108"/>
			<input type="button" id="btnPeril" name="btnPeril" class="button"	style="width:150px;" value="Perils" tabindex="109"/>
		</div>
	</div>
	
	
</div> 

<script type="text/javascript">
	initializeAll();
	setModuleId("GIPIS139");
	setDocumentTitle("View Invoice Commission Details");
	var dispOverridingComm = "${dispOverridingComm}";
	var selectedObj = null;
	
	var resetIntm = true;
	var resetLine = true;
	var resetSubline = true;
	
	function resetPage() {
		if (dispOverridingComm == "N") {
			$("btnCommDetail").hide();
		}else{
			$("btnCommDetail").show();
		}
		$("btnToolbarPrint").hide();
		$("btnToolbarPrintSep").hide();
		$("txtIntmNo").focus();
		disableToolbarButton("btnToolbarEnterQuery");
		enableToolbarButton("btnToolbarExecuteQuery");
		disableButton("btnCommDetail");
		disableButton("btnPeril");
		$("txtIntmNo").readOnly = false;
		$("txtLineCd").readOnly = false;
		$("txtSublineCd").readOnly = false;
		$("txtCredBranch").readOnly = false;
		enableSearch("searchIntmNo");
		enableSearch("searchLineCd");
		enableSearch("searchSublineCd");
		$$("div#intermediaryCommissionBodyDiv input[type='text']").each(function (a) {
			$(a).clear();
		});
		try {
		} catch (e) {
			showErrorMessage("resetPage",e);
		}
	}
	
	function disableAllFields() {
		try{
			disableToolbarButton("btnToolbarExecuteQuery");
			enableToolbarButton("btnToolbarEnterQuery");
			$$("div#intermediaryCommissionBodyDiv input[type='text']").each(function (a) {
				$(a).readOnly = true;
			});
			$$("div#intermediaryCommissionBodyDiv img").each(function (img) {
				var src = img.src;
				if(nvl(img, null) != null){
					if(src.include("searchIcon.png")){
						disableSearch(img);
					}
				}
			});
		} catch(e){
			showErrorMessage("disableAllFields", e);
		}
	} 
	
	function lovOnChangeEvent(id,lovFunc,populateFunc,noRecordFunc,content,findText) {
		try{
			if (findText == null) {
				findText = $F(id).trim() == "" ? "%" : $F(id);
			}
			var cond = validateTextFieldLOV(content,findText,"Searching, please wait...");
			if (cond == 2) {
				lovFunc(findText);
			} else if(cond == 0) {
				noRecordFunc();				
			}else{
				populateFunc(cond);
			}
		}catch (e) {
			showErrorMessage("lovOnChangeEvent",e);
		}
	}
	
	try {
		var jsonIntermediaryCommission =  JSON.parse('${jsonIntermediaryComm}');
		intermediaryCommissionTableModel = {
			url : contextPath+ "/GIPIPolbasicController?action=showViewIntermediaryCommission&refresh=1",
			options : {
				width : '900px',
				height : '310px',
				onCellFocus : function(element, value, x, y, id) {
					selectedObj = tbgIntermediaryCommission.geniisysRows[y];
					enableButton("btnCommDetail");
					enableButton("btnPeril");
					tbgIntermediaryCommission.keys.removeFocus(tbgIntermediaryCommission.keys._nCurrentFocus, true);
					tbgIntermediaryCommission.keys.releaseKeys();
				},
				postPager : function() {
					selectedObj = null;
					disableButton("btnCommDetail");
					disableButton("btnPeril");
					tbgIntermediaryCommission.keys.removeFocus(tbgIntermediaryCommission.keys._nCurrentFocus, true);
					tbgIntermediaryCommission.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					selectedObj = null;
					disableButton("btnCommDetail");
					disableButton("btnPeril");
					tbgIntermediaryCommission.keys.removeFocus(tbgIntermediaryCommission.keys._nCurrentFocus, true);
					tbgIntermediaryCommission.keys.releaseKeys();
				},
				onSort : function() {
					selectedObj = null;
					disableButton("btnCommDetail");
					disableButton("btnPeril");
					tbgIntermediaryCommission.keys.removeFocus(tbgIntermediaryCommission.keys._nCurrentFocus, true);
					tbgIntermediaryCommission.keys.releaseKeys();
				},
				toolbar : {
					elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
					onFilter : function() {
						selectedObj = null;
						disableButton("btnCommDetail");
						disableButton("btnPeril");
						tbgIntermediaryCommission.keys.removeFocus(tbgIntermediaryCommission.keys._nCurrentFocus, true);
						tbgIntermediaryCommission.keys.releaseKeys();
					},
					onRefresh : function() {
						selectedObj = null;
						disableButton("btnCommDetail");
						disableButton("btnPeril");
						tbgIntermediaryCommission.keys.removeFocus(tbgIntermediaryCommission.keys._nCurrentFocus, true);
						tbgIntermediaryCommission.keys.releaseKeys();
					},
				}
			},
			columnModel : [
					{
						id : 'recordStatus',
						title : '',
						width : '0',
						visible : false
					},
					{
						id : 'divCtrId',
						width : '0',
						visible : false
					},
					{
						id : "policyNo",
						title : "Policy / Endorsement No.",
						width : '250px',
						filterOption: true
					},
					{
						id : "invoiceNo",
						title : "Invoice No.",
						width : '100px',
						filterOption: true
					},
					{
						id : "assuredName",
						title : "Assured Name",
						width : '270px',
						filterOption: true
					},
					{
						id : "sharePercent",
						title : "% Share",
						width : '100px',
						titleAlign : 'right',
						geniisysClass: 'money',
						filterOptionType : 'integerNoNegative',
						align : 'right',
						filterOption: true
					},
					{
						id : "commAmt",
						title : "Commission Amt.",
						width : '150px',
						titleAlign : 'right',
						geniisysClass: 'money',
						filterOptionType : 'integerNoNegative',
						align : 'right',
						filterOption: true
					},
				],
			rows : jsonIntermediaryCommission.rows
		};
		tbgIntermediaryCommission = new MyTableGrid(intermediaryCommissionTableModel);
		tbgIntermediaryCommission.pager = jsonIntermediaryCommission;
		tbgIntermediaryCommission.render('intermediaryCommissionTable');
// 		tbgIntermediaryCommission.afterRender = function(){
// 											};
	} catch (e) {
		showErrorMessage("intermediaryCommissionTableModel", e);
	}
	
	function showGipis139IntmLOV(findText2,id){
		try{
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
								 action   : "showGipis139IntmLOV",
								 findText2 : findText2,
								 page : 1
				},
				title: "Intermediary",
				width: 400,
				height: 400,
				columnModel: [
					{
						id : 'intmNo',
						title: 'Number',
						width : '100px',
						align: 'right'
					},
					{
						id : 'intmName',
						title: 'Name',
					    width: '280px',
					    align: 'left'
					}
				],
				draggable: true,
				filterText: findText2,
				autoSelectOneRecord : true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtIntmNo").value =  lpad(row.intmNo,12,'0');
						$("txtIntmName").value = unescapeHTML2(row.intmName);
						resetIntm = true;
					}
				},
				onCancel: function(){
					$("txtIntmNo").clear();
					$("txtIntmName").clear();
					resetIntm = true;
		  		},
				onUndefinedRow : function(){
					$("txtIntmNo").clear();
					$("txtIntmName").clear();
					showMessageBox("No record selected.", "I");
					resetIntm = true;
				}
			});
		}catch(e){
			showErrorMessage("showGipis139IntmLOV",e);
		}
	}
	
	function showGipis139LineLOV(findText2,id,moduleId){
		try{
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
								 action   : "showGipis139LineLOV",
								 moduleId : moduleId,
								 findText2 : findText2,
								 page : 1
				},
				title: "Lines",
				width: 400,
				height: 400,
				columnModel: [
					{
						id : 'lineCd',
						title: 'Line',
						width : '100px',
						align: 'left'
					},
					{
						id : 'lineName',
						title: 'Name',
					    width: '280px',
					    align: 'left'
					}
				],
				draggable: true,
				filterText: findText2,
				autoSelectOneRecord : true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtLineCd").value = unescapeHTML2(row.lineCd);
						$("txtLineName").value = unescapeHTML2(row.lineName);
						resetLine = true;
					}
				},
				onCancel: function(){
					$("txtLineCd").clear();
					$("txtLineName").clear();
					resetLine = true;
		  		},
				onUndefinedRow : function(){
					$("txtLineCd").clear();
					$("txtLineName").clear();
					showMessageBox("No record selected.", "I");
					resetLine = true;
				}
			});
		}catch(e){
			showErrorMessage("showGipis139LineLOV",e);
		}
	}
	
	function showGipis139SublineLOV(findText2,id){
		try{
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
								 action   : "showGipis139SublineLOV",
								 lineCd : $F("txtLineCd"),
								 findText2 : findText2,
								 page : 1
				},
				title: "Subline",
				width: 400,
				height: 400,
				columnModel: [
					{
						id : 'sublineCd',
						title: 'Subline Code',
						width : '100px',
						align: 'left'
					},
					{
						id : 'sublineName',
						title: 'Subline Name',
					    width: '280px',
					    align: 'left'
					}
				],
				draggable: true,
				filterText: findText2,
				autoSelectOneRecord : true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtSublineCd").value = unescapeHTML2(row.sublineCd);
						$("txtSublineName").value = unescapeHTML2(row.sublineName);
						resetSubline = true;
					}
				},
				onCancel: function(){
					$("txtSublineCd").clear();
					$("txtSublineName").clear();
					resetSubline = true;
		  		},
				onUndefinedRow : function(){
					$("txtSublineCd").clear();
					$("txtSublineName").clear();
					showMessageBox("No record selected.", "I");
					resetSubline = true;
				}
			});
		}catch(e){
			showErrorMessage("showGipis139SublineLOV",e);
		}
	}
	
 	function showCommDtlOverlay() {
		try{
			overlayCommDtl = Overlay.show(contextPath+"/GIPIPolbasicController",
					{urlContent: true,
					 title: "Commission Details",
					 urlParameters: {
		                    action : "getGipis139CommDetail",
		                    intmNo : selectedObj.intmNo,
		                    issCd : selectedObj.issCd,
		                    premSeqNo : selectedObj.premSeqNo,
		                    policyId : selectedObj.policyId,
		                    lineCd : selectedObj.lineCd
		            },
					 height: 350,
					 width: 750,
					 draggable: false
					});
		}catch (e) {
			showErrorMessage("showCommDtlOverlay",e);
		}
	}
 	
 	function showPerilDtlOverlay() {
		try{
			overlayPerilDtl = Overlay.show(contextPath+"/GIPIPolbasicController",
					{urlContent: true,
					 title: "Peril Details",
					 urlParameters: {
		                    action : "getGipis139PerilDetail",
		                    intmNo : selectedObj.intmNo,
		                    issCd : selectedObj.issCd,
		                    premSeqNo : selectedObj.premSeqNo,
		                    policyId : selectedObj.policyId,
		                    lineCd : selectedObj.lineCd
		            },
					 height: 300,
					 width: 550,
					 draggable: false
					});
		}catch (e) {
			showErrorMessage("showPerilDtlOverlay",e);
		}
	}
	
	/* observe */
	$("btnCommDetail").observe("click", function(){
		showCommDtlOverlay();
	});
	
	$("btnPeril").observe("click", function(){
		showPerilDtlOverlay();
	});
	
	$("searchIntmNo").observe("click", function(){
		if (resetIntm) { 
			var findText = "%";
			showGipis139IntmLOV(findText, "txtIntmNo");
		}
	});
	
	$("searchLineCd").observe("click", function(){
		if (resetLine) { 
			var findText = "%";
			showGipis139LineLOV(findText, "txtLineCd","GIPIS139");
		}
	});
	
	$("searchSublineCd").observe("click", function(){
		if (resetSubline) { 
			if($F("txtLineCd").trim() == ""){
				$("txtSublineCd").clear();
				$("txtSublineName").clear();
				showMessageBox("Please enter Line Code first.","I");
				return;
			}
			var findText = "%";
			showGipis139SublineLOV(findText, "txtSublineCd");
		}
	});
	
	$("txtIntmNo").observe("change", function() {
		if (this.value.trim() == "") {
			$("txtIntmNo").clear();
			$("txtIntmName").clear();
			return;
		}
		resetIntm = false;
		var findText = this.value.trim() == "" ? "%" : this.value;
		showGipis139IntmLOV(findText, "txtIntmNo");
	});
	
	$("txtLineCd").observe("change", function() {
		if (this.value.trim() == "") {
			$("txtLineCd").clear();
			$("txtLineName").clear();
			return;
		}
		resetLine = false;
		var findText = this.value.trim() == "" ? "%" : this.value;
		showGipis139LineLOV(findText, "txtLineCd","GIPIS139");
	});
	
	$("txtSublineCd").observe("change", function() {
		if($F("txtLineCd").trim() == ""){
			$("txtSublineCd").clear();
			$("txtSublineName").clear();
			showMessageBox("Please enter Line Code first.","I");
			return;
		}else if (this.value.trim() == "") {
			$("txtSublineCd").clear();
			$("txtSublineName").clear();
			return;
		}
		resetSubline = false;
		var findText = this.value.trim() == "" ? "%" : this.value;
		showGipis139SublineLOV(findText, "txtSublineCd");
	});
	
	$("btnToolbarExecuteQuery").observe("click" , function() {
		if (checkAllRequiredFieldsInDiv("intermediaryCommissionBodyDiv")) {
			disableAllFields();
			tbgIntermediaryCommission.url = contextPath+ "/GIPIPolbasicController?action=showViewIntermediaryCommission&refresh=1&intmNo="+$F("txtIntmNo")
																															   +"&lineCd="+$F("txtLineCd")
																															   +"&sublineCd="+$F("txtSublineCd")
																															   +"&credBranch="+$F("txtCredBranch")
																															   +"&moduleId="+"GIPIS139";
			tbgIntermediaryCommission._refreshList();
			
			if(tbgIntermediaryCommission.geniisysRows.length == 0){
				showMessageBox("Query caused no records to be retrieved. Re-enter.", "I");
			}
		}
	});

	$("btnToolbarEnterQuery").observe("click" , function() {
		resetPage();
		tbgIntermediaryCommission.url = contextPath+ "/GIPIPolbasicController?action=showViewIntermediaryCommission&refresh=1";
		tbgIntermediaryCommission._refreshList();
	});
	
	$("btnToolbarExit").observe("click" , function() {
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	
	resetPage();
</script>