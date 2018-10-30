---
title: share-miniapp
date: 2018-10-20 14:22:57
tags:
  - 小程序
  - Hybrid开发
categories:
  - 前端
---

## WebView简介
> `WebView`是Android提供的一种可以插在`Activities`中的视图容器，该容器可以用来承载web页面。

``` java
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical" >

    <WebView
      android:id="@+id/webview"
      android:layout_width="fill_parent"
      android:layout_height="fill_parent"
  />
</LinearLayout>
```

加载网络web页面：
``` java
import android.app.Activity;
import android.os.Bundle;
import android.webkit.WebView;

public class WebVievActivityWithURL extends Activity {

    private WebView myWebView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_with_web_view);

        myWebView = (WebView) findViewById(R.id.webview);

        myWebView.loadUrl("https://m.facebook.com");
    }

}
```

加载本地web页面：
``` java
import android.app.Activity;
import android.os.Bundle;
import android.webkit.WebView;

public class WebViewActivityWithHTML extends Activity {

    private WebView myWebView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_with_web_view);

        myWebView = (WebView) findViewById(R.id.webview);
        myWebView.loadDataWithBaseURL("file:///android_asset/", getHTMLData(),
                "text/html", "UTF-8", "");
    }

    private String getHTMLData() {
        StringBuilder html = new StringBuilder();
        html.append("<html>");
        html.append("<head>");

        html.append("<link rel=stylesheet href='css/style.css'>");
        html.append("</head>");
        html.append("<body>");
        html.append("<div id ='main'> Loading html data in WebView</div>");
        html.append("</body>");
        html.append("</html>");

        return html.toString();
    }
}
```

处理web页面总的导航：
> 默认情况下，点击WebWiew里的web页面上的链接，会在不同的浏览器中打开该链接。可以通过`shouldOverrideUrlLoading`方法重写该行为。
``` java
import android.app.Activity;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.webkit.WebView;
import android.webkit.WebViewClient;

public class WebViewActivityWithWebClient extends Activity {

    private WebView myWebView;

    /** (non-Javadoc)
     * @see android.app.Activity#onCreate(android.os.Bundle)
     */
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_with_web_view);

        myWebView = (WebView) findViewById(R.id.webview);
        myWebView.setWebViewClient(new MyWebViewClient());

        myWebView.loadData(getHTMLData(),"text/html", "UTF-8");
    }

    /**
     * @return - Static HTML data
     */
    private String getHTMLData() {
        StringBuilder html = new StringBuilder();
        html.append("<html>");
        html.append("<head>");
        html.append("</head>");
        html.append("<body>");
        html.append("<div id ='main'> <a href ='https://m.facebook.com'> Go to Face book</a></div>");
        html.append("</body>");
        html.append("</html>");

        return html.toString();
    }

    private class MyWebViewClient extends WebViewClient {
        @Override
        public boolean shouldOverrideUrlLoading(WebView view, String url) {
           view.loadUrl(url);
           return true;
        }

        @Override
        public void onPageFinished(WebView view, String url) {
            super.onPageFinished(view, url);
          //You can add some custom functionality here
        }

        @Override
        public void onReceivedError(WebView view, int errorCode,
                String description, String failingUrl) {
            super.onReceivedError(view, errorCode, description, failingUrl);
          //You can add some custom functionality here
        }
     }

}
```

注入JS到WebView
> 在被WebView加载的web页面中调用原生方法

``` java
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

import android.app.Activity;
import android.content.res.AssetManager;
import android.os.Bundle;
import android.webkit.JavascriptInterface;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.widget.Toast;

public class WebViewActivityWithJavaScript extends Activity {
    private WebView myWebView;

    /* (non-Javadoc)
     * @see android.app.Activity#onCreate(android.os.Bundle)
     */
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_with_web_view);

        myWebView = (WebView) findViewById(R.id.webview);
        WebSettings webSettings = myWebView.getSettings();
        webSettings.setJavaScriptEnabled(true);
        myWebView.addJavascriptInterface(new MyJavaScriptInterface(this), "Android");
        myWebView.loadData(getHTMLData(),"text/html", "UTF-8");
    }

    /**
     * @return - Static HTML data
     */
    private String getHTMLData() {
        StringBuilder html = new StringBuilder();
        try {
            AssetManager assetManager = getAssets();

            InputStream input = assetManager.open("javascriptexample.html");
            BufferedReader  br = new BufferedReader(new InputStreamReader(input));
            String line;
            while ((line = br.readLine()) != null) {
                html.append(line);
            }
            br.close();
        } catch (Exception e) {
           //Handle the exception here
        }

        return html.toString();
    }

    public class MyJavaScriptInterface {
        Activity activity;

        MyJavaScriptInterface(Activity activity) {
            this.activity = activity;
        }

        @JavascriptInterface
        public void showToast(String toast) {
            Toast.makeText(activity, toast, Toast.LENGTH_SHORT).show();
        }

        @JavascriptInterface
        public void closeActivity() {
            activity.finish();
        }
    }
}
```

在web页面中调用原生方法：
``` html
<html>

<body>
<input type="button" value="Show Toast" onClick="showAndroidToast('Toast to JavaScript interface')" />
<br>
<input type="button" value="Close this Activity" onClick="closeActivity()" />
</body>
<script type="text/javascript">
    function showAndroidToast(toast) {
        Android.showToast(toast);
    }

     function closeActivity() {
        Android.closeActivity();
    }
</script>

</html>
```
