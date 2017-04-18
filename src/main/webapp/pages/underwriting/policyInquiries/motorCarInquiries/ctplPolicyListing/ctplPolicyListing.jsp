<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="ctplPolicyListingMainDiv" name="ctplPolicyListingMainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>CTPL Motor Policy Listing</label>
		</div>
	</div>
	
	<div id="ctplPolicyListingHeaderDiv" class="sectionDiv" style="padding: 10px 0 10px 0;">
		<table style="float: left; margin: 0 0 0 20px;">
			<tr>
				<td class="rightAligned">Crediting Branch</td>
				<td colspan="2">
					<input id="credBranch" name="credBranch" type="text" class="upper" maxlength="2"  style="width: 90px; margin-left: 4px;" tabindex="101">
				</td>
				<td>
					<input id="asOf" value="asOf" title="As of" type="radio" name="dateRangeRG" style="margin: 0 5px 0 35px; float: left;" checked="checked" tabindex="106">
					<label for="asOf">As of</label>
				</td>
				<td>
					<div id="asOfDateDiv" class="required" style="float:left; border: solid 1px gray; width: 128px; height: 21px; margin-right:3px;">
			    		<input style="height: 13px; width: 104px; border: none; float: left;" id="asOfDate" name="headerField" class="required" type="text" readonly="readonly" tabindex="107"/>
			    		<img name="hrefAsOfDate" id="hrefAsOfDate" style="margin-top: 1px;" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="As of" onClick="scwShow($('asOfDate'),this, null);"/>
					</div>
				</td>
			</tr>
			<tr>
			    <td class="rightAligned">Date Basis</td>
			    <td>
			        <input id="inceptDate" value="incept" title="Incept Date" type="radio" name="dateBasisRG" style="margin: 0 5px 0 5px; float: left;" checked="checked" tabindex="102">
					<label for="inceptDate">Incept Date</label>
			    </td>
			    <td>
			        <input id="effectivityDate" value="effectivity" title="Effectivity Date" type="radio" name="dateBasisRG" style="margin: 0 5px 0 5px; float: left;" tabindex="103">
					<label for="effectivityDate">Effectivity Date</label>
			    </td>
			    <td>
					<input id="from" value="from" title="From" type="radio" name="dateRangeRG" style="margin: 0 5px 0 35px; float: left;" tabindex="108">
					<label for="from">From</label>
				</td>
				<td>
					<div id="fromDateDiv" style="float:left; border: solid 1px gray; width: 128px; height: 21px; margin-right:3px;">
			    		<input style="height: 13px; width: 104px; border: none; float: left;" id="fromDate" name="headerField" type="text" readonly="readonly" tabindex="109"/>
			    		<img name="hrefFromDate" id="hrefFromDate" style="margin-top: 1px;" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From" onClick="scwShow($('fromDate'),this, null);"/>
					</div>
				</td>
			</tr>
			<tr>
				<td></td>
				<td>
					<input id="issueDate" value="issue" title="Issue Date" type="radio" name="dateBasisRG" style="margin: 0 5px 0 5px; float: left;" tabindex="104">
					<label for="issueDate">Issue Date</label>
				</td>
				<td>
					<input id="expiryDate" value="expiry" title="Expiry Date" type="radio" name="dateBasisRG" style="margin: 0 5px 0 5px; float: left;" tabindex="105">
					<label for="expiryDate">Expiry Date</label>
				</td>
				<td></td>
				<td>
					<div id="toDateDiv" style="float:left; border: solid 1px gray; width: 128px; height: 21px; margin-right:3px;">
			    		<input style="height: 13px; width: 104px; border: none; float: left;" id="toDate" name="headerField" type="text" readonly="readonly" tabindex="110"/>
			    		<img name="hrefToDate" id="hrefToDate" style="margin-top: 1px;" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From" onClick="scwShow($('toDate'),this, null);"/>
					</div>
				</td>
			</tr>
		</table>
		
		<table style="float: left;">
			<tr>
				<td class="rightAligned" style="padding-left: 35px;">Plate Ending</td>
				<td colspan="2">
					<select id="plateEnding" name="plateEnding" style="width: 90px;" tabindex="111">
						<option value="0">0</option>
						<option value="1">1</option>
						<option value="2">2</option>
						<option value="3">3</option>
						<option value="4">4</option>
						<option value="5">5</option>
						<option value="6">6</option>
						<option value="7">7</option>
						<option value="8">8</option>
						<option value="9">9</option>
						<option value=""></option>
					</select>
				</td>
			</tr>
			<tr>
				<td style="padding-top: 20px;">
					<input id="direct" value="direct" title="Direct" type="radio" name="reinsuranceRG" style="margin: 0 5px 0 35px; float: left;" tabindex="112">
					<label for="direct">Direct</label>
				</td>
				<td style="padding-top: 20px;">
					<input id="assumed" value="assumed" title="Assumed" type="radio" name="reinsuranceRG" style="margin: 0 5px 0 5px; float: left;" tabindex="113">
					<label for="assumed">Assumed</label>
				</td>
				<td style="padding-top: 20px;">
					<input id="directAssumed" value="directAssumed" title="Direct and Assumed" type="radio" name="reinsuranceRG" style="margin: 0 5px 0 20px; float: left;" checked="checked" tabindex="114">
					<label for="directAssumed">Direct and Assumed</label>
				</td>
			</tr>
		</table>
	</div>
	
	<div id="ctplPolicyDiv" class="sectionDiv" style="height: 450px; margin-bottom: 25px;">
		<div id="ctplPolicyTGDiv" name="ctplPolicyTGDiv" style="height: 342px; margin: 12px 0 20px 11px;"></div>
		
		<label style="margin: 5px 0 0 40px;">Reinsurer</label>
		<input id="reinsurer" name="reinsurer" type="text" style="width: 775px; margin-left: 4px;" readonly="readonly" tabindex="201"/>
		
		<div id="buttonsDiv" align="center" style="margin-top: 12px">
			<input id="btnPrint" type="button" class="button" value="Print Report" style="width: 120px;" tabindex="202">
		</div>
	</div>
	
