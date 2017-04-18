<div id="productionInquiry" name="productionInquiry" style="float: left; width: 100%;">
	<div id="productionInquiryExitDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="underwritingExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Production Inquiry</label>
			<span class="refreshers" style="margin-top: 0;">				
			 	<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	<div id="showBody">		
		<div class="sectionDiv" style="margin-bottom: 50px">	
			<div style="float: left;width: 100%;margin-bottom:20px">	
				<div style="width: 458px; float: left; padding: 0;margin-top: 10px">			
					<div>
						<fieldset style="width: 415px; float: right;margin:0;">
							<legend><strong>Period Covered</strong></legend>	
							<div style="margin: 5px 0 5px 20px">
								<table>	
									<tr id="rowFromTo">
										<td class="rightAligned" style="width: 40px;">From</td>
										<td>
											<div style="float: left; width: 130px;" class="withIconDiv" id="fromDateDiv">
												<input type="text" id="txtFromDate" name="txtFromDate" class="withIcon disableDelKey required" readonly="readonly" style="width: 105px;"/>
												<img id="hrefFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="" onclick="scwShow($('txtFromDate'),this, null);"/>
											</div>	
										</td>	
										<td style="width:40px;" class="rightAligned">To</td>						
										<td>
											<div style="float: left; width: 130px;" class="withIconDiv" id="toDateDiv">
												<input type="text" id="txtToDate" name="txtToDate" class="withIcon disableDelKey required" readonly="readonly" style="width: 105px;"/>
												<img id="hrefToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="" onclick="scwShow($('txtToDate'),this, null);"/>
											</div>	
										</td>
									</tr>	
									<tr id="rowMonthYear">
										<td class="rightAligned" style="width: 40px;">Month</td>
										<td>
											<div style="width: 132px;" id="monthDiv">
												<select id="dDnMenuMonth" name="dDnMenuMonth" class="required" style="text-align: left; width: 100%;margin:2px 4px 0 0">
												</select>
											</div>
										</td>	
										<td style="width:44px;" class="rightAligned">Year</td>						
										<td>
											<div style="float: left; width: 130px;" id="yearDiv"><input type="text" id="txtYear" name="txtYear" class="required" style="width: 124px;margin:2px 4px 0 0" maxlength="4"/></div>
										</td>
									</tr>
								</table>
							</div>	
						</fieldset>
					</div>
					<div>	
						<fieldset style="width: 415px; float: right;margin:5px 0 0 0">
							<legend><strong>Criteria / Basis</strong></legend>	
							<div style="margin: 5px 0 5px 20px">		
								<table>
									<tr>
										<td align="right">Line</td>
										<td><span class="lovSpan" style="width: 246px; margin-top:2px;height:19px;">
												<input id="txtLine" type="text" style="width:220px;margin: 0;height:13px;border: 0" maxlength="30"><img
												src="${pageContext.request.contextPath}/images/misc/searchIcon.png"
												id="imgSearchLine" alt="Go" style="float: right; margin-top: 2px;" />
											</span>	
										</td>
									</tr>								
									<tr>
										<td align="right">Subline</td>
										<td><span class="lovSpan" style="width: 246px; margin-top:2px;height:19px;">
												<input id="txtSubline" type="text" style="width:220px;margin: 0;height:13px;border: 0" maxlength="30"><img
												src="${pageContext.request.contextPath}/images/misc/searchIcon.png"
												id="imgSearchSubline" alt="Go" style="float: right; margin-top: 2px;" />
											</span>	
										</td>
									</tr>
									<tr>
										<td>										
										</td>
										<td style="padding: 5px 0 5px 0;margin: 0">
											<div>
												<div style="padding: 0;margin: 0">
													<input style="float: left;" type="radio" id="rdoCreditingBranch" name="rdoCredBrnchIssSource"/>
													<label for="rdoCreditingBranch" style="padding-top: 2px">Crediting Branch</label>								
												</div>
												<div>
													<input style="float: left; margin-left: 25px" type="radio" id="rdoIssuingSource" name="rdoCredBrnchIssSource" checked="checked"/>								
													<label for="rdoIssuingSource" style="padding-top: 2px">Issuing Source</label>
												</div>
											</div>
										</td>
									</tr>
									<tr>
										<td align="right" id="lblCredIss" style="width:76px">Issue Code</td>
										<td><span class="lovSpan" style="width: 246px; margin-top:2px;height:19px;">
												<input id="txtIssue" type="text" style="width:220px;margin: 0;height:13px;border: 0" maxlength="30"><img
												src="${pageContext.request.contextPath}/images/misc/searchIcon.png"
												id="imgSearchIssue" alt="Go" style="float: right; margin-top: 2px;" />
											</span>	
										</td>
									</tr>
									<tr>
										<td align="right">Issue Year</td>
										<td><span class="lovSpan" style="width: 246px; margin-top:2px;height:19px;">
												<input id="txtIssueYear" type="text" style="width:220px;margin: 0;height:13px;border: 0" maxlength="30"><img
												src="${pageContext.request.contextPath}/images/misc/searchIcon.png"
												id="imgSearchIssueYear" alt="Go" style="float: right; margin-top: 2px;" />
											</span>	
										</td>
									</tr>
									<tr>
										<td align="right">Intermediary</td>
										<td><span class="lovSpan" style="width: 24	6px; margin-top:2px;height:19px;">
												<input id="txtIntermediary" type="text" style="width:220px;margin: 0;height:13px;border: 0" maxlength="240"><img
												src="${pageContext.request.contextPath}/images/misc/searchIcon.png"
												id="imgSearchIntermediary" alt="Go" style="float: right; margin-top: 2px;" />
											</span>	
										</td>
									</tr>
								</table>					
							</div>
							<div style="margin: 10px 0 5px 30px">	
								<table>
									<tr>
										<td align="right" style="padding: 0 0 7px 0"><input type="radio" id="rdoByEffectivityDate" name="rdoDate" checked="checked"/></td>
										<td style="width: 150px; padding: 0 0 7px 0"><label for="rdoByEffectivityDate">By Effectivity Date</label></td>
										<td align="right" style="padding: 0 0 7px 0"><input type="radio" id="rdoByBookingDate" name="rdoDate"/></td>
										<td style="padding: 0 0 7px 0"><label for="rdoByBookingDate">By Booking Date</label></td>									
									</tr>
									<tr>
										<td align="right" style="padding: 0 0 7px 0"><input type="radio" id="rdoByIssueDate" name="rdoDate"/></td>
										<td style="padding: 0 0 7px 0"><label for="rdoByIssueDate">By Issue Date</label></td>
										<td align="right" style="padding: 0 0 7px 0"><input type="radio" id="rdoByAccountingEntryDate" name="rdoDate"/></td>
										<td style="padding: 0 0 7px 0"><label for="rdoByAccountingEntryDate">By Accounting Entry Date</label></td>									
									</tr>
									<tr>
										<td style=""><input style="float: right; margin-right: 2px" type="checkbox" id="chkIncSpecialPol"/>
										</td>
										<td><label for="chkIncSpecialPol" style="">Include Special Policies</label></td>
										<td></td>
										<td></td>									
									</tr>
								</table>
							</div>	
						</fieldset>
					</div>
					<div>
						<fieldset style="width: 415px; float: right;margin:5px 0 0 0">
							<legend><strong>Distribution</strong></legend>			
							<div style="padding: 5px; margin-left: 20px">
								<table>
									<tr>
										<td align="right"><input type="radio" id="rdoDistributed" name="rdoDistribution"/></td>
										<td style="padding-top: 4px;width: 115px;"><label for="rdoDistributed" >Distributed</label></td>
										<td align="right"><input type="radio" id="rdoUndistributed" name="rdoDistribution"/></td>
										<td style="padding-top: 4px;width: 115px;"><label for="rdoUndistributed">Undistributed</label></td>
										<td align="right"><input type="radio" id="rdoBoth" name="rdoDistribution" checked="checked"/></td>
										<td style="padding-top: 4px"><label for="rdoBoth">Both</label></td>
									</tr>
								</table>
							</div>		
						</fieldset>
					</div>
				</div>	
				<div style="width: 458px; float: right;padding: 0;margin-top: 10px">			
					<div>
						<fieldset style="width: 415px; float: left;margin:0">
							<legend><strong>Total</strong></legend>		
							<div style="margin:120px 0 133px 40px">
								<table>
									<tr>
										<td class="rightAligned">Total No. of Policies</td>	
										<td><input class="rightAligned" id="txtTotNoOfPolicies" type="text" style="width: 220px;" value="0" maxlength="12" readonly="readonly"/></td>									
									</tr>	
									<tr>
										<td class="rightAligned">Total Premium</td>	
										<td><input class="rightAligned" id="txtTotPremium" type="text" style="width: 220px" value="0.00" maxlength="30" readonly="readonly"/></td>									
									</tr>		
									<tr>
										<td class="rightAligned">Total Sum Insured</td>	
										<td><input class="rightAligned" id="txtTotSumInsured" type="text" style="width: 220px" value="0.00" maxlength="30" readonly="readonly"/></td>									
									</tr>	
									<tr>
										<td class="rightAligned">Total Tax</td>	
										<td><input class="rightAligned" id="txtTotTax" type="text" style="width: 220px" value="0.00" maxlength="30" readonly="readonly"/></td>									
									</tr>	
									<tr>
										<td class="rightAligned">Total Commission</td>	
										<td><input class="rightAligned" id="txtTotCommission" type="text" style="width: 220px" value="0.00" maxlength="30" readonly="readonly"/></td>									
									</tr>																	
								</table>
							</div>			
						</fieldset>
					</div>
				</div>	
			</div>	
			<div style="border: 0; margin-bottom: 20px;" align="center">
				<input style="width: 120px" type="button" id="btnExtract" value="Extract">
				<input style="width: 180px" type="button" id=btnViewProdDtls value="View Production Details">
			</div>			
		</div>		
	</div>		
