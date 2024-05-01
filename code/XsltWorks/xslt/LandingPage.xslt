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
				
					
					function btnClickVoice()
					{
						
						window.chrome.webview.postMessage("voicewith " + document.getElementById("seltopic").value);
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

				<form  name="form1" id="form1">
				<h1>Azure AI Services</h1>
				<hr />
					
				<xsl:apply-templates select="//FileItem[Type='video']" mode="video">
				</xsl:apply-templates>

				<hr />
				<a href="#" onclick="HideElement('extractedaudio');return false;">
					<h4>Extracted Audio</h4>
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
					<h4>Azure Speech Recogniser - Speech to Text Recognition</h4> 
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
					
				<!-- *******************************************************************
				voice in a language
				******************************************************************* -->					
						
				<a href="#" onclick="HideElement('summaryaudio');return false;">
					<h2>Azure Text to Speech - Summary Audio</h2>
				</a>
				<div id="summaryaudio" style="display:none">

					
					<hr />

					<div>
					  Language:
					  &#160;
						<select name="selsubject" id="selsubject">
							<option value="" selected="selected">Select language</option>
						</select>
						&#160;
						Voice: <select name="seltopic" id="seltopic">
						&#160;
						<option value="" selected="selected">Please select language first</option>
					  </select>
						&#160;
	
						<input type="button" onclick="btnClickVoice();return false" value="Add Voice"/>
					</div>
					
						
					<table>
						<xsl:apply-templates select="//FileItem[Type='summary_audio']" mode="audio">
						</xsl:apply-templates>
					</table>
				</div>

				<hr />
				</form>
				
				<xsl:call-template name="sel-javascript1">
				</xsl:call-template>
				<!-- 
				DEBUG
				
				
				<a href="#" onclick="HideElement('debuginfo');return false;">debug</a>
				<div id="debuginfo" style="display:none">
					<textarea readonly="true">
						<xsl:copy-of select="."/>
					</textarea>
				</div>
				
				-->

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
				<xsl:value-of select="LanguageName"/>
			</td>
			<td>
				<xsl:value-of select="VoiceName"/>
			</td>
			<td>
				<audio controls="true">
					<source type="audio/wav">
						<xsl:attribute name="src">
							file:///<xsl:value-of select="FileName/text()"/>
						</xsl:attribute>
					</source>
				</audio>
			</td>
		</tr>

	</xsl:template>

	<xsl:template match="FileItem" mode="video">
		<!--
		<b><xsl:value-of select="Name"/></b>
		-->
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

	
	<xsl:template name="sel-javascript1">
	
    <script>
    var subjectObject1 = {
      "Front-end": [
        "HTML",
        "CSS",
        "JavaScript"    
      ],
      "Back-end": [
        "PHP",
        "SQL"]
      
    },
    topicDefaultOption = new Option("Please select subject first", "");
	
	var subjectObject = {
		"Afrikaans": ["af-ZA-AdriNeural", "af-ZA-WillemNeural"],
		"Amharic": ["am-ET-MekdesNeural", "am-ET-AmehaNeural"],
		"Arabic": ["ar-AE-FatimaNeural", "ar-AE-HamdanNeural", "ar-BH-LailaNeural", "ar-BH-AliNeural", "ar-DZ-AminaNeural", "ar-DZ-IsmaelNeural", "ar-EG-SalmaNeural", "ar-EG-ShakirNeural", "ar-IQ-RanaNeural", "ar-IQ-BasselNeural", "ar-JO-SanaNeural", "ar-JO-TaimNeural", "ar-KW-NouraNeural", "ar-KW-FahedNeural", "ar-LB-LaylaNeural", "ar-LB-RamiNeural", "ar-LY-ImanNeural", "ar-LY-OmarNeural", "ar-MA-MounaNeural", "ar-MA-JamalNeural", "ar-OM-AyshaNeural", "ar-OM-AbdullahNeural", "ar-QA-AmalNeural", "ar-QA-MoazNeural", "ar-SA-ZariyahNeural", "ar-SA-HamedNeural", "ar-SY-AmanyNeural", "ar-SY-LaithNeural", "ar-TN-ReemNeural", "ar-TN-HediNeural", "ar-YE-MaryamNeural", "ar-YE-SalehNeural"],
		"Azerbaijani": ["az-AZ-BanuNeural", "az-AZ-BabekNeural"],
		"Bulgarian": ["bg-BG-KalinaNeural", "bg-BG-BorislavNeural"],
		"Bangla": ["bn-BD-NabanitaNeural", "bn-BD-PradeepNeural", "bn-IN-TanishaaNeural", "bn-IN-BashkarNeural"],
		"Bosnian": ["bs-BA-VesnaNeural", "bs-BA-GoranNeural"],
		"Catalan": ["ca-ES-JoanaNeural", "ca-ES-EnricNeural", "ca-ES-AlbaNeural"],
		"Czech": ["cs-CZ-VlastaNeural", "cs-CZ-AntoninNeural"],
		"Welsh": ["cy-GB-NiaNeural", "cy-GB-AledNeural"],
		"Danish": ["da-DK-ChristelNeural", "da-DK-JeppeNeural"],
		"German": ["de-AT-IngridNeural", "de-AT-JonasNeural", "de-CH-LeniNeural", "de-CH-JanNeural", "de-DE-KatjaNeural", "de-DE-ConradNeural", "de-DE-AmalaNeural", "de-DE-BerndNeural", "de-DE-ChristophNeural", "de-DE-ElkeNeural", "de-DE-FlorianMultilingualNeural", "de-DE-GiselaNeural", "de-DE-KasperNeural", "de-DE-KillianNeural", "de-DE-KlarissaNeural", "de-DE-KlausNeural", "de-DE-LouisaNeural", "de-DE-MajaNeural", "de-DE-RalfNeural", "de-DE-SeraphinaMultilingualNeural", "de-DE-TanjaNeural"],
		"Greek": ["el-GR-AthinaNeural", "el-GR-NestorasNeural"],
		"English": ["en-AU-NatashaNeural", "en-AU-WilliamNeural", "en-AU-AnnetteNeural", "en-AU-CarlyNeural", "en-AU-DarrenNeural", "en-AU-DuncanNeural", "en-AU-ElsieNeural", "en-AU-FreyaNeural", "en-AU-JoanneNeural", "en-AU-KenNeural", "en-AU-KimNeural", "en-AU-NeilNeural", "en-AU-TimNeural", "en-AU-TinaNeural", "en-CA-ClaraNeural", "en-CA-LiamNeural", "en-GB-SoniaNeural", "en-GB-RyanNeural", "en-GB-LibbyNeural", "en-GB-AbbiNeural", "en-GB-AlfieNeural", "en-GB-BellaNeural", "en-GB-ElliotNeural", "en-GB-EthanNeural", "en-GB-HollieNeural", "en-GB-MaisieNeural", "en-GB-NoahNeural", "en-GB-OliverNeural", "en-GB-OliviaNeural", "en-GB-ThomasNeural", "en-GB-MiaNeural", "en-HK-YanNeural", "en-HK-SamNeural", "en-IE-EmilyNeural", "en-IE-ConnorNeural", "en-IN-NeerjaNeural", "en-IN-PrabhatNeural", "en-KE-AsiliaNeural", "en-KE-ChilembaNeural", "en-NG-EzinneNeural", "en-NG-AbeoNeural", "en-NZ-MollyNeural", "en-NZ-MitchellNeural", "en-PH-RosaNeural", "en-PH-JamesNeural", "en-SG-LunaNeural", "en-SG-WayneNeural", "en-TZ-ImaniNeural", "en-TZ-ElimuNeural", "en-US-AvaMultilingualNeural", "en-US-AndrewMultilingualNeural", "en-US-EmmaMultilingualNeural", "en-US-BrianMultilingualNeural", "en-US-AvaNeural", "en-US-AndrewNeural", "en-US-EmmaNeural", "en-US-BrianNeural", "en-US-JennyNeural", "en-US-GuyNeural", "en-US-AriaNeural", "en-US-DavisNeural", "en-US-JaneNeural", "en-US-JasonNeural", "en-US-SaraNeural", "en-US-TonyNeural", "en-US-NancyNeural", "en-US-AmberNeural", "en-US-AnaNeural", "en-US-AshleyNeural", "en-US-BrandonNeural", "en-US-ChristopherNeural", "en-US-CoraNeural", "en-US-ElizabethNeural", "en-US-EricNeural", "en-US-JacobNeural", "en-US-JennyMultilingualNeural", "en-US-MichelleNeural", "en-US-MonicaNeural", "en-US-RogerNeural", "en-US-RyanMultilingualNeural", "en-US-SteffanNeural", "en-US-AIGenerate1Neural", "en-US-AIGenerate2Neural", "en-US-BlueNeural", "en-ZA-LeahNeural", "en-ZA-LukeNeural"],
		"Spanish": ["es-AR-ElenaNeural", "es-AR-TomasNeural", "es-BO-SofiaNeural", "es-BO-MarceloNeural", "es-CL-CatalinaNeural", "es-CL-LorenzoNeural", "es-CO-SalomeNeural", "es-CO-GonzaloNeural", "es-CR-MariaNeural", "es-CR-JuanNeural", "es-CU-BelkysNeural", "es-CU-ManuelNeural", "es-DO-RamonaNeural", "es-DO-EmilioNeural", "es-EC-AndreaNeural", "es-EC-LuisNeural", "es-ES-ElviraNeural", "es-ES-AlvaroNeural", "es-ES-AbrilNeural", "es-ES-ArnauNeural", "es-ES-DarioNeural", "es-ES-EliasNeural", "es-ES-EstrellaNeural", "es-ES-IreneNeural", "es-ES-LaiaNeural", "es-ES-LiaNeural", "es-ES-NilNeural", "es-ES-SaulNeural", "es-ES-TeoNeural", "es-ES-TrianaNeural", "es-ES-VeraNeural", "es-ES-XimenaNeural", "es-GQ-TeresaNeural", "es-GQ-JavierNeural", "es-GT-MartaNeural", "es-GT-AndresNeural", "es-HN-KarlaNeural", "es-HN-CarlosNeural", "es-MX-DaliaNeural", "es-MX-JorgeNeural", "es-MX-BeatrizNeural", "es-MX-CandelaNeural", "es-MX-CarlotaNeural", "es-MX-CecilioNeural", "es-MX-GerardoNeural", "es-MX-LarissaNeural", "es-MX-LibertoNeural", "es-MX-LucianoNeural", "es-MX-MarinaNeural", "es-MX-NuriaNeural", "es-MX-PelayoNeural", "es-MX-RenataNeural", "es-MX-YagoNeural", "es-NI-YolandaNeural", "es-NI-FedericoNeural", "es-PA-MargaritaNeural", "es-PA-RobertoNeural", "es-PE-CamilaNeural", "es-PE-AlexNeural", "es-PR-KarinaNeural", "es-PR-VictorNeural", "es-PY-TaniaNeural", "es-PY-MarioNeural", "es-SV-LorenaNeural", "es-SV-RodrigoNeural", "es-US-PalomaNeural", "es-US-AlonsoNeural", "es-UY-ValentinaNeural", "es-UY-MateoNeural", "es-VE-PaolaNeural", "es-VE-SebastianNeural"],
		"Estonian": ["et-EE-AnuNeural", "et-EE-KertNeural"],
		"Basque": ["eu-ES-AinhoaNeural", "eu-ES-AnderNeural"],
		"Persian": ["fa-IR-DilaraNeural", "fa-IR-FaridNeural"],
		"Finnish": ["fi-FI-SelmaNeural", "fi-FI-HarriNeural", "fi-FI-NooraNeural"],
		"Filipino": ["fil-PH-BlessicaNeural", "fil-PH-AngeloNeural"],
		"French": ["fr-BE-CharlineNeural", "fr-BE-GerardNeural", "fr-CA-SylvieNeural", "fr-CA-JeanNeural", "fr-CA-AntoineNeural", "fr-CA-ThierryNeural", "fr-CH-ArianeNeural", "fr-CH-FabriceNeural", "fr-FR-DeniseNeural", "fr-FR-HenriNeural", "fr-FR-AlainNeural", "fr-FR-BrigitteNeural", "fr-FR-CelesteNeural", "fr-FR-ClaudeNeural", "fr-FR-CoralieNeural", "fr-FR-EloiseNeural", "fr-FR-JacquelineNeural", "fr-FR-JeromeNeural", "fr-FR-JosephineNeural", "fr-FR-MauriceNeural", "fr-FR-RemyMultilingualNeural", "fr-FR-VivienneMultilingualNeural", "fr-FR-YvesNeural", "fr-FR-YvetteNeural"],
		"Irish": ["ga-IE-OrlaNeural", "ga-IE-ColmNeural"],
		"Galician": ["gl-ES-SabelaNeural", "gl-ES-RoiNeural"],
		"Gujarati": ["gu-IN-DhwaniNeural", "gu-IN-NiranjanNeural"],
		"Hebrew": ["he-IL-HilaNeural", "he-IL-AvriNeural"],
		"Hindi": ["hi-IN-SwaraNeural", "hi-IN-MadhurNeural"],
		"Croatian": ["hr-HR-GabrijelaNeural", "hr-HR-SreckoNeural"],
		"Hungarian": ["hu-HU-NoemiNeural", "hu-HU-TamasNeural"],
		"Armenian": ["hy-AM-AnahitNeural", "hy-AM-HaykNeural"],
		"Indonesian": ["id-ID-GadisNeural", "id-ID-ArdiNeural"],
		"Icelandic": ["is-IS-GudrunNeural", "is-IS-GunnarNeural"],
		"Italian": ["it-IT-ElsaNeural", "it-IT-IsabellaNeural", "it-IT-DiegoNeural", "it-IT-BenignoNeural", "it-IT-CalimeroNeural", "it-IT-CataldoNeural", "it-IT-FabiolaNeural", "it-IT-FiammaNeural", "it-IT-GianniNeural", "it-IT-GiuseppeNeural", "it-IT-ImeldaNeural", "it-IT-IrmaNeural", "it-IT-LisandroNeural", "it-IT-PalmiraNeural", "it-IT-PierinaNeural", "it-IT-RinaldoNeural"],
		"Japanese": ["ja-JP-NanamiNeural", "ja-JP-KeitaNeural", "ja-JP-AoiNeural", "ja-JP-DaichiNeural", "ja-JP-MayuNeural", "ja-JP-NaokiNeural", "ja-JP-ShioriNeural", "ja-JP-MasaruMultilingualNeural"],
		"jv": ["jv-ID-SitiNeural", "jv-ID-DimasNeural"],
		"Georgian": ["ka-GE-EkaNeural", "ka-GE-GiorgiNeural"],
		"Kazakh": ["kk-KZ-AigulNeural", "kk-KZ-DauletNeural"],
		"Khmer": ["km-KH-SreymomNeural", "km-KH-PisethNeural"],
		"Kannada": ["kn-IN-SapnaNeural", "kn-IN-GaganNeural"],
		"Korean": ["ko-KR-SunHiNeural", "ko-KR-InJoonNeural", "ko-KR-BongJinNeural", "ko-KR-GookMinNeural", "ko-KR-HyunsuNeural", "ko-KR-JiMinNeural", "ko-KR-SeoHyeonNeural", "ko-KR-SoonBokNeural", "ko-KR-YuJinNeural"],
		"Lao": ["lo-LA-KeomanyNeural", "lo-LA-ChanthavongNeural"],
		"Lithuanian": ["lt-LT-OnaNeural", "lt-LT-LeonasNeural"],
		"Latvian": ["lv-LV-EveritaNeural", "lv-LV-NilsNeural"],
		"Macedonian": ["mk-MK-MarijaNeural", "mk-MK-AleksandarNeural"],
		"Malayalam": ["ml-IN-SobhanaNeural", "ml-IN-MidhunNeural"],
		"mn": ["mn-MN-YesuiNeural", "mn-MN-BataaNeural"],
		"Marathi": ["mr-IN-AarohiNeural", "mr-IN-ManoharNeural"],
		"Malay": ["ms-MY-YasminNeural", "ms-MY-OsmanNeural"],
		"Maltese": ["mt-MT-GraceNeural", "mt-MT-JosephNeural"],
		"Myanmar (Burmese)": ["my-MM-NilarNeural", "my-MM-ThihaNeural"],
		"Norwegian": ["nb-NO-PernilleNeural", "nb-NO-FinnNeural", "nb-NO-IselinNeural"],
		"Nepali": ["ne-NP-HemkalaNeural", "ne-NP-SagarNeural"],
		"Dutch": ["nl-BE-DenaNeural", "nl-BE-ArnaudNeural", "nl-NL-FennaNeural", "nl-NL-MaartenNeural", "nl-NL-ColetteNeural"],
		"Polish": ["pl-PL-AgnieszkaNeural", "pl-PL-MarekNeural", "pl-PL-ZofiaNeural"],
		"Pashto": ["ps-AF-LatifaNeural", "ps-AF-GulNawazNeural"],
		"Portuguese (Brazil)": ["pt-BR-FranciscaNeural", "pt-BR-AntonioNeural", "pt-BR-BrendaNeural", "pt-BR-DonatoNeural", "pt-BR-ElzaNeural", "pt-BR-FabioNeural", "pt-BR-GiovannaNeural", "pt-BR-HumbertoNeural", "pt-BR-JulioNeural", "pt-BR-LeilaNeural", "pt-BR-LeticiaNeural", "pt-BR-ManuelaNeural", "pt-BR-NicolauNeural", "pt-BR-ThalitaNeural", "pt-BR-ValerioNeural", "pt-BR-YaraNeural", "pt-PT-RaquelNeural", "pt-PT-DuarteNeural", "pt-PT-FernandaNeural"],
		"Romanian": ["ro-RO-AlinaNeural", "ro-RO-EmilNeural"],
		"Russian": ["ru-RU-SvetlanaNeural", "ru-RU-DmitryNeural", "ru-RU-DariyaNeural"],
		"Sinhala": ["si-LK-ThiliniNeural", "si-LK-SameeraNeural"],
		"Slovak": ["sk-SK-ViktoriaNeural", "sk-SK-LukasNeural"],
		"Slovenian": ["sl-SI-PetraNeural", "sl-SI-RokNeural"],
		"Somali": ["so-SO-UbaxNeural", "so-SO-MuuseNeural"],
		"Albanian": ["sq-AL-AnilaNeural", "sq-AL-IlirNeural"],
		"sr": ["sr-Latn-RS-NicholasNeural", "sr-Latn-RS-SophieNeural", "sr-RS-SophieNeural", "sr-RS-NicholasNeural"],
		"su": ["su-ID-TutiNeural", "su-ID-JajangNeural"],
		"Swedish": ["sv-SE-SofieNeural", "sv-SE-MattiasNeural", "sv-SE-HilleviNeural"],
		"Swahili": ["sw-KE-ZuriNeural", "sw-KE-RafikiNeural", "sw-TZ-RehemaNeural", "sw-TZ-DaudiNeural"],
		"Tamil": ["ta-IN-PallaviNeural", "ta-IN-ValluvarNeural", "ta-LK-SaranyaNeural", "ta-LK-KumarNeural", "ta-MY-KaniNeural", "ta-MY-SuryaNeural", "ta-SG-VenbaNeural", "ta-SG-AnbuNeural"],
		"Telugu": ["te-IN-ShrutiNeural", "te-IN-MohanNeural"],
		"Thai": ["th-TH-PremwadeeNeural", "th-TH-NiwatNeural", "th-TH-AcharaNeural"],
		"Turkish": ["tr-TR-EmelNeural", "tr-TR-AhmetNeural"],
		"Ukrainian": ["uk-UA-PolinaNeural", "uk-UA-OstapNeural"],
		"Urdu": ["ur-IN-GulNeural", "ur-IN-SalmanNeural", "ur-PK-UzmaNeural", "ur-PK-AsadNeural"],
		"Uzbek (Latin)": ["uz-UZ-MadinaNeural", "uz-UZ-SardorNeural"],
		"Vietnamese": ["vi-VN-HoaiMyNeural", "vi-VN-NamMinhNeural"],
		"wuu": ["wuu-CN-XiaotongNeural", "wuu-CN-YunzheNeural"],
		"Cantonese (Traditional)": ["yue-CN-XiaoMinNeural", "yue-CN-YunSongNeural"],
		"zh": ["zh-CN-XiaoxiaoNeural", "zh-CN-YunxiNeural", "zh-CN-YunjianNeural", "zh-CN-XiaoyiNeural", "zh-CN-YunyangNeural", "zh-CN-XiaochenNeural", "zh-CN-XiaohanNeural", "zh-CN-XiaomengNeural", "zh-CN-XiaomoNeural", "zh-CN-XiaoqiuNeural", "zh-CN-XiaoruiNeural", "zh-CN-XiaoshuangNeural", "zh-CN-XiaoxiaoDialectsNeural", "zh-CN-XiaoxiaoMultilingualNeural", "zh-CN-XiaoyanNeural", "zh-CN-XiaoyouNeural", "zh-CN-XiaozhenNeural", "zh-CN-YunfengNeural", "zh-CN-YunhaoNeural", "zh-CN-YunxiaNeural", "zh-CN-YunyeNeural", "zh-CN-YunzeNeural", "zh-CN-XiaochenMultilingualNeural", "zh-CN-XiaorouNeural", "zh-CN-XiaoyuMultilingualNeural", "zh-CN-YunjieNeural", "zh-CN-YunyiMultilingualNeural", "zh-CN-XiaoxuanNeural", "zh-CN-guangxi-YunqiNeural", "zh-CN-henan-YundengNeural", "zh-CN-liaoning-XiaobeiNeural", "zh-CN-liaoning-YunbiaoNeural", "zh-CN-shaanxi-XiaoniNeural", "zh-CN-shandong-YunxiangNeural", "zh-CN-sichuan-YunxiNeural", "zh-HK-HiuMaanNeural", "zh-HK-WanLungNeural", "zh-HK-HiuGaaiNeural", "zh-TW-HsiaoChenNeural", "zh-TW-YunJheNeural", "zh-TW-HsiaoYuNeural"],
		"Zulu": ["zu-ZA-ThandoNeural", "zu-ZA-ThembaNeural"]
	},
	topicDefaultOption = new Option("Please select subject first", "");
    
    window.onload = function() {
      var subjectSel = document.getElementById("selsubject");
      var topicSel = document.getElementById("seltopic");
     
      for (var x in subjectObject) {
        subjectSel.options[subjectSel.options.length] = new Option(x, x);
      }
      subjectSel.onchange = function() {
        //empty Chapters- and Topics- dropdowns
        topicSel.length = 0;
        //chapterSel.length = 1; //not found :(
        
        if(this.value === "") {
          topicSel.options.add(topicDefaultOption);
        } else 
		{
          //display correct values
          for (var y in subjectObject[this.value]) {
            // topicSel.options.add(new Option(subjectObject[this.value][y], y));
			topicSel.options.add(new Option(subjectObject[this.value][y], subjectObject[this.value][y]));
          }
        }
      }
      
    }
    </script>	
	
	</xsl:template>
		
	
	<xsl:template name="sel-javascript">

	<script>

		var subjectObject = {
		  "Front-end": {
			"HTML": ["Links", "Images", "Tables", "Lists"],
			"CSS": ["Borders", "Margins", "Backgrounds", "Float"],
			"JavaScript": ["Variables", "Operators", "Functions", "Conditions"]
		  },
		  "Back-end": {
			"PHP": ["Variables", "Strings", "Arrays"],
			"SQL": ["SELECT", "UPDATE", "DELETE"]
		  }
		}
		
		window.onload = function() {
		  var subjectSel = document.getElementById("selsubject");
		  var topicSel = document.getElementById("seltopic");
		  var chapterSel = document.getElementById("selchapter");
		  
		  for (var x in subjectObject) {
			subjectSel.options[subjectSel.options.length] = new Option(x, x);
		  }
		  
		  subjectSel.onchange = function() {
			//empty Chapters- and Topics- dropdowns
			chapterSel.length = 1;
			topicSel.length = 1;
			//display correct values
			for (var y in subjectObject[this.value]) {
			  topicSel.options[topicSel.options.length] = new Option(y, y);
			}
		  }
		  
		  topicSel.onchange = function() {
			//empty Chapters dropdown
			chapterSel.length = 1;
			//display correct values
			var z = subjectObject[subjectSel.value][this.value];
			for (var i = 0; i &lt; z.length; i++) {
			  chapterSel.options[chapterSel.options.length] = new Option(z[i], z[i]);
			}
		  }
		}
	
	</script>
	</xsl:template>
	

</xsl:stylesheet>


