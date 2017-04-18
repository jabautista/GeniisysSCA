<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>


<div id="parListingMainDiv" module="parCreation">
	<div id="coverNoteInquiryMainDiv">
		<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	
		<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
			<div id="innerDiv" name="innerDiv">
				<label>Cover Note Inquiry</label>
			</div>
		</div>
		
		<div id="paramsDiv" class="sectionDiv" style="width: 100%; height: 97px;">
			<fieldset style="height: 70px; width: 885px; margin: 5px 10px 0px 10px;">
				<legend>Search By</legend>
				<table style="margin: 15px 0 0 10px; float: left;">
					<tr>
						<td>
							<input id="inceptDateRB" name="searchByRG" type="radio" value="1" style="margin: 2px 5px 4px 5px; float: left;" checked="checked">
							<label for="inceptDateRB" style="margin: 2px 0 4px 0">Incept Date</label>
						</td>
						<td>
							<input id="expiryDateRB" name="searchByRG" type="radio" value="2" style="margin: 2px 5px 4px 20px; float: left;" >
							<label for="expiryDateRB" style="margin: 2px 0 4px 0">Expiry Date</label>
						</td>
						<td>
							<input id="cnPrintedDateRB" name="searchByRG" type="radio" value="3" style="margin: 2px 5px 4px 20px; float: left;" >
							<label for="cnPrintedDateRB" style="margin: 2px 0 4px 0">CN Printed Date</label>
						</td>
						<td>
							<input id="cnExpiryDateRB" name="searchByRG" type="radio" value="4" style="margin: 2px 5px 4px 20px; float: left;" >
							<label for="cnExpiryDateRB" style="margin: 2px 0 4px 0">CN Expiry Date</label>
						</td>
					</tr>
				</table>
				<table style="margin: 2px 0 0 10px; float: right;">
					<tr>
						<td class="rightAligned" style="padding-right: 13px;">
							<input id="asOfRB" name="dateTypeRG" type="radio" value="1" style="margin: 2px 5px 4px 5px; float: left;" checked="checked">
							<label for="asOfRB" style="margin: 2px 0 4px 0">As Of</label>
						</td>
						<td colspan="2">
							<div id="asOfDateDiv" class="withIcon " style="float: left; border: 1px solid gray; width: 145px; height: 20px;">
								<input id="txtAsOfDate" readonly="readonly" type="text" class="withIcon disableDelKey" maxlength="10" style="border: none; float: left; width: 120px; height: 13px; margin: 0px;" value=""  tabindex="103"/>
								<img id="imgAsOfDate" alt="Date" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onclick="$('txtAsOfDate').focus(); scwShow($('txtAsOfDate'),this, null);" />
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">
							<input id="fromRB" name="dateTypeRG" type="radio" value="2" style="margin: 2px 5px 4px 5px; float: left;">
							<label for="fromRB" style="margin: 2px 0 4px 0">From</label>
						</td>
						<td>
							<div id="fromDateDiv" class="withIcon" style="float: left; border: 1px solid gray; width: 145px; height: 20px;">
								<input id="txtFromDate" name="fromToInput" readonly="readonly" type="text" class="withIcon disableDelKey" maxlength="10" style="border: none; float: left; width: 120px; height: 13px; margin: 0px;" value="" tabindex="104"/>
								<img id="imgFromDate" alt="Date" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" "/>
							</div>
						</td>
						<td>
							<div id="toDateDiv" class="withIcon" style="float: left; border: 1px solid gray; width: 145px; height: 20px;">
								<input id="txtToDate" name="fromToInput" readonly="readonly" type="text" class="withIcon disableDelKey" maxlength="10" style="border: none; float: left; width: 120px; height: 13px; margin: 0px;" value="" tabindex="105"/>
								<img id="imgToDate" alt="Date" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" />
							</div>
						</td>
					</tr>
				</table>
			</fieldset>
		</div>
		
		<div id="coverNoteDiv" class="sectionDiv" style="width: 100%; height: 403px;">
			
			<div id="coverNoteListTGDiv" style="width: 900px; height: 285px; margin: 10px 10px 5px 10px;"></div>
			
			<table style="margin: 5px 0 5px 50px;">
				<tr>
					<td class="rightAligned" style="padding-right: 7px">Policy / Endt. No.</td>
					<td colspan="5"><input id="txtPolicyNo" type="text" readonly="readonly" style="width: 700px;"></td>
				</tr>
				<tr>
					<td class="rightAligned" style="padding-right: 7px">Address of Assured</td>
					<td colspan="5"><input id="txtAddress" type="text" readonly="readonly" style="width: 700px;"></td>
				</tr>
				<tr>
					<td class="rightAligned" style="padding-right: 7px">Incept Date</td>
					<td><input id="txtInceptDate" type="text" readonly="readonly" style="width: 140px;"></td>
					<td style="padding: 0 7px 0 50px;">Expiry Date</td>
					<td><input id="txtExpiryDate" type="text" readonly="readonly" style="width: 140px;"></td>
					<td style="padding: 0 7px 0 50px;">Underwriter</td>
					<td><input id="txtUnderwriter" type="text" readonly="readonly" style="width: 140px;"></td>
				</tr>
			</table>
		</div>
	</div>
	
