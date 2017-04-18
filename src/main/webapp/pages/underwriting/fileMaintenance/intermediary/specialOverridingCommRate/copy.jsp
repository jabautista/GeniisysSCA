<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div style="width: 598px;" id="copyIntDiv">
	<div class="sectionDiv" id="copyDiv" style="margin-top: 4px;">
		<table align="center" style="margin-bottom: 10px;">
			<tr>
				<td colspan="3"><h4 align="center">COPY FROM</h4></td>
			</tr>
			<tr>
				<td><label for="txtCopyFromIntmNo" style="float: right; margin: 0 5px 2px 0;">Intermediary</label></td>
				<td>
					<span class="lovSpan required" style="width: 91px; margin: 0px; height: 21px;">
						<input type="text" id="txtCopyFromIntmNo" ignoreDelKey="true" style="text-align: right; width: 66px; float: left; border: none; height: 15px; margin: 0;" class="required integerNoNegativeUnformatted" tabindex="101" lastValidValue="" maxlength="12"/> 
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgCopyFromIntm" alt="Go" style="float: right;" tabindex="102"/>
					</span>
				</td>
				<td>
					<input type="text" id="txtCopyFromIntmName" style="margin: 0; width: 300px;" readonly="readonly"/>
				</td>
			</tr>
			<tr>	
				<td><label for="txtCopyFromIssCd" style="float: right; margin: 0 5px 2px 0;">Issuing Source</label></td>
				<td>
					<span class="lovSpan required" style="width: 91px; margin: 0px; height: 21px;">
						<input type="text" id="txtCopyFromIssCd" ignoreDelKey="true" style="width: 50px; float: left; border: none; height: 15px; margin: 0;" class="required" tabindex="101" lastValidValue="" maxlength="2"/> 
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgCopyFromIss" alt="Go" style="float: right;" tabindex="102"/>
					</span>
				</td>
				<td>
					<input type="text" id="txtCopyFromIssName" style="margin: 0; width: 300px;" readonly="readonly"/>
				</td>
			</tr>
		</table>
	</div>
	
	
	
	<div class="sectionDiv" style="margin-top: 2px;">
		<table align="center" style="margin-bottom: 10px;">
			<tr>
				<td colspan="3"><h4 align="center">COPY TO</h4></td>
			</tr>
			<tr>
				<td><label for="txtCopyToIntmNo" style="float: right; margin: 0 5px 2px 0;">Intermediary</label></td>
				<td>
					<span class="lovSpan required" style="width: 91px; margin: 0px; height: 21px;">
						<input type="text" id="txtCopyToIntmNo" ignoreDelKey="true" style="text-align: right; width: 66px; float: left; border: none; height: 15px; margin: 0;" class="required integerNoNegativeUnformatted" tabindex="101" lastValidValue="" maxlength="12"/> 
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgCopyToIntm" alt="Go" style="float: right;" tabindex="102"/>
					</span>
				</td>
				<td>
					<input type="text" id="txtCopyToIntmName" style="margin: 0; width: 300px;" readonly="readonly"/>
				</td>
			</tr>
			<tr>	
				<td><label for="txtCopyToIssCd" style="float: right; margin: 0 5px 2px 0;">Issuing Source</label></td>
				<td>
					<span class="lovSpan required" style="width: 91px; margin: 0px; height: 21px;">
						<input type="text" id="txtCopyToIssCd" ignoreDelKey="true" style="width: 50px; float: left; border: none; height: 15px; margin: 0;" class="required" tabindex="101" lastValidValue="" maxlength="2"/> 
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgCopyToIss" alt="Go" style="float: right;" tabindex="102"/>
					</span>
				</td>
				<td>
					<input type="text" id="txtCopyToIssName" style="margin: 0; width: 300px;" readonly="readonly"/>
				</td>
			</tr>
		</table>
	</div>
	
	
	<div style="float: none; text-align: center;">
		<input type="button" class="button" value="Copy" id="btnCopy" style="width: 90px; margin-top: 7px;" />
		<input type="button" class="button" value="Cancel" id="btnCancelCopy" style="width: 90px; margin-top: 7px;" />
	</div>
