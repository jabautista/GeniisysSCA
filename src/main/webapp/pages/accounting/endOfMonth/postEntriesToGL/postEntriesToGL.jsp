<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="mainNav" name="mainNav">
	<div id="smoothMenu1" name="smoothMenu1" class="ddsmoothmenu">
		<ul>
			<li><a id="postEntriesToGLExit">Exit</a> </li>
		</ul>
	</div>
</div>

<div id="postEntriesToGLMainDiv" name="postEntriesToGLMainDiv" >
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Post Entries to the General Ledger</label>
			<span class="refreshers" style="margin-top: 0;">
		 		<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	
	<div class="sectionDiv" style="width: 920px; height: 350px;">
		<div id="fieldsOuterDiv" class="sectionDiv" style="width: 500px; height: 220px; margin: 20px 0 0 200px; padding: 15px 15px 15px 15px;">
			<div id="fieldsDiv" class="sectionDiv" style="width: 498px; height: 80px;">
				<table align="center" style="width: 400px; height: 80px; padding: 20px; ">
					<tr>
						<td>Year</td>
						<td>
							<div id="yearDiv" class="required" style="border: 1px solid gray; width: 150px; height: 20px; margin-right: 50px; float:left">
								<input id="txtTranYear" name="txtTranYear" type="text" maxlength="4" style="border: none; float: left; width: 125px; height: 13px; margin: 0px;" value="" class="required rightAligned integerNoNegativeUnformattedNoComma"/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchTranYear" name="searchTranYear" alt="Go" style="float: right;"/>
							</div>
						</td>
						<td>Month</td>
						<td>
							<div id="monthDiv" class="required" style="border: 1px solid gray; width: 150px; height: 20px; margin-right: 10px; float:left">
								<input id="txtTranMonth" name="txtTranMonth" type="text" maxlength="2" style="border: none; float: left; width: 125px; height: 13px; margin: 0px;" value="" class="required rightAligned integerNoNegativeUnformattedNoComma"/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchTranMonth" name="searchTranMonth" alt="Go" style="float: right;"/>
							</div>
						</td>
					</tr>
				</table>
			</div>
			
			<table id="postTagTbl1" style="width: 400px; height: 70px; margin-left: 90px; padding: 20px 0 0 25px;"> 
				<tr>
					<td>
						<input id="fiscalRB" name="postTagRG" type="radio" value="1" style="float: left; margin: 0px 5px 13px 25px;"/><label for="fiscalRB" style="margin: 2px 0 4px 0;">Post to Fiscal General Ledger</label>
					</td>
				</tr>
				<tr>
					<td>
						<input id="financialRB" name="postTagRG" type="radio" value="2" style="float: left; margin: 0px 5px 13px 25px;"/><label for="financialRB" style="margin: 2px 0 4px 0;">Post to Financial General Ledger</label>
					</td>
				</tr>
				<tr>
					<td>
						<input id="bothRB" name="postTagRG" type="radio" value="3" style="float: left; margin: 0px 5px 13px 25px;" checked="checked"/><label for="bothRB" style="margin: 2px 0 4px 0;">Post to Fiscal and Financial General Ledgers</label>
					</td>
				</tr>
			</table>
			
			<table id="postTagTbl2" style="width: 400px; height: 70px; margin-left: 90px; padding: 50px 0 0 25px;"> 
				<tr>
					<td>
						<input id="bothRB2" name="postTagRG" type="radio" value="3" style="float: left; margin: 0px 5px 13px 25px;" /><label for="bothRB2" style="margin: 2px 0 4px 0;">Post to Fiscal and Financial General Ledgers</label>
					</td>
				</tr>
			</table>  
		</div>		
		
		<div id="buttonDiv" class="buttonsDiv" style="margin-top: 15px;">
			<input id="btnPost" type='button' class='button' value="Post" style="width: 80px;"/>
		</div>
	</div>			
</div>

