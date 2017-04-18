<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<p style="margin-left: 10px;">
	Your session has expired. Please login <span style="font-weight: bold; cursor: pointer; float: none;" id="expired" name="expired">here</span>.
</p>

<script>
	$("expired").observe("click", function ()	{
		showLogin();
		hideOverlay();
		if ($$(".dialog").size() > 0) {
			$$(".dialog").each(function (d) {
				d.hide();
			});
			$("overlay_modal").hide(); 
		}
	});

	$("welcomeUserDiv").update();
	$("mainNav").update();
	changeTag = 0;
</script>