</div>

<jsp:include page="/pages/underwriting/menus/basicInfoMenu.jsp"></jsp:include>
<div id="parInfoDiv" name="parInfoDiv" style="display: none;"></div>

<script type="text/javascript">
try{
	setModuleId("GIPIS213");
	setDocumentTitle("Cover Note Inquiry");
	
	hideToolbarButton("btnToolbarPrint");
	disableToolbarButton("btnToolbarEnterQuery");
	
	$("txtAsOfDate").value = dateFormat(new Date(), 'mm-dd-yyyy');
	
	$("txtFromDate").disabled = true;
	disableDate("imgFromDate");
	$("txtToDate").disabled = true;
	disableDate("imgToDate");
	
	var dateTypeRB = "1";
	var searchByRB = "1";
	var entQuery = false;
	
	var selectedRowInfo = null;
	
	var objCovernote = new Object();
	objCovernote.tablegrid = JSON.parse('${covernoteGrid}'.replace(/\\/g, '\\\\'));
	objCovernote.objRows = objCovernote.tablegrid || [];
	
	try{
		var covernoteTableModel = {
			url : contextPath+"/GIPIPARListController?action=getCoverNoteList&refresh=1",
			options: {
				width: '898px',
				height: '255px',
				onCellFocus: function(element, value, x, y, id){
					selectedRowInfo = covernoteTG.geniisysRows[y];
					populateCovernoteFields(selectedRowInfo);
				},
				onRemoveRowFocus: function(){
					covernoteTG.keys.releaseKeys();
					selectedRowInfo = null;
					populateCovernoteFields(null);
				},
				onSort: function(){
					covernoteTG.onRemoveRowFocus();
				},
				onRefresh: function(){
					covernoteTG.onRemoveRowFocus();
				},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onFilter: function(){
						covernoteTG.onRemoveRowFocus();
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
					id: 'parId',
					width: '0px',
					visible: false
				},
				{
					id: 'lineCd',
					title: 'Line Cd',
					width: '0px',
					visible: false,
					filterOption: true
				},
				{
					id: 'issCd',
					title: 'Issue Cd',
					width: '0px',
					visible: false,
					filterOption: true
				},
				{
					id: 'parYy',
					title: 'PAR Year',
					width: '0px',
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{
					id: 'parSeqNo',
					title: 'PAR Seq No',
					width: '0px',
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{
					id: 'parStatus',
					width: '0px',
					visible: false
				},
				{
					id: 'assdNo',
					width: '0px',
					visible: false
				},
				{
					id: 'address',
					width: '0px',
					visible: false
				},
				{
					id: 'inceptDate',
					width: '0px',
					visible: false
				},
				{
					id: 'expiryDate',
					width: '0px',
					visible: false
				},
				{
					id: 'policyNo',
					width: '0px',
					visible: false
				},
				{
					id: 'underwriter',
					width: '0px',
					visible: false
				},  
				{
					id: 'parNumber',
					title: 'PAR Number',
					width: '165px',
					visible: true,
					sortable: true
				}, 
				{
					id: 'assdName',
					title: 'Assured',
					width: '345px',
					visible: true,
					sortable: true,
					filterOption: true
				},
				{
					id: 'cnDatePrinted',
					title: 'Date Printed',
					width: '100px',
					visible: true,
					sortable: true,
					filterOption: true,
					filterOptionType: 'formattedDate',
					renderer: function(value){
						return formatDateToDefaultMask(value);
					}
				},
				{
					id: 'cnExpiryDate',
					title: 'CN Expiry',
					width: '100px',
					visible: true,
					sortable: true,
					filterOption: true,
					filterOptionType: 'formattedDate',
					renderer: function(value){
						return formatDateToDefaultMask(value);
					}
				},  
				{
					id: 'premAmt',
					title: 'Premium Amount',
					width: '131px',
					titleAlign: 'right',
					align: 'right',
					geniisysClass: 'money',
					visible: true,
					sortable: true,
					filterOption: true,
					filterOptionType: 'number'
				} 
			],
			rows : objCovernote.objRows
		};
		
		covernoteTG = new MyTableGrid(covernoteTableModel);
		covernoteTG.pager = objCovernote.tablegrid;
		covernoteTG.render('coverNoteListTGDiv');
		
	}catch(e){
		showErrorMessage("Cover Note table grid error", e);
	}
	
	
	function populateCovernoteFields(row){
		try{
			row == null ? $("txtPolicyNo").clear() : $("txtPolicyNo").value = unescapeHTML2(row.policyNo);
			row == null ? $("txtAddress").clear() : $("txtAddress").value = unescapeHTML2(row.address);
			row == null ? $("txtInceptDate").clear() : $("txtInceptDate").value = dateFormat(row.inceptDate, 'mm-dd-yyyy');
			row == null ? $("txtExpiryDate").clear() : $("txtExpiryDate").value = dateFormat(row.expiryDate, 'mm-dd-yyyy');
			row == null ? $("txtUnderwriter").clear() : $("txtUnderwriter").value = unescapeHTML2(row.underwriter);
		}catch(e){
			showErrorMessage("populateCovernoteFields", e);
		}		
	};	
	
	function toggleEnterExecute(enterQuery){
		try{
			if (enterQuery){
				$$("div#paramsDiv input[type='radio']").each(function(rb){
					rb.disabled = false;
				});
				
				$$("div#coverNoteDiv input[type='text']").each(function(txt){
					txt.clear();
				});
				
				if (dateTypeRB == "1"){ //as of
					$("txtAsOfDate").disabled = false;
					enableDate("imgAsOfDate");
				}else if(dateTypeRB == "2"){ // from
					$("txtFromDate").disabled = false;
					enableDate("imgFromDate");
					$("txtToDate").disabled = false;
					enableDate("imgToDate");
				}
				
				disableToolbarButton("btnToolbarEnterQuery");
				enableToolbarButton("btnToolbarExecuteQuery");
			}else{
				/*$$("div#paramsDiv input[type='radio']").each(function(rb){
					rb.disabled = true;
				});*/
				
				$$("input[name='dateTypeRG']").each(function(rb){
					rb.disabled = true;
				});
				
				if (dateTypeRB == "1"){ //as of
					$("txtAsOfDate").disabled = true;
					disableDate("imgAsOfDate");
				}else if(dateTypeRB == "2"){ // from
					$("txtFromDate").disabled = true;
					disableDate("imgFromDate");
					$("txtToDate").disabled = true;
					disableDate("imgToDate");
				}
				
				enableToolbarButton("btnToolbarEnterQuery");
				disableToolbarButton("btnToolbarExecuteQuery");
			}
			entQuery = enterQuery;
		}catch(e){
			showErrorMessage("toggleEnterExecute", e);
		}
	}	
	
	$("imgFromDate").observe("click", function(){
		scwNextAction = function(){
							checkInputDates("txtFromDate", "txtFromDate", "txtToDate");
						}.runsAfterSCW(this, null);
						
		scwShow($("txtFromDate"),this, null);
	});
	
	$("imgToDate").observe("click", function(){
		scwNextAction = function(){
							checkInputDates("txtToDate", "txtFromDate", "txtToDate");
						}.runsAfterSCW(this, null);
						
		scwShow($("txtToDate"),this, null);
	});
	
	$$("input[name='dateTypeRG']").each(function(rb){
		rb.observe("click", function(){
			dateTypeRB = rb.value;
			
			if (dateTypeRB == "1"){ //as of
				$("txtAsOfDate").focus();
				$("txtAsOfDate").disabled = false;
				enableDate("imgAsOfDate");
				$("txtFromDate").clear();
				$("txtFromDate").removeClassName("required");
				$("txtFromDate").disabled = true;
				disableDate("imgFromDate");
				$("txtToDate").clear();
				$("txtToDate").removeClassName("required");
				$("txtToDate").disabled = true;
				disableDate("imgToDate");
			}else if(dateTypeRB == "2"){ // from
				$("txtFromDate").focus();
				$("txtFromDate").addClassName("required");
				$("txtFromDate").disabled = false;
				enableDate("imgFromDate");
				$("txtToDate").addClassName("required");
				$("txtToDate").disabled = false;
				enableDate("imgToDate");
				$("txtAsOfDate").clear();
				$("txtAsOfDate").disabled = true;
				disableDate("imgAsOfDate");
			}
		});
	});
	
	$$("input[name='searchByRG']").each(function(rb){
		rb.observe("click", function(){
			searchByRB = rb.value;
			if (!entQuery){
				covernoteTG.url = contextPath+"/GIPIPARListController?action=getCoverNoteList&refresh=1&dateType="+dateTypeRB+"&searchBy="+searchByRB
								  +"&asOfDate="+$F("txtAsOfDate")+"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate");
				covernoteTG._refreshList();
				if (covernoteTG.geniisysRows.length == 0){
					showMessageBox("Query caused no records to be retrieved.", "I");
				}
			}
		});
	});
	
	$$("input[name='fromToInput']").each(function(txt){
		txt.observe("blur", function(){
			checkInputDates(txt.id, "txtFromDate", "txtToDate");
		});
	});
	
	
	$("btnToolbarEnterQuery").observe("click", function(){
		covernoteTG.url = contextPath+"/GIPIPARListController?action=getCoverNoteList&refresh=1";
		covernoteTG._refreshList();
		toggleEnterExecute(true);
	});
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		if(checkAllRequiredFieldsInDiv('paramsDiv')){
			if ($("asOfRB").checked && $F("txtAsOfDate") == ""){
				$("txtAsOfDate").value = dateFormat(new Date(), "mm-dd-yyyy");
			}
			
			covernoteTG.url = contextPath+"/GIPIPARListController?action=getCoverNoteList&refresh=1&dateType="+dateTypeRB+"&searchBy="+searchByRB
								+"&asOfDate="+$F("txtAsOfDate")+"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate");
			covernoteTG._refreshList();
			toggleEnterExecute(false);
			if (covernoteTG.geniisysRows.length == 0){
				showMessageBox("Query caused no records to be retrieved.", "I");
			}
		}		
	});
	
	$("btnToolbarExit").observe("click", function(){
		covernoteTG.onRemoveRowFocus();
		creationFlag = true;
		showParListing();	
	});
	
}catch(e){
	showMessageBox("Page Error", e);
}
</script>