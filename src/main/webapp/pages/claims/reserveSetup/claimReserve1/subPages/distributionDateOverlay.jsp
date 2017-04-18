<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="distDateMainDiv">
	<div id="distDateDiv" name="statusDiv" style="margin-top: 10px; height: 85px; width: 99.5%;" class="sectionDiv" align="center">
		<div style='margin-top: 5px; float: left; width: 100%' align="center">
			<table style="margin-top: 25px;">
				<tr>
					<td>
						<label id="lblMessage" style='width: 100%; float: left; margin-top: 5px; line-height: 17px; font-family: Verdana; font-size: 11px;'>Distribution Date</label>
					</td>
					<td>
						<div id="txtDistDateDiv" name="txtDistDateDiv" style="float: left; width: 155px;" class="withIconDiv">
							<input style="width: 130px;" id="txtDistDate" name="txtDistDate" type="text" value="" class="withIcon" readonly="readonly" />
							<img id="hrefDistDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Distribution Date"  />
						</div>
					</td>
				</tr> 
			</table>
		</div>
	</div>
	<div align="center">
		<input type="button" class="button" id="okDistDateBtn" value="Ok" style="width: 100px;margin-top: 10px; margin-bottom: 10px;">
		<input type="button" class="button" id="cancelDistDateBtn" value="Cancel" style="width: 100px;margin-top: 10px; margin-bottom: 10px;">
	</div>
</div>
<script type="text/javascript">
try{
	initializeAll();
	var tempDate = dateFormat(new Date,"mm-dd-yyyy");
	var nbtEffDate =  dateFormat(objGICLClaims.polEffDate,"mm-dd-yyyy");
	
	$("txtDistDate").value = nvl(dateFormat(objGICLS024.distributionDate,"mm-dd-yyyy"), tempDate);
	
	$("okDistDateBtn").observe("click", function(){
		var a = new Date($F("txtDistDate").replace(/-/g,"/"));
		var b = new Date(objGICLClaims.strPolEffDate);
		if(compareDatesIgnoreTime(a, b)==1){
			showMessageBox("Distribution date must not be earlier than the policy's effectivity date ("+nbtEffDate+").", "I");
			return false;
		} else {
			objGICLS024.distributionDate = a;
			changeTag = 1;
			/* if(objCurrGICLClmResHist !=null){
				objCurrGICLClmResHist.distributionDate = a;
			} */ //robert
		}
		overlayGICLS024DistDate.close();
		delete overlayGICLS024DistDate;
	});
	
	$("cancelDistDateBtn").observe("click", function(){
		overlayGICLS024DistDate.close();
		delete overlayGICLS024DistDate;
	});
	
	$("hrefDistDate").observe("click", function(){
		scwShow($('txtDistDate'),this, null);
	});
	
	$("txtDistDate").observe("blur", function(){
		var a = new Date($F("txtDistDate").replace(/-/g,"/"));
		var b = new Date(objGICLClaims.strPolEffDate);
		if(compareDatesIgnoreTime(a, b)==1){
			showMessageBox("Distribution date must not be earlier than the policy's effectivity date ("+nbtEffDate+").", "I");
		}
	});
	
}catch(e){
	showErrorMessage("distribution date overlay.", e);
}
</script>