<script type="text/javascript">
try{
	setModuleId("GIACS410");
	setDocumentTitle("Post Entries to the General Ledger");
	initializeAll();
	
	var gl_no = null;
	var finance_end = null;
	var fiscal_end = null;
	var post_tag = 3;
	var gl_type = "Fiscal and Financial GLs";
	
	$("postTagTbl2").hide();
	
	function getGLNo(){
		try{
			new Ajax.Request(contextPath + "/GIACPostEntriesToGLController",{
				method: "POST",
				parameters: { action: "getGLNo"},
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if (checkCustomErrorOnResponse(response)){
						gl_no = response.responseText;
						getFinanceEnd();
					}
					
				}
			});
		}catch(e){
			showErrorMessage("getGLNo", e);
		}
	}
	
	
	function getFinanceEnd(){
		try{
			new Ajax.Request(contextPath + "/GIACPostEntriesToGLController",{
				method: "POST",
				parameters: { action: "getFinanceEnd"},
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if(checkCustomErrorOnResponse(response)){
						finance_end = response.responseText;
						
						if (gl_no == 2){ 
							getFiscalEnd();
						}

						if (gl_no == 1){
							$("postTagTbl1").hide();
							$("bothRB").checked = false;
							//fiscal and financial radio displayed = property_off in FMB
							$("postTagTbl2").show();
							$("bothRB2").checked = true;
						}else if(gl_no == 2){ 
							if (fiscal_end == finance_end){
								disableButton("btnPost");
								showMessageBox("Parameter gl_no has an invalid value.", "I");
							}else{
								enableButton("btnPost");
							}
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("getFinanceEnd", e);
		}
	}
	
	function getFiscalEnd(){
		try{
			new Ajax.Request(contextPath + "/GIACPostEntriesToGLController",{
				method: "POST",
				parameters: { action: "getFiscalEnd"},
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if(checkCustomErrorOnResponse(response)){
						fiscal_end = response.responseText;
					}
				}
			});
		}catch(e){
			showErrorMessage("getFiscalEnd", e);
		}
	}
		
	function whenNewFormInstance(){
		getGLNo();				
		
		$("txtTranYear").value = new Date().format("yyyy");
		$("txtTranMonth").value = new Date().format("m");
		$("txtTranYear").focus();
	}
	
	function showTranYearLOV(isIconClicked){
		var searchString = isIconClicked ? "%" : ($F("txtTranYear").trim() == "" ? '%' : $F("txtTranYear"));
		
		try{
			LOV.show({
				controller:  	'AccountingLOVController',
				urlParameters: 	{
								action:		'getGIACS410TranYearLOV',
								//tranYear: 	$F("txtTranYear")
								searchString:	searchString
								},
				title:			"Valid Values For Year",
				height:			300,
				width:			350,
				columnModel:	[
				             	 {
				             		 id: 'tranYear',
				             		 title: 'Year',
					             	 width: '330px'
				             	 }
				             	],
				draggable:		true,
				autoSelectOneRecord: true,
				filterText: searchString,
				onSelect: function(row){
					if (row != undefined){
						$("txtTranYear").setAttribute("lastValidValue", row.tranYear);
						$("txtTranYear").value = row.tranYear;
					}
				},
				onUndefinedRow : function(){
					$("txtTranYear").value = $("txtTranYear").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtTranYear");
				},
				onCancel: function(){
					$("txtTranYear").focus();
					$("txtTranYear").value = $("txtTranYear").readAttribute("lastValidValue");
				}
			});
		}catch(e){
			showErrorMessage("showTranYearLOV", e);
		}
	}
	
	function showTranMonthLOV(isIconClicked){
		var searchString = isIconClicked ? "%" : ($F("txtTranMonth").trim() == "" ? '%' : $F("txtTranMonth"));
		
		try{
			LOV.show({
				controller:		'AccountingLOVController',
				urlParameters:	{
									action:			'getGIACS410TranMonthLOV',
									tranYear:		$F("txtTranYear"),
									searchString:	searchString
								},
				title:			'Valid Values for Month',
				height:			350,
				width:			400,
				columnModel:	[
				            	 {
				            		id: 'tranMonth',
				            		title: 'Month',
				            		width: '50px'
				            	 },
				            	 {
				            		 id: 'tranYear',
				            		 title: 'Year',
				            		 width: '50px'
				            	 },
				            	 {
				            		 id: 'postTag',
				            		 title: 'Post Tag',
				            		 width: '70px'
				            	 },
				            	 {
				            		 id: 'desc',
				            		 title: 'Description',
				            		 width: '210px'
				            	 }
				            	],
				draggable:		true,
				autoSelectOneRecord: true,
				filterText: searchString,
				onSelect: function(row){
					if (row != undefined){
						$("txtTranMonth").setAttribute("lastValidValue", row.tranMonth);
						$("txtTranMonth").value = row.tranMonth;
					}
				},
				onUndefinedRow : function(){
					$("txtTranMonth").value = $("txtTranMonth").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtTranMonth");
				},
				onCancel: function(){
					$("txtTranMonth").focus();
					$("txtTranMonth").value = $("txtTranMonth").readAttribute("lastValidValue");
				}
			});	
		}catch(e){
			showErrorMessage("showTranMonthLOV", e);
		}
	}
	
	function validateTranYear(){
		try{
			new Ajax.Request(contextPath + "/GIACPostEntriesToGLController",{
				method: "POST",
				parameters: {
					action:		"validateTranYear",
					tranYear:	$F("txtTranYear")
				},
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if (response.responseText == ""){
						showMessageBox("Invalid value for Tran Year", "E");
					}
				}
			});
		}catch(e){
			showErrorMessage("validateTranYear", e);
		}
	}
	
	function validateTranMonth(){
		try{
			new Ajax.Request(contextPath + "/GIACPostEntriesToGLController",{
				method: "POST",
				parameters: {
					action:		"validateTranMonth",
					tranYear:	$F("txtTranYear"),
					tranMonth:	$F("txtTranMonth")
				},
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if (response.responseText != 'Y'){
						showMessageBox("Invalid value for Tran Month", "E");
					}
				}
			});
		}catch(e){
			showErrorMessage("validateTranMonth", e);
		}
	}
	
	function checkIsPrevMonthClosed(){
		try{
			new Ajax.Request(contextPath + "/GIACPostEntriesToGLController",{
				method: "POST",
				parameters: {
					action:		"checkIsPrevMonthClosed",
					tranYear:	$F("txtTranYear"),
					tranMonth:	$F("txtTranMonth"),
					postTag:	post_tag
				},
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if(checkCustomErrorOnResponse(response)){
						postToGL();
					}
				}
			});
		}catch(e){
			showErrorMessage("checkIsPrevMonthClosed", e);
		}
	}
	
	function postToGL(){
		try{
			new Ajax.Request(contextPath + "/GIACPostEntriesToGLController",{
				method: "POST",
				parameters: {
					action:		"postToGL",
					tranYear:	$F("txtTranYear"),
					tranMonth:	$F("txtTranMonth"),
					postTag:	post_tag,
					glNo:		gl_no,
					fiscalEnd:	fiscal_end,
					financeEnd:	finance_end
				},
				evalScripts: true,
				asynchronous: true,
				onCreate: showNotice("Working...Please Wait."),
				onComplete: function(response){
					hideNotice();
					if(checkCustomErrorOnResponse(response)){
						if (response.responseText == "SUCCESS"){
							showMessageBox("Entries of "+getMonthWordEquivalent($F("txtTranMonth") - 1) + " " + formatNumberDigits(nvl($F("txtTranYear"), 7), 4) 
											+ " are posted to the General Ledger.");
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("postToGL", e);
		}
	}
	
	
	whenNewFormInstance();
	
	$("txtTranYear").observe("change", function(){
		if($F("txtTranYear") == ""){
			$("txtTranYear").focus();
		}else{
			showTranYearLOV(false); //validateTranYear();
		}
	});
	
	$("txtTranMonth").observe("change", function(){
		if ($F("txtTranMonth") > 12){
			$("txtTranMonth").clear();
			$("txtTranMonth").focus();
		}else if($F("txtTranMonth") == ""){
			$("txtTranMonth").focus();
		}else{
			showTranMonthLOV(false); //validateTranMonth();
		}
	});
	
	$("searchTranYear").observe("click", function(){
		showTranYearLOV(true);
	});
	
	$("searchTranMonth").observe("click", function(){
		showTranMonthLOV(true);
	});
	
	$$("input[name='postTagRG']").each(function(rb){
		rb.observe("click", function(){
			post_tag = rb.value;
			
			if (rb.value == 1){
				gl_type = "Fiscal GL";
			}else if (rb.value == 2){
				gl_type = "Financial GL";
			}else if (rb.value == 3){
				gl_type = "Fiscal and Financial GLs";
			}
		});
	});
	
	$("btnPost").observe("click", function(){
		/*if ($F("txtTranYear") == "" || $F("txtTranMonth") == ""){
			showMessageBox("Field must be entered.", "I");
		}else{*/
		if (checkAllRequiredFieldsInDiv('fieldsDiv')){
			showConfirmBox("Confirm", "Post " + getMonthWordEquivalent($F("txtTranMonth") - 1) + " " + nvl($F("txtTranYear"), 7) 
										+ " entries to the " + gl_type +"?", "Yes", "No",
							function(){
								checkIsPrevMonthClosed();
							},
							function(){}
			);
			
			objGIACS410.postGL = "Y";						
		}
	});
	
	$("postEntriesToGLExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	});
	
	observeReloadForm("reloadForm", showPostEntriesToGLPage);
	
}catch(e){
	showErrorMessage("Page Error: ", e);
}
</script>