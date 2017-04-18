<!-- Dren Niebres 10.03.2016 SR-4573 : JSP for Module GIACS606 to call reports GIACR606 -->
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="convertedRecordsPerStatus">
	<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
		<label>Converted Records Per Status</label>
		<span class="refreshers" style="margin-top: 0;">
 			<label id="btnReloadForm" name="gro" style="margin-left: 5px;">Reload Form</label>
		</span>
	</div>
</div>
	<div class="sectionDiv" style="padding-bottom: 20px; padding-top: 30px" >
		<div style="margin: 0 auto; width: 500px;">
			<div style="border: 1px solid #E0E0E0; margin-top: 2px; padding: 15px 0;">
				<table align="center">									
					<tr>
						<td><label for="txtSource" style="float: left;">Source</label>
							<label style="float: right;">:</label></td>
						<td style="padding-left: 5px;" colspan="3">
							<span class="lovSpan" style="width: 70px; margin-bottom: 0;">
								<input type="text" id="txtSource" style="width: 45px; float: left;" class="withIcon allCaps"  maxlength="4"  tabindex="204"/>  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSource" alt="Go" style="float: right;" />
							</span>
							<input type="text" id="txtSourceName" readonly="readonly" style="margin: 0; height: 14px; width: 286px; float: left; margin-left: 2px" tabindex="205"/>
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
							<input type="text" id="txtTransactionName" readonly="readonly" style="margin: 0; height: 14px; width: 286px; float: left; margin-left: 2px" tabindex="207"/>
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
						<td>
							<div id="divStatusL">	
								<label for="txtStatus" style="float: left;">Status</label>
								<label style="float: right;">:</label>
							</div>
						</td>
						<td style="padding-left: 5px;" colspan="3">
							<div id="divStatusT">	
								<span class="lovSpan" style="width: 70px; margin-bottom: 0;">								
									<input type="text" id="txtStatus" style="width: 45px; float: left;" class="withIcon allCaps"  maxlength="240"  tabindex="209"/>  
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgStatus" alt="Go" style="float: right;"/>
								</span>
								<input type="text" id="txtStatusName" readonly="readonly" style="margin: 0; height: 14px; width: 286px; float: left; margin-left: 2px" tabindex="210"/>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<div id="divPremStatL">	
								<label for="txtPremStat" style="float: left;">Prem Status</label>
								<label style="float: right;">:</label>
							</div>
						</td>
						<td style="padding-left: 5px;" colspan="3">
							<div id="divPremStatT">	
								<span class="lovSpan" style="width: 70px; margin-bottom: 0;">								
									<input type="text" id="txtPremStat" style="width: 45px; float: left;" class="withIcon allCaps"  maxlength="240"  tabindex="211"/>  
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgPremStat" alt="Go" style="float: right;"/>
								</span>
								<input type="text" id="txtPremStatName" readonly="readonly" style="margin: 0; height: 14px; width: 286px; float: left; margin-left: 2px" tabindex="210"/>
							</div>
						</td>
					</tr>	
					<tr>
						<td>
							<div id="divCommStatL">	
								<label for="txtCommStat" style="float: left;">Comm Status</label>
								<label style="float: right;">:</label>
							</div>
						</td>
						<td style="padding-left: 5px;" colspan="3">
							<div id="divCommStatT">	
								<span class="lovSpan" style="width: 70px; margin-bottom: 0;">								
									<input type="text" id="txtCommStat" style="width: 45px; float: left;" class="withIcon allCaps"  maxlength="240"  tabindex="212"/>  
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgCommStat" alt="Go" style="float: right;"/>
								</span>
								<input type="text" id="txtCommStatName" readonly="readonly" style="margin: 0; height: 14px; width: 286px; float: left; margin-left: 2px" tabindex="210"/>
							</div>
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
	var objGIACS606 = {};
	var txtTrans = document.getElementById('txtTransaction');
	
	function initGIACS606(){
		setModuleId("GIACS606");
		setDocumentTitle("Converted and Uploaded Files");
		$("txtSourceName").value = "ALL SOURCES";
		$("txtTransactionName").clear;
		$("txtFilename").value = "ALL FILES";
		$("txtStatusName").value = "ALL STATUS";
		$("txtPremStatName").value = "ALL PREMIUM STATUS";	
		$("txtCommStatName").value = "ALL COMMISSION STATUS";	
		$("divPremStatL").hide();
		$("divPremStatT").hide();
		$("divCommStatL").hide();
		$("divCommStatT").hide();			
	}	
	initGIACS606();			
	
	function resetForm() {
		onLOV = false;
		$("txtSource").clear();
		$("txtSourceName").value = "ALL SOURCES";
		$("txtTransaction").clear();
		$("txtTransactionName").clear();
		$("txtFilename").value = "ALL FILES";	
		$("txtStatus").clear();		
		$("txtStatusName").value = "ALL STATUS";	
		$("txtPremStatName").value = "ALL PREMIUM STATUS";	
		$("txtCommStatName").value = "ALL COMMISSION STATUS";		
		$("selDestination").selectedIndex = 0;
		toggleRequiredFields("screen");
		checkSource = "";
		checkTransaction = "";
	}
	
	$("btnReloadForm").observe("click", resetForm);
	observeReloadForm("btnReloadForm", showGIACS606);
			
	$("imgSource").observe("click",function(){
	showGIACS606SourceLOV("%");
	});		
	
	function showGIACS606SourceLOV(x){
		try{		
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					  action : "getGIACS606SourceLOV",
					  search : x,
						page : 1
				},
				title: "List of Sources",
				width: 470,
				height: 400,
				columnModel: [
		 			{
						id : 'sourceCd',
						title: 'Code',
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
						objGIACS606.sourceCd = unescapeHTML2(row.sourceCd);
						$("txtSourceName").value = unescapeHTML2(row.sourceName);
						$("txtSourceName").setAttribute("lastValidValue", unescapeHTML2(row.sourceName));
						objGIACS606.sourceName = unescapeHTML2(row.sourceName); 								
					}
				},
				onCancel: function(){
					$("txtSource").focus();
					$("txtSource").value = $("txtSource").getAttribute("lastValidValue");
		  		},
		  		onUndefinedRow: function(){
		  			$("txtSource").value = $("txtSource").getAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtSource");
		  		}
			});
		}catch(e){
			showErrorMessage("showGIACS606SourceLOV",e);
		}
	} 	
	
	$("txtSource").observe("change", function(){
		if($("txtSource").value == ""){
			objGIACS606.sourceCd = "";
			$("txtSource").setAttribute("lastValidValue", "");
			$("txtSourceName").value = "ALL SOURCES";
		} else {
			showGIACS606SourceLOV($("txtSource").value+"%");
		}
	});		 

	$("imgTransaction").observe("click",function(){
		showGIACS606TransactionLOV("%");
	});		

	function showGIACS606TransactionLOV(x){
		try{		
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					  action : "getGIACS606TransactionLOV",
					  search : x,
						page : 1
				},
				title: "List of Transactions",
				width: 480,
				height: 400,
				columnModel: [
		 			{
						id : 'rvLowValue',
						title: 'Trantype',
						width : '120px',
						align: 'left',
						titleAlign : 'left'						
					},
					{
						id : 'rvMeaning',
						title: 'Status',
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
						objGIACS606.rvLowValue = unescapeHTML2(row.rvLowValue);
						$("txtTransactionName").value = unescapeHTML2(row.rvMeaning);
						$("txtTransactionName").setAttribute("lastValidValue", unescapeHTML2(row.rvMeaning));
						objGIACS606.rvMeaning = unescapeHTML2(row.rvMeaning); 	

						if ($("txtTransaction").value == 2) {
							$("divStatusL").hide();
							$("divStatusT").hide();
							$("divPremStatL").show();
							$("divPremStatT").show();
							$("divCommStatL").show();
							$("divCommStatT").show();							
						} else {
							$("divStatusL").show();
							$("divStatusT").show();			
							$("divPremStatL").hide();
							$("divPremStatT").hide();
							$("divCommStatL").hide();
							$("divCommStatT").hide();								
						}						
					}
				},
				onCancel: function(){
					$("txtTransaction").focus();
					$("txtTransaction").value = $("txtTransaction").getAttribute("lastValidValue");
		  		},
		  		onUndefinedRow: function(){
		  			$("txtTransaction").value = $("txtTransaction").getAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtTransaction");
		  		}
			});
		}catch(e){
			showErrorMessage("showGIACS606TransactionLOV",e);
		}
	} 	
	
	$("txtTransaction").observe("change", function(){
		if($("txtTransaction").value == ""){
			objGIACS606.rvLowValue = "";
			$("txtTransaction").setAttribute("lastValidValue", "");
			$("txtTransactionName").value = "";
		} else {
			showGIACS606TransactionLOV($("txtTransaction").value+"%");
		}
	});		 		

	$("imgFilename").observe("click",function(){
		if ($("txtTransaction").value == ""){ 
			customShowMessageBox("Please enter a valid transaction type.", imgMessage.INFO, "txtTransaction");
		} else {
			showGIACS606FilenameLOV("%"); 
		}
	});		
	
	function showGIACS606FilenameLOV(x){
		try{		
			LOV.show({
				controller 			  : "AccountingLOVController",
				urlParameters 		  : {
					  action  		  : "getGIACS606FilenameLOV",
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
						title: 'Filename',
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
						objGIACS606.fileName = unescapeHTML2(row.fileName);						
					}
				},
				onCancel: function(){
					$("txtFilename").focus();
					if ($("txtFilename").value = "ALL FILES"){
					   ($("txtFilename").value = "ALL FILES");
					} else {
						$("txtFilename").value = $("txtFilename").getAttribute("lastValidValue");	
					}					
		  		},
		  		onUndefinedRow: function(){
		  			$("txtFilename").value = $("txtFilename").getAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtFilename");
					($("txtFilename").value = "ALL FILES");
		  		}
			});
		}catch(e){
			showErrorMessage("showGIACS606FilenameLOV",e);
		}
	} 	
	
	$("txtFilename").observe("change", function(){
		if ($("txtTransaction").value == ""){ 
			customShowMessageBox("Please enter a valid transaction type.", imgMessage.INFO, "txtTransaction");
			$("txtFilename").value = "ALL FILES";
		} else {		
			if($("txtFilename").value == ""){
				objGIACS606.fileName = "";
				$("txtFilename").setAttribute("lastValidValue", "");
				$("txtFilename").value = "ALL FILES";
			} else {
				showGIACS606FilenameLOV($("txtFilename").value+"%");
			}
		}
	});

	$("imgStatus").observe("click",function(){
		if ($("txtTransaction").value == ""){ 
			customShowMessageBox("Please enter a valid transaction type.", imgMessage.INFO, "txtTransaction");
		} else {
			showGIACS606StatusLOV("%"); 
		}
	});			
	
	function showGIACS606StatusLOV(x){
		try{		
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					  action : "getGIACS606StatusLOV",
					  search : x,
			 transactionType : $("txtTransaction").value,
						page : 1
				},
				title: "List of Status",
				width: 480,
				height: 400,
				columnModel: [
		 			{
						id : 'rvLowValue',
						title: 'Prem chk',
						width : '120px',
						align: 'left',
						titleAlign : 'left'						
					},
					{
						id : 'rvMeaning',
						title: 'Status',
					    width: '345px',
					    align: 'left'
					}
				],
				filterText: nvl(escapeHTML2(x), "%"), 
				autoSelectOneRecord : true,
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtStatus").value = unescapeHTML2(row.rvLowValue);
						$("txtStatus").setAttribute("lastValidValue", unescapeHTML2(row.rvLowValue));
						objGIACS606.rvLowValue = unescapeHTML2(row.rvLowValue);
						$("txtStatusName").value = unescapeHTML2(row.rvMeaning);
						$("txtStatusName").setAttribute("lastValidValue", unescapeHTML2(row.rvMeaning));
						objGIACS606.rvMeaning = unescapeHTML2(row.rvMeaning); 								
					}
				},
				onCancel: function(){
					$("txtStatus").focus();
					$("txtStatus").value = $("txtStatus").getAttribute("lastValidValue");
		  		},
		  		onUndefinedRow: function(){
		  			$("txtStatus").value = $("txtStatus").getAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtStatus");
		  		}
			});
		}catch(e){
			showErrorMessage("showGIACS606StatusLOV",e);
		}
	} 	
	
	$("txtStatus").observe("change", function(){
		if ($("txtTransaction").value == ""){ 
			customShowMessageBox("Please enter a valid transaction type.", imgMessage.INFO, "txtTransaction");
			$("txtStatus").clear();					
		} else {
			if($("txtStatus").value == ""){
				objGIACS606.rvLowValue = "";
				$("txtStatus").setAttribute("lastValidValue", "");
				$("txtStatusName").value = "ALL STATUS";
			} else {
				showGIACS606StatusLOV($("txtStatus").value+"%");
			}

		}
	});		 		

	$("imgPremStat").observe("click",function(){
		if ($("txtTransaction").value == ""){ 
			customShowMessageBox("Please enter a valid transaction type.", imgMessage.INFO, "txtTransaction");
		} else {
			showGIACS606Status2ALOV("%"); 
		}
	});			
	
	function showGIACS606Status2ALOV(x){
		try{		
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					  action : "getGIACS606Status2ALOV",
					  search : x,
			 transactionType : $("txtTransaction").value,
						page : 1
				},
				title: "List of Premium Status",
				width: 480,
				height: 400,
				columnModel: [
		 			{
						id : 'rvLowValue',
						title: 'PremChk',
						width : '120px',
						align: 'left',
						titleAlign : 'left'						
					},
					{
						id : 'rvMeaning',
						title: 'Status',
					    width: '345px',
					    align: 'left'
					}
				],
				filterText: nvl(escapeHTML2(x), "%"), 
				autoSelectOneRecord : true,
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtPremStat").value = unescapeHTML2(row.rvLowValue);
						$("txtPremStat").setAttribute("lastValidValue", unescapeHTML2(row.rvLowValue));
						objGIACS606.rvLowValue = unescapeHTML2(row.rvLowValue);
						$("txtPremStatName").value = unescapeHTML2(row.rvMeaning);
						$("txtPremStatName").setAttribute("lastValidValue", unescapeHTML2(row.rvMeaning));
						objGIACS606.rvMeaning = unescapeHTML2(row.rvMeaning); 								
					}
				},
				onCancel: function(){
					$("txtPremStat").focus();
					$("txtPremStat").value = $("txtPremStat").getAttribute("lastValidValue");
		  		},
		  		onUndefinedRow: function(){
		  			$("txtPremStat").value = $("txtPremStat").getAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtPremStat");
		  		}
			});
		}catch(e){
			showErrorMessage("showGIACS606Status2ALOV",e);
		}
	} 	
	
	$("txtPremStat").observe("change", function(){
		if ($("txtTransaction").value == ""){ 
			customShowMessageBox("Please enter a valid transaction type.", imgMessage.INFO, "txtTransaction");
			$("txtPremStat").clear();					
		} else {
			if($("txtPremStat").value == ""){
				objGIACS606.rvLowValue = "";
				$("txtPremStat").setAttribute("lastValidValue", "");
				$("txtPremStatName").value = "ALL PREMIUM STATUS";
			} else {
				showGIACS606Status2ALOV($("txtPremStat").value+"%");
			}

		}
	});	

	$("imgCommStat").observe("click",function(){
		if ($("txtTransaction").value == ""){ 
			customShowMessageBox("Please enter a valid transaction type.", imgMessage.INFO, "txtTransaction");
		} else {
			showGIACS606Status2BLOV("%"); 
		}
	});			
	
	function showGIACS606Status2BLOV(x){
		try{		
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					  action : "getGIACS606Status2BLOV",
					  search : x,
			 transactionType : $("txtTransaction").value,
						page : 1
				},
				title: "List of Commission Status",
				width: 480,
				height: 400,
				columnModel: [
		 			{
						id : 'rvLowValue',
						title: 'CommChk',
						width : '120px',
						align: 'left',
						titleAlign : 'left'						
					},
					{
						id : 'rvMeaning',
						title: 'Status',
					    width: '345px',
					    align: 'left'
					}
				],
				filterText: nvl(escapeHTML2(x), "%"), 
				autoSelectOneRecord : true,
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtCommStat").value = unescapeHTML2(row.rvLowValue);
						$("txtCommStat").setAttribute("lastValidValue", unescapeHTML2(row.rvLowValue));
						objGIACS606.rvLowValue = unescapeHTML2(row.rvLowValue);
						$("txtCommStatName").value = unescapeHTML2(row.rvMeaning);
						$("txtCommStatName").setAttribute("lastValidValue", unescapeHTML2(row.rvMeaning));
						objGIACS606.rvMeaning = unescapeHTML2(row.rvMeaning); 								
					}
				},
				onCancel: function(){
					$("txtCommStat").focus();
					$("txtCommStat").value = $("txtCommStat").getAttribute("lastValidValue");
		  		},
		  		onUndefinedRow: function(){
		  			$("txtCommStat").value = $("txtCommStat").getAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtCommStat");
		  		}
			});
		}catch(e){
			showErrorMessage("showGIACS606Status2BLOV",e);
		}
	} 	
	
	$("txtCommStat").observe("change", function(){
		if ($("txtTransaction").value == ""){ 
			customShowMessageBox("Please enter a valid transaction type.", imgMessage.INFO, "txtTransaction");
			$("txtCommStat").clear();					
		} else {
			if($("txtCommStat").value == ""){
				objGIACS606.rvLowValue = "";
				$("txtCommStat").setAttribute("lastValidValue", "");
				$("txtCommStatName").value = "ALL COMMISSION STATUS";
			} else {
				showGIACS606Status2BLOV($("txtCommStat").value+"%");
			}
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
	
 	function printReport(){
		var txtFilename2 = "";		
		if ($("txtFilename").value == "ALL FILES") {
			txtFilename2 = "";
		} else {
			txtFilename2 = $("txtFilename").value;
		}
		
		if($F("selDestination") == "file") {
			if ($("rdoPdf").checked) 
				reportId = "GIACR606";
			else 
				reportId = "GIACR606_CSV";		
		} else {
			reportId = "GIACR606";
		}
		
		try {
			var content = contextPath + "/UploadingReportPrintController?action=printReport"
					                  + "&sourceCd=" + $("txtSource").value
					                  + "&transactionCd=" + $("txtTransaction").value
					                  + "&fileName=" + txtFilename2					
					                  + "&premCheckFlag=" + $("txtStatus").value
					                  + "&tpremCheckFlag=" + $("txtPremStat").value
					                  + "&tcommCheckFlag=" + $("txtCommStat").value
					                  + "&reportId=" + reportId
					                  + "&noOfCopies=" + $F("txtNoOfCopies")
					                  + "&printerName=" + $F("selPrinter")
					                  + "&destination=" + $F("selDestination");
		
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
					fileType = "CSV2";
				
				new Ajax.Request(content, {
					parameters : {destination : "file",
								  fileType : fileType},
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							if (fileType == "CSV2"){
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

	$("btnPrint").observe("click", function(){
		var dest = $F("selDestination");		
		if ($("txtTransaction").value == ""){ 
			customShowMessageBox("Please enter a valid transaction type.", imgMessage.INFO, "txtTransaction");
		}else {
			if(dest == "printer"){
				if(checkAllRequiredFieldsInDiv("printDiv")){
					printReport();
				}
			}else{
				printReport();
			}
		}		
	});	
</script>