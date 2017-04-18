<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giris055MainDiv" name="giris055MainDiv" style="">
	<div id="giris055ExitDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="btnExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>View Binder Status</label>
	   		<span class="refreshers" style="margin-top: 0;">
			</span>
	   	</div>
	</div>
	<div id="giris055" name="giris055">
		<div class="sectionDiv" style="height: 495px;">
			<div id="binderStatTableDiv" style="padding-top: 10px;">
				<div id="binderStatTable" style="height: 340px; margin-left: 10px;"></div>
			</div>
			<div class="sectionDiv" align="center" id="binderInfoDiv" style="margin-top: 10px; margin-left: 10px; margin-bottom: 0px; width: 98%;">
				<table style="margin-top: 10px; margin-bottom: 10px;">
					<tr>
						<td class="rightAligned">Assured Name</td>
						<td class="leftAligned" colspan="4">
							<input id="txtNbtAssdName" type="text" readonly="readonly" style="width: 581px;" tabindex="101" maxlength="500">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Policy No.</td>
						<td class="leftAligned">
							<input type="text" readonly="readonly" name="txtNbtLineCd" id="txtNbtLineCd" tabindex="102" style="width: 40px; text-align: left; border: 1px solid gray;">
							<input type="text" readonly="readonly" name="txtNbtSublineCd" id="txtNbtSublineCd" tabindex="103" style="width: 70px; text-align: left; border: 1px solid gray;">
							<input type="text" readonly="readonly" name="txtNbtIssCd" id="txtNbtIssCd" tabindex="104" style="width: 40px; text-align: left; border: 1px solid gray;">
							<input type="text" readonly="readonly" name="txtNbtIssueYy" id="txtNbtIssueYy" tabindex="105" style="width: 40px; text-align: right; border: 1px solid gray;">
							<input type="text" readonly="readonly" name="txtNbtPolSeqNo" id="txtNbtPolSeqNo" tabindex="106" style="width: 70px; text-align: right; border: 1px solid gray;">
							<input type="text" readonly="readonly" name="txtNbtRenewNo" id="txtNbtRenewNo" tabindex="107" style="width: 40px; text-align: right; border: 1px solid gray;">
						</td>
						<td class="rightAligned">/</td>
						<td class="leftAligned">
							<input type="text" readonly="readonly" name="txtNbtEndtIssCd" id="txtNbtEndtIssCd" tabindex="108" style="width: 50px; text-align: left; border: 1px solid gray;">
							<input type="text" readonly="readonly" name="txtNbtEndtYy" id="txtNbtEndtYy" tabindex="109" style="width: 50px; text-align: right; border: 1px solid gray;">
							<input type="text" readonly="readonly" name="txtNbtEndtSeqNo" id="txtNbtEndtSeqNo" tabindex="110" style="width: 73px; text-align: right; border: 1px solid gray;">
						</td>
					</tr>
				</table>
			</div>
			<div class="buttonsDiv">
				<input type="button" class="button" id="btnViewDistByPeril" value="View Distribution by Peril" tabindex="111">
			</div>
		</div>	
	</div>
