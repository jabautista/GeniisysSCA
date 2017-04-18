<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>

<div id="batchDistParameterDiv" name="batchDistParameterDiv" style="width: 497px;">
	<div id="parameterDiv1" name="parameterDiv1" class="sectionDiv" style="padding-top: 15px; padding-bottom: 15px;">
		<table align="center">
			<tr>
				<td class="rightAligned" style="width: 30px;">From</td>
				<td>
					<div style="border: 1px solid gray; height: 21px; width: 100px; background-color: white; margin-left: 5px;">
						<input type="text" id="txtFromDate" name="txtFromDate" value="" style="width: 70px; height: 12px; border: none; background-color: white;"/>
						<img id="hrefFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtFromDate'),this, null);" alt="Inception Date" />
					</div>
				</td>
				<td class="rightAligned" style="width: 30px;">To</td>
				<td>
					<div style="border: 1px solid gray; height: 21px; width: 100px; background-color: white; margin-left: 5px;">
						<input type="text" id="txtToDate" name="txtToDate" value="" style="width: 70px; height: 12px; border: none; background-color: white;">
						<img id="hrefToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtToDate'),this, null);" alt="Inception Date" />
					</div>
				</td>
				<td class="rightAligned">
					<div style="margin-left: 25px;">
						<select id="dateType" name="dateType" style="width: 120px; height: 22px;">
							<option value="issueDate">Issue Date</option>
							<option value="effDate">Effectivity Date</option>
							<option value="expiryDate">Expiry Date</option>
						</select>
					</div>
				</td>
			</tr>
		</table>
	</div>
	<div id="parameterDiv2" name="parameterDiv2" class="sectionDiv" style="padding-bottom: 15px; padding-top: 15px; margin-bottom: 10px;">
		<table align="center">
			<tr>
				<td class="rightAligned">Line Code</td>
				<td class="leftAligned">
					<select id="lineCd" name="lineCd" style="width: 200px;" class="required">
						<option value=""></option>
						<c:forEach var="line" items="${lineListing}">
							<option value="${line.lineCd}">${line.lineName}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Subline Code</td>
				<td class="leftAligned">
					<select id="sublineCd" name="sublineCd" style="width: 200px;">
						<option value=""></option>
						<c:forEach var="subline" items="${sublineListing}">
							<option value="${subline.sublineCd}" lineCd="${subline.lineCd}">${subline.sublineName}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Branch Code</td>
				<td class="leftAligned">
					<select id="issCd" name="issCd" style="width: 200px;">
						<option value=""></option>
						<c:forEach var="iss" items="${issCdListing}">
							<option value="${iss.issCd}">${iss.issName}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">TSI Amount</td>
				<td class="leftAligned">
					<select id="equateList" name="equateList" style="width: 54px;">
						<option value=""></option>
						<option value="greaterEqual">&#62=</option>
						<option value="lessEqual">&#60=</option>
						<option value="equals">=</option>
					</select>
					<input type="text" id="inputTsiAmt" name="inputTsiAmt" style="width: 134px;" class="money"></input>
				</td>
			</tr>
		</table>
	</div>
	<div align="center" style="margin-top: 10px;">
		<input type="button" id="btnOkParam" 	 name="btnOkParam" 		value="Ok" 		class="button"/>
		<input type="button" id="btnCancelParam" name="btnCancelParam" 	value="Cancel" 	class="button"/>
	</div>
</div>