</div>

<script type="text/javascript">
	var sysdate = dateFormat(new Date(), "mm-dd-yyyy");
	var credBranchValue; //added by carloR SR 5328 07.12.2016
	
	try{
		ctplPolicyModel = {
			url: contextPath+"/",
			options: {
	          	height: '326px',
	          	width: '900px',
	          	onCellFocus: function(element, value, x, y, id){
	          		$("reinsurer").value = unescapeHTML2(ctplPolicyTG.geniisysRows[y].reinsurer);
	          		$("credBranch").value = ctplPolicyTG.geniisysRows[y].credBranch;
	          		ctplPolicyTG.keys.removeFocus(ctplPolicyTG.keys._nCurrentFocus, true);
	          		ctplPolicyTG.keys.releaseKeys();
	            },
	            onRemoveRowFocus: function(){
	            	$("reinsurer").value = "";
	            	$("credBranch").value = "";
	            	ctplPolicyTG.keys.removeFocus(ctplPolicyTG.keys._nCurrentFocus, true);
	          		ctplPolicyTG.keys.releaseKeys();
	            },
	            onSort: function(){
	            	ctplPolicyTG.onRemoveRowFocus();
	            },
	            toolbar: {
	            	elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
	            	onRefresh: function(){
	            		ctplPolicyTG.onRemoveRowFocus();
	            	},
	            	onFilter: function(){
	            		ctplPolicyTG.onRemoveRowFocus();
	            	}
	            }
			},
			columnModel:[
						{   id: 'recordStatus',
						    width: '0px',
						    visible: false,
						    editor: 'checkbox'
						},
						{	id: 'divCtrId',
							width: '0px',
							visible: false
						},
						{	id: 'policyNo',
							title: 'Policy No.',
							width: '160px',
							filterOption: true
						},
						{	id: 'assdName',
							title: 'Assured',
							width: '200px',
							filterOption: true
						},
						{	id: 'inceptDate',
							title: 'Incept Date',
							align: 'center',
							width: '85px',
							filterOption: true,
							filterOptionType: 'formattedDate'
						},
						{	id: 'dspPlateNo',
							title: 'Plate No.',
							width: '85px',
							filterOption: true
						},
						{	id: 'dspSerialNo',
							title: 'Serial No.',
							width: '120px',
							filterOption: true
						},
						{	id: 'dspCoMake',
							title: 'Company / Make',
							width: '120px',
							filterOption: true
						},
						{	id: 'ctplPremium',
							title: 'CTPL Premium',
							width: '110px',
							align: 'right',
							geniisysClass: 'money',
							filterOption: true,
							filterOptionType: 'number'
						}
						],
			rows: []
		};
		ctplPolicyTG = new MyTableGrid(ctplPolicyModel);
		ctplPolicyTG.pager = [];
		ctplPolicyTG.render('ctplPolicyTGDiv');
		ctplPolicyTG.afterRender = function(){
			ctplPolicyTG.onRemoveRowFocus();
		};
	}catch(e){
		showMessageBox("Error in CTPL Policy Listing Table Grid: " + e, imgMessage.ERROR);
	}

	function newFormInstance(){
		initializeAll();
		makeInputFieldUpperCase();
		setModuleId("GIPIS206");
		setDocumentTitle("CTPL Motor Policy Listing");
	}
	
	function resetForm(){
		$("credBranch").value = "";
		$("plateEnding").value = "";
		
		$("inceptDate").checked = true;
		$("asOf").checked = true;
		$("directAssumed").checked = true;
		
		enableInputField("credBranch");
		enableToolbarButton("btnToolbarExecuteQuery");
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarPrint");
		disableButton("btnPrint");
		
		enableAsOf();
		disableFromTo();
		
		$("plateEnding").enable();
		$("credBranch").focus();
		
		$$("input[type='radio']").each(function(i){
			i.enable();
		});
	}
	
	function enableAsOf(){
		$("asOfDate").value = sysdate;
		$("asOfDate").enable();
		$("asOfDate").addClassName("required");
		$("asOfDateDiv").setStyle("background-color: #FFFACD");
		enableDate("hrefAsOfDate");
	}
	
	function enableFromTo(){
		$("fromDate").enable();
		$("toDate").enable();
		$("fromDate").addClassName("required");
		$("toDate").addClassName("required");
		$("fromDateDiv").setStyle("background-color: #FFFACD");
		$("toDateDiv").setStyle("background-color: #FFFACD");
		enableDate("hrefFromDate");
		enableDate("hrefToDate");
	}
	
	function disableAsOf(){
		$("asOfDate").value = "";
		$("asOfDate").disable();
		$("asOfDate").removeClassName("required");
		$("asOfDateDiv").removeClassName("required");
		$("asOfDateDiv").setStyle("background-color: #F0F0F0");
		disableDate("hrefAsOfDate");
	}
	
	function disableFromTo(){
		$("fromDate").value = "";
		$("toDate").value = "";
		$("fromDate").disable();
		$("toDate").disable();
		$("fromDate").removeClassName("required");
		$("toDate").removeClassName("required");
		$("fromDateDiv").removeClassName("required");
		$("toDateDiv").removeClassName("required");
		$("fromDateDiv").setStyle("background-color: #F0F0F0");
		$("toDateDiv").setStyle("background-color: #F0F0F0");
		disableDate("hrefFromDate");
		disableDate("hrefToDate");
	}
	
	function disableForm(){
		$$("input[name='headerField'], input[type='radio']").each(function(i){
			i.disable();
		});
		
		disableToolbarButton("btnToolbarExecuteQuery");
		enableToolbarButton("btnToolbarEnterQuery");
		disableInputField("credBranch");
		
		$("asOfDate").removeClassName("required");
		$("asOfDateDiv").removeClassName("required");
		
		$("asOfDate").disable();
		$("asOfDateDiv").setStyle("background-color: #F0F0F0");
		disableDate("hrefAsOfDate");
		
		$("fromDate").removeClassName("required");
		$("toDate").removeClassName("required");
		$("fromDateDiv").removeClassName("required");
		$("toDateDiv").removeClassName("required");
		
		$("fromDate").disable();
		$("toDate").disable();
		$("fromDateDiv").setStyle("background-color: #F0F0F0");
		$("toDateDiv").setStyle("background-color: #F0F0F0");
		disableDate("hrefFromDate");
		disableDate("hrefToDate");
		
		$("plateEnding").disable();
	}
	
	function executeQuery(){
		var dateBasis = "";
		var dateRange = $("asOf").checked ? "asOf" : "fromDate";
		var reinsurance = $("direct").checked ? "direct" : $("assumed").checked ? "assumed" : "directAssumed";
		credBranchValue = $("credBranch").value; //added by carloR SR 5328 07.12.2016, to get the credBranch value before it reset
		
		$$("input[name='dateBasisRG']").each(function(i){
			if(i.checked){
				dateBasis = i.value;
			}
		});
		
		ctplPolicyTG.url = contextPath +"/GIPIVehicleController?action=showCTPLPolicyListing&refresh=1&credBranch="+$F("credBranch")+
							"&asOfDate="+$F("asOfDate")+"&fromDate="+$F("fromDate")+"&toDate="+$F("toDate")+"&plateEnding="+$F("plateEnding")+
							"&dateBasis="+dateBasis+"&dateRange="+dateRange+"&reinsurance="+reinsurance+"&moduleId=GIPIS206";
		ctplPolicyTG._refreshList();
		
		enableToolbarButton("btnToolbarPrint");
		enableButton("btnPrint");
		disableForm();
	}
	
	function printReport(){
		//comment by Alejandro Burgos Jr. 02.09.2016
		/*
		var fileType = $("rdoPdf").checked ? "PDF" : "XLS";
		var plate = $F("plateEnding") != "" ? "1" : "2";
		var range = $("asOf").checked ? "1" : "2";
		var reinsurance = $("direct").checked ? "1" : $("assumed").checked ? "2" : "3";
		var dateBasis = $("inceptDate").checked ? "1" : $("issueDate").checked ? "2" : $("effectivityDate").checked ? "3" : "4";
		
		var content = contextPath+"/PolicyInquiryPrintController?action=printGIPIR206&moduleId=GIPIS206&reportId=GIPIR206"+
						"&asOfDate="+$F("asOfDate")+"&fromDate="+$F("fromDate")+"&toDate="+$F("toDate")+
						"&plateEnding="+$F("plateEnding")+"&plate="+plate+"&range="+range+"&reinsurance="+reinsurance+
						"&dateBasis="+dateBasis+"&fileType="+fileType;
		
		printGenericReport(content, "CTPL MOTOR POLICY LISTING");
		*/
		//end comment
		
		//added by Alejandro Burgos Jr. 02.09.2016
		try {
			var plate = $F("plateEnding") != "" ? "1" : "2";
			var range = $("asOf").checked ? "1" : "2";
			var reinsurance = $("direct").checked ? "1" : $("assumed").checked ? "2" : "3";
			var dateBasis = $("inceptDate").checked ? "1" : $("issueDate").checked ? "2" : $("effectivityDate").checked ? "3" : "4";
			var content = contextPath+"/PolicyInquiryPrintController?action=printGIPIR206&moduleId=GIPIS206&reportId=GIPIR206"+
						"&asOfDate="+$F("asOfDate")+"&fromDate="+$F("fromDate")+"&toDate="+$F("toDate")+
						"&plateEnding="+$F("plateEnding")+"&plate="+plate+"&range="+range+"&reinsurance="+reinsurance+
						"&dateBasis="+dateBasis+"&credBranch="+credBranchValue; //replace $F("credBranch") with credBranchValue by CarloR SR 5328 07.12.2016
					
			if("screen" == $F("selDestination")){
				showPdfReport(content, "CTPL Motor Policy Listing");
			}else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					parameters : {noOfCopies : $F("txtNoOfCopies"),
								  printerName : $F("selPrinter")
								 },
					evalScripts: true,
					asynchronous: true,
					onCreate: showNotice("Processing, please wait..."),				
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							showMessageBox("Printing complete.", "S");
						}
					}
				});
				
			}else if("file" == $F("selDestination")){
			
			
			var fileType = "PDF";
		
			if($("rdoPdf").checked)
				fileType = "PDF";
			else if ($("rdoCsv").checked)
				fileType = "CSV"; 
			
			
			new Ajax.Request(content, {
				method: "POST",
				parameters : {destination : "file",
							  fileType    : fileType},
				evalScripts: true,
				asynchronous: true,
				onCreate: showNotice("Generating report, please wait..."),
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						if (fileType == "CSV"){ 
							copyFileToLocal(response, "csv");
							deleteCSVFileFromServer(response.responseText);
						} else 
							copyFileToLocal(response);
					}
				}
			});
			
			}else if("local" == $F("selDestination")){
				new Ajax.Request(content, {
					parameters : {destination : "local"},
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							var message = printToLocalPrinter(response.responseText);
							if(message != "SUCCESS"){
								showMessageBox(message, imgMessage.ERROR);
							}
						}
					}
				});
			}
			
		} catch (e){
			showErrorMessage("GIACS108 printReport", e);
		}//end here
	}

	$("asOf").observe("click", function(){
		disableFromTo();
		enableAsOf();
	});
	
	$("from").observe("click", function(){
		disableAsOf();
		enableFromTo();
	});
	
	$("fromDate").observe("focus", function(){
		if(($F("fromDate") != "" && $F("toDate") != "") && (Date.parse($F("fromDate")) > Date.parse($F("toDate")))){
			showMessageBox("From Date should not be later than To Date.", "I");
			$("fromDate").value = "";
			$("fromDate").focus();
		}
	});
	
	$("toDate").observe("focus", function(){
		if(($F("fromDate") != "" && $F("toDate") != "") && (Date.parse($F("fromDate")) > Date.parse($F("toDate")))){
			showMessageBox("From Date should not be later than To Date.", "I");
			$("toDate").value = "";
			$("toDate").focus();
		}
	});
	
	$("btnPrint").observe("click", function(){
		showGenericPrintDialog("Print CTPL Motor Policy Listing", printReport, null, "true");
		$("csvOptionDiv").show(); //added by Alejandro Burgos 02.09.2016
	});
	
	$("btnToolbarEnterQuery").observe("click", function(){
		ctplPolicyTG.url = contextPath +"/GIPIVehicleController?action=showCTPLPolicyListing&refresh=1";
		ctplPolicyTG._refreshList();
		resetForm();
	});
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		if(checkAllRequiredFieldsInDiv("ctplPolicyListingHeaderDiv")){
			executeQuery();
		}
	});
	
	$("btnToolbarPrint").observe("click", function(){
		showGenericPrintDialog("Print CTPL Motor Policy Listing", printReport, null, "true");
		$("csvOptionDiv").show(); //added by Alejandro Burgos 02.09.2016
	});
	
	$("btnToolbarExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	
	newFormInstance();
	resetForm();
</script>