</div>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/underwriting/underwriting.js">
try {
	setModuleId("GIPIS200");
	setDocumentTitle("Production Inquiry");	
	var changeParamTag = 0;
	
	function getGIPIS200LineLOV() {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getGIPIS200LineLOV",
				line : ($("txtLine").readAttribute("lastValidValue") != $F("txtLine") ? nvl($F("txtLine"),"%") : "%"),
				issCd :nvl(objGIPIS200.issCd,""),
				page : 1,				
			},
			title : "List of Lines",
			width : 415,
			height : 386,
			columnModel : [ {
				id : "lineCd",
				title : "Line",
				width : '120px',
			},{
				id : "lineName",
				title : "Line Name",
				width : '280px',
			}],
			draggable : true,
			autoSelectOneRecord : true,
			filterText :($("txtLine").readAttribute("lastValidValue") != $F("txtLine") ? nvl($F("txtLine"),"%") : "%"),
			onSelect : function(row) {
				if(objGIPIS200.lineCd != unescapeHTML2(row.lineCd)){
					$("txtSubline").value="";
					$("txtSubline").setAttribute("lastValidValue","");	
					changeParam();
				}	
				$("txtLine").value = unescapeHTML2(row.lineName);					
				$("txtLine").setAttribute("lastValidValue", unescapeHTML2(row.lineName));
				objGIPIS200.lineCd=unescapeHTML2(row.lineCd);
				objGIPIS200.lineName=unescapeHTML2(row.lineName);				
				objGIPIS200.sublineCd="";
				objGIPIS200.sublineName="";									
			},
			onCancel : function() {
				$("txtLine").value = $("txtLine").readAttribute("lastValidValue");
			},
			onUndefinedRow : function() {
				customShowMessageBox("No record selected.", imgMessage.INFO,
						"txtLine");		
				$("txtLine").value = $("txtLine").readAttribute("lastValidValue");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();
			}
		});
	}	
	
	function getGIPIS200SublineLOV() {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getGIPIS200SublineLOV",
				subline : ($("txtSubline").readAttribute("lastValidValue") != $F("txtSubline") ? nvl($F("txtSubline"),"%") : "%"),
				lineCd :nvl(objGIPIS200.lineCd,""),
				page : 1
			},
			title : "List of Subline",
			width : 415,
			height : 386,
			columnModel : [ {
				id : "sublineCd",
				title : "Subline Cd",
				width : '120px',
			},{
				id : "sublineName",
				title : "Subline Name",
				width : '280px',
			}],
			draggable : true,
			autoSelectOneRecord : true,
			filterText :($("txtSubline").readAttribute("lastValidValue") != $F("txtSubline") ? nvl($F("txtSubline"),"%") : "%"),
			onSelect : function(row) {
				if(objGIPIS200.sublineCd != unescapeHTML2(row.sublineCd)){
					changeParam();
				}
				$("txtSubline").value = unescapeHTML2(row.sublineName);					
				$("txtSubline").setAttribute("lastValidValue", unescapeHTML2(row.sublineName));
				objGIPIS200.sublineCd=unescapeHTML2(row.sublineCd);
				objGIPIS200.sublineName=unescapeHTML2(row.sublineName);				
			},
			onCancel : function() {
				$("txtSubline").value = $("txtSubline").readAttribute("lastValidValue");
			},
			onUndefinedRow : function() {
				customShowMessageBox("No record selected.", imgMessage.INFO,
						"txtSubline");		
				$("txtSubline").value = $("txtSubline").readAttribute("lastValidValue");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();
			}
		});
	}	
	
	function getGIPIS200IssueLOV() {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getGIPIS200IssueLOV",
				issue : ($("txtIssue").readAttribute("lastValidValue") != $F("txtIssue") ? nvl($F("txtIssue"),"%") : "%"),
				lineCd :nvl(objGIPIS200.lineCd,""),
				page : 1,				
			},
			title : objGIPIS200.credIss=="C" ? "List of Credit Branch" : "List of Issuing Branch",
			width : 415,
			height : 386,
			columnModel : [ {
				id : "issName",
				title : "Issue Name",
				width : '280px',
			},{
				id : "issCd",
				title : "Iss. C",
				width : '120px',
			}],
			draggable : true,
			autoSelectOneRecord : true,
			filterText :($("txtIssue").readAttribute("lastValidValue") != $F("txtIssue") ? nvl($F("txtIssue"),"%") : "%"),
			onSelect : function(row) {
				if(objGIPIS200.issCd != unescapeHTML2(row.issCd)){
					changeParam();
				}
				$("txtIssue").value = unescapeHTML2(row.issName);					
				$("txtIssue").setAttribute("lastValidValue", unescapeHTML2(row.issName));
				objGIPIS200.issCd=unescapeHTML2(row.issCd);
				objGIPIS200.issName=unescapeHTML2(row.issName);				
			},
			onCancel : function() {
				$("txtIssue").value = $("txtIssue").readAttribute("lastValidValue");
			},
			onUndefinedRow : function() {
				customShowMessageBox("No record selected.", imgMessage.INFO,
						"txtIssue");		
				$("txtIssue").value = $("txtIssue").readAttribute("lastValidValue");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();
			}
		});
	}	
	
	function getGIPIS200IssueYearLOV() {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getGIPIS200IssueYearLOV",
				issueYy : ($("txtIssueYear").readAttribute("lastValidValue") != $F("txtIssueYear") ? nvl($F("txtIssueYear"),"%") : "%"),
				page : 1			
			},
			title : "List of Issue Year",
			width : 281,
			height : 300,
			columnModel : [ {
				id : "issueYy",
				title : "Issue Year",
				width : '270px',
			}],
			draggable : true,
			autoSelectOneRecord : true,
			filterText :($("txtIssueYear").readAttribute("lastValidValue") != $F("txtIssueYear") ? nvl($F("txtIssueYear"),"%") : "%"),
			onSelect : function(row) {
				if(objGIPIS200.issueYy != unescapeHTML2(row.issueYy)){
					changeParam();
				}
				$("txtIssueYear").value = unescapeHTML2(row.issueYy);					
				$("txtIssueYear").setAttribute("lastValidValue", unescapeHTML2(row.issueYy));
				objGIPIS200.issueYy=unescapeHTML2(row.issueYy);				
			},
			onCancel : function() {
				$("txtIssueYear").value = $("txtIssueYear").readAttribute("lastValidValue");
			},
			onUndefinedRow : function() {
				customShowMessageBox("No record selected.", imgMessage.INFO,
						"txtIssueYear");		
				$("txtIssueYear").value = $("txtIssueYear").readAttribute("lastValidValue");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();
			}
		});
	}
	
	function getGIPIS200IntermediaryLOV() {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getGIPIS200IntermediaryLOV",
				intermediary : ($("txtIntermediary").readAttribute("lastValidValue") != $F("txtIntermediary") ? nvl($F("txtIntermediary"),"%") : "%"),
				lineCd :nvl(objGIPIS200.lineCd,""),
				page : 1,				
			},
			title : "List of Intermediary",
			width : 415,
			height : 386,
			columnModel : [ {
				id : "intmNo",
				title : "Intm No",
				width : '120px',
			},{
				id : "intmName",
				title : "Intm Name",
				width : '280px',
			}],
			draggable : true,
			autoSelectOneRecord : true,
			filterText :($("txtIntermediary").readAttribute("lastValidValue") != $F("txtIntermediary") ? nvl($F("txtIntermediary"),"%") : "%"),
			onSelect : function(row) {
				if(objGIPIS200.intmNo != unescapeHTML2(row.intmNo)){
					changeParam();
				}
				$("txtIntermediary").value = unescapeHTML2(row.intmName);					
				$("txtIntermediary").setAttribute("lastValidValue", unescapeHTML2(row.intmName));
				objGIPIS200.intmNo=unescapeHTML2(row.intmNo);
				objGIPIS200.intmName=unescapeHTML2(row.intmName);				
			},
			onCancel : function() {
				$("txtIntermediary").value = $("txtIntermediary").readAttribute("lastValidValue");
			},
			onUndefinedRow : function() {
				customShowMessageBox("No record selected.", imgMessage.INFO,
						"txtIntermediary");		
				$("txtIntermediary").value = $("txtIntermediary").readAttribute("lastValidValue");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();
			}
		});
	}	
		
	function checkViewProdDtls(){
		new Ajax.Request(contextPath+"/GIPIPolbasicController", {
			parameters: {
						action : "checkViewProdDtls"						
						},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				showNotice("Processing information, please wait...");
			},
			onComplete: function(response){
				hideNotice();				
				var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
				if (checkErrorOnResponse(response)){
					if(res.message!=null){
						showMessageBox(res.message, imgMessage.INFO);
					}else{
						showProductionDetails(objGIPIS200.lineCd,objGIPIS200.sublineCd,objGIPIS200.issCd,objGIPIS200.issueYy,objGIPIS200.intmNo,objGIPIS200.credIss,objGIPIS200.paramDate,objGIPIS200.fromDate,objGIPIS200.toDate,objGIPIS200.month,objGIPIS200.year,objGIPIS200.distFlag,objGIPIS200.regPolicySw);
					}							
				}	
			}
		});
	}
	
	function extractProduction(){
		new Ajax.Request(contextPath+"/GIPIPolbasicController", {
			parameters: {
						action : "extractProduction",	
						lineCd : objGIPIS200.lineCd,
						sublineCd : objGIPIS200.sublineCd,
						issCd : objGIPIS200.issCd,
						issueYy : objGIPIS200.issueYy,
						intmNo : objGIPIS200.intmNo, 
						credIss : objGIPIS200.credIss,						
						paramDate : objGIPIS200.paramDate,
						fromDate : objGIPIS200.fromDate,
						toDate : objGIPIS200.toDate,
						month : objGIPIS200.month,
						year : objGIPIS200.year,						
						distFlag : objGIPIS200.distFlag,
						regPolicySw : objGIPIS200.regPolicySw
						},
			asynchronous: false,
			evalScripts: true,
			onCreate : function() {
				showNotice("Working, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
				if (checkErrorOnResponse(response)){
					showMessageBox(res.message, imgMessage.INFO);
					$("txtTotNoOfPolicies").value = res.noOfPolicies;
					$("txtTotPremium").value = formatCurrency(res.totalPrem);
					$("txtTotSumInsured").value = formatCurrency(res.totalTsi);
					$("txtTotTax").value = formatCurrency(res.totalTax);
					$("txtTotCommission").value = formatCurrency(res.totalCommission);
					if(checkUserModule("GIPIS202")){
						enableButton("btnViewProdDtls");
						objGIPIS200.btnViewProdDtlsTag ="Y";
						changeParamTag = 1;
					}
				}				
			}
		});
	}
		
	function setInitialTotal(){
		$("txtTotNoOfPolicies").value= "0";
		$("txtTotPremium").value= "0.00";
		$("txtTotSumInsured").value= "0.00";
		$("txtTotTax").value= "0.00";
		$("txtTotCommission").value= "0.00";	
	}
	
	function getDdnMenuMonthInnerHTML(){	
		var monthStr = ['JANUARY','FEBRUARY','MARCH','APRIL','MAY','JUNE','JULY','AUGUST','SEPTEMBER','OCTOBER','NOVEMBER','DECEMBER'];
		var ddnMenuMonthInnerHTMLValue ="";
		for(var i=0; i<monthStr.length; i++){
			if(objGIPIS200.month!=""){
				if(objGIPIS200.month==monthStr[i]){
					ddnMenuMonthInnerHTMLValue = ddnMenuMonthInnerHTMLValue+"<option value=\""+monthStr[i]+"\" selected=\"selected\">"+monthStr[i]+"</option>";
					objGIPIS200.month = monthStr[i];
				}else{
					ddnMenuMonthInnerHTMLValue = ddnMenuMonthInnerHTMLValue+"<option value=\""+monthStr[i]+"\">"+monthStr[i]+"</option>";
				}
			}else{
				if(serverDate.format("mmmm").toUpperCase()==monthStr[i]){
					ddnMenuMonthInnerHTMLValue = ddnMenuMonthInnerHTMLValue+"<option value=\""+monthStr[i]+"\" selected=\"selected\">"+monthStr[i]+"</option>";
					objGIPIS200.month = monthStr[i];
				}else{
					ddnMenuMonthInnerHTMLValue = ddnMenuMonthInnerHTMLValue+"<option value=\""+monthStr[i]+"\">"+monthStr[i]+"</option>";
				}
			}			
		}
		return ddnMenuMonthInnerHTMLValue;
	}
	
	function setRdoByDate(paramDate){	
		objGIPIS200.paramDate = paramDate;
		if (paramDate== 4){
			objGIPIS200.distFlag = "D";
			$("rdoDistributed").checked = "checked";			
		}
		
		if (paramDate== 3){
			$("rowMonthYear").show();
			$("rowFromTo").hide();
			$("dDnMenuMonth").innerHTML = getDdnMenuMonthInnerHTML();
			if(objGIPIS200.year==""){
				$("txtYear").value=serverDate.format("yyyy");
				$("txtYear").setAttribute("lastValidValue", $F("txtYear"));	
				objGIPIS200.year = serverDate.format("yyyy");
			}else{
				$("txtYear").value=objGIPIS200.year;
				$("txtYear").setAttribute("lastValidValue", $F("txtYear"));	
			}
		}else{
			$("rowMonthYear").hide();
			$("rowFromTo").show();
			$("txtFromDate").value = objGIPIS200.fromDate;
			$("txtToDate").value = objGIPIS200.toDate;
		}
	}
	
	function setRdoDistribution(distFlag){	
		objGIPIS200.distFlag = distFlag;
		if (objGIPIS200.paramDate== 3){
			$("txtYear").value =serverDate.format("yyyy");			
		}
		if(objGIPIS200.paramDate== 4){
			if(distFlag=="B"||distFlag=="U"){
				showWaitingMessageBox("Only Distributed Policies have Accounting Entry Date", "I", function() {
					$("rdoDistributed").checked = "checked";
				});
				objGIPIS200.distFlag = "D";
			}	
		}
	}
			
	function initializeGIPIS200(){
		$("txtFromDate").value = objGIPIS200.fromDate;	
		$("txtToDate").value = objGIPIS200.toDate;	
		$("dDnMenuMonth").innerHTML = getDdnMenuMonthInnerHTML();
		$("txtYear").value = objGIPIS200.year;	
		$("txtLine").value = objGIPIS200.lineName;	
		$("txtSubline").value = objGIPIS200.sublineName;	
		if(objGIPIS200.credIss=="C"){
			$("rdoCreditingBranch").checked = "checked";	
		}else if(objGIPIS200.credIss=="S"){
			$("rdoIssuingSource").checked = "checked";
		}
		$("lblCredIss").innerHTML = objGIPIS200.cred;	
		$("txtIssue").value = objGIPIS200.issName;	
		$("txtIssueYear").value = objGIPIS200.issueYy;	
		$("txtIntermediary").value = objGIPIS200.intmName;	
		if(objGIPIS200.paramDate== 3){
			$("rowMonthYear").show();
			$("rowFromTo").hide();
			$("rdoByBookingDate").checked = "checked";			
		}else if(objGIPIS200.paramDate == 2){
			$("rowMonthYear").hide();
			$("rowFromTo").show();
			$("rdoByEffectivityDate").checked = "checked";	
		}else if(objGIPIS200.paramDate== 1){
			$("rowMonthYear").hide();
			$("rowFromTo").show();
			$("rdoByIssueDate").checked = "checked";	
		}else if(objGIPIS200.paramDate== 4){
			$("rowMonthYear").hide();
			$("rowFromTo").show();
			$("rdoByAccountingEntryDate").checked = "checked";	
		}
		if(objGIPIS200.regPolicySw=="Y"){
			$("chkIncSpecialPol").checked = "checked";
		}else{
			$("chkIncSpecialPol").checked = false;
		}
		if(objGIPIS200.distFlag=="D"){
			$("rdoDistributed").checked = "checked";			
		}else if(objGIPIS200.distFlag=="U"){
			$("rdoUndistributed").checked = "checked";	
		}else if(objGIPIS200.distFlag=="B"){
			$("rdoBoth").checked = "checked";	
		}
		
		$("txtTotNoOfPolicies").value = objGIPIS200.dspNoOfPolicies;	
		$("txtTotPremium").value = objGIPIS200.dspTotalPrem;	
		$("txtTotSumInsured").value = objGIPIS200.dspTotalTsi;	
		$("txtTotTax").value = objGIPIS200.dspTotalTax;	
		$("txtTotCommission").value = objGIPIS200.dspTotalCommission;
		enableButton("btnExtract");
		if(objGIPIS200.btnViewProdDtlsTag=="Y"){
			enableButton("btnViewProdDtls");
		}else{
			disableButton("btnViewProdDtls");
		}	
	}
	
	function setProdDtls(){
		objGIPIS200.dspNoOfPolicies = $("txtTotNoOfPolicies").value;
		objGIPIS200.dspTotalPrem = $("txtTotPremium").value;
		objGIPIS200.dspTotalTsi = $("txtTotSumInsured").value;
		objGIPIS200.dspTotalTax = $("txtTotTax").value;
		objGIPIS200.dspTotalCommission = $("txtTotCommission").value;
		checkViewProdDtls();
	}
	
	function validateBeforeExtract(){		
		if(objGIPIS200.paramDate!= 3){
			if($("txtFromDate").value==""||$("txtToDate").value==""){
				showWaitingMessageBox("Required fields must be entered.", "I", function() {
					$("txtFromDate").focus();
				});				
			}else{
				if (changeParamTag == 1){
					showConfirmBox("Confirmation","Data has been extracted within the specified parameter/s. Do you wish to continue extraction?", "Yes", "No",
							extractProduction,"");		
					return;
				}
				extractProduction();				
			}
		}else{
			if($("dDnMenuMonth").value==""||$("txtYear").value==""){
				showWaitingMessageBox("Required fields must be entered.", "I", function() {
					$("dDnMenuMonth").focus();
				});				
			}else{
				if (changeParamTag == 1){
					showConfirmBox("Confirmation","Data has been extracted within the specified parameter/s. Do you wish to continue extraction?", "Yes", "No",
							extractProduction,"");		
					return;
				}
				extractProduction();				
			}
		}
	}
	
	
	function initializeObjGIPIS200(){
		objGIPIS200.fromDate = "";
		objGIPIS200.toDate = "";
		objGIPIS200.month = "";
		objGIPIS200.year = "";
		objGIPIS200.lineCd="";
		objGIPIS200.lineName="";
		objGIPIS200.sublineCd="";
		objGIPIS200.sublineName="";
		objGIPIS200.credIss = "S";
		objGIPIS200.cred = "Issue Code";
		objGIPIS200.issCd = "";
		objGIPIS200.issName = "";
		objGIPIS200.issueYy = "";
		objGIPIS200.intmNo = "";
		objGIPIS200.intmName="";
		objGIPIS200.paramDate = 2;
		objGIPIS200.regPolicySw = "N";
		objGIPIS200.distFlag = "B";
		objGIPIS200.dspNoOfPolicies = "0";
		objGIPIS200.dspTotalPrem = "0.00";
		objGIPIS200.dspTotalTsi = "0.00";
		objGIPIS200.dspTotalTax = "0.00";
		objGIPIS200.dspTotalCommission = "0.00";
		objGIPIS200.btnViewProdDtlsTag = "N";
	}
			
	function changeParam(){
		disableButton("btnViewProdDtls");
		setInitialTotal();		
		changeParamTag = 0;
	}
	$("txtFromDate").observe("focus", function(){	
		var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g,"/")) :"";
		var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g,"/")) :"";
		if (toDate < fromDate && toDate != ""){
			customShowMessageBox("From Date should not be later than To Date.", "I", "txtFromDate");
			$("txtFromDate").clear();
			objGIPIS200.fromDate = "";
			return false;
		}else{
			if($F("txtFromDate") != objGIPIS200.fromDate){
				changeParam();
			}
			objGIPIS200.fromDate = $F("txtFromDate");
		}
	});
	 	
 	$("txtToDate").observe("focus", function(){
		var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g,"/")) :"";
		var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g,"/")) :"";
		if (toDate < fromDate && toDate != ""){
			customShowMessageBox("From Date should not be later than To Date.", "I", "txtToDate");
			$("txtToDate").clear();
			objGIPIS200.toDate = "";
			return false;
		}else{
			if($F("txtToDate") != objGIPIS200.toDate){
				changeParam();
			}
			objGIPIS200.toDate = $F("txtToDate");
		}				
	});
 	 	
 	$("dDnMenuMonth").observe("change",function(){	
 		$("txtYear").value="";
 		objGIPIS200.month = $F("dDnMenuMonth");
 		objGIPIS200.year="";	
 		changeParam();
 	});
	
	$("txtYear").observe("keyup", function(e) {
		if(isNaN($F("txtYear"))) {
			$("txtYear").value = (nvl($("txtYear").readAttribute("lastValidValue"), "") == "" ? "" : $("txtYear").readAttribute("lastValidValue"));
		}
	});	
	
	$("txtYear").observe("change",function(){
		$("txtYear").value=removeLeadingZero($F("txtYear"));	
		
 		if($F("txtYear").trim()==""){
 			$("txtYear").value = serverDate.format("yyyy");
 			$("txtYear").setAttribute("lastValidValue", serverDate.format("yyyy"));
 		}else if(parseInt($F("txtYear")) < 1000){
 			showWaitingMessageBox("Year format should be YYYY.", "I", function() {
 				$("txtYear").value = (nvl($("txtYear").readAttribute("lastValidValue"), "") == "" ? "" : $("txtYear").readAttribute("lastValidValue"));
 				$("txtYear").focus();
 			});	
 		}else if(isNaN($F("txtYear"))) {
			$("txtYear").value = (nvl($("txtYear").readAttribute("lastValidValue"), "") == "" ? "" : $("txtYear").readAttribute("lastValidValue"));
 		}else {						
			$("txtYear").setAttribute("lastValidValue", $F("txtYear"));	
		} 
 		objGIPIS200.year = $F("txtYear");
 		changeParam();
 	});
	
	$("rdoCreditingBranch").observe("click", function() {
		objGIPIS200.credIss = "C";
		objGIPIS200.cred = "Cred. Branch";		
		$("lblCredIss").innerHTML = "Cred. Branch";
		changeParam();
	});
	
	$("rdoIssuingSource").observe("click", function() {
		objGIPIS200.credIss = "S";
		objGIPIS200.cred = "Issue Code";
		$("lblCredIss").innerHTML = "Issue Code";	
		changeParam();
	});
	
	$("rdoByEffectivityDate").observe("click", function() {
		setRdoByDate(2);
		changeParam();
	});
	
	$("rdoByBookingDate").observe("click", function() {
		setRdoByDate(3);
		changeParam();
	});
	
	$("rdoByIssueDate").observe("click", function() {
		setRdoByDate(1);
		changeParam();
	});
	
	$("rdoByAccountingEntryDate").observe("click", function() {
		setRdoByDate(4);
		changeParam();
	});
	
	$("rdoDistributed").observe("click", function() {
		setRdoDistribution("D");
		changeParam();
	});
	
	$("rdoUndistributed").observe("click", function() {
		setRdoDistribution("U");
		changeParam();
	});
	
	$("rdoBoth").observe("click", function() {
		setRdoDistribution("B");
		changeParam();
	});
	
	$("imgSearchLine").observe("click", function() {
		getGIPIS200LineLOV();		
	});
	
	$("txtLine").observe("keyup", function() {
		$("txtLine").value = $F("txtLine").toUpperCase();
	});
	
	$("txtLine").observe("change", function() {		
		$("txtLine").value = $F("txtLine").toUpperCase();
		if($F("txtLine").trim()!=""){
			getGIPIS200LineLOV();	
		}else if($F("txtLine").trim()==""){
			$("txtLine").setAttribute("lastValidValue","");	
			$("txtLine").value="";
			objGIPIS200.lineCd="";
			objGIPIS200.lineName="";
			$("txtSubline").value="";
			objGIPIS200.sublineCd="";
			objGIPIS200.sublineName="";
			$("txtSubline").setAttribute("lastValidValue","");	
			changeParam();
		}					
	});	
	
	$("imgSearchSubline").observe("click", function() {
		if(objGIPIS200.lineCd==""){
			showWaitingMessageBox("Specify line code in which subline belongs.", "I", function() {
				$("txtSubline").value="";
				$("txtLine").focus();
			});		
		}else{
			getGIPIS200SublineLOV();
		}
	});
	
	$("txtSubline").observe("keyup", function() {
		$("txtSubline").value = $F("txtSubline").toUpperCase();
	});
	
	$("txtSubline").observe("change", function() {		
		$("txtSubline").value = $F("txtSubline").toUpperCase();
		if(objGIPIS200.lineCd==""){
			showWaitingMessageBox("Specify line code in which subline belongs.", "I", function() {
				$("txtSubline").value="";
				$("txtLine").focus();
			});		
		}else{
			if($F("txtSubline").trim()!=""){
				getGIPIS200SublineLOV();	
			}else if($F("txtSubline").trim()==""){
				$("txtSubline").setAttribute("lastValidValue","");	
				$("txtSubline").value="";
				objGIPIS200.sublineCd="";
				objGIPIS200.sublineName="";
				changeParam();
			}	
		}						
	});	
	
	$("imgSearchIssue").observe("click", function() {
		getGIPIS200IssueLOV();
	});
	
	$("txtIssue").observe("keyup", function() {
		$("txtIssue").value = $F("txtIssue").toUpperCase();
	});
	
	$("txtIssue").observe("change", function() {		
		$("txtIssue").value = $F("txtIssue").toUpperCase();
		if($F("txtIssue").trim()!=""){
			getGIPIS200IssueLOV();	
		}else if($F("txtIssue").trim()==""){
			$("txtIssue").setAttribute("lastValidValue","");	
			$("txtIssue").value="";
			objGIPIS200.issCd="";
			objGIPIS200.issName="";
			changeParam();
		}					
	});	
	
	$("imgSearchIssueYear").observe("click", function() {
		getGIPIS200IssueYearLOV();
	});
	
	$("txtIssueYear").observe("change", function() {		
		if($F("txtIssueYear").trim()!=""){
			getGIPIS200IssueYearLOV();	
		}else if($F("txtIssueYear").trim()==""){
			$("txtIssueYear").setAttribute("lastValidValue","");	
			$("txtIssueYear").value="";
			objGIPIS200.issueYy="";
			changeParam();
		}					
	});	
	
	$("imgSearchIntermediary").observe("click", function() {
		getGIPIS200IntermediaryLOV();
	});
	
	$("txtIntermediary").observe("change", function() {		
		if($F("txtIntermediary").trim()!=""){
			getGIPIS200IntermediaryLOV();	
		}else if($F("txtIntermediary").trim()==""){
			$("txtIntermediary").setAttribute("lastValidValue","");	
			$("txtIntermediary").value="";
			objGIPIS200.intmNo="";
			objGIPIS200.intmName="";
			changeParam();
		}					
	});		
	
	$("chkIncSpecialPol").observe("change", function() {		
		objGIPIS200.regPolicySw = $("chkIncSpecialPol").checked ? "Y":"N";	
		changeParam();
	});	
	
	$("btnExtract").observe("click", validateBeforeExtract);	
		
	observeAccessibleModule(accessType.BUTTON, "GIPIS202", "btnViewProdDtls", setProdDtls);
	
	observeReloadForm("reloadForm", function(){
		showViewProduction();
		initializeObjGIPIS200();
	});
	
	$("underwritingExit").observe("click", function() {
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main" , null); 		
		initializeObjGIPIS200();
	});
	initializeGIPIS200();	
} catch (e) {
	showErrorMessage("Error : ", e.message);
}
	
</script>