</div>
<script type="text/javascript">
	setModuleId("GIRIS055");
	setDocumentTitle("View Binder Status");
	initializeAll();
	checkUserAccess();
	var fnlBinderId;
	
	function checkUserAccess(){
		try{
			new Ajax.Request(contextPath+"/GIACAccTransController?action=checkUserAccess2", {
				method: "POST",
				parameters: {
					moduleName: "GIRIS055"
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(response.responseText == 0){
						showWaitingMessageBox('You are not allowed to access this module.', imgMessage.ERROR, function(){
							goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
						});  
						
					}
				}
			});
		}catch(e){
			showErrorMessage('checkUserAccess', e);
		}
	}
	
	var rowIndex = -1;
	var objGIRIS055 = {};
	var objCurrBinderStat = null;
	objGIRIS055.binderStatList = JSON.parse('${jsonGiris055BinderStatList}');
	
	var binderStatTable = {
			url : contextPath + "/GIRIBinderController?action=showGiris055&refresh=1",
			options : {
				width : '900px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrBinderStat = tbgBinderStatList.geniisysRows[y];
					setFieldValues(objCurrBinderStat);
					tbgBinderStatList.keys.removeFocus(tbgBinderStatList.keys._nCurrentFocus, true);
					tbgBinderStatList.keys.releaseKeys();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgBinderStatList.keys.removeFocus(tbgBinderStatList.keys._nCurrentFocus, true);
					tbgBinderStatList.keys.releaseKeys();
				},
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgBinderStatList.keys.removeFocus(tbgBinderStatList.keys._nCurrentFocus, true);
						tbgBinderStatList.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgBinderStatList.keys.removeFocus(tbgBinderStatList.keys._nCurrentFocus, true);
					tbgBinderStatList.keys.releaseKeys();
				},
				onSort: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgBinderStatList.keys.removeFocus(tbgBinderStatList.keys._nCurrentFocus, true);
					tbgBinderStatList.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgBinderStatList.keys.removeFocus(tbgBinderStatList.keys._nCurrentFocus, true);
					tbgBinderStatList.keys.releaseKeys();
				},
				prePager: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgBinderStatList.keys.removeFocus(tbgBinderStatList.keys._nCurrentFocus, true);
					tbgBinderStatList.keys.releaseKeys();
				}
			},
			columnModel : [
				{ 								// this column will only be used for deletion
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
					id : 'binderNo',
					filterOption : false,
					title : 'Binder Number',
					width : '100px'				
				},
				{
					id : 'dspRiName',
					filterOption : true,
					title : 'Reinsurer',
					width : '400px'
				},
				{
					id : 'binderDate',
					title : 'Binder Date',
					width : '110px',
					titleAlign : 'center',
					filterOptionType : 'formattedDate',
					filterOption : true,
				},
				{
					id : 'reverseDate',
					title : 'Reversal Date',
					width : '110px',
					titleAlign : 'center',
					filterOptionType : 'formattedDate',
					filterOption : true,
				},
				{
					id : 'dspStatus',
					filterOption : true,
					title : 'Status',
					width : '160px'
				}, 
				{
					id : "lineCd",
					title : "Binder Line Code",
					width : '0px',
					filterOption : true,
					visible : false
				},
				{
					id : "binderYy",
					title : "Binder Year",
					width : '0px',
					filterOption : true,
					filterOptionType : 'integerNoNegative',
					visible : false
				},
				{
					id : "binderSeqNo",
					title : "Binder Seq. No.",
					width : '0px',
					filterOption : true,
					filterOptionType : 'integerNoNegative',
					visible : false
				}
			],
			rows : objGIRIS055.binderStatList.rows
	};
	tbgBinderStatList = new MyTableGrid(binderStatTable);
	tbgBinderStatList.pager = objGIRIS055.binderStatList;
	tbgBinderStatList.render("binderStatTable");
	
	function setFieldValues(rec){
		try{
			fnlBinderId = rec == null ? "" : rec.fnlBinderId;
			$("txtNbtAssdName").value = rec == null ? "" : unescapeHTML2(rec.nbtAssdName);
			$("txtNbtLineCd").value = rec == null ? "" : rec.nbtLineCd;
			$("txtNbtSublineCd").value = rec == null ? "" : rec.nbtSublineCd;
			$("txtNbtIssCd").value = rec == null ? "" : rec.nbtIssCd;
			$("txtNbtIssueYy").value = rec == null ? "" : formatNumberDigits(rec.nbtIssueYy, 2);
			$("txtNbtPolSeqNo").value = rec == null ? "" : formatNumberDigits(rec.nbtPolSeqNo, 7);
			$("txtNbtRenewNo").value = rec == null ? "" : formatNumberDigits(rec.nbtRenewNo, 2);
			$("txtNbtEndtIssCd").value = rec == null ? "" : rec.nbtEndtIssCd == null ? "" : rec.nbtEndtIssCd;
			$("txtNbtEndtYy").value = rec == null ? "" : rec.nbtEndtYy == null ? "" : formatNumberDigits(rec.nbtEndtYy, 2);
			$("txtNbtEndtSeqNo").value = rec == null ? "" : rec.nbtEndtSeqNo == null ? "" : formatNumberDigits(rec.nbtEndtSeqNo, 2);
			rec == null ? disableButton("btnViewDistByPeril") : rec.distPerilSw == 'Y' ? enableButton("btnViewDistByPeril") : disableButton("btnViewDistByPeril");
			objCurrBinderStat = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	$("btnViewDistByPeril").observe("click", function(){
		viewDistPerilOverlay();
	});
	
	function viewDistPerilOverlay(){
		try {
			distPerilOverlay = Overlay.show(contextPath+"/GIRIBinderController", {
				urlContent: true,
				urlParameters: {action    : "showDistPerilOverLay",																
								ajax      : "1",
								fnlBinderId : fnlBinderId
				},
			    title: "Distribution by Peril",
			    height: 400,
			    width: 800,
			    draggable: true
			});
		} catch (e) {
			showErrorMessage("Distribution by Peril Overlay Error: " , e);
		}
	}
	
    $("btnExit").observe("click", function(){
    	goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
    });
    
    disableButton("btnViewDistByPeril");
	observeReloadForm("reloadForm", showGiris055);
</script>