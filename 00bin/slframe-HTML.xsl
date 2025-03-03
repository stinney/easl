<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	       xmlns="http://www.w3.org/1999/xhtml">
  <xsl:param name="mode" select="'full'"/> <!-- or nc for non-contrastive only -->
  <xsl:template match="/">
    <xsl:variable name="title-sub">
      <xsl:if test="$mode='nc'">
	<xsl:text> NC</xsl:text>
      </xsl:if>
    </xsl:variable>
    <html>
      <head>
	<meta charset="utf-8"/>
	<title><xsl:value-of select="@n"/><xsl:text>EASL</xsl:text><xsl:value-of select="$title-sub"/></title>
	<link media="screen,projection" href="/easl/css/projcss.css" type="text/css" rel="stylesheet"/>
      </head>
      <body>
	<table class="sltab borders">
	  <thead>
	    <tr>
	      <th class="lname" colspan="2">Entry</th>
	      <th class="names">Names</th>
	      <th class="glyph">Glyph</th>
	      <th class="image">Row</th>
	    </tr>
	  </thead>
	  <xsl:choose>
	    <xsl:when test="$mode='full'">
	      <xsl:apply-templates select="sl/sign"/>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:apply-templates select="sl/sign[s/f]"/>
	    </xsl:otherwise>
	  </xsl:choose>
	</table>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="sign">
    <tbody>
      <xsl:for-each select="s">
	<tr>
	  <xsl:if test="count(preceding-sibling::*)=0">
	    <th class="lname" rowspan="{count(../*)}">
	      <xsl:value-of select="../@n"/>
	    </th>
	  </xsl:if>
	  <xsl:choose>
	    <xsl:when test="count(../*) > 1">
	      <th class="lname"><xsl:value-of select="@xml:id"/></th>
	    </xsl:when>
	    <xsl:otherwise>
	      <td/>
	    </xsl:otherwise>
	  </xsl:choose>
	  <td>
	    <a href="/pcsl/{../@oid}" target="_blank">
	      <div class="names">
		<div class="sname"><xsl:value-of select="@sn"/></div>
		<div class="uname"><xsl:value-of select="@u"/></div>
		<xsl:if test="f">
		  <div class="rglyf"><span class="ofs-pc ofs-200"><xsl:value-of select="@c"/></span></div>
		</xsl:if>
		<div class="notes"><p><xsl:value-of select="n"/></p></div>
	      </div>
	    </a>
	  </td>
	  <td class="ofs-pc ofs-200">
	    <div>
	      <xsl:if test="not(f)">
		<div>
		  <span class="{@class}">
		    <xsl:value-of select="@c"/>
		  </span>
		</div>
	      </xsl:if>
	      <xsl:for-each select="f">
		<div>
		  <span class="{@class}"><xsl:value-of select="@c"/></span>
		</div>
	      </xsl:for-each>
	    </div>
	  </td>
	  
	  <xsl:if test="count(preceding-sibling::*)=0">
	    <td rowspan="{count(../*)}">
	      <xsl:choose>
		<xsl:when test="starts-with(../@row,'/')">
		  <img class="lrow" src="{../@row}"/>
		</xsl:when>
		<xsl:otherwise>
		  <img class="lrow" width="600px" src="/osl/{../@row}"/>
		</xsl:otherwise>
	      </xsl:choose>
	    </td>
	  </xsl:if>
	</tr>
      </xsl:for-each>
    </tbody>
  </xsl:template>

  <xsl:template name="chr">
    <xsl:param name="c"/>
    <xsl:text disable-output-escaping="yes">&amp;#</xsl:text>
    <xsl:value-of select="$c"/>
    <xsl:text>;</xsl:text>
  </xsl:template>
  
</xsl:transform>
