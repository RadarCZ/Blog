﻿<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:dcterms="http://purl.org/dc/terms/"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:np9="http://schemas.altairis.cz/Nemesis/Publishing/9/"
                xmlns:x4w="http://schemas.altairis.cz/XML4web/PageMetadata/"
                xmlns:x4h="http://schemas.altairis.cz/XML4web/XsltHelper/"
                xmlns:x4c="http://schemas.altairis.cz/XML4web/Configuration/"
                xmlns:void="http://tempuri.org/#void"
                exclude-result-prefixes="msxsl dcterms dc np9 x4w x4h x4c void">

  <!-- Setup output -->
  <xsl:output method="xml" indent="yes" encoding="utf-8" omit-xml-declaration="yes" />

  <!-- Key indices -->
  <xsl:key name="serials" match="//x4w:serial" use="." />
  <xsl:key name="categories" match="//x4w:category" use="." />

  <!-- Common header  -->
  <xsl:template name="SiteHeader">
    <header>
      <div>
        <a href="/">
          <img src="/content/images/logo_onblack.svg" alt="altair.blog" style="height:100px;" />
        </a>
      </div>
    </header>
    <nav>
      <ul>
        <li>
          <a href="https://www.rider.cz/">Michal Altair Valášek</a>
        </li>
        <xsl:call-template name="ListCategories">
          <xsl:with-param name="EmitUl" select="0"/>
        </xsl:call-template>
      </ul>
    </nav>
  </xsl:template>

  <!-- Common footer -->
  <xsl:template name="SiteFooter">
    <footer>
      <ul class="logos">
        <li>
          <img src="/content/images/logo_onwhite.svg" alt="altair.blog" style="height:38px;" />
        </li>
      </ul>
      <ul class="text">
        <li>
          <a href="/feed.rss">
            RSS feed <i class="fal fa-rss-square">&#8197;</i>
          </a>
        </li>
        <li>
          Powered by <a href="https://www.xml4web.com/">XML4web</a> on <a href="https://www.github.com/">GitHub Pages</a>
        </li>
        <li>
          Copyright &#0169; <a href="https://www.rider.cz/">Michal Altair Valášek</a>, 2003-2018
        </li>

      </ul>
    </footer>
  </xsl:template>

  <!-- Document header -->
  <xsl:template name="PopulateHeader">
    <xsl:param name="Title" />
    <xsl:param name="Description" />

    <meta charset="utf-8"/>
    <xsl:if test="$Title != ''">
      <title>
        <xsl:value-of select="$Title" />
      </title>
    </xsl:if>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="Content-Language" content="cs-CZ" />
    <xsl:if test="$Description != ''">
      <meta name="Description" content="{$Description}"/>
    </xsl:if>
    <link rel="stylesheet" type="text/css" href="/content/styles.min.css?sha={x4h:ComputeHash('/content/styles.min.css')}" />
    <link rel="stylesheet" type="text/css" href="/content/fa-5.1.0/css/all.css" />
    <link rel="alternate" type="application/rss+xml" href="/feed.rss" title="RSS Feed" />
  </xsl:template>

  <!-- Link to article with detail -->
  <xsl:template name="ArticleLink">
    <xsl:param name="ShowCategories" select="1" />
    <xsl:param name="ShowSerials" select="1" />

    <article>
      <xsl:if test="x4w:pictureUrl">
        <xsl:attribute name="class">haspicture</xsl:attribute>
        <aside>
          <a>
            <xsl:attribute name="href">
              <xsl:choose>
                <xsl:when test="x4w:alternateUrl">
                  <xsl:value-of select="x4w:alternateUrl"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="@path"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <img src="{x4w:pictureUrl}" width="{x4w:pictureWidth}" height="{x4w:pictureHeight}" alt="" />
          </a>
        </aside>
      </xsl:if>
      <header>
        <a>
          <xsl:attribute name="href">
            <xsl:choose>
              <xsl:when test="x4w:alternateUrl">
                <xsl:value-of select="x4w:alternateUrl"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="@path"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:value-of select="dcterms:title" />
        </a>
      </header>
      <div>
        <xsl:value-of select="dcterms:abstract" />
      </div>
      <footer>
        <time datetime="{dcterms:dateAccepted}" title="Datum vydání">
          <i class="fal fa-calendar-alt">&#8197;</i>
          <xsl:value-of select="x4h:FormatDateTime(dcterms:dateAccepted, 'D', 'cs-CZ') "/>
        </time>
        <xsl:if test="$ShowCategories = 1 and x4w:category">
          <ul class="categories">
            <xsl:for-each select="x4w:category">
              <li>
                <a href="/categories/{x4h:UrlKey(.)}" title="Rubrika">
                  <i class="fal fa-tag">&#8197;</i>
                  <xsl:value-of select="."/>
                </a>
              </li>
            </xsl:for-each>
          </ul>
        </xsl:if>
        <xsl:if test="$ShowSerials= 1 and x4w:serial">
          <ul class="serials">
            <xsl:for-each select="x4w:serial">
              <li>
                <a href="/serials/{x4h:UrlKey(.)}" title="Seriál">
                  <i class="fal fa-list-alt">&#8197;</i>
                  <xsl:value-of select="."/>
                </a>
              </li>
            </xsl:for-each>
          </ul>
        </xsl:if>
      </footer>
    </article>
  </xsl:template>

  <!-- Pager interface -->
  <xsl:template name="Pager">
    <xsl:param name="PageNumber" />
    <xsl:param name="PageCount" />

    <!-- Previous page links -->
    <xsl:if test="$PageNumber &gt; 1">
      <span class="prev">
        <xsl:choose>
          <xsl:when test="$PageNumber = 1">
            <!-- Do not display prev on first page-->
          </xsl:when>
          <xsl:when test="$PageNumber = 2">
            <a href="./" rel="first">Novější</a>
          </xsl:when>
          <xsl:otherwise>
            <a href="./" rel="first">Nejnovější</a>
            <a href="{concat('./', $PageNumber - 1)}" rel="prev">Novější</a>
          </xsl:otherwise>
        </xsl:choose>
      </span>
    </xsl:if>

    <!-- Next page links -->
    <xsl:if test="$PageNumber &lt; $PageCount">
      <span class="next">
        <xsl:choose>
          <xsl:when test="$PageNumber = $PageCount">
            <!-- Do not display next on last page-->
          </xsl:when>
          <xsl:when test="$PageNumber = $PageCount - 1">
            <a href="{concat('./', $PageCount)}" rel="last">Starší</a>
          </xsl:when>
          <xsl:otherwise>
            <a href="{concat('./', $PageNumber + 1)}" rel="next">Starší</a>
            <a href="{concat('./', $PageCount)}" rel="last">Nejstarší</a>
          </xsl:otherwise>
        </xsl:choose>
      </span>
    </xsl:if>

    <span class="info">
      <xsl:value-of select="concat($PageNumber, ' / ', $PageCount)"/>
    </span>

  </xsl:template>

  <!-- List of serials -->
  <xsl:template name="ListSerials">
    <xsl:param name="UlClass" />
    <xsl:param name="EmitUl" select="1" />

    <xsl:choose>
      <xsl:when test="$EmitUl = 1">
        <ul>
          <xsl:call-template name="ListSerials">
            <xsl:with-param name="UlClass" select="$UlClass"/>
            <xsl:with-param name="EmitUl" select="0"/>
          </xsl:call-template>
        </ul>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="$UlClass">
          <xsl:attribute name="class">
            <xsl:value-of select="$UlClass" />
          </xsl:attribute>
        </xsl:if>
        <xsl:for-each select="//x4w:serial[generate-id() = generate-id(key('serials', .))]">
          <li>
            <a href="/serials/{x4h:UrlKey(.)}">
              <xsl:value-of select="."/>
            </a>
          </li>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- List of categories -->
  <xsl:template name="ListCategories">
    <xsl:param name="UlClass" />
    <xsl:param name="EmitUl" select="1" />

    <xsl:choose>
      <xsl:when test="$EmitUl = 1">
        <ul>
          <xsl:call-template name="ListCategories">
            <xsl:with-param name="UlClass" select="$UlClass"/>
            <xsl:with-param name="EmitUl" select="0"/>
          </xsl:call-template>
        </ul>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="$UlClass">
          <xsl:attribute name="class">
            <xsl:value-of select="$UlClass" />
          </xsl:attribute>
        </xsl:if>
        <xsl:for-each select="//x4w:category[generate-id() = generate-id(key('categories', .))]">
          <li>
            <a href="/categories/{x4h:UrlKey(.)}">
              <xsl:value-of select="."/>
            </a>
          </li>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