<script type="text/javascript">
	initializeAllMoneyFields();
	addStyleToInputs();
	
	$("btnCancelParam").observe("click", function(){
		//Modalbox.hide();
		overlayBatchParameter.close();
	});

	$("btnOkParam").observe("click", function(){
		if(validateParameters()){
			giuwPolDistPolbasicVTableGrid.objFilter = getObjFilter();
			var mtgId = giuwPolDistPolbasicVTableGrid._mtgId;
			var filterBy = $('mtgFilterBy'+mtgId);
			var filterText = $('mtgFilterText'+mtgId);
			$('mtgFilterText'+mtgId).clear();
			for (var property in giuwPolDistPolbasicVTableGrid.objFilter){
				for(var i=0; i<filterBy.options.length; i++){    					
					if(property == filterBy.options[i].value){
						filterText.value+=filterBy.options[i].text+"="+giuwPolDistPolbasicVTableGrid.objFilter[property]+";";
					}
				}
			}
				
			/*fireEvent($('mtgBtnAddFilter'+mtgId), "click");
			fireEvent($('mtgBtnOkFilter'+mtgId), "click");*/ // moved inside Ajax : shan 08.29.2014
			
			new Ajax.Request(contextPath+"/GIUWDistBatchController", {
				parameters: {
					action: 	"getPoliciesByParam",
					moduleId:	"GIUWS015",
					filter:		prepareJsonAsParameter(giuwPolDistPolbasicVTableGrid.objFilter)
				},
				onCreate: showNotice("Fetching records, please wait..."),
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						fireEvent($('mtgBtnAddFilter'+mtgId), "click");
						fireEvent($('mtgBtnOkFilter'+mtgId), "click");
						objGIUWS015.tempTaggedRecords = JSON.parse(response.responseText);
						for (var a=0; a<objGIUWS015.tempTaggedRecords.length; a++){
							objGIUWS015.tempTaggedRecords[a].batchIdTag = true;
						}
						objGIUWS015.filterByParam = true;	// shan 08.06.2014
						giuwPolDistPolbasicVTableGrid.afterRender(); // shan 08.06.2014
						overlayBatchParameter.close();
					}
				}
			});
			//Modalbox.hide();
		}
	});

	function getObjFilter(){
		var obj = new Object();
		if($F("lineCd") != "")	 obj.lineCd    = escapeHTML2($F("lineCd"));
		if($F("sublineCd") != "")obj.sublineCd = escapeHTML2($F("sublineCd"));
		if($F("issCd") != "")	 obj.issCd 	   = escapeHTML2($F("issCd"));
		if($("txtFromDate").value != "" && $("txtToDate").value != ""){
			obj.dateType = escapeHTML2($F("dateType"));
			obj.fromDate = $("txtFromDate").value;
			obj.toDate = $("txtToDate").value;
		}
		if($F("equateList") != "" && $("inputTsiAmt").value != ""){ 
			obj.equateTsi = escapeHTML2($F("equateList"));
			obj.tsiAmt = unformatCurrencyValue($("inputTsiAmt").value);
		} 
		return obj;
	}

	function validateParameters(){
		if($F("lineCd") == ""){
			showMessageBox("Please enter line code for batch distribution.", "I");
			return false;
		}else if($("txtFromDate").value != "" && $("txtToDate").value == ""){
			showMessageBox("Please enter to date for batch distribution.", "I");
			return false;
		}else if($("txtFromDate").value == "" && $("txtToDate").value != ""){
			showMessageBox("Please enter from date for batch distribution.", "I");
			return false;
		}
		return true;
	}

	function filterSublineCd(lineCd){
		(($$("select#sublineCd option[disabled='disabled']")).invoke("show")).invoke("removeAttribute", "disabled");
		(($$("select#sublineCd option:not([lineCd='" +lineCd+ "'])")).invoke("hide")).invoke("setAttribute", "disabled", "disabled");
		$("sublineCd").options[0].show();
		$("sublineCd").options[0].disabled = false;
		$("sublineCd").value = "";
	}

	$("txtFromDate").observe("blur", function(){
		if(this.value != ""){
			checkDate("txtFromDate");
		}
	});

	$("txtToDate").observe("blur", function(){
		if(this.value != ""){
			checkDate("txtToDate");
		}
	});

	$("lineCd").observe("change", function(){
		filterSublineCd(this.value);
	});

	filterSublineCd("");
	
</script>