</div>
<script type="text/javascript">
	try {
		
		function getCopyIntmLov(x) {
			
			var searchString;
			
			if(x == "from")
				searchString = ($("txtCopyFromIntmNo").readAttribute("lastValidValue").trim() != $F("txtCopyFromIntmNo").trim() ? $F("txtCopyFromIntmNo").trim() : "");
			else
				searchString = ($("txtCopyToIntmNo").readAttribute("lastValidValue").trim() != $F("txtCopyToIntmNo").trim() ? $F("txtCopyToIntmNo").trim() : "");
				
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGIACS153IntmNoLOV",
					searchString : searchString,
					page : 1
				},
				title : "List of Intermediaries",
				width : 480,
				height : 386,
				columnModel : [ 
	            	{
						id : "intmNo",
						title : "Intm No.",
						width : 120,
						align : "right",
						titleAlign : "right"
					},
					{
						id : "intmName",
						title : "Intm Name",
						width : 345
					}
				],
				draggable : true,
				autoSelectOneRecord: true,
				filterText : searchString,
				onSelect : function(row) {
					
					if(x == "from") {
						$("txtCopyFromIntmNo").value = row.intmNo;
						$("txtCopyFromIntmName").value = unescapeHTML2(row.intmName);
						$("txtCopyFromIntmNo").setAttribute("lastValidValue", $F("txtCopyFromIntmNo"));
						$("txtCopyFromIntmName").setAttribute("lastValidValue", $F("txtCopyFromIntmName"));
						$("txtCopyFromIssCd").focus();
					} else {
						$("txtCopyToIntmNo").value = row.intmNo;
						$("txtCopyToIntmName").value = unescapeHTML2(row.intmName);
						$("txtCopyToIntmNo").setAttribute("lastValidValue", $F("txtCopyToIntmNo"));
						$("txtCopyToIntmName").setAttribute("lastValidValue", $F("txtCopyToIntmName"));
						$("txtCopyToIssCd").focus();
					}
					
									
				},
				onCancel : function () {
					
					if(x == "from") {						
						$("txtCopyFromIntmNo").value = $("txtCopyFromIntmNo").readAttribute("lastValidValue");
						$("txtCopyFromIntmName").value = $("txtCopyFromIntmName").readAttribute("lastValidValue");
						$("txtCopyFromIntmNo").focus();
					} else {
						$("txtCopyToIntmNo").value = $("txtCopyToIntmNo").readAttribute("lastValidValue");
						$("txtCopyToIntmName").value = $("txtCopyToIntmName").readAttribute("lastValidValue");
						$("txtCopyToIntmNo").focus();
					}
				},
				onUndefinedRow : function(){
					if(x == "from") {						
						$("txtCopyFromIntmNo").value = $("txtCopyFromIntmNo").readAttribute("lastValidValue");
						$("txtCopyFromIntmName").value = $("txtCopyFromIntmName").readAttribute("lastValidValue");
						$("txtCopyFromIntmNo").focus();
					} else {
						$("txtCopyToIntmNo").value = $("txtCopyToIntmNo").readAttribute("lastValidValue");
						$("txtCopyToIntmName").value = $("txtCopyToIntmName").readAttribute("lastValidValue");
						$("txtCopyToIntmNo").focus();
					}
					ShowMessageBox("No record selected.", imgMessage.INFO);
				}
			});
		}
		
		$("imgCopyFromIntm").observe("click", function(){
			getCopyIntmLov("from");
		});
		
		$("imgCopyToIntm").observe("click", function(){
			getCopyIntmLov("to");
		});
		
		$("txtCopyFromIntmNo").observe("change", function(){
			if(this.value.trim() == ""){
				$("txtCopyFromIntmNo").clear();
				$("txtCopyFromIntmName").clear();
				$("txtCopyFromIntmNo").setAttribute("lastValidValue", $F("txtCopyFromIntmNo"));
				$("txtCopyFromIntmName").setAttribute("lastValidValue", $F("txtCopyFromIntmName"));
				return;
			} 
			
			if($F("txtCopyFromIntmNo").trim() != $("txtCopyFromIntmNo").readAttribute("lastValidValue")){
				getCopyIntmLov("from");
			}
		});
		
		$("txtCopyToIntmNo").observe("change", function(){
			if(this.value.trim() == ""){
				$("txtCopyToIntmNo").clear();
				$("txtCopyToIntmName").clear();
				$("txtCopyToIntmNo").setAttribute("lastValidValue", $F("txtCopyToIntmNo"));
				$("txtCopyToIntmName").setAttribute("lastValidValue", $F("txtCopyToIntmName"));
				return;
			}
				
			if($F("txtCopyToIntmNo").trim() != $("txtCopyToIntmNo").readAttribute("lastValidValue")){
				getCopyIntmLov("to");
			}
		});
		
		function getCopyIssLov(x) {
			
			var searchString;
			
			if(x == "from")
				searchString = ($("txtCopyFromIssCd").readAttribute("lastValidValue").trim() != $F("txtCopyFromIssCd").trim() ? $F("txtCopyFromIssCd").trim() : "");
			else
				searchString = ($("txtCopyToIssCd").readAttribute("lastValidValue").trim() != $F("txtCopyToIssCd").trim() ? $F("txtCopyToIssCd").trim() : "");
			
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGiiss202IssLov",
					filterText : searchString,
					lineCd : $F("txtLineCd"),
					page : 1
				},
				title : "List of Issuing Sources",
				width : 480,
				height : 386,
				columnModel : [ 
	            	{
						id : "issCd",
						title : "Iss Cd",
						width : 120
					},
					{
						id : "issName",
						title : "Iss Name",
						width : 345
					}
				],
				draggable : true,
				autoSelectOneRecord: true,
				filterText : searchString,
				onSelect : function(row) {
					
					if(x == "from") {
						$("txtCopyFromIssCd").value = unescapeHTML2(row.issCd);
						$("txtCopyFromIssName").value = unescapeHTML2(row.issName);
						$("txtCopyFromIssCd").setAttribute("lastValidValue", $F("txtCopyFromIssCd"));
						$("txtCopyFromIssName").setAttribute("lastValidValue", $F("txtCopyFromIssName"));
						$("txtCopyToIntmNo").focus();
					} else {
						$("txtCopyToIssCd").value = unescapeHTML2(row.issCd);
						$("txtCopyToIssName").value = unescapeHTML2(row.issName);
						$("txtCopyToIssCd").setAttribute("lastValidValue", $F("txtCopyToIssCd"));
						$("txtCopyToIssName").setAttribute("lastValidValue", $F("txtCopyToIssName"));
						$("btnCopy").focus();
					}
					
									
				},
				onCancel : function () {
					
					if(x == "from") {						
						$("txtCopyFromIssCd").value = $("txtCopyFromIssCd").readAttribute("lastValidValue");
						$("txtCopyFromIssName").value = $("txtCopyFromIssName").readAttribute("lastValidValue");
						$("txtCopyFromIssCd").focus();
					} else {
						$("txtCopyToIssCd").value = $("txtCopyToIssCd").readAttribute("lastValidValue");
						$("txtCopyToIssName").value = $("txtCopyToIssName").readAttribute("lastValidValue");
						$("txtCopyToIssCd").focus();
					}
				},
				onUndefinedRow : function(){
					if(x == "from") {						
						$("txtCopyFromIssCd").value = $("txtCopyFromIssCd").readAttribute("lastValidValue");
						$("txtCopyFromIssName").value = $("txtCopyFromIssName").readAttribute("lastValidValue");
						$("txtCopyFromIssCd").focus();
					} else {
						$("txtCopyToIssCd").value = $("txtCopyToIssCd").readAttribute("lastValidValue");
						$("txtCopyToIssName").value = $("txtCopyToIssName").readAttribute("lastValidValue");
						$("txtCopyToIssCd").focus();
					}
					ShowMessageBox("No record selected.", imgMessage.INFO);
				}
			});
		}
		
		$("imgCopyFromIss").observe("click", function(){
			getCopyIssLov("from");
		});
		
		$("imgCopyToIss").observe("click", function(){
			getCopyIssLov("to");
		});
		
		$("txtCopyFromIssCd").observe("change", function(){
			if(this.value.trim() == ""){
				$("txtCopyFromIssCd").clear();
				$("txtCopyFromIssName").clear();
				$("txtCopyFromIssCd").setAttribute("lastValidValue", $F("txtCopyFromIssCd"));
				$("txtCopyFromIssName").setAttribute("lastValidValue", $F("txtCopyFromIssName"));
				return;
			}
				
			if($F("txtCopyFromIssCd").trim() != $("txtCopyFromIssCd").readAttribute("lastValidValue")){
				getCopyIssLov("from");
			}
		});
		
		$("txtCopyToIssCd").observe("change", function(){
			if(this.value.trim() == ""){
				$("txtCopyToIssCd").clear();
				$("txtCopyToIssName").clear();
				$("txtCopyToIssCd").setAttribute("lastValidValue", $F("txtCopyToIssCd"));
				$("txtCopyToIssName").setAttribute("lastValidValue", $F("txtCopyToIssName"));
				return;
			}
				
			if($F("txtCopyToIssCd").trim() != $("txtCopyToIssCd").readAttribute("lastValidValue")){
				getCopyIssLov("to");
			}
		});
		
		function copy(){
			new Ajax.Request(contextPath+"/GIISSplOverrideRtController", {
				method: "POST",
				parameters : {
					action : "copyGiiss202",
					intmNoFrom : removeLeadingZero($F("txtCopyFromIntmNo")),
					issCdFrom : removeLeadingZero($F("txtCopyFromIssCd")),
					intmNoTo : removeLeadingZero($F("txtCopyToIntmNo")),
					issCdTo : removeLeadingZero($F("txtCopyToIssCd")),
					lineCd : objGiiss202.lineCd,
					sublineCd : objGiiss202.sublineCd},
				onCreate : showNotice("Processing, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						showWaitingMessageBox("Records copied.", "S", function(){
							
							$("txtIntmNo").value = $F("txtCopyToIntmNo");
							$("txtIntmName").value = $F("txtCopyToIntmName");
							$("txtIssCd").value = $F("txtCopyToIssCd");
							$("txtIssName").value = $F("txtCopyToIssName");

							tbgSplOverrideRt.url = contextPath+"/GIISSplOverrideRtController?action=getGiiss202RecList&intmNo=" + removeLeadingZero($F("txtIntmNo"))
								+ "&issCd=" + $F("txtIssCd") + "&lineCd=" + $F("txtLineCd") + "&sublineCd=" + $F("txtSublineCd");
							tbgSplOverrideRt._refreshList();
							
							overlayCopy.close();
							delete overlayCopy;
						});				
					}
				}
			});
		}
		
		$("btnCopy").observe("click", function(){
			if(checkAllRequiredFieldsInDiv("copyIntDiv"))
				copy();
		});
		
		$("btnCancelCopy").observe("click", function(){
			overlayCopy.close();
			delete overlayCopy;
		});
		
		initializeAll();
		
		$("txtCopyFromIntmNo").focus();
		
	} catch (e) {
		showErrorMessage("Copy", e);
	}
</script>