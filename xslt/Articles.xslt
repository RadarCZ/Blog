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
                xmlns:x4o="http://schemas.altairis.cz/XML4web/OutputProcessor/"
                xmlns:void="http://tempuri.org/#void"
                exclude-result-prefixes="msxsl dcterms dc np9 x4w x4h x4c void">

  <xsl:include href="_Common.xslt" />

  <xsl:template match="/">
    <x4o:root>
      <xsl:for-each select="//file[not(x4w:alternateUrl) and dcterms:dateAccepted]">
        <xsl:sort select="dcterms:dateAccepted"/>
        <x4o:document href="{@path}.html">
          <html>
            <head>
              <xsl:call-template name="PopulateHeader">
                <xsl:with-param name="Title" select="dcterms:title" />
                <xsl:with-param name="Description" select="dcterms:abstract" />
                <xsl:with-param name="CanonicalUrl" select="@path" />
                <xsl:with-param name="Image" select="x4w:coverUrl" />
              </xsl:call-template>
              <meta name="robots" content="index, follow" />
              <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.13.1/styles/default.min.css" integrity="sha256-Zd1icfZ72UBmsId/mUcagrmN7IN5Qkrvh75ICHIQVTk=" crossorigin="anonymous" />
            </head>
            <body>
            <xsl:if test="x4w:coverUrl">
              <xsl:attribute name="class">hascover</xsl:attribute>
              <xsl:attribute name="style">
                <xsl:value-of select="concat('background-image: url(', x4w:coverUrl, ')')" />
              </xsl:attribute>
            </xsl:if>
              <xsl:call-template name="SiteHeader" />
              <main>
                <h1>
                  <xsl:value-of select="dcterms:title"/>
                </h1>
                <aside class="article-info">
                  <xsl:if test="x4w:category">
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
                  <xsl:if test="x4w:serial">
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
                  <div>
                    <a href="https://www.rider.cz/">Michal Altair Valášek&#160;</a>
                    <i class="fal fa-user">&#8203;</i>
                  </div>
                  <xsl:if test="dcterms:dateAccepted">
                    <div>
                      <time datetime="{dcterms:dateAccepted}" title="Datum vydání">
                        <xsl:value-of select="concat(x4h:FormatDateTime(dcterms:dateAccepted, 'd. MMMM yyyy', 'cs-CZ'), '&#160;')"/>
                        <i class="fal fa-calendar-alt">&#8203;</i>
                      </time>
                    </div>
                  </xsl:if>
                  <xsl:if test="x4w:coverCredits">
                    <div>
                      <xsl:value-of select="concat(x4w:coverCredits, '&#160;')" />
                      <i class="fal fa-camera">&#8203;</i>
                    </div>
                  </xsl:if>
                </aside>
                <section class="article-text" x4o:unescape="true">
                  <xsl:value-of select="x4h:GetItemHtml(@path)" />
                </section>
                <section class="issues">
                  <xsl:variable name="GitHubIssueUrl" select="concat('https://github.com/ridercz/Blog/issues/new?title=', x4h:UrlEncode(dcterms:title), '&amp;body=https://www.altair.blog', @path)" />
                  <xsl:variable name="GitHubEditUrl" select="concat('https://github.com/ridercz/Blog/edit/master/source', @path, '.md')" />
                  <xsl:variable name="GitHubHistoryUrl" select="concat('https://github.com/ridercz/Blog/commits/master/source', @path, '.md')" />
                  <header><i class="fab fa-github">&#8203;</i> Je v článku něco špatně? Chcete něco doplnit?</header>
                  <p>Komentáře zde nenajdete, ale pokud je v článku chyba nebo k němu chcete něco věcného doplnit, můžete na GitHubu <a href="{$GitHubIssueUrl}">otevřít nový issue</a> nebo <a href="{$GitHubEditUrl}">navrhnout změnu v textu</a> a poslat mi pull request.</p>
                  <p>Tamtéž také najdete <a href="{$GitHubHistoryUrl}">historii všech verzí článku</a>, pokud v něm byly provedeny nějaké změny či úpravy.</p>
                </section>
                <section class="sharing">
                  <span>Pošli to dál:</span>
                  <ul>
                    <li>
                      <a href="https://twitter.com/intent/tweet?text=https://www.altair.blog{@path}">
                        <i class="fab fa-twitter">&#8203;</i>
                      </a>
                    </li>
                    <li>
                      <a href="https://www.facebook.com/sharer.php?u=https://www.altair.blog{@path}">
                        <i class="fab fa-facebook-f">&#8203;</i>
                      </a>
                    </li>
                  </ul>
                </section>
              </main>
              <xsl:call-template name="SiteFooter" />
              <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.15.6/highlight.min.js" integrity="sha256-aYTdUrn6Ow1DDgh5JTc3aDGnnju48y/1c8s1dgkYPQ8=" crossorigin="anonymous">//</script>
              <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.15.6/languages/cs.min.js" integrity="sha256-FA/nNCvKfGdhdbNDRy0q50kSiee+lwHIHXpu0PTD3E0=" crossorigin="anonymous">//</script>
              <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.15.6/languages/dos.min.js" integrity="sha256-2rzI2inyZTuqpt3ZQtgN0ezM8PgkMQLlVCaHshqVLe4=" crossorigin="anonymous">//</script>
              <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.15.6/languages/markdown.min.js" integrity="sha256-rKw1H9B1GnccvcVdRBfRB6EZt3jaXLLbeEWSSEKmtgg=" crossorigin="anonymous">//</script>
              <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.15.6/languages/openscad.min.js" integrity="sha256-Y9GkiAmfiOzodbzy8YHB98RiHtWi5AtEgzxr9k0S5jg=" crossorigin="anonymous">//</script>
              <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.15.6/languages/powershell.min.js" integrity="sha256-YKxCyo85JjNZ2Dwsj9CUsCPcUemLxwMnUJGAn2PXJU8=" crossorigin="anonymous">//</script>
              <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.15.6/languages/scss.min.js" integrity="sha256-eek2X9CXZFSN3jZUYGcxdvpGUbEjjtXobLOI8/qxZqk=" crossorigin="anonymous">//</script>
              <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.15.6/languages/xml.min.js" integrity="sha256-LOa0DHufGN2pVUzWMDfCHhttYdt0S7KcTB98p7Rv2k4=" crossorigin="anonymous">//</script>
              <script type="text/javascript">
                  hljs.initHighlightingOnLoad();
              </script>
            </body>
          </html>
        </x4o:document>
      </xsl:for-each>
    </x4o:root>
  </xsl:template>

</xsl:stylesheet>
