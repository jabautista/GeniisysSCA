<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="extractOverlayDiv" name="extractOverlayDiv" style="width:600px;">
	<div class="sectionDiv" style="margin:20px 10px 10px 10px; width:580px;">
		<table border="0" style="margin:20px 20px 20px 20px; width: 540px;">
			<tr>
				<td class="rightAligned">Line</td>
				<td colspan="3">
					<input type="text" id="txtLineCd" name="txtLineCd" style="width: 50px; margin-left: 5px;" class="upper" readonly="readonly" tabindex="201" />
					<input type="text" id="txtLineName" name="txtLineName" style="width: 404px; margin-left: 2px;" class="upper" readonly="readonly" tabindex="202" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Treaty</td>
				<td colspan="3"><input type="text" id="txtTreaty" name="txtTreaty" style="width: 468px; margin-left: 5px;" class="upper" readonly="readonly" tabindex="203" /></td>
			</tr>
			<tr>
				<td class="rightAligned">Year</td>
				<td><input type="text" id="txtYear" name="txtYear" style="width: 150px; margin-left: 5px; text-align:right" class="integerNoNegativeUnformattedNoComma" maxlength="4" tabindex="204" /></td>
				<td class="rightAligned" style="width:140px;">Quarter</td>
				<td>
					<select id="selQuarter" name="selQuarter" style="width: 158px; margin-left: 5px;" tabindex="205" >
						<option value="1">1st</option>
						<option value="2">2nd</option>
						<option value="3">3rd</option>
						<option value="4">4th</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">User ID</td>
				<td><input type="text" id="txtUserIdExt" name="txtUserIdExt" style="width: 150px; margin-left: 5px;" class="upper" readonly="readonly" tabindex="206" /></td>
				<td class="rightAligned">Last Update</td>
				<td><input type="text" id="txtLastUpdateExt" name="txtLastUpdateExt" style="width: 150px; margin-left: 5px;" class="upper" readonly="readonly" tabindex="207" /></td>
			</tr>
		</table>
	</div>
	
	<div class="buttonsDiv" style="margin:10px 10px 10px 10px; width:600px;">
		<input type="button" class="button" id="btnOk" name="btnOk" value="Ok" style="width: 90px;" />
		<input type="button" class="button" id="btnReturn" name="btnReturn" value="Return" style="width: 90px;" />
	</div>
</div>

<script type="text/javascript">
	
	function populateFields(){
		$("txtLineCd").value 	= objTreaty.treatySelectedRow != null ? nvl(objTreaty.treatySelectedRow.lineCd, "") : "";
		$("txtLineName").value 	= objTreaty.treatySelectedRow != null ? unescapeHTML2(nvl(objTreaty.treatySelectedRow.lineName, "")) : "";
		$("txtTreaty").value 	= objTreaty.treatySelectedRow != null ? unescapeHTML2(nvl(objTreaty.treatySelectedRow.treatyName, "")) : "";
		$("txtYear").value 		= objTreaty.treatySelectedRow != null ? nvl(objTreaty.treatySelectedRow.year, "") : "";
		$("selQuarter").value 	= objTreaty.treatySelectedRow != null ? unescapeHTML2(nvl(objTreaty.treatySelectedRow.qtr, "")) : "";
		$("txtUserIdExt").value = nvl(objTreaty.currentUserId, "");
		$("txtLastUpdateExt").value = dateFormat(new Date(), 'mm-dd-yyyy');
	}
	
	function proceedToExtraction(){
		try {
			var month3 = parseInt($F("selQuarter")) * parseInt("3");
			var month2 = month3 - 1;
			var month1 = month2 - 1;
			new Ajax.Request(contextPath + "/GIACReinsuranceReportsController",{
				method: "POST",
				parameters : {
					action	: "deleteAndExtract",
					lineCd	: nvl(objTreaty.treatySelectedRow.lineCd, ""),
					shareCd	: nvl(objTreaty.treatySelectedRow.shareCd, ""),
					treatyYy: nvl(objTreaty.treatySelectedRow.treatyYy, ""),
					year	: $F("txtYear"), //nvl(objTreaty.treatySelectedRow.year, ""),
					qtr		: $F("selQuarter"), //nvl(objTreaty.treatySelectedRow.qtr, ""),
					month1	: month1,
					month2	: month2,
					month3	: month3
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function (){
					showNotice("Deleting previously extracted data, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						var resp = JSON.parse(response.responseText);
						if(resp.recordCount == 0 || resp.recordCount == null){
							showMessageBox("Extraction finished. No records extracted.", "I");
						} else {
							showMessageBox("Extraction finished. " + resp.recordCount +" records extracted.", "I");
						}
					}
				}
			});
		} catch(e){
			showErrorMessage("proceedToExtraction: ", e);
		}
	}
	
	$("btnOk").observe("click", function(){
		if($F("txtYear") != ""){
			try {
				var month3 = parseInt($F("selQuarter")) * parseInt("3");
				var month2 = month3 - 1;
				var month1 = month2 - 1;
				new Ajax.Request(contextPath + "/GIACReinsuranceReportsController",{
					method: "POST",
					parameters : {
						action	: "checkForPrevExtract",
						lineCd	: nvl(objTreaty.treatySelectedRow.lineCd, ""),
						shareCd	: nvl(objTreaty.treatySelectedRow.shareCd, ""),
						treatyYy: nvl(objTreaty.treatySelectedRow.treatyYy, ""),
						year	: $F("txtYear"), //nvl(objTreaty.treatySelectedRow.year, ""),
						qtr		: $F("selQuarter"), //nvl(objTreaty.treatySelectedRow.qtr, ""),
						month1	: month1,
						month2	: month2,
						month3	: month3
					},
					asynchronous: false,
					evalScripts: true,
					onCreate: function (){
						showNotice("Checking for previously extracted records, please wait...");
					},
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							var resp = JSON.parse(response.responseText);
							if(resp.hasPrevExt == "TRUE"){
								showConfirmBox2("Confirmation", "Data for this treaty has previously been extracted. Do you still want to continue?", "Ok", "Cancel", proceedToExtraction, "");
							} else {
								if(resp.recordCount == 0 || resp.recordCount == null){
									showMessageBox("Extraction finished. No records extracted.", "I");
								} else {
									showMessageBox("Extraction finished. " +rep.recordCount +" records extracted.", "I");
								}
							}
						}
					}
				});
			} catch(e){
				showErrorMessage("btnOk onClick: ", e);
			}
		} else {
			showMessageBox("Please enter value for year.", "I");
		}
	});
	
	$("btnReturn").observe("click", function(){
		extractOverlay.close();
	});
	
	initializeAll();
	populateFields();
</script>