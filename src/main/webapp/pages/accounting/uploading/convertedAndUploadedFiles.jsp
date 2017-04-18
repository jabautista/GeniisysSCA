<!-- Dren Niebres 10.03.2016 SR-4572 : JSP for Module GIACS605 to call reports GIACR601, GIACR601A, GIACR602, GIACR602A -->
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="convertedAndUploadedFilesDiv">
	<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
		<label>Converted And Uploaded Files</label>
		<span class="refreshers" style="margin-top: 0;">
 			<label id="btnReloadForm" name="gro" style="margin-left: 5px;">Reload Form</label>
		</span>
	</div>
</div>
	<div class="sectionDiv" style="padding-bottom: 20px;" >
		<div style="margin: 0 auto; width: 500px;">
			<div style="border: 1px solid #E0E0E0; margin-top: 30px; padding: 15px 0;">
				<table align="center">
					<tr>
						<td><input type="checkbox" id="chkConverted" style="margin-left: 10px; margin-right: 10px;" tabindex="101"/></td>
						<td><label for="chkConverted" style="margin-left: 10px; margin-right: 30px;">Converted</label></td>
						<td><input type="checkbox" id="chkConvertedUnuploaded" style="margin-left: 10px; margin-right: 10px;" tabindex="102"/></td>												
						<td><label for="chkConvertedUnuploaded" style="margin-left: 10px; margin-right: 30px;">Converted/Unuploaded</label></td>
						<td><input type="checkbox" id="chkUploaded" style="margin-left: 10px; margin-right: 10px;" tabindex="103"/></td>												
						<td><label for="chkUploaded" style="margin-left: 10px; margin-right: 10px;">Uploaded</label></td>
					</tr>
				</table>
			</div>
			<div style="border: 1px solid #E0E0E0; margin-top: 2px; padding: 15px 0;">
				<table align="center">
					<tr>
						<td>
							<div id="divFromDateL">	
								<label for="txtFromDate" style="float: right;">From Date :</label>
							</div>
						</td>
						<td style="padding-left: 5px;">
							<div id="divFromDateT" style="float: left; width: 140px; height: 20px; margin: 0;" class="withIconDiv required">
								<input type="text" id="txtFromDate" class="withIcon required" readonly="readonly" style="width: 116px;" tabindex="201"/>
								<img id="imgFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="" style="margin : 1px 1px 0 0; cursor: pointer"/>
							</div>
						</td>
						<td>
							<div id="divToDateL">	
								<label for="txtToDate" style="float: right; margin-left: 20px;">To Date :</label>
							</div>
						</td>
						<td style="padding-left: 5px;">
							<div id="divToDateT" style="float: left; width: 140px; height: 20px; margin: 0;" class="withIconDiv required">
								<input type="text" id="txtToDate" class="withIcon required" readonly="readonly" style="width: 116px;" tabindex="202"/>
								<img id="imgToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="" style="margin : 1px 1px 0 0; cursor: pointer"/>
							</div>
						</td>
					</tr>								
					<tr>															
						<td>
							<div id="divAsOfDateL" style="display: none;">					
								<label for="txtAsOfDate" style="float: right;">As of Date :</label></td>
							</div>	
						<td style="padding-left: 5px;">
							<div id="divAsOfDateT" style="float: left; width: 140px; height: 20px; margin: 0; display: none;" class="withIconDiv required">
								<input type="text" id="txtAsOfDate" class="withIcon required" readonly="readonly" style="width: 116px;" tabindex="203"/>
								<img id="imgAsOfDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="" style="margin : 1px 1px 0 0; cursor: pointer"/>
							</div>
						</td>							
					</tr>					
						
					<tr>
						<td><label for="txtSource" style="float: left;">Source</label>
							<label style="float: right;">:</label></td>
						<td style="padding-left: 5px;" colspan="3">
							<span class="lovSpan" style="width: 70px; margin-bottom: 0;">
								<input type="text" id="txtSource" style="width: 45px; float: left;" class="withIcon allCaps"  maxlength="4"  tabindex="204"/>  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSource" alt="Go" style="float: right;" />
							</span>
							<input type="text" id="txtSourceName" readonly="readonly" style="margin: 0; height: 14px; width: 286px; float: left; margin-left: 2px;" tabindex="205"/>
						</td>
					</tr>
					<tr>
						<td><label for="txtTransaction" style="float: left;">Transaction</label>
							<label style="float: right;">:</label></td>
						<td style="padding-left: 5px;" colspan="3">
							<span class="lovSpan" style="width: 70px; margin-bottom: 0;">
								<input type="text" id="txtTransaction" style="width: 45px; float: left;" class="withIcon allCaps"  maxlength="1"  tabindex="206"/>  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgTransaction" alt="Go" style="float: right;"/>
							</span>
							<input type="text" id="txtTransactionName" readonly="readonly" style="margin: 0; height: 14px; width: 286px; float: left; margin-left: 2px;" tabindex="207"/>
						</td>
					</tr>
					<tr>
						<td><label for="txtFilename" style="float: left;">Filename</label>
							<label style="float: right;">:</label></td>
						<td style="padding-left: 5px;" colspan="3">
							<span class="lovSpan" style="width: 366px; margin-bottom: 0;">
								<input type="text" id="txtFilename" style="width: 340px; float: left;" class="withIcon allCaps"  maxlength="15"  tabindex="208"/>  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgFilename" alt="Go" style="float: right;" />
							</span>						
						</td>
					</tr>								
					<tr>
						<td></td>
						<td style="padding-left: 5px;" colspan="3">
							<input value="GIACR602" title="perFilename" type="radio" id="rdoPerFilename" name="GIACR602Type" tabindex="209" style="margin: 2px 5px 4px 5px; float: left;" checked="checked"><label for="rdoPerFilename" style="margin: 2px 0 4px 0">Per Filename</label>
						    <input value="GIACR602A" title="perUploadDate" type="radio" id="rdoPerUploadDate" name="GIACR602Type" tabindex="300" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="rdoPerUploadDate" style="margin: 2px 0 4px 0">Per Upload Date</label>
						</td>
					</tr>	
						
				</table>
			</div>
			<div id="printDiv" style="border: 1px solid #E0E0E0; margin-top: 2px; padding: 15px 0;">
				<table align="center">
					<tr>
						<td class="rightAligned">Destination</td>
						<td class="leftAligned">
							<select id="selDestination" style="width: 200px;" tabindex="301">
								<option value="screen">Screen</option>
								<option value="printer">Printer</option>
								<option value="file">File</option>
								<option value="local">Local Printer</option>
							</select>
						</td>
					</tr>
					<tr>
						<td></td>
						<td>
							<input value="PDF" title="PDF" type="radio" id="rdoPdf" name="fileType" tabindex="302" style="margin: 2px 5px 4px 5px; float: left;" checked="checked" disabled="disabled"><label for="rdoPdf" style="margin: 2px 0 4px 0">PDF</label>
							<input value="CSV" title="CSV" type="radio" id="rdoCsv" name="fileType" tabindex="303" style="margin: 2px 5px 4px 5px; float: left;" disabled="disabled"><label for="rdoCsv" style="margin: 2px 0 4px 0">CSV</label>														
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Printer</td>
						<td class="leftAligned">
							<select id="selPrinter" style="width: 200px;" class="required" tabindex="304">
								<option></option>
								<c:forEach var="p" items="${printers}">
									<option value="${p.name}">${p.name}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">No. of Copies</td>
						<td class="leftAligned">
							<input type="text" id="txtNoOfCopies" tabindex="305" style="float: left; text-align: right; width: 175px;" class="required integerNoNegativeUnformattedNoComma">
							<div style="float: left; width: 15px;">
								<img id="imgSpinUp" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; cursor: pointer;">
								<img id="imgSpinUpDisabled" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; display: none;">
								<img id="imgSpinDown" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; cursor: pointer;">
								<img id="imgSpinDownDisabled" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; display: none;">
							</div>					
						</td>
					</tr>
				</table>
			</div>
			<div>
				<input type="button" class="button" value="Print" tabindex="401" id="btnPrint" style="width: 120px; margin: 15px auto;"/>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">	

	initializeAll();
	initializeAccordion();
	validate = 0;		
	var objGIACS605 = {};
	var txtTrans = document.getElementById('txtTransaction');
	
	function initGIACS605(){
		setModuleId("GIACS605");
		setDocumentTitle("Converted and Uploaded Files");
		$("chkConverted").checked = true;
		$("chkConvertedUnuploaded").checked = false;
		$("chkUploaded").checked = false;
		$("txtSourceName").value = "ALL SOURCES";
		$("txtTransactionName").value = "ALL TRANSACTIONS";
		$("txtFilename").value = "ALL FILES";		
	}	
	initGIACS605();			
	
	function resetForm() {
		$("chkConverted").checked = true;
		$("chkConvertedUnuploaded").checked = false;
		$("chkUploaded").checked = false;
		$("txtFromDate").clear();
		$("txtToDate").clear();
		$("txtAsOfDate").clear();
		$("txtSource").clear();
		$("txtSourceName").value = "ALL SOURCES";
		$("txtTransaction").clear();
		$("txtTransactionName").value = "ALL TRANSACTIONS";
		$("txtFilename").value = "ALL FILES";			
		$("selDestination").selectedIndex = 0;
		toggleRequiredFields("screen");
	}
	
	$("btnReloadForm").observe("click", resetForm);
	observeReloadForm("btnReloadForm", showGIACS605);
			
	$("imgSource").observe("click",function(){
		if(validate == 0){
			showGIACS605SourceLOV("%");
		} else {
			validate = 0;
		}
	});		
	
	function showGIACS605SourceLOV(x){
		try{		
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					  action : "getGIACS605SourceLOV",
					  search : x,
						page : 1
				},
				title: "List of Sources",
				width: 470,
				height: 400,
				columnModel: [
		 			{
						id : 'sourceCd',
						title: 'Source Cd',
						width : '100px',
						align: 'left',
						titleAlign : 'left'						
					},
					{
						id : 'sourceName',
						title: 'Source Name',
					    width: '335px',
					    align: 'left'
					}
				],
				filterText: nvl(escapeHTML2(x), "%"), 
				autoSelectOneRecord : true,
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtSource").value = unescapeHTML2(row.sourceCd);
						$("txtSource").setAttribute("lastValidValue", unescapeHTML2(row.sourceCd));
						objGIACS605.sourceCd = unescapeHTML2(row.sourceCd);
						$("txtSourceName").value = unescapeHTML2(row.sourceName);
						$("txtSourceName").setAttribute("lastValidValue", unescapeHTML2(row.sourceName));
						objGIACS605.sourceName = unescapeHTML2(row.sourceName); 								
						validate = 0;
					}
				},
				onCancel: function(){
					$("txtSource").focus();
					$("txtSource").value = $("txtSource").getAttribute("lastValidValue");
					validate = 0;
		  		},
		  		onUndefinedRow: function(){
		  			$("txtSource").value = $("txtSource").getAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtSource");
					validate = 0;
		  		}
			});
		}catch(e){
			showErrorMessage("showGIACS605SourceLOV",e);
		}
	} 	
	
	$("txtSource").observe("change", function(){
		if($("txtSource").value == ""){
			objGIACS605.sourceCd = "";
			$("txtSource").setAttribute("lastValidValue", "");
			validate = 0;
			$("txtSourceName").value = "ALL SOURCES";
		} else {
			showGIACS605SourceLOV($("txtSource").value+"%");
		}
	});		 

	$("imgTransaction").observe("click",function(){
		if ($("chkConvertedUnuploaded").checked == true)
			null;
		else
			if(validate == 0){
				showGIACS605TransactionLOV("%");
			} else {
				validate = 0;
			}
	});		

	function showGIACS605TransactionLOV(x){
		try{		
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					  action : "getGIACS605TransactionLOV",
					  search : x,
						page : 1
				},
				title: "List of Transactions",
				width: 480,
				height: 400,
				columnModel: [
		 			{
						id : 'rvLowValue',
						title: 'Type',
						width : '120px',
						align: 'left',
						titleAlign : 'left'						
					},
					{
						id : 'rvMeaning',
						title: 'Transaction',
					    width: '345px',
					    align: 'left'
					}
				],
				filterText: nvl(escapeHTML2(x), "%"), 
				autoSelectOneRecord : true,
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtTransaction").value = unescapeHTML2(row.rvLowValue);
						$("txtTransaction").setAttribute("lastValidValue", unescapeHTML2(row.rvLowValue));
						objGIACS605.rvLowValue = unescapeHTML2(row.rvLowValue);
						$("txtTransactionName").value = unescapeHTML2(row.rvMeaning);
						$("txtTransactionName").setAttribute("lastValidValue", unescapeHTML2(row.rvMeaning));
						objGIACS605.rvMeaning = unescapeHTML2(row.rvMeaning); 								
						validate = 0;
						
						if ($("chkUploaded").checked == true && $("txtTransaction").value == 5 && $("chkConverted").checked == false){
							document.getElementById('rdoPerUploadDate').removeAttribute('disabled');
						} else {
							document.getElementById('rdoPerUploadDate').setAttribute('disabled', 'disabled');
							$("rdoPerFilename").checked = true;
							document.getElementById('txtFilename').removeAttribute('disabled');
						}
					}
				},
				onCancel: function(){
					$("txtTransaction").focus();
					$("txtTransaction").value = $("txtTransaction").getAttribute("lastValidValue");
					validate = 0;
		  		},
		  		onUndefinedRow: function(){
		  			$("txtTransaction").value = $("txtTransaction").getAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtTransaction");
					validate = 0;
		  		}
			});
		}catch(e){
			showErrorMessage("showGIACS605TransactionLOV",e);
		}
	} 	
	
	$("txtTransaction").observe("change", function(){
		if($("txtTransaction").value == ""){
			$("rdoPerFilename").checked == true;
			objGIACS605.rvLowValue = "";
			$("txtTransaction").setAttribute("lastValidValue", "");
			validate = 0;
			$("txtTransactionName").value = "ALL TRANSACTIONS";		
			document.getElementById('rdoPerUploadDate').setAttribute('disabled', 'disabled');
			$("rdoPerFilename").checked = true;
			document.getElementById('txtFilename').removeAttribute('disabled');			
		} else {
			showGIACS605TransactionLOV($("txtTransaction").value+"%");
		}
	});		 		

	$("imgFilename").observe("click",function(){
		if ($("rdoPerUploadDate").checked == true) {
			null;					
		}else if ($("txtTransaction").value == ""){ 
			customShowMessageBox("Please enter a valid transaction type.", imgMessage.INFO, "txtTransaction");
		}else if(validate == 0){
			showGIACS605FilenameLOV("%"); 
		} else {
			validate = 0;
		}
	});		
	
	function showGIACS605FilenameLOV(x){
		try{		
			LOV.show({
				controller 			  : "AccountingLOVController",
				urlParameters 		  : {
					  action  		  : "getGIACS605FilenameLOV",
					  search  		  : x,
					  sourceCd 		  : $("txtSource").value,
					  transactionType : $("txtTransaction").value,
					  page  		  : 1
				},
				title: "List of Filenames",
				width: 470,
				height: 400,
				columnModel: [
		 			{
						id : 'fileName',
						title: 'File Name',
						width : '400px',
						align: 'left',
						titleAlign : 'left'						
					}
				],
				filterText: nvl(escapeHTML2(x), "%"), 
				autoSelectOneRecord : true,
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtFilename").value = unescapeHTML2(row.fileName);
						$("txtFilename").setAttribute("lastValidValue", unescapeHTML2(row.fileName));
						objGIACS605.fileName = unescapeHTML2(row.fileName);						
					}
				},
				onCancel: function(){
					$("txtFilename").focus();
					if ($("txtFilename").value = "ALL FILES"){
					   ($("txtFilename").value = "ALL FILES");
					} else {
						$("txtFilename").value = $("txtFilename").getAttribute("lastValidValue");	
					}					
					validate = 0;
		  		},
		  		onUndefinedRow: function(){
		  			$("txtFilename").value = $("txtFilename").getAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtFilename");
					validate = 0;
					($("txtFilename").value = "ALL FILES");
		  		}
			});
		}catch(e){
			showErrorMessage("showGIACS605FilenameLOV",e);
		}
	} 	
	
	$("txtFilename").observe("change", function(){
		if ($("txtTransaction").value == ""){ 
			customShowMessageBox("Please enter a valid transaction type.", imgMessage.INFO, "txtTransaction");
			$("txtFilename").value = "ALL FILES";
		} else {			
			if($("txtFilename").value == ""){
				objGIACS605.fileName = "";
				$("txtFilename").setAttribute("lastValidValue", "");
				validate = 0;
				$("txtFilename").value = "ALL FILES";
			} else {
				showGIACS605FilenameLOV($("txtFilename").value+"%");
			}
		}
	});

	$("chkConverted").observe("click", function(){
		if(this.checked)
			document.getElementById('txtFilename').removeAttribute('disabled');
			$("chkConvertedUnuploaded").checked = false;
			$("divAsOfDateL").hide();
			$("divAsOfDateT").hide();
			$("divFromDateL").show();
			$("divFromDateT").show();	
			$("divToDateL").show();
			$("divToDateT").show();		
			txtTrans.removeAttribute('disabled');		
			if ($("chkConverted").checked == false && $("chkUploaded").checked == true && $("txtTransaction").value == 5){
				document.getElementById('rdoPerUploadDate').removeAttribute('disabled');
			} else if ($("chkUploaded").checked == true){
				$("rdoPerFilename").checked = true;
				document.getElementById('rdoPerUploadDate').setAttribute('disabled', 'disabled');
			} else {
				document.getElementById('rdoPerUploadDate').setAttribute('disabled', 'disabled');
			}
	});
	
	$("chkConvertedUnuploaded").observe("click", function(){
		if(this.checked)
			document.getElementById('txtFilename').style.color = 'black';
			$("chkConverted").checked = false;
			$("chkUploaded").checked = false;
			$("divAsOfDateL").show();
			$("divAsOfDateT").show();	
			$("divFromDateL").hide();
			$("divFromDateT").hide();	
			$("divToDateL").hide();
			$("divToDateT").hide();		
			showGIACS605TransactionLOV("5");	
			txtTrans.setAttribute('disabled', 'disabled');
	});

	$("chkUploaded").observe("click", function(){
		if(this.checked)
			$("chkConvertedUnuploaded").checked = false;
			$("divAsOfDateL").hide();
			$("divAsOfDateT").hide();
			$("divFromDateL").show();
			$("divFromDateT").show();	
			$("divToDateL").show();
			$("divToDateT").show();	
			txtTrans.removeAttribute('disabled');			
			if ($("chkConverted").checked == false && $("txtTransaction").value == 5){
				document.getElementById('rdoPerUploadDate').removeAttribute('disabled');
			}
			if ($("rdoPerFilename").checked == true){
				document.getElementById('txtFilename').style.color = 'black';
			}
	});	
	
	$("rdoPerUploadDate").observe("click", function(){
		if(this.checked)
			document.getElementById('imgFilename').setAttribute('disabled', 'disabled');
			document.getElementById('txtFilename').setAttribute('disabled', 'disabled');
	});	
	
	$("rdoPerFilename").observe("click", function(){
		if(this.checked)
			document.getElementById('txtFilename').removeAttribute('disabled');
	});				
	
	$("imgFromDate").observe("click", function(){
		scwShow($("txtFromDate"), this, null);
	});
	
	$("imgToDate").observe("click", function(){
		scwShow($("txtToDate"), this, null);
	});
	
	$("imgAsOfDate").observe("click", function(){
		scwShow($("txtAsOfDate"), this, null);
	});	
	
	$("txtFromDate").observe("focus", function(){
		if ($("imgFromDate").disabled == true) return;		
			var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g,"/")) :"";
			var sysdate = new Date();
			var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g,"/")) :"";				
		if (fromDate > sysdate && fromDate != ""){
			customShowMessageBox("Date should not be greater than the current date.", "I", "txtFromDate");
			$("txtFromDate").clear();
			return false;
		}		
		if (toDate < fromDate && toDate != ""){
			customShowMessageBox("From Date should be earlier than To Date.", "I", "txtFromDate");
			$("txtFromDate").clear();
			return false;
		}
	});
 	
 	$("txtToDate").observe("focus", function(){
		if ($("imgToDate").disabled == true) return;		
			var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g,"/")) :"";
			var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g,"/")) :"";
			var sysdate = new Date();		
		if (toDate > sysdate && toDate != ""){
			customShowMessageBox("Date should not be greater than the current date.", "I", "txtToDate");
			$("txtToDate").clear();
			return false;
		}		
		if (toDate < fromDate && toDate != ""){
			customShowMessageBox("From Date should be earlier than To Date.", "I", "txtToDate");
			$("txtToDate").clear();
			return false;
		}
	});
	
	function toggleRequiredFields(dest){
		if(dest == "printer"){			
			$("selPrinter").disabled = false;
			$("txtNoOfCopies").disabled = false;
			$("selPrinter").addClassName("required");
			$("txtNoOfCopies").addClassName("required");
			$("imgSpinUp").show();
			$("imgSpinDown").show();
			$("imgSpinUpDisabled").hide();
			$("imgSpinDownDisabled").hide();
			$("txtNoOfCopies").value = 1;
				$("rdoPdf").disable();
				$("rdoCsv").disable();				
		} else {
			if(dest == "file"){
				$("rdoPdf").enable();
				$("rdoCsv").enable();
			} else {
				$("rdoPdf").disable();
				$("rdoCsv").disable();
			}				
			
			$("selPrinter").value = "";
			$("txtNoOfCopies").value = "";
			$("selPrinter").disabled = true;
			$("txtNoOfCopies").disabled = true;
			$("selPrinter").removeClassName("required");
			$("txtNoOfCopies").removeClassName("required");
			$("imgSpinUp").hide();
			$("imgSpinDown").hide();
			$("imgSpinUpDisabled").show();
			$("imgSpinDownDisabled").show();			
		}
	}
	
	$("imgSpinUp").observe("click", function(){
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		$("txtNoOfCopies").value = no + 1;
	});
	
	$("imgSpinDown").observe("click", function(){
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		if(no > 1){
			$("txtNoOfCopies").value = no - 1;
		}
	});
	
	$("imgSpinUp").observe("mouseover", function(){
		$("imgSpinUp").src = contextPath + "/images/misc/spinupfocus.gif";
	});
	
	$("imgSpinDown").observe("mouseover", function(){
		$("imgSpinDown").src = contextPath + "/images/misc/spindownfocus.gif";
	});
	
	$("imgSpinUp").observe("mouseout", function(){
		$("imgSpinUp").src = contextPath + "/images/misc/spinup.gif";
	});
	
	$("imgSpinDown").observe("mouseout", function(){
		$("imgSpinDown").src = contextPath + "/images/misc/spindown.gif";
	});
	
	$("selDestination").observe("change", function(){
		var dest = $F("selDestination");
		toggleRequiredFields(dest);
	});	
	
	toggleRequiredFields("screen");
	
	function printReport(reportId,params){
		var txtFilename2 = "";		
		if ($("txtFilename").value == "ALL FILES") {
			txtFilename2 = "";
		} else {
			txtFilename2 = $("txtFilename").value;
		}
		
		try {
			var content = contextPath + "/UploadingReportPrintController?action=printReport"
					                  + params
					                  + "&sourceCd=" + $("txtSource").value
					                  + "&transactionCd=" + $("txtTransaction").value
					                  + "&fileName=" + txtFilename2					                  
					                  + "&noOfCopies=" + $F("txtNoOfCopies")
					                  + "&printerName=" + $F("selPrinter")
					                  + "&destination=" + $F("selDestination")
					                  + "&reportId=" + reportId;									
		
			if("screen" == $F("selDestination")){
				showPdfReport(content, "");
			}else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					parameters : {noOfCopies : $F("txtNoOfCopies")},
					onCreate: showNotice("Processing, please wait..."),				
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
						}
					}
				});
			}else if("file" == $F("selDestination")){
				var fileType = "PDF"; 
				if ($("rdoPdf").checked)
					fileType = "PDF";
				else
					fileType = "CSV";
					
				new Ajax.Request(content, {
					parameters : {destination : "file",
								  fileType : fileType}, 
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){							
							if (fileType == "CSV"){
								copyFileToLocal(response, "csv");
							} else {
								copyFileToLocal(response);
							} 						
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
			showErrorMessage("printReport", e);
		}
	}
	
	
	
	function printReportOption(){
		if("file" == $F("selDestination") && $("rdoCsv").checked){
			if ($("chkConverted").checked == true && $("chkUploaded").checked == true) {
				var params =  "&fromDate=" + $("txtFromDate").value
				+ "&toDate=" + $("txtToDate").value;	
				printGIACR601Csv(params);
				printGIACR602Csv(params);
			}else if ($("chkConverted").checked == true){		
				var params =  "&fromDate=" + $("txtFromDate").value
				+ "&toDate=" + $("txtToDate").value;
				printGIACR601Csv(params);						
			}else if ($("chkConvertedUnuploaded").checked == true){				
				var params =  "&asOfDate=" + $("txtAsOfDate").value
				printReport("GIACR601A_CSV",params);			
			}else if ($("rdoPerUploadDate").checked == true && $("chkUploaded").checked == true){				
				var params =  "&fromDate=" + $("txtFromDate").value
				+ "&toDate=" + $("txtToDate").value;
				printReport("GIACR602A_CSV",params);						
			}else if ($("chkUploaded").checked == true){				
				var params =  "&fromDate=" + $("txtFromDate").value
				+ "&toDate=" + $("txtToDate").value;
				printGIACR602Csv(params);
			}			
		}else {
			if ($("chkConverted").checked == true && $("chkUploaded").checked == true) {
				var params =  "&fromDate=" + $("txtFromDate").value
				+ "&toDate=" + $("txtToDate").value;	
				printReport("GIACR601",params);	
				printReport("GIACR602",params);		
			}else if ($("chkConverted").checked == true){		
				var params =  "&fromDate=" + $("txtFromDate").value
				+ "&toDate=" + $("txtToDate").value;						
				printReport("GIACR601",params);						
			}else if ($("chkConvertedUnuploaded").checked == true){				
				var params =  "&asOfDate=" + $("txtAsOfDate").value
				printReport("GIACR601A",params);			
			}else if ($("rdoPerUploadDate").checked == true && $("chkUploaded").checked == true){				
				var params =  "&fromDate=" + $("txtFromDate").value
				+ "&toDate=" + $("txtToDate").value;
				printReport("GIACR602A",params);						
			}else if ($("chkUploaded").checked == true){				
				var params =  "&fromDate=" + $("txtFromDate").value
				+ "&toDate=" + $("txtToDate").value;
				printReport("GIACR602",params);			
			}
		}
	}
	
	function printGIACR601Csv(params) {
		if ($("txtTransaction").value == "") {
			printReport("GIACR601_TRAN1_A_CSV",params);
			printReport("GIACR601_TRAN1_B_CSV",params);	
			printReport("GIACR601_TRAN2_CSV",params);
			printReport("GIACR601_TRAN3_CSV",params);
			printReport("GIACR601_TRAN4_CSV",params);
			printReport("GIACR601_TRAN5_CSV",params);
		} else if ($("txtTransaction").value == 1) {
			printReport("GIACR601_TRAN1_A_CSV",params);
			printReport("GIACR601_TRAN1_B_CSV",params);						
		} else if ($("txtTransaction").value == 2) {
			printReport("GIACR601_TRAN2_CSV",params);				
		} else if ($("txtTransaction").value == 3) {
			printReport("GIACR601_TRAN3_CSV",params);				
		} else if ($("txtTransaction").value == 4) {
			printReport("GIACR601_TRAN4_CSV",params);				
		} else if ($("txtTransaction").value == 5) {
			printReport("GIACR601_TRAN5_CSV",params);				
		}		
	}
	
 	function printGIACR602Csv(params) {
		if ($("txtTransaction").value == "") {
			printReport("GIACR602_TRAN1_A_CSV",params);
			printReport("GIACR602_TRAN1_B_CSV",params);	
			printReport("GIACR602_TRAN2_CSV",params);
			printReport("GIACR602_TRAN3_CSV",params);
			printReport("GIACR602_TRAN4_CSV",params);
			printReport("GIACR602_TRAN5_CSV",params);
		} else if ($("txtTransaction").value == 1) {
			printReport("GIACR602_TRAN1_A_CSV",params);
			printReport("GIACR602_TRAN1_B_CSV",params);						
		} else if ($("txtTransaction").value == 2) {
			printReport("GIACR602_TRAN2_CSV",params);				
		} else if ($("txtTransaction").value == 3) {
			printReport("GIACR602_TRAN3_CSV",params);				
		} else if ($("txtTransaction").value == 4) {
			printReport("GIACR602_TRAN4_CSV",params);				
		} else if ($("txtTransaction").value == 5) {
			printReport("GIACR602_TRAN5_CSV",params);				
		}		
	}

	$("btnPrint").observe("click", function(){
		var dest = $F("selDestination");		
		if ($("chkConverted").checked == false && $("chkConvertedUnuploaded").checked == false && $("chkUploaded").checked == false){
			customShowMessageBox("No selected type of report.");
		} else if (($("chkConverted").checked == true) && ($("chkUploaded").checked == true)) {
			if ($("txtFromDate").value == "" && $("txtToDate").value == "")
				customShowMessageBox("Please enter From Date and To Date.", "I", "txtFromDate");
			else if($("txtFromDate").value == "")
				customShowMessageBox("Please enter From Date.", "I", "txtFromDate");
			else if ($("txtToDate").value == "")
				customShowMessageBox("Please enter To Date.", "I", "txtToDate");
			else
				if(dest == "printer"){
					if(checkAllRequiredFieldsInDiv("printDiv")){
						printReportOption();
					}
				}else{
					printReportOption();
				}
		} else if (($("chkConverted").checked == true) || ($("chkUploaded").checked == true)){
			if ($("txtFromDate").value == "" && $("txtToDate").value == "")
				customShowMessageBox("Please enter From Date and To Date.", "I", "txtFromDate");
			else if($("txtFromDate").value == "")
				customShowMessageBox("Please enter From Date.", "I", "txtFromDate");
			else if ($("txtToDate").value == "")
				customShowMessageBox("Please enter To Date.", "I", "txtToDate");
			else
				if(dest == "printer"){
					if(checkAllRequiredFieldsInDiv("printDiv")){
						printReportOption();
					}
				}else{					
					printReportOption();
				}
		} else if ($("chkConvertedUnuploaded").checked == true) {
			if ($("txtAsOfDate").value == "")
				customShowMessageBox("Please enter As of Date.", "I", "txtAsOfDate");	
			else
				if(dest == "printer"){
					if(checkAllRequiredFieldsInDiv("printDiv")){
						printReportOption();
					}
				}else{
					printReportOption();
				}
		}						
	});	
</script>