<%
				String displayCOCAddtlCols = "";
				String pluginExists = "";
				try {
					Class.forName("com.isap.api.COCRegistration", false, this.getClass().getClassLoader());
					displayCOCAddtlCols = "block";
					pluginExists = "Y";	
				}catch (Exception e)
				{
					displayCOCAddtlCols = "none";
					pluginExists = "N";
				}
				request.setAttribute("pluginExists", pluginExists);
				request.setAttribute("isDisplayed", displayCOCAddtlCols);
%>
<div id="authDiv" style="display:${isDisplayed};">
<input type="hidden" id="pluginExists" name="pluginExists" value="${pluginExists}">
	<div id="authenticateMainDiv" name="authenticateMainDiv"
		style="float: left; width: 310px; margin-left: 4.5%; margin-top: 5px; height: 10px auto; display: none;">
		<div style="float: left; text-align: left; width: 20px;">
			<input type="checkbox" id="authenticateCOC" name="authenticateCOC"
				style="width: 18px;" /> <input type="hidden" id="allowAuthenticateCOC" name="allowAuthenticateCOC" value="${authenticateCOC}">
				</div>
		<div style="float: left; text-align: left; width: 80%">
			<label>Authenticate COC/s?</label>
		</div>
	</div>
</div>

<script>

</script>