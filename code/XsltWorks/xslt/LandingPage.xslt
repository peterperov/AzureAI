<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>

	<xsl:import href="scripts.xslt"/>	
	
	<xsl:output method = "html" encoding="UTF-8" />
	<xsl:param name="arg1"/>
	

	<xsl:template match="/">

		<html>
			<head>
				<title>Process Report</title>
				<meta charset="UTF-8"/>
				<style>
					BODY
					{
					FONT-FAMILY: Calibri;
					}
					td
					{
					margin: 2px;
					padding: 2px;
					}
					.gray
					{
					background-color: #e8e8e8;
					}
				</style>
				<script>
					function btnClickAction(name)
					{
					window.chrome.webview.postMessage(name);
					}
				
					function btnClickTranslate()
					{
						
						window.chrome.webview.postMessage("translateto " + document.getElementById("seltranslate").value);
					}
				
				</script>
				<xsl:call-template name="script" />
			</head>
			<body>
				<!--
				<h2>arg1 : <xsl:value-of select="$arg1"/></h2>
				
				file:///
				<xsl:copy-of select="ArrayOfFileItem" />
-->
				<h1>Azure AI Services</h1>

				<hr />
				<h2>Original Video</h2>
				<hr />
				<xsl:apply-templates select="//FileItem[Type='video']" mode="video">
				</xsl:apply-templates>

				<hr />
				<a href="#" onclick="HideElement('extractedaudio');return false;">
					<h2>Extracted Audio</h2>
				</a>
				<div id="extractedaudio" style="display:none">
					<hr />
					<table>
						<xsl:apply-templates select="//FileItem[Type='audio']" mode="audio">
						</xsl:apply-templates>
					</table>
				</div>
				<hr />
				
				<a href="#" onclick="HideElement('speech2text');return false;">
					<h2>Azure Speech Recogniser - Speech to Text Recognition</h2> 
				</a>
				<div id="speech2text" style="display:none">
				<hr />
				<xsl:apply-templates select="//FileItem[Type='text']" mode="text">
				</xsl:apply-templates>
				</div>
					
				<hr />
				<a href="#" onclick="HideElement('summarization');return false;">
					<h2>Azure OpenAI ChatGPT Service - Summary</h2>
				</a>
				<div id="summarization" style="display:none">
					<hr />
					<xsl:apply-templates select="//FileItem[Type='summary_all']" mode="text">
					</xsl:apply-templates>
				</div>

				
				<hr />
				<!-- *******************************************************************
				translation 
				 style="display:none"
				******************************************************************* -->
				<a href="#" onclick="HideElement('translation');return false;">
					<h2>Azure Translator Service - Summary translated</h2>
				</a>
				<div id="translation">
					<hr />

					<span>
						<b>Add Translation: </b>
						<select id="seltranslate">
							<xsl:apply-templates select="//translation_languages/language" mode="languagepicker" />
						</select>
						<input type="button" onclick="btnClickTranslate();return false" value="translate"/>
					</span>
					<br />
					
					
					<xsl:apply-templates select="//FileItem[Type='translated_summary']" mode="translatedtext">
					</xsl:apply-templates>
				</div>
				
				<hr />
				<a href="#" onclick="HideElement('summaryaudio');return false;">
					<h2>Azure Text to Speech - Summary Audio</h2>
				</a>
				<div id="summaryaudio" style="display:none">
					<hr />
					<table>
						<xsl:apply-templates select="//FileItem[Type='summary_audio']" mode="audio">
						</xsl:apply-templates>
					</table>
				</div>

				<hr />
				<br />
				
				<a href="#" onclick="HideElement('debuginfo');return false;">debug</a>
				<div id="debuginfo" style="display:none">
					<textarea readonly="true">
						<xsl:copy-of select="."/>
					</textarea>
				</div>

			</body>

		</html>

	</xsl:template>


	<xsl:template match="FileItem" mode="translatedtext">
		
		<xsl:variable name="id">translatedtext<xsl:value-of select="position()"/></xsl:variable>
		<br />
		<a href="#" onclick="HideElement('{$id}');return false;"> <b><xsl:value-of select="LanguageName"/></b> </a>
		<br />
		<div id="{$id}" style="display:none">
		<br />
		<textarea rows="10" cols="50">
			<xsl:value-of select="Content"/>
		</textarea>
		</div>

	</xsl:template>
	
	
	<xsl:template match="FileItem" mode="text">
		
		<xsl:variable name="id">text<xsl:value-of select="position()"/></xsl:variable>

		<br />
		<b><xsl:value-of select="Name"/></b>
		<br />
		<div id="{$id}">
		<br />

		<textarea rows="10" cols="50">
			<xsl:value-of select="Content"/>
		</textarea>
		</div>

		<br />
	</xsl:template>

	<xsl:template match="FileItem" mode="audio">

		<tr>
			<td>
				<audio controls="true">
					<source type="audio/wav">
						<xsl:attribute name="src">
							file:///<xsl:value-of select="FileName/text()"/>
						</xsl:attribute>
					</source>
				</audio>
			</td>
			<td>
				<b>
					<xsl:value-of select="Name"/>
				</b>
			</td>

		</tr>

	</xsl:template>

	<xsl:template match="FileItem" mode="video">
		<b>
			<xsl:value-of select="Name"/>
		</b>
		<br />
<!--
		<xsl:value-of select="FileName"/>
-->
		<video controls="true" width="600">
			<source type="audio/wav">
				<xsl:attribute name="src">
					file:///<xsl:value-of select="FileName/text()"/>
				</xsl:attribute>
			</source>
		</video>
		<br />

	</xsl:template>

	
	<xsl:template match="language" mode="languagepicker">

		<option>
			<xsl:attribute name="value">
				<xsl:value-of select="@key" />
			</xsl:attribute>
			<xsl:value-of select="@name" />
		</option>
			

	
	</xsl:template>


</xsl:stylesheet>


