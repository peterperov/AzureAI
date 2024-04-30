<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>

	<xsl:template name ="script">
		<script>

			function HideElement(id)
			{
				var x = document.getElementById(id);
				if (x.style.display === "none") {
				x.style.display = "block";
				} else {
				x.style.display = "none";
				}
			}
			
			
		</script>

	</xsl:template>


</xsl:stylesheet>
