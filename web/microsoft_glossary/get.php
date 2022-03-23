<?php

function main() {
  if (isset($_GET['q'])) {
    handle_query($_GET['q']);
  } else {
    header('HTTP/1.0 400 Bad Request');
  }
}

function handle_query($phrase) {
  $base = to_percentile($phrase);
  if (strlen($base) > 50) {
    header('HTTP/1.0 400 Bad Request');
    exit();
  }
  $file = "cache/$base.css";
  $tmp = "$file.tmp";

  $xml = lookup_word($phrase);
  if (false === $xml) {
    header('HTTP/1.0 503 API error');
    exit();
  }

  $css = embed_css_data($xml);
  if (@file_put_contents($tmp, $css) === strlen($css)) {
    @rename($tmp, $file);
  } else {
    @unlink($tmp);
  }

  header('Content-Type: text/css; charset=UTF-8');
  echo $css;
}

function to_percentile($s) {
  return strtolower(str_replace("+", "%20", urlencode($s)));
}

function embed_css_data($data) {
  $data = urlencode($data);
  return "#_data:after{content:'$data'}";
}

function lookup_word($phrase) {
  $body = get_soap($phrase);
  $headers =
    array(
      'Content-Type: text/xml; charset=UTF-8',
      'SOAPAction: http://api.terminology.microsoft.com/terminology/Terminology/GetTranslations',
      'X-Forwarded-For: ' . $_SERVER['REMOTE_ADDR']
    );

  $context = stream_context_create(
      array(
        'http' =>
          array(
            'user_agent' => 'CORS.glossary.hu/0.1',
            'method' => 'POST',
            'header' => $headers,
            'content' => $body,
            'protocol_version' => 1.1,
            'timeout' => 30
          )
      )
    );

  $url = 'https://api.terminology.microsoft.com/Terminology.svc';
  return @file_get_contents($url, false, $context);
}

function get_soap($phrase) {
  $text = htmlspecialchars($phrase);
  return <<<EOF
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
    <s:Body>
    <GetTranslations xmlns="http://api.terminology.microsoft.com/terminology">
    <text>$text</text>
    <from>en-US</from>
    <to>hu-HU</to>
    <searchOperator>Contains</searchOperator>
    <sources xmlns:a="https://api.terminology.microsoft.com/terminology" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
    <a:TranslationSource>Terms</a:TranslationSource>
    <a:TranslationSource>UiStrings</a:TranslationSource>
    </sources>
    <maxTranslations>20</maxTranslations>
    <includeDefinitions>true</includeDefinitions>
    </GetTranslations>
    </s:Body>
    </s:Envelope>
EOF;
}

main();
